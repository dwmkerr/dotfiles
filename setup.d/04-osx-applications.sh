# Bail if we are not on OSX.
if [[ "$os" != "osx" ]]; then
    echo "warning: cannot setup OSX applications on '${os}', stopping..."
    return 0
fi

apps=('1password'
'dropbox'
'vlc'
'virtualbox'
'vagrant'
'virtualbox'
'iterm2'
'visual-studio-code'
'whatsapp'
'slack'
'font-hack'
'docker'
'kubectl'
'minikube'
'steam'
'transmission'
'cyberduck'
'parallels'
'spotmenu'
'spectacle'
)

for app in $apps; do
    brew install caskroom/cask/brew-cask
    brew tap caskroom/fonts

    if ask "$os: Install Application '${app}'?" Y; then
        brew cask install ${app}
    fi
done

# Install Linux apps.
apps=('coreutils'
'findutils'
'gnu-indent'
'gnu-sed'
'gnutls'
'grep'
'gnu-tar'
'gawk'
'telnet'
'wget'
'tree'
)
for app in $apps; do
    if ask "$os: Install tool '${app}'?" Y; then
        brew install ${app}
    fi
done
