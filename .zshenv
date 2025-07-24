if [[ "${ZLOADING:-}" == ".zshenv" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
    print -n -P "[%F{#444}skip%f(%F{white}%D{%S.%3.}%f)]"
    return 0
fi

autoload -Uz compinit
compinit

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

if [[ -o interactive ]]; then
    export ZLOADING=".zshenv"
    # Uncomment to disable preflight load check
    # export SKIP_PREFLIGHT_LOAD_CHECK=0
    echo -e "✅ INTERACTIVE │ l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"

    . "/Users/donaldmoore/.config/zsh/variables.zsh" # Load custom variables
    export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"   # Set ZDOTDIR if not already set
    . "${ZDOTDIR}/functions.zsh"                     # Load custom functions

    # ? To get the path of a `brew` command:
    # ? brew --prefix cmd
    export IMGNX_PATH="/Users/donaldmoore/bin:/usr/local/opt:/usr/local/bin:/Users/donaldmoore/.config/cargo/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/MacGPG2/bin:/Applications/Wireshark.app/Contents/MacOS"
    export PATH="$IMGNX_PATH"
    export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))

    # VS Code
    if command -v code >/dev/null 2>&1; then
        export VSCODE_SUGGEST=1
    fi

    ### 🥾 PATH

    add2path "$HOME/bin"
    # add2path "$HOME/.local/bin"
    # add2path "$HOME/.cargo/bin"

    ### 🌐 XDG

    # cargo config is located in $XDG_CONFIG_HOME/cargo/config.toml

    for lib_dir in ~/lib/**/build; do
        add2path "$lib_dir"
    done

    ### No-Name Directory (fallback for plugins)
    # Rust/Cargo
    . "/Users/donaldmoore/.local/share/cargo/env"

    . "${ZDOTDIR}/aliases.zsh"     # Load custom aliases
    . "${ZDOTDIR}/keybindings.zsh" # Load custom keybindings
    . "${ZDOTDIR}/hashes.zsh"      # Load custom hashes
    . "${ZDOTDIR}/path.zsh"        # Load custom path
    # Source Cargo
    [ -f "$HOME/.config/cargo/env" ] && . "$HOME/.config/cargo/env"

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
. "/Users/donaldmoore/.config/cargo/env"
export VOLTA_HOME="$HOME/.config/volta"
export PATH="$VOLTA_HOME/bin:$PATH"
