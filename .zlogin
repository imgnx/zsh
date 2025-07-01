# shellcheck shell=zsh
if [[ -o interactive ]]; then
    print -n -P "[%F{yellow}.zlogin%f]"
fi

# Remove all occurrences of $HOME/bin from PATH
# new_path=$(print -r -- "$PATH" | sed -e "s|$HOME/bin:||g" -e "s|:$HOME/bin||g" -e "s|$HOME/bin||g")

# Prepend $HOME/bin
# export PATH="$HOME/bin:$new_path"

# Optional: echo the result
# echo "PATH updated:"
# echo "$PATH"

export ZSH_TRACE="$XDG_CONFIG_HOME/zsh/logs/zsh-exec.log"
