# Wrap 'git' with 'hub' - if we have hub installed.
if [ -x "$(command -v hub)" ]; then
    eval "$(hub alias -s)"
fi


# Basic alises based on the 'git' OMZ plugin.
# For reference, see:
#   https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
git_current_branch() {
    git branch --show-current
}
# Basic alises based on the 'git' OMZ plugin.
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
alias ga='git add'
alias gd='git diff'
alias gf='git fetch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit --verbose'
alias gst='git status'
alias gcm='git checkout main || git checkout master'
alias gl='git pull'
gpo() {
    git push --set-upstream origin "$(git_current_branch)"
}

alias gpo='git push --set-upstream origin'

# My own personal git functions or shorthands.

# Clone from GitHub.
ghclone() {
    git clone git@github.com:$1
}

# Not really a command, but a much nicer version of git branch.
# Source: https://stackoverflow.com/questions/2514172/listing-each-branch-and-its-lastevisions-date-in-git
alias gbranch='for k in `git branch -l | \
    perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; \
    do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | \
    head -n 1`\\t$k; done | sort -r'
alias gbranchr='for k in `git branch -r | \
    perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; \
    do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | \
    head -n 1`\\t$k; done | sort -r'

