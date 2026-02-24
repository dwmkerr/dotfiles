# Claude Code

Configuration and setup for [Claude Code](https://claude.ai/code) CLI.

## GitHub Action

Claude Code can run on GitHub issues and PRs via the official `claude-code-action`. Mention `@claude` in an issue or PR comment to trigger it. See [github-action.md](./github-action.md) for setup and usage.

## Configuration

Configuration files are managed via symlinks from this directory:

- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `claude/settings.json` → `~/.claude/settings.json`
- `claude/statusline.sh` → `~/.claude/statusline.sh`

Run `make link` to create or refresh symlinks. Claude Code writes through symlinks safely.

To view or edit settings, use the `/config` command within Claude Code.

For detailed setup guidance, see: [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config)

### Settings layers

Claude Code merges settings from three layers:

| Layer | File | Version-controlled | Contents |
|-------|------|--------------------|----------|
| Global | `~/.claude/settings.json` (symlink → repo) | Yes | Plugins, universal permissions, statusline, env vars, feature flags |
| Global local | `~/.claude/settings.local.json` | No | Machine-specific permissions (e.g. notion, python), sensitive config |
| Project local | `.claude/settings.local.json` | No | Project-specific permissions |

**Rule of thumb:** if a permission is safe everywhere, put it in `settings.json`. If it's machine/account-specific, use `settings.local.json`. If it's destructive or project-specific, use the project-level file.

## Plugins

Enabled plugins are stored in `settings.json`. To set up from scratch:

```bash
# Context engineering patterns
/plugin marketplace add context-engineering-marketplace
/plugin install context-engineering-fundamentals@context-engineering-marketplace

# Claude toolkit - utilities and skills
/plugin marketplace add claude-toolkit
/plugin install skills@claude-toolkit
/plugin install toolkit@claude-toolkit
/plugin install dwmkerr@claude-toolkit

# Personal agents (research, writing, typescript) and protocols
/plugin marketplace add dwmkerr-claude-toolkit
/plugin install dwmkerr-toolkit@dwmkerr-claude-toolkit
/plugin install protocols@dwmkerr-claude-toolkit

# Ark platform agents
/plugin marketplace add agents-at-scale-ark
/plugin install ark@agents-at-scale-ark

# AI26 tools (PDF conversion)
/plugin marketplace add ai26
/plugin install ai26@ai26

# Document skills (docx, pptx, xlsx, pdf)
/plugin marketplace add anthropic-agent-skills
/plugin install document-skills@anthropic-agent-skills

# TDD, debugging, brainstorming, git worktrees
/plugin marketplace add claude-plugins-official
/plugin install superpowers@claude-plugins-official

# CX tools (git, issues, testing)
/plugin marketplace add ccp
/plugin install cx@ccp

# Problem-solving pipeline
/plugin marketplace add pspipe
/plugin install ps@pspipe
```

Discovery: [VoltAgent/awesome-claude-skills](https://github.com/VoltAgent/awesome-claude-skills)

## MCP Servers

Common MCP (Model Context Protocol) servers:

```bash
# Context7 - Up-to-date documentation for libraries
claude mcp add --transport http context7 https://mcp.context7.com/mcp

# If you have a Context7 API key:
claude mcp add --transport http context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: YOUR_API_KEY"

# Notion - Access Notion workspace
claude mcp add --transport http notion https://mcp.notion.com/mcp --scope user
```

| Server | Description |
|--------|-------------|
| [Context7](https://github.com/upstash/context7) | Fetches up-to-date documentation for libraries |
| [Notion](https://mcp.notion.com) | Access Notion workspace |

## Shell Autocomplete

Tab completion for the `claude` CLI (flags, subcommands, model names, etc.). Works in bash and zsh.

**Already using these dotfiles?** It's sourced automatically from [`shell.d/claude-autocomplete.sh`](../shell.d/claude-autocomplete.sh).

**Standalone install** — add to your `~/.bashrc` or `~/.zshrc`:

```bash
source <(curl -fsSL https://raw.githubusercontent.com/dwmkerr/dotfiles/main/shell.d/claude-autocomplete.sh)
```

## Offline Coding with LM Studio

[LM Studio](https://lmstudio.ai) runs local models offline via the `lms` CLI (see [`shell.d/lmstudio.sh`](../shell.d/lmstudio.sh)).

```sh
# Install
brew install --cask lm-studio

# Open GUI
open -a "LM Studio"
```

**Recommended model:** [Qwen3-Coder-Next](https://huggingface.co/qwen/qwen3-coder-next) — 80B MoE with only 3B active parameters, optimised for Apple Silicon via MLX. ~45GB download.

```sh
# Login first
lms login

# Download - auto-selects best MLX quantization for your hardware
lms get "Qwen3-Coder-Next" --mlx -y

# Check the downloaded model name
lms ls

# Load with full GPU and large context window (use name from lms ls)
lms load qwen/qwen3-coder-next --context-length 131072 --gpu max -y

# Start the local server (exposes OpenAI-compatible API on localhost:1234)
lms server start
```

> If the download times out, open LM Studio to resume it.

### Troubleshooting

**"The number of tokens to keep from the initial prompt is greater than the context length"** — Claude Code's system prompt is large. Try reducing it:

```sh
# Disable auto-loaded tools first
claude-local --strict-mcp-config

# If still failing, also strip skills and use a minimal system prompt
claude-local --strict-mcp-config --disable-slash-commands --system-prompt "You are a helpful coding assistant."
```

**"request.thinking.type: Invalid discriminator value. Expected 'enabled' | 'disabled'"** — Disable extended thinking:

```sh
claude-local --settings '{"alwaysThinkingEnabled": false}'
```
