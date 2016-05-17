set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'fugitive.vim'

Plugin 'Xuyuanp/nerdtree-git-plugin'                      
Bundle 'airblade/vim-gitgutter'                           
Bundle 'ctrlp/ctrlp.vim'                                  
Bundle 'easymotion/vim-easymotion'                        
Plugin 'jistr/vim-nerdtree-tabs'                          
Plugin 'mileszs/ack.vim'                                  
Plugin 'nelstrom/vim-visual-star-search'                  
Plugin 'pangloss/vim-javascript'                          
Plugin 'scrooloose/nerdtree'                              
Plugin 'scrooloose/syntastic'                             
Plugin 'stefandtw/quickfix-reflector.vim'                 
Plugin 'taglist.vim'                                      
Plugin 'terryma/vim-expand-region'                     
Plugin 'terryma/vim-multiple-cursors'                     
Plugin 'tomtom/tcomment_vim'                              
Plugin 'tpope/vim-surround'                               
Plugin 'vim-scripts/vis'                                  
Plugin 'vim-airline/vim-airline'                                  
Plugin 'vim-airline/vim-airline-themes'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-misc'
Plugin 'Raimondi/delimitMate'
Plugin 'moll/vim-node'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'


call vundle#end() 
filetype plugin indent on


" Utilsnipperts
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"



"js library syntax
let g:used_javascript_libs = 'lo-dash,React,Chai'

" tagbar
nmap <F8> :TagbarToggle<CR>

" mouse support for scrolling
set mouse=a

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" easy motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

 " `s{char}{char}{label}`
 " Need one more keystroke, but on average, it may be more comfortable.
 nmap s <Plug>(easymotion-overwin-f2)

 " Turn on case insensitive feature
 let g:EasyMotion_smartcase = 1

 " JK motions: Line motions
 map <Leader>j <Plug>(easymotion-j)
 map <Leader>k <Plug>(easymotion-k)



" ctags
filetype plugin on
:set tags=./tags;
:let g:easytags_dynamic_files = 1
:let g:easytags_events = ['BufWritePost']

" Sfiletype plugin onyntactic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" Buffer
set hidden
set autoread 
set autowriteall


" scroll
set scrolloff=10
set scrolljump=5

" search 
set ignorecase
set smartcase

" Reload vimrc when edited
" autocmd MyAutoCmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc
"       \ so $MYVIMRC | if has('gui_running') | source $MYGVIMRC | endif |
"       AirlineRefresh

" Leader
let mapleader = ","

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" NERDTree
nnoremap <Leader>f :NERDTreeFind<Enter>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1


set clipboard=unnamed
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif


augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Make it obvious where 80 characters is
call matchadd('ColorColumn', '\%81v', 100)

" Numbers
set number
set numberwidth=5
set relativenumber  

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>


" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l


" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

