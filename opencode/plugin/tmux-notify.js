// Reuse the Claude Code tmux notifier so opencode and Claude share one
// notification mechanism (window/pane/session highlight + bell).
const NOTIFY = `${process.env.HOME}/.claude/hooks/tmux-notify.sh`

export const server = async ({ $ }) => {
  // .nothrow() so a tmux/script failure never bubbles into the opencode session.
  const run = (action) => $`${NOTIFY} ${action}`.nothrow()

  return {
    event: async ({ event }) => {
      // session.idle = agent finished a turn → raise the notification.
      if (event.type === "session.idle") {
        await run("set")
        return
      }

      // Agent started working again (user submitted) → clear, mirroring the
      // Claude UserPromptSubmit clear. Property name is best-effort; tmux's own
      // pane-focus-in hook clears on focus regardless, so a miss is harmless.
      if (event.type === "session.status" && event.properties?.status === "busy") {
        await run("clear")
      }
    },
  }
}
