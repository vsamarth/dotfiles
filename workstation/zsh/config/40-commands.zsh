export EDITOR='nvim'
export VISUAL='code --wait'
export GIT_EDITOR="$EDITOR"
export ZELLIJ_SOCKET_DIR="/tmp/zellij-${EUID}"

alias ls='eza --group-directories-first'
alias ll='eza -Alh --git --no-user --no-time --group-directories-first'
alias la='eza -A --group-directories-first'
alias cat='bat'
alias g='git'
alias lg='lazygit'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git slog'
alias reload='source ~/.zshrc'

y() {
  local cwd_file cwd
  cwd_file="$(mktemp -t yazi-cwd)"
  yazi "$@" --cwd-file="$cwd_file"
  if IFS= read -r cwd < "$cwd_file"; then
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  fi
  command rm -f -- "$cwd_file"
}

zj() {
  if [[ -n "${ZELLIJ-}" ]]; then
    print -u2 'zj: already inside a Zellij session'
    return 1
  fi

  local repo_root session_name
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || repo_root="${PWD:A}"
  session_name="work-${repo_root:t}"

  (
    builtin cd -- "$repo_root" || return
    zellij attach --create "$session_name"
  )
}
