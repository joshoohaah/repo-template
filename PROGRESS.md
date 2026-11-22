# Progress log

Append-only handoff log so the next session (human or agent) can pick up
without re-deriving context. Newest entry at the top. Keep entries short.

<!--
Template for each entry:

## YYYY-MM-DD — <short title>
- **Goal:** what this session set out to do (link spec if any)
- **Done:** what changed (files / PRs)
- **Verified:** what `scripts/verify.sh` / manual checks showed
- **Next:** the very next concrete step
- **Traps:** anything surprising that cost time (also add to AGENTS.md › Gotchas if durable)
-->

## {{DATE}} — Repository created from template
- **Goal:** bootstrap repo.
- **Done:** ran `scripts/init-template.sh`.
- **Verified:** `bash scripts/verify.sh` passes (no stack detected yet).
- **Next:** fill in the `{{...}}` placeholders in `AGENTS.md`; add the first spec.
- **Traps:** none yet.
