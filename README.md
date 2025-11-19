# dotfiles

This repository contains all of my configuration for MacOS and Linux, with a focus on terminal, editor, shell, programming environments etc. This repository can easily be forked to allow you to create and customise your own machine setup.

This repository also contains some handy [Shell Scripts and Aliases](#shell-scripts-and-aliases) that others might find helpful.

Some key features are:

- Support for setting up a clean machine with developer focused tooling
- The ability to choose what features you do or don't install
- Idempotent setup, which allows you to run the setup whenever you want to add or upgrade features
- Small, simple scripts to setup 'features', such as Ruby and `rbenv`, Python, Vim and so on
- Small, simple scripts which are sourced into your shell profile, providing things like auto-completion
- Management of dotfiles such as `~/.vimrc` and `~/.gitconfig`
- Optional management of private file, such as SSH keys, as long as you have access to an AWS S3 bucket

⚠️ **Warning**: I have tried wherever possible to ensure no _destructive_ change will happen when working with the scripts or commands in this project, without explicit user intervention (i.e. the user typing `yes` to make changes). The goal is that you can run the setup scripts without changing _anything_ unless you explicitly choose a feature. However, I cannot guarantee I haven't made an mistakes, so please exercise caution.

**Screenshot on MacOSX**

![Screenshot: MacOSX](./docs/screenshot_macosx.png)

**Screenshot on Ubuntu**

![Screenshot: Ubuntu](./docs/screenshot_ubuntu.png)

<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [SSH Keys, GPG Keys and Private Files](#ssh-keys-gpg-keys-and-private-files)
    - [Backing Up Private Files](#backing-up-private-files)
    - [Restoring Private Files](#restoring-private-files)
    - [Configuring Backup and Restore](#configuring-backup-and-restore)
- [MacOS - Manual Steps](#macos---manual-steps)
    - [iTerm2 Configuration](#iterm2-configuration)
- [Features](#features)
- [Developer Guide](#developer-guide)
- [Ubuntu Terminal Configuration](#ubuntu-terminal-configuration)
- [Shell Prompt Theme](#shell-prompt-theme)
- [Shell Scripts and Aliases](#shell-scripts-and-aliases)
    - [Shell Commands](#shell-commands)
    - [Shell Scripts](#shell-scripts)
- [Cheat Sheet - TMux](#cheat-sheet---tmux)
- [Cheat Sheet - Vim](#cheat-sheet---vim)
- [Effective Tmux](#effective-tmux)
- [Effective Vim](#effective-vim)
    - [The Golden Rule](#the-golden-rule)
    - [Workspaces](#workspaces)
    - [Process & Copy Buffer](#process--copy-buffer)
    - [NerdTree](#nerdtree)
    - [fzf-lua](#fzf-lua)
    - [COC](#coc)
    - [JavaScript, TypeScript, React](#javascript-typescript-react)
    - [Fuzzy Find](#fuzzy-find)
    - [Split-Join](#split-join)
    - [Vim Tab Completion](#vim-tab-completion)
- [Cheat Sheet - Shell](#cheat-sheet---shell)
- [Tooling Choices](#tooling-choices)
    - [Vim](#vim)
- [TODO](#todo)

<!-- vim-markdown-toc -->

## Introduction

The goal of this project is to provide a single command which will setup key features of the system. Each feature should be _orthogonal_ and not depend on other features.

## Quick Start

Run the commands below to quickly setup or update a machine. Note that the default behaviour in all cases is to _not_ make any changes unless the user explicitly confirms them.

```sh
# MacOSX only - install command-line tools (so that we have git).
xcode-select --install

# Create a working environment, in my standard format.
mkdir -p ~/repos/github/dwmkerr
cd ~/repos/github/dwmkerr

# Clone the dotfiles - note that a new machine will not have my SSH key
# so this is over https. Once the private files such as SSH keys are copied the
# remote will be updated to use SSH.
git clone https://github.com/dwmkerr/dotfiles.git
cd dotfiles

# Setup the machine - the script will run interactively.
make setup
```

## SSH Keys, GPG Keys and Private Files

SSH Keys, GPG Keys and Private Files (such as cloud configuration files, which contain sensitive information) can be backed up and restored to a folder on AWS.

This means that to transfer sensitive information from one machine to another, you can simple run `backup-private-files` on the source machine, and `restore-private-files` on the target machine.

### Backing Up Private Files

As long as your AWS profile is configured, this is a one-liner:

```sh
make private-files-backup
```

You will be asked for confirmation before backing up any files.

### Restoring Private Files

Assuming you have the AWS CLI, GPG, and pinentry-mac installed (all of which are installed with `make setup`), run the following commands to create a profile (you will need credentials, which should be in the password manager):

```sh
# Restore private files:
make private-files-restore
```

You will be asked for confirmation before restoring any files.

### Configuring Backup and Restore

The following variables can be used to configure the backup and restore process. The values shown are the defaults, so these only need to be changed if you are using a different S3 bucket or AWS profile name.

```sh
# Define the name of the AWS profile used to access the S3 bucket.
# Default is "dwmkerr".
DOTFILES_PRIVATE_PROFILE="dwmkerr" # Use whatever name makes sense for you!
# Define the name of the AWS S3 bucket that stores private files.
# Default is "dwmkerr-dotfiles-private".
DOTFILES_PRIVATE_S3_BUCKET="dwmkerr-dotfiles-private"

# Run AWS configure to create the named profile - you will be asked to provide
# an access key and secret. If this is not setup the backup/restore scripts will
# prompt you to configure.
aws configure --profile 

# Backup private files:
make private-files-backup
```

## MacOS - Manual Steps

The following steps have not yet been automated:

1. Sign into Chrome and setup sync
0. Install and into Bitwarden
0. Open Joplin and enable S3 synchronisation (AWS credentials are in Bitwarden)
1. For `Terminal`, install the profiles under `./terminal` to give the One Dark / One Light themes

### iTerm2 Configuration

Install the profile under `./terminal/dwmkerrj.json` which configures:

- The [One Dark Theme](https://github.com/one-dark/iterm-one-dark-theme)
- The Window to be automatically maximised to full screen
- The Left Alt key to map to `Esc+`

Then for the global preferences, set:

- General: AI - ([API Key](https://platform.openai.com/api-keys)
- General: AI - set the prompt to a value from `prompts`. I find [`iterm2-ai-output-in-vim.txt`](./prompts/iterm2-ai-output-in-vim.txt) the best
- General: Selection - (Enabled) Applications in terminal may access clipboard
- General: Window (Disabled) Native full screen windows
- Keys: HotKey - (Enabled) Show/hide all windows with a system-wide hotkey (⌥ +Space)

---

These steps are work in progress.

0. Restore Parallels virtual machines from backup.
0. Restore the `~/.private/` folder from a secure backup, to bring back project specific secrets.

## Features

Each of the 'features' listed below typically has a `./setup.d/x-<feature-name>.sh` script to _install or upgrade_ the feature. Some also have a `./.shell.d/x-<feature-name>.sh` file which is sourced by interactive shells if commands need to be run on shell startup (such as enabled `pyenv` and similar features. The numbers are used to ensure that if there _are_ dependencies on features, we try and install in the right order.

**Private Files**

Private files, such as GPG and SSH keys can be backed up or restored with the commands below:

```
make private-files-backup
make private-files-restore
```

Shell configuration which is private can be kept in `~/.shell.private.d/` - this folder will be loaded by `~/.shell.sh` but not checked in.

**Package Manager**

- Installs or upgrades [Homebrew](https://brew.sh/) on OSX.
- Updates `apt` on Ubuntu.
- Installs and updates `snap` on Ubuntu.

**OSX Configuration**

Various preferences for OSX, such as showing the path bar on the Finder windows, smaller icons, etc.

**Git**

Sets up `gnupg` and the `git` user settings.

**Node**

Sets up `nvm` (Node Version Manager) and the current LTS version of node.

**Python**

Sets up `pyenv` (Python Environment Manager) and `python3`.

**Ruby**

Sets up `rvm` (Ruby Version Manager) and `ruby`.

**Golang**

Sets up `golang` and `$GOPATH`.

**Vim**

Sets up `vim` and vim config file. Plugins are installed with `PlugInstall`.

**TMux**

This installs `tmux` and the Tmux Plugin Manager.

**Shell**

This installs `bash`, `zsh` and sets `zsh` as the default shell for the user. Sets the command prompt and sources the `.shell.sh` file.

Installs On My Zsh, which I use for themes and some conveniences, and copies over the zsh themes.

To enable features to be used in shells, the shell configuration file will source our special `shell.sh` file. This file then goes and sources the appropriate files from `~/.shell.d`.

**OSX Applications**

Many applications I used, such as WhatsApp, Visual Studio Code, T-Mux.

This also installs common CLI applications, such as `tree`, as well as GNU tools (`coretools`, `gsed` etc).

**Commandline Tools**

`ag` is setup and will use a global ignore file at `~/.ignore`. `vim-ack` also uses this file.

**Claude Code**

Configuration for Claude Code CLI is managed via symlinks. Settings are stored in `claude/settings.json` and linked to `~/.claude/settings.json`.

To view or edit Claude Code settings, use the `/config` command within Claude Code.

## Developer Guide

There's not much to say really, just follow the principles below:

- Try to keep features _orthogonal_, so that they don't rely on each other
- Try to remember to support `bash` as well as `zsh`
- Try to remember to support Linux as well as MacOSX

## Ubuntu Terminal Configuration

Set the [OneDark Theme](https://github.com/denysdovhan/one-gnome-terminal) with:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"
```

## Shell Prompt Theme

The [`set_ps1.sh`](./shell.d/set_ps1.sh) can be used to set `PS1` styles:

```
$ set_ps1 debian
```

The `PS1` is converted to Z-Shell format if the current shell is `zsh`. My current 'default' theme is named `dwmkerr`.

## Shell Scripts and Aliases

The following features are loaded as part of my configuration. Check the link to the source if you'd like to copy over an individual feature for your own use.

### Shell Commands

The following shell commands are setup:

| Command                                   | Usage                                                               |
|-------------------------------------------|---------------------------------------------------------------------|
| **Quick Aliases**                         | [`shell.d/aliases.sh`](./shell.d/aliases.sh)                        |
| [`serve`](./shell.d/aliases.sh)           | Serve the current folder over HTTP on port 3000.                    |
| [`vinilla`](./shell.d/aliases.sh)         | Open `vi` without loading the `vimrc` (i.e. vanilla configuration). |
| **Basic Functions**                       |                                                                     |
| [`eachdir`](./shell.d/functions.sh)       | Run a command in each child directory.                              |
| [`D`](./shell.d/functions.sh)             | Get the date in ISO86091 format (e.g. `2021-04-24`).                |
| [`mkd`](./shell.d/functions.sh)           | Make a directory, using `-p` and `cd` into it.                      |
| [`restart_shell`](./shell.d/functions.sh) | Restart the current shell process, useful when profile changes.     |
| [`revcut`](./shell.d/functions.sh)        | Cut, but in reverse (i.e. from the last to the first delimiter).    |
| [`toggle_bak`](./shell.d/functions.sh)    | Toggle *.bak off or on a file (useful to disable config etc).    |
| **Git Functions**                         |                                                                     |
| [`ghclone`](./shell.d/git.sh)             | Clone from GitHub, e.g: `ghclone dwmkerr/effective-shell`.          |

### Shell Scripts

| Script                      | Usage                                                                            |
|-----------------------------|----------------------------------------------------------------------------------|
| `./scripts/test-shell.d.sh` | Source each `./shell.d` file in turn, time result. Good for checking for errors. |

## Cheat Sheet - TMux

| Command                                   | Usage                                                            |
|-------------------------------------------|------------------------------------------------------------------|
| **Sessions**                              |                                                                  |
| `tmux detach -E 'bash --noprofile --norc` | Detach the current session and open a vanilla shell.             |
|-------------------------------------------|------------------------------------------------------------------|
| `<leader> R`                              | Reload Tmux configuration (i.e. source the `~/.tmux.conf` file). |
| `man tmux`                                | Get help on commands.                                            |
| `<leader> ?`                              | Get help on commands.                                            |
| `Ctrl + h/j/k/l`                          | Navigate splits (vim aware)                                      |
| `Meta + h/l`                              | Move through tabs.                                               |
| `Ctrl + Meta + h/j/k/l`                   | Move through tabs.                                               |
| `move-window -r`                          | Re-order the tab numbers (useful if there are gaps).             |
| `<leader> / S`                            | Show Sessions with window preview, hit `x` to delete.            |
| `<leader> / $`                            | Rename session.                                                  |
| `new -s <name>`                           | New session with name.                                           |
| `<leader> / Ctrl+S`                       | Save Tmux Session                                                |
| `<leader> / Ctrl+R`                       | Restore Tmux Session                                             |
| `<leader> /`                              | Last split                                                       |
| `<leader> {`                              | Swap pane left                                                   |
| `<leader> }`                              | Swap pane right                                                  |
| `<leader>. <session-name>:<pane number>`  | Move a pane to a session.                                        |


## Cheat Sheet - Vim

Here's a quick reference. My `<Leader>` is `\`, so I've written shortcuts as `\x` rather than `<Leader>x` for brevity. I still need to port the above to the structure below.

| Command                              | Usage                                                                                                                             |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| **Custom Commands**                  |                                                                                                                                   |
| `<leader>t`                          | Open current file in NERDTree.                                                                                                    |
| `<leader>w`                          | Write buffer.                                                                                                                     |
| `<leader>\\`                         | Open buffer in new tab.                                                                                                           |
| `<leader>d`                          | Open diffview (git diff viewer).                                                                                                  |
| `<leader>D`                          | Open file history for all files.                                                                                                  |
| `<leader>dh`                         | Open file history for current file.                                                                                               |
| `<leader>dc`                         | Close diffview.                                                                                                                   |
| `<leader>t`                          | Show current buffer in NERDTree.                                                                                                  |
| `<leader>F`                          | Toggle focus mode.                                                                                                                |
| **Other Commands**                   |                                                                                                                                   |
| `\[<Space>`                          | blank line above                                                                                                                  |
| `]<Space>`                           | blank line below                                                                                                                  |
| `sj`                                 | Splitjoin down (i.e. split a line downwards).                                                                                     |
| `sk`                                 | Splitjoin up (i.e. join a line upwards).                                                                                          |
| `:Tabularize /=`                     | Line up selection, using '='                                                                                                      |
| **Navigation**                       |                                                                                                                                   |
| `gd`                                 | Where possible, will go to a local definition. Supercharged by vim-coc.                                                           |
| `gd`                                 | https://vi.stackexchange.com/questions/42414/for-vim-and-specifically-coc-vim-is-it-idomatic-to-use-gd-to-open-a-link/42415#42415 |
| `gf`                                 | Open file under cursor.                                                                                                           |
| `gx`                                 | Open link or address under cursor.                                                                                                |
| **Spelling**                         |                                                                                                                                   |
| `]s` and `[s`                        | Next/Previous spelling error.                                                                                                     |
| `z=` and `zg`                        | Check dictionary / add to dictionary.                                                                                             |
| **Markdown**                         | Provided by `vim-markdown`                                                                                                        |
| `]]` and `[[`                        | Next and previous headers.                                                                                                        |
| `gx`                                 | Open link in standard editor.                                                                                                     |
| **Focus**                            | From `vim-goyo` and `vim-limelight`                                                                                               |
| `:Goyo`                              | Enter focus mode.                                                                                                                 |
| `:Limelight 0.8` and `:Limelight!`   | Go into limelight, 80% ultra focus, and toggle limelight.                                                                         |
| `let g:limelight_paragraph_span = 1` | Span more paragraphs in limelight.                                                                                                |
| **Markdown Tables**                  |                                                                                                                                   |
| `\tm`                                | Enter/Exit 'table mode', which will dynamically format markdown tables.                                                           |
| `ci｜`                               | Example of the `｜` motion for cells - i.e. 'change-in-cell'.                                                                     |

Note: including the vertical pipe `|` in the table above would cause rendering issues. So instead, the unicode character `｜` is used to illustrate the commands. Do not use the unicode character, use the normal ASCII 0x7C character.

Other useful stuff:

- By default vim doesn't treat `-` as part of a word (for motions, search, autocomplete, etc). Use `set iskeyword+=-` to change this. This is the changed in my `vimrc` but a useful one to remember.

## Effective Tmux

Most essential commands:

- Option - h/l - move left/right between tabs


## Effective Vim

Here's some of the stuff I find most useful.

### The Golden Rule

If you repeat yourself or do dumb formatting crap, find the idiomatically correct way to do something or use a plugin. Always look up native ways first.

### Workspaces

If you have a monorepo with folders like `backend` and `frontend`, you need Vim to understand that each is a 'workspace'. This is handled with config like:

```vim
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'pyproject.toml', 'setup.cfg']
```

Check with:

```vim
:CocList folders
```

See: https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders

### Process & Copy Buffer

Grep all lines with `secret` and put on clipboard:

```vim
:!cat % | grep secret | pbcopy
```

This example could be used to grab all references to GitHub secrets from a buffer.

### NerdTree

- `C-n` to toggle/focus the tree
- `R` in the tree to refresh
- `<leader>t` to 'tree' the current file, i.e. show the current buffer in NerdTree.

### fzf-lua

- `<leader>space` buffers
- `<leader>f` files
- `<leader>g` ripgrep (works amazingly)

### COC

I've barely scratched the surface and will force myself to learn more.

- `<leader>rn` rename
- `gd` go to definition, `gr` go to references
- `<leader>A` show code actions, e.g. import missing reference
- `<leader>qf` apply default code action, e.g. import missing reference

### JavaScript, TypeScript, React

I use `vim-polyglot` and `vim-coc` with `vim-tsserver` - this seems to cover most of my needs without any additional plugins.

**Potential Improvements**

- I'm looking into `coc-prettier` etc to make sure that auto formatting will happen if/when needed when typing, rather than blindly on save
- Eliminate unneeded plugins and conf

### Fuzzy Find

I'm currently using [`fzf-lua`](https://github.com/ibhagwan/fzf-lua) after spending a few years on [`fzf.vim`](https://github.com/junegunn/fzf.vim). It seems lightening fast but a little harder to decipher some of the documentation. The main customisations andre:

### Split-Join

I find the `sj` and `sk` commands invaluable, until something like this becomes native it's a super useful plugin.

### Vim Tab Completion

COC is used - it's basically setup like VS Code - tab selects the first option. Then `<C-n>` and `<C-p>` to cycle (or up/down).

## Cheat Sheet - Shell

These are just some common commands I often forget:

| Command      | Usage                                                                                     |
|--------------|-------------------------------------------------------------------------------------------|
| `tput cvvis` | Show the cursor. Useful if it disappears when a command hides it and fails to restore it. |

## Tooling Choices

### Vim

*Why Vim Plug over Vundle?*

I was impressed enough with the comments on [this post](https://erikzaadi.com/2016/02/11/moving-from-vundle-to-vim-plug/) to make the switch, particularly as [coc](https://github.com/neoclide/coc.nvim) doesn't support Vundle, meaning I had to give Plug a try.

## TODO

- [ ] fix: correct slow terminal startup
- [ ] feat: iTerm OpenAI
- [ ] fix: check iTerm restore window size
- [ ] fix: Bash Tab Completion: https://stackoverflow.com/questions/7179642/how-can-i-make-bash-tab-completion-behave-like-vim-tab-completion-and-cycle-thro
- [ ] feat: install patched nerdfont https://github.com/ryanoasis/nerd-fonts/releases
- [ ] Autocomplete for docker/k8s is still not properly setup.
- [ ] osx - mas (mac app store CLI: brew)
- [ ] osx - set icon
- [ ] iterm - set colour scheme
- [ ] terminal - raise bug on broken colours
- [ ] node is not sourcing properly
- [ ] fix: long urls in tmux work if they span lines - *unless* they are in `vim`
- [ ] vi: decide on vi/nvim
- [ ] Note; javascript projects can get CoC support by adding a jsconfig.json file as per https://code.visualstudio.com/docs/languages/jsconfig then :CocInstall coc-tsserver
- [ ] Note; golang projects can get CoC support by adding :CocInstall coc-go
- [ ] update all to neovim
- [ ] todo: document shell shortcuts (repos/dwmkerr)
