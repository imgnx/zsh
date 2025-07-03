# shellcheck shell=zsh
if [[ -o interactive ]]; then
    print -n -P "[%F{yellow}.zlogin%f]"
fi

export ZSH_TRACE="$XDG_CONFIG_HOME/zsh/logs/zsh-exec.log"
