# Install RVM, but do not automatically try and edit a bash profile or whatever
# to source commands, we'll handle that ourselves in the ~/.profile/ruby.sh
# script. Get the GPG keys first.
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles

# Check if the user wants to install Ruby.
ruby_ver="2.6"

source $HOME/.rvm/scripts/rvm
if ! ask "$os: setup Ruby ${ruby_ver} as the default?" Y; then
    return 0
fi
rvm install ruby ${ruby_ver}
rvm use ruby ${ruby_ver} --default
