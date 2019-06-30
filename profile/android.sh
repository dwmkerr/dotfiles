#!/usr/bin/env bash 
# If the Android SDK has been installed, set the SDK path.
sdk_path="/usr/local/share/android-sdk"
if [[ -d "$sdk_path" ]]; then
    # This is the preferred environment variable for the SDK root.
    export ANDROID_SDK_ROOT="$sdk_path"

    # ANDROID_HOME is deprecated, but we'll set it just in case some other tool
    # has tried to set it to something else.
    export ANDROID_HOME="$sdk_path"

    # Make sure we set the correct emulator path first!
    export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$PATH
fi
