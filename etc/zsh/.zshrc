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
source /usr/share/fzf/key-bindings.zsh

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
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*:*:*:*:processes' command'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false


# better url management
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# history substring search
zle -N history-substring-search-up
# zle -N history-substring-search-down

alias v='nvim'

# ls aliases
alias ls='exa --color=always'
alias la='ls -la --group-directories-first --git-ignore --git --no-time --no-user'
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
alias gpp='git pull --no-commit'
alias gd='git diff --minimal'
alias gl='git log --oneline'
alias bat='bat --theme=ansi'

alias reload='source ~/.config/zsh/.zshrc'
alias pacman='doas pacman'
alias dev='cd ~/dev'
alias tmp='cd ~/tmp'
alias sys='cd ~/sys'

# most useless aliases
alias rm='rm -rf'

# My own fzf script
# to fast work with
# files/dictonaries
fzf_open()
{
  # Remove 2 lines
  # to cleaner look
  tput cuu 2

	[ "$1" = '-type d'  ] && {
		TARGET=$(find . -type d | grep -v $FIND_EXCEPTIONS | fzf --reverse --height 40%)
	}

	[ "$1" = '-type f' ] && {
		TARGET=$(find . -type f | grep -v $FIND_EXCEPTIONS | fzf --reverse --height 40%)
	}

  [ -z $TARGET ] && return

  # Checks is it file
  [ -f $TARGET ] && {
		FILE_TYPE=$(printf $TARGET | sed 's/.*\././')

    # Checks file extension
    [  $FILE_TYPE = .pdf ] && {
      # Open with default pdf app
      xdg-open $TARGET
			return
    }

    [  $FILE_TYPE = .html ] && {
				read ANSWER"?Open with browser or vim? [b/V] " && \
				[ $ANSWER = b ] && {
					$(xdg-open $TARGET &> /dev/null &)
					return
				}
    }

		$EDITOR $TARGET ^M
  } || {
    # If target is dictonary
    [ -d $TARGET ] && cd $TARGET
  }
}

# Bindings
bindkey -s '^k' "fzf_open '-type d'^M"
bindkey -s '^n' "fzf_open '-type f'^M"
bindkey -ar ':'
