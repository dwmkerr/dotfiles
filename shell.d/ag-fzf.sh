# ag-fzf.sh
#
# Configuration for searching.

# As long as we have 'ag', use our ~/.ignore file.
if type ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag --path-to-ignore ~/.ignore -g ""'
fi

# If we have fzf config, source it.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

