# Zsh config file
# Copyright (c) 2022 fenze <contact@fenze.dev>

# autoload autocomplete
autoload -Uz compinit

precmd()
{
  # Autocomplete
  compinit
}

export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

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

setopt complete_aliases
setopt complete_in_word
setopt always_to_end
setopt path_dirs
setopt auto_menu
setopt auto_list
setopt auto_param_slash
setopt menu_complete

# History
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt inc_append_history

# better url management
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# history substring search
zle -N history-substring-search-up
# zle -N history-substring-search-down

# nvim as default editor
export EDITOR='nvim'
alias v='nvim'

# ls aliases
alias ls='exa --color=always'
alias la='ls -l --group-directories-first --git-ignore --git --no-time --no-user'
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
# doas
alias 'doas=doas '
alias d='doas '

alias reload='source ~/.config/zsh/.zshrc'

alias dev='cd ~/dev'
alias tmp='cd ~/tmp'
alias sys='cd ~/sys'

# most useless aliases
alias rm='rm -rf'

# If no executable
# cmd tries to cd
setopt auto_cd

# spelling correction
setopt correct
setopt correct_all

# Ignore lines prefixed with '#'
setopt interactivecomments

# Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
setopt rc_quotes

# prevents you from accidentally overwriting an existing file.
setopt noclobber

FIND_EXCEPTIONS='.git\|.node_modules\|.cache\|.css\|.java\|.android\|.local\|.gradle\|google'

# FZF default options to improve speed
export FZF_DEFAULT_COMMAND="find . -type f | grep -iv $FIND_EXCEPTIONS"

# FZF appearance
export FZF_DEFAULT_OPTS='
	--color bg+:-1,bg:-1,spinner:#F8BD96,hl:#FFFFFF
	--color fg:#999999,header:#F28FAD,info:#FFFFFF,pointer:#FFFFFF
	--color=marker:#FFFFFF,fg+:#F2CDCD,prompt:#FFFFFF,hl+:#E8A2AF
	--no-bold
	--inline-info
'

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

# Update nvim plugins,
# pacman/yay packages
update() {
  echo "Updating: neovim plugins..." && {
    $(nvim -c PlugUpdate -c qa! &> /dev/null) && {
      tput cuu 1 && echo "Neovim: Cleaning...\r"
    }

    $(nvim -c PlugClean -c qa! &> /dev/null) && {
      tput cuu 1 && echo "Neovim: plugins update done."
    }
  }

  echo "Updating: pacman packages..." && {
    $(doas pacman -Syyu --quiet --noconfirm &> /dev/null) && {
      tput cuu 1
      echo "Pacman: Cleaning..."
      $(echo "y\ny" | doas pacman -Scc &> /dev/null) && {
        tput cuu 1
        echo "Pacman: packages update done."
      }
    }
  }

  echo "Updating: yay packages" && {
    $(doas yay -Syyu --quiet --noconfirm &> /dev/null) && {
      tput cuu 1
      echo "yay: Cleaning..."
      $(echo "y\ny\ny" | doas yay -Scc &> /dev/null) && {
        tput cuu 1
        echo "yay: packages update done."
      }
    }
  }
}

# Bindings
bindkey -s '^k' "fzf_open '-type d'^M"
bindkey -s '^n' "fzf_open '-type f'^M"
bindkey -ar ':'
