# I expect the following folder in my $HOME for temp stuff. Vim'll save the edit
# history and backups there.
mkdir -p ~/tmp

if [[ "$os" == "osx" ]]; then
    if ask "$os: Install NeoVim?" N; then
        echo "$os: Installing nvim..."
        brew install nvim
    fi
elif [[ "$os" == "ubuntu" ]]; then
    if ask "$os: Install NeoVim?" N; then
        echo "$os: Installing nvim..."
        sudo apt-get install -y nvim
    fi
fi

# Make sure vi always goes to nvim.
if ask "$os: Symlink 'vi' and 'vim' to 'nvim'?" N; then
    sudo ln -sf "$(which nvim)" /usr/local/bin/vi
    sudo ln -sf "$(which nvim)" /usr/local/bin/vim
fi

# Use our dotfiles for vimrc and vim spell.
if ask "$os: Link to dotfiles vimrc, init.vim, vimspell?" N; then
    ensure_symlink "$(pwd)/vim/vim-spell-en.utf-8.add" "$HOME/.vim-spell-en.utf-8.add"
    ensure_symlink "$(pwd)/vim/vimrc" "$HOME/.vimrc"
    ensure_symlink "$(pwd)/vim/init.vim" "$HOME/.config/nvim/init.vim"
    echo "$os: Note that plugin manager and plugins should now be installed"
    echo "otherwise vim will show warnings on startup."
fi

# Note: I no longer use Vundle, having migrated to Vim-Plug. However, if you
# want it installed, just uncomment the line below:
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Vim Plug.
if ask "$os: Install Vim Plug (plugin manager)?" N; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# Install plugins.
if ask "$os: Install Vim Plugin (requires Vim Plug)?" N; then
    vi +'PlugInstall --sync' +qa
fi
