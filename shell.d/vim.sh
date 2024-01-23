# If neovim exists, alias vi/vim to it.
if [ -x "$(command -v nvim)" ]; then
    alias vi=nvim
    alias vim=nvim
fi
