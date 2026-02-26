#!/usr/bin/env bash
set -eo pipefail

action="${1:-set}"

case "$action" in
  set)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    pane_tty=$(tmux display-message -p -t "${TMUX_PANE}" '#{pane_tty}')

    # Bell — highlights window tab when viewing a different window
    printf '\a' > "$pane_tty"

    # Pane highlight — visible when in the same window but different pane
    tmux select-pane -t "${TMUX_PANE}" -P 'bg=#1a0500'
    tmux set-option -p -t "${TMUX_PANE}" @claude_notify 1

    # Session marker — visible in session list (Ctrl-b s)
    session=$(tmux display-message -p '#{session_name}')
    session="${session% 🔔}"
    tmux rename-session "${session} 🔔" 2>/dev/null || true
    ;;

  clear)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    # Reset pane background
    tmux select-pane -t "${TMUX_PANE}" -P 'default' 2>/dev/null || true
    tmux set-option -pu -t "${TMUX_PANE}" @claude_notify 2>/dev/null || true

    # Remove session marker
    session=$(tmux display-message -p '#{session_name}')
    session="${session% 🔔}"
    tmux rename-session "${session}" 2>/dev/null || true
    ;;

  clear-session)
    # Called by tmux hook (no $TMUX_PANE available)
    session=$(tmux display-message -p '#{session_name}')
    cleaned="${session% 🔔}"
    [ "$cleaned" != "$session" ] && tmux rename-session "$cleaned" 2>/dev/null || true
    ;;
esac
