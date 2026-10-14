#!/usr/bin/env bash
set -euo pipefail

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 52
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-recents -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Window tiling and trackpad
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

killall Dock Finder

# Always-on with the lid closed needs sudo, so it is not run here.
# The agent shows this command and waits for approval:
#   sudo pmset -a disablesleep 1
