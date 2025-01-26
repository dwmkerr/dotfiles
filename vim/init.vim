" Load our vimrc, which is compatible with NeoVim.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc