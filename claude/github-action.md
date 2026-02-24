# Claude Code GitHub Action

Run Claude Code on GitHub issues and PRs. Mention `@claude` or add the `claude` label to trigger it.

## Setup

### 1. Install the Claude GitHub App

Visit https://github.com/apps/claude and install for your account. Select **All repositories** to cover everything, or pick specific repos.

### 2. Add the API key secret

```bash
# For a single repo
gh secret set ANTHROPIC_API_KEY --repo dwmkerr/<repo-name>

# For all repos in your account (requires GitHub CLI 2.x)
gh secret set ANTHROPIC_API_KEY --org dwmkerr --visibility all
```

### 3. Copy the workflow file

Copy `.github/workflows/claude.yml` from this repo into any repo you want to enable.

## Usage

### From an issue

Create an issue and mention `@claude` in the body:

> @claude add a makefile target for running lint

Claude reads the codebase, implements the change, pushes a branch, and comments with a link to create a PR.

### From a PR comment

Comment on any PR:

> @claude fix the failing test

Claude reads the PR diff, makes changes, and pushes to the branch.

### Using the `claude` label

Add a `claude` label to any issue. Claude picks it up the same as an `@claude` mention.

## How it works

```
Issue/Comment → GitHub Action triggers → Claude Code runs on the runner
→ reads codebase → implements → pushes branch → comments with PR link
```

Claude does NOT auto-create PRs (by design). It pushes commits and gives you a pre-filled link.

## Notifications

Standard GitHub notifications apply:
- **GitHub mobile app** push notifications
- **Email** notifications
- **Slack** via GitHub's Slack integration

## Allowed tools

The workflow restricts Bash to safe commands (`git`, `npm test`, `npm run build`, `make`). Edit the `allowed_tools` field in the workflow to expand this.

## Cost

Typical usage: $0.05-$0.50 per invocation, $10-50/month depending on volume.

## Rolling out to more repos

To add this to another repo, copy the workflow file and set the secret:

```bash
# Copy workflow
mkdir -p /path/to/repo/.github/workflows
cp .github/workflows/claude.yml /path/to/repo/.github/workflows/

# Set secret
gh secret set ANTHROPIC_API_KEY --repo dwmkerr/<repo-name>
```

A rollout script for all repos is planned — see the dotfiles README for updates.
