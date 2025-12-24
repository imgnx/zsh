# Clean, minimal environment for Codex-only shells.

# Keep ZDOTDIR explicit so child shells stay isolated from the user's profile.
export ZDOTDIR="${ZDOTDIR:-/Users/donaldmoore/.config/zsh/codex-shell}"

# Build a predictable PATH (prefer macOS defaults, then Homebrew, then user bins).
PATH=""
if [[ -x /usr/libexec/path_helper ]]; then
  eval "$(/usr/libexec/path_helper -s)"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
fi
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$HOME/bin:$PATH"
typeset -U path PATH
export PATH

# Isolated history file so the user's history stays untouched.
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/codex-history"
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
mkdir -p -- "${HISTFILE:h}"

# Lightweight defaults shared by interactive and non-interactive shells.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="$LANG"
umask 022
