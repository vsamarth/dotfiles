#!/usr/bin/env bash

set -euo pipefail

if ! command -v dockutil >/dev/null 2>&1; then
  printf 'dockutil is required; run the workstation bootstrap first.\n' >&2
  exit 1
fi

dockutil --remove all --no-restart

app_paths=(
  '/Applications/Safari.app'
  '/Applications/Ghostty.app'
  '/System/Applications/Messages.app'
  '/System/Applications/Calendar.app'
  '/System/Applications/Notes.app'
  '/Applications/IINA.app'
  '/System/Applications/System Settings.app'
)

for app_path in "${app_paths[@]}"; do
  if [[ -d "$app_path" ]]; then
    dockutil --add "$app_path" --no-restart
  fi
done

if [[ -d "$HOME/Downloads" ]]; then
  dockutil --add "$HOME/Downloads" --section others --view grid --display stack --sort dateadded --no-restart
fi

killall Dock 2>/dev/null || true
printf 'Installed the clean workstation Dock layout.\n'
