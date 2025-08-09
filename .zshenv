if [[ "${ZLOADING:-}" == ".zshenv" && "${SKIP_PREFLIGHT_LOAD_CHECK:-0}" != 1 ]]; then
	print -n -P "[%F{#444}skip env%f(%F{white}%D{%S.%3.}%f)]"
	return 0
fi

COPILOT_MODE="${COPILOT_MODE:-false}" # Default to false if not set

function import() {
	prompt=(
		"Did you mean to run \033[5;38;5;1mimport\033[0m in the current terminal? \033[38;5;5mimport\033[39m is currently set to run ImageMagick."
		'You likely meant to add a shebang to the top of a JavaScript file and the terminal found an "import" statement instead.'
		"Here is the shebang for Node.js:\n\n\033[38;5;2m\#!/usr/bin/env node\033[39m\n\n"
		'Is this what you meant to do? (y/N)'
	)

	answer="$(safeguard "${prompt[@]}")"

}

if [[ -o interactive ]]; then
	export ZLOADING=".zshenv"
	# Uncomment to disable preflight load check
	# export SKIP_PREFLIGHT_LOAD_CHECK=0
	# echo -e "✅ INTERACTIVE │ l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"

	export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}" # Set ZDOTDIR if not already set
	. "${ZDOTDIR}/functions.zsh" -                 # Load custom functions

	# Load custom variables
	. "$ZDOTDIR/variables.zsh"
	# Load custom functions
	. "$ZDOTDIR/functions.zsh"
	# Load aliases, keybindings, hashes, paths
	. "$ZDOTDIR/aliases.zsh"
	. "$ZDOTDIR/keybindings.zsh"
	. "$ZDOTDIR/hashes.zsh"
	. "$ZDOTDIR/paths.zsh"

	# Source Cargo environment if exists
	[ -f "$HOME/dotfiles/.cargo/env" ] && . "$HOME/dotfiles/.cargo/env"

	export IMGNXZINIT=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))

	# VS Code
	if command -v code >/dev/null 2>&1; then
		export VSCODE_SUGGEST=1
	fi

	### 🥾 PATH

	# add2path "$HOME/bin"
	# add2path "$HOME/.local/bin"
	# add2path "$HOME/.cargo/bin"

	### 🌐 XDG

	### No-Name Directory (fallback for plugins)
	# Rust/Cargo
	# . "/Users/donaldmoore/dotfiles/.cargo/env"
	# Source elsewhere...

	. "${ZDOTDIR}/aliases.zsh"                               # Load custom aliases
	. "${ZDOTDIR}/keybindings.zsh"                           # Load custom keybindings
	. "${ZDOTDIR}/hashes.zsh"                                # Load custom hashes
	. "${ZDOTDIR}/paths.zsh"                                 # Load custom path variables
	. "${ZDOTDIR}/functions.zsh.d/delayed-script-loader.zsh" # Load delayed script loader
	# Source Cargo
	[ -f "$HOME/dotfiles/.cargo/env" ] && . "$HOME/dotfiles/.cargo/env"

fi
