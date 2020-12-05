#!/usr/bin/env bash
shopt -s nullglob

# private-files-restore.sh
#
# This script is used to restore private and sensitive files, such as ssh keys and
# gpg keys, from an encrypted AWS S3 bucket.
#
# Note: this script assumes you are logged in with access to the AWS S3 bucket
# below and that the AWS CLI is installed.

# Set the bucket name and profile. This can be overwritten if needed.
profile=${DOTFILES_PRIVATE_PROFILE:-dwmkerr}
bucket=${DOTFILES_PRIVATE_S3_BUCKET:-dwmkerr-dotfiles-private}

# Helper function to restore files after checking with the user first.
function restore_safe() {
    echo -n "Restore '$1' to '$2'? [y/n]: "
    read yesno
    if [[ $yesno =~ ^[Yy] ]]; then
        mkdir -p "$(dirname $2)"
        aws s3 cp "$1" "$2" $3 --profile "${profile}"
    fi
}

# Alicloud CLI configuration and credentials.
copy_safe "s3://${bucket}/aliyun/" "$HOME/.aliyun/config.json" 

# AWS CLI configuration and credentials.
copy_safe "s3://${bucket}/aws/" "$HOME/.aws/config"
copy_safe "s3://${bucket}/aws/" "$HOME/.aws/credentials"

# Azure CLI configuration and credentials.
copy_safe "s3://${bucket}/azure/" "$HOME/.azure/config"

# Google Cloud CLI configuration and credentials.
echo -n "Restore Google Cloud configuration and credentials? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    dest="$HOME/.config/gcloud/"
    mkdir -p "${dest}"
    aws s3 sync "s3://${bucket}/config/gcloud/" "${dest}"
fi

# Restore SSH keys and config.
echo -n "Restore SSH keys and configuration? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    dest="$HOME/.ssh/"
    mkdir -p "${dest}"
    aws s3 sync "s3://${bucket}/ssh/" "${dest}"
fi

# Restore GPG secret keys.
echo -n "Restore backup GPG keys? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    aws s3 cp "s3://${bucket}/gpg/secret-keys.asc" - | gpg --import
fi

# Restore GPG trust database.
echo -n "Restore GPG trust database? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    aws s3 cp "s3://${bucket}/gpg/trust-database.txt" - | gpg  --import-ownertrust
fi
