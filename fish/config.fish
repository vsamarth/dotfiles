if type -q nvim
    set -gx EDITOR "nvim"
else 
    set -gx EDITOR "vim"
end

if type -q code
    set -gx VISUAL "code"
else
    set -gx VISUAL $EDITOR
end

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.dotfiles/bin"

# Homebrew
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
abbr -a e "$EDITOR"