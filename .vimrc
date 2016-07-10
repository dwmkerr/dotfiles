" --- Vundle Configuration
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Install Plugins
Plugin 'fatih/vim-go'        " Brutal Golang features
Plugin 'altercation/vim-colors-solarized'
Plugin 'pangloss/vim-javascript' "Better syntax and indenting for js.
Plugin 'helino/vim-json'     " As above.
Plugin 'kien/ctrlp.vim'      " Ctrl-P to open anything.

" all of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" --- Simple Vim config.
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Theme settings (requires oceanic, installed earlier by Vundle)
syntax enable
set background=dark
colorscheme solarized

" Wildmenu settings, provides much nicer tab completion for commands.
set wildmenu

" Ignore some common files for ctrlp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

" Language Settings

" All languages - no autocommenting on newlines
au FileType * set fo-=c fo-=r fo-=o

" Language specific indentation.
au FileType javascript setl sw=2 sts=2 et
au FileType yaml setl sw=2 sts=2 et
