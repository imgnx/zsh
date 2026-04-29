#!/bin/zsh

autoload -Uz compinit
compinit
zmodload zsh/complist

# Use menu selection so Tab/Shift-Tab and arrow keys can walk completion lists.
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M emacs '^[[Z' reverse-menu-complete
bindkey -M viins '^[[Z' reverse-menu-complete

# 1. Define the completion function
_complete_my_dir() {
  _files -W $XDG_CONFIG_HOME
}

# 2. Register the completion for your command
compdef _complete_my_dir cnf

# mods completion: list files/dirs under $MODULES/BARE
_complete_mods_dir() {
  local base="${MODULES:-$HOME/src}/BARE"
  _files -W "$base"
}
compdef _complete_mods_dir mods

_complete_module_nav_dir() {
  local name="${service:-${words[1]}}"
  local resolved="${MODULE_NAV_ALIASES[$name]:-$name}"
  local module_name="${MODULE_NAV_MODULES[$resolved]}"
  local base="${MODULES:-${DINGLEHOPPER:-$HOME/src/dinglehopper}/modules}/$module_name"

  [[ -n "$module_name" ]] || return 1

  _wanted "${resolved}-dirs" expl "directory in \$${module_name}" \
    _path_files -W "$base" -/
}
compdef _complete_module_nav_dir bare worktrees codespaces wt cs

# Codex prompt completion: `codex /prompts:<TAB>` lists files under ~/.config/codex/prompts.
_codex_prompt_complete() {
  local prompts_dir="${XDG_CONFIG_HOME:-$HOME/.config}/codex/prompts"
  local prefix="/prompts:"
  local cur="${words[CURRENT]}"
  local -aU prompt_files filtered

  setopt local_options extended_glob null_glob
  if [[ $cur == ${prefix}* ]]; then
    [[ -d $prompts_dir ]] || return 1
    prompt_files=(${prompts_dir}/**/*(.N:t))
    for file in $prompt_files; do
      case "$file" in
        *~|*\#) ;; # skip backups
        *) filtered+="$file" ;;
      esac
    done
    prompt_files=($filtered)
    (( ${#prompt_files} )) || return 1
    _wanted prompts expl 'codex prompt' \
      compadd -Q -P "$prefix" -M 'r:|.=* r:|=*' -- $prompt_files
    return
  fi

  # Hint the prefix and fall back to default completion for other args.
  compadd -Q -- "$prefix"
  _default
}
compdef _codex_prompt_complete codex

# SET_THEME completion: files anywhere, but prefer .themefile names.
_set_theme_files() {
  _files -g "*.themefile"
}
compdef _set_theme_files SET_THEME
