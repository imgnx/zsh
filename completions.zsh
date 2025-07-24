echo -e "[\033[38;5;17mcompletions\033[0m]"

# Custom completion for cd'ing into first-level directories
_cd_first_level() {
    local dir
    compadd $(ls -d */)  # Suggest directories at the first level

    if [[ $#words -eq 1 && -d "$1" && $(basename "$PWD") == "$PWD" ]]; then
        # If only one directory name is typed and it exists in the first level, cd into it
        builtin cd "$1"
    fi
}

# Bind the function to the `cd` command
compdef _cd_first_level cd

