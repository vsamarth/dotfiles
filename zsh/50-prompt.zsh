# Starship's configuration lives separately at ~/.config/starship.toml.
# Zsh otherwise reserves a trailing cell, which misaligns Starship's $fill.
ZLE_RPROMPT_INDENT=0
eval "$(starship init zsh)"

# Fish-like inline history suggestions. Accept the full suggestion with →.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^[[C' forward-char
