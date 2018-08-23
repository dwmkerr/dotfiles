#!/usr/bin/env bash

# If we do not have go installed, no need to set the env.
if [ -x "$(command -v go)" ]; then

    # Add the Go binaries to the path.
    export PATH=$PATH:$(go env GOPATH)/bin

    # Export GOBIN and GOPATH, setting our global go home directory.
    export GOPATH=$(go env GOPATH)
    export GOBIN=$GOPATH/bin

fi
