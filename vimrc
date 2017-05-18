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
Plugin 'hashivim/vim-terraform' " Adds suppport for terraform files (in fact HCP etc)
Plugin 'scrooloose/nerdtree' " NerdTree is a tree view for vim.
Plugin 'scrooloose/syntastic' " Syntax checking lah
Plugin 'mtscout6/syntastic-local-eslint.vim'         " Linting, with better support for eslint.
Plugin 'vim-airline/vim-airline'    " A useful statusbar.
Plugin 'sjl/vitality.vim'    " Nicer cursor, tmux interactions.
Plugin 'tpope/vim-surround'  " Surround motions.

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
set colorcolumn=80      " highlight column 80

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Make backspace work in a sane fashion.
set backspace=indent,eol,start

" Pane configuration.

    " Move panes with ctrl+direction
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>

    " More natural (to me) splitting.
    set splitbelow
    set splitright

" Theme settings
syntax on
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
set background=dark
colorscheme solarized

" Enable the mouse. Also enable when in tmux.
set mouse=a
set ttymouse=xterm2

" Use the system clipboard.
set clipboard=unnamed

" Enable saving backups (swapfiles) and store vim backups in a temp dir
" rather than the local dir.
set swapfile
set dir=~/tmp

" Wildmenu settings, provides much nicer tab completion for commands.
set wildmenu

" Ignore some common files for ctrlp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

" Plugin: Syntastic Settings
let g:syntastic_javascript_checkers = ['eslint']
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Plugin: NerdTree settings

" Toggle NerdTree with Ctrl+N
map <C-n> :NERDTreeToggle<CR>

" Open NerdTree automatically on startup.
" Also focus the *previous* window, i.e. the main window!
autocmd vimenter * NERDTree | wincmd p

" Plugin: Airline Settings

" Show the buffers in the tabline.
let g:airline#extensions#tabline#enabled = 1


" Language Settings

" All languages - no autocommenting on newlines, 4 spaces soft tabs + expand
au FileType * set fo-=c fo-=r fo-=o sw=4 sts=4 et

" Language specific indentation.
au FileType javascript setl sw=2 sts=2 et
au FileType json  setl sw=2 sts=2 et
au FileType yaml setl sw=2 sts=2 et
au FileType make set noexpandtab shiftwidth=8 softtabstop=0 " makefiles must use tabs
