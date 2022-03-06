# Zsh config file
# Copyright (c) 2022 fenze <contact@fenze.dev>

# autoload autocomplete
autoload -Uz compinit

precmd()
{
	# Autocomplete
	compinit
	# Insert cursor
	zle-keymap-select
}

# Different cursor for vim modes
zle-keymap-select() { [[ $KEYMAP = vicmd ]] && printf '\e[2 q' || printf '\e[4 q'; }
zle -N zle-keymap-select

prompt='$([ $PWD = $HOME ] || echo "%2~ ")\$ '

# Activate vim mode.
bindkey -v

# Reduce annoying delay
# when switch vim modes
KEYTIMEOUT=1

# FZF keybinds after bindkey
# to unblock useful history etc.
source /usr/share/fzf/key-bindings.zsh

# LS style and default options
export LS_COLORS=$LS_COLORS:"no=7;0":"di=34": \
	"ln=32":"so=34:pi=0;33":"ex=35":"bd=34;46":"cd=30;43": \
	"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42":

# ZSH completion menu with colors
zstyle ':completion:*' list-colors ${LS_COLORS}
zstyle ':completion:*' menu select

# nvim as default editor
export EDITOR='nvim'
alias v='nvim'

# ls aliases
alias ls='ls --color=always'
alias la='ls -lAhG --group-directories-first | sed /^total/d'
alias lr='ls -R'

# git aliases
alias ga='git add'
alias gaa='ga -A'
alias gi='git init -q'
alias gra='git remote add origin'
alias gr='git remotes'
alias gc='git commit'
alias gs='git status --short'
alias gp='git push --quiet'

# config aliases
alias envc='cd ~/.config/env/'
alias vc='v ~/.config/nvim/init.vim'

# most useless alias
alias rm='rm -rf'

# If no executable
# cmd tries to cd
setopt auto_cd

# FZF default options to improve speed
export FZF_DEFAULT_COMMAND='find . | grep -v ".git\|.node_modules\|.cache" && tput cuu 2'

# FZF appearance
export FZF_DEFAULT_OPTS='
  --reverse
  --info hidden
  --color fg:249,bg:0,hl:2,fg+:249,bg+:0,hl+:2
  --color info:6,prompt:249,spinner:7,pointer:1,marker:0,header:#586e75
'

# My own fzf script
# to fast work with
# files/dictonaries
fzf_open()
{
	# Remove 2 lines to cleaner look
	tput cuu 2

	TARGET=$(fzf --reverse --height 40% --preview "bat --color=always --style=numbers {}")

	# Checks is it file
	[ -f "$TARGET" ] && {

		# Checks file extension
		[ $(printf $TARGET | sed 's/.*\././') = .pdf ] && {

			# Open with default pdf app
			xdg-open $TARGET
		} || {

			# Open with default editor
			$EDITOR $TARGET ^M
		}
	} || {

		# If target is dictonary
		[ -d $TARGET ] && cd $TARGET
	}
}

# Update nvim plugins, pacman/yay packages
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

bindkey -s '^n' "fzf_open ^M"
bindkey -s '^e' "fc ^M"
bindkey -s '^f' "tput cuu 1 && nnn ^M"
