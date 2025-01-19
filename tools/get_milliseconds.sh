get_milliseconds() {
    local timestamp
    timestamp=$(date +%s%N 2>/dev/null | sed 's/[^0-9]//g')

    # If the timestamp is in nanoseconds (19 digits), convert it to milliseconds
    if (( ${#timestamp} > 13 )); then
        timestamp=$((timestamp / 1000000))
    elif (( ${#timestamp} == 10 )); then
        # If the timestamp is in seconds (10 digits), convert it to milliseconds
        timestamp=$((timestamp * 1000))
    fi

    # Ensure the timestamp is valid and numeric
    if [[ $timestamp =~ ^[0-9]+$ ]]; then
        echo "$timestamp"
    else
        echo "error: invalid timestamp generated: $timestamp" >&2
        exit 1
    fi
}
