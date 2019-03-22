#!/bin/bash
source ./tools/ask.sh
source ./tools/ensure_symlink.sh

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

# Perform MacOSX Dock Configuration.
if [[ "$os" == "osx" ]]; then
    if ask "$os: Standardise Dock Configuration?" Y; then
        # Set my preferred dock size.
        defaults write com.apple.dock tilesize -int 32
        defaults write com.apple.dock largesize -int 64

        # Only show apps which are open, rather than shortcuts.
        defaults write com.apple.dock static-only -bool true

        # Restart the dock.
        killall Dock
    fi    
    if ask "$os: Enable 'tap-to-click'?" Y; then
        # Reference: http://osxdaily.com/2014/01/31/turn-on-mac-touch-to-click-command-line/
        defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
        sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    fi    
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
    fi
    if ask "$os: Update HomeBrew?" Y; then
        echo "$os: Updating brew..."
        brew update
    fi
elif [[ "$os" == "ubuntu" ]]; then
    if ask "$os: update apt?" Y; then
        echo "$os: Updating apt..."
        sudo apt-get update -y
    fi
fi

# Install MacOSX Applications.
if [[ "$os" == "osx" ]]; then
    if ask "$os: Install Applications (vlc)?" Y; then
        brew install caskroom/cask/brew-cask
        brew cask install google-chrome
        brew cask install 1password
        brew cask install docker-machine
        brew cask install dropbox
        brew cask install vlc
        brew cask install virtualbox && brew cask install vagrant && brew cask install virtualbox
        # The 'Hack' font.
        brew install caskroom/fonts/font-hack
    fi
fi

# Move to zsh.
echo "$os: checking shell..."
if [[ "$SHELL" != "/bin/zsh" ]]; then
    if ask "$os: Shell is '$SHELL', change to zsh?" Y; then
        if [[ "$os" == "osx" ]]; then
            echo "$os: Installing zsh..."
            brew install zsh zsh-completions
            chsh -s $(which zsh)
        elif [[ "$os" == "ubuntu" ]]; then
            echo "$os: Installing zsh..."
            apt-get install -y zsh zsh-completions
            chsh -s $(which zsh)
        fi
    fi
fi

# Ensure tmux is up to date.
if ask "$os: Install/Update tmux?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Updating tmux..."
        brew install tmux
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        apt-get update && apt-get install tmux
    fi
fi

# Check the shell, and make sure that we are sourcing the .profile file.
if ask "$os: Add .profile to bash/zsh?" Y; then
    ln -sf "$(pwd)/profile.sh" "~/.profile.sh"
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
            ln -s "$(pwd).tmux.conf" "~/.tmux.conf"
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

# Configure Git.
echo "$os: Configuring Git for dwmkerr and GPG signing..."
git config --global user.name "Dave Kerr"
git config --global user.email "dwmkerr@gmail.com"
git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
git config --global commit.gpgSign true
git config --global tag.forceSignAnnotated true
git config --global gpg.program "gpg2"

# Configure vim.

# Use our dotfiles for vimrc and vim spell.
ensure_symlink "$(pwd)/vim/vim-spell-en.utf-8.add" "$HOME/.vim-spell-en.utf-8.add"
ensure_symlink "$(pwd)/vim/vimrc" "$HOME/.vimrc"

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
