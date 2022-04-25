" Author: fenze <contact@fenze.dev>

set fillchars=eob:\ ,vert:\ ,
set laststatus=0
set noruler
set shortmess=F
set noswapfile
set clipboard=unnamedplus
set tabstop=2
set shiftwidth=2
set ignorecase
set nohlsearch
set smarttab
set formatoptions-=cro
set scrolloff=10
set nowrap
set cursorline
set hidden
set noexpandtab
set keywordprg=:tab\ Man
set noshowmode
set noshowcmd
set splitbelow splitright
set shortmess+=W
set shortmess+=c
set guicursor=n-v-c:block-Cursor

syntax on
filetype plugin indent on

cal plug#begin()
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'catppuccin/nvim', {'as': 'catppuccin'}
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'preservim/nerdcommenter'
	Plug 'deoplete-plugins/deoplete-clang'
cal plug#end()

cal deoplete#enable()
cal deoplete#custom#option('refresh_always', v:false)

colo catppuccin

so ~/.config/nvim/colors.vim

hi! link EndofBuffer Normal
hi! Normal ctermbg=NONE guibg=NONE
hi! link NormalNC Normal
hi Comment guifg=#8080aa

au BufRead,BufNewFile *.scss set filetype=scss.css

au BufWritePost *.sass silent !sassc "%:p" "%:r.css"

nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> gr <Plug>(lcn-rename)
nmap <silent> L <Plug>(lcn-hover)

let g:deoplete#enable_ignore_case = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0

set completeopt-=preview

let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

nm <c-f> :Rg        <cr>
nm <c-n> :Files     <cr>
nm <c-h> :History   <cr>
nm sc  :Commits   <cr>

nm <space> /
nm ; :

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

let $confp = '~/.config/nvim/init.vim'
com! Reload :so $confp

au BufWinEnter *.c,*.h,*.py let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

let g:fzf_layout = { 'down': '30%' }
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

let g:instant_markdown_autostart = 0
map tt :vnew term://zsh<cr>

au BufEnter * if &buftype == 'terminal' | :startinsert | endif
au WinEnter * :stopinsert

tno :q <C-\><C-n> :q <cr>

au BufWrite * sil! :%s#\($\n\s*\)\+\%$## | :%s/\s\+$//e
