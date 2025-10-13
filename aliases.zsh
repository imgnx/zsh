# alias emacs='emacs --init-directory=$XDG_CONFIG_HOME/emacs'
# alias taku="cd $TAKU" # Now a setup.sh as a function
# alias tr="tabula_rasa"
# Normal mode - verbose, detailed output with all information
# Only define aliases here. No functions or script sourcing.

alias rest="reset"
alias rset="reset"
alias rs="reset"
alias r="reset"

# alias src="cd $SRC"
# alias dh="cd $DINGLEHOPPER"
# alias triage="cd $DINGLEHOPPER/triage"
# alias srv="cd $DINGLEHOPPER/srv"


alias .......='cd ../../../../../..'
alias ......='cd ../../../../..'
alias .....='cd ../../../..'
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias 0bsd="license"
alias acp="git add-commit-push --no-verify"
alias backend='cd "$SRC/dinglehopper/src/backend"'
alias be='cd "$SRC/dinglehopper/src/backend"'
alias bend='cd "$SRC/dinglehopper/src/backend"'
alias bin='cd "$BIN"'
alias bk="back_up"
alias bkgd='afplay "$BKGD" &'
alias bkup="back_up"
alias btldr="doom /Users/donaldmoore/.config/_____CONFIG.JSON_HOOMAN_BOOTLOADER"
alias c=copy
alias cache='cd "$XDG_CACHE_HOME"'
alias cash="$money"
alias cc="copy"
alias cdspc='codespace'
alias clean-precmd="precmd_functions=()"
alias cli='cd "$SRC/dinglehopper/src/cli"'
alias cnt='cd "$HOME/src"'
alias copycat="copy"
alias data='cd "$XDG_DATA_HOME"'
# Keep a single df alias
alias df='df -h'
alias dw="$DOWNLOADS"
alias dwn="$DOWNLOADS"
alias e='emacs'
alias edit='emacs'
alias env='env | sort' # Sorted environment variables
alias fe='cd "$SRC/dinglehopper/src/frontend"'
alias fend='cd "$SRC/dinglehopper/src/frontend"'
alias fnx="emacs $XDG_CONFIG_HOME/zsh/functions.zsh"
alias free='vm_stat' # Memory usage details on macOS
alias frontend='cd "$SRC/dinglehopper/src/frontend"'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias git-branch="git branch -v"
alias git-remote="git remote -v"
alias gl='git pull'
alias gp='git push'
# alias grep='rg -p' # Promoted to function
alias gs='git status'
alias h='history'
alias history='fc -l 1' # Full history
alias i=$ICLOUD_DRIVE
alias icloud=$ICLOUD_DRIVE
alias imgnxlog=" 70960C40-F14F-49E5-ABE6-EACEAE25F79B $@"
alias jsh='jsh || cd "$JSH"'
unalias eza 2>/dev/null
eza() { command eza --icons "$@"; }
alias l="eza"
alias l.="eza './.??*'" # l. (you might see a bullet point because of a common ligature)
alias la='eza --long --all -bGF --header --git --color=always --group-directories-first --icons'
alias labs='cd "$LABS"'
alias ld='eza -1 --color=always --group-directories-first --icons'
alias lh="eza -a | grep -E '^\.|^total'"
alias lib='cd "$LIB"'
alias list-hooks="echo 'All hooks:'; echo 'precmd:' \"\${precmd_functions[@]}\"; echo 'preexec:' \"\${preexec_functions[@]}\"; echo 'periodic:' \"\${periodic_functions[@]}\""
alias list-precmd="echo 'precmd_functions:'; printf '%s\n' \"\${precmd_functions[@]}\""
# Keep the more detailed ll variant (octal-permissions)
alias ll='eza -la --octal-permissions --group-directories-first'
# Remove duplicate llm (icons are provided globally)
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first'
unalias ls 2>/dev/null
ls() {
    if [[ " $* " == *" -l "* || " $* " == *" l "* ]]; then
        eza -bGF --header --git --color=always --group-directories-first --long "$@"
    else
        eza -bGF --header --git --color=always --group-directories-first "$@"
    fi
}
alias lsd.="eza -d -a | grep -E '^\.'"
alias lsd='eza -d --color=always --group-directories-first --icons'
alias lsdh.="eza -d -a | grep -E '^\.'"
alias lsdh="eza -d | grep -E '^\.'"
# Remove duplicate lx (icons are provided globally)
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first'
alias m='"$MEDIA"'
alias mkdir='mkdir -p'
alias money='"$HOME/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"'
alias mount='mount | column -t' # Formatted mount points
alias mx="code -r $XDG_CONFIG_HOME/hammerspoon/init.lua"
alias netstat='netstat -tuln' # Network connections with details
# alias p="$v"
# alias pastecat="$v"
# alias pc="$v"
alias pcnf="doom /Users/donaldmoore/.config/_____CONFIG.JSON_HOOMAN_BOOTLOADER"
alias p="python3"
alias pins=". ./.venv/bin/activate"
alias pi="ssh pi@zero2w.local"
alias pip="python -m pip"
alias rl="readlink"
alias rp=realpath
alias rt='cd "$XDG_RUNTIME_DIR"'
alias s='cd "$HOME/src"'
alias sam=$SAMPLES
alias samples='cd "/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/Media/_____SAMPLES"'
alias scr=$SCRIPTS
alias sexy="open https://terminal.sexy/"
alias src='cd "$SRC"'
alias state='cd "$XDG_STATE_HOME"'
alias stdln='cd "$HOME/src/dinglehopper/stdln/"'
alias SURGE="$HOME/Library/Containers/com.apple.garageband10/Data/Documents/Surge XT/Patches/Templates"
alias surge='cd "$SURGE"'
# Spicy system sampler
alias sync_icloud="isync"
alias t='cd "$HOME/test"'
alias tabula="tabula_rasa"
alias test='cd "$TEST"'
alias tk=$TAKU
alias tmp='cd "$HOME/tmp"'
alias todo='cd "$HOME/Documents/ChalkBox/"'
# Keep the simpler top alias; adjust if you prefer detailed stats
alias top='top -o cpu'
alias uls="/bin/ls"
alias v="$v"
alias wk='cd "$SRC/__CODE_WORKSPACE__"'
alias x="sexy"
alias xdg-open="open"
alias xdg='cd "$XDG_CONFIG_HOME"'
