# shellcheck shell=zsh
if [[ -o interactive ]]; then
    curr=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
    diff="$((curr - IMGNXZINIT))"
    if [[ diff -gt 1000 ]]; then
        diff="%F{yellow}$(printf "%d.%03d" "$((diff / 1000))" "$((diff % 1000))")%f"
    elif [[ diff -gt 300 ]]; then
        diff="%F{green}$(printf "%dms" "$diff")%f"
    else
        diff="%F{magenta}$(printf "%dms" "$diff")%f"

    fi
    # print -n -P "[%F{green}.zlogin%f]"
fi

if [[ -o interactive ]]; then
    # Banner
    echo -e "\033[38;5;5m"

    cat <<EOF
+──                               
┌──┐ ─── ── ───── ──── ───  ───
│  │ 
│  │  │           │  │     
└──┘──┴──╲        ╱──┴──┴──    
          ╲      ╱       ╱    

EOF
    echo -e "\033[0m"
fi
print -P "l: [$diff]"

export ZSH_TRACE="$XDG_CONFIG_HOME/zsh/logs/zsh-exec.log"

export PATH="$IMGNX_PATH"

cloudflared -v

source $ZDOTDIR/completions.zsh
