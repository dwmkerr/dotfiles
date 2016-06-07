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
Plugin 'mhartington/oceanic-next'      " Beautiful colours, indicates editor setup.

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
set t_Co=256
colorscheme OceanicNext
set background=dark

" Wildmenu settings, provides much nicer tab completion for commands.
set wildmenu

" Treat json just as javascript.
autocmd BufNewFile,BufRead *.json set ft=javascript

" Language specific options`
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 noexpandtab
