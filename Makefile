SHELL := /bin/bash
DOTFILES := $(shell pwd)

.PHONY: bootstrap

# Assumes homebrew is installed

bootstrap: fish vscode

.PHONY: fish

brewInstall = @brew install -q $(1)

heading = $(shell tput setaf 4)$(shell tput bold)❯❯ $(1)$(shell tput sgr0)
message = $(shell tput bold) ❯ $(1)$(shell tput sgr0)

fish-install:
ifeq ($(shell command -v fish),)
	$(info $(call message,Installing fish shell))
	$(call brewInstall,fish)
else
	$(info $(call message,Fish shell found at $(shell command -v fish)))
endif


fish: fish-install
# Check if fish is in /etc/shells
ifeq ($(shell grep $(shell command -v fish) /etc/shells),)
	$(info $(call message,Adding $(shell command -v fish) to /etc/shells))
	$(shell echo $(shell command -v fish) | sudo tee -a /etc/shells)
else
	$(info $(call message,Fish shell found in /etc/shells))
endif
# Make fish the default shell if it isn't already
ifneq ($(shell echo $$SHELL),$(shell command -v fish))
	$(info $(call message,Setting fish as default shell))
	$(shell chsh -s $(shell command -v fish))
else
	$(info $(call message,Fish shell is already the default shell))
endif
# Install fisher
	$(info $(call message,Updating fisher plugins))
# Install fisher
	@fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"


vscode-install:
ifeq ($(shell command -v code),)
	$(info $(call message,Installing Visual Studio Code))
	$(call brewInstall,visual-studio-code)
else
# Extract vscode version
	$(eval vscodeVersion := $(shell code --version | head -n 1 | cut -d ' ' -f 3))
	$(info $(call message,Visual Studio Code v$(vscodeVersion) found at $(shell command -v code)))
endif

vscode: vscode-install
	$(info $(call message,Installing Visual Studio Code extensions))
# Install extensions
	@$(foreach plugin,$(shell cat "$(DOTFILES)/vscode/extensions"),code --list-extensions | grep $(plugin) > /dev/null || code --install-extension $(plugin);)


node:
	$(call brewInstall,fnm)
	@fnm completions --shell fish > ~/.config/fish/completions/fnm.fish
	@fnm use --install-if-missing 19
	@npm install -g \
		prettier fkill-cli pnpm tldr trash-cli zx

rust:
	brew install rustup-init
	rustup-init -y
	cargo install cargo-update