# CLAUDE.md

@AGENTS.md

<!--
AGENTS.md is the single source of truth for agent instructions in this repo.
This file only imports it so Claude Code picks it up. Put Claude-specific
notes below this line (keep it short); put everything else in AGENTS.md.
-->

## Claude Code specifics

- Skills live in `.claude/skills/` (`/spec`, `/verify`, `/review`, `/handoff`).
  GitHub Copilot reads the same folder, so keep skills tool-neutral.
- Use a subagent for independent review of non-trivial diffs (`/review`).
