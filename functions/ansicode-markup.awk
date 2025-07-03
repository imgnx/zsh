# ansicode-markup.awk
# This script colorizes the text between HTML-like tags in a file.
# It uses ANSI escape codes to set the text color.
# Supports predefined HTML-like tags and custom hex color codes.

BEGIN {
    # Predefined colors
    colors["red"] = "\033[1;31m";
    colors["green"] = "\033[1;32m";
    colors["blue"] = "\033[1;34m";
    colors["magenta"] = "\033[1;35m";
    colors["yellow"] = "\033[1;33m";
    colors["cyan"] = "\033[1;36m";
    reset = "\033[0m";
}

{
    line = $0;
    while (match(line, /<([^>]+)>([^<]+)<\/\1>/)) {
        tag = substr(line, RSTART + 1, index(substr(line, RSTART + 1), ">") - 1);
        content = gensub(/<[^>]+>([^<]+)<\/[^>]+>/, "\\1", "g", substr(line, RSTART, RLENGTH));

        if (tag ~ /^#[0-9a-fA-F]{6}$/) {
            # Convert hex color to ANSI escape code
            hex = substr(tag, 2);
            r = strtonum("0x" substr(hex, 1, 2));
            g = strtonum("0x" substr(hex, 3, 2));
            b = strtonum("0x" substr(hex, 5, 2));
            color = sprintf("\033[38;2;%d;%d;%dm", r, g, b);
        } else if (tag in colors) {
            color = colors[tag];
        } else {
            color = ""; # No color if tag is unrecognized
        }

        repl = color content reset;
        line = substr(line, 1, RSTART - 1) repl substr(line, RSTART + RLENGTH);
    }
    print line;
}

END {
    # Reset color at the end
    print reset;
}