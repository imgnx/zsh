
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
