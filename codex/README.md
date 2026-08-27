# Codex

Configuration for [Codex CLI](https://github.com/openai/codex).

## Configuration

Codex config lives at `~/.codex/config.toml`. Unlike Claude Code, it is **not symlinked** from this repo: Codex mixes declarative config with machine-written state in the same file (`[projects.*]` trust levels, `[hooks.state.*]` trusted hashes, TUI state), and it may contain sensitive provider URLs. Symlinking it would make the repo dirty after every session.

Instead, this doc records the preferred settings. To apply them, ask an AI agent to read this file and merge the blocks below into `~/.codex/config.toml`, preserving any existing machine state.

Shell aliases and environment are in [`shell.d/codex.sh`](../shell.d/codex.sh).

## MCP servers

Codex CLI, the IDE extension, and the desktop app share the MCP configuration in `~/.codex/config.toml`. Use the CLI to merge servers into that file without replacing local settings.

### Recommended setup

```bash
# Current library documentation
codex mcp add context7 --url https://mcp.context7.com/mcp

# Notion workspace
codex mcp add notion --url https://mcp.notion.com/mcp

# Browser automation using the preferred Edge profile
codex mcp add playwright-edge -- npx -y @playwright/mcp@latest --browser msedge

# Spotify (after completing the setup in the spotify skill)
codex mcp add spotify -- node ~/repos/spotify-mcp-server/build/index.js
```

Remote servers may open an OAuth page while being added. If authentication is still required, run `codex mcp login <server-name>`. Restart Codex after changing the server list, then verify it with `codex mcp list` or `/mcp` inside Codex.

### Optional browsers

Edge is the default. Add another browser only for cross-browser testing or when a second agent needs a separate concurrent browser:

```bash
codex mcp add playwright         -- npx -y @playwright/mcp@latest
codex mcp add playwright-firefox -- npx -y @playwright/mcp@latest --browser firefox
codex mcp add playwright-safari  -- npx -y @playwright/mcp@latest --browser webkit
```

| Server | Purpose |
|--------|---------|
| [Context7](https://github.com/upstash/context7) | Current library and framework documentation |
| [Notion](https://mcp.notion.com) | Notion workspace access |
| [Playwright](https://github.com/microsoft/playwright-mcp) | Persistent Edge browser automation |
| [Spotify](https://github.com/marcelmarais/spotify-mcp-server) | Playlist and playback management |

See the [official Codex MCP documentation](https://learn.chatgpt.com/docs/extend/mcp) for supported transports, authentication, and configuration options.

### Preferred settings

```toml
model_reasoning_effort = "xhigh"

[features]
hooks = true
```

### Status line

Mirrors the Claude Code statusline (`claude/statusline.sh`): directory, git branch, context remaining, model + effort.

```toml
[tui]
status_line = ["current-dir", "git-branch", "context-remaining", "model-with-reasoning"]
status_line_use_colors = true
```

Edit interactively with the `/statusline` command inside Codex.

Available items (as of 0.145.0): `project-name`, `current-dir`, `git-branch`, `context-remaining`, `context-used`, `model-with-reasoning`, `used-tokens`, `total-input-tokens`, `total-output-tokens`, `five-hour-limit`, `weekly-limit`, `thread-title`, `thread-id`, `run-state`, `task-progress`, `codex-version`, `app-name`.

Limitations vs the Claude Code statusline: no custom script hook ([openai/codex#20244](https://github.com/openai/codex/issues/20244)), no identity badge, no colour thresholds for context usage.

### Sensitive / local-only config

Keep these in `~/.codex/config.toml` only — never commit:

- `[model_providers.*]` — gateway URLs and API key env vars
- `[projects.*]` — per-directory trust levels (machine-specific)
- `[hooks.state.*]` — trusted hook hashes (machine-specific)
