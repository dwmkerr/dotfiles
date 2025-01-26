#!/usr/bin/env bash

# Wrap 'git' with 'hub' - if we have hub installed.
if [ -x "$(command -v hub)" ]; then
    eval "$(hub alias -s)"
fi

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

# Push to origin. Use it all the time innit?
alias gpo='git push --set-upstream origin $(git_current_branch)'
