#!/usr/bin/env bash
shopt -s nullglob
set -e
source "./tools/ask.sh"

# private-files-restore.sh
#
# This script is used to restore private and sensitive files, such as ssh keys and
# gpg keys, from an encrypted AWS S3 bucket.

echo "WARNING: aws/gpg/pinentry-mac must be installed and configured..."
echo "run 'make setup' first and install 'git + gpg' features"

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
    aws s3 sync --profile "${profile}" "s3://${bucket}/config/gcloud" "${dest}"
fi

# Restore SSH keys and config.
echo -n "Restore SSH keys and configuration? (Warning, will overwrite existing) [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    dest="$HOME/.ssh/"
    mkdir -p "${dest}"
    aws s3 sync --profile "${profile}" "s3://${bucket}/ssh" "${dest}"

    # Folders are owned by curent user, private keys are 600, public keys are 644.
    chmod 700 ~/.ssh
    find ~/.ssh -type f -exec chmod 0600 {} \;
    find ~/.ssh/*.pub -type f -exec chmod 0644 {} \;
    find ~/.ssh -type d -exec chmod 0700 {} \;

fi

# Warn about authorizing secret keys for SSO.
echo "Warning: Any GitHub Organisations which require SSO will need to have"
echo "their authorisation set up for your SSH keys. Configure this at:"
echo "  https://github.com/settings/keys"
echo ""

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

# Restore Boxes config.
if ask "Restore '~/boxes.json'" N; then
    restore_safe "s3://${bucket}/boxes.json" ~/.boxes.json
fi
