# Inspired by https://github.com/trailofbits/claude-code-config

alias claude-yolo="claude --dangerously-skip-permissions"

# Run Claude Code against local LM Studio server
claude-local() {
    if ! curl -s http://localhost:1234/v1/models > /dev/null 2>&1; then
        echo "Error: LM Studio server is not running on localhost:1234" >&2
        echo "Start it with: lms server start" >&2
        return 1
    fi

    local model
    model=$(curl -s http://localhost:1234/v1/models | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -z "$model" ]; then
        echo "Error: No models loaded in LM Studio" >&2
        echo "Load a model with: lms load <model>" >&2
        echo "List downloaded models: lms ls" >&2
        return 1
    fi

    ANTHROPIC_BASE_URL=http://localhost:1234 \
    ANTHROPIC_AUTH_TOKEN=lmstudio \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    claude --model "$model" "$@"
}
