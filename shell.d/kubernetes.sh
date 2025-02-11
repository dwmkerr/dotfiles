#!/usr/bin/env bash

# This has saved me a lot of time...
alias k='kubectl'

# ZSH auto-completion.
# if [ -n "$BASH_VERSION" ]; then
#     #TODO 
# fi
if [ -n "$ZSH_VERSION" ]; then
    if [ $commands[kubectl] ]; then
      source <(kubectl completion zsh)
    fi
fi
