# format this file with `gawk [ --lint | -L ] -f /path/to/this/file /dev/null`
# colorize.awk

# This script colorizes the text between pipes in a file.
# It uses ANSI escape codes to set the text color.
# The colors are cycled through 8-bit ANSI colors (0-255).


BEGIN {
    for (i = 0; i < 256; i++) {
        colors[i] = sprintf("\033[38;5;%dm", i); # 8-bit ANSI color
    }
    reset = "\033[0m";
    color_idx = 0;
}
{
    line = $0;
    while (match(line, /\|[^|]+\|/)) {
        color = colors[color_idx % 256];
        color_idx++;
        match_str = substr(line, RSTART + 1, RLENGTH - 2);
        repl = color match_str reset;
        line = substr(line, 1, RSTART - 1) repl substr(line, RSTART + RLENGTH);
    }
    print line;
}

END {
    # Reset color at the end
    print reset;
}
