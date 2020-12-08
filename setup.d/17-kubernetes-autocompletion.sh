# Bit of an issue with this - if we are in zsh we need zsh auto-completion, but
# Check if the user wants to setk RVM.
if ! ask "$os: setup pyenv (Python Version Manager)?" Y; then
    return 0
fi

# we're using a bash shebang...

# If kubectl is installed, enable auto completion.
# if [ -x "$(command -v kubectl)" ]; then
  # source <(kubectl completion zsh)
# fi

