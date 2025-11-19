#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current directory using jq
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Colors using tput
fg_blue=$(tput setaf 4)
fg_green=$(tput setaf 2)
bold=$(tput bold)
dim=$(tput dim)
reset=$(tput sgr0)

# Get PWD limited to 3 folders (like _pwd_max_folders from set_ps1.sh)
pwd_display=$(echo "${CURRENT_DIR/#$HOME/~}" | rev | cut -d'/' -f1-3 | rev)

# Get git info if in a git repo
git_info=""
if cd "$CURRENT_DIR" 2>/dev/null && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info=" ${fg_green}${branch}${reset}"
    fi
fi

# Output the status line
echo "${bold}${fg_blue}${pwd_display}${reset}${git_info} ${dim}? for help${reset}"
