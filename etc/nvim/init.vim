" Author: fenze <contact@fenze.dev>

set fillchars=eob:\ ,
set laststatus=0
set noruler
set noswapfile
set noshowmode
set clipboard=unnamedplus
set tabstop=2
set shiftwidth=2
set ignorecase
set nohlsearch
set number
set formatoptions-=cro

filetype plugin indent on

call plug#begin()
	Plug 'sainnhe/sonokai'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'tpope/vim-fugitive'
	Plug 'suxpert/vimcaps'
	Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'preservim/nerdcommenter'
call plug#end()

call deoplete#enable()
call deoplete#custom#option('refresh_always', v:false)

colorscheme sonokai
hi! Normal ctermbg=8
hi! link EndofBuffer Normal

let g:LanguageClient_serverCommands = {
			\ 'c': ['clangd'],
			\ 'python': ['pylsp'],
			\ 'go': ['gopls']
			\ }

au BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

let g:LanguageClient_hoverPreview = "Never"
let g:LanguageClient_echoProjectRoot = 0

let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

nm <c-f> :Rg <cr>
nm <c-n> :Files <cr>
nm <c-h> :History: <cr>
nm <c-c> :Commits <cr>

let g:fzf_colors =
\ { 'fg':         ['fg', 'Normal'],
  \ 'bg':         ['bg', 'Normal'],
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
nm <space> /
nm ; :

au BufWrite * sil! :%s#\($\n\s*\)\+\%$## | :%s/\s\+$//e
