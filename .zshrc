# If this zsh session is non‑interactive, exit quietly.
[[ ! -o interactive || "$TABULA_RASA" == (1|true) ]] && return
# Anything after this point runs only for interactive shells.
# … your other prompt customizations …

# Add completions to search path
if [[ ":$FPATH:" != *":/Users/donaldmoore/.config/zsh/completions.d:"* ]]; then
    export FPATH="/Users/donaldmoore/.config/zsh/completions.d:$FPATH";
fi
# export PATH="$PATH:$HOME/.config/nvm"

source $XDG_CONFIG_HOME/zsh/completions.zsh
zmodload zsh/datetime # Use this with $EPOCHREALTIME
setopt extendedglob

DARKNESS="\033[48;2;29;29;32m"
tangerine="%F{#FF3300}"
green="%F{#AABFAA}"
indigo="%F{#5D00FF}"
gray="%F{#EEEEEE}"
lightgreen="%F{#AABFAA}"
jobs="%F{#00D7AF}"
green="%F{#00FF66}"
red="%F{#FF0000}"
yellow="%F{#FFFF00}"
highlighter="%F{#CCFF00}"
white="%F{#FFFFFF}"
# BKGD
bkgd_blk="%K{#000000}"
# UTIL
dim=$'%{\e[2m%}'
reset=$'%{\e[0m%}%f%k%s%b'
RESET="\033[0m"

# print -P "${dim}"

local ZDOTDIR="/Users/donaldmoore/.config/zsh"

[[ ! $(command -v mempurge) ]] && export PATH="$PATH:$HOME/bin"
source /Users/donaldmoore/src/dinglehopper/triage/shed/contrib/zsh/focus-burst.zsh

PATH_1="$(mktemp)";
FPATH_1="$(mktemp)";

TRAPEXIT() {
    /bin/rm -f $PATH_1 $FPATH_1 $PATH_2 $FPATH_2
}

source $ZDOTDIR/variables.zsh 
source $ZDOTDIR/bin.zsh
source "$ZDOTDIR/aliases.zsh" 
source "$ZDOTDIR/history.zsh"

(( ZSH_DEBUG > 0 )) && echo "[ZSH_DEBUG]: [F]PATH Debugger: \$[F]PATH_1"
print -rl -- ${(s.:.)PATH} > $PATH_1
print -rl -- ${(s.:.)FPATH} > $FPATH_1

# --- Homebrew environment ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Get public IP once per session ---
tmpIpFile="$(mktemp)"

# curl -fsS --max-time 5 ifconfig.me >"${tmpIpFile}"
echo " 71.45.102.76" > "${tmpIpFile}"

# --- Prompt setup ---
setopt PROMPT_SUBST

# Dynamic prompt
# setopt PROMPT_SUBST;

ip="$(cat $tmpIpFile)"

export PS1='%B  𓃠  [pid:$$] %(?..%F{red}[exit:%?]%f) %(1j.${jobs}[jobs:%j]%f.) %S $ip ${dim}%s${reset}
%B${highlighter} %S %n@%M ${dim}%s${reset}
%B${green}  %S $(basename $SHELL) %~ ${dim}%s 
${reset}${white}󱚞${dim}   ${reset} '

blinky="%F{#FF0000}"
clyde="%F{#FEB945}"
inky="%F{#02FFDF}"
pinky="%F{#FEB9DF}"
export RPROMPT="${yellow}󰮯${red} · · · · ${blinky}󱙝 ${clyde}󱙝 ${inky}󱙝 ${pinky}󱙝${reset} "
Export="/Users/donaldmoore/src"
export DINGLEHOPPER="$SRC/dinglehopper"
export TRIAGE="$DINGLEHOPPER/triage"
# export CRATES="/Users/donaldmoore/src/dinglehopper/triage"
# alias grep="rg -p"

export PATH="$PATH:$HOME/secret/top"

if [ ! "$COLUMNS" -ge 35 ]; then
	echo -en '\033[5m\033[1m\033[38;2;222;173;237m'
	echo "[insert banner here]"
	echo -en "\033[0m"
fi

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export XDG_DATA_HOME="$HOME/.local/share"
# export YARN_DATA_FOLDER="${YARN_DATA_FOLDER:-$XDG_CACHE_HOME/yarn}" # deprecated
export YARN_CACHE_FOLDER="${YARN_CACHE_HOME:-$XDG_CACHE_HOME}/yarn"
export PATH="$XDG_DATA_HOME/yarn/global/bin:$PATH"
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

source "$ZDOTDIR/tmp-alias.zsh"
