#!/bin/zsh
# Scan ~/.config for bin folders and output new ones to a file

BLACKLISTED="$HOME/.config/zsh/bin.black.list"
OUTPUT="$HOME/.config/zsh/.bins.timestamp"

: > "$OUTPUT"

for dir in $(find "$HOME/.config/" -type d -name 'bin' 2>/dev/null); do
    grep -qxF "$dir" "$WHITELISTED" 2>/dev/null && continue
    grep -qxF "$dir" "$BLACKLISTED" 2>/dev/null && continue
    [[ ":$PATH:" == *":$dir:"* ]] && continue
    echo "$dir" >> "$OUTPUT"
done
