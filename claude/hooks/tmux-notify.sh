#!/usr/bin/env bash
set -eo pipefail

action="${1:-set}"

# The session marker is a session option, so the session keeps its name and
# `new-session -A -s <name>` (iTerm profiles, ssh RemoteCommand) attaches to it.

case "$action" in
  set)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    pane_tty=$(tmux display-message -p -t "${TMUX_PANE}" '#{pane_tty}')

    # Bell - highlights window tab when viewing a different window
    printf '\a' > "$pane_tty"

    # Pane highlight - visible when in the same window but different pane
    tmux select-pane -t "${TMUX_PANE}" -P 'bg=#1a0500'
    tmux set-option -p -t "${TMUX_PANE}" @claude_notify 1

    # Session marker - shown in the status line and session list (Ctrl-b s).
    # Targets the pane's session because Claude may run in a session no client
    # is viewing.
    tmux set-option -t "${TMUX_PANE}" @claude_notify_session 1
    ;;

  clear)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    # Reset pane background
    tmux select-pane -t "${TMUX_PANE}" -P 'default' 2>/dev/null || true
    tmux set-option -pu -t "${TMUX_PANE}" @claude_notify 2>/dev/null || true

    tmux set-option -u -t "${TMUX_PANE}" @claude_notify_session 2>/dev/null || true
    ;;

  clear-session)
    # Takes the session as an argument because tmux hooks run without $TMUX_PANE.
    session="${2:-}"
    [ -z "$session" ] && session=$(tmux display-message -p '#{session_id}')
    tmux set-option -u -t "$session" @claude_notify_session 2>/dev/null || true
    ;;
esac
