# IMPORTANT:
#
# There is no shebang in this script. This will be sourced from the user's
# current shell. So we might be using bash, zsh, etc. If we use an explicit
# shebang, we can guarantee the shell which will interpret the script, but
# cannot conditionally set up the user's _current_ shell.
#
# See the section near the end where we are sourcing auto-complete settings for
# an example of why this matters. If we use a shebang in this script, we'll only
# ever source auto-completions for the shell in the shebang.

#!/usr/bin/env bash

# Import everything from the .profile folder.
for file in ~/.profile/*; do
    [ -e "$file" ] || continue
    source "$file"
done

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d ~/.private ]]; then
    for private in ~/.private/*; do
        [ -e "$private" ] || continue
        source "$private"
    done
fi

# Bit of an issue with this - if we are in zsh we need zsh auto-completion, but
# we're using a bash shebang...

# If kubectl is installed, enable auto completion.
# if [ -x "$(command -v kubectl)" ]; then
  # source <(kubectl completion zsh)
# fi

# Add support to the terminal for colours.
#   See: https://github.com/nathanbuchar/atom-one-dark-terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# For any programs which need an editor, we use vim.
export EDITOR=vim

# We're an xterm 256bit colour terminal, just in case anyone asks...
export TERM="xterm-256color"
alias tmux="tmux -2"

# Current preferred prompt.
export PS1="\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;28m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"

# Set the language. This is required for some Python tools.
# Fix 'perl: warning: Setting locale failed.'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# If we are not running in interactive mode, we're done.
[[ $- != *i* ]] && return

# We *are* interactive, so if we are not already in tmux, start it.
[[ -z "$TMUX" ]] && exec tmux

# Load auto-completions depending on our shell.
if [ -n "$BASH_VERSION" ]; then
    # Source auto-completions from the Mac and Linux locations.
    if [ -f /usr/local/etc/bash_completion ]; then . /usr/local/etc/bash_completion; fi
    if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
elif [ -n "$ZSH_VERSION" ]; then
    # Source zsh auto-completions.
    fpath=(~/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i
fi
