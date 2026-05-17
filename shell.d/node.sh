# Lazy NVM: preset PATH so node/npm/npx work immediately without sourcing
# nvm.sh (~1.5s cost). Vim/nvim and coc.nvim find node binary via PATH.
# Only nvm function itself is lazy-loaded since it has no binary.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# Resolve default version (alias chain may end at glob like lts/* — pick newest installed).
_nvm_default_bin() {
    local target version
    [ -d "$NVM_DIR/alias" ] || return 1
    target=$(cat "$NVM_DIR/alias/default" 2>/dev/null) || return 1
    while [ -f "$NVM_DIR/alias/$target" ]; do
        target=$(cat "$NVM_DIR/alias/$target")
    done
    if [ "$target" = "lts/*" ] || [ -z "$target" ]; then
        version=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)
    else
        version="$target"
    fi
    [ -d "$NVM_DIR/versions/node/$version/bin" ] && echo "$NVM_DIR/versions/node/$version/bin"
}

_nvm_bin=$(_nvm_default_bin)
[ -n "$_nvm_bin" ] && export PATH="$_nvm_bin:$PATH"
unset -f _nvm_default_bin
unset _nvm_bin

# Lazy stub: nvm has no binary, so we stub it. First invocation sources real nvm.
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    if [ -n "$BASH_VERSION" ]; then
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    fi
    nvm "$@"
}
