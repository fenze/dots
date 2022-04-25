# Zsh config file
# Copyright (c) 2022 fenze <contact@fenze.dev>

# autoload autocomplete
autoload -Uz compinit

precmd()
{
  # Autocomplete
  compinit
}

prompt='$([ $PWD = $HOME ] || echo "%~ ")› '

# Activate vim mode.
bindkey -v

# Reduce annoying delay
# when switch vim modes
KEYTIMEOUT=1

# FZF keybinds after bindkey
# to unblock useful history etc.
# . /usr/share/fzf/key-bindings.zsh

# LS style and default options
export LS_COLORS=$LS_COLORS:"no=7;0":"di=34": \
	"ln=32":"so=34:pi=0;33":"ex=3":"bd=34;46":"cd=30;43": \
	"su=30;41":"sg=30;46":"ow=30;43":"tw=30;42":

# ZSH completion menu with colors
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*:*:*:*:processes' command'ps -u $USER -o comm -w -w'
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false

alias v='nvim'

# ls aliases
alias ls='exa --color=always'
alias la='ls -la --group-directories-first --git-ignore --git --no-time --no-user'

# git aliases
alias ga='git add'
alias gaa='ga -A'
alias gi='git init -q'
alias gra='git remote add origin'
alias gr='git remotes'
alias gc='git commit'
alias gs='git status --short'
alias gp='git push --quiet'
alias gpp='git pull --no-commit'
alias gd='git diff --minimal'
alias gl='git log --oneline'


# doas aliases
alias 'doas=doas'

# pacman aliases
alias pacman='doas pacman'

alias reload='. ~/.config/zsh/.zshrc'

# cd aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias rm='rm -rf'

# FZF appearance
export FZF_DEFAULT_OPTS='
	--color bg+:-1,bg:-1,spinner:#F8BD96,hl:#FFFFFF
	--color fg:#999999,header:#F28FAD,info:#FFFFFF,pointer:#FFFFFF
	--color=marker:#FFFFFF,fg+:#F2CDCD,prompt:#FFFFFF,hl+:#E8A2AF
	--no-bold
	--reverse
	--inline-info
'

setopt complete_aliases
setopt complete_in_word
setopt always_to_end
setopt path_dirs
setopt auto_menu
setopt auto_list
setopt auto_param_slash
setopt menu_complete
setopt prompt_subst

# History
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt inc_append_history
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS

# spelling correction
setopt correct
setopt correct_all

# Ignore lines prefixed with '#'
setopt interactivecomments

# Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
setopt rc_quotes

# prevents you from accidentally overwriting an existing file.
setopt noclobber


export PATH=$PATH:/home/fenze/.config/android/platform-tools
export PATH=$PATH:/home/fenze/.local/bin

# nvim as default editor
export EDITOR='nvim'

export HISTORY_IGNORE="(*la*|cd*|*reboot*|fzf_open*)"

export FIND_EXCEPTIONS='.git\|.node_modules\|.cache\|.css\|.java\|.android\|.local\|.gradle\|google'

# FZF default options to improve speed
export FZF_DEFAULT_COMMAND="find . -type f | grep -vi $FIND_EXCEPTIONS"

fzf_open()
{
  tput cuu 2

	[ "$1" = '-type d'  ] && TARGET=$(find . -type d | cut -b3- | grep -vi "$FIND_EXCEPTIONS\|.config" | fzf --height 40%)
	[ "$1" = '-type f'  ] && TARGET=$(find . -type f | cut -b3- | grep -vi $FIND_EXCEPTIONS  | fzf --height 40%)

  [ -z $TARGET ] && return

  [ -f $TARGET ] && {
		FILE_TYPE=$(printf $TARGET | sed 's/.*\././')

		[  $FILE_TYPE = .pdf ] && (xdg-open $TARGET; return)

    [  $FILE_TYPE = .html ] && {
				read ANSWER"?Open with browser or vim? [b/V] " && \
				[ $ANSWER = b ] && $(xdg-open $TARGET &> /dev/null &) & return
    }

		($EDITOR $TARGET) && return

  } || [ -d $TARGET ] && cd $TARGET
}

fzf_hist()
{
	selected=($(fc -lr | cut -f6- -d" " | fzf --tiebreak=index))
}

# Bindings
bindkey -s '^k' "fzf_open '-type d'^M"
bindkey -s '^n' "fzf_open '-type f'^M"
bindkey -s '^h' "tput cuu 1 && cd ~^M"
bindkey -s '^p' "tput cuu 1 && la ^M"

zle -N fzf_hist
bindkey -M vicmd '^R' fzf_hist
bindkey -M viins '^R' fzf_hist

bindkey -ar ':'
