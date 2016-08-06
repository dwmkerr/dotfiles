# Ensure that we have a .bashrc file sourced from the MacOSX profile.
touch ~/.bashrc
echo "source ~/.bashrc" >> ~/.profile
source ~/.profile
