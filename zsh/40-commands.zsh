export EDITOR=nano VISUAL=nano

# Keep the command surface compact and predictable.
alias ls='eza --group-directories-first'
alias ll='eza -Alh --git --no-user --no-time --group-directories-first'
alias la='eza -A --group-directories-first'
alias cat='bat'
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git slog'
alias reload='source ~/.zshrc'
