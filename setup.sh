#!/bin/bash
source ./tools/ask.sh

ask "This script will attempt to setup your machine, continue?" Y || exit 0

# If HomeBrew is not installed, install it.
which -s brew
if [[ $? != 0 ]] ; then
    if ask "HomeBrew is not installed. Install it?" Y; then
        echo "Installing HomeBrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi    
else
    echo "HomeBrew is installed, updating..."
    brew update
fi

# TODO: ugh, still lots to do

# If NVM is not installed, install it.
command -v nvm
if [[ $? != 0 ]] ; then
    if ask "NVM is not installed. Install it?" Y; then
        echo "Installing NVM..."
        touch ~/.bash_profile
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    fi    
else
    echo "NVM is installed..."
fi

ask "Should I go on?"

# Install vundle.
read -p "Install Vundle? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Install tmux.
read -p "Install and configure tmux? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install tmux
    ln -s .tmux.conf ~/.tmux.conf
fi
