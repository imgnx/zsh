# shellcheck shell=bash

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
# # Tabula Rasa will

# function 1DABF50B_9CB5_4679_9B58_2F203D12C8F1() {
#     echo -e "Active Mode: \033[38;5;2mNormal\033[0m"
#     echo -e "Mode(s): \033[38;5;4mScreencast\033[0m, \033[38;5;64mZen Mode\033[39m, \033[38;5;84mTabula Rasa\033[0m, \033[38;5;6mCopilot\033[0m..."
#     echo -e "Activate? [Y/n]:"

#     read -k 1 init_response
#     if [[ "$init_response" =~ ^[Yy]$ ]]; then

#         # If screencast mode is set to -1, ask the user if they are screencasting.
#         if [[ "$SCREENCAST_MODE" -eq -1 ]]; then
#             # Screencast mode is not set. Do you want to enable it?
#             # This will allow the terminal to be recorded in screencasts.
#             # Ask about screencast mode
#             echo -n " Are you \033[38;5;31mScreencasting\033[0m? [Y/n]:"
#             # Read only the first character of input
#             read -k 1 sc_response
#             # Move to a new line after the keypress
#             echo
#             if [[ "$sc_response" =~ ^[Yy]$ ]]; then

#             else

#             fi
#             clear
#         else
#             echo "Screencast mode is currently set to $SCREENCAST_MODE."
#         fi

#         # Tabula Rasa Mode
#         if [[ "$TABULA_RASA" -eq -1 ]]; then
#             # Tabula Rasa mode is not set. Do you want to enable it?
#             # This will give you a blank slate — no configrations will be loaded.
#             # Ask about tabula rasa mode
#             echo -n " \033[38;5;2mTabula Rasa?\033[39m [y/N]: "
#             read -k 1 tr_response
#             # Move to a new line after the keypress
#             echo
#             if [[ "$tr_response" =~ ^[Yy]$ ]]; then

#             else

#             fi

#             clear
#             # # Clear the last two lines from the prompt above (the question and the response).
#             # if [[ -n "$ZSH_VERSION" ]]; then
#             #     # Zsh-specific way to clear lines
#             #     print -n "\e[1A\e[2K"
#             # else
#             #     # Fallback for other shells (like bash)
#             #     echo -e "\033[1A\033[2K"
#             # fi
#         fi
#     fi
# }

# if [[ -o interactive ]]; then
# 1DABF50B_9CB5_4679_9B58_2F203D12C8F1
# fi

### 🥾 PATH

### 🌐 XDG

# cargo config is located in $XDG_CONFIG_HOME/cargo/config.toml
add2path "$XDG_CONFIG_HOME/cargo/bin"
add2path "$CARGO_HOME"
add2path "$RUSTUP_HOME"
add2path "$HOME/go/bin"
add2path "$BIN"

for lib_dir in ~/lib/**/build; do
    $HOME/bin/add2path "$lib_dir"
done

### ✋ Modules
### source

### GPG
if command -v gpgconf >/dev/null 2>&1; then

fi
### ZSH

### No-Name Directory (fallback for plugins)

. "/Users/donaldmoore/.local/share/cargo/env"

if [[ -o interactive ]]; then

    print -n -P "[%F{#202020}.zshenv%f]"
    . "${ZDOTDIR}/aliases.zsh"     # Load custom aliases
    . "${ZDOTDIR}/variables.zsh"   # Load custom variables
    . "${ZDOTDIR}/functions.zsh"   # Load custom functions
    . "${ZDOTDIR}/keybindings.zsh" # Load custom keybindings

    # Dotfiles Game Genie: USB-based config override
    autoload_usb_config() {
        for vol in /Volumes/*; do
            if [[ -d "$vol" && "$vol" =~ ^/Volumes/[0-9]+_([A-Z]+)$ && -d "$vol/.config" ]]; then

                echo "🔌 Loaded config from USB: $vol"
                return
            fi
        done

    }

    autoload_usb_config

fi
