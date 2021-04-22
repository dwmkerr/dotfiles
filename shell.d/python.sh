# Assume we have a .pyenv path to use as the pyenv root - if we don't have it
# then that's fine, we simply won't have access to the pyenv binary.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# If we have pyenv, use it.
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
