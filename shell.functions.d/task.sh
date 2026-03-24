task() {
  local name="task"

  if [[ "$1" == "-h" ]]; then
    echo "usage:"
    echo "  ${name} <task-name>    create or switch to a task"
    echo "  ${name}                list tasks"
    echo "  ${name} -r <pattern>   resume a task in a new tmux window"
    echo "  ${name} -d <pattern>   delete a task and its folder"
    echo "  ${name} --complete     archive the current task folder"
    return 0
  fi

  # --- Complete (archive) current task ---
  if [[ "$1" == "--complete" ]]; then
    local current_dir="$PWD"
    local current_name="$(basename "$current_dir")"
    local parent_dir="$(dirname "$current_dir")"

    # Verify we're in a task folder under ~/tasks.
    if [[ "$parent_dir" != "$HOME/tasks" ]] || [[ "$current_name" != task-* ]]; then
      echo "error: not in a task folder (~/tasks/task-*)"
      return 1
    fi

    local archive_dir="$HOME/tasks/zz-archive"
    mkdir -p "$archive_dir"
    mv "$current_dir" "$archive_dir/"
    echo -e "archived \e[1;32m${current_name}\e[0m → zz-archive/"

    if [[ -n "${TMUX}" ]]; then
      tmux kill-window
    else
      cd ~/tasks
    fi
    return 0
  fi

  # Must be running inside tmux.
  if [[ -z "${TMUX}" ]]; then
    echo "error: must be running in tmux"
    return 1
  fi

  # --- List tasks (no args) ---
  if [[ -z "$1" ]]; then
    local dirs=()
    for d in ~/tasks/task-*; do
      [[ -d "$d" ]] && dirs+=("$d")
    done
    if [[ ${#dirs[@]} -eq 0 ]]; then
      echo "no tasks found in ~/tasks/"
      return 0
    fi
    for d in "${dirs[@]}"; do
      echo "🟠 $(basename "$d")"
    done
    return 0
  fi

  # --- Delete task ---
  if [[ "$1" == "-d" ]]; then
    shift
    if [[ -z "$1" ]]; then
      echo "error: specify a pattern to match, e.g. task -d 02"
      return 1
    fi
    local pattern="$*"
    local matches=()
    for d in ~/tasks/task-*; do
      [[ -d "$d" ]] && [[ "$(basename "$d")" == *"${pattern}"* ]] && matches+=("$d")
    done
    if [[ ${#matches[@]} -eq 0 ]]; then
      echo "no task matching '${pattern}'"
      return 1
    elif [[ ${#matches[@]} -gt 1 ]]; then
      echo "multiple matches — be more specific:"
      for d in "${matches[@]}"; do echo "  $(basename "$d")"; done
      return 1
    fi
    local target="${matches[0]}"
    local label="$(basename "$target")"
    rm -rf "$target"
    tmux kill-window -t "🟠 ${label}" 2>/dev/null
    echo -e "deleted \e[1;31m${label}\e[0m"
    return 0
  fi

  # --- Resume task ---
  if [[ "$1" == "-r" ]]; then
    shift
    if [[ -z "$1" ]]; then
      echo "error: specify a pattern to match, e.g. task -r 01"
      return 1
    fi
    local pattern="$*"
    local matches=()
    for d in ~/tasks/task-*; do
      [[ -d "$d" ]] && [[ "$(basename "$d")" == *"${pattern}"* ]] && matches+=("$d")
    done
    if [[ ${#matches[@]} -eq 0 ]]; then
      echo "no task matching '${pattern}'"
      return 1
    elif [[ ${#matches[@]} -gt 1 ]]; then
      echo "multiple matches — be more specific:"
      for d in "${matches[@]}"; do echo "  $(basename "$d")"; done
      return 1
    fi
    local target="${matches[0]}"
    local label="$(basename "$target")"
    tmux new-window -n "🟠 ${label}" -c "${target}"
    tmux split-window -h -c "${target}"
    tmux select-pane -L
    echo -e "resumed \e[1;32m${label}\e[0m"
    return 0
  fi

  # --- Switch to existing task if already open in tmux ---
  local raw_name="$*"
  local safe_name=$(echo "${raw_name}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

  # Check if any existing task directory matches the safe_name.
  local existing_dir=""
  for d in ~/tasks/task-*; do
    if [[ -d "$d" ]] && [[ "$(basename "$d")" == *"${safe_name}"* ]]; then
      existing_dir="$d"
      break
    fi
  done

  if [[ -n "${existing_dir}" ]]; then
    local existing_label="$(basename "${existing_dir}")"
    local window_name="🟠 ${existing_label}"
    # Switch to the window if it's already open.
    if tmux select-window -t "${window_name}" 2>/dev/null; then
      echo -e "switched to \e[1;32m${existing_label}\e[0m"
      return 0
    fi
  fi

  # --- Create new task ---
  mkdir -p ~/tasks
  # Only consider folders that have a numeric prefix after 'task-'.
  local last_num=$(ls -1d ~/tasks/task-* 2>/dev/null | grep -o 'task-[0-9][0-9]*' | sed 's/task-//' | sort -n | tail -1)
  local next_num=$(printf "%02d" $(( ${last_num:-0} + 1 )))

  local task_dir=~/tasks/task-${next_num}-${safe_name}
  local task_label="task-${next_num}-${safe_name}"

  mkdir -p "${task_dir}"
  tmux new-window -n "🟠 ${task_label}" -c "${task_dir}"
  tmux split-window -h -c "${task_dir}"
  tmux select-pane -L
  echo -e "created \e[1;32m${task_label}\e[0m"
}

# Tab completion: complete task directory names from ~/tasks/task-*
_task_completions() {
  local tasks=()
  for d in ~/tasks/task-*; do
    [[ -d "$d" ]] && tasks+=("$(basename "$d")")
  done

  if [ -n "${ZSH_VERSION:-}" ]; then
    local flags=('-h' '-r' '-d' '--complete')
    case "${words[2]}" in
      -r|-d) compadd -- "${tasks[@]}" ;;
      *)     compadd -- "${flags[@]}" "${tasks[@]}" ;;
    esac
  else
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "$prev" in
      -r|-d) COMPREPLY=($(compgen -W "${tasks[*]}" -- "$cur")) ;;
      *)     COMPREPLY=($(compgen -W "-h -r -d --complete ${tasks[*]}" -- "$cur")) ;;
    esac
  fi
}

if [ -n "${ZSH_VERSION:-}" ]; then
  compdef _task_completions task
else
  complete -F _task_completions task
fi
