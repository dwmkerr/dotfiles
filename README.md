# dotfiles

My setup for MacOSX and Linux, with a focus on terminal, editor, shell, programming environments etc.

**Screenshot on MacOSX**

![Screensho: MacOSX](./docs/screenshot_macosx.png)

**Screenshot on Ubuntu**

![Screenshot: Ubuntu](./docs/screenshot_ubuntu.png)

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Installing or Updating](#installing-or-updating)
* [Shell Commands](#shell-commands)
* [Cheat Sheet - TMux](#cheat-sheet---tmux)
* [Cheat Sheet - Vim](#cheat-sheet---vim)

<!-- vim-markdown-toc -->

## Introduction

The goal of this project is to provide a single command which will setup key features of the system. Each feature should be _orthogonal_ and not depend on other features. Each feature should be _optional_ and installed only if the user specifies.

The following is set up:

- `zsh` as the default shell
- `tmux` for terminal multiplexing, with my preferred theme and settings
- `vim` as the default editor, with my preferred theme and settings
- `~/.private` as a folder excluded from version control, the contents of which are always loaded on shell startup (ideal for project specific secrets etc)
- `~/.profile` as a version controlled folder, the contents of which are always loaded on shell startup

## Installing or Updating

First clone the repo:

```sh
git clone git@github.com:dwmkerr/dotfiles
```

Then run setup:

```sh
./setup.sh
```

A variety of tools required to support common coding requirements (Node Version Manager, Golang, Docker etc) are installed.

## Shell Commands

The following shell commands are setup:

| Command | Usage |
|---------|-------|
| `serve` | Serve the current folder over HTTP on port 3000. |
| `restart-shell` | Restart the current shell, reloading `~/.private`, `~/.profile` etc.

## Cheat Sheet - TMux

- Ctrl+B / Ctrl+S - Save Tmux Session
- Ctrl+B / Ctrl+R - Restore Tmux Session
- Ctrl+h/j/k/l - Navigate splits (vim aware)
- Ctrl+/ - Last split
- Ctrl+B h - Move window left
- Ctrl+B l - Move window right
- Ctrl+B { - Swap pane left
- Ctrl+B } - Swap pane right

## Cheat Sheet - Vim

- `[<Space>` - blank line above
- `]<Space>` - blank line below
- `sj` - Splitjoin down (i.e. split a line downwards).
- `sk` - Splitjoin up (i.e. join a line upwards).
- `<leader>r` - Open current file in NERDTree.
- `<leader>w` - Write buffer.
- `<leader>\\` - Open buffer in new tab.
- `<leader>d` - Open word under cursor in Dash.
- `<leader>t` - Show current buffer in NERDTree.
- `:Tabularize /=` - Line up selection, using '='
- `gd` - where possible, will go to a local definition.
