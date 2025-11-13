#!/bin/sh

DOTFILES_REPO="https://github.com/vsamarth/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"


set -e

info() {
  tput bold
  echo "$1"
  tput sgr0
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

if ! command -v brew >/dev/null 2>&1; then
  info "Installing homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Check if dotfiles already exist
if [ -d "$DOTFILES_DIR" ]; then
  info "Dotfiles directory already exists at $DOTFILES_DIR"
  read -p "Do you want to update it? (y/n): " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    info "Updating dotfiles..."
    cd "$DOTFILES_DIR" || exit
    git pull || exit
    info "Running dotfiles script"
    "$DOTFILES_DIR/bin/dot" setup
  else
    info "Skipping clone. Run '$DOTFILES_DIR/bin/dot setup' manually if needed."
  fi
else
  info "Cloning your dotfiles..."
  git clone $DOTFILES_REPO "$HOME/.dotfiles"

  info "Running dotfiles script"
  "$DOTFILES_DIR/bin/dot" setup
fi
