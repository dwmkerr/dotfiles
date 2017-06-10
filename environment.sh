#!/usr/bin/env bash

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
eval $(/usr/libexec/path_helper -s)

# Setup key Android environment variables. Assumes an installation with
# something like Android Studio or Eclipse, rather than an SDK installed
# with HomeBrew.
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
