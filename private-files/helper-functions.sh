# This script should not be called directly - instead it is sourced by the
# backup and restore scripts.

# Helper function to backup files after checking with the user first.
backup_safe() {
    if [ ! -r "${1}" ]; then
        echo "skipping missing file '${1}'..."
    else
        echo -n "backup '$1' to '$2'? [y/n]: "
        read yesno
        if [[ $yesno =~ ^[Yy] ]]; then
            aws s3 cp --profile "${profile}" "$1" "$2" $3
        fi
    fi
}

# Helper function to restore files after checking with the user first.
restore_safe() {
    echo -n "Restore '$1' to '$2'? (Warning, will overwrite existing) [y/n]: "
    read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
        mkdir -p "$(dirname $2)"
        echo "Preparing to run: aws s3 cp \"$1\" \"$2\" $3 --profile \"${profile}"
        aws s3 cp --profile "${profile}" "$1" "$2" $3
    fi
}

