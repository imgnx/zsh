# alias emacs='emacs --init-directory=$XDG_CONFIG_HOME/emacs'

alias frontend="cd $SRC/dinglehopper/src/frontend"
alias fend="cd $SRC/dinglehopper/src/frontend"
alias fe="cd $SRC/dinglehopper/src/frontend"
alias backend="cd $SRC/dinglehopper/src/backend"
alias bend="cd $SRC/dinglehopper/src/backend"
alias be="cd $SRC/dinglehopper/src/backend"
alias cli="cd $SRC/dinglehopper/src/cli"

# Only define aliases here. No functions or script sourcing.
alias bin="cd $BIN"
alias btldr="doom /Users/donaldmoore/.config/_____CONFIG.JSON_HOOMAN_BOOTLOADER"
alias pcnf="doom /Users/donaldmoore/.config/_____CONFIG.JSON_HOOMAN_BOOTLOADER"
alias jsh="jsh || cd $JSH"
alias labs="cd $LABS"
alias lib="cd $LIB"
alias src="cd $SRC"
# alias taku="cd $TAKU" # Now a setup.sh as a function
alias test="cd $TEST"
alias wk="cd $SRC/__CODE_WORKSPACE__"
alias xdg="cd $XDG_CONFIG_HOME"
alias cache="cd $XDG_CACHE_HOME"
alias data="cd $XDG_DATA_HOME"
alias rt="cd $XDG_RUNTIME_DIR"
alias state="cd $XDG_STATE_HOME"
alias samples='cd "/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/Media/_____SAMPLES"'
alias surge="cd $SURGE"
alias copycat="copy"
alias cc="copy"
alias c=copy
alias pastecat="$v"
alias pc="$v"
alias p="$v"
alias v="$v"
alias ls='eza -bGF --header --git --color=always --group-directories-first --icons'
alias ll='eza -la --icons --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias la='ls -la'
alias ld='eza -1 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"
alias lh="eza -a | grep -E '^\.|^total'"
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lsd='eza -d --color=always --group-directories-first --icons'
alias lsd.="eza -d -a | grep -E '^\.'"
alias lsdh="eza -d | grep -E '^\.'"
alias lsdh.="eza -d -a | grep -E '^\.'"
alias df='df -h'
alias top='top -o cpu'
alias tmp="cd $HOME/tmp"

if [ "$SCREENCAST_MODE" != 1 ]; then
    # Normal mode - verbose, detailed output with all information
    alias _re="_reset"
    alias rest="reset"
    alias _reset="command reset"
    alias .......='cd ../../../../../..'
    alias ......='cd ../../../../..'
    alias .....='cd ../../../..'
    alias ....='cd ../../..'
    alias ...='cd ../..'
    alias ..='cd ..'
    alias 0bsd="license"
    alias bkgd='afplay "$BKGD" &'
    alias cash="$money"
    alias cdspc='codespace'
    alias clean-precmd="precmd_functions=()"
    alias cnt="cd ~/src"
    alias dw="$DOWNLOADS"
    alias dwn="$DOWNLOADS"
    alias e='emacs'
    alias edit='emacs'
    alias ga='git add'
    alias gb='git branch'
    alias gc='git commit'
    alias gco='git checkout'
    alias gd='git diff'
    alias git-branch="git branch -v"
    alias git-remote="git remote -v"
    alias gl='git pull'
    alias gp='git push'
    alias grep='rg'
    alias gs='git status'
    alias h='history'
    alias i=$ICLOUD_DRIVE
    alias icloud=$ICLOUD_DRIVE
    alias imgnxlog=" 70960C40-F14F-49E5-ABE6-EACEAE25F79B $@"
    alias l.="eza -a | grep -E '^\.'"
    alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
    alias la='eza --long --all --group --group-directories-first'
    alias ld='eza -1 --color=always --group-directories-first --icons'
    alias lh="eza -a | grep -E '^\.'"
    alias list-hooks="echo 'All hooks:'; echo 'precmd:' \"\${precmd_functions[@]}\"; echo 'preexec:' \"\${preexec_functions[@]}\"; echo 'periodic:' \"\${periodic_functions[@]}\""
    alias list-precmd="echo 'precmd_functions:'; printf '%s\n' \"\${precmd_functions[@]}\""
    alias ll='eza -la --icons --octal-permissions --group-directories-first'
    alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
    alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
    alias m='"$MEDIA"'
    alias mkdir='mkdir -p'
    alias money='"$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"'
    alias pi="ssh pi@zero2w.local"
    alias pip="python -m pip"
    alias re='reset'                   # alias for reset
    alias refresh='reset'              # alias for reset
    alias reset='reset && exec zsh -l' # reset terminal in interactive mode.
    alias restart='reset'              # alias for reset
    alias rp=realpath
    alias s='cd ~/src'
    alias sam=$SAMPLES
    alias scr=$SCRIPTS
    alias sexy="open https://terminal.sexy/"
    alias SURGE="$HOME/Library/Containers/com.apple.garageband10/Data/Documents/Surge XT/Patches/Templates"
    alias sync_icloud="isync"
    alias t='cd ~/test'
    alias tk=$TAKU
    alias todo="todo.sh"
    # alias tr="tabula_rasa"
    alias tabula="tabula_rasa"
    alias x="sexy"
    alias xdg-open="open"
    alias df='df -ahicY'                                          # All filesystems, human readable, inodes, show type
    alias top='top -o cpu -stats pid,command,cpu,mem,pstate,time' # Detailed process info
    alias free='vm_stat'                                          # Memory usage details on macOS
    alias netstat='netstat -tuln'                                 # Network connections with details
    alias mount='mount | column -t'                               # Formatted mount points
    alias env='env | sort'                                        # Sorted environment variables
    alias history='fc -l 1'                                       # Full history
fi
