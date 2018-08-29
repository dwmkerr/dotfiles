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
Plugin 'heavenshell/vim-jsdoc' " JSDoc support for Vim.
Plugin 'kien/ctrlp.vim'      " Ctrl-P to open anything.
Plugin 'scrooloose/nerdtree' " NerdTree is a tree view for vim.
Plugin 'w0rp/ale'            " Asynchronous Linting Engine.
Plugin 'vim-airline/vim-airline'    " A useful statusbar.
Plugin 'sjl/vitality.vim'    " Nicer cursor, tmux interactions.
Plugin 'tpope/vim-surround'  " Surround motions.
Plugin 'tpope/vim-repeat'    " Allow the 'dot' for repeating even for plugins.
Plugin 'mileszs/ack.vim'     " Ack support.
Plugin 'christoomey/vim-tmux-navigator' " Seamless navigation between tmux/vim splits.
Plugin 'rizzatti/dash.vim'   " Dash support.

" Plugins for languages
Plugin 'jparise/vim-graphql'      " GraphQL
Plugin 'PProvost/vim-ps1'         " PowerShell
Plugin 'mxw/vim-jsx'              " JSX support.
Plugin 'pangloss/vim-javascript'  " Better syntax and indenting for js.
Plugin 'elzr/vim-json'            " As above.
Plugin 'othree/html5.vim'         " HTML + SVG
Plugin 'hashivim/vim-terraform'   " Adds suppport for terraform files (in fact HCP etc)
Plugin 'godlygeek/tabular'        " Line up text! Needed by vim-markdown.
Plugin 'mzlogin/vim-markdown-toc' " Build a TOC for markdown.
" Plugin 'plasticboy/vim-markdown'                    " Markdown support. Not yet sure if this is worth it.

" Support focus events, even when running in tmux.
Plugin 'tmux-plugins/vim-tmux-focus-events'

" Lots of mappings such as [<Space> ]<Space>.
Plugin 'tpope/vim-unimpaired'

" Nice splitting / joining.
Plugin 'AndrewRadev/splitjoin.vim'

" Highlight the yanked text briefly.
Plugin 'machakann/vim-highlightedyank'

" NERD Commenter plugin.
Plugin 'scrooloose/nerdcommenter'

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

" Colour and terminal configuration.

    " If we have 24bit colour support, use it. Without this line we seem to get
    " the right colours *almost* - except the background!
    if (has("termguicolors"))
        set termguicolors
    endif

" Theme settings

    " Syntax highlighting on, dark background, onedark theme.
    syntax on
    set background=dark
    colorscheme onedark

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

    " Ignore some common files for ctrlp, also ignore gitignore.
    let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

    " Now that we have common files ignored, enable searching dotfiles.
    let g:ctrlp_show_hidden = 1

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
au FileType html           setl sw=2 sts=2 et
au FileType javascript     setl sw=2 sts=2 et
au FileType javascript.jsx setl sw=2 sts=2 et
au FileType json           setl sw=2 sts=2 et
au FileType ruby           setl sw=2 sts=2 et
au FileType yaml           setl sw=2 sts=2 et
au FileType terraform      setl sw=2 sts=2 et
au FileType make           set noexpandtab shiftwidth=8 softtabstop=0 " makefiles must use tabs

" JavaScript Language Settings

    " Support JSX syntax highlighting in *.js, not just *.jsx.
    let g:jsx_ext_required = 0

    " Disable syntax concealing for json files.
    let g:vim_json_syntax_conceal = 0

" Ruby Language Settings

    " 'Fastlane' file types are ruby files.
    au BufNewFile,BufRead Appfile set ft=ruby
    au BufNewFile,BufRead Deliverfile set ft=ruby
    au BufNewFile,BufRead Fastfile set ft=ruby
    au BufNewFile,BufRead Gymfile set ft=ruby
    au BufNewFile,BufRead Matchfile set ft=ruby
    au BufNewFile,BufRead Snapfile set ft=ruby
    au BufNewFile,BufRead Scanfile set ft=ruby

" Go Language Settings

    " Lots of syntax highlighting!
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_types = 1

    " Highlight the variable under the cursor.
    let g:go_auto_sameids = 1

" Markdown language settings

    " I don't find the folding particularly useful, turn it off.
    " let g:vim_markdown_folding_disabled = 1

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

" Splitjoin Plugin
" Remember it like this: 's' for 'split', j splits down, k up.
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" Add a space after each comment delimiter.
let g:NERDSpaceDelims = 1

noremap <leader><leader> :tabnew %<cr>

" When in insert mode, highlight the current line.
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Ack Plugin Configuration

    " Use ag, rather than ack (sorry, I need my .gitignore to be used...).
    let g:ackprg = 'ag --nogroup --nocolor --column'

    " Leader a to quickly get ready to ack.
    :noremap <Leader>a :Ack 

" Leader d to open in Dash.
:nmap <silent> <leader>d <Plug>DashSearch

" Use persistent undo.
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undodir=~/.vim/undo
set undofile

" Enable highlighted yank on earlier versions of vim.
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif
let g:highlightedyank_highlight_duration = 100
