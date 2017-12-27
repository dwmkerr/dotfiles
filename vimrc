" --- Vundle Configuration
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins for colour schemes.
Plugin 'altercation/vim-colors-solarized'
Plugin 'joshdick/onedark.vim'
Plugin 'rakr/vim-one'

" Install Plugins
Plugin 'fatih/vim-go'        " Brutal Golang features
Plugin 'pangloss/vim-javascript' "Better syntax and indenting for js.
Plugin 'helino/vim-json'     " As above.
Plugin 'heavenshell/vim-jsdoc' " JSDoc support for Vim.
Plugin 'kien/ctrlp.vim'      " Ctrl-P to open anything.
Plugin 'hashivim/vim-terraform' " Adds suppport for terraform files (in fact HCP etc)
Plugin 'scrooloose/nerdtree' " NerdTree is a tree view for vim.
Plugin 'mtscout6/syntastic-local-eslint.vim'         " Linting, with better support for eslint.
" Plugin 'scrooloose/syntastic' " Syntax checking lah
Plugin 'vim-airline/vim-airline'    " A useful statusbar.
Plugin 'sjl/vitality.vim'    " Nicer cursor, tmux interactions.
Plugin 'tpope/vim-surround'  " Surround motions.
Plugin 'tpope/vim-repeat'    " Allow the 'dot' for repeating even for plugins.
Plugin 'mileszs/ack.vim'     " Ack support.
Plugin 'christoomey/vim-tmux-navigator' " Seamless navigation between tmux/vim splits.
Plugin 'rizzatti/dash.vim'   " Dash support.

" Plugins for languages
Plugin 'jparise/vim-graphql' " GraphQL

" Support focus events, even when running in tmux.
Plugin 'tmux-plugins/vim-tmux-focus-events'

" Lots of mappings such as [<Space> ]<Space>.
Plugin 'tpope/vim-unimpaired'

" all of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on

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

" Break bad habits - no arrow keys!
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Pane configuration.

    " More natural (to me) splitting.
    set splitbelow
    set splitright

" Theme settings
syntax on
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
set background=dark
" colorscheme solarized
colorscheme onedark
" colorscheme one

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

" Plugin: ctrlp configuration.

    " Ignore some common files for ctrlp
    let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

    " Now that we have common files ignored, enable searching dotfiles.
    let g:ctrlp_show_hidden = 1

" Plugin: Syntastic Settings
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe = '$(npm bin)/eslint'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" Plugin: NerdTree settings

" Toggle NerdTree with Ctrl+N
map <C-n> :NERDTreeToggle<CR>

" Open NerdTree automatically on startup.
" Also focus the *previous* window, i.e. the main window!
" autocmd vimenter * NERDTree | wincmd p

" Show or hide hidden files.
let NERDTreeShowHidden=1

" But still ignore some normally not needed files.
let g:NERDTreeIgnore=['\.git$[[dir]]', 'node_modules$[[dir]]', '\.nyc_output$[[dir]]']

" Show the current file in NERDTree.
map <leader>t :NERDTreeFind<cr>

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
au FileType terraform setl sw=2 sts=2 et
au FileType make set noexpandtab shiftwidth=8 softtabstop=0 " makefiles must use tabs

" Custom Commands

" Refresh nerdtree and ctrlp.
nmap <Leader>r :NERDTreeFocus<cr>R<c-w><c-p>:CtrlPClearCache<cr>

" Ctrl+c exits in the same way as Esc (including sending InsertLeave)
:imap jj <Esc>
:ino <C-c> <Esc>

" Line number stuff.
set number
set relativenumber
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc
:au FocusLost * :set norelativenumber
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeavE * :set relativenumber
nnoremap <Leader>n :call NumberToggle()<cr>

" Map leader s to save.
nnoremap <leader>s :w<cr>
inoremap <leader>s <C-c>:w<cr>

" NERD Commenter plugin.
Plugin 'scrooloose/nerdcommenter'

" Add a space after each comment delimiter.
let g:NERDSpaceDelims = 1

noremap <leader><leader> :tabnew %<cr>

" When in insert mode, highlight the current line.
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Leader a to quickly get ready to ack.
:noremap <Leader>a :Ack 

" Leader d to open in Dash.
:nmap <silent> <leader>d <Plug>DashSearch
