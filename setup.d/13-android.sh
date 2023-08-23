

# Setup Android.
# Note that the preferred locations for the SDK vary:
# $HOME/Library/Android/sdk - used by Android Studio on Mac and most online resources documenting Mac.
# /usr/local/share/android-sdk - used in CI
# /usr/local/share/android-commandlinetools/ - If you just install the sdkmanager via brew and install packages, they end up here - not useful
android_version="33"
if ask "$os: Setup Android v${android_version}?" Y; then
    if [[ "$os" == "osx" ]]; then
        # Install Java and Grandle.
        brew install --cask temurin
        brew install gradle

        # Install the Android Command-line Tools and HAXM.
        brew install --cask android-commandlinetools
        brew install --cask intel-haxm

        # Install the appropriate SDKs components for the given Android version.
        # Install them to the location used by Android Studio.
        android_sdk_root="$HOME/Library/Android/sdk"
        sdkmanager --sdk_root="${android_sdk_root}" "platform-tools" "platforms;android-${android_version}" "extras;intel;Hardware_Accelerated_Execution_Manager" "build-tools;${android_version}.0.0" "system-images;android-${android_version};google_apis;x86_64" "emulator"

        # Finally, create an emulator for the given Android version.
        avdmanager create avd -n "Android${android_version}Emulator" -k "system-images;android-${android_version};google_apis;x86_64"

        # We should *not* have an 'emulator' symlink, as we add:
        #   /usr/local/share/android-sdk/emulator/
        # to our path. Having the link causes 'missing binary' issues. So remove it.
        rm /usr/local/share/android-sdk/emulator/emulator
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi
