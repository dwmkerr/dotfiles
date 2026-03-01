# Claude Code GitHub Action

Run Claude Code on GitHub issues and PRs. Mention `@claude` or add the `claude` label to trigger it.

## Quick Start

Use [dwmkerr/agent-actions](https://github.com/dwmkerr/agent-actions) — a centralized reusable workflow that handles triggers, actor allowlists, concurrency, and timeouts.

1. Run `setup-agent-actions` in your repo (or copy the caller template manually)
2. Ensure the `ANTHROPIC_API_KEY` secret is available (org-level or repo-level)

The `setup-agent-actions` shell function (from this dotfiles repo) creates the caller workflow automatically:

```bash
setup-agent-actions              # current directory
setup-agent-actions ~/repos/foo  # specific repo
```

## How It Works

```
your-repo/.github/workflows/agent-actions.yml  (thin caller, ~15 lines)
    └── calls → dwmkerr/agent-actions/.github/workflows/claude.yml  (all config)
                    └── runs → anthropics/claude-code-action@v1
```

Configuration (trigger phrase, timeout, allowed users) lives in agent-actions. Override per-repo if needed:

```yaml
jobs:
  claude:
    uses: dwmkerr/agent-actions/.github/workflows/claude.yml@main
    secrets:
      anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    with:
      allowed_users: "dwmkerr,teammate1"
      timeout_minutes: 45
```

## Credential Strategy

### Option A: Org-level secret (recommended)

Set the API key once at the GitHub org level. All repos inherit it automatically.

```bash
gh secret set ANTHROPIC_API_KEY --org dwmkerr --visibility all
```

- One place to rotate the key
- Any repo with the workflow file just works
- Can override per-repo if needed

### Option B: Per-repo secret

```bash
gh secret set ANTHROPIC_API_KEY --repo dwmkerr/<repo-name>
```

Useful for repos that need a different key or rate limit.

### Option C: AWS Bedrock OIDC (zero secrets)

For enterprise setups, use GitHub OIDC to get temporary AWS credentials and call Bedrock. No stored secrets needed. Requires an AWS IAM role configured to trust GitHub OIDC — see the [cxpipe repo](https://github.com/anthropics/cxpipe) for a production example.

## Security Notes

- **Actor allowlist is handled centrally** — defaults to `dwmkerr`, override via `allowed_users` input
- The `GITHUB_TOKEN` is automatically scoped to the repo and requires no setup
- `id-token: write` is included for future OIDC support but is not used with API key auth
