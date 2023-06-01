#!/usr/bin/env bash

# run a command in multiple directories
eachdir() {
  pattern=$1
  command="${@:2}"
  baseDirName=$(basename `pwd`)

  for dir in `find $1 -type d -maxdepth 1 -mindepth 1`; do

    (cd $dir
    currentBranch=$(if [ -d ".git" ]; then echo "\033[1;34mgit:(\033[0m\033[1;31m`git symbolic-ref --short HEAD`\033[0m\033[1;34m)\033[0m"; fi)
     echo "\033[0;32m➜\033[0m  \033[1m$baseDirName/\033[0m\033[1;36m$(basename `pwd`)\033[0m $currentBranch"; eval $command)
  done
}

# get the ISO8601 time
DT() {
  date +"%Y-%m-%dT%H:%M"
}

# get the ISO8601 date
D() {
  date +"%Y-%m-%d"
}

# Restart the shell.
function restart_shell() {
  exec -l $SHELL
}

# Make a directory (don't fail if it exists) and move into it.
function mkd {
  mkdir -p -- "$1" && cd -P -- "$1";
}

# Cut, but in reverse, e.g:
# $ echo "One;Two;Three;Four;Five" | revcut -d';' -f2
# -> Four
function revcut {
  rev | cut "$@" | rev
}
