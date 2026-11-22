# repo-template (Claude Code)

A GitHub template repository that makes any new repo **ready for Claude Code on
day one**. Language-agnostic: works for Node, Python, Go, Rust, or anything you
plug into `scripts/verify.sh`.

Using GitHub Copilot instead? Use
[copilot-repo-template](https://github.com/joshoohaah/copilot-repo-template).

> This README is replaced by a project README when you run `scripts/init-template.sh`.

## What's inside

| Path | Purpose | Idea from |
|------|---------|-----------|
| `CLAUDE.md` | Project instructions loaded every session: commands, repo map, boundaries, gotchas | [AGENTS.md](https://github.com/agentsmd/agents.md) |
| `scripts/verify.sh` | Single non-interactive "is it working?" command; auto-detects stack; prints only failures | [mini-SWE-agent](https://github.com/SWE-agent/mini-swe-agent), [12-factor](https://github.com/humanlayer/12-factor-agents) #9 |
| `PROGRESS.md` | Append-only handoff log so sessions resume cold | [harness engineering](https://github.com/walkinglabs/learn-harness-engineering) (continuity) |
| `.claude/settings.json` | Permissions (allow verify + git-read; deny `.env`/keys, `rm -rf`, force-push) and a **SessionStart hook** that shows Claude the latest `PROGRESS.md` entry and git state | harness engineering (continuity) |
| `.claude/skills/` | `/spec`, `/verify`, `/review`, `/handoff` | Spec Kit, harness engineering |
| `.claude/agents/reviewer.md` | Read-only **reviewer subagent**: checks a diff against its spec in a fresh context | harness engineering (independent review) |
| `.github/workflows/claude.yml` | `@claude` in an issue or PR → Claude Code works on it in GitHub Actions | 12-factor #11 (trigger from anywhere) |
| `.github/workflows/ci.yml` | Runs the same `verify.sh` | — |
| `docs/specs/`, `docs/decisions/` | Spec-before-code template; ADRs | [Spec Kit](https://github.com/github/spec-kit) (lite) |
| `docs/agents/PRINCIPLES.md` | The principles above, applied to this repo | all |
| `.github/` (rest) | PR template with verification checklist, `agent-task` issue form, Dependabot | — |

## Use it

```bash
gh repo create <you>/my-app --private --template <you>/repo-template --clone
cd my-app
bash scripts/init-template.sh "my-app" "One-line description of what it does"
```

Then in Claude Code: *"Fill in the `{{...}}` placeholders in CLAUDE.md from the
code, and add the right toolchain to ci.yml and claude.yml."*

**To enable `@claude` on GitHub** (optional, once per repo or org):
run `/install-github-app` in Claude Code, or add a `CLAUDE_CODE_OAUTH_TOKEN`
secret (from `claude setup-token`). Without it, `claude.yml` does nothing.

**Existing repo?** Copy `CLAUDE.md`, `PROGRESS.md`, `scripts/`, `docs/`,
`.claude/`, and the `.github/` pieces you want.

## Daily loop

```
(SessionStart hook shows PROGRESS.md) → /spec → small steps + /verify → /review → /handoff → PR
```

Details: [docs/agents/WORKFLOW.md](docs/agents/WORKFLOW.md).

## Customizing verify

`scripts/verify.sh` runs `lint` / `typecheck` / `test` / `build` npm scripts if
present, `ruff`/`mypy`/`pytest` for Python, `go vet`/`go test`, and
`cargo fmt`/`clippy`/`test`. Add anything else in `scripts/verify.local.sh`:

```bash
# scripts/verify.local.sh — sourced by verify.sh
run_step "docker compose config" docker compose config -q
```

On Windows without a bash prompt: `pwsh scripts/verify.ps1`.

## Not included (on purpose)

- **MCP servers** — add a `.mcp.json` per project when one is needed.
- **Agent evals ([Harbor](https://github.com/harbor-framework/harbor))** — add
  when a repo *is* an agent or you're tuning prompts/config and need evidence.
