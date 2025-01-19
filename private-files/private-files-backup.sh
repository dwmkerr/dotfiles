#!/usr/bin/env bash
shopt -s nullglob

# private-files-backup.sh
#
# This script is used to copy private and sensitive files, such as ssh keys and
# gpg keys, to an encrypted AWS S3 bucket. These files can then be restored to
# another machine by running the 'restore-private-files.sh' script.

# Load the helper functions.
helper_functions_path="$(dirname "$(readlink -f "$0")")/helper-functions.sh"
source "${helper_functions_path}"

# Set the bucket name and profile. This can be overwritten if needed.
profile=${DOTFILES_PRIVATE_PROFILE:-dwmkerr}
bucket=${DOTFILES_PRIVATE_S3_BUCKET:-dwmkerr-dotfiles-private}

# Ensure the AWS profile exists - if it doesn't, configure it.
if aws_profile_exists "${profile}"; then
    echo "AWS Profile "${profile}" will be used."
else
    echo "AWS Profile "${profile}" does not exist, setting up now:"
    aws configure --profile "${profile}"
fi

# Ensure the AWS profile exists - if it doesn't, configure it.
if [[ $(aws configure --profile "${DOTFILES_PRIVATE_PROFILE}" list >> /dev/null 2>&1) -eq 0 ]]; then
    echo 'AWS Profile "${DOTFILES_PRIVATE_PROFILE}" will be used.'
else
    echo 'AWS Profile "${DOTFILES_PRIVATE_PROFILE}" does not exist, setting up now:'
    aws configure --profile "${DOTFILES_PRIVATE_PROFILE}"
fi

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
    gpg --export-secret-keys --armor | aws s3 cp --profile "${profile}" - "s3://${bucket}/gpg/secret-keys.asc"

fi

# Backup the GPG trust database.
echo -n "Export and backup GPG trust database? [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    gpg --export-ownertrust | aws s3 cp --profile "${profile}" - "s3://${bucket}/gpg/trust-database.txt"
fi
