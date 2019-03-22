#!/usr/bin/env bash

# First, enable tap-to-click.
# Reference: http://osxdaily.com/2014/01/31/turn-on-mac-touch-to-click-command-line/
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

