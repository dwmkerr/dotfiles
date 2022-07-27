# Configure Terraform.
if ask "$os: Setup Terraform and Terraform Lint?" Y; then
    if [[ "$os" == "osx" ]]; then
        brew install terraform
        brew tap wata727/tflint
        brew install tflint

        # Now that terraform is installed, we can enable auto-completion.
        # Note that this won't take effect until the shell is restarted.
        terraform -install-autocomplete

    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: TODO"
    fi
fi

