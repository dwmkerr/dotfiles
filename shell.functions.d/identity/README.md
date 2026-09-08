# Identities

Per-terminal git/GitHub identities.

## How it works

Each identity is a small shell file that sets env vars (`GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `GH_TOKEN`, etc.) for the current shell. Git and `gh` respect these automatically.

## File layout

```
shell.functions.d/identity/
  identity.sh                # shell function (sourced via shell.sh)
  pre-push-identity-guard    # git hook script
  README.md

~/.shell.private.d/
  myname.identity            # identity config (secrets — never committed)
  project-2.identity
```

Identity `.identity` files live in `~/.shell.private.d/`, not in this directory. They contain secrets (GitHub tokens) and are never committed to git. They are backed up via `make private-files-backup`.

## Creating an identity

Copy an existing `.identity` file and fill in the fields:

```bash
cp ~/.shell.private.d/dwmkerr.identity ~/.shell.private.d/myname.identity
```

Fields:

| Field | Description |
|-------|-------------|
| `IDENTITY_NAME` | Short name used in commands and prompt |
| `IDENTITY_GIT_NAME` | Git author/committer name |
| `IDENTITY_GIT_EMAIL` | Git author/committer email |
| `IDENTITY_GIT_SIGNING_KEY` | GPG fingerprint, or path to an SSH public key (optional) |
| `IDENTITY_GIT_SIGNING_FORMAT` | `openpgp` (default) or `ssh` |
| `IDENTITY_GH_TOKEN` | GitHub personal access token for `gh` CLI |
| `IDENTITY_GH_LOGIN` | Expected GitHub login, asserted by `identity check` |
| `IDENTITY_COLOR` | Prompt badge color: red, green, yellow, blue, magenta, cyan |
| `IDENTITY_ICON` | Emoji shown in `identity list` output |
| `IDENTITY_BLOCKED_REPOS` | Comma-separated repos/globs to block pushes to |
| `IDENTITY_HIDE_PS1` | Set to `1` to hide the PS1 badge for this identity |

## Signing

Git has no environment variable for the signing key, so the loader injects
`user.signingkey`, `gpg.format` and `commit.gpgsign` through `GIT_CONFIG_COUNT`.

An identity with no `IDENTITY_GIT_SIGNING_KEY` gets signing switched **off** and
its inherited signing key blanked. Without that, the global `commit.gpgsign`
signs every identity's commits with whatever key `~/.gitconfig` names.

SSH signing needs the public key listed in `~/.ssh/allowed_signers` for git to
verify its own signatures, and registered on GitHub as a Signing key (separate
from an Authentication key) for GitHub to show them as Verified.

## Usage

`identity.sh` is sourced automatically via `shell.sh`. Commands:

```bash
identity list       # show available identities
identity myname     # load the 'myname' identity
identity            # show current identity
identity status     # show identity, git, and GitHub auth details
identity check      # verify the token is live and owned by the expected account
identity clear      # unset identity, revert to global gitconfig
```

## Prompt badge

The PS1 theme shows a colored identity badge on the prompt line. If `identity.sh` isn't sourced, the badge is silently skipped.

## Push guardrails

The `pre-push-identity-guard` script blocks pushes to repos listed in `IDENTITY_BLOCKED_REPOS`. Supports glob patterns like `org-name/*` or `*/repo-name`.

Install per-repo by symlinking to `.git/hooks/pre-push`:

```bash
ln -sf ~/path/to/dotfiles/shell.functions.d/identity/pre-push-identity-guard \
    .git/hooks/pre-push
```

## iTerm2 profiles

Each identity can have an iTerm2 profile in `terminal/iTerm2/`. Profiles run `identity <name> && tmux -L <socket> new-session -A -s <session>` as initial text, giving fully isolated tmux sessions per identity.

## Future ideas

- `.identity.yaml` in repo roots to force/guard identity per-project
- Global `core.hooksPath` so the push guard works everywhere
- `identity init` command to scaffold new identities interactively
