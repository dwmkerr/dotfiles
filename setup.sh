#!/bin/bash
source ./tools/ask.sh

# Identify the operating system.
un=$(uname -a)
os="unknown"
if [[ "$un" =~ [Dd]arwin ]]; then
    echo "Operating System: OSX"
    os="osx"
elif [[ "$un" =~ [Uu]buntu ]]; then
    echo "Operating System: Ubuntu"
    os="ubuntu"
else
    echo "Operating System: Unknown"
    exit 1
fi

# Setup any package manager required.
if [[ "$os" == "osx" ]]; then
    echo "$os: Checking for brew..."
    which -s brew
    if [[ $? != 0 ]] ; then
        if ask "$os: HomeBrew is not installed. Install it?" Y; then
            echo "$os: Installing HomeBrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi    
    else
        echo "$os: HomeBrew is installed, updating..."
        brew update
    fi
elif [[ "$os" == "ubuntu" ]]; then
    if ask "$os: update apt?" Y; then
        echo "$os: Updating apt..."
        sudo apt-get update -y
    fi
fi

# Move to zsh.
echo "$os: checking shell..."
if [[ "$SHELL" != "/bin/zsh" ]]; then
    if ask "$os: Shell is '$SHELL', change to zsh?" Y; then
        echo "Installing zsh..."
    fi
else
    echo "$os: Shell is '$SHELL'"
fi

# Check the shell, and make sure that we are sourcing the .profile file.
echo "$os: checking for .profile setup..."
if [[ "$SHELL" =~ bash ]]; then
    # TODO: we should only do this if the line is not already in our rc.
    if ask "$os: Add 'source .profile' to bashrc?" Y; then
        ln -sf "~/.profile.sh" "$(pwd)/profile.sh"
        echo "" >> ~/.bashrc
        echo "# Load dwmkerr/dotfiles shell configuration." >> ~/.bashrc
        echo "source ~/.profile.sh" >> ~/.bashrc
        source ~/.bashrc
    fi
fi

# If NVM is not installed, install it.
echo "$os: Checking for NVM..."
nvm_installed=$(command -v nvm)
if [[ ${nvm_installed} != 0 ]] ; then
    if ask "$os: NVM is not installed. Install it?" Y; then
        echo "$os: Installing NVM..."
        touch ~/.bash_profile
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    fi    
else
    echo "$os: NVM is installed..."
fi

# NOTE: We need to support upgrading tmux too...
# sudo apt-get -y remove tmux

# Install tmux.
TMUX_VERSION=2.6
echo "$os: Checking for tmux..."
tmux_installed=$(command -v tmux)
tmux_version=$(tmux -V > /dev/null 2>&1)
if [[ ${tmux_installed} != 0 ]]; then
    if ask "$os: tmux ${TMUX_VERSION} is not installed. Install it?" Y; then
        if [[ "$os" == "osx" ]]; then
            echo "$os: Installing tmux ${TMUX_VERSION}..."
            brew install tmux
            ln -s .tmux.conf ~/.tmux.conf
        elif [[ "$os" == "ubuntu" ]]; then
            echo "$os: Installing tmux ${TMUX_VERSION}..."
            # Get the build dependencies.
            sudo apt-get install -y wget tar libevent-dev libncurses-dev
            TMUX_DIR="${HOME}/temp/tmux-src"
            mkdir -p "${TMUX_DIR}"
            wget -P "${TMUX_DIR}" -q https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
            tar xzf "${TMUX_DIR}/tmux-${TMUX_VERSION}.tar.gz" -C "${TMUX_DIR}"
            pushd "${TMUX_DIR}"/tmux-*
            ./configure && make -j"$(nproc)" && sudo make install
            popd
            rm -rf ~/temp/tmux-src
            tmux -V
        fi

        # Now install the tmux plugin manager, then install the plugins.
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/bin/install_plugins
    fi
fi

exit

# Install vundle.
read -p "Install Vundle? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Re-attach to user namespace is needed to get the system clipboard setup.
brew install reattach-to-user-namespace
brew install bash-completion

# Not sure if we want this here, but here's some zsh completion...
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker > ~/.zsh/completion/_docker
curl -L https://raw.githubusercontent.com/docker/machine/v0.13.0/contrib/completion/zsh/_docker-machine > ~/.zsh/completion/_docker-machine
curl -L https://raw.githubusercontent.com/docker/compose/1.17.0/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

# Install linters and related tools. These are used by ALE in Vim.

# Install Terraform Lint.
brew tap wata727/tflint
brew install tflint

# HTML linting.
brew install tidy-html5

# Setup hub.
brew install hub
