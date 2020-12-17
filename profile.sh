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

# Import everything from the .profile.d folder.
for file in $HOME/.profile.d/*; do
    [ -e "$file" ] || continue
    source "$file"
done

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d $HOME/.private ]]; then
    for private in $HOME/.private/*; do
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

# Set some variables for prompt colours.
set_ps1 () {
    local darkgray="\e[0;30m"  # Dark Gray
    local darkgraybold="\e[1;30m" # Bold Dark Gray
    local red="\e[0;31m" # Red
    local redbold="\e[1;31m" # Bold Red
    local green="\e[0;32m" # Green
    local greenbold="\e[1;32m" # Bold Green
    local yellow="\e[0;33m" # Yellow
    local yellowbold="\e[1;33m" # Bold Yellow
    local blue="\e[0;34m" # Blue
    local bluebold="\e[1;34m" # Bold Blue
    local purple="\e[0;35m" # Purple
    local purplebold="\e[1;35m" # Bold Purple
    local turquoise="\e[0;36m" # Turquoise
    local turquoisebold="\e[1;36m" # Bold Turquoise
    local lightgray="\e[0;37m" # Light Gray
    local lightgraybold="\e[1;37m" # Bold Light Gray
    local bg_darkgray="\e[40m" # Dark Gray (Background)
    local bg_red="\e[41m" # Red (Background)
    local bg_green="\e[42m" # Green (Background)
    local bg_yellow="\e[43m" # Yellow (Background)
    local bg_blue="\e[44m" # Blue (Background)
    local bg_purple="\e[45m" # Purple (Background)
    local bg_turquoise="\e[46m" # Turquoise (Background)
    local bg_lightgray="\e[47m" # Light Gray (Background)

    # Setup the PS1 line if we are using bash.
    if [ -n "$BASH_VERSION" ]; then
        # Host, User, Working Directory
        # export PS1="\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;28m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"
        # User, Working Directory. A little cleaner than the above.
        export PS1="\[$(tput sgr0)\]\[\033[38;5;28m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"
    fi
}
set_ps1

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
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
    if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
elif [ -n "$ZSH_VERSION" ]; then
    # Source zsh auto-completions.
    fpath=($HOME/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i
fi
