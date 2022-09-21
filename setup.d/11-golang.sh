# Setup parameters.
golangver="1.19.1"
gopath="$HOME/go"

if [[ "$os" == "osx" ]]; then
    pkg_path="${TMPDIR}golang.pkg"
    curl -o "${pkg_path}" "https://dl.google.com/go/go${golangver}.darwin-amd64.pkg"
    sudo open "${pkg_path}"
    rm "${pkg_path}"
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
