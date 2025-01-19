# This script can be used to test that the ~/.shell.d/ folder's contents are
# sourced properly.
set -e

# Load each of the tools.
for file in ./tools/*; do
    [ -e "$file" ] || continue
    echo "Loading tool '$file'..."
    source "$file"
done

start_timer() {
    timestamp_start=$(get_milliseconds)
    echo "start timer at $timestamp_start"
}

stop_timer() {
    timestamp_stop=$(get_milliseconds)
    if [[ -z "$timestamp_start" ]]; then
        echo "error: timer was not started." >&2
        exit 1
    fi
    echo "stop timer at $timestamp_stop"
    milliseconds=$((timestamp_stop - timestamp_start))
    echo "time taken: ${milliseconds}ms"
}

# Loop through each profile file, source if the user confirms, time result.
for file in "$HOME/.shell.d/"*; do
    [ -e "$file" ] || continue
    [ -f "$file" ] || continue  # Ensure it's a regular file

    if ask "test ${file}?" "N"; then
        start_timer
        # Ensure DEBUG is set and run with rcfile
        DEBUG=1 bash  -e -x -c "source ${file}" || {
            echo "error: Failed to source ${file}" >&2
            exit 1
        }
        sleep 1
        echo "debug: slept for 1000ms..."
        stop_timer
    fi
done
