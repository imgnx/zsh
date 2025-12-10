
# TEXT
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

print -P "${dim}"
# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/donaldmoore/.config/zsh/completions:"* ]]; then export FPATH="/Users/donaldmoore/.config/zsh/completions:$FPATH"; fi
# If this zsh session is non‑interactive, exit quietly.
[[ -o interactive ]] || return

# Anything after this point runs only for interactive shells.
# echo "Expectations are pre‑meditated resentments"
# … your other prompt customizations …

# export PATH="$PATH:$HOME/.config/nvm"
source $HOME/.config/zsh/variables.zsh
source $XDG_CONFIG_HOME/zsh/functions.zsh
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"
# . /Users/donaldmoore/src/dinglehopper/triage/shed/contrib/zsh/focus-burst.zsh
# . "$XDG_CONFIG_HOME/zsh/.zshenv"
# . "$XDG_CONFIG_HOME/zsh/history.zsh"
# source "$XDG_CONFIG_HOME/zsh/.zshrc"
[[ ! $(command -v mempurge) ]] && export PATH="$PATH:$HOME/bin"

# --- Homebrew environment ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Get public IP once per session ---
tmpIpFile="$(mktemp)";

curl -fsS --max-time 5 ifconfig.me > "${tmpIpFile}"

# --- Prompt setup ---
setopt PROMPT_SUBST

# Dynamic prompt
# setopt PROMPT_SUBST;

ip="$(cat $tmpIpFile)"

export PS1='%B  𓃠  [pid:$$] %(?..%F{red}[exit:%?]%f) %(1j.${jobs}[jobs:%j]%f.) %S $ip ${dim}%s${reset}
%B${highlighter} %S %n@%M ${dim}%s${reset}
%B${green}  %S %~ ${dim}%s 
${reset}${white}󱚞${dim}   ${reset} ';

blinky="%F{#FF0000}"
clyde="%F{#FEB945}"
inky="%F{#02FFDF}"
pinky="%F{#FEB9DF}"
export RPROMPT="${yellow}󰮯${red} · · · · ${blinky}󱙝 ${clyde}󱙝 ${inky}󱙝 ${pinky}󱙝 ${reset}"

#                              

# 󱙝 󱚞 󱙜 

