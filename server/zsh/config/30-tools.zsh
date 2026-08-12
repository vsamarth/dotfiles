eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --prompt="❯ "'
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-min-height 12
