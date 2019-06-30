ensure_symlink() {
    target_path="$1"
    symlink_path="$2"

    # If there's no source, create it.
    echo "  linking '$symlink_path' to '$target_path'"
    if [[ ! -e "$symlink_path" ]]; then
        ln -sf "$target_path" "$symlink_path"
    elif [[ ! "$(readlink $symlink_path)" = "$target_path" ]]; then
        rm -rf "$symlink_path"
        ln -sf "$target_path"
    fi
}
