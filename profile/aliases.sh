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

# ---
#
# OpenShift Aliases
#
# ---

# I have to do this way too often
alias killpod="oc delete pod --grace-period=0 "
