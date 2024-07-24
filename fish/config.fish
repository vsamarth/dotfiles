# TODO: Organize this config file

set -gx VISUAL code
set -gx EDITOR nvim
set -gx LANG "en_US.UTF-8"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.dotfiles/bin"

# Homebrew
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

if test -d "$HOME/cargo"
    source "$HOME/.cargo/env.fish"
end

if type -q zoxide
    zoxide init fish | source
end

if type -q eza
    alias ls "eza -A --sort type"
    alias lls "eza -A --long --sort type --git --no-user --no-time"
end



if type -q bat
    alias cat bat
end


abbr -a br brew
abbr -a bri "brew install -q"
abbr -a brui "brew uninstall -q"
abbr -a brup "brew update -q && brew upgrade -q && brew cleanup -q"
abbr -a brls "brew list"

abbr -a g git
abbr -a gs git status -s
abbr -a gl git slog
abbr -a ghrv gh repo view

alias reload "source $HOME/.config/fish/config.fish"

alias hosts "sudo $EDITOR /etc/hosts"
abbr -a e "$EDITOR"

# FZF
set -gx FZF_DEFAULT_OPTS "--height 40% --reverse --border --ansi --prompt='❯ '"

if type -q fzf
    fzf --fish | source
end

# Tmux
abbr -a tm tmux
abbr -a tmds tmux_directory_session
abbr -a tmls tmux_list_sessions

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
    end
end
# <<< conda initialize <<<

