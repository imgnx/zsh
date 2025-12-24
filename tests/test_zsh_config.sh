#!/bin/zsh
# Simple test for Zsh config: checks if a key function and variable are set

# Source config files to ensure environment is loaded
source ~/.zshenv
source ~/.zshrc

if [[ -z "$ZDOTDIR" ]]; then
    echo "FAIL: ZDOTDIR is not set"
    exit 1
fi

if [[ -z "$PS1" ]]; then
    echo "FAIL: PS1 is not set"
    exit 1
fi

echo "PASS: Zsh config basic test succeeded"
exit 0
