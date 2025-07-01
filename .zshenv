# shellcheck shell=bash

. "${ZDOTDIR}/functions.zsh" # Load custom functions

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

function import() {
    prompt=(
        "Did you mean to run \033[5;38;5;1mimport\033[0m in the current terminal? \033[38;5;5mimport\033[39m is currently set to run ImageMagick."
        'You likely meant to add a shebang to the top of a JavaScript file and the terminal found an "import" statement instead.'
        "Here is the shebang for Node.js:\n\n\033[38;5;2m\#!/usr/bin/env node\033[39m\n\n"
        'Is this what you meant to do? (y/N)'
    )

    answer="$(safeguard "${prompt[@]}")"

}

# "Tabula rasa" is a Latin term meaning "blank slate".
# In philosophy and psychology, it refers to the idea
# that individuals are born without built-in mental
# content and that all knowledge comes from experience
# and sensory perception. This concept is central to
# the empiricist view of learning and development,
# contrasting with nativism, which suggests that some
# knowledge is innate.
# Tabula Rasa will
export TABULA_RASA=-1 # 0=off, 1=on, -1=ask

export SCREENCAST_MODE=-1 # 0=off, 1=on, -1=ask

function 1DABF50B_9CB5_4679_9B58_2F203D12C8F1() {
    echo -e "Active Mode: \033[38;5;2mNormal\033[0m"
    echo -e "Mode(s): \033[38;5;4mScreencast\033[0m, \033[38;5;64mZen Mode\033[39m, \033[38;5;84mTabula Rasa\033[0m, \033[38;5;6mCopilot\033[0m..."
    echo -e "Activate? [Y/n]:"

    read -k 1 init_response
    if [[ "$init_response" =~ ^[Yy]$ ]]; then

        # If screencast mode is set to -1, ask the user if they are screencasting.
        if [[ "$SCREENCAST_MODE" -eq -1 ]]; then
            # Screencast mode is not set. Do you want to enable it?
            # This will allow the terminal to be recorded in screencasts.
            # Ask about screencast mode
            echo -n " Are you \033[38;5;31mScreencasting\033[0m? [Y/n]:"
            # Read only the first character of input
            read -k 1 sc_response
            # Move to a new line after the keypress
            echo
            if [[ "$sc_response" =~ ^[Yy]$ ]]; then
                export SCREENCAST_MODE="true"
            else
                export SCREENCAST_MODE="false"
            fi
            clear
        else
            echo "Screencast mode is currently set to $SCREENCAST_MODE."
        fi

        # Tabula Rasa Mode
        if [[ "$TABULA_RASA" -eq -1 ]]; then
            # Tabula Rasa mode is not set. Do you want to enable it?
            # This will give you a blank slate — no configrations will be loaded.
            # Ask about tabula rasa mode
            echo -n " \033[38;5;2mTabula Rasa?\033[39m [y/N]: "
            read -k 1 tr_response
            # Move to a new line after the keypress
            echo
            if [[ "$tr_response" =~ ^[Yy]$ ]]; then
                export TABULA_RASA="true"
            else
                export TABULA_RASA="false"
            fi

            clear
            # # Clear the last two lines from the prompt above (the question and the response).
            # if [[ -n "$ZSH_VERSION" ]]; then
            #     # Zsh-specific way to clear lines
            #     print -n "\e[1A\e[2K"
            # else
            #     # Fallback for other shells (like bash)
            #     echo -e "\033[1A\033[2K"
            # fi
        fi
    fi
}

if [[ -o interactive ]]; then
    1DABF50B_9CB5_4679_9B58_2F203D12C8F1

fi

export CLOUDSDK_PYTHON="/usr/bin/python3"

### 🥾 PATH
export PATH="$HOME/bin:$PATH"

### 🌐 XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/run"

### ✋ Modules
export ICLOUD_DRIVE="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs"
export ZDOTDIR="$HOME/.config/zsh"
export ZINIT_HOME="$XDG_CONFIG_HOME/zinit"
export DOOMDIR="$XDG_CONFIG_HOME/doom"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH"
export CLOUDSDK_PYTHON="/Users/donaldmoore/.pyenv/versions/pitchfix/bin/python"
### source

export CARGO_TARGET_DIR="$XDG_CONFIG_HOME/cargo"
export AWKDIR="$XDG_CONFIG_HOME/zsh/functions"

export EDITOR="code --wait"
export PATH=$HOME/bin:$PATH
### GPG
export GPG_TTY=$(tty)
if command -v gpgconf >/dev/null 2>&1; then
    export GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AGENT_PID=$(gpgconf --list-dirs agent-pid)
fi
### ZSH
export ESLINT_USE_FLAT_CONFIG=false
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BIN="$HOME/bin"
export BKGD="$SAMPLES/bkgd.mp3"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export CALCULATOR="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"
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
export ZSH="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/cache"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export ZSH_LOG_DIR="$XDG_CACHE_HOME/zsh/logs"
### No-Name Directory (fallback for plugins)
export ZSH_NN_DIR="$XDG_CACHE_HOME/zsh/nn"

export CARGO_HOME="$HOME/.config/cargo"
export RUSTUP_HOME="$HOME/.config/rustup"
export PATH="$CARGO_HOME/bin:$PATH"

alias restart='exec zsh --login'
alias refresh='exec zsh --login'

. "/Users/donaldmoore/.local/share/cargo/env"

export CARGO_HOME="$HOME/.config/cargo"
export RUSTUP_HOME="$HOME/.config/rustup"

# Check if Copilot is running in its own terminal
if [[ -n "$COPILOT_MODE" && "$COPILOT_MODE" == "true" ]]; then
    echo -e "\033[38;5;6mCopilot terminal detection is active.\033[39m"
    echo "To disable Copilot terminal detection, unset the COPILOT_MODE environment variable or set it to 'false'."
    echo -e "\033[38;5;2mCopilot terminal mode is enabled.\033[39m"
    # You can add any specific behavior for Copilot terminals here
fi

# You may need to install gdate...
echo -e "\033[38;5;3m$(pwd)\033[0m - $(gdate -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
if [[ $SCREENCAST_MODE == "true" || $SCREENCAST_MODE -eq 1 ]]; then
    echo -e -n "\033[38;5;31m[ Screencasting ]\033[39m"
else
    echo -e -n "\033[38;5;233m[ Screencasting ]\033[39m"
fi
if [[ $TABULA_RASA == "true" || $TABULA_RASA -eq 1 ]]; then
    echo -e -n "\033[38;5;2m[ Tabula Rasa ]\033[39m"
else
    echo -e -n "\033[38;5;233m[ Tabula Rasa ]\033[39m"
fi
if [[ $COPILOT_MODE == "true" || $COPILOT_MODE -eq 1 ]]; then
    echo -e -n "\033[38;5;6m[ Copilot ]\033[39m"
else
    echo -e -n "\033[38;5;233m[ Copilot ]\033[39m"
fi

if [[ -o interactive ]]; then
    print -n -P "[%F{magenta}.zshenv%f]"

    # Dotfiles Game Genie: USB-based config override
    autoload_usb_config() {
        for vol in /Volumes/*; do
            if [[ -d "$vol" && "$vol" =~ ^/Volumes/[0-9]+_([A-Z]+)$ && -d "$vol/.config" ]]; then
                export XDG_CONFIG_HOME="$vol/.config"
                echo "🔌 Loaded config from USB: $vol"
                return
            fi
        done
        export XDG_CONFIG_HOME="$HOME/.config"
    }

    autoload_usb_config

fi
