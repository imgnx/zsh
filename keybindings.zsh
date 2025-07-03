# --- Keybindings ---

print -n -P "[%F{green}keybindings%f]"

bindkey -e
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
