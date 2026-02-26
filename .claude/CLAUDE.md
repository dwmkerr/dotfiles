# CLAUDE.md

# Comments Guidelines

**NEVER add breadcrumb comments** that simply describe what the code does or what it was changed from. Instead, use comments to explain WHY the current approach was chosen.

## Bad Comments (breadcrumbs):
```javascript
// Changed from Promise.all to sequential processing to avoid API rate limits
// Loop through all users  
// Check if user is active
// Send notification to user
```

## Good Comments (reasoning):
```javascript
// Process sequentially to avoid hitting API rate limits
users.forEach(user => {
    if (user.active) {
        sendNotification(user);
    }
});
```

Other examples of good comments:
- `// Use mutex lock to prevent race condition on shared counter`
- `// Exponential backoff handles temporary API unavailability` 
- `// API doesn't validate null values, so we check here`

# Commit and PR Requirements

CRITICAL: All commit messages and PR titles MUST follow conventional commit format (e.g., `feat:`, `fix:`, `docs:`, `chore:`).

## Pull Request Format

When creating pull requests, use this simple format:
```
## Summary
- Brief description of changes
```

**CRITICAL: Whenever a PR is created or updated, ALWAYS include the PR URL at the end of the message.**

## Supported Commit Types
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `ci`: CI/CD changes
- `build`: Build system changes
- `perf`: Performance improvements

# Tmux Notifications

Claude Code hooks send a terminal bell on `Stop` and `Notification` events via `~/.claude/hooks/tmux-notify.sh`. This highlights the window tab (red), pane background, and appends 🔔 to the session name. Notifications auto-clear on pane focus, session switch, or next prompt submit.

To disable: remove the `hooks` block from `claude/settings.json` and the tmux hooks from `tmux/tmux.conf` (the `set-hook` lines and `monitor-bell`).

# Writing Style

- **be concise and direct** - Remove unnecessary adjectives and verbose descriptions
- **Use simple language** - Avoid complex explanations when simple ones work
- **Keep descriptions brief** - 1-2 sentences maximum for each item
- **Use active voice** - "Creates agent" not "Agent is created"
