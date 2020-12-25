# Setup ag.
if ask "$os: Install/Configure The Silver Searcher?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install the_silver_searcher
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        apt-get install -y silversearcher-ag
    fi

    # We refer to this global ag ignore file in the profile.d/aliases.sh file,
    # because `ag` is an alias for using `ag` with this file.
    ensure_symlink "$(pwd)/ag/ignore" "$HOME/.ignore"
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

# Setup wiktionary cli.
if ask "$os: Install wped/wikt?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/local/bin/wped
        sudo ln -s /usr/local/bin/wped /usr/local/bin/wikt
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/bin/wped
        sudo ln -s /usr/bin/wped /usr/bin/wikt
    fi
fi

# Setup Kubectl
if ask "$os: Install kubectl?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install kubectl
    elif [[ "$os" == "ubuntu" ]]; then
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl
    fi
fi
