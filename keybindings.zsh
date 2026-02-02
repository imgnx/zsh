# --- Keybindings ---

# print -P -n "[%F{green}keybindings%f]"
# ~/.zsh/keybindings.zsh
# ----------------------------------------------------------
# Custom keybindings and clipboard helpers
# ----------------------------------------------------------

# Copy the last command’s output to clipboard
copy_last_output() {
  local cmd out
  # Defaults to debugger.
  echo "Copying output of last command:"
  
  cmd="$(fc -ln -1)" || return 1
  echo "Command: $cmd"

  tmpfile="$(mktemp)"

  TRAPEXIT() {
      rm -rf "$tmpfile"
  }
  echo -e "\033[38;2;0;255;0mstdout:\033[0m"  
  out="$( eval "$cmd" | tee \"$tmpfile\" )"
  print -rn -- "$out" | pbcopy
  zle -M "Copied output of: $cmd"
}

zle -N copy_last_output

alias CLO="$(copy_last_output)"


# Copy the most recent kill/yank buffer to the system clipboard
copy_yank_buffer() {
  local buf
  if (( ${#killring[@]} )); then
    buf=${killring[1]}
  else
    buf=$CUTBUFFER
  fi

  if [[ -z $buf ]]; then
    zle -M "Kill ring is empty"
    return 1
  fi

  if command -v pbcopy >/dev/null 2>&1; then
    print -rn -- "$buf" | pbcopy
  elif command -v xclip >/dev/null 2>&1; then
    print -rn -- "$buf" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    print -rn -- "$buf" | xsel --clipboard --input
  else
    zle -M "No clipboard tool available (need pbcopy/xclip/xsel)"
    return 1
  fi

  zle -M "Yank buffer copied to clipboard"
}

zle -N copy_yank_buffer


# Key bindings (Ctrl-R to copy last command output)
# bindkey '^[R' copy_last_output
# bindkey '^R' copy_last_text
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^B" backward-char
bindkey "^F" forward-char
bindkey "^[B" backward-word
bindkey "^[F" forward-word
bindkey "^D" delete-char-or-list
bindkey "^[D" kill-word
bindkey "^W" backward-kill-word
bindkey "^K" kill-line
bindkey "^U" kill-whole-line
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^[P" history-search-backward
bindkey "^[N" history-search-forward
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey "^Y" yank
bindkey "^[Y" yank-pop
bindkey "^[L" down-case-word
bindkey "^[U" up-case-word
bindkey "^[C" capitalize-word
bindkey "^T" transpose-chars
bindkey "^[T" transpose-words
bindkey "^[." insert-last-word
bindkey "^I" expand-or-complete
bindkey "^[*" expand-word
bindkey "^[=" what-cursor-position
bindkey "^L" clear-screen
bindkey "^[L" clear-screen
bindkey "^V" quoted-insert
bindkey "^G" send-break
bindkey "^O" accept-line-and-down-history
bindkey "^X^R" _read_comp
bindkey "^[<" beginning-of-buffer-or-history
bindkey "^[>" end-of-buffer-or-history
bindkey "\M-^?" self-insert
# Key bindings for history search
bindkey '^R' history-incremental-search-backward # Ctrl+R for reverse search
bindkey '^S' history-incremental-search-forward  # Ctrl+S for forward search
bindkey '^P' history-search-backward             # Ctrl+P for previous matching
bindkey '^N' history-search-forward              # Ctrl+N for next matching

# F11 copies the yank buffer to the clipboard (falls back to common sequences)
if [[ -n ${terminfo[kf11]} ]]; then
  bindkey "${terminfo[kf11]}" copy_yank_buffer
fi
# Common fallback for many terminals if terminfo is missing
bindkey "^[[23~" copy_yank_buffer

bindkey -e
