#!/usr/bin/env bash
# identity.sh — per-terminal git/GitHub identity manager.
# Identity data files (*.identity) live in ~/.shell.private.d and are not
# version-controlled. This loader is safe to track publicly.

_IDENTITIES_DIR="$HOME/.shell.private.d"

_identity_load() {
    local name="$1"
    local file="${_IDENTITIES_DIR}/${name}.identity"

    if [ ! -f "$file" ]; then
        echo "Identity not found: $file" >&2
        return 1
    fi

    # Always clear first so no fields leak between identities.
    _identity_clear_env

    # Source the identity file to get IDENTITY_* vars.
    source "$file"

    # Export the identity name.
    export DOTFILES_IDENTITY="$IDENTITY_NAME"

    # Git env vars override global gitconfig per-process.
    export GIT_AUTHOR_NAME="$IDENTITY_GIT_NAME"
    export GIT_AUTHOR_EMAIL="$IDENTITY_GIT_EMAIL"
    export GIT_COMMITTER_NAME="$IDENTITY_GIT_NAME"
    export GIT_COMMITTER_EMAIL="$IDENTITY_GIT_EMAIL"

    [ -n "$IDENTITY_GIT_SIGNING_KEY" ] && export GIT_COMMITTER_SIGNING_KEY="$IDENTITY_GIT_SIGNING_KEY"
    [ -n "$IDENTITY_GH_TOKEN" ] && export GH_TOKEN="$IDENTITY_GH_TOKEN"
    [ -n "$IDENTITY_GIT_SSH_KEY" ] && export GIT_SSH_COMMAND="ssh -i ${IDENTITY_GIT_SSH_KEY/#\~/$HOME} -o IdentitiesOnly=yes -o IdentityAgent=none"

    export TMUX_RESURRECT_DIR="$HOME/.local/share/tmux/resurrect/$IDENTITY_NAME"

    # Store color/icon/blocklist for prompt and hooks.
    export IDENTITY_COLOR="$IDENTITY_COLOR"
    export IDENTITY_ICON="$IDENTITY_ICON"
    export IDENTITY_BLOCKED_REPOS="$IDENTITY_BLOCKED_REPOS"
}

_identity_clear_env() {
    unset DOTFILES_IDENTITY
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
    unset GIT_COMMITTER_SIGNING_KEY
    unset GH_TOKEN GIT_SSH_COMMAND
    unset TMUX_RESURRECT_DIR
    unset "${!IDENTITY_@}"
}

_identity_clear() {
    _identity_clear_env
    echo "Identity cleared. Using global gitconfig defaults."
}

_identity_show() {
    if [ -z "$DOTFILES_IDENTITY" ]; then
        echo "No identity set. Using global gitconfig."
        return 0
    fi
    echo "${IDENTITY_ICON:-?} ${DOTFILES_IDENTITY} (${GIT_AUTHOR_NAME} <${GIT_AUTHOR_EMAIL}>)"
}

_identity_list() {
    local file
    for file in "${_IDENTITIES_DIR}"/*.identity; do
        [ -e "$file" ] || continue
        local name
        name="$(basename "$file" .identity)"
        # Source into a subshell to read fields without polluting env.
        local icon git_name git_email
        icon="$(source "$file" && echo "$IDENTITY_ICON")"
        git_name="$(source "$file" && echo "$IDENTITY_GIT_NAME")"
        git_email="$(source "$file" && echo "$IDENTITY_GIT_EMAIL")"
        if [ "$name" = "$DOTFILES_IDENTITY" ]; then
            echo "* ${icon} ${name}  ${git_name} <${git_email}>"
        else
            echo "  ${icon} ${name}  ${git_name} <${git_email}>"
        fi
    done
}

# PS1 badge — only shown for non-default identities.
_identity_info() {
    [ -z "$DOTFILES_IDENTITY" ] && return
    [ "${IDENTITY_HIDE_PS1:-0}" = "1" ] && return
    local reset=$(tput sgr0)
    local bold=$(tput bold)
    local color
    case "${IDENTITY_COLOR:-white}" in
        red)     color=$(tput setaf 1) ;;
        green)   color=$(tput setaf 2) ;;
        yellow)  color=$(tput setaf 3) ;;
        blue)    color=$(tput setaf 4) ;;
        magenta) color=$(tput setaf 5) ;;
        cyan)    color=$(tput setaf 6) ;;
        *)       color=$(tput setaf 7) ;;
    esac
    echo "${bold}${color}${DOTFILES_IDENTITY}${reset} "
}

_identity_status() {
    echo "=== Identity ==="
    if [ -n "$DOTFILES_IDENTITY" ]; then
        echo "  DOTFILES_IDENTITY=$DOTFILES_IDENTITY"
    else
        echo "  No identity set"
    fi

    echo ""
    echo "=== Git (env vars override gitconfig) ==="
    echo "  \$ echo \$GIT_AUTHOR_NAME"
    echo "  ${GIT_AUTHOR_NAME:-(not set)}"
    echo "  \$ echo \$GIT_AUTHOR_EMAIL"
    echo "  ${GIT_AUTHOR_EMAIL:-(not set)}"
    echo "  \$ git config user.name"
    echo "  $(git config user.name 2>/dev/null || echo '(not set)')"
    echo "  \$ git config user.email"
    echo "  $(git config user.email 2>/dev/null || echo '(not set)')"

    echo ""
    echo "=== GitHub ==="
    echo "  \$ echo \$GH_TOKEN"
    if [ -n "$GH_TOKEN" ]; then
        echo "  ${GH_TOKEN:0:8}..."
    else
        echo "  (not set)"
    fi
    echo "  \$ gh auth status"
    gh auth status 2>&1 | sed 's/^/  /'

    if [ -n "$IDENTITY_BLOCKED_REPOS" ]; then
        echo ""
        echo "=== Blocked repos ==="
        echo "  ${IDENTITY_BLOCKED_REPOS}"
    fi
}

identity() {
    local cmd="${1:-}"

    case "$cmd" in
        "")      _identity_show ;;
        list)    _identity_list ;;
        clear)   _identity_clear ;;
        status)  _identity_status ;;
        *)       _identity_load "$cmd" && _identity_show ;;
    esac
}

# Auto-load identity if DOTFILES_IDENTITY is already set (e.g. from iTerm profile).
if [ -n "$DOTFILES_IDENTITY" ]; then
    _identity_load "$DOTFILES_IDENTITY"
fi
