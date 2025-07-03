// ansicode-markup.js
// This script colorizes the text between HTML-like tags in a string.
// It uses ANSI escape codes to set the text color.
// Supports predefined HTML-like tags and custom hex color codes.

const colors = {
  red: "\x1b[31m",
  green: "\x1b[32m",
  blue: "\x1b[34m",
  magenta: "\x1b[35m",
  yellow: "\x1b[33m",
  cyan: "\x1b[36m",
  reset: "\x1b[0m",
};

function hexToAnsi(hex) {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return `\x1b[38;2;${r};${g};${b}m`;
}

function colorize(input) {
  return input.replace(/<([^>]+)>([^<]+)<\/\1>/g, (match, tag, content) => {
    let color;
    if (/^#[0-9a-fA-F]{6}$/.test(tag)) {
      color = hexToAnsi(tag);
    } else if (colors[tag]) {
      color = colors[tag];
    } else {
      color = ""; // No color if tag is unrecognized
    }
    return `${color}${content}${colors.reset}`;
  });
}

// Example usage
const example = "This is <red>red</red>, <#00FF00>green</#00FF00>, and <blue>blue</blue>.";
console.log(colorize(example));