# --- Optional cleanup trap on exit ---
# (Uncomment if you want to remove tempfile when you close shell)
TRAPEXIT() { rm -f "$tmpIpFile"; rm -f "$bannerTmp" }
# | Glyph | Unicode | Name                                     |
# | ----- | ------- | ---------------------------------------- |
# | `█`   | U+2588  | Full Block                               |
# | `▓`   | U+2593  | Dark Shade                               |
# | `▒`   | U+2592  | Medium Shade                             |
# | `▒`   | U+2592  | Medium Shade                             |
# | `░`   | U+2591  | Light Shade                              |
# | `▀`   | U+2580  | Upper Half Block                         |
# | `▄`   | U+2584  | Lower Half Block                         |
# | `▌`   | U+258C  | Left Half Block                          |
# | `▐`   | U+2590  | Right Half Block                         |
# | `▖`   | U+2596  | Quadrant Lower Left                      |
# | `▗`   | U+2597  | Quadrant Lower Right                     |
# | `▘`   | U+2598  | Quadrant Upper Left                      |
# | `▝`   | U+259D  | Quadrant Upper Right                     |
# | `▚`   | U+259A  | Quadrant Upper Left/Lower Right          |
# | `▞`   | U+259E  | Quadrant Upper Right/Lower Left          |
# | `▟`   | U+259F  | Quadrant LL + LR + UR (missing UL)       |
# | `▛`   | U+259B  | Quadrant UL + UR + LL (missing LR)       |
# | `▜`   | U+259C  | Quadrant UL + UR + LR (missing LL)       |
# | `▙`   | U+2599  | Quadrant UL + LL + LR (missing UR)       |
# | `╴`   | U+2574  | Box Drawings Light Left                  |
# | `╵`   | U+2575  | Box Drawings Light Up                    |
# | `╶`   | U+2576  | Box Drawings Light Right                 |
# | `╷`   | U+2577  | Box Drawings Light Down                  |
# | `╸`   | U+2578  | Box Drawings Heavy Left                  |
# | `╹`   | U+2579  | Box Drawings Heavy Up                    |
# | `╺`   | U+257A  | Box Drawings Heavy Right                 |
# | `╻`   | U+257B  | Box Drawings Heavy Down                  |
# | `╼`   | U+257C  | Box Drawings Light Left and Heavy Right  |
# | `╽`   | U+257D  | Box Drawings Light Up and Heavy Down     |
# | `╾`   | U+257E  | Box Drawings Heavy Left and Light Right  |
# | `╿`   | U+257F  | Box Drawings Heavy Up and Light Down     |
# | `║`   | U+2551  | Double Vertical Line                     |
# | `═`   | U+2550  | Double Horizontal Line                   |
# | `╔`   | U+2554  | Double Top Left Corner                   |
# | `╗`   | U+2557  | Double Top Right Corner                  |
# | `╚`   | U+255A  | Double Bottom Left Corner                |
# | `╝`   | U+255D  | Double Bottom Right Corner               |
# | `╦`   | U+2566  | Double Top T-Intersection                |
# | `╩`   | U+2569  | Double Bottom T-Intersection             |
# | `╠`   | U+2560  | Double Left T-Intersection               |
# | `╣`   | U+2563  | Double Right T-Intersection              |
# | `╬`   | U+256C  | Double Cross Intersection                |
# | `╒`   | U+2552  | Double/Single Top Left Corner            |
# | `╕`   | U+2555  | Double/Single Top Right Corner           |
# | `╘`   | U+2558  | Double/Single Bottom Left                |
# | `╛`   | U+255B  | Double/Single Bottom Right               |
# | `╤`   | U+2564  | Double/Single Top T                      |
# | `╧`   | U+2567  | Double/Single Bottom T                   |
# | `╟`   | U+255F  | Double/Single Left T                     |
# | `╢`   | U+2562  | Double/Single Right T                    |
# | `╪`   | U+256A  | Double/Single Cross                      |
# | `╫`   | U+256B  | Single/Double Cross                      |
# | `┏`   | U+250F  | Top Left Box Corner                      |
# | `┓`   | U+2513  | Top Right Box Corner                     |
# | `┗`   | U+2517  | Bottom Left Box Corner                   |
# | `┛`   | U+251B  | Bottom Right Box Corner                  |
# | `┝`   | U+252D  | Left Box T-Intersection                  |
# | `┥`   | U+2525  | Right Box T-Intersection                 |
# | `┯`   | U+2530  | Top Box T-Intersection                   |
# | `┷`   | U+2537  | Bottom Box T-Intersection                |
# | `┸`   | U+2538  | Bottom Box T-Intersection                |
# | `┰`   | U+E2520 | Top Box T-Intersection                   |
# | `│`   | U+2502  | Vertical Line                            |
# | `─`   | U+2500  | Horizontal Line                          |
# | `┌`   | U+250C  |                                          |
# | `┐`   | U+2510  | Top Right Corner                         |
# | `└`   | U+2514  | Bottom Left Corner                       |
# | `┘`   | U+2518  | Bottom Right Corner                      |
# | `┬`   | U+252C  | Top T-Intersection                       |
# | `┴`   | U+2534  | Bottom T-Intersection                    |
# | `├`   | U+251C  | Left T-Intersection                      |
# | `┤`   | U+251E  | Right T-Intersection                     |
# | `┼`   | U+253C  | Cross T-Intersection                     |
# | `╲`   | U+2572  | Light Diagonal Upper Left to Lower Right |
# | `╱`   | U+2571  | Light Diagonal Upper Right to Lower Left |
# | `╳`   | U+2573  | Light Diagonal Cross                     |




export SRC="/Users/donaldmoore/src"
export DINGLEHOPPER="$SRC/dinglehopper"
export TRIAGE="$DINGLEHOPPER/triage"
# export CRATES="/Users/donaldmoore/src/dinglehopper/triage"
# alias grep="rg -p"

