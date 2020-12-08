# Install pyrev and python.
brew install pyenv

# Check if the user wants to install a specific version of Python.
version="3.7.3"

if ! ask "$os: setup Python ${version} as the default?" Y; then
    return 0
fi
pyenv install ${version}
