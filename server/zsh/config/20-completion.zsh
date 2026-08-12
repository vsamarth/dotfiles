fpath=(/opt/homebrew/share/zsh/site-functions /opt/homebrew/share/zsh-completions $fpath)
autoload -Uz compinit
_zsh_compdump="$HOME/.zcompdump"
if [[ ! -s "$_zsh_compdump" || /opt/homebrew/share/zsh/site-functions -nt "$_zsh_compdump" || /opt/homebrew/share/zsh-completions -nt "$_zsh_compdump" ]]; then
  compinit -d "$_zsh_compdump"
else
  compinit -C -d "$_zsh_compdump"
fi
unset _zsh_compdump

_lazy_uv_completion() {
  unfunction _lazy_uv_completion
  source <(uv generate-shell-completion zsh)
  _uv "$@"
}
compdef _lazy_uv_completion uv

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
bindkey -e
setopt auto_cd interactive_comments no_beep
