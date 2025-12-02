# Dotfiles setup with Just
# Assumes homebrew is installed

# Variables using Just functions
dotfiles_dir := justfile_directory()
home_dir := env_var("HOME")
homebrew_prefix := "/opt/homebrew"
fish_config_dir := home_dir + "/.config/fish"
fish_path := homebrew_prefix + "/bin/fish"
vscode_settings := home_dir + "/Library/Application Support/Code/User/settings.json"
ghostty_dir := home_dir + "/.config/ghostty"
config_dir := home_dir + "/.config"
ssh_dir := home_dir + "/.ssh"

# Default recipe - run full setup
default:
    just setup

# Full setup
setup: sudo create-dirs fish vscode terminal git zellij ssh dev-tools brewfile dock macos
    @echo "Setup complete!"

# Keep sudo alive
sudo:
    @if [ -z "${GITHUB_ACTION:-}" ]; then \
        sudo -v; \
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null & \
    fi

# Create necessary directories
create-dirs:
    mkdir -p {{config_dir}}
    mkdir -p {{home_dir}}/.local/bin

# Install Fish shell
fish:
    @echo "Installing Fish shell..."
    brew install -q fish
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/fish {{fish_config_dir}}
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update" 2>/dev/null || true
    @if ! grep -Fxq "{{fish_path}}" /etc/shells 2>/dev/null; then \
        echo "{{fish_path}}" | sudo tee -a /etc/shells > /dev/null; \
    fi
    @if [ "$(echo $SHELL)" != "{{fish_path}}" ]; then \
        chsh -s "{{fish_path}}"; \
    fi

# Install VS Code
vscode:
    @echo "Setting up VS Code"
    brew install --cask -q visual-studio-code
    mkdir -p "{{home_dir}}/Library/Application Support/Code/User"
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/vscode/settings.json "{{vscode_settings}}"

terminal:
    @echo "Setting up Ghostty"
    brew install --cask -q ghostty
    mkdir -p "{{ghostty_dir}}"
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/ghostty/config "{{ghostty_dir}}/config"

# Install Git and GitHub CLI
git:
    @echo "Setting up Git and Github CLI"
    brew install -q git gh git-delta
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/git/gitconfig {{home_dir}}/.gitconfig
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/git/gitignore {{home_dir}}/.gitignore

# Setup macOS dock
dock:
    @echo "Setting up your dock"
    brew install -q dockutil
    bash {{dotfiles_dir}}/macos/dock.sh

# Configure macOS system defaults
macos:
    @echo "Configuring macOS system defaults..."
    bash {{dotfiles_dir}}/macos/.macos

# Install Rust
rust:
    @echo "Setting up Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env" && cargo install --quiet \
        cargo-edit \
        cargo-update \
        cargo-audit \
        cargo-outdated \
        cargo-tree \
        cargo-expand

# Install Python
python:
    @echo "Setting up Python"
    brew install -q python pipx
    pipx ensurepath
    @echo "Installing Python tools..."
    pipx install uv ruff

# Install Golang
go:
    @echo "Setting up Golang"
    brew install -q go
    @echo "Setting up Go environment..."
    mkdir -p {{home_dir}}/go/bin {{home_dir}}/go/src {{home_dir}}/go/pkg

# Install Node.js
node:
    @echo "Setting up Node.js"
    brew install -q node
    npm install -g bun fkill-cli

# Install Neovim
neovim:
    @echo "Setting up Neovim"
    brew install -q neovim
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/nvim {{config_dir}}/nvim

# Install Zellij
zellij:
    @echo "Setting up Zellij"
    brew install -q zellij
    mkdir -p {{config_dir}}/zellij
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/zellij {{config_dir}}/zellij


# Setup SSH config
ssh:
    @echo "Setting up SSH config"
    mkdir -p {{ssh_dir}}
    {{dotfiles_dir}}/bin/symlink {{dotfiles_dir}}/ssh/config {{ssh_dir}}/config

# Install development tools
dev-tools:
    @echo "Setting up development tools"
    brew install -q zoxide fzf fd ripgrep jq dust lazygit just

# Install all packages from Brewfile
brewfile:
    @echo "Installing packages from Brewfile..."
    brew bundle install --file={{dotfiles_dir}}/Brewfile

# Clean Homebrew caches
clean:
    brew cleanup

# List all available recipes
list:
    just --list
