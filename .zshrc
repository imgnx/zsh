# If this zsh session is non-interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == "1|true" ]] && return

# Ensure Homebrew
if [[ ! "$PATH" =~ "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Ensure tmux
if ! which tmux >/dev/null; then
    echo -n "tmux is not installed. Install now? (Y/n): "
    read -r -k 1 todo
    case "$todo" in
	[yY])
	    brew install tmux
	    ;;
	[nN]) ;; # no-op
	*)
	    echo -e "\033[33mSkipped tmux installation...\033[0m"
	    ;;
    esac
fi

tmux-toggle() {
    emulate -L zsh
    local s=${TMUX_TOGGLE_SESSION:-main}
    if [[ -n $TMUX ]]; then
	command tmux detach-client
	return
    fi

    if [[ ! -t 0 || ! -t 1 ]]; then
	command tmux new-session -A -s "$s" </dev/tty >/dev/tty 2>/dev/tty
    else
	command tmux new-session -A -s "$s"
    fi
}

zle -N tmux-toggle

if [[ -n ${terminfo[kf12]} ]]; then
    bindkey -M emacs "${terminfo[kf12]}" tmux-toggle
    bindkey -M viins "${terminfo[kf12]}" tmux-toggle
    bindkey -M vicmd "${terminfo[kf12]}" tmux-toggle
else
    bindkey -M emacs $'\e[24~' tmux-toggle
    bindkey -M viins $'\e[24~' tmux-toggle
    bindkey -M vicmd $'\e[24~' tmux-toggle
fi

if [[ "$DISABLE_TMUX" != 1 ]]; then
    #! Launch in `tmux` by default.
    if [[ -z "$TMUX" ]]; then
	# ! Use F12 to open the escape hatch...
	# bind-key -n F12 detach-client

	# Use a consistent name or keep your UUID logic
	SESSION_ID="$(uuidgen)"

	# -d starts it in the background so we can finish the setup
	# -A attaches if it exists; -s names it; -n names the first window
	if ! tmux has-session -t "$SESSION_ID" 2>/dev/null; then
	    # INITIAL SETUP: Only runs if the session is brand new
	    tmux new-session -d -s "$SESSION_ID" -n editor 'emacs'
	    tmux split-pane -t "$SESSION_ID" -h
	    tmux split-pane -t "$SESSION_ID" -v
	    tmux split-pane -t "$SESSION_ID" -v -p 33
	    tmux select-pane -t "$SESSION_ID:0.0"
	    echo "Session ID: $SESSION_ID"
	fi

	# Attach to the session (new or existing)
	tmux attach-session -t "$SESSION_ID"
    fi
fi

# Add completions
if [[ ":$FPATH:" != *":/Users/donaldmoore/.config/zsh/completions.d:"* ]]; then
    export FPATH="/Users/donaldmoore/.config/zsh/completions.d:$FPATH"
fi

source $XDG_CONFIG_HOME/zsh/completions.zsh
zmodload zsh/datetime
zmodload zsh/mapfile
setopt extendedglob
setopt PROMPT_SUBST

# --- Homebrew environment ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Colors ---
export DARKNESS="\033[48;2;29;29;32m"

export TANGERINE="%F{#FF3300}"
export GREEN="%F{#AABFAA}"
export INDIGO="%F{#5D00FF}"
export JOBS="%F{#00D7AF}"
export LIME="%F{#00FF66}"
export RED="%F{#FF0000}"
export YELLOW="%F{#FFFF00}"

export NEUTRAL14="%F{#DDDDDD}"
export NEUTRAL8="%F{#777777}"
export FG_WHITE="$NEUTRAL14"
export FG_GRAY="$NEUTRAL8"
export FG_DARK="%F{#202020}"

export BG_BLACK="%K{#000000}"
export BG_WHITE="%K{#FFFFFF}"
export BG_DARK="%K{#202020}"

DIM=$'%{\e[2m%}'
export RESET_ZSH=$'%{\e[0m%}%f%k%s%b'
export RESET_FG=$'%{\e[39m%}'
export RESET_BG=$'%{\e[49m%}'
export RESET="${RESET_ZSH}"

# --- Paths / utilities ---
local ZDOTDIR="/Users/donaldmoore/.config/zsh"
[[ ! $(command -v mempurge) ]] && export PATH="$PATH:$HOME/bin"

source /Users/donaldmoore/src/dinglehopper/triage/shed/contrib/zsh/focus-burst.zsh
source $ZDOTDIR/variables.zsh
source $ZDOTDIR/bin.zsh
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/history.zsh"

# --- Public IP (cached) ---
tmpIpFile="$(mktemp)"
export IP="$(echo ' 71.45.102.76' | tee $tmpIpFile)"

# ======================================================
# =============== THEME SYSTEM (SINGLE) =================

# ======================================================
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/bin/zsh-themefile"

# ======================================================
# ==================== PROMPT ==========================
# ======================================================

export PS1=' 𓃠  %B[pid:$$] %(?..%F{RED}[exit:%?]%f) %(1j.\${JOBS}[jobs:%j]%f.)${FG_DK}%S $IP ${DIM}%s${RESET_BG}${RESET}
%B${FG_VAR}${DIM}${RESET}${FG_VAR}%S${BG_WHITE}%S %n@%M %s%b${FG_VAR}${RESET_BG}${RESET}
%B ${LIME}%S NS: ${NAMESPACE} | %2~ ${DIM}%s${RESET_BG}${RESET}
${FG_WHITE}󱚞   ${FG_GRAY} '

BLINKY="%F{#FF0000}"
CLYDE="%F{#FEB945}"
INKY="%F{#02FFDF}"
PINKY="%F{#FEB9DF}"

export RPROMPT="SET ROLL INIT ... _THEME ${YELLOW}󰮯${RED} · · · · ${BLINKY}󱙝 ${CLYDE}󱙝 ${INKY}󱙝 ${PINKY}󱙝${RESET}"

# ======================================================
# ===================== ENV ============================
# ======================================================

export SRC="/Users/donaldmoore/src"
export DINGLEHOPPER="$SRC/dinglehopper"
export TRIAGE="$DINGLEHOPPER/triage"

export XDG_DATA_HOME="$HOME/.local/share"
export HISTFILE="$HOME/.local/state/zsh/history"
export LESSHISTFILE="$HOME/.config/less/history"
export PYTHONHISTFILE="$HOME/.config/python/history"

export OPEN_JDK_PATH="/opt/homebrew/opt/openjdk@21/bin"
[[ "$PATH" != *"$OPEN_JDK_PATH"* ]] && export PATH="$OPEN_JDK_PATH:$PATH"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
[ -f "$ZDOTDIR/.iterm2_shell_integration.zsh" ] && source "$ZDOTDIR/.iterm2_shell_integration.zsh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

source /Users/donaldmoore/src/dinglehopper/triage/tri/tri
source "/Users/donaldmoore/.config/zsh/hooks.zsh"
. "/Users/donaldmoore/.deno/env"

print -P "${RESET}"

# reset-widget() {
#   reset
#   zle -I
#   zle reset-prompt
# }

# zle -N reset-widget
# bindkey '^R' reset-widget

# bindkey -s '^e' 'emacs\n'

if [[ ":$PATH:" != *":$DINGLEHOPPER/utils:"* ]]; then
    export PATH="$PATH:$DINGLEHOPPER/utils"
fi
