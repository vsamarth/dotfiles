# Assumes homebrew is installed.

HOMEBREW_PREFIX := /opt/homebrew
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
CURRENT_SHELL := $(shell echo $$SHELL)

setup: sudo create-dirs fish vscode git tmux dock

sudo:
ifndef GITHUB_ACTION
	@sudo -v
	@while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

clean:
	brew cleanup


create-dirs:
	mkdir -p $(HOME)/.config
	mkdir -p $(HOME)/.local/bin


.PHONY: fish

FISH_CONFIG_DIR := $(HOME)/.config/fish
FISH_PATH := $(HOMEBREW_PREFIX)/bin/fish
fish:
	brew install -q fish
	symlink $(DOTFILES_DIR)/fish $(FISH_CONFIG_DIR)
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
	@if ! grep -Fxq "$(FISH_PATH)" /etc/shells; then \
		echo "$(FISH_PATH)" | sudo tee -a /etc/shells > /dev/null; \
	fi
	@if [ "$(CURRENT_SHELL)" != "$(FISH_PATH)" ]; then \
		chsh -s "$(FISH_PATH)"; \
	fi

VSCODE_EXTENSIONS := jdinhlife.gruvbox esbenp.prettier-vscode vscode-icons-team.vscode-icons
VSCODE_SETTINGS := "$(HOME)/Library/Application Support/Code/User/settings.json"

.PHONY: vscode
vscode:
	$(info Setting up Visual Studio Code)
	brew install -q visual-studio-code
	$(foreach extension,$(VSCODE_EXTENSIONS),code --install-extension $(extension);)
	symlink $(DOTFILES_DIR)/vscode/settings.json $(VSCODE_SETTINGS)

.PHONY: git
git: 
	$(info Setting up Git and Github CLI)
	brew install -q git gh git-delta
	symlink $(DOTFILES_DIR)/git/gitconfig $(HOME)/.gitconfig
	symlink $(DOTFILES_DIR)/git/gitignore $(HOME)/.gitignore

.PHONY: dock
dock:
	$(info Setting up your dock)
	brew install -q dockutil
	bash $(DOTFILES_DIR)/macos/dock.sh

.PHONY: rust
rust:
	$(info Setting up Rust)
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	source "$(HOME)/.cargo/env" && cargo install cargo-edit cargo-update

.PHONY: python
python:
	$(info Setting up Python)
	brew install -q python pipx
	pipx install poetry ruff


.PHONY: node
node:
	$(info Setting up Node.js)
	brew install -q node
	npm install -g pnpm fkill-cli

.PHONY: neovim
neovim:
	$(info Setting up Neovim)
	brew install -q neovim
	symlink $(DOTFILES_DIR)/nvim $(HOME)/.config/nvim

.PHONY: tmux
tmux:
	$(info Setting up Tmux)
	brew install -q tmux
	symlink $(DOTFILES_DIR)/tmux $(HOME)/.config/tmux
