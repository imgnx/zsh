#!/bin/zsh
# Scan ~/.config for bin folders and output new ones to a file

BLACKLISTED="$HOME/.config/zsh/bin.black.list"
WHITELISTED="$HOME/.config/zsh/bin.white.list"
OUTPUT="$HOME/.config/zsh/.bins.timestamp"
LOG_FILE="$HOME/.config/zsh/.bins.log"

# Clear output file
: > "$OUTPUT"

# Add timestamp to log
echo "=== Bin scan started at $(date) ===" >> "$LOG_FILE"

# Log existing lists for debugging
echo "Whitelisted paths:" >> "$LOG_FILE"
if [[ -f "$WHITELISTED" ]]; then
    cat "$WHITELISTED" >> "$LOG_FILE"
else
    echo "  (whitelisted file not found)" >> "$LOG_FILE"
fi

echo -e "\nBlacklisted paths:" >> "$LOG_FILE"
if [[ -f "$BLACKLISTED" ]]; then
    cat "$BLACKLISTED" >> "$LOG_FILE"
else
    echo "  (blacklisted file not found)" >> "$LOG_FILE"
fi

echo -e "\nScanning for bin directories..." >> "$LOG_FILE"

for dir in $(find "$HOME/.config/" -type d -name 'bin' 2>/dev/null); do
    echo "Found: $dir" >> "$LOG_FILE"
    
    if grep -qxF "$dir" "$WHITELISTED" 2>/dev/null; then
        echo "  -> WHITELISTED (skipping)" >> "$LOG_FILE"
        continue
    fi
    
    if grep -qxF "$dir" "$BLACKLISTED" 2>/dev/null; then
        echo "  -> BLACKLISTED (skipping)" >> "$LOG_FILE"
        continue
    fi
    
    if [[ ":$PATH:" == *":$dir:"* ]]; then
        echo "  -> ALREADY IN PATH (skipping)" >> "$LOG_FILE"
        continue
    fi
    
    echo "  -> NEW (adding to output)" >> "$LOG_FILE"
    echo "$dir" >> "$OUTPUT"
done

echo -e "\n=== Bin scan completed at $(date) ===\n" >> "$LOG_FILE"
