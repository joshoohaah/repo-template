---
name: verify
description: Run scripts/verify.sh (lint, types, tests) and fix failures one at a time. Use before saying any task is done, or when asked to check, test, or fix the build.
---

# Verify

Run `bash scripts/verify.sh`.

- If it passes, say so in one line.
- If it fails: fix the FIRST failure only, re-run, and repeat. Fix the code, not
  the test or lint config, unless the test itself is wrong (explain why if so).
- Stop and ask if a fix needs a new dependency, a config change that weakens a
  check, or more than ~3 attempts on the same failure.
