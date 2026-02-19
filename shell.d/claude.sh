alias claude-yolo="claude --dangerously-skip-permissions"

# Run Claude Code against local LM Studio server
claude-local() {
    ANTHROPIC_BASE_URL=http://localhost:1234 \
    ANTHROPIC_AUTH_TOKEN=lmstudio \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    claude "$@"
}
