# I expect the following folder in my $HOME for temp stuff. Vim'll save the edit
# history and backups there.
mkdir ~/tmp

if [[ "$os" == "osx" ]]; then
    echo "$os: Installing vim..."
    brew install vim
elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing vim..."
    sudo apt-get install -y vim
fi

# Note: I no longer use Vundle, having migrated to Vim-Plug. However, if you
# want it installed, just uncomment the line below:
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Vim Plug.
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Use our dotfiles for vimrc and vim spell.
ensure_symlink "$(pwd)/vim/vim-spell-en.utf-8.add" "$HOME/.vim-spell-en.utf-8.add"
ensure_symlink "$(pwd)/vim/vimrc" "$HOME/.vimrc"

# Install plugins.
vim +'PlugInstall --sync' +qa
