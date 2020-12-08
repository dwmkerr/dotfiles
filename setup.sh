# Load each of the tools.
for file in ./tools/*; do
    [ -e "$file" ] || continue
    echo "Loading tool '$file'..."
    source "$file"
done

# Get the operating system, output it. The script will terminate if the OS
# cannot be categorically identified.
os=$(get_os)
echo "os identified as: $os"

# Run each of the setup files.
for file in ./setup.d/*; do
    # If we don't have a file (this happens when we find no results), then just
    # move onto the next file (or finish the loop).
    [ -e "$file" ] || continue

    # Ask the user if they want to setup the feature, then setup or skip.
    feature=$(basename "$file")
    if ! ask "$os: setup feature '$feature'?" "y/N"; then continue; fi
    source $file
done

# Many changes (such as chsh) need a restart, offer it now,
if ask "$os: Some changes may require a restart - restart now?" Y; then
    if [[ "$os" == "osx" ]]; then
        echo "$os: Restarting..."
        sudo shutdown -r now
    elif [[ "$os" == "ubuntu" ]]; then
        echo "$os: Restarting..."
        echo "TODO"
    fi
fi
