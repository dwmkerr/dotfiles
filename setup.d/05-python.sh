# Install pyrev and python.
if ask "$os: Install pyenv?" n; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Installing pyenv..."
        brew install pyenv
    elif [[ "$os" == "ubuntu" ]]; then
        # Install python dependencies.
        sudo apt install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev\
            libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    fi
fi

# Check if the user wants to install a specific version of Python.
version="3.7.3"
if ask "$os: setup Python ${version} as the default?" n; then
    # Use the full path to the pyenv binary as we have probably not restarted
    # the shell since installing it...
    ~/.pyenv/bin/pyenv install ${version}
fi
