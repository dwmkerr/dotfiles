#!/usr/bin/env bash

# If we do not have go installed, no need to set the env.
if [ -x "$(command -v go)" ]; then

    # Export GOBIN and GOPATH, setting our global go home directory.
    export GOPATH=$HOME/go
    export GOBIN="$GOROOT/bin"
    export PATH=$PATH:"$GOBIN"

fi
