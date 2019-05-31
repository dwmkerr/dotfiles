# Check if the user wants the feature, bail if not.
if ! ask "$os: setup docker autocompletion?" Y; then
    return 0
fi

# Note the standard bash and zsh autocompletion paths.
bash_autocomplete_dir="/etc/bash_completion.d"
zsh_autocomplete_dir="${HOME}/.zsh/completion"

# If we are on a Mac, we might not have auto-completion installed (for Linux, it
# should already be good to go).
if [[ "$os" == "osx" ]]; then
    echo "$os: installing bash-completion..."
    brew install bash-completion
    bash_autocomplete_dir="$(brew --prefix)${bash_autocomplete_dir}"
fi

# Ensure the completion paths exist.
sudo mkdir -p "${bash_autocomplete_dir}"
mkdir -p "${zsh_autocomplete_dir}"

# Download the bash autocompletion script scripts.
sudo curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o \
    "${bash_autocomplete_dir}/docker"
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/bash/docker-compose -o \
    "${bash_autocomplete_dir}/docker-compose"
sudo curl -L https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/bash/docker-machine.bash -o \
    "${bash_autocomplete_dir}/docker-machine"

# Download the zsh autocompletion scripts.
curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/zsh/_docker -o \
    "${zsh_autocomplete_dir}/_docker"
curl -L https://raw.githubusercontent.com/docker/compose/1.24.0/contrib/completion/zsh/_docker-compose -o \
    "${zsh_autocomplete_dir}/_docker-compose"
curl -L https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/zsh/_docker-machine -o \
    "${zsh_autocomplete_dir}/_docker-machine"

