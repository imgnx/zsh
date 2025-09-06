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

    # Ensure XDG variables are set before mkdir
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

    # Quality-of-life: allow typing a directory name to cd into it
    setopt AUTO_CD
    
        # Load immediately:
    source_once "${ZDOTDIR}/functions.zsh"
    echo "Sourced functions.zsh"
    source_once "${ZDOTDIR}/variables.zsh"
    source_once "${ZDOTDIR}/aliases.zsh"
    source_once "${ZDOTDIR}/keybindings.zsh"
    # paths.zsh duplicates variables; avoid double-sourcing by default
    # source_once "${ZDOTDIR}/paths.zsh"

    # # Normalize EMACS_* to proper XDG paths if unset or broken (e.g., '/emacs*')
    # [[ -z ${EMACSDIR:-}         || -z ${EMACSDIR:#/emacs*}         ]] && export EMACSDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs"
    # [[ -z ${EMACS:-}            || -z ${EMACS:#/emacs*}            ]] && export EMACS="${EMACSDIR}"
    # [[ -z ${EMACS_DIR:-}        || -z ${EMACS_DIR:#/emacs*}        ]] && export EMACS_DIR="${EMACSDIR}"
    # [[ -z ${EMACS_CONFIG_DIR:-} || -z ${EMACS_CONFIG_DIR:#/emacs*} ]] && export EMACS_CONFIG_DIR="${EMACSDIR}"
    # [[ -z ${EMACS_CACHE_DIR:-}  || -z ${EMACS_CACHE_DIR:#/emacs*}  ]] && export EMACS_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/emacs"
    # [[ -z ${EMACS_SAVEDIR:-}    || -z ${EMACS_SAVEDIR:#/emacs*}    ]] && export EMACS_SAVEDIR="${XDG_STATE_HOME:-$HOME/.local/state}/emacs"
    # [[ -z ${EMACS_BACKUP_DIR:-} || -z ${EMACS_BACKUP_DIR:#/emacs*} ]] && export EMACS_BACKUP_DIR="${EMACS_SAVEDIR}/backup"
    # [[ -z ${EMACS_TRASH_DIR:-}  || -z ${EMACS_TRASH_DIR:#/emacs*}  ]] && export EMACS_TRASH_DIR="${EMACS_SAVEDIR}/trash"
    # [[ -z ${EMACS_SAVES_DIR:-}  || -z ${EMACS_SAVES_DIR:#/emacs*}  ]] && export EMACS_SAVES_DIR="${EMACS_SAVEDIR}/saves"
    # [[ -z ${EMACS_LISP_DIR:-}   || -z ${EMACS_LISP_DIR:#/emacs*}   ]] && export EMACS_LISP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/emacs/site-lisp"
    # [[ -z ${EMACS_DUMP_FILE:-}  || -z ${EMACS_DUMP_FILE:#/emacs*}  ]] && export EMACS_DUMP_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/emacs/auto-save-list/.emacs.dumper"
    # [[ -z ${DOOMDIR:-}          ]] && export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
    # [[ -z ${DOOMLOCALDIR:-}     || -z ${DOOMLOCALDIR:#/emacs*}     ]] && export DOOMLOCALDIR="${XDG_CONFIG_HOME:-$HOME/.config}/emacs/.local"

    #     # Ensure expected cache/state dirs exist (Emacs/Doom + Zsh + common XDG)
    #     mkdir -p \
    #         "${DOOMLOCALDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/emacs/.local}" \
    #         "${EMACS_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/emacs}" \
    #         "${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/cache}" \
    #         "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" \
    #         "${XDG_CONFIG_HOME:-$HOME/.config}/npm" "${XDG_CACHE_HOME:-$HOME/.cache}/npm" "${NPM_CONFIG_PREFIX:-${XDG_DATA_HOME:-$HOME/.local/share}/npm}" \
    #         "${XDG_CACHE_HOME:-$HOME/.cache}/yarn" "${PNPM_STORE_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/pnpm}" "${PNPM_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/pnpm}" \
    #         "${GOPATH:-${XDG_DATA_HOME:-$HOME/.local/share}/go}" "${GOCACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/go}" "${GOMODCACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/go/mod}" \
    #         "${XDG_CONFIG_HOME:-$HOME/.config}/aws" "${XDG_CONFIG_HOME:-$HOME/.config}/gcloud" "${XDG_CONFIG_HOME:-$HOME/.config}/gh" "${XDG_CONFIG_HOME:-$HOME/.config}/docker" \
    #         "${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep" \
    #         "$(dirname "${LESSHISTFILE:-${XDG_STATE_HOME:-$HOME/.local/state}/less/history}")" "$(dirname "${NODE_REPL_HISTORY:-${XDG_STATE_HOME:-$HOME/.local/state}/node/repl_history}")"

    # # Create a default ripgrep config if missing to avoid startup errors
    # if [[ ! -f "${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/ripgreprc}" ]]; then
    #   : > "${RIPGREP_CONFIG_PATH:-$XDG_CONFIG_HOME/ripgrep/ripgreprc}"
    # fi
    
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
