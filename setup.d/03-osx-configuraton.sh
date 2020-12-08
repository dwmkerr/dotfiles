# Perform MacOSX Dock Configuration.
if [[ "$os" != "osx" ]]; then
    echo "warning: cannot setup OSX configuration on '${os}', stopping..."
    return 0
fi

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

if ask "$os: Setup 'reattach-to-user-namespace' to allow proper clipboard support in the shell?" Y; then
    brew install reattach-to-user-namespace
fi

