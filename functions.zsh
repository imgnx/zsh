
__wrap_notice rm
rm() {

    local flags=()
    local files=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -*) flags+=("$1") ;; # Collect flags
            *) files+=("$1") ;;  # Collect file paths
        esac
        shift
    done

    for file in "${files[@]}"; do
        local abs_path="$(realpath "$file" 2>/dev/null)"

        # Check if the file is in any user's .Trash directory
        if [[ "$abs_path" =~ ^/Users/.*/\.Trash/ ]]; then
            /bin/rm "${flags[@]}" "$file" # Call /bin/rm directly if file is in any user's .Trash
            return
        fi

        # Otherwise, move it to the user's .Trash
        if [[ -e "$file" ]]; then
            local trash_path="$HOME/.Trash$abs_path"
            mkdir -p "$(dirname "$trash_path")"

            local mv_output
            local mv_status
            mv_output="$(mv "$file" "$trash_path" 2>&1)"
            mv_status=$?

            if (( mv_status != 0 )); then
                if [[ "${mv_output:l}" == *"resource deadlock avoided"* ]]; then
                    local reply
                    printf "Resource deadlock avoided while moving:\n%s\nUse /bin/rm instead of the wrapper? [Y/n] " "$file" > /dev/tty
                    read -r reply < /dev/tty

                    if [[ -z "$reply" || "$reply" == [Yy] || "$reply" == [Yy][Ee][Ss] ]]; then
                        /bin/rm "${flags[@]}" -- "$file"
                    fi
                else
                    print -u2 -- "$mv_output"
                fi
            fi
        fi
    done

    # If only flags were passed, fallback to system rm
    if [[ ${#files[@]} -eq 0 ]]; then
        /bin/rm "${flags[@]}"
    fi
}



remote() {
    OUT="$(git remote | head -n 1 | awk '{ print $2 }')"
    echo $OUT | pbcopy
    echo "Copied remote ($OUT) to clipboard."
    if [[ $1 == "-o" ]]; then
	open "$OUT"
    else
	echo -e "\033[38;2;255;205;0mPass the -o flag to view remote in a browser.\033[0m"
    fi
}

__wrap_notice open
open () {
    node - "$@" <<'NODE'
let args = process.argv.slice(2)
console.log(args);
NODE
    /usr/bin/open "$@"
}



# Moved to `bin`.
# lookup() {
#     if [[ $1 == "--help" || $1 == "-h" ]]; then
#         echo "lookup

# Regular expression search on hunspell's dictionaries.

# Usage: lookup <regex>"
#     fi
    
#     cat "/Users/donaldmoore/src/dinglehopper/modules/BARE/dict/en_US.words" | grep -Ei "$1"
# }

killtmux() {
    tmux list-sessions | awk '{
print $1
}' | sed s/:$//g | while IFS= read -r line
    do
        tmux kill-session -t $line
    done
}

# Moved to `bin`.
# dict() {
#     echo -e "This function literally just retruns the file. Use \033[48;2;255;205;0mgrep\033[0m or something similar."
#     cat "/Users/donaldmoore/src/dinglehopper/modules/BARE/dict/en_US.words"
# }

source $DINGLEHOPPER/tsrv/bin/tsrv
source "${ZDOTDIR:-$HOME/.config/zsh}/src/__wrap_notice"

autoload -Uz add-zsh-hook

typeset -g TAKU_LAST_DIR_FILE="${TAKU_LAST_DIR_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh/last_pwd}"

save_last_dir() {
    local last_dir_file="${TAKU_LAST_DIR_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh/last_pwd}"
    mkdir -p "${last_dir_file:h}" || return
    print -r -- "$PWD" >| "$last_dir_file"
}

restore_last_dir() {
    [[ "${TAKU_RESTORE_LAST_DIR:-1}" == "0" ]] && return

    local last_dir_file="${TAKU_LAST_DIR_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh/last_pwd}"
    local legacy_last_dir_file="$HOME/tmp/.last_pwd"
    local target=""

    if [[ -r "$last_dir_file" ]]; then
	target="$(<"$last_dir_file")"
    elif [[ -r "$legacy_last_dir_file" ]]; then
	target="$(<"$legacy_last_dir_file")"
    fi

    [[ -n "$target" && -d "$target" ]] || return
    [[ "$PWD" == "$target" ]] && return

    cd "$target"
}

add-zsh-hook chpwd save_last_dir
restore_last_dir

lock() {
    sudo chflags -R uchg "$@"
}

unlock() {
    sudo chflags -R nouchg "$@"
}

hop() {
    before="$PWD"
    after="$(realpath ./)"
    echo -e "\033[38;2;255;205;0mhop: \033[0m$before -> $after"
    cd "$after"
    echo -e "\033[38;2;255;205;0mhop: \033[0m$before -> $after"
}

highlight() {
    echo -e "\033[48;2;255;0;255m\033[38;2;0;0;0m\033[1m$@\033[0m"
}

alias mark="highlight $@"

dusort() {
    du -sh -- ./*(D) | sort -hr | bat --style=plain
}

dh() {
    cd "$DINGLEHOPPER"
}

activate() {
    . ./.venv/bin/activate
}

__wrap_notice reset

reset() {
    /usr/bin/reset && exec zsh -l
}
