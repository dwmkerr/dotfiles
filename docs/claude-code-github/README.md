# Claude Code GitHub Action

Run Claude Code on GitHub issues and PRs. Mention `@claude` or add the `claude` label to trigger it.

## Quick Start

1. Copy `claude.yml` to `.github/workflows/claude.yml` in your repo
2. Edit the `sender.login` allowlist to include your team
3. Ensure the `ANTHROPIC_API_KEY` secret is available (org-level or repo-level)

## Template Workflow

The [`claude.yml`](./claude.yml) template includes:

- **Actor allowlist** — only specified GitHub users can trigger Claude (prevents strangers burning your API key on public repos)
- **Trigger events** — issue comments, PR review comments, PR reviews, and the `claude` label
- **Permissions** — write access to contents, issues, and pull requests

### Adding team members

Add more users to the `sender.login` check:

```yaml
if: |
  (
    github.event.sender.login == 'dwmkerr' ||
    github.event.sender.login == 'teammate1' ||
    github.event.sender.login == 'teammate2'
  ) && (
    ...
  )
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

## Repos Using This

| Repo | Actor allowlist |
|------|-----------------|
| `dwmkerr/dotfiles` | `dwmkerr` |
| `dwmkerr/tips-openspec` | none (needs update) |
| `dwmkerr/agents-at-scale-ark` | `dwmkerr`, `Nab-0`, `cm94242` |

## Security Notes

- **Always use an actor allowlist on public repos** — without it, anyone can trigger the action and consume your API key
- The `GITHUB_TOKEN` is automatically scoped to the repo and requires no setup
- `id-token: write` is included for future OIDC support but is not used with API key auth
