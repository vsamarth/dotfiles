# Assumes homebrew is installed
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CURRENT_SHELL := $(shell echo $$SHELL)

CARGO_PACKAGES := cargo-edit cargo-cache stylua
PIP_PACKAGES := tmuxp
NPM_PACKAGES := pnpm prettier fkill-cli serve

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
	$(DOTFILES_DIR)/bin/symlink $(1) $(2)
endef

all: sudo create-dirs fish neovim vscode git tmux go rust node python

NVIM_CONFIG_DIR := $(HOME)/.config/nvim

sudo:
ifndef GITHUB_ACTION
	@sudo -v
	@while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

NVIM_CONFIG_DIR := $(HOME)/.config/nvim

create-dirs:
	mkdir -p $(HOME)/.config
	mkdir -p $(HOME)/.local/bin

neovim:
	$(call heading,Configuring neovim)
	brew install -q neovim
	$(call symlink,$(DOTFILES_DIR)/nvim,$(NVIM_CONFIG_DIR))
	nvim --headless "+Lazy! sync" +qa

.PHONY: fish

FISH_CONFIG_DIR := $(HOME)/.config/fish
fish:
	$(call heading,Configuring fish shell)
	brew install -q fish
	$(call symlink,$(DOTFILES_DIR)/fish,$(FISH_CONFIG_DIR))
	fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"


.PHONY: go rust

go:
	$(call heading,Setting up Go)
	brew install -q go
	go env -w GOPATH="$(HOME)/.go"
	mkdir -p "$(HOME)/go"
	go install github.com/cosmtrek/air@latest
	brew install -q golangci-lint golang-migrate

rust:
	$(call heading,Setting up Rust)
	brew install -q rustup-init
	rustup-init --no-modify-path -y
	source $(HOME)/.cargo/env && cargo install $(CARGO_PACKAGES)

node:
	$(call heading,Setting up Node.js)
	brew install -q node
	npm install --global $(NPM_PACKAGES)

python:
	$(call heading,Setting up Python)
	brew install -q miniconda
	pip install --user $(PIP_PACKAGES)

.PHONY: vscode

VSCODE_SETTINGS := $(HOME)/Library/Application\ Support/Code/User/settings.json

vscode:
	$(call heading,Setting up Visual Studio Code)
	brew install -q visual-studio-code
	code --install-extension jdinhlife.gruvbox
	code --install-extension esbenp.prettier-vscode
	$(call symlink,$(DOTFILES_DIR)/vscode/settings.json,$(VSCODE_SETTINGS))

.PHONY: tmux
tmux:
	$(call heading,Setting up Tmux)
	brew install -q tmux
	$(call symlink,$(DOTFILES_DIR)/tmux/tmux.conf,$(HOME)/.tmux.conf)

.PHONY: git
git:
	$(call heading,Setting up Git)
	brew install -q git gh lazygit git-flow git-delta
	$(call symlink,$(DOTFILES_DIR)/git/gitconfig,$(HOME)/.gitconfig)
	$(call symlink,$(DOTFILES_DIR)/git/gitignore,$(HOME)/.gitignore)

BIN_DIR := $(HOME)/.local/bin

.PHONY: symlink-bin
