sourceenv() {
  local name="sourceenv"
  local verbose=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h)
        echo "usage: ${name} [-v] [<path_to_env_file>]"
        echo "  Sources environment variable definitions from a .env file, e.g:"
        echo "  KEY=VALUE"
        echo "  -v  verbose mode (show values being set)"
        exit 0
        ;;
      -v)
        verbose=true
        shift
        ;;
      *)
        env_file="$1"
        shift
        ;;
    esac
  done

  # Determine the path to the environment file
  env_file="${env_file:-.env}"

  if [ ! -f "$env_file" ]; then
    echo "error: ${env_file} not found"
    echo "usage: ${name} [-v] [<path_to_env_file>]"
  else
    # Process each line in the env file
    while IFS= read -r line || [ -n "$line" ]; do
      # Skip empty lines and comment lines
      [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
      
      # Remove inline comments (but not inside quotes)
      if [[ "$line" =~ ^([^#]*[^[:space:]])([[:space:]]*#.*)?$ ]]; then
        line="${BASH_REMATCH[1]}"
      fi
      
      # Split on first = sign
      if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
        var_name="${BASH_REMATCH[1]}"
        var_value="${BASH_REMATCH[2]}"
        
        # Remove surrounding quotes if present
        if [[ "$var_value" =~ ^\"(.*)\"$ ]] || [[ "$var_value" =~ ^\'(.*)\'$ ]]; then
          var_value="${BASH_REMATCH[1]}"
        fi
        
        # Check if variable already exists and show status
        if [[ -n "${!var_name:-}" ]]; then
          if [[ "$verbose" == true ]]; then
            echo -e "\033[34m${var_name}\033[0m: updated ($var_value)"
          else
            echo -e "\033[34m${var_name}\033[0m: updated"
          fi
        else
          if [[ "$verbose" == true ]]; then
            echo -e "\033[32m${var_name}\033[0m: set ($var_value)"
          else
            echo -e "\033[32m${var_name}\033[0m: set"
          fi
        fi
        
        # Set the variable
        export "${var_name}=${var_value}"
      fi
    done < "$env_file"
  fi
}
