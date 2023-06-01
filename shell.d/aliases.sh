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

# Start a web server, Python 2 or 3.
alias serve_python2="python -m SimpleHTTPServer 3000"
alias serve="python -m http.server 3000"

# When we use `ag`, provide the a shared `.ignore` file.
alias ag='ag --path-to-ignore ~/.ignore'

# Open vim without loading the vimrc.
alias vimnilla='vi -u NONE'

# Open bash without loading and config.
alias bashnilla='bash --noprofile --norc'

# Quick links to locations.
alias gorepos='cd ~/repos'
