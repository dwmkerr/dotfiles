# If NVM is not installed, install it.
echo "$os: Checking for NVM..."
if [ ! -x "$(command -v nvm)" ] ; then
    if ask "$os: NVM is not installed. Install it?" N; then
        echo "$os: Installing NVM..."
        touch ~/.bash_profile
        # TODO: make sure this also does zsh
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    fi    
else
    echo "$os: NVM is installed..."
fi

# Install the current node lts.
if ask "$os: install and use node lts as default?" N; then
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm install 'lts/*'
    nvm alias default 'lts/*'
fi
