if [[ -o interactive ]]; then
  echo -en "\033[38;2;222;173;237m
イエムジーエヌエックス
\033[0m"
fi

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
    
    
    imgnx_debug "[source_once] guarding $(basename "$file") => " # The file itself will respond with a confirmation.
    
    if [[ -f "$file" ]]; then
        . "$file" || { imgnx_debug "[source_once] Error sourcing $file"; }
    else
        imgnx_debug "[source_once] Missing file: $file"
        return 2
    fi
}

alias source_once='function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8'



# --- Better Prompt ---

function7FFA824F_5204_4508_B0FD_1AD917064BCF() {
    local loader_path="$ZDOTDIR/functions.zsh.d/delayed-script-loader.zsh"
    if [[ -z "$__SOURCED_DELAYED_SCRIPT_LOADER" ]]; then
        if [[ -f "$loader_path" ]]; then
            for func in "${ZDOTDIR}/functions.zsh.d/"*.zsh; do
                imgnx_debug "[delayed-script-loader] Sourcing: $(basename "$func")"
                source_once "$func"
            done
        else
            echo "[delayed-script-loader] File not found: $loader_path" >&2
        fi
    fi
    
    export ZSH_DEBUG="false"
}

alias enable-dsc='function7FFA824F_5204_4508_B0FD_1AD917064BCF'

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

if [[ -o interactive ]]; then
    # MARK: Start of Preflight check
    # ? Uncomment to disable preflight load check
    # export SKIP_PREFLIGHT_LOAD_CHECK=0
    # echo -e "✅ INTERACTIVE
    # l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"
    # ? MARK: End of Preflight check
    
    export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"

    # Quality-of-life: allow typing a directory name to cd into it
    setopt AUTO_CD
    
    # Load immediately:
    source_once "${ZDOTDIR}/functions.zsh"
    source_once "${ZDOTDIR}/variables.zsh"
    source_once "${ZDOTDIR}/aliases.zsh"
    source_once "${ZDOTDIR}/keybindings.zsh"
    # paths.zsh duplicates variables; avoid double-sourcing by default
    # source_once "${ZDOTDIR}/paths.zsh"

    # Ensure expected cache/state dirs exist (Emacs/Doom + Zsh + common XDG)
    mkdir -p \
      "${DOOMLOCALDIR:-$XDG_CONFIG_HOME/emacs/.local}" \
      "${EMACS_CACHE_DIR:-$XDG_CACHE_HOME/emacs}" \
      "${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/zsh/cache}" \
      "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" \
      "$XDG_CONFIG_HOME/npm" "$XDG_CACHE_HOME/npm" "${NPM_CONFIG_PREFIX:-$XDG_DATA_HOME/npm}" \
      "$XDG_CACHE_HOME/yarn" "$PNPM_STORE_DIR" "$PNPM_HOME" \
      "$GOPATH" "$GOCACHE" "$GOMODCACHE" \
      "$XDG_CONFIG_HOME/aws" "$XDG_CONFIG_HOME/gcloud" "$XDG_CONFIG_HOME/gh" "$XDG_CONFIG_HOME/docker" \
      "$XDG_CONFIG_HOME/ripgrep" \
      "$(dirname "$LESSHISTFILE")" "$(dirname "$NODE_REPL_HISTORY")"

    # Create a default ripgrep config if missing to avoid startup errors
    if [[ ! -f "${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/ripgreprc}" ]]; then
      : > "${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/ripgreprc}"
    fi
    
    # compinit
    zmodload zsh/complist
    zstyle ':completion:*' completer _complete
    if [[ "${ZSH_COMPLETION_DEBUG:-0}" = "1" ]]; then
        zstyle ':completion:*' verbose yes
        zstyle ':completion:*' debug yes
    else
        zstyle ':completion:*' verbose yes
        zstyle ':completion:*' debug no
    fi
    autoload -Uz compinit
    # Use XDG cache for compdump; ignore insecure dirs
    compinit -i -d "${ZSH_COMPDUMP:-$HOME/.zcompdump}"
    
    # Completions
    source_once "${ZDOTDIR}/completions.zsh"
    
    # For Zplug
    # export ZPLUG_HOME=/usr/local/opt/zplug
    # source_once $ZPLUG_HOME/init.zsh
    # plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
    
    # Lazy loaded:
    # source_once "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh"
    
    # Load user-defined functions
    
    
    if command -v code >/dev/null 2>&1; then
        export VSCODE_SUGGEST=1
    fi
fi
