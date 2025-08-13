
# --- Better Prompt ---
better_prompt() {
    local color branch gitinfo stats stat_parts stat
    color="$(ggs)"
    stats="${IMGNX_STATS:-}"
    
    branch=""
    gitinfo=""
    
    # Git info
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        branch=${$(git rev-parse --abbrev-ref HEAD 2>/dev/null):-no git}
        [[ -n "$branch" && "$branch" != "no git" ]] && branch="/$branch"
        local remote="$(git remote 2>/dev/null)"
        local remote_part=""
        [[ -n "$remote" ]] && remote_part=" $remote"
        gitinfo="%F{$color}${remote_part}%F{#8aa6c0}$branch%f"
    fi
    
    # Compose PS1
    PS1="
"
    [[ -n "$gitinfo" ]] && PS1+="
$gitinfo "
    # card=0
    # if [[ -n "$stats" ]]; then
    #     card=$((card+1))
    #     # Split stats by tabs, colorize each part
    #     stat_parts=("${(@s:\t:)stats}")
    #     for stat in $stat_parts; do
    #         case $card in
    #         1) PS1+=" %F{#FF007B}${stat}%f" ;; # CPU
    #         2) PS1+=" %F{#007BFF}${stat}%f" ;; # RAM
    #         3) PS1+=" %F{#7BFF00}${stat}%f" ;; # Zsh count
    #         *) PS1+=" %F{#fca864}${stat}%f" ;; # Default color
    #         esac
    #         card=$((card+1)) # Increment card for each stat
    #     done
    # fi

    # PS1+="CPU: $(top -l 1 | grep 'CPU usage' | awk '{print $3}' | tr -d '%'), PhysMem: $(top -l 1 | grep 'PhysMem' | awk '{print $2}')"

    PS1+='%F{green}%n@'"${LOCAL_IP}"':%~%f'
    PS1+="
%B%F{#FF007B}$(basename $SHELL) %f%F{#FFFFFF}%m %F{#7BFF00}=>%b
"
    RPS1='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f'
}

# Lazy loader for delayed-script-loader.zsh

autoload -Uz add-zsh-hook
add-zsh-hook precmd better_prompt

function7FFA824F_5204_4508_B0FD_1AD917064BCF() {
    local loader_path="$ZDOTDIR/functions.zsh.d/delayed-script-loader.zsh"
    if [[ -z "$__SOURCED_DELAYED_SCRIPT_LOADER" ]]; then
        if [[ -f "$loader_path" ]]; then
            source "$loader_path"
            typeset -g __SOURCED_DELAYED_SCRIPT_LOADER=1
        else
            echo "[delayed-script-loader] File not found: $loader_path" >&2
        fi
    fi
}

alias enable-dsc='function7FFA824F_5204_4508_B0FD_1AD917064BCF'

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"



if [[ "${ZLOADING:-}" == ".zshenv" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
    print -n -P "[%F{#444}skip env%f(%F{white}%D{%S.%3.}%f)]"
    return 0
fi

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

functionD8EA8FE0_EE54_4EA2_AE42_6692B212B4D5() {
    if [[ "${ZSH_DEBUG:-}" == "true" ]]; then
        echo $@
    fi
}

alias imgnx_debug='functionD8EA8FE0_EE54_4EA2_AE42_6692B212B4D5'

# Guard function to source each file only once
# `source_once`
function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8() {
    local file="$1"
    local guard_var="__SOURCED_$(basename "$file" | tr -c '[:alnum:]_' '_' | tr -s '_')"
    if [[ -z "${(P)guard_var}" ]]; then
        imgnx_debug "1 guard_var is not set if -z \${guard_var} == true"
        imgnx_debug "2 \033[38;5;9m\${guard_var} is set to ${guard_var}\033[0m"
        imgnx_debug "2.1 \${guard_var} is: \033[38;5;9m${(P)guard_var}\033[0m"
        imgnx_debug "2.2 \${file} is: \033[38;5;208m$file\033[0m"
        imgnx_debug "$(set | grep "^__SOURCED_" | sort)"
        typeset -g "$guard_var"=1
        imgnx_debug "3 guard_var should now be 1: \033[38;5;10m$guard_var\033[0m"
        imgnx_debug "4 \$file is: \033[38;5;208m$file\033[0m"
        if [[ -f "$file" ]]; then
            imgnx_debug -e "\033[38;5;11mSourcing: $file\033[0m"
            . "$file" || { [[ "${ZSH_DEBUG:-}" == "true" ]] && imgnx_debug "Error sourcing $file (pipe)"; }
        else
            imgnx_debug -e "\033[38;5;10mFile not found: $file\033[0m"
        fi
    fi
}

alias source_once='function4D17203C_6FD1_49C4_BB6C_D1DB91517FB8'




if [[ -o interactive ]]; then
    # MARK: Preflight check
    # ? Uncomment to disable preflight load check
    # export SKIP_PREFLIGHT_LOAD_CHECK=0
    # echo -e "✅ INTERACTIVE
    # l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"
    # ? MARK: Preflight check
    
    export ZLOADING=".zshenv"
    export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
    
    # Load immediately:
    source_once "${ZDOTDIR}/functions.zsh"
    source_once "${ZDOTDIR}/variables.zsh"
    source_once "${ZDOTDIR}/aliases.zsh"
    source_once "${ZDOTDIR}/keybindings.zsh"
    source_once "${ZDOTDIR}/paths.zsh"
    
    # Lazy loaded:
    # source_once "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh"
    
    export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
    
    if command -v code >/dev/null 2>&1; then
        export VSCODE_SUGGEST=1
    fi
fi


precmd_better_prompt='functionE2BBEF85_0229_4994_AA4A_0E9AD426573'
