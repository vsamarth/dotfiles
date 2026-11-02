#!/usr/bin/env bash
# Set the Dock's apps, left to right. Run after the apps are installed; safe to re-run.
set -euo pipefail

command -v dockutil >/dev/null || { echo "dockutil is required (brew install dockutil)" >&2; exit 1; }

# Add the first path that exists; warn if none do.
add() {
  for app in "$@"; do
    if [ -d "$app" ]; then dockutil --add "$app" --no-restart >/dev/null; return; fi
  done
  echo "Skipped, not installed: $1" >&2
}

dockutil --remove all --no-restart >/dev/null
add /Applications/Helium.app
add /Applications/Rex.app "/Applications/Rex Beta.app"
add /Applications/Claude.app
add "/Applications/Proton Mail.app"
add /System/Applications/Calendar.app
killall Dock
