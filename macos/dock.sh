# Ensure dockutil is installed
if ! command -v dockutil &>/dev/null; then
	echo "Dockutil must be installed to run this script."
	exit 1
fi

dockutil --remove all --no-restart

APPS=(

	"Firefox"
	"Cursor"
	"Ghostty"
	"Whatsapp"
	"Todoist"
	"Proton Mail"
	"Calendar"
	"ChatGPT"
	"Spotify"
)

for app in "${APPS[@]}"; do
	if [ -d "/Applications/$app.app" ]; then
		dockutil --add "/Applications/$app.app" --no-restart
	fi

	if [ -d "/System/Applications/$app.app" ]; then
		dockutil --add "/System/Applications/$app.app" --no-restart
	fi
done

killall Dock
