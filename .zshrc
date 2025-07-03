# Only print banner if interactive
if [[ -o interactive ]]; then
    echo ""
    print -n -P "[%F{cyan}.zshrc%f]"
fi

if [[ -n "$TABULA_RASA" && "$TABULA_RASA" -eq 1 ]]; then
    echo "Tabula Rasa mode is enabled. No configurations will be loaded."
    return 0
fi

# ==============================
# Emacs Configuration
# ==============================
export DOOMDIR="${DOOMDIR:-$XDG_CONFIG_HOME/doom}"
export EMACS="${EMACS:-$XDG_CONFIG_HOME/emacs/init.el}"
export EMACS_DUMP_FILE="${EMACS_DUMP_FILE:-$XDG_STATE_HOME/emacs/auto-save-list/.emacs.dumper}"
export EMACS_DIR="${EMACS_DIR:-$XDG_CONFIG_HOME/emacs}"
export EMACS_CONFIG_DIR="${EMACS_CONFIG_DIR:-$XDG_CONFIG_HOME/emacs}"
export EMACS_LISP_DIR="${EMACS_LISP_DIR:-$XDG_DATA_HOME/emacs/site-lisp}"
export EMACS_CACHE_DIR="${EMACS_CACHE_DIR:-$XDG_CACHE_HOME/emacs}"
export EMACS_SAVEDIR="${EMACS_SAVEDIR:-$XDG_STATE_HOME/emacs}"
export EMACS_BACKUP_DIR="${EMACS_BACKUP_DIR:-$XDG_STATE_HOME/emacs/backup}"
export EMACS_TRASH_DIR="${EMACS_TRASH_DIR:-$XDG_STATE_HOME/emacs/trash}"
export EMACS_SAVEDIR="${EMACS_SAVEDIR:-$XDG_STATE_HOME/emacs/saves}"

# ==============================
#  XDG Base Directories
# ==============================

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# ==============================
#  Zsh Configuration
# ==============================
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
export ZINIT_HOME="${ZINIT_HOME:-$XDG_CONFIG_HOME/zinit}"
export ZSH="${ZSH:-$XDG_CONFIG_HOME/zsh}"
export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/zsh/cache}"
export ZSH_COMPDUMP="${ZSH_COMPDUMP:-$XDG_CACHE_HOME/zsh/zcompdump}"
export ZSH_LOG_DIR="${ZSH_LOG_DIR:-$XDG_CACHE_HOME/zsh/logs}"
export ZSH_NN_DIR="${ZSH_NN_DIR:-$XDG_CACHE_HOME/zsh/nn}"
export ZSH_PLUGINS_DIR="${ZSH_PLUGINS_DIR:-$ZSH/plugins}"

# Add cargo/bin to PATH if not present

# Resource function: source file then add its base directory to PATH
function resource() {
    local file="$1"
    if [[ -f "$file" ]]; then
        source "$file"
        local basedir=$(dirname "$file")
        add2path "$basedir"
    else
        echo "Resource file '$file' not found."
    fi
}

# Autoload Zsh modules
autoload -Uz colors && colors
autoload -Uz add-zsh-hook

# History settings
HISTFORMAT="%F{blue}%n@%m:%~%f %(!.#.$) %F{green}[%*]%f %F{yellow}%B%?%b%f %F{red}[%?]%f"
HISTFILE="$XDG_STATE_HOME/zsh/zsh_history"
HISTSIZE=5000
SAVEHIST=5000
HISTFILESIZE=5000

# History options for search and behavior
setopt HIST_FIND_NO_DUPS    # Don't show duplicates in history search
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries
setopt HIST_IGNORE_SPACE    # Don't save commands that start with space
setopt HIST_SAVE_NO_DUPS    # Don't write duplicates to history file
setopt HIST_VERIFY          # Show command with history expansion before running
setopt INC_APPEND_HISTORY   # Append to history file immediately
setopt SHARE_HISTORY        # Share history between all sessions
setopt EXTENDED_HISTORY     # Save timestamp and duration

# Key bindings for history search
bindkey '^R' history-incremental-search-backward # Ctrl+R for reverse search
bindkey '^S' history-incremental-search-forward  # Ctrl+S for forward search
bindkey '^P' history-search-backward             # Ctrl+P for previous matching
bindkey '^N' history-search-forward              # Ctrl+N for next matching

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
. "${ZINIT_HOME}/zinit.zsh"

# Cargo and Zsh profile/login
[ -f "$HOME/.config/cargo/env" ] && . "$HOME/.config/cargo/env"

# Local IP address (cached)
if [[ -z "$LOCAL_IP" ]]; then
    LOCAL_IP=$(ipconfig getifaddr en2 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo 127.0.0.1)
fi

# Better prompt with fixed slash and dimmed path
PS1='%F{#444}%n@'$LOCAL_IP'%f:%F{#333}%f  '

