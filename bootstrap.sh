#!/bin/sh
set -e

DOTFILES_REPO="https://github.com/vsamarth/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

xcode-select -p >/dev/null 2>&1 || { xcode-select --install; echo "Re-run after the Command Line Tools finish."; exit 0; }

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

[ -d "$DOTFILES_DIR" ] || git clone "$DOTFILES_REPO" "$DOTFILES_DIR"

command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

echo "Next: cd ~/.dotfiles, run claude, and ask it to follow instructions.md"
