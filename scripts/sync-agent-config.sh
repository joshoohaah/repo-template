#!/usr/bin/env bash
# sync-agent-config.sh — keep every agent's instruction file generated from AGENTS.md.
#
#   bash scripts/sync-agent-config.sh          # regenerate
#   bash scripts/sync-agent-config.sh --check  # exit 1 if out of date (used by verify.sh)
#
# Who reads what:
#   AGENTS.md                         Copilot (cloud agent, CLI, VS Code), Codex, Cursor, ... — the source of truth
#   CLAUDE.md                         Claude Code — imports AGENTS.md via @AGENTS.md (hand-written, not generated)
#   .github/copilot-instructions.md   Copilot code review + older Copilot surfaces — GENERATED copy of AGENTS.md

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SRC=AGENTS.md
DEST=.github/copilot-instructions.md

render() {
  echo "<!-- GENERATED from AGENTS.md by scripts/sync-agent-config.sh — do not edit; edit AGENTS.md instead. -->"
  echo
  cat "$SRC"
}

if [[ "${1:-}" == "--check" ]]; then
  if ! diff -q <(render) "$DEST" >/dev/null 2>&1; then
    echo "$DEST is out of date with $SRC. Run: bash scripts/sync-agent-config.sh" >&2
    exit 1
  fi
  exit 0
fi

mkdir -p "$(dirname "$DEST")"
render > "$DEST"
echo "wrote $DEST"
