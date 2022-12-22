set DOTFILES "$HOME/.dotfiles"

fish_add_path "/opt/homebrew/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$DOTFILES/bin"

if type -q zoxide
    zoxide init fish | source
end

if type -q fnm
    fnm env  | source
end

if type -q conda
    eval conda "shell.fish" "hook" $argv | source
end
