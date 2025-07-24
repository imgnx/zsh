#!/bin/bash

function ls() {
    if [ "$SCREENCAST_MODE" ]; then
        printf "\033[38;5;8mScreencast Mode is currently \033[38;5;10mon\033[38;5;8m."
        echo "Are you sure you want to display the contents of \`ls\`?"
        read -r confirmation
        if [[ "$confirmation" != "yes" && "$confirmation" != "y" ]]; then
            printf "\033[38;5;9mExiting \`ls\` command.\033[0m"
            return 1
        else
            eza --color=always --group-directories-first --icons
        fi
    else
        eza --color=always --all --group-directories-first --icons
        printf "\033[38;5;8mScreencast Mode is currently \033[38;5;9moff\033[38;5;8m. \`ls\` will not display hidden files and folders.\033[0m"
    fi

}
