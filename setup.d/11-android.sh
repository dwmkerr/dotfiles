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

