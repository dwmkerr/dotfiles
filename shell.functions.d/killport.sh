killport() {
  local name="killport"
  if [[ "$1" == "-h" ]]; then
    echo "usage: ${name} <port>"
    echo "  Kills the process using the specified port, e.g:"
    echo "  ${name} 8080"
    return 0
  fi

  # Check if port number was provided
  if [[ -z "$1" ]]; then
    echo "error: no port specified"
    echo "usage: ${name} <port>"
    return 1
  fi

  local port="$1"
  
  # Find the first process using the port (handles parent/child PIDs)
  local pid=$(lsof -ti :"${port}" | head -n 1)
  
  if [[ -z "$pid" ]]; then
    echo "no process found using port ${port}"
    return 1
  fi
  
  # Get process info before killing it
  local process_info=$(ps -p "${pid}" -o comm | tail -n 1)
  
  # Kill the process, update the user.
  if kill "${pid}"; then
    echo -e "killed process using port \e[1;37m${port}\e[0m: \e[1;32m${process_info}\e[0m"
  else
    echo "failed to kill process ${pid} using port ${port}"
    return 1
  fi
} 
