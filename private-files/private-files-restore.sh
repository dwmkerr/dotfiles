#!/usr/bin/env bash
shopt -s nullglob
set -e

# private-files-restore.sh
#
# This script is used to restore private and sensitive files, such as ssh keys and
# gpg keys, from an encrypted AWS S3 bucket.

# Load the helper functions.
helper_functions_path="$(dirname "$(readlink -f "$0")")/helper-functions.sh"
source "${helper_functions_path}"

# Set the bucket name and profile. This can be overwritten if needed.
profile=${DOTFILES_PRIVATE_PROFILE:-dwmkerr}
bucket=${DOTFILES_PRIVATE_S3_BUCKET:-dwmkerr-dotfiles-private}

# Ensure the AWS profile exists - if it doesn't, configure it.
if aws_profile_exists "${profile}"; then
    echo "AWS Profile '${profile}' will be used."
else
    echo "AWS Profile '${profile}' does not exist, setting up now:"
    aws configure --profile "${profile}"
fi

# Ensure the AWS profile exists - if it doesn't, configure it.
if [[ $(aws configure --profile "${DOTFILES_PRIVATE_PROFILE}" list >> /dev/null 2>&1) -eq 0 ]]
then
    echo "AWS Profile '${DOTFILES_PRIVATE_PROFILE}' will be used."
else
    echo "AWS Profile '${DOTFILES_PRIVATE_PROFILE}' does not exist, setting up now:"
    aws configure --profile "${DOTFILES_PRIVATE_PROFILE}"
fi

# Alicloud CLI configuration and credentials.
restore_safe "s3://${bucket}/aliyun/config.json" "$HOME/.aliyun/" 

# AWS CLI configuration and credentials
restore_safe "s3://${bucket}/aws/config" "$HOME/.aws/"
restore_safe "s3://${bucket}/aws/credentials" "$HOME/.aws/"

# Azure CLI configuration and credentials.
restore_safe "s3://${bucket}/azure/config" "$HOME/.azure/"

# Google Cloud CLI configuration and credentials.
echo -n "Restore Google Cloud configuration and credentials? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    dest="$HOME/.config/gcloud/"
    mkdir -p "${dest}"
    aws s3 sync "s3://${bucket}/config/gcloud" "${dest}"
fi

# Restore SSH keys and config.
echo -n "Restore SSH keys and configuration? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    dest="$HOME/.ssh/"
    mkdir -p "${dest}"
    aws s3 sync "s3://${bucket}/ssh" "${dest}"

    # Folders are owned by curent user, private keys are 600, public keys are 644.
    chmod 700 ~/.ssh
    find ~/.ssh -type f -exec chmod 0600 {} \;
    find ~/.ssh -type f -exec chmod 0644 {} \;
    find ~/.ssh -type d -exec chmod 0700 {} \;

fi

# Restore GPG secret keys.
echo -n "Restore backup GPG keys? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    aws s3 cp --profile "${profile}" "s3://${bucket}/gpg/secret-keys.asc" - | gpg --import
fi

# Restore GPG trust database.
echo -n "Restore GPG trust database? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    aws s3 cp --profile "${profile}" "s3://${bucket}/gpg/trust-database.txt" - | gpg --import-ownertrust
fi
