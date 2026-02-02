# If this zsh session is non-interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == "1|true" ]] && return

# Ensure Homebrew
if [[ ! "$PATH" =~ "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

source $XDG_CONFIG_HOME/zsh/bin/zsh-delayed-script-loader

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
	command tmux new-session -A -s "$s"
	
    else
	command tmux -d -t "$TMUX_SESSION_ID" || command tmux new-session -A -s "$s"
    fi
}

zle -N tmux-toggle

texas() {
    # -d starts it in the background so we can finish the setup
    # -A attaches if it exists; -s names it; -n names the first window
    if ! tmux has-session -t "$TMUX_SESSION_ID" 2>/dev/null; then
	# INITIAL SETUP: Only runs if the session is brand new
	tmux new-session -d -s "$TMUX_SESSION_ID" -n editor 'emacs'
	tmux split-pane -t "$TMUX_SESSION_ID" -h
	tmux split-pane -t "$TMUX_SESSION_ID" -v
	tmux split-pane -t "$TMUX_SESSION_ID" -v -p 33
	tmux select-pane -t "$TMUX_SESSION_ID:0.0"
	echo "Session ID: $TMUX_SESSION_ID"
    fi
}

if [[ -n ${terminfo[kf12]} ]]; then
    bindkey -M emacs "${terminfo[kf12]}" tmux-toggle
    bindkey -M viins "${terminfo[kf12]}" tmux-toggle
    bindkey -M vicmd "${terminfo[kf12]}" tmux-toggle
else
    bindkey -M emacs $'\e[24~' tmux-toggle
    bindkey -M viins $'\e[24~' tmux-toggle
    bindkey -M vicmd $'\e[24~' tmux-toggle
fi



###
### This is the counterpart to the configuration in `tmux` that handles closing `tmux` from F12.
### If you delete it, I will fire you.
###


# Improved tmux launch function for Zsh widgets
launch_tmux() {
  # Forces all file descriptors back to the current TTY
  # We use TMUX="" to prevent nested sessions if you're already in one
  ( exec < /dev/tty > /dev/tty 2>&1; TMUX="" tmux attach || tmux new-session )
  
  # Ensure the prompt returns to a clean state
  zle reset-prompt
}

zle -N launch_tmux
# Using \033 for the escape prefix as requested
bindkey '\033[24~' launch_tmux

if [[ "$DISABLE_TMUX" != 1 ]]; then
    #! Launch in `tmux` by default.
    if [[ -z "$TMUX" ]]; then
	# ! Use F12 to open the escape hatch...
	# bind-key -n F12 detach-client

	# Use a consistent name or keep your UUID logic
	SESSION_ID="$(uuidgen)"
	tmux new-session -d -s "$SESSION_ID"
	# Attach to the session (new or existing)
	tmux attach-session -t "$SESSION_ID"
	export TMUX_SESSION_ID="$SESSION_ID"
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

export DIM=$'%{\e[2m%}'
export RESET_ZSH=$'%{\e[0m%}%f%k%s%b'
export RESET_FG=$'%{\e[39m%}'
export RESET_BG=$'%{\e[49m%}'
export STANDOUT=$'%{\e[7m%}'
export BLINK=$'%{\e[5m%}'
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
              
export PS1='
▄ ██╗▄  𓃠  %B[pid:$$] %(?..%F{RED}[exit:%?]%f) %(1j.\${JOBS}[jobs:%j]%f.)${FG_DK}%S $IP ${DIM}%s${RESET_BG}${RESET}
 ████╗ ${RESET}${FG_VAR}${DIM}${RESET}${BG_VAR}${FG_WHITE}%B %n@%M ${FG_VAR}${RESET_BG}${RESET}
▀╚██╔▀ %B ${LIME}%S $( [[ -n "$NAMESPACE" ]] && print -r -- "NS: $NAMESPACE" || print -r -- "%2~" ) ${DIM}%s${RESET_BG}${RESET}
  ╚═╝  ${FG_WHITE}󱚞   ${FG_GRAY} '


ghost_realpath_placeholder() {
  if [[ -z "$BUFFER" ]]; then
      POSTDISPLAY=$"$(pwd -P)"
  else
      POSTDISPLAY=""
  fi
}

# Register the function as a ZLE widget
zle -N ghost_realpath_placeholder

# Hook the widget into the Zsh line editor
# 'self-insert' handles standard typing
# 'backward-delete-char' handles backspacing back to empty
add-zsh-hook_ghost() {
  zle -N self-insert ghost_self_insert
  zle -N backward-delete-char ghost_backward_delete
}

ghost_self_insert() {
  zle .self-insert
  ghost_realpath_placeholder
}

ghost_backward_delete() {
  zle .backward-delete-char
  ghost_realpath_placeholder
}

# Initial call to show it on a fresh prompt
zle -N zle-line-init ghost_realpath_placeholder

# autoload -Uz add-zle-hook-widget
# add-zle-hook-widget line-pre-redraw _update_realpath_placeholder

VIOLET="%F{#880088}"
MAGENTA="%F{#FF00FF}"

BLINKY="%F{#FF0000}"
CLYDE="%F{#FEB945}"
INKY="%F{#02FFDF}"
PINKY="%F{#FEB9DF}"

export RPROMPT="${VIOLET}Powered by εmacs${RESET} ${YELLOW}󰮯 ${MAGENTA}· ${RED}· · · · · ${BLINKY}󱙝 ${CLYDE}󱙝 ${INKY}󱙝 ${PINKY}󱙝${RESET}"

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
    export PATH="$PATH:$DINGLEHOPPER/bin"
fi

# bun completions
[ -s "/Users/donaldmoore/.bun/_bun" ] && source "/Users/donaldmoore/.bun/_bun"

bindkey "\033[3;5~" kill-word

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Somehow allows emacs to open multiple files... 1/18/25
emacs() {
  if [[ -o interactive && ! -t 0 && -t 1 && "$*" != *"--batch"* && "$*" != *"-batch"* && "$*" != *"--script"* ]]; then
    command emacs "$@" </dev/tty
  else
    command emacs "$@"
  fi
}

fn.sh() {
    emacs $XDG_CONFIG_HOME/zsh/fn.sh
}

alias fn="fn.sh \"$@\""
