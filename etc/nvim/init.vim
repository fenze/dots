cal plug#begin()
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'catppuccin/nvim', {'as': 'catppuccin'}
	Plug 'preservim/nerdcommenter'
	Plug 'sheerun/vim-polyglot'
	Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
cal plug#end()

set nocompatible
colo catppuccin
hi Normal ctermbg=NONE guibg=NONE
hi! link NormalNC Normal

" remove ~ symbols
" and vertical line
set fillchars=eob:\ ,vert:\ ,

" hide bottom bar
" and current line/column
set laststatus=0
set noruler
set noshowmode
set hidden

" trash files
set noswapfile
set nobackup

" Search
set nohlsearch
set ignorecase

" Always block cursor
set guicursor=n-v-c:block-Cursor

" tab sizes
set tabstop=2
set shiftwidth=2

" auto scrolling
set scrolloff=7

" capslock off by default
set iminsert=0

" autodetect filetype
syntax on
filetype plugin indent on

" clipboard
set clipboard=unnamedplus

com! Reload :so $MYVIMRC

" keybinds
nm <silent> ;     :History: <cr>
nm <silent> <c-f> :Rg       <cr>
nm <silent> <c-n> :Files    <cr>
map <c-_> <plug>NERDCommenterToggle
map <space> /
nm <silent> gd <Plug>(lcn-definition)
nm <silent> gr <Plug>(lcn-rename)
nm <silent> L <Plug>(lcn-hover)
nm <silent> gf <Plug>(lcn-references)

nm <silent> <c-h> ^
nm <silent> <c-l> $

vm <silent> <c-h> ^
vm <silent> <c-l> $

" tabs
nm <silent> <A-h> :tabn <cr>
nm <silent> <A-l> :tabp <cr>
nm <a-1> 1gt
nm <a-2> 2gt
nm <a-3> 3gt
nm <a-4> 4gt
nm <a-5> 5gt
nm <a-6> 6gt
nm <a-7> 7gt
nm <a-8> 8gt
nm <a-9> 9gt

" automation
au BufWinEnter *.c,*.h call matchadd("ErrorMsg", '\%>75v.\+', 10, 4)
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
au BufWrite * sil! :%s#\($\n\s*\)\+\%$## | :%s/\s\+$//e
au InsertLeave * set iminsert=0

" commenter
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

" completions
set completeopt=menuone,noselect
set completeopt-=preview
let g:deoplete#enable_at_startup = 1
cal deoplete#custom#option('refresh_always', v:false)
let g:LanguageClient_serverCommands = {
	\ 'c': ['clangd', '-j=12', '--clang-tidy'],
	\ 'python': ['pylsp'] }
