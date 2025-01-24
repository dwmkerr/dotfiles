# Bail if we are not on OSX.
if [[ "$os" != "osx" ]]; then
    echo "warning: cannot setup OSX applications on '${os}', stopping..."
    return 0
fi

# Note that I no longer install the following apps - they are installed by the
# enterprise profile:
# - slack

# Ask to install enterprise applications
if ask "$os: List applications that must be manually installed??" N; then
    echo "Slack"
    echo "Docker Desktop: https://docs.docker.com/desktop/setup/install/mac-install/"

apps=('bitwarden'
    'cyberduck'
    'docker'
    'font-hack'
    'keepingyouawake'
    'iterm2'
    'joplin'
    'minikube'
    'parallels'
    'spectacle'
    'spotmenu'
    'spotify'
    'vagrant'
    'virtualbox'
    'visual-studio-code'
    'vlc'
)

for app in ${apps[@]}; do
    if ask "$os: Install tool '${app}'?" N; then
        brew install ${app}
    fi
done

# Install Linux apps.
apps=('coreutils'
    'findutils'
    'gawk'
    'gnu-indent'
    'gnu-sed'
    'gnu-tar'
    'gnutls'
    'grep'
    'telnet'
    'ossp-uuid' # uuid linux tool
    'tree'
    'wget'
)
for app in ${apps[@]}; do
    if ask "$os: Install tool '${app}'?" N; then
        brew install ${app}
    fi
done
