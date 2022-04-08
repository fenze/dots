" Author: fenze <contact@fenze.dev>

set fillchars=eob:\ ,
set laststatus=0
set noruler
set noswapfile
set clipboard=unnamedplus
set tabstop=2
set shiftwidth=2
set ignorecase
set nohlsearch
set number
set formatoptions-=cro
set list
set scrolloff=10
set nowrap
set cursorline

syntax on
filetype plugin indent on

cal plug#begin()
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'catppuccin/nvim', {'as': 'catppuccin'}
	Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'preservim/nerdcommenter'
	Plug 'cakebaker/scss-syntax.vim'
	Plug 'ap/vim-css-color'
	Plug 'aperezdc/vim-template'
cal plug#end()

cal deoplete#enable()
cal deoplete#custom#option('refresh_always', v:false)

colorscheme catppuccin
hi! link EndofBuffer Normal
hi! Normal ctermbg=NONE guibg=NONE
au BufRead,BufNewFile *.scss set filetype=scss.css

let g:LanguageClient_serverCommands = { 'c': ['clangd'], 'python': ['pylsp'] }

au BufWritePost *.sass !sassc "%:p" "%:p:h/style.css"

let g:email = "contact@fenze.dev"
let g:LanguageClient_hoverPreview = "Never"

let g:LanguageClient_echoProjectRoot = 0
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)

let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

nm <c-f> :Rg        <cr>
nm <c-n> :Files     <cr>
nm <c-h> :History   <cr>
nm <c-c> :Commits   <cr>
" "nm <s-c> :History:	<cr>
nm <space> /

ino " ""<left>
ino ' ''<left>
ino ( ()<left>
ino { {}<left>
ino {;<cr> {<cr><cr>};<up><tab>
ino {<cr> {<cr><cr>}<up><tab>

nm <c-h> <C-w>h
nm <c-j> <C-w>j
nm <c-k> <C-w>k
nm <c-l> <C-w>l

let g:fzf_colors = {
	\ 'fg':         ['fg', 'Normal'],
	\ 'bg':         ['bg', 'NONE'],
	\ 'preview-bg': ['bg', 'Normal'],
	\ 'hl':         ['fg', 'Normal'],
	\ 'fg+':        ['fg', 'Normal'],
	\ 'bg+':        ['bg', 'Normal'],
	\ 'hl+':        ['fg', 'Normal'],
	\ 'info':       ['fg', 'Normal'],
	\ 'border':     ['fg', 'Ignore'],
	\ 'prompt':     ['fg', 'Normal'],
	\ 'pointer':    ['fg', 'Normal'],
	\ 'marker':     ['fg', 'Normal'],
	\ 'spinner':    ['fg', 'Normal'],
	\ 'header':     ['fg', 'Normal'] }

map <c-_> <plug>NERDCommenterToggle

au BufWrite * sil! :%s#\($\n\s*\)\+\%$## | :%s/\s\+$//e
