# Echo's the operating system, simplified to:
# - osx
# - ubuntu
get_os() {
    # Identify the operating system.
    local un=$(uname -a)
    os="unknown"
    if [[ "$un" =~ [Dd]arwin ]]; then
        echo "osx"
    elif [[ "$un" =~ [Uu]buntu ]]; then
        echo "ubuntu"
    else
        logger -s "Unable to idenfify operating system from uname '$un'"
        exit 1
    fi
}
