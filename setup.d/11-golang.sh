# Setup parameters.
golangver="1.20.1"
gopath="$HOME/go"

if [[ "$os" == "osx" ]]; then
    pkg_path="${TMPDIR}golang.pkg"
    curl -o "${pkg_path}" "https://dl.google.com/go/go${golangver}.darwin-amd64.pkg"
    sudo open -W "${pkg_path}" # -W means wait for the program to close (i.e. package to install)
    rm "${pkg_path}"
elif [[ "$os" == "ubuntu" ]]; then
    echo "$os: Installing Go $golangver with snap..."
    sudo snap install --classic --channel="${golangver}/stable" go
fi

if ask "$os: Install protocol compiler (protoc)?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install protobuf
        protoc --version
    elif [[ "$os" == "ubuntu" ]]; then
        apt install -y protobuf-compiler
        protoc --version
    fi
fi

