#!/usr/bin/env bash
# identity.sh — per-terminal git/GitHub identity manager.
# Identity data files (*.identity) live in ~/.shell.private.d and are not
# version-controlled. This loader is safe to track publicly.

_IDENTITIES_DIR="$HOME/.shell.private.d"

# Git has no environment variable for the signing key - GIT_COMMITTER_SIGNING_KEY
# does not exist and is silently ignored. GIT_CONFIG_COUNT/KEY/VALUE is the only
# per-process config override, so signing settings are injected through it.
_identity_git_config_add() {
    export "GIT_CONFIG_KEY_${_identity_git_config_count}=$1"
    export "GIT_CONFIG_VALUE_${_identity_git_config_count}=$2"
    _identity_git_config_count=$((_identity_git_config_count + 1))
}

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

    # An identity with no key of its own must have signing explicitly disabled:
    # the global commit.gpgsign would otherwise sign its commits with whatever
    # key ~/.gitconfig names, attributing them to a different person.
    _identity_git_config_count=0
    if [ -n "$IDENTITY_GIT_SIGNING_KEY" ]; then
        case "${IDENTITY_GIT_SIGNING_FORMAT:-openpgp}" in
            ssh|openpgp) ;;
            *)  echo "Unknown IDENTITY_GIT_SIGNING_FORMAT: ${IDENTITY_GIT_SIGNING_FORMAT}" >&2
                _identity_clear_env
                return 1 ;;
        esac
        _identity_git_config_add gpg.format "${IDENTITY_GIT_SIGNING_FORMAT:-openpgp}"
        _identity_git_config_add user.signingkey "${IDENTITY_GIT_SIGNING_KEY/#\~/$HOME}"
        _identity_git_config_add commit.gpgsign true
        _identity_git_config_add tag.gpgsign true
        # Without this, git can create ssh signatures but not verify them, and
        # every --show-signature errors instead of reporting a result.
        [ "${IDENTITY_GIT_SIGNING_FORMAT}" = "ssh" ] && \
            _identity_git_config_add gpg.ssh.allowedSignersFile "$HOME/.ssh/allowed_signers"
    else
        _identity_git_config_add commit.gpgsign false
        _identity_git_config_add tag.gpgsign false
        # Blank the inherited key too, so an explicit `git commit -S` fails
        # loudly rather than quietly signing as whoever ~/.gitconfig names.
        _identity_git_config_add user.signingkey ""
    fi
    export GIT_CONFIG_COUNT="$_identity_git_config_count"
    [ -n "$IDENTITY_GH_TOKEN" ] && export GH_TOKEN="$IDENTITY_GH_TOKEN"
    [ -n "$IDENTITY_GIT_SSH_KEY" ] && export GIT_SSH_COMMAND="ssh -i ${IDENTITY_GIT_SSH_KEY/#\~/$HOME} -o IdentitiesOnly=yes -o IdentityAgent=none"

    # gh falls back to the keyring login when GH_TOKEN is unset, running as
    # whoever that is with no error at all, so an identity with no token of its
    # own is worth saying out loud.
    if [ -z "$IDENTITY_GH_TOKEN" ]; then
        echo "Warning: identity '${IDENTITY_NAME}' has no GitHub token - gh will use the default login." >&2
    fi

    export TMUX_RESURRECT_DIR="$HOME/.local/share/tmux/resurrect/$IDENTITY_NAME"

    # Store color/icon/blocklist for prompt and hooks.
    export IDENTITY_COLOR="$IDENTITY_COLOR"
    export IDENTITY_ICON="$IDENTITY_ICON"
}

