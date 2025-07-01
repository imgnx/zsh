# shellcheck shell=bash

alias SURGE="$HOME/Library/Containers/com.apple.garageband10/Data/Documents/Surge XT/Patches/Templates"

print -n -P "[%F{#202020}variables%f]"

# ============================
# Named Directories
# ============================
hash -d bin=$BIN
hash -d labs=$LABS
hash -d lib=$LIB
hash -d src=$SRC
hash -d taku=$TAKU
hash -d test=$TEST
hash -d wk=$WORKBENCH
hash -d Labs=$LABS
hash -d zcnf=$ZDOTDIR
hash -d xdg=$XDG_CONFIG_HOME
hash -d xdg_cache=$XDG_CACHE_HOME
hash -d xdg_data=$XDG_DATA_HOME
hash -d xdg_state=$XDG_STATE_HOME
hash -d xdg_runtime=$XDG_RUNTIME_DIR
hash -d surge=$SURGE

# GPG
export GPG_TTY=$(tty)
export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AGENT_PID=$(gpgconf --list-dirs agent-pid)

# ZSH
export ESLINT_USE_FLAT_CONFIG=false
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BIN="$HOME/bin"
export BKGD="$SAMPLES/bkgd.mp3"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export CALCULATOR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
export CONTAINERS="$HOME/_____CONTAINERS"
export DOWNLOADS="$HOME/Downloads"
export EXA_COLORS="ln=1;35"
export LABS="$WORKBENCH/_____LABS"
export LIB="$HOME/lib"
export TEST="$HOME/test"
export LOGPATH="$ICLOUD_DRIVE/Logs/"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export SCRIPTS="$HOME/scripts"
export SRC="$HOME/src"
export TAKU="$WORKBENCH/taku"
export WORKBENCH="$HOME/_____WORKBENCH"
export WORKSPACE="$WORKBENCH"
export ZDOTDIR="$HOME/.config/zsh"
export ZINIT_HOME="$XDG_CONFIG_HOME/zinit"
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export ZSH="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/cache"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export ZSH_LOG_DIR="$XDG_CACHE_HOME/zsh/logs"
export CONFIG="$XDG_CACHE_HOME"

# No-Name Directory (fallback for plugins)
export ZSH_NN_DIR="$XDG_CACHE_HOME/zsh/nn"

# =============
# Surge XT for GarageBand
# =============
