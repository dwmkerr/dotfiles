# CLAUDE.md

# Memory

NEVER use the persistent memory system. Do not write memory files or update MEMORY.md, even when given feedback worth remembering. Preferences belong in CLAUDE.md files, nowhere else.

# Temporary Files

When working in a git repo, use `./scratch/` for temporary files (cloned repos, test outputs, scratch work). This keeps them discoverable and easy to clean up. No special permissions are needed — just ensure it's gitignored:

```bash
mkdir -p ./scratch
grep -qxF 'scratch/' .gitignore 2>/dev/null || echo 'scratch/' >> .gitignore
```

When not in a git repo, use `/tmp` instead.

# GitHub Repository Access

WebFetch cannot easily access GitHub repository content. Clone the repo instead:

```bash
# In a git repo — use scratch
git clone --depth 1 https://github.com/<owner>/<repo> ./scratch/<repo>

# Outside a git repo — use /tmp
git clone --depth 1 https://github.com/<owner>/<repo> /tmp/<repo>
```

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

# Writing Style

- **be concise and direct** - Remove unnecessary adjectives and verbose descriptions
- **Use simple language** - Avoid complex explanations when simple ones work
- **Keep descriptions brief** - 1-2 sentences maximum for each item
- **Use active voice** - "Creates agent" not "Agent is created"

# Browser Automation

**`claude-in-chrome` is disabled by company policy — do not use it.** Use the
**playwright-edge** MCP server (`mcp__playwright-edge__*`) by default for all browser
automation.

It runs its own persistent profile, separate from the real Edge browser, so logins
survive between sessions but must be done manually the first time (Google/2FA logins
cannot be automated).

Google account: `dwmkerr@gmail.com`.

Only reach for `playwright` (chromium), `playwright-firefox`, or `playwright-safari`
when a task genuinely needs a second, concurrent browser — one agent per MCP server,
since each server shares a single browser context and active-tab pointer.
