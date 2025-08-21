# shellcheck shell=zsh


if [[ -o interactive ]]; then
    diff="$(get_diff)"
    # curr=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
    # diff="$((curr - IMGNXZINIT))"
    # if [[ diff -gt 1000 ]]; then
    #     diff="%F{yellow}$(printf "%d.%03d" "$((diff / 1000))" "$((diff % 1000))")%f"
    #     elif [[ diff -gt 300 ]]; then
    #     diff="%F{green}$(printf "%dms" "$diff")%f"
    # else
    #     diff="%F{magenta}$(printf "%dms" "$diff")%f"
    
    # fi
    # print -n -P "[%F{green}.zlogin%f]"
fi

# if [[ -o interactive ]]; then
#     # Banner
#     echo -e "\033[38;2;222;173;237m"

#     cat <<EOF
# ⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜        ⍜⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜        ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜  ⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜        ⍜⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜      ⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜                 ⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜        ⍜⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜       ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜      ⍜⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜⍜     ⍜⍜       ⍜⍜⍜⍜⍜⍜⍜ ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜        ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜
#   ⍜⍜⍜⍜⍜  ⍜⍜⍜⍜⍜⍜⍜⍜              ⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜⍜   ⍜⍜⍜⍜⍜⍜⍜         ⍜⍜⍜⍜⍜⍜    ⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜
#          ⍜⍜⍜⍜⍜⍜⍜               ⍜⍜⍜⍜⍜⍜⍜⍜     ⍜⍜⍜⍜⍜⍜⍜⍜                               ⍜⍜⍜⍜⍜⍜⍜
# EOF
#     echo -e "\033[0m"
# fi

export ZSH_TRACE="$XDG_CONFIG_HOME/zsh/logs/zsh-exec.log"

# Todo: Dump tracelogs... ?

shelltrace() {
    echo "Tracelog initialized. Output will be saved to ~/zsh-tracelog.txt."
    echo "Waiting..."
    exec zsh -xv 2> ~/zsh-tracelog.txt
    echo "Tracelog complete. Would you like to view it now? (Y/n)
    [ctrl+C] to exit."
    
    read -n answer
    if [[ "$answer" == [Yy] ]]; then
        tail -n 100 "$ZSH_TRACE" | bat --paging=never --theme=ansi --language=zsh
    else
        exit 0
    fi
}


print -P -n "%F{magenta}<shelltrace>%f Loading time: [$diff]"


# Delay execution of enable-dsc until after the prompt is ready

autoload -Uz add-zsh-hook
enable_dsc_after_prompt() {
    enable-dsc
    # Remove the hook after execution to avoid repeated calls
    add-zsh-hook -d precmd enable_dsc_after_prompt
}
add-zsh-hook precmd enable_dsc_after_prompt
