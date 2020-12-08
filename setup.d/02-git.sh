# Configure Git.
if [[ "$os" == "osx" ]]; then
    echo "$os: Installing gpg..."
    # Install GPG and Pinentry for Mac.
    brew install gnupg pinentry-mac

    # Tell GPG to use pinentry-mac, and restart the agent.
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent
elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing gpg..."
    apt-get install gnupg2
fi

echo "$os: Configuring Git for dwmkerr and GPG signing..."
git config --global user.name "Dave Kerr"
git config --global user.email "dwmkerr@gmail.com"
git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
git config --global commit.gpgSign true
git config --global tag.forceSignAnnotated true
git config --global gpg.program "gpg2"
