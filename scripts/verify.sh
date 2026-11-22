#!/usr/bin/env bash
# verify.sh — the single "is it working?" command for humans, agents, and CI.
#
# - Non-interactive, safe to run from a fresh shell, from any directory.
# - Auto-detects the stack (Node, Python, Go, Rust) and runs what exists.
# - Prints one line per passing step and only the tail of failing output,
#   so the result fits in an agent's context window.
# - Exit code 0 = everything passed.
#
# Customize: add project-specific checks in scripts/verify.local.sh
# (sourced at the end; call `run_step "<name>" <command...>`).
#
# Env: VERIFY_TAIL=<n>  lines of output to show per failure (default 60)

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

TAIL_LINES="${VERIFY_TAIL:-60}"
LOG_DIR="$(mktemp -d)"
trap 'rm -rf "$LOG_DIR"' EXIT

failures=0
ran=0

have() { command -v "$1" >/dev/null 2>&1; }

run_step() {
  local name="$1"; shift
  local log="$LOG_DIR/step-$ran.log"
  ran=$((ran + 1))
  local start=$SECONDS
  if "$@" >"$log" 2>&1; then
    printf 'PASS  %-28s (%ss)\n' "$name" "$((SECONDS - start))"
  else
    local code=$?
    failures=$((failures + 1))
    printf 'FAIL  %-28s (exit %s) — %s\n' "$name" "$code" "$*"
    echo "----- last $TAIL_LINES lines -----"
    tail -n "$TAIL_LINES" "$log"
    echo "----------------------------------"
  fi
}

skip() { printf 'SKIP  %-28s %s\n' "$1" "$2"; }

# ---------- generic checks (always) ----------
check_conflict_markers() {
  ! git grep -nE '^(<<<<<<<|>>>>>>>) ' -- . ':!*.md' 2>/dev/null
}
check_shell_syntax() {
  local f rc=0
  while IFS= read -r f; do bash -n "$f" || rc=1; done < <(git ls-files '*.sh' 2>/dev/null)
  return $rc
}
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  run_step "no conflict markers" check_conflict_markers
  run_step "shell script syntax" check_shell_syntax
  if have gitleaks; then
    run_step "secret scan (gitleaks)" gitleaks detect --no-banner --redact --source .
  fi
fi

# ---------- Node / TypeScript ----------
if [[ -f package.json ]]; then
  pm=npm
  [[ -f pnpm-lock.yaml ]] && pm=pnpm
  [[ -f yarn.lock ]] && pm=yarn
  [[ -f bun.lockb || -f bun.lock ]] && pm=bun
  if [[ ! -d node_modules ]]; then
    skip "node" "node_modules missing — run '$pm install' first"
    failures=$((failures + 1))
  else
    has_script() { node -e "process.exit(require('./package.json').scripts?.['$1'] ? 0 : 1)" 2>/dev/null; }
    for s in lint typecheck test build; do
      if has_script "$s"; then
        if [[ "$s" == test ]]; then
          CI=1 run_step "$pm run $s" "$pm" run "$s"
        else
          run_step "$pm run $s" "$pm" run "$s"
        fi
      fi
    done
  fi
fi

# ---------- Python ----------
if [[ -f pyproject.toml || -f requirements.txt || -f setup.py ]]; then
  py=""
  if [[ -f uv.lock ]] && have uv; then py="uv run"
  elif [[ -x .venv/bin/python ]]; then py=".venv/bin/python -m"
  elif [[ -x .venv/Scripts/python.exe ]]; then py=".venv/Scripts/python.exe -m"
  elif have python3; then py="python3 -m"
  elif have python; then py="python -m"
  fi
  if [[ -z "$py" ]]; then
    skip "python" "no python interpreter found"
  else
    # shellcheck disable=SC2086
    if $py ruff --version >/dev/null 2>&1; then
      run_step "ruff check" $py ruff check .
      run_step "ruff format --check" $py ruff format --check .
    fi
    # shellcheck disable=SC2086
    if $py mypy --version >/dev/null 2>&1 && grep -q '\[tool.mypy\]' pyproject.toml 2>/dev/null; then
      run_step "mypy" $py mypy .
    fi
    # shellcheck disable=SC2086
    if $py pytest --version >/dev/null 2>&1; then
      run_step "pytest" $py pytest -q -x --no-header
    fi
  fi
fi

# ---------- Go ----------
if [[ -f go.mod ]] && have go; then
  run_step "go vet" go vet ./...
  run_step "go test" go test ./...
fi

# ---------- Rust ----------
if [[ -f Cargo.toml ]] && have cargo; then
  run_step "cargo fmt --check" cargo fmt --all -- --check
  run_step "cargo clippy" cargo clippy --all-targets -- -D warnings
  run_step "cargo test" cargo test --quiet
fi

# ---------- project-specific ----------
if [[ -f scripts/verify.local.sh ]]; then
  # shellcheck source=/dev/null
  source scripts/verify.local.sh
fi

echo
if (( failures > 0 )); then
  echo "verify: $failures step(s) FAILED"
  exit 1
fi
echo "verify: all $ran step(s) passed"
