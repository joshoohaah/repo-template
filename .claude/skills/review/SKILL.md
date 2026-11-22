---
name: review
description: Independent review of the current diff against its spec, from a fresh context. Use before opening a PR or when asked to review changes.
---

# Independent review

The author grades its own work generously, so the review must come from a
context that has NOT seen the implementation conversation.

1. Collect the diff: `git diff main...HEAD` plus `git diff` (uncommitted).
   Use a different base branch if the user named one (Claude Code: $ARGUMENTS).
2. Find the relevant spec in `docs/specs/` (from the branch name, `PROGRESS.md`, or commits).
3. Hand ONLY the diff, the spec, and `AGENTS.md` to a reviewer with a fresh context:
   a subagent if your agent supports them; otherwise tell the user to run this
   skill in a new chat/session.
   The reviewer reports, ranked by severity:
   - correctness bugs and unmet acceptance criteria (cite the criterion),
   - security issues (secrets, injection, unsafe input handling),
   - missing tests for new behavior,
   - violations of AGENTS.md conventions/boundaries.
   Each finding: file:line, what's wrong, a concrete failure scenario.
4. Show the findings. Don't apply fixes until the user says which ones.
