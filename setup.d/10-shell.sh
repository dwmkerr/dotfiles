# Install the latest bash.
if ask "$os: install or upgrade bash and bash-completion?" N; then
    if [[ "$os" == "osx" ]]; then
        brew install bash bash-completion@2
        # Make sure the installed zsh path is allowed in the list of shells.
        echo "$(which bash)" >> sudo tee -a /etc/shells
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: not yet implemented"
        exit 1
    fi
fi

# Install the latest zsh.
if ask "$os: install or upgrade zsh?" N; then
    if [[ "$os" == "osx" ]]; then
        brew install zsh zsh-completions
        # Make sure the installed zsh path is allowed in the list of shells.
        echo "$(which zsh)" >> sudo tee -a /etc/shells
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get update -y
        sudo apt-get install -y zsh
    fi

    # Our zshrc assumes oh-my-zsh, ask to install it first.
    if ask "$os: current config requires oh-my-zsh, install now?" N; then
        # Run the unattended install, see:
        # https://github.com/ohmyzsh/ohmyzsh#unattended-install
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Copy over our themes.
    cp "${PWD}/zsh/*.zsh-theme" "${HOME}/.oh-my-zsh/themes"

    # After we have installed zsh, create a link to our zshrc.
    echo "$os: setting ~/.zshrc link..."
    ensure_symlink "${PWD}/zsh/zshrc" "$HOME/.zshrc"
fi

# Move to zsh.
echo "$os: checking shell..."
if [[ ! "$SHELL" =~ zsh$ ]]; then
    if ask "$os: Shell is '$SHELL', change to zsh?" Y; then
        chsh -s "$(which zsh)"
    fi
fi

# Check the shell, and make sure that we are sourcing the .shell.sh file.
if ask "$os: Add .shell.sh to bash/zsh?" Y; then

    # Create the .shell.sh script symlink as well as shell.d folder symlink.
	ensure_symlink "$(pwd)/shell.sh" "$HOME/.shell.sh"
	ensure_symlink "$(pwd)/shell.d" "$HOME/.shell.d"
    
    # Source our shell configuration in any local shell config files.
    config_files=(~/.bashrc ~/.zshrc)
    for config_file in ${config_files[@]}; do
        # Skip config files that don't exist.
        ! [ -r "${config_file}" ] && continue

        # If we don't have the 'source ~/.shell.d' line in our config, add it.
        source_command="[ -r ~/.shell.sh ] && source ~/.shell.sh"
        if ! grep -q "${source_command}" "${config_file}"; then
            if ask "$os: .shell.sh is not sourced in '${config_file}' add it?" Y; then
                echo "" >> "${config_file}"
                echo "# Source my personal (github.com/dwmkerr/dotfiles) configuration." >> "${config_file}"
                echo "${source_command}" >> "${config_file}"
            fi
        fi
    done
fi
