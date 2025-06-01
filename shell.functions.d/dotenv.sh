dotenv() {
  local name="dotenv"
  if [[ "$1" == "-h" ]]; then
    echo "usage: ${name} [<path_to_env_file>]"
    echo "  Loads environment variable definitions from a .env file, e.g:"
    echo "  KEY=VALUE"
    exit 0
  fi

  # Determine the path to the environment file
  env_file="${1:-.env}"

  if [ ! -f "$1" ]; then
    echo "error: ${env_file} not found"
    echo "usage: ${name} [<path_to_env_file>]"
  else
    set -a
    source "$env_file"
    set +a
    echo "sourced '${env_file}'"
  fi
}
