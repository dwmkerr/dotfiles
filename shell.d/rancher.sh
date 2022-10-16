# If a Rancher binaries path is present, use it.
rancher_bin_path="${HOME}/.rd/bin"
if [ -d "${rancher_bin_path}" ]; then
    export PATH="$PATH:${rancher_bin_path}"
fi
