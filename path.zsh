print -n -P "[%F{green}path%f]"

add2path "$HOME/bin"
add2path "$BIN"
add2path "$CARGO_HOME"
add2path "$CARGO_HOME/bin"
add2path "$HOME/go/bin"
add2path "$RUSTUP_HOME"
add2path "$XDG_CONFIG_HOME/cargo/bin"

