---
name: spec
description: Draft a feature spec in docs/specs/ before writing any code. Use when asked to plan, spec, or design a non-trivial feature or change.
---

# Draft a spec

The feature to spec is whatever the user described when invoking this skill
(in Claude Code: $ARGUMENTS).

1. Read `AGENTS.md`, `docs/specs/TEMPLATE.md`, and the existing specs in `docs/specs/` (to pick the next number `NNN`).
2. Explore just enough of the code to ground the spec in reality (relevant files, existing patterns).
3. Write `docs/specs/NNN-<kebab-slug>.md` from the template, status `draft`:
   - Problem: no solution in it.
   - Acceptance criteria: testable Given/When/Then statements.
   - Non-goals: be explicit.
   - Plan: smallest sequence of steps, each ending with `bash scripts/verify.sh` green.
   - Open questions: everything you would otherwise have guessed.
4. Do NOT write implementation code. Stop and show the user the open questions.