export PATH="$PATH:$HOME/secret/top"




if [ "$COLUMNS" -ge 35 ]; then
    # lolcat -S 50 "$XDG_CONFIG_HOME/zsh/banner.txt"

    # Without having to load it from functions.zsh
    
    zsh $XDG_CONFIG_HOME/zsh/banner.sh
    # lolcat -p 3 -F 0.05 "$XDG_CONFIG_HOME/zsh/banner.txt" || cat "$XDG_CONFIG_HOME/zsh/banner.txt"
else
	# Set truecolor (RGB: 0-255,0-255,0-255). Adjust numbers to taste.
	echo -en '\033[5m\033[1m\033[38;2;222;173;237m'
	echo "[banner]"
	echo -en "\033[0m"
fi

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env

# Auto-activate per-project .venv if present
autoload -U add-zsh-hook
VENVAUTO_FILE="$HOME/.zsh_venv_auto"

venv_autoactivate() {
    [[ -n "$VIRTUAL_ENV" ]] && return
    local actfile
    actfile=$(find ./ -maxdepth 3 -type f -name "activate" 2>/dev/null | head -n1) || return
    [[ -z "$actfile" ]] && return

    local dir=$(realpath "$(dirname "$actfile")")
    local decision=$(grep "^$dir " "$VENVAUTO_FILE" 2>/dev/null | awk '{print $2}')

    case "$decision" in
        always) source "$actfile"; return ;;
        never)  return ;;
    esac

    echo "Found virtualenv in: $dir"
    echo "Activate? (y)es / (n)o / (a)lways / (N)ever"
    read -k 1 reply
    echo

    case "$reply" in
        y|Y) source "$actfile" ;;
        a|A) echo "$dir always" >>"$VENVAUTO_FILE"; source "$actfile" ;;
        n)   ;;  
        N)   echo "$dir never" >>"$VENVAUTO_FILE" ;;
    esac
}

venvreset() {
    if [[ "$1" == "edit" ]]; then
        ${EDITOR:-nano} "$VENVAUTO_FILE"
    else
        rm`` -f "$VENVAUTO_FILE"
        echo "Cleared all venv auto-activation decisions."
    fi
}



bannerDebouncer() {
    local stampfile="/tmp/taku.banner.last_ts"
    local timestamp last_ts=0

    timestamp=$(date +%s)

    # If we have a previous stamp, read it
    if [[ -f "$stampfile" ]]; then
        read -r last_ts < "$stampfile"
    fi

    echo "DEBUG: delta=$(( timestamp - last_ts ))"

    # Only show banner if more than5 600 seconds (10 min) passed
    if (( timestamp - last_ts > 600 )); then
	banner;
    fi
    # Update last-seen timestamp
    printf '%s\n' "$timestamp" > "$stampfile"


}

__wrap_notice banner
banner() {
    L1="\033[0m\033[38;2;255;255;000m"
    L2="\033[0m\033[38;2;000;209;255m"
    L3="\033[0m\033[38;2;000;255;000m"
    L4="\033[0m\033[38;2;255;000;255m"
    echo -e "$L1   █████ \033[0m █████████████ ██████▌██░  "
    echo -e "$L2   ▀▀███ \033[0m   ███ ██▘█░█████ ███░██░  "
    echo -e "$L3   ▀▀███ \033[0m  ███ █████░██ ███ ██░██░  "
    echo -e "$L4   ▀▀███ \033[0m ███ ███░ █░██ ▝███ ████░  \033[0m"
}
    

add-zsh-hook precmd bannerDebouncer

add-zsh-hook chpwd venv_autoactivate
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export XDG_DATA_HOME="$HOME/.local/share"
#export YARN_DATA_FOLDER="${YARN_DATA_FOLDER:-$XDG_CACHE_HOME/yarn}"
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# export cpp=="cd /Users/donaldmoore/src/dinglehopper/triage/cpp-react-js-webview-blueprint"


compdef _retro_indexes retro
_retro_indexes() { compadd 1 2 3 4 5 6 7 8 9 10 }

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
