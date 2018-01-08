#!/usr/bin/env bash 

# Add Homebrew's sbin bin to the paths.
export PATH="/usr/local/sbin:$PATH"

# Setup key Android environment variables. Assumes an installation with
# something like Android Studio or Eclipse, rather than an SDK installed
# with HomeBrew.
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

eval $(/usr/libexec/path_helper -s)

# Weird fastlane issue
export PATH="$HOME/.fastlane/bin:$PATH"

