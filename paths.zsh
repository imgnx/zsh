
# Static path setup only. Dynamic path logic is handled in delayed-script-loader.zsh
export IMGNX_PATH="/Users/donaldmoore/bin:/Users/donaldmoore/.config/wrangler/bin:/Users/donaldmoore/dotfiles/.cargo/bin:/usr/local/opt:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/usr/local/MacGPG2/bin:/Applications/Wireshark.app/Contents/MacOS"
export PATH="$IMGNX_PATH"
# if [[ -f "$BLACKLISTED_CONFIG_BIN_PATH_FILE" ]]; then
#     BLACKLISTED_CONFIG_BIN_PATHS=("${(@f)$(cat "$BLACKLISTED_CONFIG_BIN_PATH_FILE")}")
# fi

# # Load whitelist paths from file if it exists, add to PATH if not present
if [[ -f "$WHITELISTED_CONFIG_BIN_PATH_FILE" ]]; then
    while IFS= read -r whitelist_dir; do
        [[ -z "$whitelist_dir" ]] && continue
        # Only add if not already in $PATH
        if [[ ":$PATH:" != *":$whitelist_dir:"* ]]; then
            export PATH="$whitelist_dir:$PATH"
            # echo "$whitelist_dir added to PATH from whitelist"
        fi
    done < "$WHITELISTED_CONFIG_BIN_PATH_FILE"
    # echo "Loaded whitelist from $WHITELISTED_CONFIG_BIN_PATH_FILE..."
fi

# for dir in $(find "$HOME/.config/" -type d -name 'bin'); do
#        # Skip if already in $PATH
#     if [[ ":$PATH:" == *":$dir:"* ]]; then
#         continue
#     fi
#     # Skip if in BLACKLISTED_CONFIG_BIN_PATHS
#     if [[ " ${BLACKLISTED_CONFIG_BIN_PATHS[@]} " == *" $dir "* ]]; then
#         continue
#     else
#         echo -e "$dir \033[38;5;6mnot found\033[0m in \033[38;5;1mBLACKLISTED_CONFIG_BIN_PATHS\033[0m"
#     fi
    
#     if [[ " ${CONFIG_BIN_PATHS[@]} " != *" $dir "* ]]; then
#         while true; do
#             read -q "REPLY?Would you like to add $dir to your PATH? (y/n) "; echo
#             if [[ $REPLY == [Yy] ]]; then
#                 # Only add if not already in PATH
#                 CONFIG_BIN_PATHS+=("$dir")
#                 export CONFIG_BIN_PATHS
#                 export PATH="$dir:$PATH"
#                 echo "$dir added to PATH"
#                 break
#             elif [[ $REPLY == [Nn] ]]; then
#                 BLACKLISTED_CONFIG_BIN_PATHS+=("$dir")
#                 export BLACKLISTED_CONFIG_BIN_PATHS
#                 echo "$dir" >> "$BLACKLISTED_CONFIG_BIN_PATH_FILE"
#                 echo "$dir added to BLACKLISTED_CONFIG_BIN_PATHS (and file)"
#                 break
#             else
#                 echo "Please answer y or n."
#             fi
#         done
#     fi
# done

# print -n -P "[%F{green}path%f]"

# echo "Number of skipped config bin paths: ${#BLACKLISTED_CONFIG_BIN_PATHS[@]}"
# echo -e "To edit skipped PATHS, run: \033[38;5;6mcode \"\$BLACKLISTED_CONFIG_BIN_PATH_FILE\"\033[0m"

