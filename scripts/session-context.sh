#!/usr/bin/env bash
# session-context.sh — printed into Claude's context at session start
# (SessionStart hook in .claude/settings.json). Keep the output short.

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 0

echo "## Repo state"
echo "branch: $(git branch --show-current 2>/dev/null || echo '?')"
changes="$(git status --short 2>/dev/null | head -n 15)"
echo "uncommitted changes: ${changes:+$'\n'}${changes:-none}"

if [[ -f PROGRESS.md ]]; then
  echo
  echo "## Latest PROGRESS.md entry"
  # First "## " entry outside the HTML template comment, up to the next one.
  awk '/<!--/{c=1} c{if(/-->/)c=0; next} /^## /{n++} n==1{print} n>1{exit}' PROGRESS.md
fi
exit 0
