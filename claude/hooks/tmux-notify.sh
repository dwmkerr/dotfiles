#!/usr/bin/env bash
set -eo pipefail

action="${1:-set}"

# Opt-in, since signalbox owns agent notifications when installed and the two
# would fight over the same pane.
[ "${DOTFILES_AGENT_SESSION_BELL:-}" = 1 ] || exit 0

# The session marker is a session option, so the session keeps its name and
# `new-session -A -s <name>` (iTerm profiles, ssh RemoteCommand) attaches to it.

case "$action" in
  set)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    pane_tty=$(tmux display-message -p -t "${TMUX_PANE}" '#{pane_tty}')

    # Bell - highlights window tab when viewing a different window
    printf '\a' > "$pane_tty"

    # Pane highlight - style it directly so Claude never takes focus.
    tmux set-option -p -t "${TMUX_PANE}" window-style 'bg=#1a0500'
    tmux set-option -p -t "${TMUX_PANE}" @claude_notify 1

    # Session marker - shown in the status line and session list (Ctrl-b s).
    # Targets the pane's session because Claude may run in a session no client
    # is viewing.
    tmux set-option -t "${TMUX_PANE}" @claude_notify_session 1
    ;;

  clear)
    [ -z "${TMUX:-}" ] && exit 0
    [ -z "${TMUX_PANE:-}" ] && exit 0

    # Reset pane background without selecting it.
    tmux set-option -pu -t "${TMUX_PANE}" window-style 2>/dev/null || true
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
