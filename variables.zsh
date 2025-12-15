# shellcheck shell=bash


#`````````````````#
#++ TEMPORARY ++++#
#_________________#
# Start TuxGuitar
# export MODEL=x86_64
# export OUTPUT_DIR=build_output
# export JAVA_HOME=$(/usr/libexec/java_home)
# End TuxGuitar

export SRC="$HOME/src"
# export DINGLEHOPPER="cd $DINGLEHOPPER"
export BLUEPRINTS="$DINGLEHOPPER/blueprints";
export bp="$DINGLEHOPPER/blueprints"
export dh="$DINGLEHOPPER"
export srv="cd $DINGLEHOPPER/srv"
export triage="cd $DINGLEHOPPER/triage"


# ==============================
# Placeholder
# ==============================
export PLACEHOLDER="cnf [<config-dir> (<file> ) - open in emacs ] - open in zsh"


# ==============================
# Emacs Configuration
# ==============================

export DOOMDIR="${DOOMDIR:-${XDG_CONFIG_HOME}/doom}"
# Doom core location (traditionally ~/.emacs.d). If you keep Emacs/Doom under XDG,
# this points there; otherwise default to ~/.emacs.d.
export EMACSDIR="${EMACSDIR:-${XDG_CONFIG_HOME}/emacs}"
# Doom cache/local dir; default to live alongside your XDG Emacs dir
export DOOMLOCALDIR="${DOOMLOCALDIR:-${XDG_CONFIG_HOME}/emacs/.local}"

# ==============================
#  XDG Base Directories
# ==============================

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export SHELL_SESSIONS_DISABLE=1

# Optional convenience paths (not used by vanilla Emacs)
export EMACS="${EMACS:-${XDG_CONFIG_HOME}/emacs}"
export EMACS_DUMP_FILE="${EMACS_DUMP_FILE:-${XDG_STATE_HOME}/emacs/auto-save-list/.emacs.dumper}"
export EMACS_DIR="${EMACS_DIR:-${XDG_CONFIG_HOME}/emacs}"
export EMACS_CONFIG_DIR="${EMACS_CONFIG_DIR:-${XDG_CONFIG_HOME}/emacs}"
export EMACS_LISP_DIR="${EMACS_LISP_DIR:-${XDG_DATA_HOME}/emacs/site-lisp}"
export EMACS_CACHE_DIR="${EMACS_CACHE_DIR:-${XDG_CACHE_HOME}/emacs}"
export EMACS_SAVEDIR="${EMACS_SAVEDIR:-${XDG_STATE_HOME}/emacs}"
export EMACS_BACKUP_DIR="${EMACS_BACKUP_DIR:-${XDG_STATE_HOME}/emacs/backup}"
export EMACS_TRASH_DIR="${EMACS_TRASH_DIR:-${XDG_STATE_HOME}/emacs/trash}"
export EMACS_SAVES_DIR="${EMACS_SAVES_DIR:-${XDG_STATE_HOME}/emacs/saves}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# Normalize EMACS_* if unset or set to a broken '/emacs*' path
_sanitize_emacs_var() {
    local name="$1" default="$2" val
    # Indirect get: ${(P)name} fetches value of variable named by $name
    val="${(P)name}"
    if [[ -z "${val:-}" || -z "${val:#/emacs*}" ]]; then
	typeset -gx "$name"="$default"
    fi
}

