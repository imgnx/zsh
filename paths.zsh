# shellcheck shell=bash


#`````````````````#
#++ TEMPORARY ++++#
#_________________#
# Start TuxGuitar
export MODEL=x86_64
export OUTPUT_DIR=build_output
export JAVA_HOME=$(/usr/libexec/java_home)
# End TuxGuitar


# ==============================
# Placeholder
# ==============================
export PLACEHOLDER="cnf [<config-dir> (<file> ) - open in emacs ] - open in zsh"


# ==============================
# Emacs Configuration
# ==============================

export DOOMDIR="${XDG_CONFIG_HOME}/doom"
export EMACSDIR="${XDG_CONFIG_HOME}/emacs"
export EMACS="${XDG_CONFIG_HOME}/emacs"
export EMACS_DUMP_FILE="${XDG_STATE_HOME}/emacs/auto-save-list/.emacs.dumper"
export EMACS_DIR="${XDG_CONFIG_HOME}/emacs"
export EMACS_CONFIG_DIR="${XDG_CONFIG_HOME}/emacs"
export EMACS_LISP_DIR="${XDG_DATA_HOME}/emacs/site-lisp"
export EMACS_CACHE_DIR="${XDG_CACHE_HOME}/emacs"
export EMACS_SAVEDIR="${XDG_STATE_HOME}/emacs"
export EMACS_BACKUP_DIR="${XDG_STATE_HOME}/emacs/backup"
export EMACS_TRASH_DIR="${XDG_STATE_HOME}/emacs/trash"
export EMACS_SAVEDIR="${XDG_STATE_HOME}/emacs/saves"

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

# ============================
# Tabula Rasa
# ============================
# "Tabula rasa" is a Latin term meaning "blank slate".
# In philosophy and psychology, it refers to the idea
# that individuals are born without built-in mental
# content and that all knowledge comes from experience
# and sensory perception. This concept is central to
# the empiricist view of learning and development,
# contrasting with nativism, which suggests that some
# knowledge is innate.
# Tabula Rasa will
export TABULA_RASA="${TABULA_RASA:--1}" # 0=off, 1=on, -1=ask
if [[ "$TABULA_RASA" == "1" ]]; then
    return
fi

# print -P -n "[%F{green}variables%f]"
# ============================
# Named Directories

# Hashes are for executables...

# hash -d bin=$BIN
# hash -d labs=$LABS
# hash -d lib=$LIB
# hash -d src=$SRC
# hash -d taku=$TAKU
# hash -d test=$TEST
# hash -d wk=$WORKBENCH
# hash -d xdg=$XDG_CONFIG_HOME
# hash -d cache=$XDG_CACHE_HOME
# hash -d data=$XDG_DATA_HOME
# hash -d rt=$XDG_RUNTIME_DIR
# hash -d state=$XDG_STATE_HOME
# hash -d zsh=$ZDOTDIR
# hash -d zcnf=/Users/donaldmoore/config/zsh
# hash -d surge=$SURGE

# GPG
if (gpgconf --list-dirs agent-socket &>/dev/null); then
    # echo "GPG agent is running"
    export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
    export SSH_AGENT_PID=$(gpgconf --list-dirs agent-pid)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
else
    # echo "GPG agent is not running, starting it with: gpgconf --launch gpg-agent"
fi

export GPG_TTY=$(tty)

# ZSH
export AWKDIR="$XDG_CONFIG_HOME/zsh/functions"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BIN="$HOME/bin"
export BKGD="$SAMPLES/bkgd.mp3"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export CALCULATOR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
#  ! This causes problems every time... Yes! You
#  ! have to use --path=. !!!
export CARGO_HOME="$HOME/dotfiles/.cargo"

export CLOUDSDK_PYTHON="/Users/donaldmoore/.pyenv/versions/pitchfix/bin/python"
export CONFIG="$XDG_CACHE_HOME"
export CONTAINERS="$HOME/_____CONTAINERS"
export COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export DOWNLOADS="$HOME/Downloads"
export EDITOR="$HOME/bin/code-wait"
export ESLINT_USE_FLAT_CONFIG=false
export EXA_COLORS="ln=1;35"
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export JSH="$SRC/jsh"
export LABS="$WORKBENCH/_____LABS"
export LIB="$HOME/lib"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH"
export RUSTUP_HOME="$HOME/dotfiles/.rustup"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export SCREENCAST_MODE=-1 # 0=off, 1=on, -1=ask
export SCRIPTS="$HOME/scripts"
export SRC="$HOME/src"
export TAKU="$SRC/taku-4"
export TEST="$HOME/test"
export WORKBENCH="$HOME/_____WORKBENCH"
export WORKSPACE="$WORKBENCH"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="$HOME/.local/run"
export XDG_STATE_HOME="$HOME/.local/state"
export ZDOTDIR="$HOME/.config/zsh"
export ZINIT_HOME="$XDG_CONFIG_HOME/zinit"
export ZSH="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/cache"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export ZSH_LOG_DIR="$XDG_CACHE_HOME/zsh/logs"
export ZSH_NN_DIR="$XDG_CACHE_HOME/zsh/nn"

# ============================
# Environment Variables
# ============================
export EXA_COLORS="ln=1;35"
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export WORKBENCH="$HOME/_____WORKBENCH"
export SCRIPTS="$HOME/scripts"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export BKGD="$SAMPLES/bkgd.mp3"
export CONTAINERS="$HOME/_____CONTAINERS"
export LABS="$WORKBENCH/_____LABS"
export DOWNLOADS="$HOME/Downloads"
export CALCULATOR="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"

# =================
# Volta
# =================
export VOLTA_HOME="$XDG_CONFIG_HOME/volta"
export VOLTA_CACHE="$XDG_CACHE_HOME/volta"
