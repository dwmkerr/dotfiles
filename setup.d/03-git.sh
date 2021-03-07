# Configure Git.
if [[ "$os" == "osx" ]]; then
    echo "$os: Installing git..."
    brew install git

    echo "$os: Installing gpg..."
    # Install GPG and Pinentry for Mac.
    brew install gnupg pinentry-mac

    # Tell GPG to use pinentry-mac, and restart the agent. Create the gnupg
    # folder if we have to.
    mkdir -p ~/.gnupg
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

    # Make sure we lock down the gpg config folder.
    # Set ownership to your own user and primary group.
    chown -R "$USER:$(id -gn)" ~/.gnupg
    # Set permissions to read, write, execute for only yourself, no others.
    chmod 700 ~/.gnupg
    # Set permissions to read, write for only yourself, no others.
    chmod 600 ~/.gnupg/*

elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing git..."
    sudo apt install -y git

    echo "$os: Installing gpg..."
    sudo apt install -y gnupg2
fi

# Configure Git.
if ask "$os: Configure git for dwmkerr user and GPG signing?" n; then
    git config --global user.name "Dave Kerr"
    git config --global user.email "dwmkerr@gmail.com"
    git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
    git config --global commit.gpgSign true
    git config --global tag.forceSignAnnotated true
    git config --global gpg.program "gpg"
    # Note: on ubuntu we might need:
    # git config --global gpg.program "gpg2"
fi
