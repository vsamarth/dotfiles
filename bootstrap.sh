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

info "Cloning your dotfiles..."
git clone $DOTFILES_REPO "$HOME/.dotfiles"

info "Running dotfiles script"
"$DOTFILES_DIR/bin/dot" setup
