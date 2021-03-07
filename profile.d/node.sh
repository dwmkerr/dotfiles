# Load NVM.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Note: the 'lazy load' method below *does* make things faster. However, if
# another program needs node (such as vim, which might use it in plugins) then
# calls to node will fail. So I'm reverting to eager behaviour above.

# This is a way to speed up nvm, lazy loading it as needed. Note that this comes
# from:
#   https://til-engineering.nulogy.com/Slow-Terminal-Startup-Tip-Lazy-Load-NVM/
# lazynvm() {
#   unset -f nvm node npm npx
#   export NVM_DIR=~/.nvm
#   [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
#   if [ -f "$NVM_DIR/bash_completion" ]; then
#     [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
#   fi
# }

# nvm() {
#   lazynvm 
#   nvm $@
# }
 
# node() {
#   lazynvm
#   node $@
# }
 
# npm() {
#   lazynvm
#   npm $@
# }

# npx() {
#   lazynvm
#   npx $@
# }
