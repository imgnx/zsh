#!/bin/zsh
# shellcheck disable=all

# Shared helpers for defining hook functions that are autoloaded from hooks.
# Usage:
#   register_autoload_hook chpwd chpwd_automx
# …where hooks/chpwd_automx contains the hook implementation.

autoload -Uz add-zsh-hook

: "${ZSH_HOOKS_DIR:=${ZDOTDIR}/hooks}"
[[ -d "$ZSH_HOOKS_DIR" ]] || mkdir -p "$ZSH_HOOKS_DIR"

# Ensure our hook functions are discoverable by autoload.
if [[ -z ${(M)fpath:#$ZSH_HOOKS_DIR} ]]; then
    fpath=("$ZSH_HOOKS_DIR" $fpath)
fi

# register_autoload_hook <hook-name> <function-name>
# Adds <function-name> to the requested zsh hook, autoloading from hooks.
register_autoload_hook() {
    local hook_name="$1"
    local fn_name="$2"

    [[ -z "$hook_name" || -z "$fn_name" ]] && return 1

    autoload -Uz "$fn_name"
    add-zsh-hook "$hook_name" "$fn_name"
}

# Example: automatically run ./.automx when entering a directory.
register_autoload_hook chpwd chpwd_automx
register_autoload_hook chpwd chpwd_breadcrumbs