_sanitize_emacs_var EMACSDIR         "${XDG_CONFIG_HOME}/emacs"
_sanitize_emacs_var EMACS            "${EMACSDIR}"
_sanitize_emacs_var EMACS_DIR        "${EMACSDIR}"
_sanitize_emacs_var EMACS_CONFIG_DIR "${EMACSDIR}"
_sanitize_emacs_var EMACS_CACHE_DIR  "${XDG_CACHE_HOME}/emacs"
_sanitize_emacs_var EMACS_SAVEDIR    "${XDG_STATE_HOME}/emacs"
_sanitize_emacs_var EMACS_BACKUP_DIR "${XDG_STATE_HOME}/emacs/backup"
_sanitize_emacs_var EMACS_TRASH_DIR  "${XDG_STATE_HOME}/emacs/trash"
_sanitize_emacs_var EMACS_SAVES_DIR  "${XDG_STATE_HOME}/emacs/saves"
_sanitize_emacs_var EMACS_LISP_DIR   "${XDG_DATA_HOME}/emacs/site-lisp"
_sanitize_emacs_var EMACS_DUMP_FILE  "${XDG_STATE_HOME}/emacs/auto-save-list/.emacs.dumper"

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

# Quick jump named directories
#
export DH="/Users/donaldmoore/src/dinglehopper"
hash -d dh=DH
export STDLN="/Users/donaldmoore/src/dinglehopper/stdln"
hash -d stdln=STDLN
export BP="/Users/donaldmoore/src/dinglehopper/blueprints"
hash -d bp=BP

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
export CARGO_HOME="${CARGO_HOME:-$XDG_DATA_HOME/cargo}"

# Prefer system Python for macOS tools (e.g., gcloud) if not overridden
if [[ -z "${CLOUDSDK_PYTHON:-}" ]]; then
    if [[ -x /usr/bin/python3 ]]; then
	export CLOUDSDK_PYTHON="/usr/bin/python3"
    fi
fi
export CONFIG="$XDG_CACHE_HOME"
export CONTAINERS="$HOME/_____CONTAINERS"
export COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export DOWNLOADS="$HOME/Downloads"
export EDITOR="emacs"
export ESLINT_USE_FLAT_CONFIG=false
export EXA_COLORS="ln=1;35"
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export JSH="$SRC/jsh"
export LABS="$WORKBENCH/_____LABS"
export LIB="$HOME/lib"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH"
export RUSTUP_HOME="${RUSTUP_HOME:-$XDG_DATA_HOME/rustup}"
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

# =================
# Node/JS ecosystem (XDG)
# =================
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# export NPM_CONFIG_PREFIX="${NPM_CONFIG_PREFIX:-$XDG_DATA_HOME/npm}"
export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
export PNPM_STORE_DIR="${PNPM_STORE_DIR:-$XDG_CACHE_HOME/pnpm}"
export YARN_CACHE_FOLDER="${YARN_CACHE_FOLDER:-$XDG_CACHE_HOME/yarn}"
export NODE_REPL_HISTORY="${NODE_REPL_HISTORY:-$XDG_STATE_HOME/node/repl_history}"

# =================
# Python (XDG)
# =================
export PIP_CONFIG_FILE="${PIP_CONFIG_FILE:-$XDG_CONFIG_HOME/pip/pip.conf}"
export PYTHONPYCACHEPREFIX="${PYTHONPYCACHEPREFIX:-$XDG_CACHE_HOME/python}"

# =================
# Go (XDG)
# =================
export GOPATH="${GOPATH:-$XDG_DATA_HOME/go}"
export GOCACHE="${GOCACHE:-$XDG_CACHE_HOME/go}"
export GOMODCACHE="${GOMODCACHE:-$GOPATH/pkg/mod}"

# =================
# CLI tools (XDG)
# =================
export CLOUDSDK_CONFIG="${CLOUDSDK_CONFIG:-$XDG_CONFIG_HOME/gcloud}"
export GH_CONFIG_DIR="${GH_CONFIG_DIR:-$XDG_CONFIG_HOME/gh}"
export DOCKER_CONFIG="${DOCKER_CONFIG:-$XDG_CONFIG_HOME/docker}"
export AWS_CONFIG_FILE="${AWS_CONFIG_FILE:-$XDG_CONFIG_HOME/aws/config}"
export AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE:-$XDG_CONFIG_HOME/aws/credentials}"
export RIPGREP_CONFIG_PATH="${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/ripgreprc}"
export LESSHISTFILE="${LESSHISTFILE:-$XDG_STATE_HOME/less/history}"
export WGETRC="${WGETRC:-$XDG_CONFIG_HOME/wget/wgetrc}"
export HSTS_FILE="${HSTS_FILE:-$XDG_CACHE_HOME/wget-hsts}"


