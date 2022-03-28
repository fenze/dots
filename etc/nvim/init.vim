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
set noshowcmd
set splitbelow splitright
set shortmess+=W
set guicursor=n-v-c:block-Cursor
set noshowmode

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
	Plug 'jiangmiao/auto-pairs'
	Plug 'vshih/vim-make'
	Plug 'jelera/vim-javascript-syntax'
	Plug 'othree/javascript-libraries-syntax.vim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'sindrets/diffview.nvim'
cal plug#end()

cal deoplete#enable()
cal deoplete#custom#option('refresh_always', v:false)

colo catppuccin

hi! link EndofBuffer Normal
hi! Normal ctermbg=NONE guibg=NONE
hi Comment guifg=#8080aa

au BufRead,BufNewFile *.scss set filetype=scss.css

let g:LanguageClient_serverCommands = {
	\ 'c': ['clangd'],
	\ 'python': ['pylsp'],
	\ 'javascript': ['typescript-language-server', '--stdio'] }
au BufWritePost *.sass silent !sassc "%:p" "%:p:h/style.css"

setlocal omnifunc=LanguageClient#complete

let g:email = "contact@fenze.dev"
let g:LanguageClient_hoverPreview = "Never"

let g:LanguageClient_echoProjectRoot = 0
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> gr <Plug>(lcn-rename)
nmap <silent> L <Plug>(lcn-hover)

let g:deoplete#enable_ignore_case = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

nm <c-f> :Rg        <cr>
nm <c-n> :Files     <cr>
nm <c-h> :History   <cr>
nm sc  :Commits   <cr>

nm <space> /
nm ; :

nm lr :cal Rename()<cr>

fun Rename()
	let old_name = expand('<cword>')
	let new_name = input('New name: ')
  redraw
	echo "\ "
	if len(new_name) != 0
		exe "%s/" . old_name . "/" . new_name
	en
endf

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

fun PlaceTab()
	let line = getline('.')[0:col('.')-1]
	" We need to remove the last element of the list like this,
	" because for some reason you cannot select none of the elements
	" using [:].
	if len(line) == 0
		return "\t"
	else
		let line = line[:-2]
	endif
	if match(line, '\c^[ \t]*$') != -1
		return "\t"
	else
		let tabs_ = count(line, "\t")
		let offset = len(line)
		if tabs_ != -1
			let offset = offset - tabs_ + (tabs_ * 4)
		endif
		let spaces = 4 - (offset) % 4
		return repeat(" ", spaces)
	endif
endf

inor <expr><tab> PlaceTab()

set tabline=%!TabLine()

fun TabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		el
			let s .= '%#TabLine#'
		en
		" the label is made by MyTabLabel()
		let s .= ' %{Draw_label(' . (i + 1) . ')} '
	endfo
	let s .= '%#TabLineFill#%T'
	retu s
endf

fun Draw_label(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	retu bufname(buflist[winnr - 1])
endf

let g:instant_markdown_autostart = 0
map tt :vnew term://zsh<cr>

au BufEnter * if &buftype == 'terminal' | :startinsert | endif
au WinEnter * :stopinsert

tno :q <C-\><C-n> :q <cr>

nm <silent> :w :sil! write <cr>
nm <silent> :q :sil! quit!<cr>
nm <silent> <c-r> :sil! red<cr>
nm <silent> u :sil! u<cr>

au BufWrite * sil! :%s#\($\n\s*\)\+\%$## | :%s/\s\+$//e
