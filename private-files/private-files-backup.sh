#!/usr/bin/env bash
shopt -s nullglob

# private-files-backup.sh
#
# This script is used to copy private and sensitive files, such as ssh keys and
# gpg keys, to an encrypted AWS S3 bucket. These files can then be restored to
# another machine by running the 'restore-private-files.sh' script.
#
# Note: this script assumes you are logged in with access to the AWS S3 bucket
# below and that the AWS CLI is installed.

# Set the bucket name and profile. This can be overwritten if needed.
profile=${DOTFILES_PRIVATE_PROFILE:-dwmkerr}
bucket=${DOTFILES_PRIVATE_S3_BUCKET:-dwmkerr-dotfiles-private}

# Helper function to backup files after checking with the user first.
function backup_safe() {
    echo -n "Backup '$1' to '$2'? [y/n]: "
    read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
        aws s3 cp "$1" "$2" $3 --profile "${profile}"
    fi
}

# Helper function to check if an AWS profile exists.
function aws_profile_exists() {

    local profile_name="${1}"
    echo -n "Checking for AWS profile: '${profile_name}'... "
    local profile_name_check=$(cat $HOME/.aws/config | grep "\[profile ${profile_name}]")

    if [ -z "${profile_name_check}" ]; then
        echo "profile doesn't exist"
        return 1
    else
        echo "profile exists"
        return 0
    fi
}

# Alicloud CLI configuration and credentials.
backup_safe ~/.aliyun/config.json "s3://${bucket}/aliyun/"

# AWS CLI configuration and credentials.
backup_safe ~/.aws/config "s3://${bucket}/aws/"
backup_safe ~/.aws/credentials "s3://${bucket}/aws/"

# Azure CLI configuration and credentials.
backup_safe ~/.azure/config "s3://${bucket}/azure/"

# Google Cloud CLI configuration and credentials.
for path in ~/.config/gcloud/configurations/*; do
    [ -e "$path" ] || continue
    backup_safe "${path}" "s3://${bucket}/config/gcloud/configurations/"
done
backup_safe ~/.config/gcloud/credentials.db "s3://${bucket}/config/gcloud/"

# Copy SSH keys and config.
for path in ~/.ssh/*; do
    [ -f "$path" ] && backup_safe "${path}" "s3://${bucket}/ssh/"
    [ -d "$path" ] && backup_safe "${path}" "s3://${bucket}/ssh/$(basename $path)/" --recursive
done

# Backup all GPG secret keys.
echo -n "Export and backup GPG keys? [y/n]: "
read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
    gpg --export-secret-keys --armor | aws s3 cp - "s3://${bucket}/gpg/secret-keys.asc"
fi

# Backup the GPG trust database.
echo -n "Export and backup GPG trust database? [y/n]: "
read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
    gpg --export-ownertrust | aws s3 cp - "s3://${bucket}/gpg/trust-database.txt"
fi
