# CLAUDE.md

> Project instructions for Claude Code. Loaded into every session, so keep it
> short and true (~100 lines). If an instruction is wrong, fix it in the same
> PR that finds the problem. Detail lives in `docs/` and is read when needed.

## Project

- **Name:** {{PROJECT_NAME}}
- **What it does:** {{ONE_LINE_DESCRIPTION}}
- **Stack:** {{e.g. TypeScript / Node 22, Python 3.12, Go 1.23}}
- **Entry points:** {{e.g. `src/index.ts`, `app/main.py`}}

## Commands

All commands are non-interactive and safe to run from a fresh shell.

| Purpose | Command |
|---------|---------|
| Install deps | `{{e.g. npm ci  |  uv sync}}` |
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

1. **Start from `PROGRESS.md`.** A SessionStart hook shows you its latest
   entry and the git state; read the spec it points to.
2. **Non-trivial change? Spec first** with `/spec`. Get it agreed before coding.
3. **Small steps.** One change, then `bash scripts/verify.sh`, then the next.
   Don't stack unverified edits.
4. **Tests prove behavior.** New behavior gets a test; bug fixes get a
   regression test that fails before the fix.
5. **Stop and ask** (don't guess) when requirements are ambiguous, an action
   is destructive or irreversible, or you'd need a new dependency or secret.
6. **Before you finish:** `/review` for non-trivial diffs, then `/handoff`.

## Skills and subagents

| Use | When |
|-----|------|
| `/spec <feature>` | Before any change you couldn't describe in one commit message |
| `/verify` | Run verify and fix failures one at a time |
| `/review [base]` | Before a PR: the `reviewer` subagent checks the diff against the spec in a fresh context |
| `/handoff` | End of session: write the `PROGRESS.md` entry |

## Conventions

- Commits: Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).
- Branches: `feat/<slug>`, `fix/<slug>`. Never commit directly to `main`.
- Prefer editing existing files over new ones; small files (< 400 lines) and
  small functions (< 50 lines).
- Immutable data and explicit error handling; no silent `catch {}`.
- {{project-specific conventions: naming, error types, logging, etc.}}

## Boundaries

- **Never** commit secrets, `.env` files, or credentials. Use `.env.example`.
- **Never** run destructive commands (`rm -rf`, `git push --force`, DB drops,
  `terraform apply`) without explicit human approval.
- **Never** disable or delete a failing test to make verify pass.
- Do not edit generated files: {{list, e.g. `dist/`, `*.gen.ts`}}.

## Gotchas

<!-- Add things that bit Claude (or a human) so it doesn't happen twice. -->
- {{e.g. "Tests need `TZ=UTC` or date tests fail."}}

## More context (read when needed)

- `docs/agents/PRINCIPLES.md` — the engineering principles this repo follows
- `docs/agents/WORKFLOW.md` — spec → implement → verify → review → handoff
- `docs/decisions/` — architecture decision records
