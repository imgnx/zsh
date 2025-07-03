# shellcheck shell=bash

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

print -n -P "[%F{#202020}variables%f]"
# ============================
# Named Directories
hash -d Labs=$LABS
hash -d bin=$BIN
hash -d labs=$LABS
hash -d lib=$LIB
hash -d src=$SRC
hash -d taku=$TAKU
hash -d test=$TEST
hash -d wk=$WORKBENCH
hash -d xdg=$XDG_CONFIG_HOME
hash -d xdg_cache=$XDG_CACHE_HOME
hash -d xdg_data=$XDG_DATA_HOME
hash -d xdg_runtime=$XDG_RUNTIME_DIR
hash -d xdg_state=$XDG_STATE_HOME
hash -d zcnf=$ZDOTDIR
hash -d surge=$SURGE
# GPG
export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
export GPG_TTY=$(tty)
export SSH_AGENT_PID=$(gpgconf --list-dirs agent-pid)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# ZSH
export AWKDIR="$XDG_CONFIG_HOME/zsh/functions"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BIN="$HOME/bin"
export BKGD="$SAMPLES/bkgd.mp3"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export CALCULATOR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
export CARGO_HOME="$HOME/.config/cargo"
export CARGO_TARGET_DIR="$XDG_CONFIG_HOME/cargo"
export CLOUDSDK_PYTHON="/Users/donaldmoore/.pyenv/versions/pitchfix/bin/python"
export CONFIG="$XDG_CACHE_HOME"
export CONTAINERS="$HOME/_____CONTAINERS"
export COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export DOWNLOADS="$HOME/Downloads"
export EDITOR="code --wait"
export ESLINT_USE_FLAT_CONFIG=false
export EXA_COLORS="ln=1;35"
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export LABS="$WORKBENCH/_____LABS"
export LIB="$HOME/lib"
export LOGPATH="$ICLOUD_DRIVE/Logs/"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export PATH="$CARGO_HOME/bin:$HOME/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH"
export RUSTUP_HOME="$HOME/.config/rustup"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export SCREENCAST_MODE=-1 # 0=off, 1=on, -1=ask
export SCRIPTS="$HOME/scripts"
export SRC="$HOME/src"
export TAKU="$WORKBENCH/taku"
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
export TAKU="$WORKBENCH/taku"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export BKGD="$SAMPLES/bkgd.mp3"
export CONTAINERS="$HOME/_____CONTAINERS"
export LABS="$WORKBENCH/_____LABS"
export DOWNLOADS="$HOME/Downloads"
export LOGPATH="$ICLOUD_DRIVE/Logs/"
export CALCULATOR="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
