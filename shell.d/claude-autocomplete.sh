# Claude Code CLI tab completion for bash and zsh.
#
# Source this file in your shell profile, or install with:
#   source <(curl -fsSL https://raw.githubusercontent.com/dwmkerr/dotfiles/main/shell.d/claude-autocomplete.sh)

_claude_completions() {
    local cur prev commands opts

    if [ -n "${ZSH_VERSION:-}" ]; then
        cur="${words[$CURRENT]}"
        prev="${words[$((CURRENT - 1))]}"
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
    fi

    commands="auth doctor install mcp plugin setup-token update"

    opts="--add-dir --agent --agents --allow-dangerously-skip-permissions
          --allowedTools --allowed-tools --append-system-prompt --betas
          --chrome --continue --dangerously-skip-permissions --debug
          --debug-file --disable-slash-commands --disallowedTools
          --disallowed-tools --effort --fallback-model --file --fork-session
          --from-pr --help --ide --include-partial-messages --input-format
          --json-schema --max-budget-usd --mcp-config --mcp-debug --model
          --no-chrome --no-session-persistence --output-format
          --permission-mode --plugin-dir --print --replay-user-messages
          --resume --session-id --setting-sources --settings
          --strict-mcp-config --system-prompt --tools --verbose --version"

    case "$prev" in
        --model|--fallback-model)
            _claude_reply "opus sonnet haiku"
            return
            ;;
        --effort)
            _claude_reply "low medium high"
            return
            ;;
        --permission-mode)
            _claude_reply "acceptEdits bypassPermissions default delegate dontAsk plan"
            return
            ;;
        --output-format)
            _claude_reply "text json stream-json"
            return
            ;;
        --input-format)
            _claude_reply "text stream-json"
            return
            ;;
        auth)
            _claude_reply "login logout status"
            return
            ;;
        mcp)
            _claude_reply "add add-from-claude-desktop add-json get list remove reset-project-choices serve"
            return
            ;;
        plugin)
            _claude_reply "disable enable install list marketplace uninstall update validate"
            return
            ;;
    esac

    case "$cur" in
        -*)
            _claude_reply "$opts"
            ;;
        *)
            _claude_reply "$commands"
            ;;
    esac
}

_claude_reply() {
    local completions="$1"
    if [ -n "${ZSH_VERSION:-}" ]; then
        compadd -S '' -- ${=completions}
    else
        COMPREPLY=($(compgen -W "$completions" -- "$cur"))
    fi
}

if [ -n "${ZSH_VERSION:-}" ]; then
    autoload -U compinit && compinit 2>/dev/null
    compdef _claude_completions claude
else
    complete -F _claude_completions claude
fi
