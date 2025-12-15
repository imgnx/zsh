#!/bin/zsh
#shellscript .zshenv
# Zsh environment configuration file.
# Loaded for all zsh invocations, including non-interactive shells.
# If this zsh session is non‑interactive, exit quietly.
echo "" >"$HOME/Desktop/zsh_debug.log"

setopt DEBUG_BEFORE_CMD

if [[ ! -o interactive ]]; then
	echo "----------------------------------------" # 💤
	# Non-interactive zsh session; exiting .zshenv...
	return
fi

autoload -Uz compinit
compinit

# if [[ ! -z "$ZSH_DEBUG" ]]; then
#     which compdef
# fi

# Feature flags
export TABULA_RASA="${TABULA_RASA:-}"
export ZSH_DEBUG="${ZSH_DEBUG:-}"
export FEATURE_FLAGS=("TABULA_RASA" "ZSH_DEBUG")
for flag in $FEATURE_FLAGS; do
	if [[ ! -z "$(eval echo \$$flag)" ]]; then
		echo -en "\033[48;2;20;255;0m ${flag} \033[0m"
	else
		echo -en "\033[48;2;255;0;0m ${flag} \033[0m"
	fi
	echo -n " "
	case $flag in
	TABULA_RASA)
		echo "----------------------------------------" # 💤
		echo "Clearing environment variables..."
		export -U
		;;
	esac
done
echo "\n"

source $XDG_CONFIG_HOME/zsh/bin/__wrap_notice

####### WRITE ANY NEW ENVIRONMENT CONFIGURATIONS BELOW THIS LINE #######

# Homebrew

alias cl="clear"
alias python="/opt/homebrew/bin/python3.12"
# alias pythong="python"
alias pip="pip3" # Homebrew
alias ls="eza"
alias la="ls -la"
# alias code="code-insiders"
alias ci="code-insiders"
alias gcp="gcloud storage cp --no-clobber"
alias grsync="gcloud storage rsync --no-clobber"
alias ai="cd $HOME/src/dinglehopper/codex && ls -la; say \"Please select a snippet from the list of prompts or type c-o-d-e-x and hit enter to begin interactively.\""

# trash() {
#   [ -d ~/.Trash ] || mkdir -p ~/.Trash
#   case "$1" in
#     -r|-rf|-f) shift ;;
#   esac
#   mv -f "$@" ~/.Trash/
# }

# __wrap_notice rm
# alias rm='trash'

root() {
	git rev-parse --show-toplevel
}

dusort() {
	du -ah | sort -hr | bat --style=plain
}

print -P "\033[0m\033[38;2;255;225;0m%B Tip: exec \`nmap\` to scan the network.${reset}\033[0m"

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

export NVM_DIR="$HOME/.config/nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Python sanity check
python -c "import sys; print(sys.executable); print(sys.prefix)" >/dev/null &&
	echo -en "\033[2mpip:\033[0m\033[32m canhaz\033[0m\n" ||
	echo -en "\033[2mpip:\033[0m\033[5m\033[31m cannothaz\!\033[0m\n"

# XDG Base Directory
export XDG_CONFIG_HOME="/Users/donaldmoore/.config"
export XDG_CACHE_HOME="/Users/donaldmoore/.cache"
export XDG_DATA_HOME="/Users/donaldmoore/.local/share"
export XDG_STATE_HOME="/Users/donaldmoore/.local/state"
