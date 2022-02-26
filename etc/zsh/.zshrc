# Zsh config file
# Copyright (c) 2022 fenze <contact@fenze.dev>

autoload -Uz compinit

precmd()
{
	compinit
	zle-keymap-select
}

zle-keymap-select() { [[ $KEYMAP = vicmd ]] && printf '\e[2 q' || printf '\e[4 q'; }
zle -N zle-keymap-select

prompt='$([ $PWD = $HOME ] || echo "%2~ ")| '

# Activate vim mode.
bindkey -v
KEYTIMEOUT=1
source /usr/share/fzf/key-bindings.zsh

# LS style and default options
export LS_COLORS=$LS_COLORS:"no=0;0":"di=30;34": \
	"ln=30;36":"so=34:pi=0;33":"ex=35":"bd=34;46":"cd=30;43": \
	"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42"

# ZSH completion menu with colors
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
alias gc='git commit'
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

fzf_open()
{
	tput cuu 2
	FILE=$(fzf --reverse --height 40% --preview "bat --color=always --style=numbers {}")
	[ ! -z $FILE ] && [ -f $FILE ] && {
		$EDITOR $FILE ^M
	} || [ -d $FILE ] && {
		cd $FILE
	}
}

update() {
	echo "Updating: Neovim plugins"
	$(nvim -c PlugUpdate -c qa! &> /dev/null) \
		&& tput cuu 1 \
		&& echo "Neovim: plugins update done."

	echo "Updating: pacman" && \
		$(doas pacman -Syyu --quiet --noconfirm &> /dev/null) \
			&& tput cuu 1 && echo "Pacman: packages update done."

	echo "Updating: yay" && \
		$(doas yay -Syyu --quiet --noconfirm &> /dev/null) \
			&& tput cuu 1 && echo "yay: packages update done."
}

bindkey -s '^o' "fzf_open ^M"
bindkey -s '^a' "fc ^M"
