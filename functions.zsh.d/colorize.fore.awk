#!/usr/bin/env gawk -f
# colorize.awk - Enhanced Foreground and Background Zsh colorizer

# Usage:
#   echo "text ~foreground |background" | gawk -f colorize.awk

function hex2zsh_fg(hex) {
    if (substr(hex,1,1) != "#") hex = "#" hex
    return "%F{" hex "}"
}

function hex2zsh_bg(hex) {
    if (substr(hex,1,1) != "#") hex = "#" hex
    return "%K{" hex "}"
}

function generate_ansi_colors() {
    # Generate 8-bit ANSI colors (0-255), excluding black and white
    for (i = 0; i < 256; i++) {
        if (i == 0 || i == 15 || i == 231 || i == 255) {
            continue; # Skip black and white
        }
        r = int((i / 36) % 6) * 51; # Red component
        g = int((i / 6) % 6) * 51;  # Green component
        b = int(i % 6) * 51;        # Blue component
        hex = sprintf("#%02X%02X%02X", r, g, b);
        fgcolors[i] = hex2zsh_fg(hex);
        bgcolors[i] = hex2zsh_bg(hex);
    }
    color_count = 256 - 4; # Adjust count to exclude skipped colors
}

BEGIN {
    # Initialize colors and cache
    cache_file = "/tmp/colorize_cache.txt";
 #   if (system("test -f " cache_file) == 0) {
        system("rm -f " cache_file);
    }
    generate_ansi_colors();
    reset_fg = "%f";
    reset_bg = "%k";
}
{
    n = split($0, segs, /[~|]/);
    out = "";
    fg_idx = 0;
    bg_idx = 0;
    for (i = 1; i <= n; i++) {
        if (match($0, "~")) {
            if (fg_idx < color_count) {
                color = fgcolors[fg_idx++];
                out = out color segs[i] reset_fg;
            } else {
                out = out "~" segs[i];
            }
        } else if (match($0, "|")) {
            if (bg_idx < color_count) {
                color = bgcolors[bg_idx++];
                out = out color segs[i] reset_bg;
            } else {
                out = out "|" segs[i];
            }
        } else {
            out = out segs[i];
        }
    }
    print out > cache_file;
    print out;
}

END {
    # Clean up cache
    if (system("test -f " cache_file) == 0) {
        system("rm -f " cache_file);
    }
}