# export MallocStackLogging=1
# Command to stop it:
# sudo sysctl -w kern.malloc.stack_logging=0


# OLD?
#
# ## shellcheck shell=bash


# #`````````````````#
# #++ TEMPORARY ++++#
# #_________________#
# # Start TuxGuitar
# export MODEL=x86_64
# export OUTPUT_DIR=build_output
# export JAVA_HOME=$(/usr/libexec/java_home)
# # End TuxGuitar


# # ==============================
# # Placeholder
# # ==============================
# export PLACEHOLDER="cnf [<config-dir> (<file> ) - open in emacs ] - open in zsh"


# # ==============================
# # Emacs Configuration
# # ==============================

# export DOOMDIR="${XDG_CONFIG_HOME}/doom"
# export EMACSDIR="${XDG_CONFIG_HOME}/emacs"
# export EMACS="${XDG_CONFIG_HOME}/emacs"
# export EMACS_DUMP_FILE="${XDG_STATE_HOME}/emacs/auto-save-list/.emacs.dumper"
# export EMACS_DIR="${XDG_CONFIG_HOME}/emacs"
# export EMACS_CONFIG_DIR="${XDG_CONFIG_HOME}/emacs"
# export EMACS_LISP_DIR="${XDG_DATA_HOME}/emacs/site-lisp"
# export EMACS_CACHE_DIR="${XDG_CACHE_HOME}/emacs"
# export EMACS_SAVEDIR="${XDG_STATE_HOME}/emacs"
# export EMACS_BACKUP_DIR="${XDG_STATE_HOME}/emacs/backup"
# export EMACS_TRASH_DIR="${XDG_STATE_HOME}/emacs/trash"
# export EMACS_SAVEDIR="${XDG_STATE_HOME}/emacs/saves"

# # ==============================
# #  XDG Base Directories
# # ==============================

# export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
# export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
# export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

# # ==============================
# #  Zsh Configuration
# # ==============================
# export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
# export ZINIT_HOME="${ZINIT_HOME:-$XDG_CONFIG_HOME/zinit}"
# export ZSH="${ZSH:-$XDG_CONFIG_HOME/zsh}"
# export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/zsh/cache}"
# export ZSH_COMPDUMP="${ZSH_COMPDUMP:-$XDG_CACHE_HOME/zsh/zcompdump}"
# export ZSH_LOG_DIR="${ZSH_LOG_DIR:-$XDG_CACHE_HOME/zsh/logs}"
# export ZSH_NN_DIR="${ZSH_NN_DIR:-$XDG_CACHE_HOME/zsh/nn}"
# export ZSH_PLUGINS_DIR="${ZSH_PLUGINS_DIR:-$ZSH/plugins}"

# # ============================
# # Tabula Rasa
# # ============================
# # "Tabula rasa" is a Latin term meaning "blank slate".
# # In philosophy and psychology, it refers to the idea
# # that individuals are born without built-in mental
# # content and that all knowledge comes from experience
# # and sensory perception. This concept is central to
# # the empiricist view of learning and development,
# # contrasting with nativism, which suggests that some
# # knowledge is innate.
# # Tabula Rasa will
# export TABULA_RASA="${TABULA_RASA:--1}" # 0=off, 1=on, -1=ask
# if [[ "$TABULA_RASA" == "1" ]]; then
#     return
# fi

# # print -P -n "[%F{green}variables%f]"
# # ============================
# # Named Directories

# # Hashes are for executables...

