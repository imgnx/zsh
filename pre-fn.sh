
clean() {
	find $HOME/src -type d -name "*.venv*" -o -name "*.build*" -o -name "*node_modules*" -o -name "*target*" -o -name "*build*" -o -name "*dist*" -exec rm -rf "{}" \;
	find $HOME/lib -type d -name "*.venv*" -o -name "*.build*" -o -name "*node_modules*" -o -name "*target*" -o -exec rm -rf "{}" \;
}

noiphone() {
	local pref="com.apple.audio.SystemSettings"
	if sudo defaults read $pref SuppressDeviceDisconnectAlerts 2>/dev/null | grep -q 1; then
		sudo defaults delete $pref SuppressDeviceDisconnectAlerts
		echo "🔊 Restoring audio disconnection notifications..."
	else
		sudo defaults write $pref SuppressDeviceDisconnectAlerts -bool true
		echo "🔇 Disabling audio disconnection notifications..."
	fi
	sudo killall coreaudiod
}

iPhoneMicNotifMurderer() {
	echo "🔪 Killing Audio Disconnection popups..."
	echo "This is a polling method, by the way."
	echo "Press [Enter] to continue"
	while true; do
		# Look for the process that spawns the popup (usually NotificationCenter or coreaudiod helper)
		pkill -f "Audio Disconnected" 2>/dev/null
		sleep 1
	done
}

murder() {
	echo "🔪 Killing $1"
	echo "This function uses a polling method, by the way."
	echo "Press [Enter] to continue."
	read
	while true; do
		pkill -f "$1" 2>/dev/null
		sleep 1
	done
}
alias redrum="murder"

