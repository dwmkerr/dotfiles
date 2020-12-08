# Check the shell, and make sure that we are sourcing the .profile file.
# TODO: It is quite important here we only perform this step if the profile
# is _not_ already being sourced, otherwise we will load it multiple times...
if ask "$os: Add .profile to bash/zsh?" Y; then
	ensure_symlink "$(pwd)/profile.sh" "$HOME/.profile.sh"
	ensure_symlink "$(pwd)/profile" "$HOME/.profile"
    echo "" >> ~/.bashrc
    echo "# Load dwmkerr/dotfiles shell configuration." >> ~/.bashrc
    echo "source ~/.profile.sh" >> ~/.bashrc
    echo "" >> ~/.zshrc
    echo "# Load dwmkerr/dotfiles shell configuration." >> ~/.zshrc
    echo "source ~/.profile.sh" >> ~/.zshrc
    if [[ "$SHELL" =~ bash ]]; then
        source ~/.bashrc
    elif [[ "$SHELL" =~ zsh ]]; then 
        source ~/.zshrc
    fi
fi

