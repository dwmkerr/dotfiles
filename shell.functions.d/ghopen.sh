ghopen() {
    local origin
    origin=$(git remote get-url origin 2>/dev/null)

    if [[ $? -ne 0 || "${origin}" != *github* ]]; then
        echo "current dir '$(basename "${PWD}")' is not in a github repo..."
        return 1
    fi

    local org_repo
    if [[ "${origin}" == git@* ]]; then
        # SSH: git@github.com:dwmkerr/dotfiles.git
        org_repo="${origin#*:}"
    else
        # HTTPS: https://github.com/dwmkerr/dotfiles.git
        org_repo="${origin#*github.com/}"
    fi
    org_repo="${org_repo%.git}"

    local url="https://github.com/${org_repo}"

    echo -e "opening github.com/\e[32m${org_repo}\e[0m"
    python3 -c "import webbrowser; webbrowser.open_new_tab('${url}')"
}
