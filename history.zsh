# ~/.config/zsh/history.zsh
# ----------------------------------------
# Centralized Zsh history configuration
# ----------------------------------------

# Base directories (XDG-compliant fallback)
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

# Where to keep history
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=50000       # number of lines kept in memory
export SAVEHIST=50000       # number of lines saved to file

# Create dirs and file if missing
mkdir -p "${XDG_STATE_HOME}/zsh"
[[ -e $HISTFILE ]] || touch "$HISTFILE"
chmod 600 "$HISTFILE" 2>/dev/null || true

# Core history behavior
setopt APPEND_HISTORY            # append to file, don't overwrite
setopt INC_APPEND_HISTORY_TIME   # write immediately (with timestamps)
setopt EXTENDED_HISTORY          # timestamps + durations
setopt HIST_IGNORE_DUPS          # ignore immediate duplicates
setopt HIST_IGNORE_ALL_DUPS      # drop older duplicates
setopt HIST_REDUCE_BLANKS        # trim spaces
setopt HIST_SAVE_NO_DUPS         # avoid writing duplicates to file
setopt HIST_VERIFY               # confirm !expansions before exec
setopt HIST_BEEP                 # beep on failed history expansion
setopt NO_NOMATCH                # avoid errors on unmatched globs

# Optional live merge between terminals (comment out if distracting)
# setopt SHARE_HISTORY

# Disable macOS per-window session history override
export SHELL_SESSIONS_DISABLE=1

# Ensure this shell session uses the chosen file
fc -p "$HISTFILE"

# Helper aliases
alias hist-save='fc -W'
alias hist-load='fc -R'
alias hist-flush='fc -W; fc -R; echo "↻ history flushed & reloaded"'
