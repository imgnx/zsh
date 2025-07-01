#!/bin/zsh
# shellcheck shell=bash

print -n -P "[%F{#202020}functions%f]"

function 70960C40-F14F-49E5-ABE6-EACEAE25F79B() {
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/imgnxlogger"
    mkdir -p "$cache_dir"
    local log_file="$cache_dir/$(date +'%Y-%m-%d').log"
    printf '[%s] %s\n' "$(date +'%F %T')" "$@" >>"$log_file"
}

function d() {
    dirs -v | head -n 10
}

function dna() {
    local dir=$(dirs -v | fzf --reverse | awk '{print $2}')
    echo "DEBUG: dir=$dir"
    [[ -n "$dir" ]] && cd "${dir/#\~/$HOME}"
}

# --- Custom cd wrapper ---
function cd() {
    builtin cd "$@" || return
    __TODO_CACHE[$PWD]=""
    ls
}

typeset -gA __TODO_CACHE

# --- Additional PATHs ---
[[ $PATH != *"$HOME/go/bin"* ]] && export PATH="$HOME/go/bin:$PATH"

# --- Final Prompt Customization ---

# PROMPT="$(local_ip) %n@%m: %~ %(!.#.$)"

function brew() {
    # If first argument is 'link', always use --overwrite
    if [[ "$1" == "link" ]]; then
        shift
        command brew link --overwrite "$@" 2>&1 | sed -e 's/^/🔧 /'
        return $pipestatus[1]
    fi
    command brew "$@" 2>&1 | sed -e 's/^/🔧 /'
    return $pipestatus[1]
}

# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

function uuid() {
    # Generate a UUID and format it to uppercase with underscores
    uuidgen | tr '[:lower:]-' '[:upper:]_' | sed 's/^/MAIN_/'
}

### 🧼 XDG Lint Function
function xdg-lint() {
    echo "🔍 Scanning $HOME for non-XDG config files..."
    local whitelist=(
        ".bashrc" ".zshrc" ".zshenv" ".bash_profile" ".profile" ".gitconfig"
        ".ssh" ".gnupg" ".gnupg2" ".gnome" ".local" ".config" ".cache"
        ".DS_Store" ".Trash" ".mozilla" ".npmrc"
    )

    for file in $HOME/.*; do
        [[ -e "$file" ]] || continue
        local name=${file##*/}
        if [[ ! " ${whitelist[@]} " =~ " ${name} " ]]; then
            echo "⚠️  $name may be violating XDG spec. Consider moving it to:"
            echo "    $XDG_CONFIG_HOME/$name or $XDG_DATA_HOME/$name"
        fi
    done
}

### 𝍔 Smart Diff Wrapper for VS Code
function diff() {
    local arg1
    arg1=$(realpath "$1")
    local arg2
    arg2=$(realpath "$2")

    if [[ -d "$arg1" && -d "$arg2" ]]; then
        # * Directories
        # create an XDG‐style cache directory and file
        local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/diff"
        mkdir -p "$cache_dir"
        local base1=$(basename "$arg1")
        local base2=$(basename "$arg2")
        local cache_file="$cache_dir/${base1}_vs_${base2}.txt"

        # run the recursive, brief diff and tee into the cache
        command diff -qr "$arg1" "$arg2" | tee "$cache_file"

        # report what’s only in arg1 (deleted), only in arg2 (added), and what’s modified
        echo "Deleted (only in $arg1):"
        grep "^Only in $arg1" "$cache_file" | sed "s|Only in $arg1/||"
        echo
        echo "Added   (only in $arg2):"
        grep "^Only in $arg2" "$cache_file" | sed "s|Only in $arg2/||"
        echo
        echo "Modified:"
        grep "^Files .* differ$" "$cache_file" |
            sed -e 's/^Files //' -e 's/ and .* differ$//'
        echo "Would you like to compare differentiating files? (y/n)"
        read -r answer
        if [[ "$answer" != "y" || "$answer" != "Y" ]]; then
            echo "Skipping file comparison."
        fi
        return 0
    elif [[ -f "$arg1" && -f "$arg2" ]]; then
        # * Files
        command code -d -n "$arg1" "$arg2"
    else
        # ! Invalid arguments
        echo "❌ Error: diff expects two files or two directories" >&2
        return 1
    fi
}

truncate_ansi_to_columns() {
    local input="$1"
    local clean visible raw_line result i chr
    clean=$(echo "$input" | sed 's/\x1B\[[0-9;]*[mK]//g')
    local max=${COLUMNS:-80}
    local count=0
    result=""

    i=1
    while [[ $i -le ${#input} && $count -lt $max ]]; do
        chr="${input[i]}"
        if [[ "$chr" == $'\033' ]]; then
            # ANSI escape sequence, copy it entirely
            while [[ "${input[i]}" != "m" && $i -le ${#input} ]]; do
                result+="${input[i]}"
                ((i++))
            done
            result+="${input[i]}"
        else
            result+="$chr"
            ((count++))
        fi
        ((i++))
    done

    echo "$result"
}

function colorize() {
    local AWKDIR="$HOME/.config/zsh/functions"

    case "$1" in
    -b | --background)
        shift
        echo "$*" | gawk -f "$AWKDIR/colorize.bkgd.awk"
        ;;
    -f | --foreground)
        shift
        echo "$*" | gawk -f "$AWKDIR/colorize.fore.awk"
        ;;
    -h | --help)
        echo "Usage: colorize [-b|--background] [-f|--foreground] <text>"
        echo "Options:"
        echo "  -b, --background   Colorize text with background colors"
        echo "  -f, --foreground   Colorize text with foreground colors"
        echo "  -h, --help         Show this help message"
        ;;
    *)
        echo "$*" | gawk -f "$AWKDIR/colorize.fore.awk"
        ;;
    esac
}

visual_length() {
    emulate -L zsh

    # Expand prompt sequences to ANSI, if present
    local expanded=$(print -P -- "$1")

    # Strip ANSI escape codes
    local clean=$(print -r -- "$expanded" | sed $'s/\x1B\\[[0-9;]*[mGKH]//g')

    # Return visual length
    print ${#clean}
}

function isdark() {
    local COLOR="$1"
    # Calculate if color is dark or light
    local R=$((0x$(echo $COLOR | cut -c2-3)))
    local G=$((0x$(echo $COLOR | cut -c4-5)))
    local B=$((0x$(echo $COLOR | cut -c6-7)))
    local LUMINANCE=$((R * 299 + G * 587 + B * 114))
    if ((LUMINANCE < 128000)); then
        # Dark color
        return true
    else
        # Light color
        return false
    fi
}

# Quick hook management
function clean-hooks() {
    echo "Current hooks:"
    echo "  precmd: ${precmd_functions[*]}"
    echo "  preexec: ${preexec_functions[*]}"
    echo "  periodic: ${periodic_functions[*]}"
    echo ""
    echo "To clear hooks, run:"
    echo "  precmd_functions=()"
    echo "  preexec_functions=()"
    echo "  periodic_functions=()"
}
