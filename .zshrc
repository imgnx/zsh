if [[ -o interactive ]]; then
    print -n -P "[%F{green}.zshrc loaded at %D{%Y-%m-%d %H:%M:%S}%f]"
fi

if [[ -n "$TABULA_RASA" && "$TABULA_RASA" -eq 1 ]]; then
    echo "Tabula Rasa mode is enabled. No configurations will be loaded."
    return 0
fi

# Debugging: Log when .zshrc is loaded

# Autoload Zsh modules
autoload -Uz colors && colors
autoload -Uz add-zsh-hook

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

# Better prompt with fixed slash and dimmed path
# Update prompt dynamically on every directory change

AAA52195_7126_4ECB_90D6_BCE64B3E0A5F() {
    PS1='%n%F{magenta}@%f'$LOCAL_IP'
%F{'$(
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            if git diff --quiet --cached &>/dev/null && git diff --quiet &>/dev/null; then
                echo green # All changes are committed and pushed
            elif git diff --quiet --cached &>/dev/null; then
                echo yellow # All changes are staged but not committed
            else
                echo red # Some changes are not staged
            fi
        else
            echo "#444" # Not in a Git repository
        fi
    )'}%f %F{magenta}'$(dirname "$PWD" | sed 's|\(.*\)\(.\{20\}\)$|…\2|' || echo '')'%f%F{yellow}'/$(basename "$PWD")'%f%F{cyan} =>%f '
}

# Cache directory setup
CACHE_DIR="$HOME/tmp"
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"
SYSLINE_CACHE="$CACHE_DIR/sysline_cache"
[[ ! -f $SYSLINE_CACHE ]] && touch $SYSLINE_CACHE

# --- Interactive-Only ---
if [[ -o interactive ]]; then
    # Banner
    echo -e "\033[38;5;5m"

    cat <<EOF
+__                               
┌  ┐ ___     _____ ____ ___  ___
│  │/   │__ /  ___\    \\\\  \/  /
│  │  │    +  /_/   │  │     
└──┘──│──\  \     /──│──│──/\  \\
          \──────/           \──\\
EOF
    echo -e "\033[0m"

    # Hooks
    if ! [[ "${precmd_functions[*]}" == *_IMGNX_* ]]; then
        if typeset -f add-zsh-hook >/dev/null 2>&1; then
            export PERIOD=10
            add-zsh-hook periodic 6D078F25_9FBE_4352_A453_71F7947A3B01
            add-zsh-hook precmd F6596432_CA98_4A50_9972_E10B0EE99CE9
            add-zsh-hook precmd AAA52195_7126_4ECB_90D6_BCE64B3E0A5F
        fi
    fi
fi

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
