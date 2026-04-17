# Configure GPG (used by git signing, private-files restore/backup GPG key import, etc).
if [[ "$os" == "osx" ]]; then
    echo "$os: Installing gpg..."
    # pinentry-mac is the macOS passphrase prompt helper for gpg-agent.
    brew install gnupg pinentry-mac

    # Tell GPG to use pinentry-mac, and restart the agent. Create the gnupg
    # folder if we have to.
    mkdir -p ~/.gnupg
    echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

    # Make sure we lock down the gpg config folder.
    # Set ownership to your own user and primary group.
    chown -R "$USER:$(id -gn)" ~/.gnupg
    # Set permissions to read, write, execute for only yourself, no others.
    chmod 700 ~/.gnupg
    # Set permissions to read, write for only yourself, no others.
    chmod 600 ~/.gnupg/*

elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing gpg..."
    sudo apt install -y gnupg2
fi
