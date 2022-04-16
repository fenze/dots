export SPICETIFY_INSTALL="/home/fenze/.spicetify"
export PATH="$PATH:/home/fenze/.config/android/platform-tools"
export PATH="$PATH:/home/fenze/.local/bin"

# nvim as default editor
export EDITOR='nvim'

export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

export FIND_EXCEPTIONS='.git\|.node_modules\|.cache\|.css\|.java\|.android\|.local\|.gradle\|google'

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
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
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

# spelling correction
setopt correct
setopt correct_all

# Ignore lines prefixed with '#'
setopt interactivecomments

# Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
setopt rc_quotes

# prevents you from accidentally overwriting an existing file.
setopt noclobber
