# Core completion must be ready before the first prompt. Rebuild its dump only
# after Homebrew's completion directories change; use the fast cached load
# otherwise. -u skips compaudit on rebuild: /opt/homebrew/share is group-writable
# by design, so the audit would prompt "insecure directories" in every new shell.
fpath=(/opt/homebrew/share/zsh/site-functions /opt/homebrew/share/zsh-completions $fpath)
autoload -Uz compinit
_zsh_compdump="$HOME/.zcompdump"
if [[ ! -s "$_zsh_compdump" || /opt/homebrew/share/zsh/site-functions -nt "$_zsh_compdump" || /opt/homebrew/share/zsh-completions -nt "$_zsh_compdump" ]]; then
  compinit -u -d "$_zsh_compdump"
else
  compinit -C -d "$_zsh_compdump"
fi
unset _zsh_compdump

# These generated completions stay current but cost nothing at shell startup:
# they load on the first Tab for their command in each shell.
_lazy_uv_completion() {
  unfunction _lazy_uv_completion
  source <(uv generate-shell-completion zsh)
  _uv "$@"
}
compdef _lazy_uv_completion uv

_lazy_pnpm_completion() {
  unfunction _lazy_pnpm_completion
  source <(pnpm completion zsh)
  _pnpm_completion "$@"
}
compdef _lazy_pnpm_completion pnpm

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors 'di=36' 'ln=33' 'ex=32'

bindkey -e
setopt auto_cd interactive_comments no_beep
