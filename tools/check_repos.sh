#!/usr/bin/env bash
set -e
# Recursively find all Git repos under a directory,
# show which ones have uncommitted changes or unpushed commits.
#
check_repos() {
    SEARCH_DIR="${1:-.}"
    echo "seaching '${SEARCH_DIR}' for '${GIT_DIR}'..."

    # Use 'find' to locate all '.git' directories; for each, process the parent folder.
    while IFS= read -r -d '' GIT_DIR; do
      # The Git repo is the parent directory of the .git folder
      REPO_DIR="$(dirname "$GIT_DIR")"

      # Move into the repo directory
      cd "$REPO_DIR" || continue

      # Check for uncommitted changes using 'git status --porcelain'
      UNCOMMITTED=$(git status --porcelain 2>/dev/null)

      # Check if branch is ahead of remote using 'git status -sb'
      # Look for the string '[ahead ' in the short branch status.
      AHEAD=$(git status -sb 2>/dev/null | grep '\[ahead')

      # If either uncommitted changes exist or the branch is ahead of remote, print info
      if [[ -n "$UNCOMMITTED" || -n "$AHEAD" ]]; then
        echo "------------------------------------------------------------"
        echo "Repository: $REPO_DIR"
        if [[ -n "$UNCOMMITTED" ]]; then
          echo "  -> Uncommitted changes"
        fi
        if [[ -n "$AHEAD" ]]; then
          echo "  -> Commits not pushed to remote"
        fi
        echo
      fi
    done < <(find "$SEARCH_DIR" -type d -name .git -print0)
}
