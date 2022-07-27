# Setup Java.
if ask "$os: Setup Java 8?" Y; then
    if [[ "$os" == "osx" ]]; then
        # Note that Java 8 is not the latest version, but some tools like the
        # Android SDK don't support version 9 at the time of writing. So install
        # Java 8 by preference.
        brew cask install adoptopenjdk/openjdk/adoptopenjdk8
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

