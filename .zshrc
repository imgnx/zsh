# If this zsh session is non‑interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == "1|true" ]] && return
# Anything after this point runs only for interactive shells.
# … your other prompt customizations …

if [[ ! "$PATH" =~ "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Add completions to search path
if [[ ":$FPATH:" != *":/Users/donaldmoore/.config/zsh/completions.d:"* ]]; then
    export FPATH="/Users/donaldmoore/.config/zsh/completions.d:$FPATH"
fi
# export PATH="$PATH:$HOME/.config/nvm"

source $XDG_CONFIG_HOME/zsh/completions.zsh
zmodload zsh/datetime # Use this with $EPOCHREALTIME
setopt extendedglob

# --- Homebrew environment ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# Contrast
export DARKNESS="\033[48;2;29;29;32m"


# Colorful
export TANGERINE="%F{#FF3300}"
export GREEN="%F{#AABFAA}"
export INDIGO="%F{#5D00FF}"
export JOBS="%F{#00D7AF}"
export LIME="%F{#00FF66}"
export RED="%F{#FF0000}"
export YELLOW="%F{#FFFF00}"

# Neutral
export NEUTRAL1="%F{#000000}"
export NEUTRAL2="%F{#111111}"
export NEUTRAL3="%F{#222222}"
export NEUTRAL4="%F{#333333}"
export NEUTRAL5="%F{#444444}"
export NEUTRAL6="%F{#555555}"
export NEUTRAL7="%F{#666666}"
export NEUTRAL8="%F{#777777}"
export NEUTRAL9="%F{#888888}"
export NEUTRAL10="%F{#999999}"
export NEUTRAL11="%F{#AAAAAA}"
export NEUTRAL12="%F{#BBBBBB}"
export NEUTRAL13="%F{#CCCCCC}"
export NEUTRAL14="%F{#DDDDDD}"
export NEUTRAL15="%F{#EEEEEE}"
export NEUTRAL16="%F{#FFFFFF}"
export FG_WHITE="$NEUTRAL14"
export FG_GRAY="$NEUTRAL8"
export FG_DARK="%F{#202020}"
export BG_DARK="%K{#202020}"

# Background
export BG_BLACK="%K{#000000}"
export BG_WHITE="%K{#FFFFFF}"

# Utilities
DIM=$'%{\e[2m%}'

# export RESET_ANSI=$'%{\e[0m%}'
export RESET_ZSH=$'%{\e[0m%}%f%k%s%b'
export RESET_FG=$'%{\e[39m%}'
export RESET_BG=$'%{\e[49m%}'

# alias R1="$RESET_ANSI"
alias R2="$RESET_ZSH"

export RESET="${RESET_ZSH}"

# print -P "${dim}"

local ZDOTDIR="/Users/donaldmoore/.config/zsh"

[[ ! $(command -v mempurge) ]] && export PATH="$PATH:$HOME/bin"
source /Users/donaldmoore/src/dinglehopper/triage/shed/contrib/zsh/focus-burst.zsh

PATH_1="$(mktemp)"
FPATH_1="$(mktemp)"

TRAPEXIT() {
    /bin/rm -f $PATH_1 $FPATH_1 $PATH_2 $FPATH_2
}

source $ZDOTDIR/variables.zsh
source $ZDOTDIR/bin.zsh
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/history.zsh"

((ZSH_DEBUG > 0)) && echo "[ZSH_DEBUG]: [F]PATH Debugger: \$[F]PATH_1"
# print -rl -- ${(s.:.)PATH} > $PATH_1
# print -rl -- ${(s.:.)FPATH} > $FPATH_1


# --- Get public IP once per session ---
tmpIpFile="$(mktemp)"

# curl -fsS --max-time 5 ifconfig.me >"${tmpIpFile}"
export IP="$(echo ' 71.45.102.76' | tee $tmpIpFile)"

setopt PROMPT_SUBST

# ~/.themefile format:
#   COLOR=#RRGGBB
#   NAMESPACE=whatever
#   PROMPT=...optional...

THEMEFILE() { echo "$(realpath "$PWD")/.themefile" }

is_hex() {
  local c="$1"
  c="${c#\#}"                 # strip leading '#'
  [[ "$c" =~ '^[0-9A-Fa-f]{6}$' || "$c" =~ '^[0-9A-Fa-f]{3}$' ]]
}

normalize_hex() {
  local c="$1"
  c="${c#\#}"
  # if 3-digit, expand to 6-digit
  if [[ ${#c} -eq 3 ]]; then
    c="${c[1]}${c[1]}${c[2]}${c[2]}${c[3]}${c[3]}"
  fi
  echo "#${c:u}"              # uppercase
}

apply_theme_vars() {
  export COLOR_VAR="$1"
  export FG_VAR="%F{$COLOR_VAR}"
  export BG_VAR="%K{$COLOR_VAR}"
}

PROMPT_COLOR() {
  local input="$1"
  while true; do
    if [[ -z "$input" ]]; then
      echo -n "Insert Hex (#RRGGBB or RRGGBB): "
      read -r input
      [[ -z "$input" ]] && { echo "No input."; return 1; }
    fi

    if is_hex "$input"; then
      local newcolor
      newcolor="$(normalize_hex "$input")"
      apply_theme_vars "$newcolor"
      return 0
    fi

    echo $'%F{yellow}Invalid hex color.%f  Example: #1A2B3C'
    input=""   # force reprompt
  done
}
alias PC=PROMPT_COLOR

NAMESPACE() {
  export NAMESPACE="$*"
}
alias NS=NAMESPACE

save_themefile() {
  local file; file="$(THEMEFILE)"
  : >| "$file" || return 1
  {
    print -r -- "COLOR=$COLOR_VAR"
    print -r -- "NAMESPACE=$NAMESPACE"
    [[ -n "$PROMPT_TEMPLATE" ]] && print -r -- "PROMPT_TEMPLATE=$PROMPT_TEMPLATE"
  } >> "$file"
}

load_themefile() {
  local file; file="$(THEMEFILE)"
  [[ -f "$file" ]] || return 0

  local line key val
  while IFS='=' read -r key val; do
    [[ -z "$key" ]] && continue
    case "$key" in
      (COLOR)          COLOR_VAR="$val" ;;
      (NAMESPACE)      NAMESPACE="$val" ;;
      (PROMPT_TEMPLATE) PROMPT_TEMPLATE="$val" ;;
    esac
  done < "$file"

  [[ -n "$COLOR_VAR" ]] && apply_theme_vars "$COLOR_VAR"
}

THEME() {
  local color="$1"
  shift
  local ns="$*"

  if [[ -z "$color" || -z "$ns" ]]; then
    echo "Usage: THEME <hex-color> <namespace>"
    return 1
  fi

  PROMPT_COLOR "$color" || return 1
  NAMESPACE "$ns"
  save_themefile

  echo $'%F{yellow}Use at your own risk.%f'
}

# Optional: let user edit prompt/theme file directly
THEMEEDIT() {
  local file; file="$(THEMEFILE)"
  touch "$file"
  ${EDITOR:-vi} "$file"
  load_themefile
}

rHex() {
    echo "$(printf '#%06x' $(( RANDOM % 0xFFFFFF )))"
}

export COLOR_VAR="$(rHex)"
export BG_VAR="%K{$COLOR_VAR}"
export FG_VAR="%F{$COLOR_VAR}"

export NAMESPACE="${SESSION_NAME:-$(basename $PWD)}"

# Set Prompt Color
PROMPT_COLOR() {
    if [[ -z $1 ]]; then
	echo -en "Insert Hex: #";
	read -r RES;
	NEWCOLOR="#${RES}"
    else
	NEWCOLOR="$1"
    fi

    if [[ ! "$NEWCOLOR" =~ '^#?([a-fA-F0-9]{6}|[a-f0-9A-F]{3})$' ]]; then
	echo -en "\033[33mInvalid hex color!\033[0m"
	PROMPT_COLOR
	return 1
    else
	export COLOR_VAR="$NEWCOLOR"
	export FG_VAR="%F{$COLOR_VAR}"
	export BG_VAR="%K{$COLOR_VAR}"
	return 0
    fi
}
alias PC=PROMPT_COLOR
# Set Namespace
NAMESPACE() {
    NAMESPACE="$@";
}
alias NS=NAMESPACE
# Multi-Setter
THEME() {
    if [[ -z "$1" || -z "$2" ]]; then
	echo "Usage: THEME <hex-color> <namespace>"
	return 1
    fi

    THEMEFILE="$(realpath $PWD)/.themefile"
    touch "$THEMEFILE"
    cat "$@" > "$THEMEFILE"
    PROMPT_COLOR "$1"
    NAMESPACE "$2"
    echo -en "\033[33mUse at your own risk.\033[0m"
}

export PS1=' 𓃠  %B[pid:$$] %(?..%F{RED}[exit:%?]%f) %(1j.\${JOBS}[jobs:%j]%f.)${FG_DK}%S $IP ${DIM}%s${RESET_BG}${RESET}
%B${FG_VAR}${DIM}${RESET}${FG_VAR}%S${BG_WHITE}%S %n@%M %s%b${FG_VAR}${RESET_BG}${RESET}
%B ${LIME}%S NS: ${NAMESPACE} %~ ${DIM}%s${RESET_BG}${RESET}
${FG_WHITE}󱚞   ${FG_GRAY} '

BLINKY="%F{#FF0000}"
CLYDE="%F{#FEB945}"
INKY="%F{#02FFDF}"
PINKY="%F{#FEB9DF}"
export RPROMPT="${YELLOW}󰮯${RED} · · · · ${BLINKY}󱙝 ${CLYDE}󱙝 ${INKY}󱙝 ${PINKY}󱙝${RESET} "
Export="/Users/donaldmoore/src"
export DINGLEHOPPER="$SRC/dinglehopper"
export TRIAGE="$DINGLEHOPPER/triage"
# export CRATES="/Users/donaldmoore/src/dinglehopper/triage"
# alias grep="rg -p"

if [ ! "$COLUMNS" -ge 35 ]; then
    echo -en '\033[5m\033[1m\033[38;2;222;173;237m'
    echo "[insert banner here]"
    echo -en "\033[0m"
fi

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

export OPEN_JDK_PATH="/opt/homebrew/opt/openjdk@21/bin"

if [[ ! $PATH == "*$OPEN_JDK_PATH*" ]]; then
    export PATH="$OPEN_JDK_PATH:$PATH"
fi


export XDG_DATA_HOME="$HOME/.local/share"
export YARN_CACHE_FOLDER="${YARN_CACHE_HOME:-$XDG_CACHE_HOME}/yarn"

export HISTFILE="$HOME/.local/state/zsh/history"
export LESSHISTFILE="$HOME/.config/less/history"
export PYTHONHISTFILE="$HOME/.config/python/history"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
export PRETTIERD_DEFAULT_CONFIG="$HOME/.config/prettier/config"

if [ -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" ]; then
    source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# export cpp=="cd /Users/donaldmoore/src/dinglehopper/triage/cpp-react-js-webview-blueprint"

source /Users/donaldmoore/src/dinglehopper/triage/tri/tri

export UTILS=/Users/donaldmoore/src/dinglehopper/utils
alias utils="cd $UTILS"
export ART=/Users/donaldmoore/Art
alias art="cd $ART"
export PATH="$PATH:/Users/donaldmoore/src/dinglehopper/utils/bin"
export PATH="$PATH:$(realpath /Library/Frameworks/Python.framework/Versions/Current)/bin"
. "/Users/donaldmoore/.config/zsh/hooks.zsh"
plugins=(... dirs)
. "/Users/donaldmoore/.deno/env"

print -P "${reset}"

# ! NEEDS TRIAGE!!! source "$ZDOTDIR/tmp-alias.zsh"

# cleanupPath() {
# 	export PATH="$(bash \"$ZDOTDIR/cleanup.path.sh\")"
# x}

# ADDED to hooks in fn.sh
