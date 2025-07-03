#!/bin/zsh
# Delayed script loader hook
# This function runs once after zsh initialization to source additional scripts

function D36B034A_2E4A_4D7D_A93C_4C5EB0A197A7() {
    # Called once the prompt is ready to source extra scripts
    echo -e "[ delayed-script-loader ]"
    printf '🔧 %s called. Sourcing scripts in %s/functions/scripts/**\n' \
        "${funcstack[1]}" "$ZDOTDIR"

    for file in "$ZDOTDIR/functions/"*; do
        [[ -f $file ]] || continue
        local script_name=${file:t:r}
        if source "$file"; then
            echo "✅ Sourced: $script_name"
        else
            echo "❌ Failed: $script_name"
        fi
    done

    # Remove this hook so it only runs once
    if (($ + functions[add - zsh - hook])); then
        autoload -Uz add-zsh-hook
        add-zsh-hook -d precmd D36B034A_2E4A_4D7D_A93C_4C5EB0A197A7
    fi
}

# Load it after zsh initialization is complete
autoload -Uz add-zsh-hook
add-zsh-hook precmd D36B034A_2E4A_4D7D_A93C_4C5EB0A197A7
