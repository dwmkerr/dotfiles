# Setup parameters.
golangver="1.11"
gopath="$HOME/go"

# Check if the user wants the feature, bail if not.
if ! ask "$os: setup golang ${golangver}?" Y; then
    return 0
fi

if [[ "$os" == "osx" ]]; then
    echo "$os: Installing Go $golangver with brew..."
    brew install go@${golangver}
elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing Go $golangver with snap..."
    sudo snap install --classic --channel="${golangver}/stable" go
fi

# Now make sure we have a go home for $GOPATH...
if [ ! -d "$gopath" ]; then
    if ask "$os: Create \$GOPATH at '$gopath'?" Y; then
        mkdir "${gopath}";
        mkdir "${gopath}/src";
        mkdir "${gopath}/pkg";
        mkdir "${gopath}/bin";
    fi
fi 
