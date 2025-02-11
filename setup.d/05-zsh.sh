# Install the latest zsh.
if ask "$os: install or upgrade zsh?" N; then
    if [[ "$os" == "osx" ]]; then
        brew install zsh zsh-completions

        # Get the installed zsh location and desired location.
        bash_brew_path="/opt/homebrew/bin/zsh"
        zsh_local_path="/usr/local/bin/zsh"

        # Create /usr/local/bin/zsh and add it to the allowed shells.
        sudo ln -sf "${zsh_brew_path}" "${zsh_local_path}"
        sudo sh -c "echo '${zsh_local_path}' >> /etc/shells"
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get update -y
        sudo apt-get install -y zsh
    fi

    # After we have installed zsh, create a link to our zshrc.
    echo "$os: setting ~/.zshrc link..."
    ensure_symlink "${PWD}/zsh/zshrc" "$HOME/.zshrc"
fi

# Check the shell, and make sure that we are sourcing the .shell.sh file.
if ask "$os: Add .shell.sh to .zshrc?" Y; then

    # Create the .shell.sh script symlink as well as shell.d folder symlink.
	ensure_symlink "$(pwd)/shell.sh" "$HOME/.shell.sh"
	ensure_symlink "$(pwd)/shell.d" "$HOME/.shell.d"

    # Source our shell configuration in any local shell config files.
    config_file="${HOME}/.zshrc"

    # Check if we are sourcing the dotfiles shell config.
    source_command="[ -r ~/.shell.sh ] && source ~/.shell.sh"
    if ! grep -q "${source_command}" "${config_file}"; then

        # If the config file doesn't exist, offer to create it.
        if ! [ -r "${config_file}" ]; then
            if ask "$os: shell config ${config_file} does not exist - create it now?" Y; then
                touch "${config_file}"
            fi
        fi

        # Ask the user if they'd like to source the shell config.
        if ask "$os: .shell.sh is not sourced in '${config_file}' add it?" Y; then
            echo "" >> "${config_file}"
            echo "# Source my personal (github.com/dwmkerr/dotfiles) configuration." >> "${config_file}"
            echo "${source_command}" >> "${config_file}"
        fi
    fi
fi

# If we have created a new local zsh, offer the option to set the default
# shell.
zsh_local_path="/usr/local/bin/bash"
if [ -e "${zsh_local_path}" ]; then
    if ask "$os: Change shell (chsh) to: '${zsh_local_path}'?" N; then
        # Link the system zsh to local zsh.
        chsh -s "${zsh_local_path}" 
    fi
fi
