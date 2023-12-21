if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

set -gx EDITOR "nvim"
set -gx VISUAL "code --wait"

abbr -a br "brew"
abbr -a bri "brew install -q"
abbr -a brui "brew uninstall -q"
abbr -a brup "brew update -q && brew upgrade -q && brew cleanup -q"
abbr -a brls "brew list"

abbr -a g "git"
abbr -a gs git status -s

alias reload "source $HOME/.config/fish/config.fish"

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

alias hosts "sudo $EDITOR /etc/hosts"
alias e "$EDITOR"
