set nocompatible              " be iMproved, required
filetype off                  " required

" Python binaries
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

call plug#begin('~/.vim/Plugged')
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'
" ctrlp alternative for file serach
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'sheerun/vim-polyglot'
" Plug 'dense-analysis/ale'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Bundle 'vim-scripts/ZoomWin'
" Bundle 'airblade/vim-gitgutter'
" Bundle 'edkolev/tmuxline.vim'
" Bundle 'ervandew/supertab'
" Plugin 'Raimondi/delimitMate'
" " Plugin 'SirVer/ultisnips'
Plug 'Valloric/YouCompleteMe'
Plug 'Xuyuanp/nerdtree-git-Plugin'
" Plugin 'honza/vim-snippets'
" Plugin 'jistr/vim-nerdtree-tabs'
" Plugin 'majutsushi/tagbar'
" " Plugin 'moll/vim-node'
" Plugin 'nelstrom/vim-visual-star-search'
" " Plugin 'othree/javascript-libraries-syntax.vim'
" " Plugin 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
" Plugin 'scrooloose/syntastic'
" Plugin 'sheerun/vim-polyglot'
Plug 'stefandtw/quickfix-reflector.vim'
" Plugin 'taglist.vim'
" Plugin 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plugin 'vim-scripts/vis'
" Plugin 'xolox/vim-easytags'
" Plugin 'xolox/vim-misc'
" Bundle 'geekjuice/vim-mocha'
" Bundle 'flowtype/vim-flow'
" " Bundle 'leafgarland/typescript-vim'
" Plugin 'editorconfig/editorconfig-vim'
" " Plugin 'Shougo/deoplete.nvim'
" " Plugin 'mhartington/nvim-typescript'
" " Plugin 'janko-m/vim-test'
" Plugin 'sbdchd/neoformat'
" Plugin 'HerringtonDarkholme/yats.vim'
" Plugin 'elmcast/elm-vim'
" " Plugin 'Quramy/tsuquyomi'
" Plugin 'altercation/vim-colors-solarized'
call plug#end()

" vim-test
" let test#strategy = "neovim"

" filetype Plugin indent on
"
" " YCM
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']
"
"
" " Utilsnipperts
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
"
"
"
" auto cmds
" remove fugitive buffers when hidden
autocmd BufReadPost fugitive://* set bufhidden=delete
"
" " elm format on save
" let g:elm_format_autosave = 1
"
" "js library syntax
" " let g:used_javascript_libs = 'lo-dash,React,Chai'
"
" " tagbar
" " nmap <F8> :TagbarToggle<CR>
"
" mouse support for scrolling
set mouse=a
"
" " airline
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1
"
" easy motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
"
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
 nmap s <Plug>(easymotion-overwin-f2)
"
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
"
"  " JK motions: Line motions
"  map <Leader>j <Plug>(easymotion-j)
"  map <Leader>k <Plug>(easymotion-k)
"
"
"
" " ctags
" filetype Plugin on
" set tags=./tags;
" let g:easytags_dynamic_files = 1
" let g:easytags_events = ['BufWritePost']
" " let g:easytags_opts = ["-R --exclude=.git --exclude=node_modules --exclude=test --exclude=.storybook --exclude=build --exclude=dist --exclude=coverage"]
"
" " Sfiletype Plugin onyntactic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" " Syntastic
" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" " let g:syntastic_typescript_checkers = ['tsuquyomi']
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
"
" " let g:syntastic_error_symbol = '❌'
" " let g:syntastic_style_error_symbol = '⁉️'
" " let g:syntastic_warning_symbol = '⚠️'
" " let g:syntastic_style_warning_symbol = '💩'
"
" let g:syntastic_auto_loc_list = 0
"
" let g:elm_syntastic_show_warnings = 1
" let g:tsuquyomi_disable_quickfix = 1
"
" highlight link SyntasticErrorSign SignColumn
" highlight link SyntasticWarningSign SignColumn
" highlight link SyntasticStyleErrorSign SignColumn
" highlight link SyntasticStyleWarningSign SignColumn
"
" " Buffer
set hidden
set autoread
set autowriteall
"
"
" " scroll
set scrolloff=10
set scrolljump=5
"
" " search 
set ignorecase
set smartcase
set incsearch     " do incremental searching
nmap <silent> ,/ :nohlsearch<CR>
"
" " Leader
let mapleader = ","
"
" " ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard | grep -vE "\.(svg|ttf|eot|otf|wof|jpe?g|png|gif)"']
"
" NERDTree
nnoremap <Leader>f :NERDTreeFind<Enter>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
"
"
set backspace=indent,eol,start
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=5000
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
" " set autowrite     " Automatically :write before running commands
"
" Folding
if has('folding')
  if has('windows')
    let &fillchars='vert: '           " less cluttered vertical window separators
  endif
  set foldmethod=indent               " not as cool as syntax, but faster
  set foldlevelstart=999              " start fully folded
endif
"
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif
"
" if filereadable(expand("~/.vimrc.bundles"))
"   source ~/.vimrc.bundles
" endif
"
"
" augroup vimrcEx
"   autocmd!
"
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
"
"   " Set syntax highlighting for specific file types
"   autocmd BufRead,BufNewFile Appraisals set filetype=ruby
"   autocmd BufRead,BufNewFile *.md set filetype=markdown
"
"   " Enable spellchecking for Markdown
"   autocmd FileType markdown setlocal spell
"
"   " Automatically wrap at 80 characters for Markdown
"   autocmd BufRead,BufNewFile *.md setlocal textwidth=80
"
"   " Automatically wrap at 72 characters and spell check git commit messages
"   autocmd FileType gitcommit setlocal textwidth=72
"   autocmd FileType gitcommit setlocal spell
"
"   " Allow stylesheets to autocomplete hyphenated words
"   autocmd FileType css,scss,sass setlocal iskeyword+=-
" augroup END
"
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·
"
" Make it obvious where 120 characters is
call matchadd('ColorColumn', '\%81v', 120)

" Numbers
set number
set numberwidth=5
set relativenumber  

" " Switch between the last two files
" nnoremap <leader><leader> <c-^>
"
"
" " Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
"
" No line wrapping
set tw=0
"
"
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add
"
" Autocomplete with dictionary words when spell check is on
set complete+=kspell
"
" Always use vertical diffs
set diffopt+=vertical
"
" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
"
" vim-tmux-navigator
" save when tmux leave the pane
" let g:tmux_navigator_save_on_switch = 1
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

" Ale for linting
" manually run :ALELint for linting
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let b:ale_fixers = ['prettier']
" Fix files automatically on save
autocmd BufWritePre,InsertLeave *.ts, ALEFix prettier
autocmd BufWritePre,InsertLeave *.html ALEFix prettier
autocmd BufWritePre,InsertLeave *.*ss ALEFix prettier
autocmd BufWritePre,InsertLeave *.js ALEFix prettier


" Fzf search
nnoremap <C-p> :Files<CR>


" Theme 
set background=dark
let g:solarized_termcolors = 256
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

syntax on
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

" Exit with ESC from temrinal mode
tnoremap <Esc> <C-\><C-n>

" fzf
"set rtp+=/usr/local/opt/fzf
