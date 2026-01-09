#!/bin/zsh
#shellcheck disable=all
#shfmt disable=all

# export TABULAR_RASA=
# export ZSH_DEBUG =
# export PY_DEBUG=
# export HARD_RESET=

debug() {
	zsh -xv
}

##### FLAGS AND VARIABLES GO ABOVE THIS LINE

[[ ! -z "$ZSH_DEBUG" ]] && echo "" >"$HOME/Desktop/zsh_debug.log"

# lolcat<<\\EOF
# █████  █████████████ ██████▌██░
# ▀▀███    ███ ██▘█░█████ ███░██░
# ▀▀███   ███ █████░██ ███ ██░██░
# ▀▀███  ███ ███░ █░██ ▝███ ████░
# \EOF

# Auto-activate per-project .venv if present
autoload -U add-zsh-hook

##### WRITE ANY NEW FUNCTIONS UNDER THIS LINE

when() {
	# Find .breadcrumb files, print mtime + path, sort newest first
	local files
	files=$(find "$HOME" -type f -name ".breadcrumb" -print0 |
		xargs -0 stat -f "%m %N" |
		sort -rn |
		cut -d' ' -f2-)

	# If nothing found, exit quietly
	[ -z "$files" ] && return 0

	# Output contents to bat
	printf "%s\n" "$files" | xargs bat --style=plain
}

theme() {
	cmd="$1"
	case $cmd in
	init)
		THEME_INIT "$@"
		;;
	set)
		SET_THEME "$@"
		;;
	roll | reroll)
		THEME_ROLL "$@"
		;;
	*)
		echo -en "Please select an action:

1. \033[38;2;0;123;255m(i) \033[33mtheme init\033[0m
2. \033[38;2;0;123;255m(s) \033[33mtheme set\033[0m
3. \033[38;2;0;123;255m(r) \033[33mtheme roll/reroll\033[0m

Your selection: "
		read -r -k 1 res
		case $res in
		[1i])
			theme init
			;;
		[2s])
			theme set
			;;
		[3r])
			theme roll
			;;
		*)
			echo "Invalid response \`$res\`. Exiting."
			;;
		esac
		;;
	esac
}

modules() {
	cd "$MODULES"
	when | head -n 10
}

path() {
	export PATH_2="$(mktemp)"
	print -rl -- "${path[@]}" >"$PATH_2"
	diff "$PATH_1" "$PATH_2"
}

fpath() {
	export FPATH_2="$(mktemp)"
	print -rl -- "${fpath[@]}" >"$FPATH_2"
	diff "$FPATH_1" "$FPATH_2"
}

shava() {
	node -e <(
		cat <<'EOF'
console.log("Hello, $(basename $HOME)! Your first argument is \${process.argv[1]}");
EOF
	) -- "$ARG1"

}

chkyn() {
	local prompt="${1:-Would you like to stop the timer?}"
	local ans

	while true; do
		print -n -- "$prompt [y/n] "
		if ! IFS= read -r ans; then
			print
			continue
		fi

		ans="${ans:l}"
		case "$ans" in
		y | yes) return 0 ;;
		n | no) return 1 ;;
		"") continue ;;
		*) continue ;;
		esac
	done
}

