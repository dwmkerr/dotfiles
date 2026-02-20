# Claude Code

Configuration and setup for [Claude Code](https://claude.ai/code) CLI.

## Configuration

Configuration files are managed via symlinks from this directory:

- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `claude/settings.json` → `~/.claude/settings.json`
- `claude/statusline.sh` → `~/.claude/statusline.sh`

To view or edit settings, use the `/config` command within Claude Code.

For detailed setup guidance, see: [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config)

## Preferred Plugins

After setup, install preferred marketplace plugins:

```bash
# Add marketplaces
/plugin marketplace add dwmkerr/dwmkerr-plugins
/plugin marketplace add anthropics/skills]
# https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering
/plugin marketplace add context-engineering-marketplace
/plugin marketplace add claude-toolkit

# Install plugins
/plugin install dwmkerr@dwmkerr-plugins
/plugin install anthropics@skills
/plugin install context-engineering-fundamentals@context-engineering-marketplace
/plugin install skills@claude-toolkit
```

| Marketplace | Plugin | Description |
|-------------|--------|-------------|
| `dwmkerr-plugins` | `dwmkerr` | Personal agents & skills (research, writing, typescript) |
| `anthropics/skills` | `anthropics` | Official Anthropic skills (docx, pptx, xlsx, pdf) |
| `context-engineering-marketplace` | `context-engineering-fundamentals` | Context engineering patterns |
| `claude-toolkit` | `skills` | Claude toolkit utilities |

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
