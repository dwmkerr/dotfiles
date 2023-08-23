# Perform MacOSX Dock Configuration.
if [[ "$os" != "osx" ]]; then
    echo "warning: cannot setup OSX configuration on '${os}', stopping..."
    return 0
fi

if ask "$os: Standardise Dock Configuration?" N; then
    # Set my preferred dock size and enable magnification.
    defaults write com.apple.dock tilesize -int 32
    defaults write com.apple.dock largesize -float 64
    defaults write com.apple.dock magnification -bool true

    # Only show apps which are open, rather than shortcuts.
    defaults write com.apple.dock static-only -bool true

    # Restart the dock.
    killall Dock
fi    

if ask "$os: Enable 'tap-to-click'?" N; then
    # https://www.compsmag.com/how-to/turning-on-mac-touch-to-click-support-from-command-line/
    defaults write com.apple.AppleMultitouchTrackpad Click -bool true
    sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Click -bool true
    sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    echo "'tap-to-click' enabled - this will be applied on restart..."
fi    

if ask "$os: Set wallpaper?" N; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$(pwd)/desktop/vim-shortcuts2560x1600.png\""
fi

if ask "$os: Show hidden files and folders?" N; then
    defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder
fi

if ask "$os: Show the path bar in Finder?" N; then
    defaults write com.apple.finder ShowPathbar -bool true; killall Finder
fi

if ask "$os: Setup 'reattach-to-user-namespace' to allow proper clipboard support in the shell?" N; then
    brew install reattach-to-user-namespace
fi

# Get the current computer name and ask if the user wants to change it.
computer_name=$(scutil --get ComputerName)
if ask "$os: Computer name is '${computer_name}', would you like to change it?" N; then
    printf "Enter the new computer name: "
    read new_computer_name
    scutil --set ComputerName "${new_computer_name}"
fi

# Get the current host name and ask if the user wants to change it.
host_name=$(scutil --get HostName)
if ask "$os: Host name is '${host_name}', would you like to change it?" N; then
    porintf "Enter the new host name (no spaces): "
    read new_host_name
    scutil --set HostName "${new_host_name}"
fi

# Get the current local host name and ask if the user wants to change it.
local_host_name=$(scutil --get LocalHostName)
if ask "$os: Local Host name is '${local_host_name}', would you like to change it?" N; then
    porintf "Enter the new local host name (no spaces): "
    read new_local_host_name
    scutil --set LocalHostName "${new_local_host_name}"
fi
