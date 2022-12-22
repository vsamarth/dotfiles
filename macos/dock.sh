#!/usr/bin/env bash

# Check if dockutil is installed
if ! command -v dockutil &>/dev/null; then
	# Adapted from https://github.com/kcrawford/dockutil/issues/127#issuecomment-1086442131
    echo "Installing dockutil..."
	download_url=$(curl --silent "https://api.github.com/repos/kcrawford/dockutil/releases/latest" | jq -r .assets[].browser_download_url | grep pkg)
	curl -sL ${download_url} -o /tmp/dockutil.pkg
	sudo installer -pkg "/tmp/dockutil.pkg" -target /
	rm /tmp/dockutil.pkg
fi

APPS=('Firefox Developer Edition' 'Visual Studio Code' 'iTerm' 'Spark Desktop' 'Todoist' 'Calendar' 'WhatsApp' 'Discord' 'Spotify')

dockutil --no-restart --remove all

for app in "${APPS[@]}"; do
	dockutil --no-restart --add "/Applications/$app.app"
done

killall Dock