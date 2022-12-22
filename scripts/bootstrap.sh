#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/scripts/utils.sh"

askSudo

heading "Preflight checks"

checkOperatingSystem
checkInternetConnection
# Xcode Command Line Tools
# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
	info "Installing Xcode Command Line Tools"
	xcode-select --install &>/dev/null

	# Wait until the Xcode Command Line Tools are installed
	until xcode-select -p &>/dev/null; do
		sleep 5
	done
	info "Xcode Command Line Tools installed at $(xcode-select -p)"
else
	info "Xcode Command Line Tools found at $(xcode-select -p)"
fi

# ------------------------------------------------------------------------------

heading "Setting up your environment"

# Homebrew
subheading "Homebrew"
if ! cmdExists brew; then
	info "Installing homebrew"
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
	info "Homebrew installed at $(brew --prefix)"
else
	info "Homebrew found at $(brew --prefix)"
fi
info "Updating homebrew cache"
brew update -q
info "Installing homebrew packages"
if ! brew bundle check --file="$DOTFILES/Brewfile" &>/dev/null; then
	brew bundle --file="$DOTFILES/Brewfile"
fi
info "Cleaning up homebrew cache"
brew cleanup -q

# ------------------------------------------------------------------------------

subheading "Fish"
ensureInstalled "Fish" "fish"

# Change default shell to fish
fishPath=$(which fish)
if ! grep -q "$fishPath" /etc/shells; then
	info "Adding $fishPath to /etc/shells"
	echo "$fishPath" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$fishPath" ]; then
	info "Changing default shell to fish"
	chsh -s "$fishPath"
else
	info "Fish configured as the default shell"
fi

info "Installing fisher"
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

info "Installing fish plugins"
fish -c "fisher update"

# ------------------------------------------------------------------------------

subheading "Git"
ensureInstalled "Git" "git"
ensureInstalled "Github CLI" "gh"

# Check if user is already logged in to gh
if ! gh auth status &>/dev/null; then
	info "Signing in to Github CLI"
	gh auth login
	# Wait until the user is logged in
	until gh auth status &>/dev/null; do
		sleep 5
	done
else
	info "Signed in to Github CLI as $(gh api user | jq -r '.login')"
fi

# ------------------------------------------------------------------------------

subheading "Visual Studio Code"

ensureInstalled "Visual Studio Code" "code"
# ln -fs "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

# Install extensions
info "Installing extensions"
while read -r extension; do
	code --list-extensions | grep -q "$extension" || code --install-extension "$extension"
done <"$DOTFILES/vscode/extensions"

# ------------------------------------------------------------------------------

subheading "Node.js"
ensureInstalled "Fast Node Manager (fnm)" "fnm"

info "Installing Node.js 18"
fnm use --install-if-missing 18 &>/dev/null

info "Installing npm packages"
npm install -g pnpm prettier fkill-cli trash-cli

# ------------------------------------------------------------------------------

