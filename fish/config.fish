set -gx EDITOR "nvim"
set -gx VISUAL "code"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.dotfiles/bin"
if test -x "/opt/homebrew/bin/brew"
  eval "$(/opt/homebrew/bin/brew shellenv)"
end

if type -q zoxide
  zoxide init fish | source
end

if type -q eza
  alias ls "eza -A --sort type"
  alias lls "eza -A --long --sort type --git --no-user --no-time"
end

if type -q go
  fish_add_path "$(go env GOPATH)/bin"
end

if test -d "$HOME/.cargo"
  fish_add_path "$HOME/.cargo/bin"
end

if type -q bat
  alias cat "bat"
end


abbr -a br "brew"
abbr -a bri "brew install -q"
abbr -a brui "brew uninstall -q"
abbr -a brup "brew update -q && brew upgrade -q && brew cleanup -q"
abbr -a brls "brew list"

abbr -a g "git"
abbr -a gs git status -s
abbr -a gl git log
abbr -a ghrv gh repo view

alias reload "source $HOME/.config/fish/config.fish"

alias hosts "sudo $EDITOR /etc/hosts"
alias e "$EDITOR"

# tabtab source for packages
# sets up pnpm completion
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

if status is-interactive && type -q conda
  conda "shell.fish" "hook" $argv | source
end

# FZF

set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=40% --preview-window=wrap --marker="*" --prompt="❯" --pointer="❯"'

# Tmux aliases
abbr -a tm "tmux"
abbr -a tmc "tmux_create_session"
abbr -a tma "tmux_attach"
abbr -a tmls "tmux list-sessions"
