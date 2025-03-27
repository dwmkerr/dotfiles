# shell.sh
# 
# Setup shell enviroment suitable for Bash and Zsh.
# This file should be sourced at the end of ~/.bashrc or ~/.zshrc

# If we are not running interactively do not continue loading this file.
case $- in
    *i*) ;;
      *) return;;
esac

# Set our preferred editor (both visual and line mode to be safe).
export EDITOR="vi"
export VISUAL="vi"

# Setup the path. Add local bin folders.
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Set the local shell.
# Not good as it is not respecting what we use in setup.sh but still need a way
# to make this work (or fix the symlink issue).
if [ -e "/usr/local/bin/bash" ]; then
    export SHELL="/usr/local/bin/bash"
fi

# If we have homebrew, update the PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Set a shell option but don't fail if it doesn't exist!
safe_set() { shopt -s "$1" >/dev/null 2>&1 || true; }

# Set some options to make working with folders a little easier. Note that we
# send all output to '/dev/null' as startup files should not write to the
# terminal and older shells might not have these options.
safe_set autocd         # Enter a folder name to 'cd' to it.
safe_set cdspell        # Fix minor spelling issues with 'cd'.
safe_set dirspell       # Fix minor spelling issues for commands.
safe_set cdable_vars    # Allow 'cd varname' to switch directory.

# Uncomment the below if you want to be able to 'cd' into directories that are
# not just relative to the current location. For example, if the below was
# uncommented we could 'cd my_project' from anywhere if 'my_project' is in
# the 'repos' folder.
# CDPATH="~:~/repos"

# Configure the history to make it large and support multi-line commands.
safe_set histappend                  # Don't overwrite the history file, append.
safe_set cmdhist                     # Multi-line commands are one entry only.
PROMPT_COMMAND='history -a'          # Before we prompt, save the history.
HISTSIZE=10000                       # A large number of commands per session.
HISTFILESIZE=100000                  # A huge number of commands in the file.
# HISTCONTROL="ignorespace:ignoredup" # Ignore starting with space or duplicates?
# export HISTIGNORE="ls:history"     # Any commands we want to not record?
# HISTTIMEFORMAT='%F %T '            # Do we want a timestamp for commands?

# Add support to the terminal for colours.
#   See: https://github.com/nathanbuchar/atom-one-dark-terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# We're an xterm 256bit colour terminal, just in case anyone asks...
export TERM="xterm-256color"
alias tmux="tmux -2"

if [[ $COLORTERM == gnome-* && $TERM == xterm ]]  && infocmp gnome-256color >/dev/null 2>&1; then export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then export TERM=xterm-256color
fi

# Set the language. This is required for some Python tools.
# Fix 'perl: warning: Setting locale failed.'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Start tmux - as long as it is not already started and as long as we are not in
# a vscode terminal. By this point in the script we know we are in an
# interactive shell.
# https://askubuntu.com/questions/1021553/can-i-check-if-the-terminal-was-started-by-visual-studio-code
# Similar for Android:
# https://youtrack.jetbrains.com/articles/IDEA-A-19/Shell-Environment-Loading
if [ -x "$(command -v "tmux")" ]; then
    IS_IN_IDE=0
    if [[ "$TERM_PROGRAM" == "vscode" || -n "$INTELLIJ_ENVIRONMENT_READER" ]]; then
        IS_IN_IDE=1
    fi
    if [ "${IS_IN_IDE}" != "1" ]; then
        # We *are* interactive, and we are not in an IDE, so if we are not already
        # in tmux, start it.
        [ -z "$TMUX" ] && { tmux attach || exec tmux new-session && exit;}
    fi
fi

# Load auto-completions depending on our shell.
if [ -n "$BASH_VERSION" ]; then
    # Source auto-completions from the Mac and Linux locations.
    # Note that this is based on Bash Completion 2, which requires Bash 4 or onwards.
    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    [[ -f /etc/bash_completion ]] && . /etc/bash_completion
elif [ -n "$ZSH_VERSION" ]; then
    # Source zsh auto-completions.
    fpath=($HOME/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i
fi

# Import all shell functions and shell.d files.
for file in $HOME/.shell.functions.d/*; do
    [ -e "$file" ] || continue
    source "$file"
done
for file in $HOME/.shell.d/*; do
    [ -e "$file" ] || continue
    source "$file"
done

# Import everything from the .shell.private.d folder.
if [ -d $HOME/.shell.private.d ]; then
    for file in $HOME/.shell.private.d/*; do
        [ -e "$file" ] || continue
        source "$file"
    done
fi

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d $HOME/.shell-private.d ]]; then
    for private in $HOME/.shell-private.d/*; do
        [ -e "$private" ] || continue
        source "$private"
    done
fi

# If it exists, source my work in progress 'context' project.
context_path="${HOME}/repos/github/dwmkerr/context/context.sh"
if [ -e "${context_path}" ]; then
    source "${context_path}"
fi

# Set my preferred prompt.
set_ps1 "dwmkerr" || true
