#!/bin/zsh


# print -P -n "[%F{green}completions%f]"


# Custom completion for cd'ing into first-level directories
# cd_first_level() {
# local -a dirs
# dirs=(${(f)$(printf '%s\n' */ 2>/dev/null)})
# compadd -S '' -- ${(R)dirs%.}
# }
# compdef cd_first_level cd

# echo "compdef cd_first_level cd"

# Ensure compinit is run before compdef
# if [[ -n "$ZSH_VERSION" ]]; then
#     # ! Sourced in .zshenv
#     # if ! whence compdef >/dev/null; then
#     #     autoload -Uz compinit
#     # fi

#     compdef cd_first_level cd
# else
#     echo "This completion script requires Zsh and compdef."
# fi
