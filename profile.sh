#!/usr/bin/env bash

# Import environment variables.
source ~/.environment.sh

# Import everything from the .profile folder.
source ~/.profile/aliases.sh
source ~/.profile/openshift.sh

# If we have a .private folder, source everything in it. This is useful for
# automatically loading things like project specific secrets.
if [[ -d ~/.private ]]; then
    for private in ~/.private/*; do
        [ -e "$private" ] || continue
        source $private
    done
fi
