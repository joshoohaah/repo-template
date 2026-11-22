# Engineering principles for agent-assisted work

Distilled from four sources and applied to *this repo*. The point is not the
theory; each principle maps to something concrete in the template.

| Source | What we took |
|--------|--------------|
| [AGENTS.md](https://github.com/agentsmd/agents.md) | One predictable, short instructions file — here that is `CLAUDE.md`, which Claude Code loads every session |
| [12-Factor Agents](https://github.com/humanlayer/12-factor-agents) | Own the context, compact errors, small focused tasks, humans in the loop, stateless steps |
| [mini-SWE-agent](https://github.com/SWE-agent/mini-swe-agent) | Everything is a plain shell command; linear history; no hidden state |
| [Learn Harness Engineering](https://github.com/walkinglabs/learn-harness-engineering) | Agent-readable workspace, cross-session continuity, runtime feedback, independent review, loops |
| [Spec Kit](https://github.com/github/spec-kit) (lite) | Spec before code for non-trivial work |

---

## 1. The repo is the harness (agent-readable workspace)

An agent only knows what it can read or run. So:

- **`CLAUDE.md` is a map, not a manual.** ~100 lines: commands, repo map,
  boundaries, gotchas. Deep detail lives in `docs/` and is pulled on demand.
  *(12-factor #3 "own your context window": don't flood it up front.)*
- **Durable knowledge goes in files, not chat.** Decisions → `docs/decisions/`,
  feature intent → `docs/specs/`, session state → `PROGRESS.md`. A fact that
  only exists in a chat transcript is lost.
- **Instructions must be true.** A stale command in `CLAUDE.md` is worse than
  none. Fix it in the PR that notices.

## 2. Everything is a shell command (mini-SWE-agent)

mini-SWE-agent shows you need nothing but bash and a linear message history.
Design the repo so that's enough:

- Every workflow step is one **non-interactive** command that works from a
  fresh shell (no prompts, no reliance on `cd` state or activated venvs).
- One entrypoint answers "is it working?": `bash scripts/verify.sh`.
- Commands are deterministic and idempotent where possible; re-running is safe.
- Prefer `scripts/*.sh` over tribal knowledge or IDE-only tasks.

## 3. Fast, compact feedback (12-factor #9, harness "runtime feedback")

Agents improve by reading errors. Make errors cheap to read:

- `verify.sh` prints **only failures**, truncated to the last lines that matter.
  Passing steps print one line.
- Prefer fast checks first (lint → types → unit tests → slower tests).
- Error messages in code should say what was expected, what was found, and
  where — an agent (or you at 2am) will act on them literally.

## 4. Small, focused units of work (12-factor #10)

Reliability drops as tasks grow. So:

- One spec ≈ one PR ≈ a few hours of work. Split anything bigger.
- One change → verify → next change. Never stack many unverified edits.
- Keep files and functions small so they fit in context whole.

## 5. Spec before code (Spec Kit lite)

"Build X" leaves too much to interpretation. For anything non-trivial:

1. Copy `docs/specs/TEMPLATE.md` → `docs/specs/NNN-slug.md`.
2. Fill in *problem, acceptance criteria, non-goals, plan*.
3. Agree on it (human review), *then* implement against the acceptance
   criteria, which become tests.

Skip this for typo fixes and one-file changes. Don't skip it for anything you
couldn't fully describe in a commit message.

## 6. Humans are a tool call (12-factor #7)

The agent should *ask*, not guess, when:

- requirements are ambiguous or acceptance criteria are missing,
- an action is destructive/irreversible (deletes, force-push, migrations, deploys),
- a new dependency, secret, or external service is needed.

Make asking cheap: issue templates and the spec's "Open questions" section are
the async channel.

## 7. Own your control flow; stateless steps (12-factor #8, #12, #5, #6)

- Each session should be resumable from repo state alone:
  `git log` + `PROGRESS.md` + open spec = full context. No hidden memory.
- Pause/resume = end session with a `PROGRESS.md` entry, start the next by
  reading it (`/handoff` automates the first half).
- CI runs the *same* `scripts/verify.sh` the agent runs locally — one source
  of truth for "done".

## 8. Independent review (harness engineering)

The author grades its own work generously. So:

- Non-trivial diffs get a second pass from a *fresh* context (a subagent,
  another model, or a human) that sees the spec + diff, not the conversation.
  Use `/review`.
- Review against the spec's acceptance criteria, not vibes.

## 9. Close the loop

- Every PR template asks: what was verified, how.
- When an agent hits a trap, add it to `CLAUDE.md › Gotchas`.
- When a decision is made, record it in `docs/decisions/`.
- Measure before claiming "the new prompt/config is better" — see
  [Harbor](https://github.com/harbor-framework/harbor) if a repo grows an
  agent-evaluation need.
