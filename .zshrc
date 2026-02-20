# If this zsh session is non-interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == "1|true" ]] && return

export warn="\033[38;2;255;205;0m"
source /Users/donaldmoore/.config/zsh/variables.zsh

export DEBUG_PATH="0"


# Already done early on in .zshenv
# eval "$(/opt/homebrew/bin/brew shellenv)"

# 1. Prevent duplicate entries in your PATH
typeset -U path

# 2. Add your local bin to the FRONT of the array
path=(
    /opt/homebrew/bin
    /Users/donaldmoore/.local/bin
    /Users/donaldmoore/bin # mempurge
    /Users/donaldmoore/src/dinglehopper/bin
    /opt/homebrew/opt/openjdk@21/bin
    $path
)

# 3. Export it (Zsh automatically syncs 'path' array and 'PATH' string)
export PATH


# Ensure Homebrew
# if [[ ! "$PATH" =~ "/opt/homebrew/bin" ]]; then
#     export PATH="/opt/homebrew/bin:$PATH"
#     if [[ $DEBUG_PATH == "1" ]]; then
# 	echo "Brew was not on the path..."
#     fi

# fi

# if [[ ! "$PATH" =~ "$HOME/.local/bin" ]]; then
#     export PATH="$HOME/.local/bin:$PATH"
#     if [[ $DEBUG_PATH == "1" ]]; then
# 	echo "\~/.local/bin was not on the path..."
#     fi
# fi



if [[ $DEBUG_PATH == "1" ]]; then
    echo "PATH: $PATH"
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

    cd "/Users/donaldmoore/Music/When The Going Gets Tough, The Tough Get Going."


    # Ensure the prompt returns to a clean state
    zle reset-prompt
}

zle -N launch_tmux
# Using \033 for the escape prefix as requested
bindkey '\033[24~' launch_tmux

is_vscode_term() {
    [[ "$TERM_PROGRAM" == "vscode" || -n "${VSCODE_PID:-}" || -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]
}


emacs() {
    # In VS Code integrated terminal, prefer emacsclient so you reuse your existing frame/server.
    if is_vscode_term; then
	command emacsclient
	open -a "Terminal"
	return $?
    fi

    # Somehow allows emacs to open multiple files... 1/18/26
    # Your original logic: if interactive but stdin is piped, attach stdin to tty
    if [[ -o interactive && ! -t 0 && -t 1 && "$*" != *"--batch"* && "$*" != *"-batch"* && "$*" != *"--script"* ]]; then
	command emacs "$@" </dev/tty
    else
	command emacs "$@"
    fi
}

if [[ "$DISABLE_TMUX" != 1 ]]; then
    #! Launch in `tmux` by default.

    if is_vscode_term; then
	echo -e "\033[38;2;255;205;0mzsh is starting in a VS Code Integrated Terminal.\033[0m This means..."
	echo
	echo "1. It will not launch in \`tmux\` by default."
	echo "2. Running \`emacs\` will open the \`emacsclient\`."
    else



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
export FG_THEME_TEXT="$FG_WHITE"

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

source /Users/donaldmoore/src/dinglehopper/triage/shed/contrib/zsh/focus-burst.zsh
source "$ZDOTDIR/fn.sh"
eza() { command eza --icons "$@"; }
fn.sh() {
    emacs $XDG_CONFIG_HOME/zsh/fn.sh
}
unalias eza 2>/dev/null
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/history.zsh"

# --- Public IP (cached) ---
tmpIpFile="$(mktemp)"
export IP="$(echo ' 71.45.102.76' | tee $tmpIpFile)"

# ======================================================
# =============== THEME SYSTEM (SINGLE) =================

# ======================================================
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/bin/zsh-themefile"

# If THEME_COLOR already exists (from external source), sync derived vars now.
[[ -n "${THEME_COLOR:-${COLOR_VAR:-}}" ]] && apply_theme_vars "${THEME_COLOR:-$COLOR_VAR}"

# ======================================================
# ==================== PROMPT ==========================
# ======================================================

export PS1='
 𓃠  %B[pid:$$] %(?..%F{RED}[exit:%?]%f) %(1j.\${JOBS}[jobs:%j]%f.)${FG_DARK}%S $IP ${DIM}%s${RESET_BG}${RESET}
${RESET}${FG_VAR}${DIM}${RESET}${BG_VAR}${FG_THEME_TEXT}%B %n@%M ${FG_VAR}${RESET_BG}${RESET}
%B ${LIME}%S $( [[ -n "$NAMESPACE" ]] && print -r -- "NS: $NAMESPACE" || print -r -- "%2~" ) ${DIM}%s${RESET_BG}${RESET}
${FG_WHITE}󱚞   ${FG_GRAY} '


autoload -Uz add-zle-hook-widget

ghost_realpath_placeholder() {
    if [[ -z $BUFFER ]]; then
	POSTDISPLAY="$(pwd -P)"
    else
	POSTDISPLAY=""
    fi
}

add-zle-hook-widget zle-line-init ghost_realpath_placeholder
add-zle-hook-widget zle-line-pre-redraw ghost_realpath_placeholder

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
export MODULES="$DINGLEHOPPER/modules"
export TRIAGE="$DINGLEHOPPER/triage"

export XDG_DATA_HOME="$HOME/.local/share"
export HISTFILE="$HOME/.local/state/zsh/history"
export LESSHISTFILE="$HOME/.config/less/history"
export PYTHONHISTFILE="$HOME/.config/python/history"

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

# bun completions
[ -s "/Users/donaldmoore/.bun/_bun" ] && source "/Users/donaldmoore/.bun/_bun"

bindkey "\033[3;5~" kill-word


cnf() {
    if [[ -d "$XDG_CONFIG_HOME/$1" ]]; then
	cd $XDG_CONFIG_HOME/$1
    elif [[ -f "$XDG_CONFIG_HOME/$1" ]]; then
	$EDITOR "$XDG_CONFIG_HOME/$1"
    else
	echo -e "\033[38;2;255;205;0mWarning: \033[0m$1 not found"
	cd $XDG_CONFIG_HOME
	echo -e "\033[38;2;255;205;0mWarning: \033[0m$1 not found"
    fi
}

mods() {
    local base="${MODULES:-$HOME/src}/BARE"
    local target="$1"
    if [[ -z "$target" ]]; then
	cd "$base"
	return
    fi

    if [[ -d "$base/$target" ]]; then
	cd "$base/$target"
    elif [[ -f "$base/$target" ]]; then
	${EDITOR:-vi} "$base/$target"
    else
	echo -e "\033[38;2;255;205;0mWarning: \033[0m$target not found"
	cd "$base"
    fi
}


eval "$(direnv hook zsh)"
