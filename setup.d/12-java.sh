# Setup Java.
# Check installed versions with:
# /usr/libexec/java_home -V
# Set a version with:
# export JAVA_HOME=$(/usr/libexec/java_home -v 19)

java_version="19"
if ask "$os: Setup Java ${java_version}?" Y; then
    if [[ "$os" == "osx" ]]; then
        # 'temurin' is the new name for Adopt OpenJDK.
        brew tap homebrew/cask-versions
        brew install --cask "temurin${java_version}"

    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

