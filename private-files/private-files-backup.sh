#!/usr/bin/env bash
shopt -s nullglob
set -e
source "./tools/ask.sh"

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

echo ""
echo "Scanning for files to backup..."

# Arrays to track files
declare -a files_to_backup=()
declare -a files_missing=()
declare -a backup_commands=()
declare -A backup_file_map=()

# Function to check and queue file for backup
queue_for_backup() {
    local file="$1"
    local destination="$2"
    local flags="$3"
    
    if [ -r "$file" ]; then
        files_to_backup+=("$file -> $destination")
        backup_commands+=("aws s3 cp --profile \"${profile}\" \"$file\" \"$destination\" $flags")
        backup_file_map["$file"]="backed_up"
    else
        files_missing+=("$file")
        backup_file_map["$file"]="missing"
    fi
}

# Alicloud CLI configuration and credentials.
queue_for_backup ~/.aliyun/config.json "s3://${bucket}/aliyun/"

# AWS CLI configuration and credentials.
queue_for_backup ~/.aws/config "s3://${bucket}/aws/"
queue_for_backup ~/.aws/credentials "s3://${bucket}/aws/"

# Azure CLI configuration and credentials.
queue_for_backup ~/.azure/config "s3://${bucket}/azure/"

# Google Cloud CLI configuration and credentials.
for path in ~/.config/gcloud/configurations/*; do
    [ -e "$path" ] || continue
    queue_for_backup "${path}" "s3://${bucket}/config/gcloud/configurations/"
done
queue_for_backup ~/.config/gcloud/credentials.db "s3://${bucket}/config/gcloud/"

# AI configuration files
queue_for_backup ~/.ai/config.yaml "s3://${bucket}/ai/"
queue_for_backup ~/.ai/config.openai.yaml "s3://${bucket}/ai/"
queue_for_backup ~/.ai/config.gemeni.yaml "s3://${bucket}/ai/"

# Common dotfiles
queue_for_backup ~/.gitconfig "s3://${bucket}/git/"
queue_for_backup ~/.bashrc "s3://${bucket}/shell/"
queue_for_backup ~/.zshrc "s3://${bucket}/shell/"
queue_for_backup ~/.vimrc "s3://${bucket}/vim/"

# Neovim configurations (both traditional and modern)
queue_for_backup ~/.config/nvim/init.vim "s3://${bucket}/nvim/"
queue_for_backup ~/.config/nvim/init.lua "s3://${bucket}/nvim/"

# Copy SSH keys and config.
for path in ~/.ssh/*; do
    if [ -f "$path" ]; then
        queue_for_backup "${path}" "s3://${bucket}/ssh/"
    elif [ -d "$path" ]; then
        queue_for_backup "${path}" "s3://${bucket}/ssh/$(basename $path)/" "--recursive"
    fi
done

# Boxes config
queue_for_backup ~/.boxes.json "s3://${bucket}/"

echo ""
echo "=== HOME DIRECTORY ANALYSIS ==="
echo ""
echo "Legend:"
echo "  ✓ = Will be backed up"
echo "  ✗ = Not in backup list"
echo "  ? = In backup list but file missing"
echo ""

# Get all files and directories in home directory (excluding subdirectories)
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    
    # Skip . and .. entries
    if [[ "$filename" == "." || "$filename" == ".." ]]; then
        continue
    fi
    
    # Check backup status
    if [[ -n "${backup_file_map["$file"]}" ]]; then
        if [[ "${backup_file_map["$file"]}" == "backed_up" ]]; then
            echo "  ✓ $filename"
        elif [[ "${backup_file_map["$file"]}" == "missing" ]]; then
            echo "  ? $filename (missing)"
        fi
    else
        echo "  ✗ $filename"
    fi
done < <(find ~/ -maxdepth 1 -print0 | sort -z)

echo ""
echo "=== BACKUP PREVIEW ==="
echo ""
echo "Files that WILL be backed up (${#files_to_backup[@]} files):"
for file in "${files_to_backup[@]}"; do
    echo "  ✓ $file"
done

echo ""
echo "Files that will be SKIPPED (missing) (${#files_missing[@]} files):"
for file in "${files_missing[@]}"; do
    echo "  ? $file"
done

echo ""
echo "=== SUMMARY ==="
echo "Total files to backup: ${#files_to_backup[@]}"
echo "Total files missing: ${#files_missing[@]}"
echo ""

# Single confirmation for all file backups
if [ ${#files_to_backup[@]} -gt 0 ]; then
    echo -n "Proceed with backup of all ${#files_to_backup[@]} files? [y/n]: "
    read confirm
    
    if [[ $confirm =~ ^[Yy] ]]; then
        echo ""
        echo "Starting backup..."
        
        # Execute all backup commands
        backup_count=0
        for i in "${!backup_commands[@]}"; do
            backup_count=$((backup_count + 1))
            echo "[$backup_count/${#backup_commands[@]}] ${files_to_backup[$i]}"
            eval "${backup_commands[$i]}"
        done
        
        echo ""
        echo "✓ File backups completed successfully!"
    else
        echo "File backup cancelled."
    fi
else
    echo "No files found to backup."
fi

# Handle GPG keys separately (they require special handling)
echo ""
echo "=== GPG BACKUP ==="
echo -n "Export and backup GPG secret keys? [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    echo "Backing up GPG secret keys..."
    gpg --export-secret-keys --armor | aws s3 cp --profile "${profile}" - "s3://${bucket}/gpg/secret-keys.asc"
    echo "✓ GPG secret keys backed up"
fi

echo -n "Export and backup GPG trust database? [y/n]: "
read yesno
if [[ $yesno =~ ^[Yy] ]]; then
    echo "Backing up GPG trust database..."
    gpg --export-ownertrust | aws s3 cp --profile "${profile}" - "s3://${bucket}/gpg/trust-database.txt"
    echo "✓ GPG trust database backed up"
fi

echo ""
echo "=== INSTRUCTIONS FOR ADDING MORE FILES ==="
echo ""
echo "To add more files to the backup list, edit this script and add lines like:"
echo "  queue_for_backup ~/.filename \"s3://\${bucket}/path/\""
echo ""
echo "Common files you might want to add:"
echo "  queue_for_backup ~/.vimrc \"s3://\${bucket}/vim/\""
echo "  queue_for_backup ~/.zshrc \"s3://\${bucket}/shell/\""
echo "  queue_for_backup ~/.bashrc \"s3://\${bucket}/shell/\""
echo "  queue_for_backup ~/.gitconfig \"s3://\${bucket}/git/\""
echo "  queue_for_backup ~/.npmrc \"s3://\${bucket}/npm/\""
echo ""

echo "=== BACKUP COMPLETE ==="
echo "All backup operations finished!"
