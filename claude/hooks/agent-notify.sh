#!/usr/bin/env bash
# Claude Code hook dispatcher. Prefers signalbox (which fires the session
# event AND applies the tmux signals itself); falls back to the plain tmux
# notify behaviour when signalbox is not installed. Always exits 0 — a
# notifier must never break the agent that calls it.
payload="$(cat)"

if command -v signalbox >/dev/null 2>&1; then
  printf '%s' "$payload" | signalbox claude-hook 2>/dev/null
  exit 0
fi

# No signalbox on this machine: keep the original in-terminal signals.
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
case "$payload" in
  *'"hook_event_name":"Notification"'*) "$dir/tmux-notify.sh" 2>/dev/null ;;
  *'"hook_event_name":"UserPromptSubmit"'*) "$dir/tmux-notify.sh" clear 2>/dev/null ;;
esac
exit 0
