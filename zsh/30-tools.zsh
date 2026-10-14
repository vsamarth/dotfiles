# Directory jumping and per-project environment loading need to be available
# before the first prompt.
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# FZF owns Ctrl-R / Ctrl-T. Its Tab binding is intentionally not loaded because
# fzf-tab below owns visual completion.
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --prompt="❯ "'
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# Searchable completion in the terminal's own colours. Tab again changes groups.
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-min-height 12
zstyle ':fzf-tab:*' fzf-flags \
  --border=rounded \
  --color=16
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
