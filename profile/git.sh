#!/usr/bin/env bash

# Wrap 'git' with 'hub' - if we have hub installed.
if [ -x "$(command -v hub)" ]; then
    eval "$(hub alias -s)"
fi

# ---
#
# Git Commands
#
# ---

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

# git push that directly opens merge request in GitLab
gpmr() {
  # push to current branch to remote origin
  gitOutput=`git push origin $(git_current_branch) 2>&1` && \
  # get URL for merge request
  mrURL=`echo $gitOutput | awk '/remote:   http/ {print $2}'` && \
  # open new merge request
  open -a Google\ Chrome $mrURL
}

# git push that directly opens merge request in GitLab
gpmr() {
  # push to current branch to remote origin
  gitOutput=`git push origin $(git_current_branch) 2>&1` && \
  # get URL for merge request
  mrURL=`echo $gitOutput | awk '/remote:   http/ {print $2}'` && \
  # open new merge request
  open -a Google\ Chrome $mrURL
}

# How to get the current branch: 
# 
gpr() {
    # Get the current branch name.
    branch=$(git symbolic-ref -q HEAD)
    branch=${branch##refs/heads/}
    branch=${branch:-HEAD}

    # Push to origin, grabbing the output.
    push_output=`git push origin -u $(branch) 2>&1`

    # Show the output, so that it is clear to the user what is happening.
    echo $(push_output)

    # If there's anything which starts with http, it's a good guess it'll be a
    # link to GitHub/GitLab/Whatever. So open it.
    mrURL=`echo $gitOutput | awk '/remote:   http/ {print $2}'` && \
        # open new merge request
  open -a Google\ Chrome $mrURL
}