seza() {
	emulate -L zsh
	setopt pipefail

	local themefile
	if (($ + functions[THEMEFILE])); then
		themefile="$(THEMEFILE)"
	else
		themefile="${THEMEFILE:-$HOME/.themefile}"
	fi
	[[ -f "$themefile" ]] && source "$themefile"

	local seza_theme_color="${THEME_COLOR:-}"
	local seza_theme_icon=""
	# Prefer explicit seza icon vars, otherwise reuse NAMESPACE as requested.
	if [[ -n "${SEZA_ICON:-}" ]]; then
		seza_theme_icon="$SEZA_ICON"
	elif [[ -n "${SEZA_NAMESPACE_ICON:-}" ]]; then
		seza_theme_icon="$SEZA_NAMESPACE_ICON"
	elif [[ -n "${NAMESPACE:-}" ]]; then
		seza_theme_icon="$NAMESPACE"
	fi

	if ! command -v eza >/dev/null 2>&1; then
		print -u2 "seza: eza is not installed"
		return 127
	fi

	local -a pairs
	local k v
	if typeset -p EZA_SPECIAL >/dev/null 2>&1; then
		if [[ "$(typeset -p EZA_SPECIAL 2>/dev/null)" == *"-A"* ]]; then
			typeset -A EZA_SPECIAL
			local -a __eza_special_keys=()
			eval '__eza_special_keys=("${(@k)EZA_SPECIAL}")'
			for k in "${__eza_special_keys[@]}"; do
				v="${EZA_SPECIAL[$k]}"
				pairs+=("${k}=${v}")
			done
		else
			for k in "${EZA_SPECIAL[@]}"; do
				pairs+=("$k")
			done
		fi
	fi

	# Auto-add the current directory’s own theme defaults (THEME_COLOR + NAMESPACE-as-icon)
	if [[ -n "$seza_theme_color" ]]; then
		local cwd_base="${PWD:t}"
		local cwd_abs="${PWD:A}"
		local have_base=0 have_abs=0
		for k in "${pairs[@]}"; do
			[[ "$k" == "${cwd_base}="* ]] && have_base=1
			[[ "$k" == "${cwd_abs}="* ]] && have_abs=1
		done
		((have_base)) || pairs+=("${cwd_base}=${seza_theme_color}")
		((have_abs)) || pairs+=("${cwd_abs}=${seza_theme_color}")
	fi

	local eza_colors="${EZA_COLORS:-}"
	if ((${#pairs[@]})); then
		local joined_pairs
		local IFS=:
		joined_pairs="${pairs[*]}"
		if [[ -n "$eza_colors" ]]; then
			eza_colors="${eza_colors}:${joined_pairs}"
		else
			eza_colors="$joined_pairs"
		fi
	fi

	local -a argv
	argv=("$@")

	local want_icons=0
	local arg
	for arg in "${argv[@]}"; do
		[[ "$arg" == "--special-icons" ]] && want_icons=1
	done
	if ((want_icons)); then
		local -a filtered_args=()
		for arg in "${argv[@]}"; do
			[[ "$arg" == "--special-icons" ]] && continue
			filtered_args+=("$arg")
		done
		argv=("${filtered_args[@]}")
	fi

	if ((want_icons)); then
		local icons_kv="${EZA_SPECIAL_ICONS_KV:-}"
		if [[ -z "$icons_kv" ]] && typeset -p EZA_SPECIAL_ICONS >/dev/null 2>&1 && [[ "$(typeset -p EZA_SPECIAL_ICONS 2>/dev/null)" == *"-A"* ]]; then
			local -a icon_kv_flat=()
			eval 'icon_kv_flat=("${(@kv)EZA_SPECIAL_ICONS}")'
			local -a icon_pairs
			local i
			for ((i = 1; i <= ${#icon_kv_flat[@]}; i += 2)); do
				k="${icon_kv_flat[i]}"
				v="${icon_kv_flat[i + 1]}"
				icon_pairs+=("${k}=${v}")
			done
			if ((${#icon_pairs[@]})); then
				icons_kv="$(printf '%s\n' "${icon_pairs[@]}")"
			fi
		fi

		if [[ -n "$seza_theme_icon" ]]; then
			local cwd_base="${PWD:t}"
			local cwd_abs="${PWD:A}"
			local -a icon_lines
			if [[ -n "$icons_kv" ]]; then
				while IFS= read -r line; do
					icon_lines+=("$line")
				done <<<"$icons_kv"
			fi
			local have_base=0 have_abs=0
			for k in "${icon_lines[@]}"; do
				[[ "$k" == "${cwd_base}="* ]] && have_base=1
				[[ "$k" == "${cwd_abs}="* ]] && have_abs=1
			done
			((have_base)) || icon_lines+=("${cwd_base}=${seza_theme_icon}")
			((have_abs)) || icon_lines+=("${cwd_abs}=${seza_theme_icon}")
			if ((${#icon_lines[@]})); then
				icons_kv="$(printf '%s\n' "${icon_lines[@]}")"
			fi
		fi

		local -a env_prefix
		[[ -n "$eza_colors" ]] && env_prefix+=("EZA_COLORS=$eza_colors")
		[[ -n "$icons_kv" ]] && env_prefix+=("EZA_SPECIAL_ICONS_KV=$icons_kv")

		{ "${env_prefix[@]}" eza --oneline --icons --color=always "${argv[@]}"; } | python3 - <<'PY'
import fnmatch
import os
import re
import sys

ansi = re.compile(r'\x1b\[[0-9;]*m')
raw_map = os.environ.get("EZA_SPECIAL_ICONS_KV", "")
icons = {}
for line in raw_map.splitlines():
    if "=" in line:
        key, val = line.split("=", 1)
        icons[key] = val

for raw_line in sys.stdin:
    raw_line = raw_line.rstrip("\n")
    plain = ansi.sub("", raw_line).strip()
    if not plain:
        sys.stdout.write(raw_line + "\n")
        continue

    parts = plain.split(None, 1)
    name = parts[1] if len(parts) > 1 else parts[0]

    prefix = ""
    for pattern, icon in icons.items():
        if fnmatch.fnmatch(name, pattern):
            prefix = icon + " "
            break

    sys.stdout.write(prefix + raw_line + "\n")
PY
		return $?
	fi

	if [[ -n "$eza_colors" ]]; then
		EZA_COLORS="$eza_colors" eza --icons "${argv[@]}"
	else
		eza --icons "${argv[@]}"
	fi
}

__wrap_notice codex
codex() {
	touch ./codex.log

	local ROOT OUT UUID BIN
	ROOT="$(realpath ./)"
	OUT="$ROOT/codex.log"

	if [[ -x "$ROOT/codex" ]]; then
		BIN="$ROOT/codex"
	else
		BIN="/opt/homebrew/bin/codex"
	fi

	script -a -q -F "$OUT" "$BIN" -c history.persistence=none "$@"

	UUID="$(rg -oP 'codex resume \K[0-9A-Fa-f-]{36}' "$OUT" | tail -n 1)"
	if [[ -n "${UUID:-}" ]]; then
		cat >"$ROOT/codex" <<EOF
#!/usr/bin/env bash
exec /opt/homebrew/bin/codex -c history.persistence=none resume $UUID "\$@"
EOF
		chmod +x "$ROOT/codex"
		print -ru2 -- "✓ Created $ROOT/codex wrapper for session $UUID"
	else
		print -ru2 -- "✗ No resume UUID found in $OUT"
		return 1
	fi

	printf "\033[42mView logs with: codexlog\033[0m\n"
}

codexlog() {
	local ROOT OUT
	ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
	OUT="$ROOT/codex.log"
	[[ -f "$OUT" ]] && bat "$OUT" || {
		print -ru2 -- "No log at $OUT"
		return 1
	}
}

# replace_line() {
#     tmp=$(mktemp)
#     argBuilder='
#     sed '$start,$endc\
#     "$target"' > "$tmp" && mv "$tmp" "$target"
# }

# unalias rl >/dev/null 2>&1
alias rl="replace_line"
alias rp="replace_line"

trip() {
	if [[ ! -d $XDG_CACHE_DIR ]]; then
		mkdir -p "$HOME/.cache/triptrax"
		export XDG_CACHE_DIR="$HOME/.cache"
	fi
}
alias trax="trip"

__wrap_notice man
export READER="bat"
man() {
	local command="$1"
	echo -e "\033[48;2;69;17;255mGathering documentation for ${command}... \033[0m"
	mkdir -p "${MONOLITH:-HOME}/docs/info"
	LOX="${MONOLITH:-HOME}/docs/info/${command}.info"
	if [[ -f ${LOX} ]]; then
		echo -en "A mandoc for $command already exists in$LOX. To refresh it, execute \`\033[33m/bin/rm -rf $LOX\033[0m\`."
		$READER $LOX
	elif /usr/bin/man -w "$command" >/dev/null 2>&1; then
		/usr/bin/man "$command" | col -b >"$LOX"
		echo -e "\033[48;2;0;255;127mDone\!\033[48;2;69;17;255m You can find a copy in \033[38;2;255;205;0m${MONOLITH:-HOME}/docs/info/$command.info\033[0m ."
		echo
		echo -e "Menu Options:

Press ...[1] to ...[2]
1. (a)     Open the doc with $READER.
2. (b)     Open the doc in 'bat'.
3. (c)     Open the doc with 'cat' and exit.
4. (d)     Open the doc with 'info'.
5. (e)     Open the doc with $EDITOR.


* You can set which app opens the doc by setting the default application for .info files to whichever app you'd like to open the docs with.
"

		read -r answer
		case $answer in
		a | 1)
			$READER "$LOX"
			;;
		b | 2)
			bat "$LOX"
			;;
		c | 3)
			cat "$LOX"
			;;
		d | 4)
			info "$LOX"
			;;
		e | 5)
			$EDITOR "$LOX"
			;;
		*)
			open "$LOX"
			;;
		esac
	fi
}

blueprints() {
	local cmd="${1:-}"
	case "$cmd" in
	"" | "ls")
		#   command ls -1 "$BLUEPRINTS"/*.bp(N:t:r)
		;;
	"cat")
		[[ -n "${2:-}" ]] || return 2
		command cat -- "$BLUEPRINTS/$2.bp"
		;;
	"new")
		[[ -n "${2:-}" ]] || return 2
		command mkdir -p -- "$BLUEPRINTS"
		: >|"$BLUEPRINTS/$2.bp"
		${EDITOR:-vi} "$BLUEPRINTS/$2.bp"
		;;
	*)
		if [[ -f "$BLUEPRINTS/$cmd.bp" ]]; then
			command cat -- "$BLUEPRINTS/$cmd.bp"
		else
			print -u2 "Usage: bp [ls]|cat <name>|new <name>|<name>"
			return 2
		fi
		;;
	esac
}

_bp() {
	local -a names
	#   names=("$BLUEPRINTS"/*.bp(N:t:r))
	_arguments \
		'1:blueprint:->bpnames' \
		'2:arg:_guard ".*" ""'
	case $state in
	bpnames) compadd -a names ;;
	esac
}
compdef _bp bp

bp_expand() {
	local -a names
	#   names=("$BLUEPRINTS"/*.bp(N:t:r))
	[[ ${#names[@]} -gt 0 ]] || {
		zle -M "no blueprints in $BLUEPRINTS"
		return 0
	}
	local name=""
	if [[ -n "${1:-}" ]]; then
		name="$1"
	else
		if command -v fzf >/dev/null 2>&1; then
			zle -I
			name="$(printf '%s\n' "${names[@]}" | fzf --prompt='bp> ' --height=40% --reverse)"
			zle reset-prompt
		else
			zle -M "install fzf for picker (or pass a name: bp_expand <name>)"
			return 0
		fi
	fi

	[[ -n "$name" && -f "$BLUEPRINTS/$name.bp" ]] || return 0

	local content prefix rest
	content="$(<"$BLUEPRINTS/$name.bp")"

	if [[ "$content" == *"{{CURSOR}}"* ]]; then
		prefix="${content%%\{\{CURSOR\}\}*}"
		rest="${content#*\{\{CURSOR\}\}}"
		content="${prefix}${rest}"
		local before="$LBUFFER" after="$RBUFFER"
		BUFFER="${before}${content}${after}"
		CURSOR=$((${#before} + ${#prefix}))
	else
		LBUFFER+="$content"
	fi
}

zle -N bp_expand

bp_expand_from_buffer() {
	local b="$BUFFER"
	if [[ "$b" == bp\ * ]]; then
		local name="${b#bp }"
		name="${name%% *}"
		if [[ -n "$name" && -f "$BLUEPRINTS/$name.bp" ]]; then
			BUFFER=""
			CURSOR=0
			bp_expand "$name"
			return 0
		fi
	fi
	zle expand-or-complete
}
zle -N bp_expand_from_buffer

bindkey '^X^B' bp_expand
bindkey '^I' bp_expand_from_buffer

step1() {
	local manifesto="$(basename $(realpath ./))" # Use descriptive names for your projects.
	local target="$DH/bin/create-${manifesto}-wkbn"
	mv ./setup.sh "$target" && echo "Moved setup.sh to \"\$DH/bin\". You can now use it like \`create-${manifesto}-wkbn"
	ln -s "\$target" ./setup.sh
	echo "Done! \`setup.sh\` has been symlinked in the current directory."
}

setup() {
	touch ./setup.sh
	cat <\\EOF >setup.sh
	"$@"

	\EOF
	chmod +x ./setup.sh
	./setup.sh
}

bd() {
	cd "$(dirs -p | sed -n "${1:-1}p")"
}

typeset -ga GITTAKU_HOOKS__create_post
typeset -ga GITTAKU_HOOKS__create_pre

gittaku_hook() {
	local hook="$1" fn="$2"
	typeset -n arr="GITTAKU_HOOKS__${hook//./_}"
	arr+=("$fn")
}

gittaku_plugins_load() {
	local d="${XDG_CONFIG_HOME:-$HOME/.config}/gittaku/plugins.d"
	[[ -d "$d" ]] || return 0
	local f
	setopt nullglob
	for f in "$d"/*.zsh; do
		source "$f"
	done
}

gittaku_hook_run() {
	local hook="$1"
	shift
	typeset -n arr="GITTAKU_HOOKS__${hook//./_}"
	local fn
	for fn in "${arr[@]}"; do
		"$fn" "$@"
	done
}

create() {
	set -e
	APP_NAME="${1:-my-electron-app}"
	mkdir -p "$APP_NAME"
	pushd "$APP_NAME"
	mkdir -p src
	mkdir -p frontend
	mkdir -p frontend/public
	npm init -y
	npm install --save-dev electron browser-sync >/dev/null 2>&1
	npm install --save react react-dom tailwindcss @tailwindcss/cli
	touch public/index.html # target for browser-sync

	cat >main.js <<'EOF'
const { app, BrowserWindow } = require('electron')

function createWindow () {
  const win = new BrowserWindow({
    width: 1920,
    height: 1080,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: true
    }
  })

  win.loadFile('index.html')
}

app.whenwReady().then(() => {
  createWindow()

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})
EOF

	cat >index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Electron App</title>
  <style>
    body {
        background-color: "#007BFF";
    }
  </style>
</head>
<body>
  <h1>Taku!</h1>
  <p>If you can read this, it worked.</p>
</body>
</html>
EOF

	# add "start": "electron ."
	node - <<'EOF'
const fs = require('fs')
const pkgPath = 'package.json'
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'))
pkg.scripts = pkg.scripts || {}
pkg.scripts.start = 'electron .'
pkg.scripts.dev = 'browser-sync'
fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2))
EOF

	echo -e "\033[38;2;0;209;255mDone!\033[0m Happy hacking!"
	echo "Run:"
	echo "  cd $APP_NAME"
	echo "  npm start"

}

release() {

}

root() {
	git rev-parse --show-toplevel
}

dusort() {
	du -sh -- ./*(D) | sort -hr | bat --style=plain
}

# In a file now...
# clean() {

#     set -euo pipefail

#     pushd -- "${DINGLEHOPPER:?}" >/dev/null

#     find . -type d \( \
# 	 -name .yarn -o \
# 	 -name .next -o \
# 	 -name node_modules -o \
# 	 -name __pycache__ -o \
# 	 -name build -o \
# 	 -name .build -o \
# 	 -name dist -o \
# 	 -name target -o \
# 	 -name site-packages \
# 	 \) -prune -exec rm -rf -- {} +

#     find . -type d -name .venv -prune -print0 |
# 	while IFS= read -r -d '' venv; do
# 	    proj="${venv%/*}"

# 	    py="$venv/bin/python"
# 	    if [[ -x "$py" ]]; then
# 		if "$py" -m pip freeze > "$proj/requirements.txt"; then
# 		    rm -rf -- "$venv"
# 		    find "$proj" -type d -name __pycache__ -prune -exec rm -rf -- {} +
# 		fi
# 	    fi
# 	done

#     popd >/dev/null
# }

# alias nuke='clean'
# alias scrub='clean'
# alias burn='clean'
# alias wipe='clean'

noiphone() {
	local pref="com.apple.audio.SystemSettings"
	if sudo defaults read $pref SuppressDeviceDisconnectAlerts 2>/dev/null | grep -q 1; then
		sudo defaults delete $pref SuppressDeviceDisconnectAlerts
		echo "🔊 Restoring audio disconnection notifications..."
	else
		echo "🔊 iPhone was already enabled."
	fi
}
yesiphone() {
	if sudo defaults read $pref SuppressDeviceDisconnectAlerts 2>/dev/null | grep -q 1; then
		echo "🔇 iPhone was not enabled."
	else
		sudo defaults write $pref SuppressDeviceDisconnectAlerts -bool true
		echo "🔇 Disabling audio disconnection notifications..."

	fi
	sudo killall coreaudiod
}

iPhoneMicNotifMurderer() {
	echo "🔪 Killing Audio Disconnection popups..."
	echo "This is a polling method, by the way."
	echo "Press [Enter] to continue"
	while true; do
		# Look for the process that spawns the popup (usually NotificationCenter or coreaudiod helper)
		pkill -f "Audio Disconnected" 2>/dev/null
		sleep 1
	done
}

murder() {
	echo "🔪 Killing $1"
	echo "This function uses a polling method, by the way."
	echo "Press [Enter] to continue."
	read
	while true; do
		pkill -f "$1" 2>/dev/null
		sleep 1
	done
}
alias redrum="murder"

TRAPDEBUG() {
	# You READ the variable here.
	if [[ -z "$ZSH_DEBUG" ]]; then
		return
	elif [[ "$ZSH_DEBUG" == "true" || "$ZSH_DEBUG" == "1" ]]; then
		echo "The next command is: $ZSH_DEBUG_CMD" >>"$HOME/Desktop/zsh_debug.log"
		return
	else
		return
	fi
}

collect-secrets() {
	local timestamp="$(date +%s)"
	local maxRequestsPerMinute=200 # ggshield rate limit per https://docs.gitguardian.com/api-docs/usage-and-quotas
	local numberOfFilesScanned=0
	local dir="$1"

	echo "Scanning directory: $dir"

	find . -type d | tee tmp.directories.list
	find . -type f | tee tmp.files.list

	local iteration

	iteration() {
		local file="$1"

		if ((numberOfFilesScanned % maxRequestsPerMinute == 0)); then
			secondsToWait=$((61 - ($(date +%s) - timestamp))) # 61 just to be sure...
			((secondsToWait < 0)) && secondsToWait=0
			echo "Rate limit reached. Waiting $secondsToWait seconds..."
			sleep $secondsToWait
			timestamp="$(date +%s)"
		fi

		echo "Scanning file: $file"
		ggshield secret scan path "$(realpath "$file")" --json --show-secrets -v >./tmp.secrets.json

		jq -r '
            .entities_with_incidents[]
            .incidents[]
            .occurrences[]
            .match
            ' tmp.secrets.json | sed '/^$/d' | sort -u >>tmp.secrets.list

		rm -f tmp.secrets.json
	}

	while IFS= read -r file; do
		iteration "$file"
		((numberOfFilesScanned++))
	done <tmp.files.list

	cat tmp.secrets.list | sort -u >secrets.list

	rm -f tmp.*.list

	if [[ ! -s secrets.list ]]; then
		echo -e "✅ \033[38;5;2m 󱙝 No secrets found! 󱙝\033[0m ✅"
	else
		echo -e "❌ \033[38;5;1m 󱚞 $(wc -l <secrets.list) secrets found 󱚞 \033[0m ❌"
	fi
}

scan-secrets() {
	$(
		local args_output
		args_output=$(
			deno eval -- "$@" <<'EOF'
for (const arg of Deno.args) {
  console.log(arg)
}
EOF
		)

		echo "$args_output"
	)

	local -a args
	if [[ -n "$args_output" ]]; then
		IFS=$'\n' args=($args_output)
	else
		args=()
	fi

	# State
	local destroyNonASCIIFiles=0

	# helper: creates secrets.list

	# Start
	echo "Collecting secrets..."
	if ($args[2] == "-v" || $args[2] == "--verbose"); then
		echo "Arguments: $args"
		collect-secrets "$(realpath ./)"
	else
		collect-secrets "$(realpath ./)" >/dev/null
	fi

	echo "Redacting..."

	# helper: escape secret for sed replacement
	local escape_sed
	escape_sed() {
		# escape &, |, and \ which matter in sed with | as delimiter
		printf '%s\n' "$1" | sed 's/[&|\\]/\\&/g'
	}

	while IFS= read -r secret; do
		[[ -z $secret ]] && continue
		echo "Scrubbing: $secret"
		local escaped
		escaped=$(escape_sed "$secret")

		# search for files containing this secret
		grep -Rl -- "$secret" . |
			grep -v -E '(^|/)(secrets\.json|secrets\.list)$' |
			while IFS= read -r file; do
				# detect binary-ish vs text-ish
				if ! LC_ALL=C grep -Iq . -- "$file"; then
					# binary file path
					if ((destroyNonASCIIFiles == 0)); then
						echo "Binary file with secret detected: $file"
						read -q "resp?Delete ALL binary secret files? [y/N] "
						echo
						if [[ $resp == [Yy] ]]; then
							destroyNonASCIIFiles=1
						else
							destroyNonASCIIFiles=2
						fi
					fi

					if ((destroyNonASCIIFiles == 1)); then
						echo "  Destroying binary file: $file"
						/bin/rm -f -- "$file"
					else
						echo "  Skipping binary file: $file"
					fi
				else
					echo "  Editing text file: $file"
					sed -i '' "s|$escaped|<<REDACTED>>|g" "$file"
				fi
			done
	done <secrets.list
	echo -e "󱙝 \033[38;5;2mScan complete!\033[0m 󱚞 And be careful out there, Southern Outlaw..."
	echo "Hint: execute \`collect-secrets\` and then check \`secrets.list\` for any remaining secrets."
}

alias redact="scan-secrets"
alias cover="scan-secrets"
alias scan="scan-secrets"

edit() {
	if [[ -z "$1" ]]; then
		echo "Usage: edit <file-or-command>"
		return 1
	fi

	local target

	# If it's a path, use it; otherwise resolve as a command.
	if [[ -e "$1" ]]; then
		target="$1"
	else
		target="$(command -v -- "$1")" || {
			echo "edit: not found: $1" >&2
			return 1
		}
	fi

	# Directories → Dired
	if [[ -d "$target" ]]; then
		emacs "$target"
		return
	fi

	# Text vs binary
	if file "$target" | grep -qi 'text'; then
		emacs "$target"
	else
		# Binary: make BOTH views
		local base hexfile strfile
		base="$(basename "$target")"

		strfile="$(mktemp -t "edit.${base}.str.XXXXXX")" || return 1
		hexfile="$(mktemp -t "edit.${base}.hex.XXXXXX")" || return 1

		strings "$target" >"$strfile"
		xxd "$target" >"$hexfile"

		# Open both in Emacs; you can split and flip between them.
		emacs "$strfile" "$hexfile"
	fi
}

abc() {
	args=deno eval <<EOF
let args="$@".split(" ");
console.log(args)
EOF
	strings "$1"
}

imgcloud() {
	echo -e "\033[5mThis is now \"imgcloud\" - a wrapper on gcloud.\033[0m".
	path="$(realpath $1)"
	echo -e "Backing up $path to gs://imgfunnels.com$path..."

	gcloud -r "$path" "gs://imgfunnels.com$path"
}

() {
	tput bel
}

list() {
	# Define a new array called 'my_args'
	argv=("$@")

	usage() {
		echo -e "\033[38;2;255;20;0mUsage: \033[0m$0 \033[2m<arguments>\033[0m"
		echo "n Results:
FIRST_ARGUMENT
SECOND_ARGUMENT
THIRD_ARGUMENT
FOURTH_ARGUMENT
Up to 50..."
	}

	if [[ -z "$argv" ]]; then
		usage
	fi

	# Print the elements of the array
	echo "${#argv[@]} Results:"
	v="0"
	# Construct the variable name dynamically
	nextArgv="argv${v}"

	# Access the value of the dynamically named variable using ${(P)}
	for item in "${argv[@]}"; do
		((v++))
		export argv${v}="$item"
		echo "argv${v}=$item"
	done

	echo "Press \033[38;2;255;205;0m[CTRL-c]\033[0m to quit and use your list as variables only."
	echo "Enter a filename to create a file"
	echo -ne "Filename:"
	read -r filename

	touch "./$filename"
	for item in "${argv[@]}"; do
		echo "$item" >>$filename
	done
}

bhamjobs() {
	srv && pushd bhamjobs.com && texas ./serve
}

js() {
	open "https://developer.mozilla.org/en-US/docs/Web/API/Performance"
}

timer() {
	TRAPEXIT() {
		deno run --allow-net - <<EOF
fetch("http://imgnx.org/2F34F3F9-2F9B-4FC6-BC91-F1AC8101A6D7", {
		method: "POST",
		body: JSON.stringify({
		      "message": "You left a timer running."
		})
});
EOF
	}
	sleep "$1" && alert
	if chkyn "Restart the timer?"; then
		timer "$1"
	fi
}

resetaudio() {
	sudo killall coreaudiod
}
alias noaudio="resetaudio"
alias resetcoreaudio="resetaudio"
alias coreaudio="resetaudio"
alias audio="resetaudio"

# Start  AI
#__wrap_notice codex
#codex() {
#    codex_hb="$(/opt/homebrew/bin/codex \"$@\")";
#    codex_local="$(/Users/donaldmoore/bin/codex \"$@\")";
# Comment the following line out to return to managed codex.
# codex_hb && return 0
#    return codex_local;
#}

resume() {
	uuid="$(cat ./codex)"
	codex resume "$uuid"
}
# End of Codex AI

keys() {
	name="$1"
	security find-generic-password -a "$USER" -s "$name" -w 2>/dev/null | pbcopy || return 1
}
alias pass="keys"
alias k="keys"

al() {
	emacs /Users/donaldmoore/.config/zsh/aliases.zsh
}

a() {
	ls -la
}

__wrap_notice nginx
nginx() {
	cd "/opt/homebrew/etc/nginx"
	echo "The configuration is in here. If you really want to start the server, use the following:"
	echo -e "\033[38;2;145;152;164m/opt/homebrew/bin/nginx\033[0m"
}

format() {
	if [[ -z "$1" ]]; then
		echo "Usage: $0 <file>"
	else
		filename="$1"
		extension="${filename:e}"
		if [[ $extension == "php" ]]; then
			php-cs-fixer fix "$1"
		elif [[ $extension == "js" || extension == "css" || extension == "html" ]]; then
			npx prettier -w "$1"
		fi
	fi
}

draft() {
	cd "$DINGLEHOPPER/draft"
}

oncd() {
	pushd "$(realpath ./)"
	if [[ -f ./.automx ]]; then
		./.automx
	fi
	tree -L 2
}

# fn.sh() {
# 	emacs "$HOME/.config/zsh/fn.sh"
# }

# codex() {
#     sudo tee /opt/homebrew/bin/codex "$@" ./codex && "$(cat ./codex | tail -n 10 | grep "codex resume" > ./codex-resume)" && chmod +x ./codex-resume
# }

wakewin() {
	ssh min.local 'powershell.exe Stop-Process -Name explorer -Force; Start-Process explorer'
}

function daw() {
	cd "$MODULES/BARE/digital-audio-workspace/"
}

fnsh() {
	$EDITOR "/Users/donaldmoore/.config/zsh/fn.sh"
}
alias functions="fnsh"
alias fn="fnsh"

forline() {
	emulate -L zsh
	local file="$1"
	shift
	local line
	while IFS= read -r line; do
		"$@" "$line"
	done
}

#eq() {
#    cd "/Users/donaldmoore/Documents/Aequilibrium"
#}

# _taku_venv() {
# 	python -m venv --prompt "${PWD:t}" .venv
# 	source .venv/bin/activate
# }

navi() {
	while true; do
		tput bel
		tput bel
		sleep 5
		tput bel
		tput bel
		sleep 10
		tput bel
		tput bel
		sleep 20
		tput bel
		tput bel
		sleep 40
		tput bel
		tput bel
		sleep 80
	done

}

# tri() {
#     # "Fish" commands -- lightweight,f ast, and fun...
#     cd $DINGLEHOPPER/triage/$1
# }

exitall() {
	while ((SHLVL > 1)); do
		echo "Exiting nested shell (PID=$$)…"
		exit
	done
	echo "At root shell (PID=$$)"
}

dh() {
	cd "$DINGLEHOPPER"
}
srv() {
	cd "$DINGLEHOPPER/srv"
}

activate() {
	. ./.venv/bin/activate
}

__wrap_notice reset
reset() {
	/usr/bin/reset && exec zsh -l
}

# yarn() {
#     pnpm "$@"; # muahahah
# }

# re() extracted to bin/zsh-re
source "${ZDOTDIR:-.}/bin/zsh-re"

alert() {
	while true; do
		tput bel
		read -t 2 || continue
		break
	done
	fg
}

daily() {
	setopt local_options monitor
	"$@" |& $EDITOR &
	alert
	fg %+
}

srv() {
	cd "$SRC/dinglehopper/srv"
}

salsa() {
	echo "=== 🌶️ Salsa Sampler ==="
	echo "User: $USER  Host: $(hostname)"
	echo "OS: $(sw_vers -productName) $(sw_vers -productVersion) ($(uname -m))"
	echo "Shell: $SHELL"
	echo "Uptime: $(uptime | sed -E 's/.*up ([^,]+), .*/\1/')"
	echo "Dir: $(pwd)"
	echo "Git: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo none) \
$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ') changes"
	echo "CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo n/a)"
	echo "Mem: $(vm_stat | awk '/Pages free/ {free=$3} /Pages active/ {active=$3} /Pages inactive/ {inactive=$3} /Pages speculative/ {spec=$3} END {gsub("\\.", "", free); gsub("\\.", "", active); gsub("\\.", "", inactive); gsub("\\.", "", spec); total=(free+active+inactive+spec)*4096/1024/1024/1024; printf("~%.1f GiB", total)}') (approx)"
	echo "Disk: $(df -h / | awk 'NR==2 {print $5 " used of " $2}')"
	echo "IP: $(ipconfig getifaddr en0 2>/dev/null || echo n/a)  \
WAN: $(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || echo n/a)"
	echo "Top procs:"
	(ps -A -o %cpu,%mem,comm | sort -nr | head -n 5 || true)
	echo "Recent files:"
	eza -lbGd --header --git --sort=modified --color=always --group-directories-first | head -n 10
	echo "=== 🌶️ End Salsa ==="
}

triage() {
	cd /Users/donaldmoore/src/dinglehopper/triage || return 1
	echo -e "\033[5mWelcome!\033[0m"
	when | head -n 10
}
typeset -fx static
alias st=static
alias std=static
alias standalone=static

# can() extracted to bin/zsh-can
source "${ZDOTDIR:-.}/bin/zsh-can"

# --- wrapper on "undefined": zsh hook for missing commands -------------------
# If a command is not found, suggest brew install lines (formula vs cask)
command_not_found_handler() {
	emulate -L zsh
	local cmd="$1"
	shift
	print -r -- "🫥 undefined: \"$cmd\""
	echo "\`can\` for the command_not_found_handler is temporarily disabled while we investigate an ongoing issue."
	# dwimnwis "$cmd"
	# Todo: Fuzzy finder --- Checkpoint --- ::whistles:: --- ::holds up red card:: not checking for typos! #dwimnwis
	# Reuse can's logic to check PATH + brew and print suggestions
	# can use "$cmd"
	# Return non-zero to keep shell semantics ("command not found")
	return 127
}

# Gatekeeper toggle function for .zshrc
gtkpr() {
	if [[ -z "$GATEKEEPER_STATE" || "$GATEKEEPER_STATE" == "on" ]]; then
		echo "Disabling Gatekeeper for this session..."
		sudo spctl --master-disable
		defaults write com.apple.LaunchServices LSQuarantine -bool false
		export GATEKEEPER_STATE=off
	else
		echo "Re-enabling Gatekeeper..."
		sudo spctl --master-enable
		defaults write com.apple.LaunchServices LSQuarantine -bool true
		export GATEKEEPER_STATE=on
	fi

	# Show current state
	echo "Gatekeeper is now: $GATEKEEPER_STATE"
}

alias gatekeeper="gtkpr"

# docs() extracted to bin/zsh-docs
source "${ZDOTDIR:-.}/bin/zsh-docs"

imgnx() {
	local src="$1" dest="$2"
	if [[ -z "$src" || -z "$dest" ]]; then
		printf 'usage: xngmi <source> <dest>\n' >&2
		return 1
	fi

	if command -v rsync >/dev/null 2>&1; then
		if rsync -avh --no-links "$src" "$dest"; then
			return 0
		fi
		local rsync_status=$?
		printf 'rsync failed (exit %d); falling back to cp -R...\n' "$rsync_status" >&2
	else
		printf 'rsync not found; using cp -R...\n' >&2
	fi

	cp -a "$src" "$dest"
}

psql_export() {
	pg_dump -U donaldmoore -h localhost -p 5432 -F p -v --no-owner --no-comments --no-public -f "$HOME/tmp/${1}_backup.sql" ${1}

}

rose() {
	cd "$DH/stdln/_static_html/src/roses/one/"
}

logic() {
	if [["$1" == "--help" || "$1" == "-h"]]; then
		ls "$HOME/Documentation/Logic/*"
	else
		open -a "Logic Pro X"
	fi
}

#if [[ -z "$POST_LOGIN_HOOK_RAN" ]]; then
#	export POST_LOGIN_HOOK_RAN=1
# 	add-zsh-hook precmd scan_new_config_bins
# 	echo -e "\033[38;5;2m$ignoredPaths paths ignored.\033[0m"
# fi

# pomodoro() {
# 	sudo su
# 	afplay '/Users/donaldmoore/src/dinglehopper/assets/musical/mastering/Bellmorph G#1.wav'
# 	say "Sauce is ready\! Time to push\!";
# 	shutdown -r +5 "Sauce is ready\! Time to push\!"
# 	say "Clock is ticking. Shutdown is in 5 minutes."
# }

# orodomop() {
# 	pid=$(ps aux | grep "shutdown" | awk '{print $2}')
# 	echo "$pid"
# 	[ -n "$pid" ] && sudo kill "$pid"
# }

reminder() {
	# Check for the duration flag
	local duration=0
	local reminder=""
	local time_in_seconds=""

	# Parse the arguments
	while getopts "d:" opt; do
		case $opt in
		d)
			duration=$OPTARG # If -d is passed, set the duration in minutes
			;;
		*)
			echo "Usage: schedule_reminder [-d duration_in_minutes] <reminder_message>"
			return 1
			;;
		esac
	done
	shift $((OPTIND - 1)) # Remove the options from the arguments list

	# Get the reminder message (everything else)
	reminder="$*"

	# Convert duration to seconds if a duration flag is passed
	if [[ $duration -gt 0 ]]; then
		time_in_seconds=$((duration * 60))
	else
		# If no duration flag is passed, assume the second argument is in seconds
		time_in_seconds=$1
	fi

	# Check if the reminder message is empty or no time is provided
	if [[ -z $reminder || -z $time_in_seconds ]]; then
		echo "Please provide both a reminder message and time in seconds (or use the -d flag for minutes)."
		return 1
	fi

	# Schedule the reminder using 'at' (or 'osascript' for notifications)
	echo "osascript -e 'display notification \"$reminder\" with title \"Reminder\"'" | at now + $time_in_seconds seconds

	echo "Reminder set! The reminder will be triggered in $time_in_seconds seconds."
}

ucp() {
	/bin/cp "$@"
}
cpn() {
	cp "$@"
}
cp() {
	echo "The \`cp\` command is configured to **not** overwrite files. Use \`ucp\` if you **do** want it to overwrite Enter."
	echo -n "Press [ENTER] to continue."
	read
	/bin/cp -v -n "$@"
}

fnx_C6EE3E7B-5EB4-45F9-B13D-B451E169B079() {
	if pgrep -x "Hammerspoon" >/dev/null; then
		# If Hammerspon is running, quit it
		osascript -e 'quit app "Hammerspoon"'
	else
		# If Hammerspoon is not running, launch it
		open -a Hammerspoon
	fi
}

even_better_prompt() {
	local color branch gitinfo
	color=$(ggs 2>/dev/null)
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
		[[ -n $branch ]] && branch="/$branch"
		local remote
		remote=$(git remote -v 2>/dev/null | grep "origin" | head -1)
		remoteName="$(awk '{print $1}' <<<"$remote")"
		remoteUrl="$(awk '{print $2}' <<<"$remote")"

		local remote_part=""
		[[ -n $remote ]] && remote_part=" $remoteName"
		gitinfo="%F{$color}${remote_part}%F{#8aa6c0}${branch} %F{#deaded}($remoteUrl)%f"
	fi
	PROMPT='
'
	PROMPT+='%F{green}%n@'"${LOCAL_IP:-%M}"':%~%f'
	PROMPT+='
'
	[[ -n $gitinfo ]] && PROMPT+="$gitinfo "
	PROMPT+='
'
	PROMPT+=$''"${ZSH_NAME}"':%m => '

	RPROMPT='%F{#8aa6c0} [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f'
}

# # Schedule pomodoro function to run every 30 minutes using a loop
# pomodoro_scheduler() {
# 	while true; do
# 		sleep 1800  # 1800 seconds = 30 minutes
# 		pomodoro
# 	done
# }

# # Start the scheduler in the background
# pomodoro_scheduler &

# --- gpt: Chat with OpenAI from your terminal --------------------------------
# deps: curl, jq
# env: OPENAI_API_KEY (required)
#       GPT_MODEL (default: gpt-4o-mini)
#       GPT_SYSTEM (default: "You are a concise CLI assistant.")
#       GPT_TEMPERATURE (default: 0.3)
#
# usage:
#   gpt "Explain comb filters like I'm five"
#   echo "Summarize this text..." | gpt
#   gpt -m gpt-4o -t 0.1 "5 bullet tips for Logic Pro routing"
#   gpt -s "You are terse." "One-liner on Webpack HMR"
#   gpt --stream "Write a single haiku about Zsh"
#
# flags:
#   -m <model>         Override model (e.g., gpt-4o, gpt-4o-mini)
#   -s <system>        System prompt
#   -t <temperature>   0.0–1.0 (default 0.3)
#   --stream           Stream tokens live (Ctrl-C to stop)
#   -h|--help          Show help

back_up() {

	# Interactive backup with optional system volume and isolation
	# Usage: back_up [--full]

	local include_system=false
	if [[ "$1" == "--full" ]]; then
		include_system=true
	fi

	local EXCLUDE_DIRS_VAL="${EXCLUDE_DIRS:-(venv|\.git|node_modules)}"

	# Discover volumes
	local vols=("/Volumes/"*)
	local targets=()
	for vol in "${vols[@]}"; do
		local name="$(basename "$vol")"
		if [[ $include_system == false && "$name" == "Macintosh HD" ]]; then
			continue
		fi
		[[ -d "$vol" ]] && targets+=("$vol")
	done

	if [[ ${#targets[@]} -eq 0 ]]; then
		echo "No backupable volumes found under /Volumes."
		return 1
	fi

	# Sort for stable menu order
	local -a sorted
	local -a targets # Ensure targets is explicitly an array
	sorted=($(printf '%s\n' "${targets[@]}" | sort))

	# Selection: prefer fzf if available, else use select
	local selection=""
	if command -v fzf >/dev/null 2>&1; then
		selection=$(printf '%s\n' "${sorted[@]}" | fzf --prompt='Select volume > ' --height=40% --reverse)
		if [[ -z "$selection" ]]; then
			echo "No selection made. Aborting."
			return 1
		fi
	else
		local PS3="Select a volume to back up: "
		local opt
		select opt in "${sorted[@]}"; do
			if [[ -n "$opt" ]]; then
				selection="$opt"
				break
			else
				echo "Invalid selection. Try again."
			fi
		done
	fi

	local name="$(basename "$selection")"

	# Ask whether to isolate into its own folder in the bucket
	local isolate_answer
	printf "Isolate backup into gs://imgfunnels.com/%s/? (y/N): " "$name"
	read -r isolate_answer
	local dest="gs://imgfunnels.com"
	if [[ "$isolate_answer" == "y" || "$isolate_answer" == "Y" ]]; then
		dest="gs://imgfunnels.com/$name"
	fi

	echo "Syncing $selection -> $dest"
	PYTHONUNBUFFERED=1 gsutil rsync -r -e -x "$EXCLUDE_DIRS_VAL" "$selection" "$dest" </dev/null
	local status=$?
	if [[ $status -ne 0 ]]; then
		echo "Error syncing $name (exit $status)"
		return $status
	fi
	echo "Completed: $name"

	echo 'All backups complete.'
}

dictionary() {
	cd "$HOME/src/dinglehopper/assets/dictionary"
}
# Provide a simple alias; arguments are forwarded by the shell
alias dict="dictionary"

__wrap_notice gsutil
gsutil() {
	command gsutil "$@"
}

__wrap_notice gcloud

gcloud() {
	if [[ $1 == "sync" ]]; then
		shift
		local bucket="$1" src="${2:-$PWD}"
		if [[ -z "$bucket" ]]; then
			echo "Usage: gcloud sync <bucket> [dir]" >&2
			return 1
		fi

		if [[ "$bucket" != gs://* ]]; then
			bucket="gs://$bucket"
		fi
		bucket="${bucket%/}"

		local abs_src
		abs_src=$(cd "$src" && pwd) || return 1
		local dest="${bucket}/${abs_src#/}"

		echo "Syncing $abs_src -> $dest"
		command gsutil -m rsync -d -r "$abs_src" "$dest"
		return $?
	fi

	command gcloud "$@"
}

bucket() {
	command gsutil cp -r "$1" gs://imgfunnels.com/
}

pbucket() {
	command gsutil cp -r "$1" gs://re_imgnx
}

# Ensure Emacs uses XDG init dir (Emacs 29+: --init-directory)
# __wrap_notice emacs
# emacs() {
#     local initdir="${EMACSDIR:-$XDG_CONFIG_HOME/emacs}"
#     if command emacs --help 2>&1 | grep -q -- '--init-directory'; then
#         command emacs --init-directory "$initdir" "$@"
#     else
#         EMACSDIR="$initdir" DOOMDIR="${DOOMDIR:-$XDG_CONFIG_HOME/doom}" DOOMLOCALDIR="${DOOMLOCALDIR:-$XDG_CONFIG_HOME/emacs/.local}" command emacs "$@"
#     fi
# }

lock() {
	sudo chflags -R uchg "$@"
}

unlock() {
	sudo chflags -R nouchg "$@"
}

tuner() {
	open -a "Universal Tuner"
}

visudo() {
	/usr/sbin/visudo VISUAL="emacs"
}

dh() {
	cd "$HOME/src/dinglehopper"
}

get_diff() {
	curr=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
	diff="$((curr - IMGNXZINIT))"
	if [[ $diff -gt 1000 ]]; then
		diff="%F{yellow}$(printf "%d.%03d" "$((diff / 1000))" "$((diff % 1000))")%f"
	elif [[ $diff -gt 300 ]]; then
		diff="%F{green}$(printf "%dms" "$diff")%f"
	else
		diff="%F{magenta}$(printf "%dms" "$diff")%f"
	fi

	echo "$diff"
}

better_prompt() {
	local color branch gitinfo stats stat_parts stat
	color="$(ggs)"
	stats="${IMGNX_STATS:-}"

	branch=""
	gitinfo=""

	# Git info
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no git")
		[[ -n "$branch" && "$branch" != "no git" ]] && branch="/$branch"
		local remote="$(git remote 2>/dev/null)"
		local remote_part=""
		[[ -n "$remote" ]] && remote_part=" $remote"
		gitinfo="%F{$color}${remote_part}%F{#8aa6c0}$branch%f"
	fi

	# Compose PS1
	PS1="
"
	[[ -n "$gitinfo" ]] && PS1+="
$gitinfo "
	card=0
	if [[ -n "$stats" ]]; then
		card=$((card + 1))
		# Split stats by tabs, colorize each part
		# Split stats string by tab into array, handle empty or unset
		if [[ -n "$stats" ]]; then
			# Todo: Replace spaces with tabs.
			stat_parts="${stats}"
		else
			stat_parts=()
		fi
		for stat in $stat_parts; do
			case $card in
			1) PS1+=" %F{#FF007B}${stat}%f" ;; # CPU
			2) PS1+=" %F{#007BFF}${stat}%f" ;; # RAM
			3) PS1+=" %F{#7BFF00}${stat}%f" ;; # Zsh count
			*) PS1+=" %F{#fca864}${stat}%f" ;; # Default color
			esac
			card=$((card + 1)) # Increment card for each stat
		done
	fi

	PS1+="CPU: $(top -l 1 | grep 'CPU usage' | awk '{print $3}' | tr -d '%'), PhysMem: $(top -l 1 | grep 'PhysMem' | awk '{print $2}')"

	PS1+='%F{green}%n@'"${LOCAL_IP}"':%~%f'
	PS1+="
%B%F{#FF007B}$(basename $SHELL) %f%F{#FFFFFF}%m %F{#7BFF00}=>%b
"
	RPS1='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f'
}

__wrap_notice rm
rm() {

	local flags=()
	local files=()
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-*) flags+=("$1") ;; # Collect flags
		*) files+=("$1") ;;  # Collect file paths
		esac
		shift
	done

	for file in "${files[@]}"; do
		local abs_path="$(realpath "$file" 2>/dev/null)"

		# Check if the file is in any user's .Trash directory
		if [[ "$abs_path" =~ ^/Users/.*/\.Trash/ ]]; then
			/bin/rm "${flags[@]}" "$file" # Call /bin/rm directly if file is in any user's .Trash
			return
		fi

		# Otherwise, move it to the user's .Trash
		if [[ -e "$file" ]]; then
			local trash_path="$HOME/.Trash$abs_path"
			mkdir -p "$(dirname "$trash_path")"
			mv "$file" "$trash_path"
		fi
	done

	# If only flags were passed, fallback to system rm
	if [[ ${#files[@]} -eq 0 ]]; then
		/bin/rm "${flags[@]}"
	fi
}

init() {
	# Due to issues with corruption, this is the new ~/bin
	. $HOME/src/init/main.sh
}

find() {
	# Unix find
	/usr/bin/find "$@"
}

# midi() {
# 	cd "/Users/donaldmoore/src/dinglehopper/stdln/midi"
# todo: cargo build? python? node? How do you run it
#
# }

# __wrap_notice find
# find() {
#    tempfile=$(mktemp)
#    trap 'rm -f "$tempfile"' EXIT
#    if /usr/bin/find "$@" > "$tempfile"; then
#	bat -A --style=plain "$tempfile"
#    else
#	/usr/bin/find "$@"
#    fi
#}

import() {
	prompt=(
		"Did you mean to run \033[5;38;5;1mimport\033[0m in the current terminal? \033[38;5;5mimport\033[39m is currently set to run ImageMagick."
		'You likely meant to add a shebang to the top of a JavaScript file and the terminal found an "import" statement instead.'
		"Here is the shebang for Node.js:\n\n\033[38;5;2m\#!/usr/bin/env node\033[39m\n\n"
		'Is this what you meant to do? (y/N)'
	)

	answer="$(safeguard "${prompt[@]}")"

}

dinglehopper() {
	cd $SRC/dinglehopper
}

hop() {
	before="$PWD"
	cd $(realpath)
	after="$PWD"
	echo -e "\033[38;2;255;205;0m@realpath/hop: \033[0m$before -> $after"
}

clean_old() {
	# Define directories to clean
	local dirs_to_clean=(
		"node_modules" "target" ".yarn" ".next" "venv" "dist" "build" "coverage"
		".pytest_cache" ".cache" ".parcel-cache" ".svelte-kit" ".turbo" ".expo"
		".angular" ".vercel" ".nuxt" "__pycache__" ".mypy_cache" ".sass-cache"
		".grunt" ".bower_components" ".jspm_packages" ".serverless" ".firebase"
		".idea"
	)

	# Define files to clean
	local files_to_clean=(
		".DS_Store" ".env" ".eslintcache"
	)

	# Remove directories
	for dir in "${dirs_to_clean[@]}"; do
		ufind . -maxdepth 3 -type d -name "$dir" -exec zsh -c "echo \"execute \033[14mrm -rf {}? | read\"" \; -exec rm -rf {} +
	done

	# Remove files
	for file in "${files_to_clean[@]}"; do
		ufind . -maxdepth 3 -type f -name "$file" -exec zsh -c "echo \"execute \033[14mrm -f {}? | read\"" \; -exec rm -f {} +
	done
}

tile() {
	open -a "/Users/donaldmoore/Applications/Tile.app/Contents/MacOS/ShortcutDroplet"
}

function tree() {
	command tree -C --gitignore "$@"
	echo -e "\033[38;2;255;205;0mNotice: \`tree\` is wrapped to ignore files from .gitignore and also to output in color.\033[0m\n"
}

function fzf_file_menu() {
	# A function for opening files in a menu with `fzf`
	local file
	file=$(ufind . -type f | fzf --preview 'cat {}' --preview-window=right:50%:wrap)

	if [[ -n "$file" ]]; then
		echo "Selected: $file"
		# Add actions here, like opening or copying the file
		selected_action=$(echo -e "Open\nCopy\nDelete" | fzf)
		case "$selected_action" in
		Open) open "$file" ;;
		Copy) cp "$file" ~/Documents/ ;;
		Delete) rm "$file" ;;
		esac
	fi
}

peachtree() {
	for dir in $(ufind . -type d); do
		count=$(ufind "$dir" -maxdepth 1 -type f | wc -l)
		echo "$dir ($count)"
	done
}

ptree() {
	local dir="$1"
	local indent="$2"
	local count

	count=$(find "$dir" -maxdepth 1 -type f | wc -l)
	echo "${indent}$(basename "$dir") ($count files)"

	setopt noglob

	for subdir in "$dir"/*/; do
		if [ -d "$subdir" ]; then
			print_tree "$subdir" "$indent  ├─"
		fi
	done

	unsetopt noglob
}

taku.init() {

	# Exit immediately if a command exits with a non-zero status
	set -e

	# Display the script's progress
	echo "Starting setup..."

	# 1. Create the project directory
	echo "Creating project directory..."
	mkdir -p taku-app
	cd taku-app

	# 2. Initialize a new Node.js project
	echo "Initializing Node.js project..."
	npm init -y

	# 3. Install required dependencies
	echo "Installing dependencies..."

	# Install Webpack and required plugins
	npm install --save-dev webpack webpack-cli webpack-dev-server html-webpack-plugin style-loader css-loader

	# Install React and ReactDOM
	npm install react react-dom --save

	# Install Tailwind CSS for styling
	npm install tailwindcss postcss autoprefixer --save-dev
	npx tailwindcss init

	# 4. Create the basic project structure
	echo "Creating basic project structure..."

	# Create the main HTML file
	cat >index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Web Audio Experiment</title>
</head>
<body class="bg-gray-800 text-white">
<div id="root"></div>
</body>
</html>
EOF

	# Create the src directory
	mkdir -p src/components

	# Create the App.js file for React
	cat >src/App.js <<EOF
import React from 'react';
import './styles.css';
import Component from './Component';

function App() {
return (
	<div className="App">
	<Component />
	</div>
);
}

export default App;
EOF

	# Create the Component.js file
	cat >src/Component.js <<EOF
import React, { useEffect, useRef, useState } from 'react';

const Component = () => {
const [isPlaying, setIsPlaying] = useState(false);
const audioContext = useRef(null);
const oscillator = useRef(null);
const gainNode = useRef(null);
const filter = useRef(null);
const lfo = useRef(null);
const modulator = useRef(null);
const convolver = useRef(null);

useEffect(() => {
	// Initialize Web Audio API context
	audioContext.current = new (window.AudioContext || window.webkitAudioContext)();

	// Set up oscillator
	oscillator.current = audioContext.current.createOscillator();
	oscillator.current.type = 'sine';
	oscillator.current.frequency.setValueAtTime(440, audioContext.current.currentTime);

	// Set up gain node (volume control)
	gainNode.current = audioContext.current.createGain();
	gainNode.current.gain.setValueAtTime(0.5, audioContext.current.currentTime);

	// Set up filter (low-pass)
	filter.current = audioContext.current.createBiquadFilter();
	filter.current.type = 'lowpass';
	filter.current.frequency.setValueAtTime(1000, audioContext.current.currentTime);

	// Set up LFO for tremolo effect
	lfo.current = audioContext.current.createOscillator();
	lfo.current.type = 'sine';
	lfo.current.frequency.setValueAtTime(5, audioContext.current.currentTime);

	modulator.current = audioContext.current.createGain();
	modulator.current.gain.setValueAtTime(0.5, audioContext.current.currentTime);

	// Set up reverb (convolution)
	convolver.current = audioContext.current.createConvolver();
	fetch('path/to/impulse-response.wav')
	.then((response) => response.arrayBuffer())
	.then((buffer) => audioContext.current.decodeAudioData(buffer))
	.then((decodedData) => {
		convolver.current.buffer = decodedData;
	});

	// Connect everything
	oscillator.current.connect(filter.current);
	filter.current.connect(gainNode.current);
	gainNode.current.connect(audioContext.current.destination);

	// Connect LFO to modulator, and modulator to gain node
	lfo.current.connect(modulator.current);
	modulator.current.connect(gainNode.current);

	// Start the LFO and oscillator
	lfo.current.start();
	oscillator.current.start();

	return () => {
	if (audioContext.current) {
		oscillator.current.stop();
		lfo.current.stop();
		audioContext.current.close();
	}
	};
}, []);

const playTone = () => {
	if (audioContext.current.state === 'suspended') {
	audioContext.current.resume();
	}
	setIsPlaying(true);
	oscillator.current.start();
};

const stopTone = () => {
	oscillator.current.stop();
	setIsPlaying(false);
};

return (
	<div className="flex flex-col items-center p-4 bg-gray-800 text-white min-h-screen">
	<h1 className="text-3xl font-bold mb-6">Web Audio API Experiment</h1>
	<div className="space-x-4 mb-6">
		<button onClick={playTone} disabled={isPlaying}>Play Tone</button>
		<button onClick={stopTone} disabled={!isPlaying}>Stop Tone</button>
	</div>
	</div>
);
};

export default Component;
EOF

	# Create a Tailwind CSS file for custom styling
	cat >src/styles.css <<EOF
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

body {
font-family: 'Arial', sans-serif;
}
EOF

	# 5. Create Webpack configuration file
	cat >webpack.config.js <<EOF
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
entry: './src/index.js',
output: {
	path: path.resolve(__dirname, 'dist'),
	filename: 'bundle.js',
},
module: {
	rules: [
	{
		test: /\.js$/,
		exclude: /node_modules/,
		use: 'babel-loader',
	},
	{
		test: /\.css$/,
		use: ['style-loader', 'css-loader'],
	},
	],
},
plugins: [
	new HtmlWebpackPlugin({
	template: './index.html',
	}),
],
devServer: {
	contentBase: './dist',
	hot: true,
},
};
EOF

	# 6. Set up Babel for React JSX support
	npm install --save-dev @babel/core @babel/preset-env @babel/preset-react babel-loader

	# 7. Set up npm scripts for start and build commands
	echo "Configuring npm scripts..."

	sed -i '' 's/"scripts": {/&\n    "start": "webpack serve --open",\n    "build": "webpack --mode production",/' package.json

	echo "Installing Python"

	# Default to Python
	PYTHON=${PYTHON:-python}

	# Create virtual environment if it doesn’t exist
	if [ ! -d ".venv" ]; then
		echo "[Taku] Creating virtual environment..."
		$PYTHON -m venv .venv
	fi

	# Activate the environment
	echo "[Taku] Activating .venv"
	source .venv/bin/activate

	# Upgrade pip (optional, but usually helpful)
	pip install --upgrade pip

	# 8. Run the app (optional step, can be run later)
	echo "Project setup complete! Run 'npm start' to start the app."
}

dir() {
	hash "$@"
}

cnf() {
	if [[ "$1" == "init" ]]; then
		local project_name
		local basedirname="$(basename $(realpath $pwd))" # default to the basename of the current working directory.

		if [[ -z "$2" ]]; then

			echo -en "\033[38;2;255;234;0mPlease enter a name for your project.\033[0m
project-name: (default: ${basedirname})"
			read -r project_name
			if [[ -z "$project_name" ]]; then
				project_name="$basedirname"
			fi

		else

			project_name="$2"
		fi

		local target="$XDG_CONFIG_HOME/$project_name"
		echo "Copying blueprints to \"${XDG_CONFIG_HOME}/${project_name}\""
		mkdir -p "$target"
		if [[ -d "$BLUEPRINTS" ]]; then
			find "$BLUEPRINTS" -maxdepth 1 -mindepth 1 -iname "*.md" | xargs -I{} cp "{}" "$target"
		fi
		echo "Opening $EDITOR in $XDG_CONFIG_HOME/$1"
	fi

	$EDITOR "$XDG_CONFIG_HOME/$1"
}

copy() {
	$@ | pbcopy
	export v=$(pbpaste)
}

# v() {
#  echo $(pbpaste)
# }

# /usr/local/bin/git on macOsX w/ Intel chip
alias ugit=/usr/bin/git
__wrap_notice git

taku-electron() {
	local project_name="$(basename $(realpath $pwd))"
	if [[ -z "$2" ]]; then
		set -e

		APP_NAME="${2:-$project_name}"
		mkdir -p "$APP_NAME"
		pushd "$APP_NAME"
		mkdir -p src
		mkdir -p desktop
		mkdir -p desktop/public
		npm init -y
		npm install --save-dev electron browser-sync >/dev/null 2>&1
		npm install --save react react-dom tailwindcss @tailwindcss/cli >/dev/null 2>&1
		touch "./public/index.html"

		cat <<'@@@' >main.js
const { app, BrowserWindow } = require('electron')

function createWindow () {
	const win = new BrowserWindow({
		width: 1920,
		height: 1080,
		webPreferences: {
		nodeIntegration: true,
		contextIsolation: true
	}
})

win.loadFile('index.html')
	}
	app.whenReady().then(() => {
		 createWindow()
			 app.on('activate', () => {
			    if (BrowserWindow.getAllWindows().length === 0) createWindow()
			})
				     })

			app.on('window-all-closed', () => {
				if (process.platform !== 'darwin') app.quit()
			})
@@@

		cat <<'@@@' >index.html
		<!DOCTYPE html>
		<html>
		<head>
		<meta charset="UTF-8">
		<title>Electron App</title>
		<style>
		body {
		    background-color: "#181820";
		}
		</style>
		</head>
		<body>
		<h1>Taku!</h1>
		<p>If you can read this, it worked.</p>
		</body>
		</html>
		\EOF

		node - <<\\EOF
		const fs = require('fs')
		const pkgPath = 'package.json'
		const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'))
		pkg.scripts = pkg.scripts || {}
		pkg.scripts.start = 'electron .'
		pkg.scripts.dev = 'browser-sync'
		fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2))
@@@

		#			    echo -e "\033[38;2;0;209;255mDone\!\033[0m Happy hacking\!"
		#	    echo "Run:"
		#	    echo "  cd $APP_NAME"
		#	    echo "  npm start"
	fi
}

init_capacitor() {

	mkdir -p ./mobile

	# 1. build your web app
	cd mobile
	npm run build

	# 2. add capacitor
	cd ..
	npm install @capacitor/core @capacitor/cli

	npx cap init com.example.app \
		--web-dir=mobile/dist
	# 3. add platforms

	npx cap add ios
	npx cap add android
}

taku-swift() {
	mkdir -p ./swift && pushd ./swift
	echo "Creating executable..."
	swift package init --type executable
	cat <<'EOF' >"WebKitAppDelegate.swift"
import Cocoa
import WebKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {

        // ----- Window -----
        let windowSize = NSRect(x: 0, y: 0, width: 1200, height: 800)
        window = NSWindow(
            contentRect: windowSize,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window.center()
        window.title = "React Host"
        window.makeKeyAndOrderFront(nil)

        // ----- WebView -----
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")

        let webView = WKWebView(frame: window.contentView!.bounds,
                                configuration: config)
        webView.autoresizingMask = [.width, .height]

        // ===== CHOOSE ONE =====

        // DEV: React dev server (Vite / CRA)
        let url = URL(string: "http://localhost:5173")!

        // PROD: Bundled React build
        // let url = Bundle.main.url(forResource: "index", withExtension: "html")!

        webView.load(URLRequest(url: url))
        window.contentView?.addSubview(webView)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
EOF
	echo -e "\033[32mSwift package init complete."
	popd
}

taku-c() {
	local project_name="$(basename -- "$PWD")"
	local app_name="${1:-$project_name}"

	mkdir -p -- "$app_name"
	pushd -- "$app_name" >/dev/null || exit 1

	cat <<'EOF' >"./${project_name}.c"
/*
PURE C (Linux) — GTK4 + WebKitGTK (loads your React dev server)

Install (Ubuntu 24.04+):
  sudo apt update
  sudo apt install -y build-essential pkg-config libgtk-4-dev libwebkitgtk-6.0-dev

Build:
  cc -O2 -Wall -Wextra main.c -o react_host \
    $(pkg-config --cflags --libs gtk4 webkitgtk-6.0)

Run (React dev server should be running):
  ./react_host http://localhost:5173
  # or CRA: ./react_host http://localhost:3000

Sources:
- WebKitGTK “webkitgtk-6.0 is the GTK4 API version” (migration note)
- WebKitWebView can load any URI
(See: webkitgtk.org reference/migration docs)

---------------------------------------------
main.c
---------------------------------------------
*/
#include <gtk/gtk.h>
#include <webkit/webkit.h>

static void on_activate(GtkApplication *app, gpointer user_data) {
    const char *uri = (const char *)user_data;
    if (!uri || uri[0] == '\0') uri = "http://localhost:5173";

    GtkWidget *win = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(win), "React Host (GTK4 + WebKitGTK)");
    gtk_window_set_default_size(GTK_WINDOW(win), 1200, 800);

    GtkWidget *web = webkit_web_view_new();
    gtk_window_set_child(GTK_WINDOW(win), web);

    webkit_web_view_load_uri(WEBKIT_WEB_VIEW(web), uri);

    gtk_window_present(GTK_WINDOW(win));
}

int main(int argc, char **argv) {
    const char *uri = (argc > 1) ? argv[1] : "http://localhost:5173";

    GtkApplication *app = gtk_application_new("com.example.react_host",
                                              G_APPLICATION_DEFAULT_FLAGS);

    g_signal_connect(app, "activate", G_CALLBACK(on_activate), (gpointer)uri);

    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}

/*
================================================================================
C++ OPTION (cross-platform-ish) — tiny “webview” library (C/C++ wrapper)
This is NOT GTK/WebKitGTK directly; it uses the platform webview under the hood.
Good when you want one tiny dependency instead of GTK stacks.

Repo: https://github.com/webview/webview (single-header style; supports bindings)

---------------------------------------------
main.cpp
---------------------------------------------
Build (example):
  c++ -O2 -std=c++17 main.cpp -o react_host_cpp

You need to vendor webview.h and follow its platform-specific link flags.
(They differ per OS; see the repo README.)

---------------------------------------------
main.cpp
---------------------------------------------
*/
#if 0
#include "webview.h"
#include <string>

int main(int argc, char** argv) {
    std::string url = (argc > 1) ? argv[1] : "http://localhost:5173";

    webview_t w = webview_create(0, nullptr);
    webview_set_title(w, "React Host (webview)");
    webview_set_size(w, 1200, 800, WEBVIEW_HINT_NONE);
    webview_navigate(w, url.c_str());
    webview_run(w);
    webview_destroy(w);
    return 0;
}
#endif
EOF
	# 	fi
}

# git() extracted to bin/zsh-git
source "${ZDOTDIR:-.}/bin/zsh-git"

# Get the path of the current script
script_path="${0}"

echo "$PATH" | grep -q "/Users/donaldmoore/bin" || export PATH="$HOME/bin:$PATH"

# Declare associative array for TODO cache
typeset -gA __TODO_CACHE
shellcheck() {
	if cat "$1" | grep -q '^#!.*zsh'; then
		echo "zsh -n \"$1\""
		output=$(zsh -n "$1")
		if [[ -n "$output" ]]; then
			echo -e "❌ \033[38;5;1mFound issues:\033[0m"
			echo "$output"
		else
			echo -e "✅ \033[38;5;2mNo issues found by shellcheck.\033[0m"
		fi
	else
		command shellcheck "$1" 2>&1
	fi

}

local add2pathCounter=0
local ignoredPaths=0
add2path() {
	# Initialize a counter variable
	add2pathCounter=$((add2pathCounter + 1))
	# Add a directory to the PATH if it's not already present
	if ((add2pathCounter % 100 == 0)); then
		echo -e "\033[38;5;3mWarning: add2path Counter reached the 100 times checkpoint.\033[0m"
	fi
	local dir="$1"
	if [[ ! -d "$dir" ]]; then
		echo -e "\033[38;5;1madd2path: Directory '$dir' does not exist. Skipping...\033[0m"
		return
	fi
	if [[ ":$PATH:" != *":$dir:"* ]]; then
		export PATH="$dir:$PATH"
	else
		ignoredPaths=$((ignoredPaths + 1))
		if ((add2pathCounter % 100 == 0)); then
			echo -e "\033[38;5;3mWarning: Reached the 100 times checkpoint.\033[0m"
		fi
	fi
}

tabula_rasa() {
	if [[ "$TABULA_RASA" != 1 ]]; then
		export TABULA_RASA=1
		echo "Tabula Rasa mode is enabled. No configurations will be loaded."
		echo "Do you want to continue and reload in Tabula Rasa mode? (y/N)"
		read -r response
		if [[ "$response" == [Yy] ]]; then
			exec zsh -l
		fi
	else
		export TABULA_RASA=0
		echo "Tabula Rasa mode is disabled. Configurations will be loaded."
	fi
}
god_mode() {
	echo "This will output all relevant debug information into your home directory at $HOME/+imgnx/"
	# Create the directory if it doesn't exist
	mkdir -p "$HOME/+imgnx"
	# Dumping all shell functions
	functions >"$HOME/+imgnx/functions.txt"
	# Dumping all aliases with formatting
	alias | awk -F'=' '{ print "alias " $1 "=" $2 }' >"$HOME/+imgnx/aliases.txt"
	# Dumping environment variables
	env >"$HOME/+imgnx/variables.txt"
	# Dumping command hash values
	hash >"$HOME/+imgnx/hashes.txt"
	# Dumping current shell settings
	set >"$HOME/+imgnx/shell_settings.txt"
	# Dumping shell type and version
	echo "Shell: $SHELL" >"$HOME/+imgnx/shell_info.txt"
	echo "Shell version: $(zsh --version)" >>"$HOME/+imgnx/shell_info.txt"
	# Dumping current working directory and system PATH
	echo "Current directory: $(pwd)" >"$HOME/+imgnx/current_directory.txt"
	echo "Current PATH: $PATH" >>"$HOME/+imgnx/current_directory.txt"
	# Dumping list of running processes
	ps aux >"$HOME/+imgnx/process_list.txt"
	# Dumping disk usage
	df -h >"$HOME/+imgnx/disk_usage.txt"
	# Dumping network connections (listening ports)
	netstat -tuln >"$HOME/+imgnx/network_connections.txt"
	# Dumping command history
	history >"$HOME/+imgnx/command_history.txt"
	echo "All debug information has been saved to $HOME/+imgnx/."
}
# F6596432_CA98_4A50_9972_E10B0EE99CE9() {
# 	local mtime
# 	if [[ "$OSTYPE" == darwin* ]]; then
# 		mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
# 	else
# 		mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
# 	fi
# 	local now=$(date +%s)
# 	if [ -n "$mtime" ] && [ "$mtime" -lt $((now - 10)) ]; then
# 		6D078F25_9FBE_4352_A453_71F7947A3B01
# 	fi
# 	local sysline=""
# 	[ -f "$SYSLINE_CACHE" ] && sysline=$(<"$SYSLINE_CACHE")
# 	print -P "$(colorize \n$sysline)"
# }
detect_usb_config() {
	# Too slow... maybe another time...
	for vol in /Volumes/*; do
		if [[ -d "$vol" && "$vol" =~ ^/Volumes/[0-9]+_([A-Z]+)$ && -d "$vol/**/.config" ]]; then

			echo "🔌 Config found in drive: $vol"
			return
		fi
	done
}

brew() {
	if [[ "$1" == "link" ]]; then
		shift
		command brew link --overwrite "$@" 2>&1 | sed -e 's/^/🔧 /'
		return "${pipestatus[1]:-$?}"
	fi
	command brew "$@" 2>&1 | sed -e 's/^/🔧 /'
	return "${pipestatus[1]:-$?}"
}

ucd() {
	# which pushd
	builtin cd "$@" || return
	__TODO_CACHE[$PWD]="" || return
	ls || return
}
alias icd='ucd'

colorize() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo "Usage: colorize [~|--foreground] [|--background] <text>"
		echo "Options:"
		echo "  ~, --foreground   Colorize text with foreground colors"
		echo "  |, --background   Colorize text with background colors"
		echo "  -h, --help         Show this help message"
	else
		gawk 'BEGIN {
			# Initialize colors
			for (i = 0; i < 256; i++) {
				if (i == 0 || i == 15 || i == 231 || i == 255) continue; # Skip black and white
				r = int((i / 36) % 6) * 51; # Red component
				g = int((i / 6) % 6) * 51;  # Green component
				b = int(i % 6) * 51;        # Blue component
				hex = sprintf("#%02X%02X%02X", r, g, b);
				fgcolors[i] = "%F{" hex "}";
				bgcolors[i] = "%K{" hex "}";
			}
			reset_fg = "%f";
			reset_bg = "%k";
		}
		{
			# Split input into segments by ~ and |
			n = split($0, segs, /[~|]/);
			out = "";
			fg_idx = 0;
			bg_idx = 0;
			for (i = 1; i <= n; i++) {
				if (match($0, "~")) {
					if (fg_idx < 256) {
						color = fgcolors[fg_idx++];
						out = out color segs[i] reset_fg;
					} else {
						out = out "~" segs[i];
					}
				} else if (match($0, "|")) {
					if (bg_idx < 256) {
						color = bgcolors[bg_idx++];
						out = out color segs[i] reset_bg;
					} else {
						out = out "|" segs[i];
					}
				} else {
					out = out segs[i];
				}
			}
			print out;
		}' <<<"$*" | while IFS= read -r line; do
			print -P -- "$line"
		done
	fi
}

console() {
	logger -t "imgnx" $@
}
¡d() {
	dirs -v | head -n 10
}
diff() {
	local arg1 arg2
	if command -v realpath >/dev/null 2>&1; then
		arg1=$(realpath "$1")
		arg2=$(realpath "$2")
	elif command -v readlink >/dev/null 2>&1; then
		arg1=$(readlink -f "$1")
		arg2=$(readlink -f "$2")
	else
		arg1="$1"
		arg2="$2"
	fi
	if [ -d "$arg1" ] && [ -d "$arg2" ]; then
		local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/diff"
		mkdir -p "$cache_dir"
		local base1=$(basename "$arg1")
		local base2=$(basename "$arg2")
		local cache_file="$cache_dir/${base1}_vs_${base2}.txt"
		command diff -qr "$arg1" "$arg2" | tee "$cache_file"
		echo -e "\033[33mgit status\033[0m: \033[31m❌ Missing from $arg2 (only in $arg1):\033[0m"
		grep --color=auto -n "^Only in $arg1" "$cache_file" | sed "s|Only in $arg1/||"
		echo
		echo -e "\033[33mgit status\033[0m: \033[32m✅ New in $arg2 (only in $arg2):\033[0m"
		grep --color=auto -n "^Only in $arg2" "$cache_file" | sed "s|Only in $arg2/||"
		echo
		echo -e "\033[33mgit status\033[0m: \033[33m📝 Modified (different content):\033[0m"
		grep --color=auto -n "^Files .* differ$" "$cache_file" | sed -e 's/^Files //' -e 's/ and \[.*\] differ$//'
		echo "Would you like to compare differentiating files? (y/n)"
		read -r answer
		if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
			# Compare each pair of files that differ
			while IFS= read -r line; do
				file1=$(echo "$line" | sed -n 's/^Files \(.*\) and \(.*\) differ$/\1/p')
				file2=$(echo "$line" | sed -n 's/^Files \(.*\) and \(.*\) differ$/\2/p')
				if [ -n "$file1" ] && [ -n "$file2" ]; then
					echo "Comparing: $file1 $file2"
					command code -d -n "$file1" "$file2"
				fi
			done < <(grep "^Files .* differ$" "$cache_file")
		else
			echo "Skipping file comparison."
		fi
		return 0
	elif [ -f "$arg1" ] && [ -f "$arg2" ]; then
		command code -d -n "$arg1" "$arg2"
	else
		echo "❌ Error: diff expects two files or two directories" >&2
		return 1
	fi
}
dna() {
	local dir=$(dirs -v | fzf --reverse | awk '{print $2}')
	echo "DEBUG: dir=$dir"
	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}
duhast() {
	df -ahicY -ahicY
}
elev8r() {
	afplay "$SAMPLES/Media/bkgd.mp3" &>/dev/null
}
hello() {
	echo "Hello"
}
hr() {
	local length=${1:-80} # Default length is 80 characters
	printf '%*s\n' "$length" '' | tr ' ' '─'
}
html2ansi() {
	script="$ZDOTDIR/functions/html2ansi.js"
	if [ ! -f "$script" ]; then
		echo "Error: html2ansi.js not found in $ZDOTDIR/functions/"
	else
		node "$script" "$@" | while IFS= read -r line; do
			local truncated=$(truncate_ansi_to_columns "$line")
			echo "$truncated"
		done
	fi
}
import() {
	prompt=("Did you mean to run \033[5;38;5;1mimport\033[0m in the current terminal? \033[38;5;5mimport\033[39m is currently set to run ImageMagick." 'You likely meant to add a shebang to the top of a JavaScript file and the terminal found an "import" statement instead.' "Here is the shebang for Node.js:\n\n\033[38;5;2m\#!/usr/bin/env node\033[39m\n\n" 'Is this what you meant to do? (y/N)')
	answer="$(safeguard "${prompt[@]}")"
}
# is-at-least () {
# 	emulate -L zsh
# 	local IFS=".-" min_cnt=0 ver_cnt=0 part min_ver version order
# 	min_ver=(${=1})
# 	version=(${=2:-$ZSH_VERSION} 0)
# 	while (( $min_cnt <= ${#min_ver} ))
# 	do
# 		while [ "$part" != <-> ]
# 		do
# 			(( ++ver_cnt > ${#version} )) && return 0
# 			if [ ${version[ver_cnt]} = *[0-9][^0-9]* ]
# 			then
# 				order=(${version[ver_cnt]} ${min_ver[ver_cnt]})
# 				if [ ${version[ver_cnt]} = <->* ]
# 				then
# 					[[ $order != ${${(On)order}} ]] && return 1
# 				else
# 					[[ $order != ${${(O)order}} ]] && return 1
# 				fi
# 				[[ $order[1] != $order[2] ]] && return 0
# 			fi
# 			part=${version[ver_cnt]##*[^0-9]}
# 		done
# 		while true
# 		do
# 			(( ++min_cnt > ${#min_ver} )) && return 0
# 			[ ${min_ver[min_cnt]} = <-> ] && break
# 		done
# 		(( part > min_ver[min_cnt] )) && return 0
# 		(( part < min_ver[min_cnt] )) && return 1
# 		part=''
# 	done
# }
isdark() {
	local COLOR="$1"
	local R=$((0x$(echo "$COLOR" | cut -c2-3)))
	local G=$((0x$(echo "$COLOR" | cut -c4-5)))
	local B=$((0x$(echo "$COLOR" | cut -c6-7)))
	local LUMINANCE=$((R * 299 + G * 587 + B * 114))
	if ((LUMINANCE < 128000)); then
		return 0
	else
		return 1
	fi
}

pid() {
	pgrep "$1" | pbcopy
	echo "\"$1\" PID(s) copied to clipboard."
}

truncate_ansi_to_columns() {
	local input="$1"
	local clean visible raw_line result i chr
	clean=$(echo "$input" | sed 's/\x1B\[[0-9;]*[mK]//g')
	local max=${COLUMNS:-80}
	local count=0
	result=""
	i=1
	while [ $i -le ${#input} ] && [ $count -lt "$max" ]; do
		chr="${input[i]}"
		if [ "$chr" = $'\033' ]; then
			while [ "${input[i]}" != "m" ] && [ $i -le ${#input} ]; do
				result+="${input[i]}"
				((i++))
			done
			result+="${input[i]}"
		else
			result+="$chr"
			((count++))
		fi
		((i++))
	done
	echo "$result"
}
uuid() {
	uuidgen | tr '[:lower:]-' '[:upper:]_' | sed 's/^/MAIN_/'
}
visual_length() {
	emulate -L zsh
	local expanded=$(print -P -- "$1")
	local clean=$(print -r -- "$expanded" | sed $'s/\x1B\\[[0-9;]*[mGKH]//g')
	print ${#clean}
}
# Removed 'wk' function to avoid conflict with alias 'wk' in aliases.zsh
xdg-lint() {
	echo "🔍 Scanning $HOME for non-XDG config files..."
	for file in $HOME/.*; do
		[ -e "$file" ] || continue
		local name=${file##*/}
		echo "⚠️  $name may be violating XDG spec. Consider moving it to:"
		echo "    $XDG_CONFIG_HOME/$name or $XDG_DATA_HOME/$name"
	done
}

# Custom ls function with git status coloring
statusls() {
	# Check if we're in a git repository

	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# Set up XDG cache directory
		local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/ls-git-colors"
		mkdir -p "$cache_dir"

		# Create unique cache file based on current directory and ls arguments
		local cache_key=$(echo "$PWD $*" | sha256sum | cut -d' ' -f1)
		local ls_cache_file="$cache_dir/ls_output_${cache_key}"
		local git_cache_file="$cache_dir/git_info_${cache_key}"

		# Get git information efficiently
		local git_status_output=$(git status --porcelain 2>/dev/null)
		local git_tracked_output=$(git ls-files 2>/dev/null)

		# Cache the original ls output
		/bin/ls "$@" 2>/dev/null >"$ls_cache_file"

		# Read the cached output
		local ls_output=$(<"$ls_cache_file")
		local colored_output="$ls_output"

		# Process each actual file in the directory
		for file in *; do
			[[ ! -e "$file" ]] && continue

			local color=""
			local reset=$'\033[0m'

			if echo "$git_tracked_output" | grep -q "^${file}$"; then
				# File is tracked - check for modifications
				if echo "$git_status_output" | grep -q "^.M ${file}$\|^M. ${file}$"; then
					color=$'\033[33m' # Modified - yellow
				elif echo "$git_status_output" | grep -q "^A. ${file}$"; then
					color=$'\033[32m' # Added - green
				elif echo "$git_status_output" | grep -q "^.D ${file}$\|^D. ${file}$"; then
					color=$'\033[31m' # Deleted - red
				else
					color=$'\033[32m' # Tracked and clean - green
				fi
			elif echo "$git_status_output" | grep -q "^?? ${file}$"; then
				color=$'\033[31m' # Untracked - red
			fi

			# Apply color if we have one - use awk for precise matching
			if [[ -n "$color" ]]; then
				colored_output=$(echo "$colored_output" | awk -v file="$file" -v color="$color" -v reset="$reset" '
					{
						# Split line into fields and reconstruct with colors
						line = $0
						gsub("\\<" file "\\>", color file reset, line)
						print line
					}
				')
			fi
		done

		# Clean up cache files
		rm -f "$ls_cache_file" "$git_cache_file"

		echo "$colored_output"
	else
		# Not in a git repository, use normal ls
		/bin/ls "$@"
	fi
}

when() {
	find "${1:-.}" -maxdepth 1 -exec stat -f "%B %N" {} + |
		sort -nr |
		head -n 10 |
		while read ts file; do
			echo "$(date -r "$ts" '+%Y-%m-%d %H:%M:%S')  $file"
		done
}

where() {
	# From chpwd_breadcrumbs
	find . "$@" -type f -iname ".breadcrumb*" | xargs stat -f "%m %N" | sort -hr | bat &
	alert && fg

}

spinner() {
	local pid=$1
	local delay=0.1
	local spinstr='|/-\'
	while kill -0 "$pid" 2>/dev/null; do
		local temp=${spinstr#?}
		printf " [%c]  " "$spinstr"
		spinstr=$temp${spinstr%"$temp"}
		sleep "$delay"
		printf "\b\b\b\b\b\b"
	done
	printf "    \b\b\b\b"
}

__wrap_notice eza
eza() {
	command eza --icons=always "$@"
}

autoLogy() {
	if [[ -s ./error.log ]]; then
		echo -e "error.log[0-10] - Donald(@imgnx) autoLogy(fn.sh): \033[31m"
		cat ./error.log | head -n 10
		echo -e "\033[0mEnd of ./error.log[0-10] - see ./error.log for more info - Donald(@imgnx) autoLogy(fn.sh)"
	fi
	if [[ -s ./warning.log ]]; then
		echo -e "warning.log[0-10] - Donald(@imgnx) autoLogy(fn.sh): \033[33m"
		cat ./warning.log | head -n 10
		echo -e "\033[0mEnd of warning.log[0-10] - see ./warning.log for more info - Donald(@imgnx) autoLogy(fn.sh)"
	fi
	if [[ -s ./info.log ]]; then
		echo -e "info.log[0-10] - Donald(@imgnx) autoLogy(fn.sh): \033[32m"
		cat ./info.log | head -n 10
		echo -e "\033[0mEnd of info.log[0-10] - see ./info.log for more info - Donald(@imgnx) See autoLogy(fn.sh)"
	fi
}

add-zsh-hook precmd autoLogy

_retro_indexes() {
	compadd 1 2 3 4 5 6 7 8 9 10
}
compdef _retro_indexes retro

# venv auto-activation helpers extracted to bin/zsh-venv-autoactivate
source "${ZDOTDIR:-.}/bin/zsh-venv-autoactivate"

debounceBanner() {

	local stampfile="/tmp/taku.banner.last_ts"
	local -i timestamp=0 last_ts=0

	timestamp="$(date +%s)"

	# If we have a previous stamp, read it
	if [[ -f "$stampfile" ]]; then
		local last_ts_raw
		read -r last_ts_raw <"$stampfile"
		# Strip any non-digits to avoid math parse errors.
		last_ts=${last_ts_raw//[^0-9]/}
	fi

	echo "Δ = $((timestamp - last_ts))"

	# Only show banner if more than5 600 seconds (10 min) has passed since the last time it was requested (debounce)
	if ((timestamp - last_ts > 600)); then
		banner.sh
	fi
	# Update last-seen timestamp
	printf '%s\n' "$timestamp" >"$stampfile"
}

throttleBanner() {

	local stampfile="/tmp/taku.banner.last_ts"
	local -i timestamp=0 last_ts=0

	timestamp="$(date +%s)"

	# If we have a previous stamp, read it
	if [[ -f "$stampfile" ]]; then
		local last_ts_raw
		read -r last_ts_raw <"$stampfile"
		# Strip any non-digits to avoid math parse errors.
		last_ts=${last_ts_raw//[^0-9]/}
	fi

	echo "Δ = $((timestamp - last_ts))"

	# Only show banner if more than5 600 seconds (10 min) has passed since the last time it displayed (throttle)
	if ((timestamp - last_ts > 600)); then
		banner.sh
		# Update last-seen timestamp
		printf '%s\n' "$timestamp" >"$stampfile"
	fi
}

LIVE_HOT=0

tipTop() {
	if [[ LIVE_HOT == 0 ]]; then
		export LIVE_HOT=1
		banner.sh
		return
	else
		# Switch between debouncing/throttling by commenting/uncommenting line(s).
		# debounceBanner
		throttleBanner
	fi
	# To remove the hook:
	# add-zsh-hook -d precmd tipTop
}

add-zsh-hook precmd tipTop

ifTaku() {
	if [[ -f ./.taku || -d ./.taku ]]; then
		if [[ -f ./.taku ]]; then
			lolcat -i -p 0.5 -S 90 <<<"Found .taku env file"
		else
			lolcat -i -p 0.5 -S 90 <<<"Found .taku config"
		fi
	fi
}

add-zsh-hook precmd ifTaku

unquarantine() {
	for path in "$@"; do
		if [[ -f "$path" ]]; then
			xattr -c "$path"
		elif [[ -d "$path" ]]; then
			xattr -cr "$path"
		fi
	done
}

typeset -gi ZSH_SCROLL_MARGIN_PCT=40

# _scroll_margin_cursor_row() {
#   local reply row col
#   print -n $'\e[6n' > /dev/tty
#   read -t 0.05 -s -d R reply < /dev/tty || return 1
#   row=${reply#*\[}
#   row=${row%;*}
#   [[ "$row" == <-> ]] || return 1
#   print -r -- "$row"
# }

# scroll_margin_apply() {
#   [[ -o interactive ]] || return
#   [[ -t 1 ]] || return

#   local rows=$LINES
#   (( rows > 4 )) || return

#   local margin=$(( rows * (100 - ZSH_SCROLL_MARGIN_PCT) / 200 ))
#   local top=$(( margin + 1 ))
#   local bottom=$(( rows - margin ))

#   local cursor_row
#   cursor_row=$(_scroll_margin_cursor_row) || return

#   (( cursor_row < top )) && print -n $'\e['$(( top - cursor_row ))'B'
#   (( cursor_row > bottom )) && print -n $'\e['$(( cursor_row - bottom ))'A'
# }

# add-zsh-hook precmd scroll_margin_apply

# TRAPWINCH() {
#   scroll_margin_apply
#   zle && zle -R
# }

# cleanupPath() {
#    export PATH="$(bash \"$ZDOTDIR/cleanup.path.sh\")"
# }

# add-zsh-hook precmd cleanupPath

# export PATH="$(bash \"$ZDOTDIR/cleanup.path.sh\")"

autoThemeFile() {
	(($ + functions[load_themefile])) || return 0
	load_themefile
}

add-zsh-hook chpwd autoThemeFile
autoThemeFile

keychainenv() {
	local var="$1"
	local service="$2"

	export "$var"="$(
		security find-generic-password -a "$USER" -s "$service" -w 2>/dev/null
	)"
}
bare() {
	cd "$BARE"
	when | head -n 10
}

# Function to save current directory to a hidden file
save_last_dir() {
	pwd >~/tmp/.last_pwd
}

# Add the function to the chpwd hook array
# This executes every time you use 'cd', 'pushd', or 'popd'
add-zsh-hook chpwd save_last_dir

# On shell startup, restore the directory if the file exists
if [[ -f ~/tmp/.last_pwd ]]; then
	cd "$(cat ~/tmp/.last_pwd)"
fi

docalert() {
	bat &
	alert && fg
}
