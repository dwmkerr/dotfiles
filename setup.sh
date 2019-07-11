# Load each of the tools.
for file in ./tools/*; do
    [ -e "$file" ] || continue
    echo "Loading tool '$file'..."
    source $file
done

# TODO:
# osx - mas (mac app store CLI: brew)
# osx - set icon
# iterm - set colour scheme
# terminal - raise bug on broken colours
# shell - tldr

# Get the operating system, output it. The script will terminate if the OS
# cannot be categorically identified.
os=$(get_os)
echo "os identified as: $os"

# Perform MacOSX Dock Configuration.
if [[ "$os" == "osx" ]]; then
    if ask "$os: Standardise Dock Configuration?" Y; then
        # Set my preferred dock size.
        defaults write com.apple.dock tilesize -int 32; killall Dock
        defaults write com.apple.dock largesize -float 64; killall Dock

        # Only show apps which are open, rather than shortcuts.
        defaults write com.apple.dock static-only -bool true; killall Dock
    fi    
    if ask "$os: Enable 'tap-to-click'?" Y; then
        # Reference: http://osxdaily.com/2014/01/31/turn-on-mac-touch-to-click-command-line/
        defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
        sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
        sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
        sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    fi    
    if ask "$os: Set wallpaper?" Y; then
        osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$(pwd)/desktop/vim-shortcuts2560x1600.png\""
    fi
    if ask "$os: Show hidden files and folders?" Y; then
        defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder
    fi

    if ask "$os: Show the path bar in Finder?" Y; then
        defaults write com.apple.finder ShowPathbar -bool true; killall Finder
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
        brew cask install dropbox
        brew cask install vlc
        brew cask install virtualbox && brew cask install vagrant && brew cask install virtualbox

        # Programming.
        brew cask install iterm2
        brew cask install visual-studio-code

        # Communication.
        brew cask install whatsapp
        brew cask install slack

        # The 'Hack' font.
        brew tap caskroom/fonts
        brew cask install font-hack
        
        # TODO: move to its own section and have it's own profile.
        # Docker and associated tools.
        brew cask install docker
        brew install kubectl
        brew cask install minikube

        # Gaming apps.
        brew cask install steam

        # File management / download / sharing apps.
        brew cask install transmission
        brew cask install cyberduck

        # Virtual machines.
        brew cask install parallels

        # Muzak stuff.
        brew cask install spotmenu

        # Utilities.
        brew cask install spectacle
    fi
fi

# Ensure that snap is installed for Ubuntu.
echo "checking for snap (my os is '$os')..."
if [[ "$os" == "ubuntu" ]]; then
    if [ ! -x "$(command -v snap)" ]; then
        if ask "$os: 'snap' is required for $os, install now?" Y; then
            echo "$os: Installing snap..."
            sudo apt-get install -y snapd
        else
            echo "$os: Exiting setup as 'snap' is required...";
            exit 1;
        fi
    fi
fi

# Install Linux apps.
if [[ "$os" == "osx" ]]; then
    if ask "$os: Install Linux CLI apps (telnet, tree, wget, etc)?" Y; then
        brew install telnet wget tree
    fi
fi

# Move to zsh.
echo "$os: checking shell..."
if [[ "$SHELL" != "/bin/zsh" ]]; then
    if ask "$os: Shell is '$SHELL', change to zsh?" Y; then
        if [[ "$os" == "osx" ]]; then
            echo "$os: Installing zsh..."
            brew install zsh zsh-completions
            # Make sure the installed zsh path is allowed in the list of shells.
            echo "$(which zsh)" >> sudo tee -a /etc/shells
            chsh -s "$(which zsh)"
        elif [[ "$os" == "ubuntu" ]]; then
            echo "$os: Installing zsh..."
            sudo apt-get update -y
            sudo apt-get install -y zsh
            chsh -s "$(which zsh)"
        fi

        # After we have installed zsh, create a link to our zshrc.
        echo "$os: setting ~/.zshrc link..."
        ensure_symlink "$(pwd)/zsh/zshrc" "$HOME/.zshrc"
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
    ensure_symlink "$(pwd)/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Setup the tmux plugin manager if it is not already installed.
    if [[ ! -d ~/.tmux/plugins/tpm ]]; then
        echo "$os: Setting up TPM..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
fi

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

if ask "$os: Install/Update/Configure Vim?" Y; then
    # I use ~/tmp for a lot of vim temp stuff...
    mkdir ~/tmp

    if [[ "$os" == "osx" ]]; then
        echo "$os: Installing vim..."
        brew install vim
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Installing vim..."
        apt-get update && apt-get install vim
    fi
    
    # Install Vundle.
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    # Use our dotfiles for vimrc and vim spell.
    ensure_symlink "$(pwd)/vim/vim-spell-en.utf-8.add" "$HOME/.vim-spell-en.utf-8.add"
    ensure_symlink "$(pwd)/vim/vimrc" "$HOME/.vimrc"
fi

# Configure Git.
if ask "$os: Configure dwmkerr user for Git?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Installing gpg..."
        # Install GPG and Pinentry for Mac.
        brew install gnupg pinentry-mac

        # Tell GPG to use pinentry-mac, and restart the agent.
        echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
        gpgconf --kill gpg-agent
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Installing gpg..."
        apt-get install gnupg2
    fi

    echo "$os: Configuring Git for dwmkerr and GPG signing..."
    git config --global user.name "Dave Kerr"
    git config --global user.email "dwmkerr@gmail.com"
    git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
    git config --global commit.gpgSign true
    git config --global tag.forceSignAnnotated true
    git config --global gpg.program "gpg"
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

# Configure Terraform.
if ask "$os: Setup Terraform and Terraform Lint?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install terraform
        brew tap wata727/tflint
        brew install tflint

        # Now that terraform is installed, we can enable auto-completion.
        # Note that this won't take effect until the shell is restarted.
        terraform -install-autocomplete

    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

# Configure Golang.
if ask "$os: Setup Golang?" Y; then
    golangver="1.11"
    if [[ "$os" == "osx" ]]; then
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Installing Go $golangver with snap..."
        sudo snap install --classic --channel="${golangver}/stable go"
        echo "TODO: set GOPATH..."
    fi
fi

# Setup Java.
if ask "$os: Setup Java 8?" Y; then
    if [[ "$os" == "osx" ]]; then
        # Note that Java 8 is not the latest version, but some tools like the
        # Android SDK don't support version 9 at the time of writing. So install
        # Java 8 by preference.
        brew cask reinstall AdoptOpenJDK/homebrew-openjdk/adoptopenjdk
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

# Setup Android.
android_version="28"
if ask "$os: Setup Android v${android_version}?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install gradle

        # Install the Android SDK and HAXM.
        brew cask install android-sdk
        brew cask install intel-haxm

        # Now install the appropriate SDKs components for the given Android version.
        sdkmanager "platform-tools" "platforms;android-${android_version}" "extras;intel;Hardware_Accelerated_Execution_Manager" "build-tools;${android_version}.0.0" "system-images;android-${android_version};google_apis;x86" "emulator"

        # Finally, create an emulator for the given Android version.
        avdmanager create avd -memory 768 -n Android28Emulator -k "system-images;android-${android_version};google_apis;x86"

        # We should *not* have an 'emulator' symlink, as we add:
        #   /usr/local/share/android-sdk/emulator/
        # to our path. Having the link causes 'missing binary' issues. So remove it.
        rm /usr/local/share/android-sdk/emulator/emulator
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

# Setup ag.
if ask "$os: Install/Configure The Silver Searcher?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install the_silver_searcher
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Updating tmux..."
        apt-get install -y silversearcher-ag
    fi
fi

# Setup wiktionary cli.
if ask "$os: Install wped/wikt?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/local/bin/wped
        sudo ln -s /usr/local/bin/wped /usr/local/bin/wikt
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install php-cli php-curl php-xml elinks
        wget https://raw.githubusercontent.com/mevdschee/wped/master/wped.php -O wped
        chmod 755 wped
        sudo mv wped /usr/bin/wped
        sudo ln -s /usr/bin/wped /usr/bin/wikt
    fi
fi

if ask "$os: Setup AWS/GCP/Azure/Alicloud CLIs?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install awscli
        brew install azure-cli
    elif [[ "$os" == "ubuntu" ]]; then
        pip3 install awscli --upgrade --user

        # Install az cli dependencies, Microsoft's key, thb binary.
        sudo apt-get install curl apt-transport-https lsb-release gpg
        curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
            gpg --dearmor | \
            sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
        AZ_REPO=$(lsb_release -cs)
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
            sudo tee /etc/apt/sources.list.d/azure-cli.list
        sudo apt-get update
        sudo apt-get install azure-cli
    fi
fi

# Many changes (such as chsh) need a restart, offer it now,
if ask "$os: Some changes may require a restart - restart now?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Restarting..."
        sudo shutdown -r now
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Restarting..."
        echo "TODO"
    fi

    echo "$os: Configuring Git for dwmkerr and GPG signing..."
    git config --global user.name "Dave Kerr"
    git config --global user.email "dwmkerr@gmail.com"
    git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
    git config --global commit.gpgSign true
    git config --global tag.forceSignAnnotated true
    git config --global gpg.program "gpg2"
fi

# Run each of the setup files.
for file in ./setup.d/*; do
    [ -e "$file" ] || continue
    source $file
done

exit;
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

# Re-attach to user namespace is needed to get the system clipboard setup.
brew install reattach-to-user-namespace

# Install linters and related tools. These are used by ALE in Vim.

# HTML linting.
brew install tidy-html5

# Setup hub.
brew install hub
