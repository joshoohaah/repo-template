# Workflow: spec → implement → verify → review → handoff

```
 ┌──────── read PROGRESS.md + CLAUDE.md ─────────┐
 │                                               │
 ▼                                               │
SPEC ──► IMPLEMENT ◄──► VERIFY ──► REVIEW ──► HANDOFF
(docs/specs)  small steps   scripts/verify.sh  fresh context  PROGRESS.md
```

## 0. Start of session
- Read `PROGRESS.md` (top entry) and the spec it points to.
- Run `bash scripts/verify.sh` to confirm a green baseline. If it's red,
  fixing that is the first task.

## 1. Spec (non-trivial work only)
- `/spec <feature>` or copy `docs/specs/TEMPLATE.md` → `docs/specs/NNN-slug.md`.
- Must have testable acceptance criteria and explicit non-goals.
- Human agrees before implementation starts.

## 2. Implement
- Branch: `feat/<slug>` or `fix/<slug>`.
- Test first where practical: write the failing test from an acceptance
  criterion, then make it pass.
- One logical change at a time.

## 3. Verify
- `bash scripts/verify.sh` after each change (Windows: `pwsh scripts/verify.ps1`).
- Read *all* output. Fix the first error first.
- Don't weaken tests or lint rules to get green.

## 4. Review
- `/review` — the `reviewer` subagent checks the
  diff against the spec in a fresh context, without seeing your conversation.
- Address correctness/security findings; note the rest in the PR.

## 5. Handoff
- `/handoff` — appends a `PROGRESS.md` entry: done / verified / next / traps.
- Open a PR using the template; link the spec.
- Durable lessons → `CLAUDE.md › Gotchas` or `docs/decisions/`.

## Running agents in a loop (optional)

Once the above is solid, the same pieces support unattended loops:
issue (labelled `agent-task`) → comment `@claude` (`.github/workflows/claude.yml`) → Claude reads spec → implements → CI runs
`verify.sh` → PR → human review. The guardrails are the ones already here:
small specs, one verify command, PR review, and `PROGRESS.md` for state.
