#!/usr/bin/env gawk -f
# foreground-colorize.awk - Foreground-only Zsh colorizer

# Usage:
#   echo "foo |bar| baz" | gawk -f foreground-colorize.awk

function hex2zsh_fg(hex) {
    if (substr(hex,1,1) != "#") hex = "#" hex
    return "%F{" hex "}"
}

BEGIN {
    # Foreground only
    hexcolors[0] = "#FF00FF"; # magenta
    hexcolors[1] = "#FFFF00"; # yellow
    hexcolors[2] = "#00FFFF"; # cyan
    hexcolors[3] = "#FF0000"; # red
    hexcolors[4] = "#00FF00"; # green
    hexcolors[5] = "#0000FF"; # blue
    hexcolors[6] = "#FFFFFF"; # white
    hexcolors[7] = "#000000"; # black
    hexcolors[8] = "#808080";
    hexcolors[9] = "#800000";
    hexcolors[10] ="#008000";
    hexcolors[11] ="#000080";
    hexcolors[12] ="#808000";
    hexcolors[13] ="#800080";
    hexcolors[14] ="#008080";
    hexcolors[15] ="#C0C0C0";

    color_count = 16;
    for (i = 0; i < color_count; i++) {
        fgcolors[i] = hex2zsh_fg(hexcolors[i]);
    }
    reset_fg = "%f";
}
{
    n = split($0, segs, "|");
    out = "";
    for (i = 1; i <= n; i++) {
        # Preserve pre-colored segments
        # if (segs[i] ~ /%[F]\{#[0-9A-Fa-f]{6}\}/) {
        #     out = out segs[i];
        # } else {
            color = fgcolors[(i-1)%color_count];
            out = out color segs[i] reset_fg;
        # }
    }
    print out;
}
