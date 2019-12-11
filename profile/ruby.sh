# If the rvm script exists, source it.
rvm_script="$HOME/.rvm/scripts/rvm" 
if [[ -s "${rvm_script}" ]] then
    source $HOME/.rvm/scripts/rvm
fi
