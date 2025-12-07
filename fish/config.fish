# Environment Variables
set -gx VISUAL code
set -gx EDITOR nvim
set -gx LANG "en_US.UTF-8"

# Path Configuration
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.dotfiles/bin"
fish_add_path "$HOME/go/bin"

# --- Integrations ---

# Homebrew
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Rust / Cargo
if test -d "$HOME/cargo"
    source "$HOME/.cargo/env.fish"
end

# Zoxide (Smarter cd)
if type -q zoxide
    zoxide init fish | source
end

# Direnv (Directory-specific env)
if type -q direnv
    direnv hook fish | source
end

# FZF (Fuzzy Finder)
set -gx FZF_DEFAULT_OPTS "--height 40% --reverse --border --ansi --prompt='❯ '"
if type -q fzf
    fzf --fish | source
end

# --- Aliases & Abbreviations ---

# General Utilities
abbr -a e "$EDITOR"
alias vim "$EDITOR" 
alias hosts "sudo $EDITOR /etc/hosts"
alias reload "source $HOME/.config/fish/config.fish"

# Navigation & Listings
if type -q eza
    alias ls "eza -A --sort type"
    alias ll "eza -A --long --sort type --git --no-user --no-time"
end

if type -q bat
    alias cat bat
end

if type -q fabric-ai
    alias fabric fabric-ai
end

if type -q lazygit
    abbr -a lg lazygit
end

# Git
abbr -a g git
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gcm "git checkout main"
abbr -a gco "git go"
abbr -a gd "git diff"
abbr -a gl "git slog"
abbr -a gp "git push"
abbr -a gs "git status -s"

# GitHub CLI
abbr -a ghb "gh browse"
abbr -a ghco "gh pr checkout"
abbr -a ghpc "gh pr create"
abbr -a ghpw "gh pr view --web"
abbr -a ghrv "gh repo view"

# Homebrew
abbr -a br brew
abbr -a bri "brew install -q"
abbr -a brls "brew list"
abbr -a brui "brew uninstall -q"
abbr -a brup "brew update -q && brew upgrade -q && brew cleanup -q"

# Zellij
abbr -a zl zellij
abbr -a zla "zellij attach --create"
abbr -a zlds "zellij attach --create (basename (pwd))"
abbr -a zlls "zellij list-sessions"

# Added by Antigravity
fish_add_path /Users/samarth/.antigravity/antigravity/bin
