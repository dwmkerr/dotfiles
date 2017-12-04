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

# ---
#
# Git Commands
#
# ---

# Not really a command, but a much nicer version of git branch.
# Source: https://stackoverflow.com/questions/2514172/listing-each-branch-and-its-lastevisions-date-in-git
alias gbr='for k in `git branch -l | \
    perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; \
    do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | \
    head -n 1`\\t$k; done | sort -r'
