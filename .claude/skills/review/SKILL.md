---
name: review
description: Independent review of the current diff against its spec, using the reviewer subagent in a fresh context. Use before opening a PR or when asked to review changes.
argument-hint: "[base branch, default main]"
---

# Independent review

Base branch: $ARGUMENTS (use `main` if empty).

1. Find the relevant spec in `docs/specs/` (from the branch name, the latest
   `PROGRESS.md` entry, or commit messages). If there is none, say so.
2. Launch the `reviewer` subagent. Give it ONLY:
   - the diff command: `git diff <base>...HEAD` plus `git diff` for uncommitted work,
   - the spec path.
   Do not summarize your own reasoning or the conversation for it.
3. Show the user the reviewer's findings as returned.
4. Don't apply fixes until the user says which ones.
