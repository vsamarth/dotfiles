# Assumes homebrew is installed.

HOMEBREW_PREFIX := /opt/homebrew
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
CURRENT_SHELL := $(shell echo $$SHELL)

# just in case using an unsupported macOS version for homebrew
export HOMEBREW_DEVELOPER=1

setup: sudo create-dirs fish vscode git dock

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
fish:
	brew install -q fish
	$(call symlink,$(DOTFILES_DIR)/fish,$(FISH_CONFIG_DIR))
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"




VSCODE_EXTENSIONS := jdinhlife.gruvbox esbenp.prettier-vscode vscode-icons-team.vscode-icons
VSCODE_SETTINGS := $(HOME)/Library/Application Support/Code/User/settings.json

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