# # hash -d bin=$BIN
# # hash -d labs=$LABS
# # hash -d lib=$LIB
# # hash -d src=$SRC
# # hash -d taku=$TAKU
# # hash -d test=$TEST
# # hash -d wk=$WORKBENCH
# # hash -d xdg=$XDG_CONFIG_HOME
# # hash -d cache=$XDG_CACHE_HOME
# # hash -d data=$XDG_DATA_HOME
# # hash -d rt=$XDG_RUNTIME_DIR
# # hash -d state=$XDG_STATE_HOME
# # hash -d zsh=$ZDOTDIR
# # hash -d zcnf=/Users/donaldmoore/config/zsh
# # hash -d surge=$SURGE

# # GPG
# if (gpgconf --list-dirs agent-socket &>/dev/null); then
#     # echo "GPG agent is running"
#     export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
#     export SSH_AGENT_PID=$(gpgconf --list-dirs agent-pid)
#     export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# else
#     # echo "GPG agent is not running, starting it with: gpgconf --launch gpg-agent"
# fi

# export GPG_TTY=$(tty)

# # ZSH
# export AWKDIR="$XDG_CONFIG_HOME/zsh/functions"
# export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
# export BIN="$HOME/bin"
# export BKGD="$SAMPLES/bkgd.mp3"
# export BK="$ICLOUD_DRIVE/_____BACKUPS"
# export CALCULATOR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
# #  ! This causes problems every time... Yes! You
# #  ! have to use --path=. !!!
# export CARGO_HOME="$HOME/dotfiles/.cargo"

# export CLOUDSDK_PYTHON="/Users/donaldmoore/.pyenv/versions/pitchfix/bin/python"
# export CONFIG="$XDG_CACHE_HOME"
# export CONTAINERS="$HOME/_____CONTAINERS"
# export COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set
# export DOOMDIR="$XDG_CONFIG_HOME/doom"
# export DOWNLOADS="$HOME/Downloads"
# export EDITOR="$HOME/bin/code-wait"
# export ESLINT_USE_FLAT_CONFIG=false
# export EXA_COLORS="ln=1;35"
# export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
# export JSH="$SRC/jsh"
# export LABS="$WORKBENCH/_____LABS"
# export LIB="$HOME/lib"
# export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH"
# export RUSTUP_HOME="$HOME/dotfiles/.rustup"
# export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
# export SCREENCAST_MODE=-1 # 0=off, 1=on, -1=ask
# export SCRIPTS="$HOME/scripts"
# export SRC="$HOME/src"
# export TAKU="$SRC/taku-4"
# export TEST="$HOME/test"
# export WORKBENCH="$HOME/_____WORKBENCH"
# export WORKSPACE="$WORKBENCH"
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_RUNTIME_DIR="$HOME/.local/run"
# export XDG_STATE_HOME="$HOME/.local/state"
# export ZDOTDIR="$HOME/.config/zsh"
# export ZINIT_HOME="$XDG_CONFIG_HOME/zinit"
# export ZSH="$XDG_CONFIG_HOME/zsh"
# export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/cache"
# export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
# export ZSH_LOG_DIR="$XDG_CACHE_HOME/zsh/logs"
# export ZSH_NN_DIR="$XDG_CACHE_HOME/zsh/nn"

# # ============================
# # Environment Variables
# # ============================
# export EXA_COLORS="ln=1;35"
# export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
# export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
# export BK="$ICLOUD_DRIVE/_____BACKUPS"
# export WORKBENCH="$HOME/_____WORKBENCH"
# export SCRIPTS="$HOME/scripts"
# export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
# export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
# export BKGD="$SAMPLES/bkgd.mp3"
# export CONTAINERS="$HOME/_____CONTAINERS"
# export LABS="$WORKBENCH/_____LABS"
# export DOWNLOADS="$HOME/Downloads"
# export CALCULATOR="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"

# # =================
# # Volta
# # =================
# export VOLTA_HOME="$XDG_CONFIG_HOME/volta"
# export VOLTA_CACHE="$XDG_CACHE_HOME/volta"


export BREW_CELLAR_HOME="/usr/local/Cellar/"
