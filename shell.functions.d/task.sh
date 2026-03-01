task() {
  local name="task"
  if [[ "$1" == "-h" ]]; then
    echo "usage: ${name} <task-name>"
    echo "  Creates a new task folder in ~/tasks and opens a tmux window for it, e.g:"
    echo "  ${name} fix login bug"
    return 0
  fi

  # Must be running inside tmux.
  if [[ -z "${TMUX}" ]]; then
    echo "error: must be running in tmux"
    return 1
  fi

  # Need a task name.
  if [[ -z "$1" ]]; then
    echo "error: no task name specified"
    echo "usage: ${name} <task-name>"
    return 1
  fi

  # Build a safe folder name from the input.
  local raw_name="$*"
  local safe_name=$(echo "${raw_name}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

  # Find the next task number.
  mkdir -p ~/tasks
  local last_num=$(ls -1d ~/tasks/task-* 2>/dev/null | sed 's/.*task-\([0-9]*\).*/\1/' | sort -n | tail -1)
  local next_num=$(printf "%02d" $(( ${last_num:-0} + 1 )))

  local task_dir=~/tasks/task-${next_num}-${safe_name}
  local task_label="task-${next_num}-${safe_name}"

  # Create the task folder.
  mkdir -p "${task_dir}"

  # Create a tmux window, split it vertically, and select the left pane.
  tmux new-window -n "${task_label}" -c "${task_dir}"
  tmux split-window -h -c "${task_dir}"
  tmux select-pane -L

  echo -e "created \e[1;32m${task_label}\e[0m"
}
