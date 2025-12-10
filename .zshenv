# If this zsh session is non‑interactive, exit quietly.
[[ -o interactive ]] || return

# Anything after this point runs only for interactive shells.
# echo "Expectations are pre‑meditated resentments"
echo -e "TABULA_RASA MODE: ${TABULA_RASA_MODE:-\033[38;2;255;32;0mfalse}${reset}"
# … your other prompt customizations …


# Homebrew

alias cl="clear"
alias python="python3"
alias pythong="python3"
alias pip="pip3" # Homebrew
alias ls="eza"
alias la="ls -la"
# alias code="code-insiders"
alias ci="code-insiders"
alias gcp="gcloud storage cp --no-clobber"
alias grsync="gcloud storage rsync --no-clobber"
alias ai="cd $HOME/src/dinglehopper/codex && ls -la; say \"Please select a snippet from the list of prompts or type c-o-d-e-x and hit enter to begin interactively.\""

# MARK: __wrap_notice
# ! Keep this at the top!
__wrap_notice() {
# ! Keep this at the top!
  if [[ "${ZSH_DEBUG:-false}" == "true" ]]; then
    local name="$1" path
    path=$(command -v "$name" 2>/dev/null || true)
    [[ -n "$path" ]] && echo "[wrap] $name -> $path"
  fi
} # End of __wrap_notice ! Keep this at the top!



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
__wrap_notice nmap
nmap() {
    nmap -vvv -Pn nim.local & 
    nmap -vvv -Pn bus.local
}

clean() {
    find $HOME/src -type d -name ".venv" -o -name ".build" -o -name "node_module" -o -name "build" -exec rm -rf "{}" \;
}

iPhoneMicNotifToggle() {
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
alias iphonefix="iPhoneMicNotifToggle"
alias noiphone="iPhoneMicNotifToggle"
reset() {
    exec zsh -l
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
    echo "🔪 Killing $1";
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
python -c "import sys; print(sys.executable); print(sys.prefix)" >/dev/null \
  && echo -en "\033[2mpip:\033[0m\033[32m canhaz\033[0m\n" \
  || echo -en "\033[2mpip:\033[0m\033[5m\033[31m cannothaz!\033[0m\n"


# Wrapper around gcloud that defaults to --no-clobber for storage cp
# Drop this in ~/.zshrc


__wrap_notice gcloud;
# /opt/homebrew/bin/gcloud
gcloud() {
  # Only intercept: gcloud storage cp|rsync
  if [[ "$1" == "storage" && ( "$2" == "cp" || "$2" == "rsync" ) ]]; then
    local sub="$2"
    shift 2

    local -a args=()
    local force=0 noclobber=0

    # Walk args: track/strip --force, preserve everything else
    for a in "$@"; do
      case "$a" in
        --force) force=1 ;;                  # our custom escape hatch
        --no-clobber) noclobber=1; args+="$a" ;;  # user already set it
        *) args+="$a" ;;
      esac
    done

    # Inject default if not forced and not already present
    if (( force == 0 && noclobber == 0 )); then
      args=(--no-clobber "${args[@]}")
    fi

    command gcloud storage "$sub" "${args[@]}"
  else
    # Everything else passes through untouched
    command gcloud "$@"
  fi
}


export ZSH_DEBUG=${ZSH_DEBUG:-true}  
echo -e "Debugger: ${ZSH_DEBUG}"
# XDG Base Directory
export XDG_CONFIG_HOME="/Users/donaldmoore/.config"
export XDG_CACHE_HOME="/Users/donaldmoore/.cache"
export XDG_DATA_HOME="/Users/donaldmoore/.local/share"
export XDG_STATE_HOME="/Users/donaldmoore/.local/state"
