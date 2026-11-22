---
name: verify
description: Run scripts/verify.sh (lint, types, tests) and fix failures one at a time. Use before saying any task is done, or when asked to check, test, or fix the build.
---

# Verify

Run `bash scripts/verify.sh` (on Windows without bash on PATH: `pwsh scripts/verify.ps1`).

- If it passes, say so in one line.
- If it fails: fix the FIRST failure only, re-run, and repeat. Fix the code, not
  the test or lint config, unless the test itself is wrong (explain why if so).
- If the failure is "agent config in sync", run `bash scripts/sync-agent-config.sh`.
- Stop and ask if a fix needs a new dependency, a config change that weakens a
  check, or more than ~3 attempts on the same failure.
