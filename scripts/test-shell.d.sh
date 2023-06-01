# This script can be used to test that the ~/.shell.d/ folder's contents are
# sourced properly.

# On MacOS we need to use gdate from coreutils:
# brew install coreutils
alias date='gdate'
function start_timer() {
    timestamp_start=$(date +%s%N)
}
function stop_timer() {
    timestamp_stop=$(date +%s%N)
    milliseconds=$((( $timestamp_stop- $timestamp_start ) / 1000000))
    echo $milliseconds
}

# Loop through each profile file, source if the user confirms, time result.
for file in $HOME/.shell.d/*; do
    [ -e "$file" ] || continue

    printf "Source: ${file} (y/n)? "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        start_timer
        source "$file"
        milliseconds=$(stop_timer)
        echo "Sourced in ${milliseconds}ms"
    fi
done
