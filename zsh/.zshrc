# Zsh config file
# Copyright (c) 2022 fenze <contact@fenze.dev>

autoload -Uz compinit

precmd() { compinit; zle-keymap-select }

zle -N zle-keymap-select

zle-keymap-select() { [[ $KEYMAP = vicmd ]] && printf '\e[1 q' || printf '\e[5 q'; }

prompt='$([ $PWD = $HOME ] || echo "%2~ ")\$ '

# Activate vim mode.
bindkey -v
KEYTIMEOUT=1
source /usr/share/fzf/key-bindings.zsh

# LS style and default options
export LS_COLORS=$LS_COLORS:"no=0;0":"di=30;34": \
	"ln=30;36":"so=34:pi=0;33":"ex=35":"bd=34;46":"cd=30;43": \
	"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42"

zstyle ':completion:*' list-colors ${LS_COLORS}
zstyle ':completion:*' menu select

export EDITOR='nvim'

alias v='nvim'

alias ls='ls --color=always'
alias la='ls -lAhG --group-directories-first | sed /^total/d'
alias lr='ls -R'

alias ga='git add'
alias gi='git init -q'
alias gra='git remote add origin'
alias gr='git remotes'
alias gc='git commit --short'
alias gs='git status --short'
alias gp='git push --quiet'

alias envc='cd ~/.config/env/'
alias vc='v ~/.config/nvim/init.vim'

alias rm='rm -rf'

setopt auto_cd

# FZF Options
export FZF_DEFAULT_COMMAND='find . | grep -v ".git\|.node_modules\|.cache" && tput cuu 2'
export FZF_DEFAULT_OPTS='
  --reverse
  --info hidden
  --color fg:249,bg:0,hl:2,fg+:249,bg+:0,hl+:2
  --color info:6,prompt:249,spinner:7,pointer:1,marker:0,header:#586e75
'

fzf_open() {
	tput cuu 2
	FILE=$(fzf --reverse --height 40% --preview "bat --color=always --style=numbers {}")
	[ ! -z $FILE ] && [ -f $FILE ] && {
		$EDITOR $FILE ^M
	} || [ -d $FILE ] && {
		cd $FILE
	}
}

bindkey -s '^o' "fzf_open ^M"
bindkey -s '^a' "fc ^M"

fetch()
{
	echo "os: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 | cut -d " " -f1)"
	echo "kernel: $(uname -r | sed 's/-.*//')"
	echo "packages: $(pacman -Qe | wc -l)"
	echo "colors: $(for i in $(seq 6); do printf "\033[0;3%im• " "$i"; done)"
}
