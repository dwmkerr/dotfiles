#!/usr/bin/env bash

# Wrap 'git' with 'hub' - if we have hub installed.
if [ -x "$(command -v hub)" ]; then
    eval "$(hub alias -s)"
fi

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

# Colour constants for nicer output.
GREEN='\033[0;32m'
RESET='\033[0m'

# Push the current branch to origin, set upstream, open the PR page if possible.
# Inspired by: https://gist.github.com/tobiasbueschel/ba385f25432c6b75f63f31eb2edf77b5
# How to get the current branch: https://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
# How to open the browser: https://stackoverflow.com/questions/3124556/clean-way-to-launch-the-web-browser-from-shell-script
gpr() {
    # Get the current branch name, or use 'HEAD' if we cannot get it.
    branch=$(git symbolic-ref -q HEAD)
    branch=${branch##refs/heads/}
    branch=${branch:-HEAD}

    # Pushing take a little while, so let the user know we're working.
    echo "Opening pull request for ${GREEN}${branch}${RESET}..."

    # Push to origin, grabbing the output but then echoing it back.
    push_output=`git push origin -u ${branch} 2>&1`
    echo ""
    echo ${push_output}

    # If there's anything which starts with http, it's a good guess it'll be a
    # link to GitHub/GitLab/Whatever. So open it.
    link=$(echo ${push_output} | grep -o 'http.*' | sed -e 's/[[:space:]]*$//')
    if [ ${link} ]; then
        echo ""
        echo "Opening: ${GREEN}${link}${RESET}..."
        python -mwebbrowser ${link}
    fi
}
