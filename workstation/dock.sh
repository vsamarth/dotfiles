#!/usr/bin/env bash

set -euo pipefail

if ! command -v dockutil >/dev/null 2>&1; then
  printf 'dockutil is required; run the workstation bootstrap first.\n' >&2
  exit 1
fi

dockutil --remove all --no-restart

apps=(
  'Google Chrome'
  'Visual Studio Code'
  'Ghostty'
  'WhatsApp'
  'Notion'
  'Linear'
  'Slack'
  'ChatGPT'
  'Spotify'
)

for app in "${apps[@]}"; do
  if [[ -d "/Applications/$app.app" ]]; then
    dockutil --add "/Applications/$app.app" --no-restart
  fi
done

if [[ -d '/System/Applications/Calendar.app' ]]; then
  dockutil --add '/System/Applications/Calendar.app' --no-restart
fi

killall Dock 2>/dev/null || true
printf 'Installed the clean workstation Dock layout.\n'
