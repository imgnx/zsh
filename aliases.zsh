# shellcheck shell=bash

print -n -P "[%F{#202020}aliases%f]"

# ============================
# Aliases
# ============================



alias 0bsd="license"
alias b="cd ~/bin"
alias bkgd='afplay "$BKGD" &'
alias cash="$money"
alias cdspc='codespace'
alias cnt="cd ~/src"
alias d="dirs -v | head -n 10"
alias dw="$DOWNLOADS"
alias dwn="$DOWNLOADS"
alias edit='emacs'
alias e='emacs'
alias git-branch="git branch -v"
alias git-remote="git remote -v"
alias icloud=$ICLOUD_DRIVE
alias i=$ICLOUD_DRIVE
alias la='eza --long --all --group --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
alias ld='eza -1 --color=always --group-directories-first --icons'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lh="eza -a | grep -E '^\.'"
alias l.="eza -a | grep -E '^\.'"
alias m='"$MEDIA"'
alias money='"$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"'
alias pro="edit $ZDOTDIR/.zprofile"
alias rp=realpath
alias sam=$SAMPLES
alias scr=$SCRIPTS
alias sexy="open https://terminal.sexy/"
alias s='cd ~/src'
alias resrc="source $ZDOTDIR/.zshrc"
alias sync_icloud="isync"
alias t='cd ~/test'
alias tk=$TAKU
alias wkbn='"$WORKBENCH"'
alias WKBN='"$WORKBENCH"'
alias WK_PATH="$WORKBENCH"
alias WORKSPACE="$WORKBENCH"
alias x="sexy"
alias xdg-open="open"
alias xrc="exec zshrc"

# .zshrc.save
alias h='history'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ============================
# Screencast Mode Aliases
# ============================
if [ "$SCREENCAST_MODE" = 1 ]; then
    # Screencast mode - clean, minimal output
    alias erc="code $ZDOTDIR/.zshrc"
    # alias ls='eza --color=always --group-directories-first --icons && echo "\033[38;5;8mScreencast Mode is currently \033[38;5;10mon\033[38;5;8m. \`ls\` is configured to display all files and folders.\033[0m"'
    alias df='df -h'
    # alias du='du -h'
    # alias ps='ps aux'
    alias top='top -o cpu'
else
    # Normal mode - verbose, detailed output with all information
    alias erc="emacs $ZDOTDIR/.zshrc"
    # alias ls='eza -all --color=always --group-directories-first --icons --long --header --git --time-style=long-iso && echo "\033[38;5;3mScreencast Mode\033[0m is currently \033[38;5;9moff\033[0m"'
    alias df='df -ahicY'                                          # All filesystems, human readable, inodes, show type
    # alias du='du -ahd1'                                           # All files, human readable, max depth 1
    # alias ps='ps auxww'                                           # Wide output with full command lines
    alias top='top -o cpu -stats pid,command,cpu,mem,pstate,time' # Detailed process info
    alias free='vm_stat'                                          # Memory usage details on macOS
    alias netstat='netstat -tuln'                                 # Network connections with details
    alias mount='mount | column -t'                               # Formatted mount points
    alias env='env | sort'                                        # Sorted environment variables
    alias history='fc -l 1'                                       # Full history
    alias grep='grep --color=auto -n'                             # Line numbers and color
    alias tree='eza --tree -a --level=3 --color=always --group-directories-first --icons --long'
fi

# ============================
# Prompt and Hook Management
# ============================
alias clean-precmd="precmd_functions=()"
alias list-precmd="echo 'precmd_functions:'; printf '%s\n' \"\${precmd_functions[@]}\""
alias list-hooks="echo 'All hooks:'; echo 'precmd:' \"\${precmd_functions[@]}\"; echo 'preexec:' \"\${preexec_functions[@]}\"; echo 'periodic:' \"\${periodic_functions[@]}\""

alias imgnxlog=" 70960C40-F14F-49E5-ABE6-EACEAE25F79B $@"
alias imgnxlog=" 70960C40-F14F-49E5-ABE6-EACEAE25F79B $@"
