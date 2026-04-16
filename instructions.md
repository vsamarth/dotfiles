# System Setup Instructions

This document describes how to set up the system from scratch.

## Prerequisites

Ensure Homebrew is installed. If not, install it from [brew.sh](https://brew.sh).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. Install Homebrew Packages

Install all formulas and casks.

### Formulas

```bash
brew install age bat cmake colima croc direnv docker-compose docker dockutil dust eza fabric-ai fd fish fzf gemini-cli gh git git-delta go jq just lazygit neovim node pipx python@3.12 ripgrep topgrade wget yt-dlp zellij zoxide
```

### Casks

```bash
brew install --cask chatgpt visual-studio-code discord docker font-jetbrains-mono ghostty firefox iina jordanbaird-ice@beta keepingyouawake monitorcontrol motrix proton-drive proton-mail protonvpn raycast rectangle shottr slack spotify telegram todoist-app whatsapp
```

## 2. Link Configuration Files

Link the dotfiles to their respective locations.

```bash
# Git
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/gitignore ~/.gitignore

# Fish
ln -sf ~/.dotfiles/fish ~/.config/fish

# Neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# Ghostty
ln -sf ~/.dotfiles/ghostty/config ~/.config/ghostty/config

# Zellij
ln -sf ~/.dotfiles/zellij ~/.config/zellij

# SSH
mkdir -p ~/.ssh
ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
```

## 3. Configure macOS System

Run the following commands to set macOS defaults.

```bash
# Set computer name
sudo scutil --set ComputerName "spacebook"
sudo scutil --set HostName "spacebook"
sudo scutil --set LocalHostName "spacebook"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "spacebook"

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Reload Finder
killall Finder
```

## 4. Setup Dock

Using `dockutil`, setup the dock to show the following apps in order:

1. Firefox
2. Visual Studio Code
3. Ghostty
4. Whatsapp
5. Todoist
6. Proton Mail
7. Calendar
8. ChatGPT
9. Spotify

```bash
brew install dockutil
dockutil --remove all --no-restart

APPS=(
    "Firefox"
    "Visual Studio Code"
    "Ghostty"
    "Whatsapp"
    "Todoist"
    "Proton Mail"
    "Calendar"
    "ChatGPT"
    "Spotify"
)

for app in "${APPS[@]}"; do
    if [ -d "/Applications/$app.app" ]; then
        dockutil --add "/Applications/$app.app" --no-restart
    fi
    if [ -d "/System/Applications/$app.app" ]; then
        dockutil --add "/System/Applications/$app.app" --no-restart
    fi
done

killall Dock
```

## 5. Setup Shell (Fish)

Install Fish and configure it.

```bash
brew install fish

# Add Fish to /etc/shells if not present
if ! grep -Fxq "/opt/homebrew/bin/fish" /etc/shells; then
    echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
fi

# Change default shell to Fish
if [ "$(echo $SHELL)" != "/opt/homebrew/bin/fish" ]; then
    chsh -s /opt/homebrew/bin/fish
fi

# Install Fisher plugin manager
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update" 2>/dev/null || true
```

## 6. Setup Editors

### VS Code

```bash
brew install --cask visual-studio-code
mkdir -p ~/Library/Application\ Support/Code/User
ln -sf ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

### Neovim

```bash
brew install neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim
```

## 7. Setup Terminal

### Ghostty

```bash
brew install --cask ghostty
mkdir -p ~/.config/ghostty
ln -sf ~/.dotfiles/ghostty/config ~/.config/ghostty/config
```

### Zellij

```bash
brew install zellij
ln -sf ~/.dotfiles/zellij ~/.config/zellij
```

## 8. Setup Browsers

### Firefox

```bash
brew install --cask firefox

# Ensure Firefox profile directory exists
if [ ! -d "$HOME/Library/Application Support/Firefox/Profiles" ]; then
    echo "Opening Firefox to initialize profile..."
    open -a Firefox
    sleep 10
    pkill -fi firefox || true
fi

# Find the default-release profile
PROFILE_DIR=$(ls -d "$HOME/Library/Application Support/Firefox/Profiles/"*.default-release 2>/dev/null | head -n 1)
if [ -n "$PROFILE_DIR" ]; then
    echo "Installing Betterfox user.js and overrides to $PROFILE_DIR..."
    cat ~/.dotfiles/firefox/user.js ~/.dotfiles/firefox/user-overrides.js > "$PROFILE_DIR/user.js"
    echo "Betterfox with overrides applied successfully."
else
    echo "Warning: Could not find a Firefox .default-release profile. Please open Firefox once and run this step again."
fi

# Set Firefox as default browser
open -a "Firefox" --args -silent -nosplash -setDefaultBrowser
```

## 9. Setup Development Environments

### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
source "$HOME/.cargo/env"
cargo install --quiet cargo-edit cargo-update cargo-audit cargo-outdated cargo-tree cargo-expand
```

### Python

```bash
brew install python@3.12 pipx
pipx ensurepath
pipx install uv ruff
```

### Go

```bash
brew install go
mkdir -p ~/go/bin ~/go/src ~/go/pkg
```

### Node.js

```bash
brew install node
npm install -g bun fkill-cli
```

## 10. Cleanup

```bash
brew cleanup
```
