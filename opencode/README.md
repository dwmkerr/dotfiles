# opencode

Config for the [opencode](https://opencode.ai) CLI. `make link` symlinks `plugin/tmux-notify.js` so opencode shares the Claude tmux notifications.

## Notifications

`plugin/tmux-notify.js` fires on `session.idle` and calls `~/.claude/hooks/tmux-notify.sh`, so opencode highlights the tmux window/pane/session like Claude does.

## Skills

Install into both agents with the [`skills`](https://github.com/vercel-labs/skills) CLI (symlinks, so repo edits are live):

```bash
npx skills add ~/repos/github/dwmkerr/claude-toolkit         --global --agent opencode --skill '*' -y
npx skills add ~/repos/github/dwmkerr/dwmkerr-claude-toolkit --global --agent opencode --skill '*' -y
```

## MCP

```bash
opencode mcp add context7 --url https://mcp.context7.com/mcp
opencode mcp add notion   --url https://mcp.notion.com/mcp     # then: opencode mcp auth notion
opencode mcp add playwright -- npx -y @playwright/mcp@latest
opencode mcp add spotify  -- node ~/repos/spotify-mcp-server/build/index.js
```
