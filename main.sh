#!/bin/bash
# shellcheck shell=bash

# Function to remove duplicate lines from files
# Usage: remove-duplicates <file1> [file2] ...
# Finds duplicate lines and offers to remove them (keeping first occurrence)
# Example: remove-duplicates file1.txt file2.txt
# Dependencies: awk, wc, cp

function remove-duplicates() {
    if [[ $# -eq 0 ]]; then
        echo "❌ Usage: remove-duplicates <file1> [file2] ..."
        echo "   Finds duplicate lines and offers to remove them (keeping first occurrence)"
        return 1
    fi

    for file in "$@"; do
        if [[ ! -f "$file" ]]; then
            echo "❌ File not found: $file"
            continue
        fi

        echo "📋 Checking $file for duplicates..."

        # Find duplicates with line numbers
        local duplicates=$(awk '
            {
                lines[NR] = $0
                if (seen[$0]) {
                    if (!first_seen[$0]) {
                        first_seen[$0] = line_nums[$0]
                        dup_lines[$0] = dup_lines[$0] line_nums[$0] ", "
                    }
                    dup_lines[$0] = dup_lines[$0] NR ", "
                    dup_count[$0]++
                } else {
                    seen[$0] = 1
                    line_nums[$0] = NR
                    dup_count[$0] = 1
                }
            }
            END {
                for (line in dup_count) {
                    if (dup_count[line] > 1) {
                        gsub(/, $/, "", dup_lines[line])
                        printf "%6d %s (lines: %s)\n", dup_count[line], line, dup_lines[line]
                    }
                }
            }
        ' "$file")

        if [[ -z "$duplicates" ]]; then
            echo "✅ No duplicates found in $file"
            continue
        fi

        echo
        echo "Found duplicates:"
        echo "$duplicates"
        echo

        # Ask user if they want to remove duplicates
        echo -n "Remove duplicates, keeping only the first occurrence? (y/N): "
        read -r response

        if [[ "$response" =~ ^[Yy]$ ]]; then
            # Create backup
            echo "💾 Creating backup: ${file}.bak"
            cp "$file" "${file}.bak"

            # Count original lines
            local original_count
            original_count=$(wc -l <"$file")

            # Remove duplicates using awk (keeps first occurrence)
            awk '!seen[$0]++' "$file" >"${file}.tmp" && mv "${file}.tmp" "$file"
            # Count final lines
            local final_count
            final_count=$(wc -l <"$file")
            local removed_count=$((original_count - final_count))

            echo "✅ Removed $removed_count duplicate lines from $file"
            echo "📊 Original: $original_count lines → Final: $final_count lines"
        else
            echo "⏭️  Skipping $file"
        fi
        echo
    done
}
