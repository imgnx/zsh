#!/bin/zsh
# shellcheck disable=SC1071

# Avoid "defining function based on alias 'ls'" warnings by clearing any alias first.
unalias ls 2>/dev/null

# Only engage when SCREENCAST_MODE is explicitly on (1/on/true). Default (-1/0/empty) keeps it off.
if [[ "$SCREENCAST_MODE" == "1" || "$SCREENCAST_MODE" == "on" || "$SCREENCAST_MODE" == "true" ]]; then
    ls() {
        printf "\033[38;5;8mScreencast Mode is currently \033[38;5;10mon\033[38;5;8m."
        echo "Are you sure you want to display the contents of \`ls\`?"
        read -r confirmation
        if [[ "$confirmation" != "yes" && "$confirmation" != "y" ]]; then
            printf "\033[38;5;9mExiting \`ls\` command.\033[0m"
            return 1
        else
            eza --color=always --group-directories-first --icons
        fi
    }
fi
