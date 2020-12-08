if ask "$os: Setup AWS/GCP/Azure/Alicloud CLIs?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install awscli
        brew install azure-cli
    elif [[ "$os" == "ubuntu" ]]; then
        pip3 install awscli --upgrade --user

        # Install az cli dependencies, Microsoft's key, thb binary.
        sudo apt-get install curl apt-transport-https lsb-release gpg
        curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
            gpg --dearmor | \
            sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
        AZ_REPO=$(lsb_release -cs)
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
            sudo tee /etc/apt/sources.list.d/azure-cli.list
        sudo apt-get update
        sudo apt-get install azure-cli
    fi
fi

