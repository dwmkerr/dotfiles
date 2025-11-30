---
name: ark-dashboard-testing
description: Test Ark Dashboard with Playwright and create PRs with screenshots. Use when testing dashboard UI, taking screenshots for PRs, or reviewing dashboard changes.
---

# Ark Dashboard Testing

Test Ark Dashboard UI with Playwright and create PRs with embedded screenshots.

## Setup

```bash
kubectl port-forward svc/ark-dashboard 3000:3000 -n default &
curl http://localhost:3000  # warm up
```

## Test with Playwright

Use Playwright MCP tools: `browser_navigate`, `browser_wait_for`, `browser_click`, `browser_take_screenshot`.

Screenshots save to `.playwright-mcp/screenshots/` - move to `./screenshots/`.

## PR Screenshots

Check if user has a scratch repo:
```bash
gh repo view <USERNAME>/scratch
```

If not, suggest creating one with structure: `scratch/pull-request-attachments/<org>_<repo>/`

Upload:
```bash
cd /tmp && git clone git@github.com:<USERNAME>/scratch.git
mkdir -p scratch/pull-request-attachments/<org>_<repo>
cp ./screenshots/*.png scratch/pull-request-attachments/<org>_<repo>/
cd scratch && git add . && git commit -m "chore: screenshots for <org>/<repo> PR #XXX" && git push
```

Reference in PR:
```markdown
![Alt](https://raw.githubusercontent.com/<USERNAME>/scratch/master/pull-request-attachments/<org>_<repo>/01-screenshot.png)
```

Update PR via API:
```bash
gh api repos/<org>/<repo>/pulls/XXX -X PATCH -f body="..."
```

---
[Claude Code Skills Documentation](https://docs.anthropic.com/en/docs/claude-code/skills)
