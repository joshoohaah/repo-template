# AGENTS.md

> The README for coding agents (Claude Code, Codex, Copilot, Cursor, Aider, ...).
> Keep this file short and true. If an instruction here is wrong, fix it in the
> same PR that discovers it. Details live in `docs/`, not here.
> After editing, run `bash scripts/sync-agent-config.sh` (regenerates
> `.github/copilot-instructions.md`; `verify.sh` fails if you forget).

## Project

- **Name:** {{PROJECT_NAME}}
- **What it does:** {{ONE_LINE_DESCRIPTION}}
- **Stack:** {{e.g. TypeScript / Node 22, Python 3.12, Go 1.23}}
- **Entry points:** {{e.g. `src/index.ts`, `app/main.py`}}

## Commands (the only ones you need)

All commands are non-interactive and safe to run from a fresh shell.

| Purpose | Command |
|---------|---------|
| Set up / install deps | `{{e.g. npm ci  |  uv sync}}` |
| **Verify everything** (lint, types, tests) | `bash scripts/verify.sh` |
| Run one test | `{{e.g. npx vitest run path/to/file.test.ts}}` |
| Run the app locally | `{{e.g. npm run dev}}` |

`scripts/verify.sh` is the definition of done. It must pass before you say a
task is finished. It prints only failures, so read all of its output.

## Repo map

```
{{fill in — keep to ~10 lines}}
src/            application code
tests/          tests mirror src/ layout
docs/specs/     one spec per feature (write before coding non-trivial work)
docs/decisions/ ADRs — why things are the way they are
scripts/        verify.sh and other automation
PROGRESS.md     running handoff log between sessions
```

## How to work here

1. **Read `PROGRESS.md` first.** It says what was done last and what's next.
2. **Non-trivial change? Write or update a spec** in `docs/specs/` (copy
   `docs/specs/TEMPLATE.md`). Get it agreed before writing code.
3. **Small steps.** Make one change, run `bash scripts/verify.sh`, repeat.
   Do not batch many unverified edits.
4. **Tests prove behavior.** New behavior gets a test; bug fixes get a
   regression test that fails before the fix.
5. **Stop and ask** (don't guess) when: requirements are ambiguous, a change
   is destructive or irreversible, or you'd need a new dependency or secret.
6. **Before ending a session, append to `PROGRESS.md`:** what changed, what's
   verified, what's left, and any traps you hit.

## Conventions

- Commits: Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).
- Branches: `feat/<slug>`, `fix/<slug>`. Never commit directly to `main`.
- Prefer editing existing files over creating new ones; prefer small files
  (< 400 lines) and small functions (< 50 lines).
- Immutable data and explicit error handling; no silent `catch {}`.
- {{project-specific conventions: naming, error types, logging, etc.}}

## Boundaries

- **Never** commit secrets, `.env` files, or credentials. Use `.env.example`.
- **Never** run destructive commands (`rm -rf`, `git push --force`, DB drops,
  `terraform apply`) without explicit human approval.
- **Never** disable or delete a failing test to make verify pass.
- Do not edit generated files: {{list, e.g. `dist/`, `*.gen.ts`}}.

## Gotchas

<!-- Add things that bit an agent (or a human) so it doesn't happen twice. -->
- {{e.g. "Tests need `TZ=UTC` or date tests fail."}}

## Skills

Reusable workflows in `.claude/skills/` (read by both Claude Code and Copilot):
`spec`, `verify`, `review`, `handoff`. Use them when the task matches.

## More context (read on demand, not up front)

- `docs/agents/PRINCIPLES.md` — the engineering principles this repo follows
- `docs/agents/WORKFLOW.md` — spec → implement → verify → review → handoff loop
- `docs/decisions/` — architecture decision records
