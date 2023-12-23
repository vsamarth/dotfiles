#!/usr/bin/env bash

set -e

DOTFILES_REPO="https://github.com/vsamarth/dotfiles.git"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

if ! xcode-select -p &>/dev/null; then
  echo "Run xcode-select --install to install the Xcode Command Line Tools first"
  echo "and run this script again afterwards."
  exit 1
fi

if ! command -v brew &>/dev/null; then
  echo "Installing homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Cloning your dotfiles..."
git clone $DOTFILES_REPO "$HOME/.dotfiles"
