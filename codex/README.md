# Codex

Configuration for [Codex CLI](https://github.com/openai/codex).

## Configuration

Codex config lives at `~/.codex/config.toml`. Unlike Claude Code, it is **not symlinked** from this repo: Codex mixes declarative config with machine-written state in the same file (`[projects.*]` trust levels, `[hooks.state.*]` trusted hashes, TUI state), and it may contain sensitive provider URLs. Symlinking it would make the repo dirty after every session.

Instead, this doc records the preferred settings. To apply them, ask an AI agent to read this file and merge the blocks below into `~/.codex/config.toml`, preserving any existing machine state.

Shell aliases and environment are in [`shell.d/codex.sh`](../shell.d/codex.sh).

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
