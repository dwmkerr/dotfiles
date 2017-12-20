#!/usr/bin/env bash

# Import environment variables.
source ~/.environment.sh

# Import everything from the .profile folder.
for file in ~/.profile/*; do
    [ -e "$file" ] || continue
    source $file
done

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d ~/.private ]]; then
    for private in ~/.private/*; do
        [ -e "$private" ] || continue
        source $private
    done
fi

# Add support to the terminal for colours.
#   See: https://github.com/nathanbuchar/atom-one-dark-terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
