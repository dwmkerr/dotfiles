ghopen() {
    # Get the origin for the current repo.
    local origin=$(git remote get-url origin 2> /dev/null)

    # Bail if we're not in a github repo.
    if [[ ($? -ne 0) || ("${origin}" != *github*) ]]; then
        echo "current dir '$(basename "${PWD}")' is not in a github repo..."
        return
    fi

    # The origin probably looks like this:
    # git@github.com:dwmkerr/effective-shell.git
    # The org/repo is everything after the colon and before '.git'.
    local org_repo=$(echo "${origin%.git}" | cut -f2 -d:)
    local url="http://github.com/${org_repo}"

    # Let the user know what we're opening, formatting org/repo in green, open.
    echo -e "opening github.com/\e[32m${org_repo}\e[0m"
    python3 -c "import webbrowser; webbrowser.open_new_tab('${url}')"
}
