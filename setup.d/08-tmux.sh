# Ensure tmux is up to date.
if ask "$os: Install/Update tmux?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Updating tmux..."
        brew install tmux
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        sudo apt-get install -y tmux
    fi
    ensure_symlink "$(pwd)/tmux/tmux.conf" "$HOME/.tmux.conf"
fi

# Install the TMux Plugin Manager.
if ask "$os: Install/Update tmux plugin manager? Warning, this will overwrite existing plugins?" Y; then
    # Setup the tmux plugin manager if it is not already installed.
    rm -rf ~/.tmux/plugins/tpm  || true
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Install tmux plugins.
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
fi
