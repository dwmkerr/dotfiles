# Ensure that terminals and tmux use 256 colour mode.
export TERM="screen-256color"
alias tmux="tmux -2"

# Configure NVM
export NVM_DIR="/Users/dave/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Current preferred prompt.
export PS1="\[\033[38;5;10m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;28m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"

# Projects
alias lode="cd ~/repositories/github/dwmkerr/lode"
