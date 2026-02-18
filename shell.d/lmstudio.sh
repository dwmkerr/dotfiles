#!/usr/bin/env bash

# Only add lms to PATH if LM Studio is installed.
if [ -d "$HOME/.lmstudio/bin" ]; then
    export PATH="$PATH:$HOME/.lmstudio/bin"
fi
