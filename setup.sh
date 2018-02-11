#!/bin/bash
source ./tools/ask.sh

ask "This script will attempt to setup your machine, continue?" Y || exit 0

# If HomeBrew is not installed, install it.
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS: Checking for brew..."
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
else
    echo "Linux: Skipping brew setup..."
fi

# If NVM is not installed, install it.
command -v nvm
echo "Checking for NVM..."
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


# Re-attach to user namespace is needed to get the system clipboard setup.
brew install reattach-to-user-namespace
brew install bash-completion

# Not sure if we want this here, but here's some zsh completion...
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker > ~/.zsh/completion/_docker
curl -L https://raw.githubusercontent.com/docker/machine/v0.13.0/contrib/completion/zsh/_docker-machine > ~/.zsh/completion/_docker-machine
curl -L https://raw.githubusercontent.com/docker/compose/1.17.0/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

# Install Terraform Lint.
brew tap wata727/tflint
brew install tflint
