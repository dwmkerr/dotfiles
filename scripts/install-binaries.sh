#!/usr/bin/env bash

# install-binaries.sh - Install dotfiles binaries to /usr/local/bin

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="${DOTFILES_DIR}/bin"
INSTALL_DIR="/usr/local/bin"

echo "Installing binaries from ${BIN_DIR} to ${INSTALL_DIR}..."

for binary in "${BIN_DIR}"/*; do
    if [[ -f "$binary" && -x "$binary" ]]; then
        binary_name=$(basename "$binary")
        echo "Installing: $binary_name"
        sudo ln -sf "$binary" "${INSTALL_DIR}/$binary_name"
    fi
done

echo "Done!" 