echo -en "\033[38;2;222;173;237m
イエムジーエヌエックス
\033[0m"

export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))


functionD8EA8FE0_EE54_4EA2_AE42_6692B212B4D5() {
    if [[ "${ZSH_DEBUG:-}" == "true" ]]; then
        echo -en "$@"
    fi
}

alias imgnx_debug='functionD8EA8FE0_EE54_4EA2_AE42_6692B212B4D5'

# Guard function to source each file only once
# `source_once`
function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8() {
    local file="$1"
    [[ -z "$file" ]] && return 1
    
    local base=${file##*/}            # strip path
    base=${base//[^A-Za-z0-9_]/_}      # sanitise
    while [[ $base == *_ ]]; do        # remove any trailing underscores
        base=${base%_}
    done
    [[ -z $base ]] && return 1
    local guard_var="__SOURCED_${base}"
    
    # If already defined (non-empty), skip
    if [[ -n ${parameters[$guard_var]:-} ]]; then
        return 0
    fi
    
    typeset -g "${guard_var}=1"
    
    if [[ "${ZSH_DEBUG:-}" == "true" ]]; then
        imgnx_debug "[source_once] guarding $(basename "$file") => " # The file itself will respond with a confirmation.
    fi
    
    if [[ -f "$file" ]]; then
        . "$file" || { [[ "${ZSH_DEBUG:-}" == "true" ]] && imgnx_debug "[source_once] Error sourcing $file"; }
    else
        [[ "${ZSH_DEBUG:-}" == "true" ]] && imgnx_debug "[source_once] Missing file: $file"
        return 2
    fi
}

alias source_once='function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8'



# --- Better Prompt ---

function7FFA824F_5204_4508_B0FD_1AD917064BCF() {
    local loader_path="$ZDOTDIR/functions.zsh.d/delayed-script-loader.zsh"
    if [[ -z "$__SOURCED_DELAYED_SCRIPT_LOADER" ]]; then
        if [[ -f "$loader_path" ]]; then
            source_once "$loader_path"
        else
            echo "[delayed-script-loader] File not found: $loader_path" >&2
        fi
    fi
    
    export ZSH_DEBUG="false"
}

alias enable-dsc='function7FFA824F_5204_4508_B0FD_1AD917064BCF'

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"



if [[ "${ZLOADING:-}" == ".zshenv" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
    print -n -P "[%F{#444}skip env%f(%F{white}%D{%S.%3.}%f)]"
    return 0
fi

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

if [[ -o interactive ]]; then
    # MARK: Start of Preflight check
    # ? Uncomment to disable preflight load check
    # export SKIP_PREFLIGHT_LOAD_CHECK=0
    # echo -e "✅ INTERACTIVE
    # l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"
    # ? MARK: End of Preflight check
    
    export ZLOADING=".zshenv"
    export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
    
    # For Zplug
    # export ZPLUG_HOME=/usr/local/opt/zplug
    
    # export ZSH_DEBUG="true"
    export ZSH_DEBUG="false"
    
    # Load immediately:
    source_once "${ZDOTDIR}/functions.zsh"
    source_once "${ZDOTDIR}/variables.zsh"
    source_once "${ZDOTDIR}/aliases.zsh"
    source_once "${ZDOTDIR}/keybindings.zsh"
    source_once "${ZDOTDIR}/paths.zsh"
    
    # For completions
    zmodload zsh/complist
    zstyle ':completion:*' completer _complete
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*' debug yes
    autoload -Uz compinit
    # `compinit` **before** the completion... who knows?... who cares?
    compinit
    source_once "${ZDOTDIR}/completions.zsh"
    
    export ZSH_DEBUG="false"
    # For Zplug
    source_once $ZPLUG_HOME/init.zsh
    plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
    
    # Lazy loaded:
    # source_once "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh"
    
    
    
    if command -v code >/dev/null 2>&1; then
        export VSCODE_SUGGEST=1
    fi
fi



