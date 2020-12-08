# Setup ag.
if ask "$os: Install/Configure The Silver Searcher?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install the_silver_searcher
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        apt-get install -y silversearcher-ag
    fi
fi

# Fuzzy finder.
if [[ "$os" == "osx" ]]; then
    echo "$os: Installing fzf with brew..."
    # Install fzf, then setup the auto-completion.
    brew install fzf
    $(brew --prefix)/opt/fzf/install
elif [[ "$os" == "ubuntu" ]]; then
    echo "Not yet implemented."
    exit 1
fi
