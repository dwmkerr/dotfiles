# Ensure tmux is up to date.
if ask "$os: Install/Update tmux?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Updating tmux..."
        brew install tmux
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        apt-get update && apt-get install tmux
    fi
    ensure_symlink "$(pwd)/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Setup the tmux plugin manager if it is not already installed.
    if [[ ! -d ~/.tmux/plugins/tpm ]]; then
        echo "$os: Setting up TPM..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
fi

# TODO: dedupe.

# Install tmux.
TMUX_VERSION=2.6
echo "$os: Checking for tmux..."
tmux_installed=$(command -v tmux)
tmux_version=$(tmux -V > /dev/null 2>&1)
if [[ ${tmux_installed} != 0 ]]; then
    if ask "$os: tmux ${TMUX_VERSION} is not installed. Install it?" Y; then
        if [[ "$os" == "osx" ]]; then
            echo "$os: Installing tmux ${TMUX_VERSION}..."
            brew install tmux
            ln -s "$(pwd).tmux.conf" "~/.tmux.conf"
        elif [[ "$os" == "ubuntu" ]]; then
            echo "$os: Installing tmux ${TMUX_VERSION}..."
            # Get the build dependencies.
            sudo apt-get install -y wget tar libevent-dev libncurses-dev
            TMUX_DIR="${HOME}/temp/tmux-src"
            mkdir -p "${TMUX_DIR}"
            wget -P "${TMUX_DIR}" -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
            tar xzf "${TMUX_DIR}/tmux-${TMUX_VERSION}.tar.gz" -C "${TMUX_DIR}"
            pushd "${TMUX_DIR}"/tmux-*
            ./configure && make -j"$(nproc)" && sudo make install
            popd
            rm -rf ~/temp/tmux-src
            tmux -V
        fi

        # Now install the tmux plugin manager, then install the plugins.
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/bin/install_plugins
    fi
fi
