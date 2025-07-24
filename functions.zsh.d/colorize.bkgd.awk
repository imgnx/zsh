#!/usr/bin/env gawk -f
# background-colorize.awk - Background-only Zsh colorizer

# Usage:
#   echo "foo |bar| baz" | gawk -f background-colorize.awk

BEGIN {
    for (i = 0; i < 256; i++) {
        bgcolors[i] = sprintf("\033[48;5;%dm", i); # 8-bit ANSI background color
    }
    reset_bg = "\033[0m";
    color_idx = 0;
}
{
    line = $0;
    while (match(line, /\|[^|]+\|/)) {
        color = bgcolors[color_idx % 256];
        color_idx++;
        match_str = substr(line, RSTART + 1, RLENGTH - 2);
        repl = color match_str reset_bg;
        line = substr(line, 1, RSTART - 1) repl substr(line, RSTART + RLENGTH);
    }
    print line;
}

END {
    # Reset background color at the end
    print reset_bg;
}
