#!/usr/bin/env bash
# init-template.sh — run ONCE after creating a repo from this template.
#
#   bash scripts/init-template.sh "<project name>" "<one-line description>"
#
# Fills the basic {{PLACEHOLDERS}}, swaps the template README for a project
# README, and deletes itself. Remaining {{...}} placeholders in AGENTS.md are
# printed at the end so you (or your agent) can fill them in.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ $# -lt 2 ]]; then
  echo "usage: bash scripts/init-template.sh \"<project name>\" \"<one-line description>\"" >&2
  exit 2
fi

NAME="$1"
DESC="$2"
TODAY="$(date +%Y-%m-%d)"

# Escape for use as a sed replacement string.
esc() { printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'; }

fill() {
  local f="$1"
  sed -i.bak \
    -e "s|{{PROJECT_NAME}}|$(esc "$NAME")|g" \
    -e "s|{{ONE_LINE_DESCRIPTION}}|$(esc "$DESC")|g" \
    -e "s|{{DATE}}|$TODAY|g" \
    "$f"
  rm -f "$f.bak"
}

for f in AGENTS.md PROGRESS.md .github/CODEOWNERS; do
  [[ -f "$f" ]] && fill "$f"
done

# Replace the template's README with a project README.
cat > README.md <<EOF
# $NAME

$DESC

## Quick start

\`\`\`bash
# install
{{install command}}

# verify (lint, types, tests)
bash scripts/verify.sh
\`\`\`

## Working on this repo

- Agents and humans: start with [AGENTS.md](AGENTS.md) and [PROGRESS.md](PROGRESS.md).
- Non-trivial changes start with a spec in [docs/specs/](docs/specs/).
- Principles: [docs/agents/PRINCIPLES.md](docs/agents/PRINCIPLES.md).
EOF

rm -f "$0"

echo "Initialized '$NAME'."
echo
echo "Placeholders still to fill in:"
grep -rn --include='*.md' --include='CODEOWNERS' '{{' . | grep -v '^./docs/specs/TEMPLATE.md' || echo "  (none)"
echo
echo "Next: fill those in (or ask your agent: 'fill in the AGENTS.md placeholders from the code'),"
echo "then run: bash scripts/verify.sh"
