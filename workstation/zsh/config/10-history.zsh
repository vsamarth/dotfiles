HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt append_history inc_append_history share_history
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space
setopt hist_reduce_blanks hist_save_no_dups hist_verify
