# repo-template

A GitHub template repository that makes any new repo **agent-ready on day one**
(Claude Code, Codex, Copilot, Cursor, ...). Language-agnostic: works for Node,
Python, Go, Rust, or anything you plug into `scripts/verify.sh`.

> This README is replaced by a project README when you run `scripts/init-template.sh`.

## What's inside

| Path | Purpose | Idea from |
|------|---------|-----------|
| `AGENTS.md` | One place for agent instructions: commands, repo map, boundaries, gotchas | [AGENTS.md](https://github.com/agentsmd/agents.md) |
| `CLAUDE.md` | Imports `AGENTS.md` (`@AGENTS.md`) so Claude Code reads the same file | — |
| `scripts/verify.sh` | Single non-interactive "is it working?" command; auto-detects stack; prints only failures | [mini-SWE-agent](https://github.com/SWE-agent/mini-swe-agent), [12-factor](https://github.com/humanlayer/12-factor-agents) #9 |
| `PROGRESS.md` | Append-only handoff log so sessions resume cold | [harness engineering](https://github.com/walkinglabs/learn-harness-engineering) (continuity) |
| `docs/specs/` | Spec-before-code template with testable acceptance criteria | [Spec Kit](https://github.com/github/spec-kit) (lite) |
| `docs/decisions/` | ADRs — durable "why" | — |
| `docs/agents/PRINCIPLES.md` | The principles above, applied to this repo | all |
| `.claude/commands/` | `/spec`, `/verify`, `/review` (fresh-context subagent), `/handoff` | harness engineering (independent review) |
| `.claude/settings.json` | Allow verify/git-read; deny `.env`/keys, `rm -rf`, force-push | — |
| `.github/` | CI that runs the same `verify.sh`; PR template with verification checklist; `agent-task` issue form; Dependabot | 12-factor #11 |

## Use it

**One-time:** push this repo to GitHub and mark it as a template:

```bash
gh repo create <you>/repo-template --private --source . --push
gh repo edit <you>/repo-template --template
```

**Every new project:**

```bash
gh repo create <you>/my-app --private --template <you>/repo-template --clone
cd my-app
bash scripts/init-template.sh "my-app" "One-line description of what it does"
```

Then ask your agent: *"Fill in the `{{...}}` placeholders in AGENTS.md from the
code and uncomment the right toolchain in `.github/workflows/ci.yml`."*

**Existing repo?** Copy `AGENTS.md`, `CLAUDE.md`, `PROGRESS.md`, `scripts/`,
`docs/`, `.claude/commands/`, and the `.github/` pieces you want.

## Daily loop

```
read PROGRESS.md → /spec → implement in small steps → /verify → /review → /handoff → PR
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

- **Deep Agents / mini-SWE-agent code** — this template shapes *repos* for
  agents; it doesn't ship an agent.
- **Agent evals ([Harbor](https://github.com/harbor-framework/harbor))** — add
  when a repo *is* an agent or you're tuning prompts/config and need evidence.
