#!/bin/zsh

autoload -Uz compinit
compinit

# 1. Define the completion function
_complete_my_dir() {
  _files -W $XDG_CONFIG_HOME
}

# 2. Register the completion for your command
compdef _complete_my_dir cnf

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
