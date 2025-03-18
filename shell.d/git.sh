# Wrap 'git' with 'hub' - if we have hub installed.
if [ -x "$(command -v hub)" ]; then
    eval "$(hub alias -s)"
fi

# Basic alises based on the 'git' OMZ plugin.
# For reference, see:
#   https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
git_current_branch() {
    git branch --show-current
}

# Check if main exists and use instead of master
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# Basic alises based on the 'git' OMZ plugin.
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
alias ga='git add'
alias gb='git branch'
alias gd='git diff'
alias gf='git fetch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit --verbose'
alias gst='git status'
alias gsm='git switch main'
alias gcm='git checkout main'
alias gl='git pull'

# Push to origin.
gpo() {
    git push --set-upstream origin "$(git_current_branch)"
}

# My own personal git functions or shorthands.

# Clone from GitHub.
ghclone() {
    git clone git@github.com:$1
}

# Release-As - useful for Release-Please
release_as() {
    git commit --allow-empty -m "chore: release $1" -m "Release-As: $1"
}

ghopen() {
  # Work out the repo/org from the folder we're in.
  # (Probably could do it better from .git).
  local org
  org=$(basename "$(dirname "$PWD")")
  local repo
  repo=$(basename "$(pwd)")
  url="https://github.com/$org/$repo"

  # Print the url we'll open.
  local green='\e[0;32m'
  local reset='\e[0m'
  printf "\nOpening: ${green}${url}${reset}...\n"

  # And open it. Easy.
  python3 -mwebbrowser "${url}"
}

# Not really a command, but a much nicer version of git branch.
# Source: https://stackoverflow.com/questions/2514172/listing-each-branch-and-its-lastevisions-date-in-git
alias gbranch='for k in `git branch -l | \
    perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; \
    do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | \
    head -n 1`\\t$k; done | sort -r'
alias gbranchr='for k in `git branch -r | \
    perl -pe '\''s/^..(.*?)( ->.*)?$/\1/'\''`; \
    do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | \
    head -n 1`\\t$k; done | sort -r'
