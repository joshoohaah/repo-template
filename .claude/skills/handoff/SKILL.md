---
name: handoff
description: Write a PROGRESS.md entry so the next session can resume cold. Use at the end of a work session or when asked to hand off, wrap up, or save progress.
---

# Handoff

The next session will NOT see this conversation. Leave it what it needs.

1. Run `bash scripts/verify.sh` and `git status --short` to get the real state.
2. Add a new entry at the top of the log in `PROGRESS.md` (below the template comment):

   ## <today YYYY-MM-DD> — <short title>
   - **Goal:** <what this session set out to do; link spec>
   - **Done:** <changes, files, PRs>
   - **Verified:** <verify.sh result; manual checks>
   - **Next:** <the very next concrete step>
   - **Traps:** <surprises that cost time>

3. If a trap will bite again, also add it to `CLAUDE.md › Gotchas`.
4. If a spec's status changed, update it.
5. Keep the entry under ~15 lines. Facts only.
