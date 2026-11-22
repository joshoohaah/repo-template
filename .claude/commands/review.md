---
description: Independent review of the current diff by a fresh-context subagent
argument-hint: "[base branch, default main]"
---

Get an independent review of the current changes.

1. Collect the diff: `git diff ${ARGUMENTS:-main}...HEAD` plus `git diff` (uncommitted).
2. Find the relevant spec in `docs/specs/` (from the branch name, PROGRESS.md, or commits).
3. Launch a subagent that receives ONLY: the diff, the spec, and `AGENTS.md` — not this conversation.
   Ask it to report, ranked by severity:
   - correctness bugs and unmet acceptance criteria (cite the criterion),
   - security issues (secrets, injection, unsafe input handling),
   - missing tests for new behavior,
   - violations of AGENTS.md conventions/boundaries.
   Each finding: file:line, what's wrong, a concrete failure scenario.
4. Show me the findings. Don't apply fixes until I say which ones.
