#!/usr/bin/env bash

# alises.sh
#
# Contains aliases for working with the shell.

# ---
#
# General purposes aliases.
#
# ---

# Remove formatting from text in the clipboard.
alias clipclean="pbpaste | pbcopy"

# Start a web server
alias serve="python -m SimpleHTTPServer 3000"

# When we use `ag`, provide the a shared `.ignore` file.
alias ag='ag --path-to-ignore ~/.ignore'

# Open vim without loading the vimrc.
alias vinilla='vi -u NONE'
