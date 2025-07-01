# format this file with `gawk [ --lint | -L ] -f /path/to/this/file /dev/null`
# colorize.awk

# This script colorizes the text between pipes in a file.
# It uses ANSI escape codes to set the text color.
# The colors are cycled through three different colors:
# magenta, yellow, and cyan.


BEGIN {
    colors [0] = "\033[1;35m";    # magenta
    colors [1] = "\033[1;33m";    # yellow
    colors [2] = "\033[1;36m";    # cyan
    reset = "\033[0m";
    color_idx = 0;
}
{
    line = $0;
    while ( match( line, /\|[^|]+\|/ ) ) {
        color = colors [ color_idx % 3 ];
        color_idx++;
        match_str = substr( line, RSTART + 1, RLENGTH- 2 );
        repl      = color match_str reset;
        line = substr(line, 1, RSTART - 1) repl substr(line, RSTART + RLENGTH)

    }
    print line;
}

END {
    # Reset color at the end
    print reset;
}
