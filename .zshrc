# If this zsh session is non-interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == "1|true" ]] && return

# Ensure Homebrew
if [[ ! "$PATH" =~ "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Add completions
if [[ ":$FPATH:" != *":/Users/donaldmoore/.config/zsh/completions.d:"* ]]; then
    export FPATH="/Users/donaldmoore/.config/zsh/completions.d:$FPATH"
fi

source $XDG_CONFIG_HOME/zsh/completions.zsh
zmodload zsh/datetime
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

THEMEFILE() { echo "$(realpath "$PWD")/.themefile" }

rHex() {
  printf '#%06X\n' $((RANDOM % 0xFFFFFF))
}

is_hex() {
  local c="${1#\#}"
  [[ "$c" =~ ^[0-9A-Fa-f]{6}$ || "$c" =~ ^[0-9A-Fa-f]{3}$ ]]
}

normalize_hex() {
  local c="${1#\#}"
  if [[ ${#c} -eq 3 ]]; then
    c="${c[1]}${c[1]}${c[2]}${c[2]}${c[3]}${c[3]}"
  fi
  echo "#${c:u}"
}

apply_theme_vars() {
  export COLOR_VAR="$1"
  export FG_VAR="%F{$COLOR_VAR}"
  export BG_VAR="%K{$COLOR_VAR}"
}

PROMPT_COLOR() {
  local input="$1"
  while true; do
    [[ -z "$input" ]] && { echo -n "Insert Hex (#RRGGBB): "; read -r input; }
    is_hex "$input" || { echo $'%F{yellow}Invalid hex color.%f'; input=""; continue; }
    apply_theme_vars "$(normalize_hex "$input")"
    return 0
  done
}
alias PC=PROMPT_COLOR

NAMESPACE() { export NAMESPACE="$*"; }
alias NS=NAMESPACE

save_themefile() {
  local file="$(THEMEFILE)"
  {
    echo "COLOR=$COLOR_VAR"
    echo "NAMESPACE=$NAMESPACE"
  } >| "$file"
}

load_themefile() {
  local file="$(THEMEFILE)"
  [[ -f "$file" ]] || return 0
  while IFS='=' read -r k v; do
    case "$k" in
      COLOR) apply_theme_vars "$v" ;;
      NAMESPACE) export NAMESPACE="$v" ;;
    esac
  done < "$file"
}

THEME() {
  PROMPT_COLOR "$1" || return 1
  shift
  NAMESPACE "$*"
  save_themefile
  echo $'%F{yellow}Use at your own risk.%f'
}

THEMEEDIT() {
  local f="$(THEMEFILE)"
  touch "$f"
  ${EDITOR:-vi} "$f"
  load_themefile
}

# Defaults
export NAMESPACE="${SESSION_NAME:-$(basename "$PWD")}"
apply_theme_vars "${COLOR_VAR:-$(rHex)}"
load_themefile

# ======================================================
# ==================== PROMPT ==========================
# ======================================================


export PS1=' 𓃠  %B[pid:$$] %(?..%F{RED}[exit:%?]%f) %(1j.\${JOBS}[jobs:%j]%f.)${FG_DK}%S $IP ${DIM}%s${RESET_BG}${RESET}
%B${FG_VAR}${DIM}${RESET}${FG_VAR}%S${BG_WHITE}%S %n@%M %s%b${FG_VAR}${RESET_BG}${RESET}
%B ${LIME}%S NS: ${NAMESPACE} %~ ${DIM}%s${RESET_BG}${RESET}
${FG_WHITE}󱚞   ${FG_GRAY} '

BLINKY="%F{#FF0000}"
CLYDE="%F{#FEB945}"
INKY="%F{#02FFDF}"
PINKY="%F{#FEB9DF}"

export RPROMPT="${YELLOW}󰮯${RED} · · · · ${BLINKY}󱙝 ${CLYDE}󱙝 ${INKY}󱙝 ${PINKY}󱙝${RESET}"

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

