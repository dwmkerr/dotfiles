#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current directory and model name using jq
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL_NAME=$(echo "$input" | jq -r '.model.display_name')

# Colors using ANSI codes directly
reset=$'\e[0m'
bold=$'\e[1m'
fg_blue=$'\e[34m'
fg_green=$'\e[32m'
fg_grey=$'\e[90m'
fg_purple=$'\e[35m'
# Context colors based on usage thresholds
ctx_green=$'\e[92m'      # 0-30% used
ctx_yellow=$'\e[93m'     # 30-50% used
ctx_red=$'\e[91m'        # 50-60% used
ctx_darkred=$'\e[1;31m'  # 60%+ used

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

# Calculate context remaining percentage
context_size=$(echo "$input" | jq -r '.context_window.context_window_size')
usage=$(echo "$input" | jq '.context_window.current_usage')

context_display=""
if [ "$usage" != "null" ] && [ "$context_size" != "null" ] && [ "$context_size" != "0" ]; then
    current_tokens=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    used_percent=$((current_tokens * 100 / context_size))
    remaining=$((100 - used_percent))

    # Color based on used%: 0-30 green, 30-50 amber, 50-60 red, 60-80 dark red, 80+ fire
    if [ "$used_percent" -lt 30 ]; then
        ctx_color="${ctx_green}"
        ctx_icon=""
    elif [ "$used_percent" -lt 50 ]; then
        ctx_color="${ctx_yellow}"
        ctx_icon=""
    elif [ "$used_percent" -lt 60 ]; then
        ctx_color="${ctx_red}"
        ctx_icon=""
    elif [ "$used_percent" -lt 80 ]; then
        ctx_color="${ctx_darkred}"
        ctx_icon=""
    else
        ctx_color="${ctx_darkred}"
        ctx_icon="🔥"
    fi

    context_display=" ${fg_grey}|${reset} ${ctx_color}${ctx_icon}${remaining}%${reset} ${fg_grey}context left${reset}"
fi

# Build model display
model_display=""
if [ -n "$MODEL_NAME" ] && [ "$MODEL_NAME" != "null" ]; then
    model_display=" ${fg_grey}|${reset} ${fg_purple}${MODEL_NAME}${reset}"
fi

# Identity badge (only for non-default identities)
identity_display=""
if [ -n "$DOTFILES_IDENTITY" ] && [ "$DOTFILES_IDENTITY" != "dwmkerr" ]; then
    fg_id_color=$'\e[32m'
    case "${IDENTITY_COLOR:-}" in
        red)     fg_id_color=$'\e[31m' ;;
        green)   fg_id_color=$'\e[32m' ;;
        yellow)  fg_id_color=$'\e[33m' ;;
        blue)    fg_id_color=$'\e[34m' ;;
        magenta) fg_id_color=$'\e[35m' ;;
        cyan)    fg_id_color=$'\e[36m' ;;
    esac
    identity_display="${bold}${fg_id_color}${DOTFILES_IDENTITY}${reset} "
fi

# Output the status line
echo "${identity_display}${bold}${fg_blue}${pwd_display}${reset}${git_info} ${fg_grey}? for help${reset}${context_display}${model_display}"
