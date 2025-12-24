#!/bin/zsh

autoload -Uz compinit
compinit

# 1. Define the completion function
_complete_my_dir() {
  _files -W $XDG_CONFIG_HOME
}

# 2. Register the completion for your command
compdef _complete_my_dir cnf

