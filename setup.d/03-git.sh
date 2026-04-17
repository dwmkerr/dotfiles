# Configure Git. GPG is handled separately in 02.5-gpg.sh.
if [[ "$os" == "osx" ]]; then
    echo "$os: Installing git..."
    brew install git
elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing git..."
    sudo apt install -y git
fi

# Configure Git.
if ask "$os: Configure git for dwmkerr user and GPG signing?" N; then
    git config --global user.name "Dave Kerr"
    git config --global user.email "dwmkerr@gmail.com"
    git config --global user.signingKey "35D965FB60ACC2E94E605038F780C45862199FEC"
    git config --global commit.gpgSign true
    git config --global tag.forceSignAnnotated true
    git config --global gpg.program "gpg"
    # Note: on ubuntu we might need:
    # git config --global gpg.program "gpg2"
fi
