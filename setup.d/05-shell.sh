# Move to zsh.
echo "$os: checking shell..."
if [[ ! "$SHELL" =~ zsh$ ]]; then
    if ask "$os: Shell is '$SHELL', change to zsh?" Y; then
        if [[ "$os" == "osx" ]]; then
            echo "$os: Installing zsh..."
            brew install zsh zsh-completions
            # Make sure the installed zsh path is allowed in the list of shells.
            echo "$(which zsh)" >> sudo tee -a /etc/shells
            chsh -s "$(which zsh)"
        elif [[ "$os" == "ubuntu" ]]; then
            echo "$os: Installing zsh..."
            sudo apt-get update -y
            sudo apt-get install -y zsh
            chsh -s "$(which zsh)"
        fi

        # After we have installed zsh, create a link to our zshrc.
        echo "$os: setting ~/.zshrc link..."
        ensure_symlink "$(pwd)/zsh/zshrc" "$HOME/.zshrc"
    fi
fi
