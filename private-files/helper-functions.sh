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
    echo -n "Restore '$1' to '$2'? [y/n]: "
    read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
        mkdir -p "$(dirname $2)"
        echo "Preparing to run: aws s3 cp \"$1\" \"$2\" $3 --profile \"${profile}"
        aws s3 cp --profile "${profile}" "$1" "$2" $3
    fi
}

# Helper function to check if an AWS profile exists.
# Returns: 0 if the profile exists, 1 if it doesn't and 2 if the config doesn't
# exist.
aws_profile_exists() {
    local profile_name="${1}"
    local config_path="${HOME}/.aws/config"
    echo -n "Checking for AWS profile: '${profile_name}'... "

    # If the AWS config file doesn't exist, then the profile doesn't exist.
    if [ ! -r "${config_path}" ]; then
        echo "profile doesn't exist"
        return 2
    fi

    # Grep the config file for the profile entry, e.g. a line that starts with:
    # [profile <profile_name>]
    local profile_name_check=$(cat "${config_path}" | grep "\[profile ${profile_name}]")
    if [ -z "${profile_name_check}" ]; then
        echo "profile doesn't exist"
        return 1
    else
        echo "profile exists"
        return 0
    fi
}

