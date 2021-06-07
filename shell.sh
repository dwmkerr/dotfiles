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

# Import everything from the .shell.d folder.
for file in $HOME/.shell.d/*; do
    [ -e "$file" ] || continue
    source "$file"
done

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d $HOME/.shell-private.d ]]; then
    for private in $HOME/.shell-private.d/*; do
        [ -e "$private" ] || continue
        source "$private"
    done
fi

# Add support to the terminal for colours.
#   See: https://github.com/nathanbuchar/atom-one-dark-terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# For any programs which need an editor, we use vim.
export EDITOR=vim

# We're an xterm 256bit colour terminal, just in case anyone asks...
export TERM="xterm-256color"
alias tmux="tmux -2"

if [[ $COLORTERM = gnome-* && $TERM = xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
fi

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
    # Note that this is based on Bash Completion 2, which requires Bash 4 or onwards.
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/shell.d/bash_completion.sh" ]] && . "/usr/local/etc/shell.d/bash_completion.sh"
    if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
elif [ -n "$ZSH_VERSION" ]; then
    # Source zsh auto-completions.
    fpath=($HOME/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i
fi

# Set the PS1 theme.
