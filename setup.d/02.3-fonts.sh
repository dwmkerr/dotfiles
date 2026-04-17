# Install fonts checked into the repo (includes MonacoNerdFont referenced
# by the iTerm2 profiles, required for nvim-web-devicons glyphs). macOS
# picks these up automatically on next app launch.
if [[ "$os" == "osx" ]]; then
    if ask "$os: Install repo fonts to ~/Library/Fonts?" N; then
        mkdir -p ~/Library/Fonts
        cp -v fonts/*.ttf ~/Library/Fonts/
    fi
elif [[ "$os" == "ubuntu" ]]; then
    if ask "$os: Install repo fonts to ~/.local/share/fonts?" N; then
        mkdir -p ~/.local/share/fonts
        cp -v fonts/*.ttf ~/.local/share/fonts/
        fc-cache -f
    fi
fi
