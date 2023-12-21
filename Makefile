# Assumes homebrew is installed
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CURRENT_SHELL := $(shell echo $$SHELL)

define message
	@tput bold
	@echo "❯ $(1)"
	@tput sgr0
endef

define heading
	@echo
	@tput bold
	@tput setaf 4
	@echo "❯ $(1)"
	@tput sgr0
endef

define symlink 
	@$(DOTFILES_DIR)/bin/symlink $(1) $(2)
endef

all: sudo fish neovim

NVIM_CONFIG_DIR := $(HOME)/.config/nvim

sudo:
ifndef GITHUB_ACTION
	@sudo -v
	@while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

NVIM_CONFIG_DIR := $(HOME)/.config/nvim

neovim:
	$(call heading,Configuring neovim)
	$(call message,Installing neovim)
	brew install -q neovim
	$(call message,Linking neovim config)
	$(call symlink,$(DOTFILES_DIR)/nvim,$(NVIM_CONFIG_DIR))
	$(call message,Installing neovim plugins)
	nvim --headless "+Lazy! sync" +qa

.PHONY: fish

FISH_CONFIG_DIR := $(HOME)/.config/fish
fish:
	$(call heading,Configuring fish shell)
	$(call message,Installing fish shell)
	brew install -q fish
	$(call message,Symlinking fish config)
	$(call symlink,$(DOTFILES_DIR)/fish,$(FISH_CONFIG_DIR))