_identity_clear_env() {
    unset DOTFILES_IDENTITY
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
    # Remove injected git config precisely: git fails with "missing config key"
    # if GIT_CONFIG_COUNT outlives the pairs it counts.
    if [ -n "$GIT_CONFIG_COUNT" ]; then
        local _i=0
        while [ "$_i" -lt "$GIT_CONFIG_COUNT" ]; do
            unset "GIT_CONFIG_KEY_${_i}" "GIT_CONFIG_VALUE_${_i}"
            _i=$((_i + 1))
        done
        unset GIT_CONFIG_COUNT
    fi
    unset GH_TOKEN GIT_SSH_COMMAND
    unset TMUX_RESURRECT_DIR
    # Enumerate IDENTITY_* explicitly. `${!IDENTITY_@}` is bash-only and
    # breaks under zsh with "bad substitution".
    unset IDENTITY_NAME IDENTITY_GIT_NAME IDENTITY_GIT_EMAIL \
          IDENTITY_GIT_SIGNING_KEY IDENTITY_GIT_SIGNING_FORMAT \
          IDENTITY_GH_TOKEN IDENTITY_GH_LOGIN IDENTITY_GIT_SSH_KEY \
          IDENTITY_COLOR IDENTITY_ICON IDENTITY_HIDE_PS1
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

# Days until the token expires, or empty if the date cannot be parsed. BSD and
# GNU date take different flags, so try both.
_identity_token_days_left() {
    # BSD date cannot parse a trailing "UTC" via %Z, so drop the zone and read
    # the timestamp as UTC explicitly.
    local expiry="$1" expiry_epoch=""
    expiry_epoch=$(date -j -u -f "%Y-%m-%d %H:%M:%S" "${expiry% *}" +%s 2>/dev/null) \
        || expiry_epoch=$(date -u -d "$expiry" +%s 2>/dev/null) \
        || return 0
    [ -n "$expiry_epoch" ] || return 0
    echo $(( (expiry_epoch - $(date +%s)) / 86400 ))
}

# Ask GitHub who the current token actually belongs to. The whole point of an
# identity is that commands run as someone specific, and only GitHub can confirm
# that - a token can be dead, or belong to an account you did not expect.
_identity_check() {
    if [ -z "$DOTFILES_IDENTITY" ]; then
        echo "No identity set." >&2
        return 1
    fi

    if [ -z "$GH_TOKEN" ]; then
        echo "✗ ${DOTFILES_IDENTITY}: no token set, gh would run as the default login" >&2
        return 1
    fi

    local response login expiry days
    response=$(gh api -i user 2>&1) || {
        echo "✗ ${DOTFILES_IDENTITY}: $(echo "$response" | grep -i "message" | head -1)" >&2
        return 1
    }

    login=$(echo "$response" | grep -o '"login": *"[^"]*"' | head -1 | cut -d'"' -f4)
    expiry=$(echo "$response" | grep -i "^github-authentication-token-expiration:" | cut -d" " -f2- | tr -d "\r")

    if [ -n "$IDENTITY_GH_LOGIN" ] && [ "$login" != "$IDENTITY_GH_LOGIN" ]; then
        echo "✗ ${DOTFILES_IDENTITY}: token belongs to '${login}', expected '${IDENTITY_GH_LOGIN}'" >&2
        return 1
    fi

    if [ -n "$expiry" ]; then
        days=$(_identity_token_days_left "$expiry")
        echo "✓ ${DOTFILES_IDENTITY}: authenticated as ${login}, token expires ${expiry}${days:+ (${days} days)}"
    else
        echo "✓ ${DOTFILES_IDENTITY}: authenticated as ${login}, token does not expire"
    fi
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
    echo "  \$ identity check"
    _identity_check 2>&1 | sed 's/^/  /'
    echo "  \$ gh auth status"
    gh auth status 2>&1 | sed 's/^/  /'
}

identity() {
    local cmd="${1:-}"

    case "$cmd" in
        "")      _identity_show ;;
        list)    _identity_list ;;
        clear)   _identity_clear ;;
        check)   _identity_check ;;
        status)  _identity_status ;;
        *)       _identity_load "$cmd" && _identity_show ;;
    esac
}

# Auto-load identity if DOTFILES_IDENTITY is already set (e.g. from iTerm profile).
if [ -n "$DOTFILES_IDENTITY" ]; then
    _identity_load "$DOTFILES_IDENTITY"
fi
