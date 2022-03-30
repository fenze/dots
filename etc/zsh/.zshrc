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
zle-keymap-select() {
  [[ $KEYMAP = vicmd ]] && printf '\e[2 q' || printf '\e[5 q'
}

zle -N zle-keymap-select

prompt='$([ $PWD = $HOME ] || echo "[%2~] ")> '

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
alias gd='git diff --minimal'

# doas
alias 'doas=doas '
alias d='doas '

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

# FZF default options to improve speed
export FZF_DEFAULT_COMMAND='find . | grep -v ".git\|.node_modules\|.cache" && tput cuu 2'

# FZF appearance
export FZF_DEFAULT_OPTS='
	--color bg+:#1E1E2E,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD
	--color fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96
	--color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD
	--reverse
	--no-bold
	--info hidden
'

# My own fzf script
# to fast work with
# files/dictonaries
fzf_open()
{
  # Remove 2 lines
  # to cleaner look
  tput cuu 1

  TARGET=$(fzf --reverse --height 40% --preview "bat --color=always --style=numbers {}")
  [ -z $TARGET ] && exit

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
      tput cuu 1
      echo "Neovim: Cleaning..."
    }

    $(nvim -c PlugClean -c qa! &> /dev/null) && {
      tput cuu 1
      echo "Neovim: plugins update done."
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
bindkey -s '^n' "fzf_open ^M"
bindkey -s '^e' "fc ^M"
bindkey -s '^f' "tput cuu 1 && nnn ^M"
