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
tempfile="$(mktemp -t pubip.XXXXXX)"

fetch_public_ip() {
  {
    curl -fsS --max-time 5 ifconfig.me >| "$tempfile" || printf '' >| "$tempfile"
  } &!
}

ip() {
  [[ -s "$tempfile" ]] || fetch_public_ip
  if [[ -s "$tempfile" ]]; then
    cat "$tempfile"
  else
    echo "fetching..."
  fi
}

fetch_public_ip
echo -e "\n🌐 Public IP: $(ip)"

# --- Prompt setup ---
setopt PROMPT_SUBST

# Colors
tangerine="%F{#FF3300}"
green="%F{#AABFAA}"
indigo="%F{#5D00FF}"
gray="%F{#EEEEEE}"
green="%F{#AABFAA}"
white="%F{#FFFFFF}"
reset="%f%k%s"

# Dynamic prompt
setopt PROMPT_SUBST; 

export PS1='[pid:$$] %(?..%F{red}[exit:%?]%f) %(1j.%F{#00D7AF}[jobs:%j]%f.) %~ $(cat "$tempfile" 2>/dev/null) 
%F{#00FF66}%K{#000000}%S%n%F{#000000}%K{#00FF66}@%M%k%s%f${reset}'

# --- Optional cleanup trap on exit ---
# (Uncomment if you want to remove tempfile when you close shell)
TRAPEXIT() { rm -f "$tempfile"; }





export SRC="/Users/donaldmoore/src"
export DINGLEHOPPER="$SRC/dinglehopper"
export TRIAGE="$DINGLEHOPPER/triage"
# export CRATES="/Users/donaldmoore/src/dinglehopper/triage"
# alias grep="rg -p"

export PATH="$PATH:$HOME/secret/top"




if [ "$COLUMNS" -ge 86 ]; then
    # lolcat -S 50 "$XDG_CONFIG_HOME/zsh/banner.txt"
    lolcat -p 3 -F 0.05 "$XDG_CONFIG_HOME/zsh/banner.txt" || cat "$XDG_CONFIG_HOME/zsh/banner.txt"
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
        rm -f "$VENVAUTO_FILE"
        echo "Cleared all venv auto-activation decisions."
    fi
}

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
