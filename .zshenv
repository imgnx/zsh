#!/bin/zsh
#shellscript .zshenv
# Zsh environment configuration file.
# Loaded for all zsh invocations, including non-interactive shells.
# If this zsh session is non‑interactive, exit quietly.
echo "" >"$HOME/Desktop/zsh_debug.log"

# XDG Base Directory
export XDG_CONFIG_HOME="/Users/donaldmoore/.config"
export XDG_CACHE_HOME="/Users/donaldmoore/.cache"
export XDG_DATA_HOME="/Users/donaldmoore/.local/share"
export XDG_STATE_HOME="/Users/donaldmoore/.local/state"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_HOOKS_DIR="$ZDOTDIR/hooks.d"

setopt DEBUG_BEFORE_CMD

if [[ ! -o interactive ]]; then
	# Non-interactive zsh session; exiting .zshenv...
	return
fi

#### PLACE ALL NEW SCRIPTS BELOW THIS LINE ####

# Feature flags
# export TABULA_RASA="${TABULA_RASA}" # Can't do that with this one and it has to be first. It's the "blank slate" feature flag.
export HARD_RESET="${HARD_RESET:-}"
export ZSH_DEBUG="${ZSH_DEBUG:-}"
export DEBUG_LEVEL="${DEBUG_LEVEL:-}"
export FEATURE_FLAGS=("TABULA_RASA" "HARD_RESET" "ZSH_DEBUG")

if [[ "$DEBUG_LEVEL" > 0 ]]; then
	echo "ZSH DEBUG_LEVEL: $DEBUG_LEVEL"
fi

for flag in $FEATURE_FLAGS; do
	if [[ -n ${flag//[^a-zA-Z0-9_]/} ]]; then
		val=$(eval echo \$$flag) # sanitize flag to ensure it's a valid variable name and retrieve its value
	else
		val="" # fallback if flag is not a valid variable name
	fi
	if [[ $val == true || ($val =~ '^[0-9]+$' && $val -gt 0) ]]; then

		echo -en "\033[48;2;20;255;0m ${flag} \033[0m"
		case $flag in
		TABULA_RASA)
			if [[ "$TABULA_RASA" == true || (($TABULA_RASA -gt 1)) ]]; then
				return
			fi
			;;
		HARD_RESET)
			export -U
			;;
		DEBUG_LEVEL)
			if [[ "$DEBUG_LEVEL" > 0 ]]; then
				echo "ZSH DEBUG_LEVEL: $DEBUG_LEVEL"
			fi
			;;
		esac
	else
	    echo -en "\033[48;2;20;20;20m\033[2m ${flag} \033[0m"
	fi

	echo -n " "
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
alias ai="cd $HOME/src/dinglehopper/agents/codex.d && ls -la; say \"Please select an action to perform from the list of prompts or say \`divide by seven\` and hit enter to begin interactively.\""
echo -e "\033[0m\033[38;2;255;225;0m\033[1m Tip: exec \`nmap\` to scan the network.\033[0m"

export NVM_DIR="$HOME/.config/nvm"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Python sanity check
python -c "import sys; print(sys.executable); print(sys.prefix)" >/dev/null &&
	echo -en "\033[2mpip:\033[0m\033[32m canhaz\033[0m\n" ||
	echo -en "\033[2mpip:\033[0m\033[5m\033[31m cannothaz\!\033[0m\n"

echo -e "\033[48;2;30;30;33m\"When in doubt, use brute force.\"
- Ken Thompson\033[0m";
autoload -Uz compinit
compinit

# if [[ ! -z "$ZSH_DEBUG" ]]; then
#     which compdef
# fi

