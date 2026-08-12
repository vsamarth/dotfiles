eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --prompt="❯ "'
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh

zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-min-height 12
zstyle ':fzf-tab:*' fzf-flags \
  --border=rounded \
  --color='fg:#d3c6aa,bg:#2f383e,hl:#dbbc7f,fg+:#d3c6aa,bg+:#3d484d,hl+:#dbbc7f,info:#a7c080,prompt:#e69875,pointer:#a7c080,marker:#d699b6,spinner:#83c092'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
