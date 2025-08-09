export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ "${ZLOADING:-}" == ".zshenv" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
    print -n -P "[%F{#444}skip env%f(%F{white}%D{%S.%3.}%f)]"
    return 0
fi

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

# Guard function to source each file only once
# `source_once`
function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8() {
    local file="$1"
    local guard_var="__SOURCED_$(basename "$file" | tr -c '[:alnum:]_' '_' | tr -s '_')"
    if [[ -z "${(P)guard_var}" ]]; then
        typeset -g "$guard_var"=1
        . "$file"
    fi
}

if [[ -o interactive ]]; then
    # MARK: Preflight check
    # ? Uncomment to disable preflight load check
    # export SKIP_PREFLIGHT_LOAD_CHECK=0
    # echo -e "✅ INTERACTIVE
    # l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"
    # ? MARK: Preflight check
    
    export ZLOADING=".zshenv"
    export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
    
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/functions.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/variables.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/aliases.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/keybindings.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/hashes.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/paths.zsh"
    # function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8 "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh"
    
    export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
    
    if command -v code >/dev/null 2>&1; then
        export VSCODE_SUGGEST=1
    fi
fi


# if [[ -o interactive ]]; then
# export ZLOADING=".zshenv"
# export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}" # Set ZDOTDIR if not already set
# . "${ZDOTDIR}/functions.zsh" -                 # Load custom functions

# # Load custom variables
# . "$ZDOTDIR/variables.zsh"
# # Load custom functions
# . "$ZDOTDIR/functions.zsh"
# # Load aliases, keybindings, hashes, paths
# . "$ZDOTDIR/aliases.zsh"
# . "$ZDOTDIR/keybindings.zsh"
# . "$ZDOTDIR/hashes.zsh"
# . "$ZDOTDIR/paths.zsh"

# export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))

# VS Code
# if command -v code >/dev/null 2>&1; then
#     export VSCODE_SUGGEST=1
# fi

### 🥾 PATH

# add2path "$HOME/bin"
# add2path "$HOME/.local/bin"
# add2path "$HOME/.cargo/bin"

### 🌐 XDG

### No-Name Directory (fallback for plugins)
# Rust/Cargo
# . "/Users/donaldmoore/dotfiles/.cargo/env"
# Source elsewhere...

# . "${ZDOTDIR}/aliases.zsh"                               # Load custom aliases
# . "${ZDOTDIR}/keybindings.zsh"                           # Load custom keybindings
# . "${ZDOTDIR}/hashes.zsh"                                # Load custom hashes
# . "${ZDOTDIR}/paths.zsh"                                 # Load custom path variables
# . "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh" # Load delayed script loader
# Source Cargo environment if exists
# [ -f "$HOME/dotfiles/.cargo/env" ] && . "$HOME/dotfiles/.cargo/env"
# fi
