# This function pushes the current branch to 'origin'. If a web address is shown
# in the output, it opens it up. On GitHub, GitLab and BitBucket, this means it
# will open the pull request for you!
#
# This is also part of the 'dotfiles' configration at:
#   github.com/effective-shell/dotfiles

# Push the current branch to origin, set upstream, open the PR page if possible.
# Inspired by: https://gist.github.com/tobiasbueschel/ba385f25432c6b75f63f31eb2edf77b5
# How to get the current branch: https://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
# How to open the browser: https://stackoverflow.com/questions/3124556/clean-way-to-launch-the-web-browser-from-shell-script
gpr() {
    # Colour constants for nicer output.
    green='\e[0;32m'
    reset='\e[0m'

    # Get the current branch name, or use 'HEAD' if we cannot get it.
    branch=$(git symbolic-ref -q HEAD)
    branch=${branch##refs/heads/}
    branch=${branch:-HEAD}

    # Pushing take a little while, so let the user know we're working.
    printf "Opening pull request for ${green}${branch}${reset}...\n"

    # Push to origin, grabbing the output but then echoing it back.
    push_output=`git push origin -u ${branch} 2>&1`
    printf "\n${push_output}\n"

    # If there's anything which starts with http, it's a good guess it'll be a
    # link to GitHub/GitLab/Whatever. So open the first link found.
    link=$(echo ${push_output} | grep -o 'http.*' | head -n1 | sed -e 's/[[:space:]]*$//')
    if [ ${link} ]; then
        printf "\nOpening: ${green}${link}${reset}...\n"
        python -mwebbrowser ${link}
    fi
}
