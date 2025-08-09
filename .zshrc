# Always set ZLOADING for session tracking

# Early exit if skipping preflight
if [[ "${ZLOADING:-}" == ".zshrc" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
	print -n -P "[%F{#444}skip rc%f(%F{white}%D{%S.%3.}%f)]"
	return 0
fi

if [[ -o interactive ]]; then
	export ZLOADING=".zshrc"
	echo -e "✅ INTERACTIVE │ l: [\033[38;5;207;3;4m${ZLOADING:-.zshrc}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"
else
	export ZLOADING=".zshrc"
fi

# Early exit for tabula rasa mode
if [[ -n "$TABULA_RASA" && "$TABULA_RASA" -eq 1 ]]; then
	echo "Tabula Rasa mode is enabled. No configurations will be loaded."
	return 0
fi

# Ensure compinit is loaded for completions and compdef
autoload -Uz compinit
compinit -u

# History settings
HISTFORMAT="%F{blue}%n@%m:%~%f %(!.#.$) %F{green}[%*]%f %F{yellow}%B%?%b%f %F{red}[%?]%f"
HISTFILE="$XDG_STATE_HOME/zsh/zsh_history"
HISTSIZE=5000
SAVEHIST=5000
HISTFILESIZE=5000

# History options for search and behavior
setopt HIST_FIND_NO_DUPS    # Don't show duplicates in history search
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries
setopt HIST_IGNORE_SPACE    # Don't save commands that start with space
setopt HIST_SAVE_NO_DUPS    # Don't write duplicates to history file
setopt HIST_VERIFY          # Show command with history expansion before running
setopt INC_APPEND_HISTORY   # Append to history file immediately
setopt SHARE_HISTORY        # Share history between all sessions
setopt EXTENDED_HISTORY     # Save timestamp and duration

# Zinit setup
# ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# . "${ZINIT_HOME}/zinit.zsh"

# Cargo and Zsh profile/login

# Local IP address (cached)
if [[ -z "$LOCAL_IP" ]]; then
	LOCAL_IP=$(ipconfig getifaddr en2 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo 127.0.0.1)
fi

# Cache directory setup
CACHE_DIR="$HOME/tmp"
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"
SYSLINE_CACHE="$CACHE_DIR/sysline_cache"
[[ ! -f $SYSLINE_CACHE ]] && touch $SYSLINE_CACHE

# Create .gitignore if missing
if [[ ! -f "$HOME/.config/.gitignore" ]]; then
	cat <<'EOF' >"$HOME/.config/.gitignore"
# Emacs (Doom, Spacemacs, etc)
emacs/.git/
emacs/.gitmodules
emacs/.cache/
emacs/.local/
emacs/straight/
emacs/.emacs.d/

# VS Code
Code/User/globalStorage/
Code/User/workspaceStorage/

# Other junk
**/*.pyc
__pycache__/
*.log
tmp/
EOF
fi

# | Glyph | Unicode | Name                 | Meaning                               |
# | ----- | ------- | -------------------- | ------------------------------------- |
# | `│`   | U+2502  | Vertical Line       | Used for vertical separation          |
# | `─`   | U+2500  | Horizontal Line     | Used for horizontal separation        |
# | `┌`   | U+250C  | | Top Left Corner    | Used for top-left corner of boxes     |
# | `┐`   | U+2510  | Top Right Corner     | Used for top-right corner of boxes    |
# | `└`   | U+2514  | Bottom Left Corner   | Used for bottom-left corner of boxes   |
# | `┘`   | U+2518  | Bottom Right Corner  | Used for bottom-right corner of boxes  |
# | `┬`   | U+252C  | Top T-Intersection   |                                       |
# | `┴`   | U+2534  | Bottom T-Intersection|                                       |
# | `├`   | U+251C  | Left T-Intersection  | Used for left-side transitions         |
# | `┤`   | U+251E  | Right T-Intersection | Used for right-side transitions        |
# | `┼`   | U+253C  | Cross T-Intersection | Used for intersections in boxes        |
# | `┏`   | U+250F  | Top Left Box Corner  | Used for top-left corner of boxes     |
# | `┓`   | U+2513  | Top Right Box Corner | Used for top-right corner of boxes    |
# | `┗`   | U+2517  | Bottom Left Box Corner | Used for bottom-left corner of boxes |
# | `┛`   | U+251B  | Bottom Right Box Corner| Used for bottom-right corner of boxes|
# | `┝`   | U+252D  | Left Box T-Intersection| Used for left-side transitions      |
# | `┥`   | U+2525  | Right Box T-Intersection| Used for right-side transitions     |
# | `┯`   | U+2530  | Top Box T-Intersection | Used for top-side transitions       |
# | `┷`   | U+2537  | Bottom Box T-Intersection| Used for bottom-side transitions   |
# | `┸`   | U+2538  | Bottom Box T-Intersection | Used for bottom-side transitions   |
# | `┰`   | U+E2520  | Top Box T-Intersection | Used for top-side transitions       |
# | ``   | U+E0B0  | Right Separator      | Used to separate prompt segments      |
# | ``   | U+E0B1  | Thin Right Separator |                                       |
# | ``   | U+E0B2  | Left Separator       | For left-side transitions             |
# | ``   | U+E0B3  | Thin Left Separator  |                                       |
# | ``   | U+E0A0  | Branch               | Indicates Git branch                  |
# | `≈`   | U+E0BA  | Left-facing Chevron  |
# | ``   | U+E0B8  | Right-facing Chevron |
# | ``   | U+E0BA  | Left-facing Chevron  |                                       |
# | ``   | U+E0BC  | Right-facing Chevron |                                       |
# | ``   | U+E0BD  | Left-facing Chevron |                                       |
# | ``   | U+E0BE  | Right-facing Chevron |                                       |
# | `` | U+E0BF  | Left-facing Chevron |                                       |
# | ` ` | U+E0C0  | Right-facing Chevron |                                       |

IFS=$' \t\n'

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh


plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