# Cache directory setup
CACHE_DIR="$HOME/tmp"
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"
SYSLINE_CACHE="$CACHE_DIR/sysline_cache"
[[ ! -f $SYSLINE_CACHE ]] && touch $SYSLINE_CACHE

# System Information
function 6D078F25_9FBE_4352_A453_71F7947A3B01() {

    local ZSH_COUNT CPU_USAGE RAM
    local mtime
    if [[ "$OSTYPE" == darwin* ]]; then
        mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
    else
        mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
    fi
    [[ ! -d "$HOME/tmp" ]] && mkdir -p "$HOME/tmp"
    [[ ! -f $SYSLINE_CACHE ]] && touch $SYSLINE_CACHE
    CPU_USAGE=$(LANG=C ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f", s}')
    if vm_stat >/dev/null 2>&1; then
        RAM=$(vm_stat | awk "/Pages free/ { printf \"%.1f\", \$3 * 4096 / 1024 / 1024 }")
    else
        RAM=$(free -m | awk "/Mem:/ { printf \"%.1f\", \$4 }")
    fi
    ZSH_COUNT=$(pgrep -c zsh 2>/dev/null || ps -eo comm | grep -c "^zsh")
    if [[ $ZSH_COUNT -gt 30 ]]; then
        CONCURRENT_SHELLS="%K{#FF2000}%F{white} No. ${ZSH_COUNT} %f%k"
    elif [[ $ZSH_COUNT -gt 20 ]]; then
        CONCURRENT_SHELLS="%K{#FF8000}%F{white} No. ${ZSH_COUNT} %f%k"
    elif [[ $ZSH_COUNT -gt 15 ]]; then
        CONCURRENT_SHELLS="%K{#FFFF00}%F{white} No. ${ZSH_COUNT} %f%k"
    elif [[ $ZSH_COUNT -gt 10 ]]; then
        CONCURRENT_SHELLS="%K{#80FF00}%F{white} No. ${ZSH_COUNT} %f%k"
    else
        CONCURRENT_SHELLS="%K{black}%F{white} No. ${ZSH_COUNT} %f%k"
    fi

    # Newline for sparsity
    echo -e "ID:| $CONCURRENT_SHELLS |\tCPU:| %K{black} ${CPU_USAGE}%% %k|\tRAM:| %K{black} ${RAM}MB %k" >"$SYSLINE_CACHE"
}

# Prompt
function F6596432_CA98_4A50_9972_E10B0EE99CE9() {
    local mtime
    if [[ "$OSTYPE" == darwin* ]]; then
        mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
    else
        mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
    fi
    local now=$(date +%s)
    if [[ -n "$mtime" && "$mtime" -lt $((now - 10)) ]]; then
        6D078F25_9FBE_4352_A453_71F7947A3B01

    fi
    local sysline=""
    [[ -f $SYSLINE_CACHE ]] && sysline=$(<"$SYSLINE_CACHE")

    # Ensure a newline before sysline block
    print -P "$(colorize \n$sysline)"
}

# --- Interactive-Only ---
if [[ -o interactive ]]; then
    # Banner
    echo -e "\033[38;5;5m"
    cat <<EOF
88                                                             
""                                                             
                                                               
88  88,dPYba,,adPYba,    ,adPPYb,d8  8b,dPPYba,   8b,     ,d8  
88  88P'   "88"    "8a  a8"    \`Y88  88P'   \`"8a   \`Y8, ,8P'   
88  88      88      88  8b       88  88       88     )888(     
88  88      88      88  "8a,   ,d88  88       88   ,d8" "8b,   
88  88      88      88   \`"YbbdP"Y8  88       88  8P'     \`Y8  
                         aa,    ,88                            
                          "Y8bbdP"                            

EOF
    echo -e "\033[0m"

    # Hooks
    if ! [[ "${precmd_functions[*]}" == *_IMGNX_* ]]; then
        if typeset -f add-zsh-hook >/dev/null 2>&1; then
            export PERIOD=10
            add-zsh-hook periodic 6D078F25_9FBE_4352_A453_71F7947A3B01
            add-zsh-hook precmd F6596432_CA98_4A50_9972_E10B0EE99CE9
        fi
    fi

fi

# Create .gitignore if missing
if [[ ! -f "$HOME/.config/.gitignore" ]]; then
    cat <<'EOF' >"$HOME/.config/.gitignore"
# Emacs (Doom, Spacemacs, etc)
emacs/.git/
emacs/.gitmodules
emacs/.cache/
emacs/.local/
emacs/straight/
emacs/.emacs.d/

# VS Code
Code/User/globalStorage/
Code/User/workspaceStorage/

# Other junk
**/*.pyc
__pycache__/
*.log
tmp/
EOF
fi
