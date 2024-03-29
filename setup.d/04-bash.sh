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

# Check the shell, and make sure that we are sourcing the .shell.sh file.
if ask "$os: Add .shell.sh to .bashrc?" Y; then

    # Create the .shell.sh script symlink as well as shell.d folder symlink.
	ensure_symlink "$(pwd)/shell.sh" "$HOME/.shell.sh"
	ensure_symlink "$(pwd)/shell.d" "$HOME/.shell.d"
    
    # Source our shell configuration in any local shell config files.
    config_file="${HOME}/.bashrc"

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
