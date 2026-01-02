# --- can: playful capability checks (files/dirs + commands/packages via Homebrew) ---
can() {
	# TODO: Fuzzy Search for unknown commands
	emulate -L zsh
	setopt PIPE_FAIL

	local quiet=0 json=0 subcmd="" target=""

	# flags
	while [[ "$1" == -* ]]; do
		case "$1" in
		-q | --quiet) quiet=1 ;;
		-j | --json) json=1 ;;
		-h | --help)
			cat <<'USAGE'
Usage:
  can <path>                  # list capabilities of a file/dir (playful)
  can haz|run|read|write <path>
  can enter <dir>
  can use <command>           # PATH + version; check Homebrew if missing
  can pkg <name>              # Homebrew availability/installed (formula/cask)

Options:
  -q, --quiet   exit status only (no output)
  -j, --json    JSON output
Notes:
  • If <thing> is not a path, "can <thing>" falls back to "can use <thing>".
  • Exit 0 means "yes/can", exit 1 means "no/can't".
USAGE
			return 0
			;;
		*) break ;;
		esac
		shift
	done

	# optional subcommand
	case "$1" in
	haz | run | read | write | enter | use | pkg)
		subcmd=$1
		shift
		;;
	esac

	# target required
	if [[ -z "$1" ]]; then
		print -r -- "Usage: can [haz|run|read|write|enter|use|pkg] <path|name>  (try: can -h)"
		return 1
	fi
	target=$1

	# helpers
	_bool() { [[ $1 -eq 0 ]] && echo true || echo false; }
	_say() { ((quiet)) || print -r -- "$@"; }

	# --- file/dir mode --------------------------------------------------------
	_file_list() {
		local p=$1
		local exists=1 readable=1 writable=1 runnable=1 is_dir=1 enterable=1 size="null" type="unknown"

		[[ -e $p ]] && exists=0
		[[ -r $p ]] && readable=0
		[[ -w $p ]] && writable=0
		[[ -x $p && -f $p ]] && runnable=0
		if [[ -d $p ]]; then
			is_dir=0
			[[ -x $p ]] && enterable=0
			type="dir"
		elif [[ -f $p ]]; then
			type="file"
			local s
			s=$(stat -f %z "$p" 2>/dev/null || stat -c %s "$p" 2>/dev/null)
			[[ -n $s ]] && size=$s
		elif [[ -L $p ]]; then
			type="symlink"
		fi

		if ((json)); then
			_say "{\"path\":\"$p\",\"type\":\"$type\",\"exists\":$(_bool $exists),\"readable\":$(_bool $readable),\"writable\":$(_bool $writable),\"runnable\":$(_bool $runnable),\"directory\":$(_bool $is_dir),\"enterable\":$(_bool $enterable),\"size\":$size}"
			return 0
		fi

		if [[ $exists -ne 0 ]]; then
			_say "❌ can't haz: \"$p\" does not exist"
			return 1
		fi
		_say "✅ can haz: \"$p\" exists"
		((readable == 0)) && _say "📖 can read" || _say "🚫 can't read"
		((writable == 0)) && _say "✏️  can write" || _say "🔒 can't write"
		[[ -f $p ]] && { ((runnable == 0)) && _say "🎬 can run" || _say "🙅 can't run"; }
		[[ -d $p ]] && { ((enterable == 0)) && _say "🚪 can enter" || _say "🚷 can't enter"; }
	}

	_file_pred() {
		local mode=$1 p=$2 ok=1
		case "$mode" in
		haz)
			[[ -e $p ]]
			ok=$?
			;;
		run)
			[[ -x $p && -f $p ]]
			ok=$?
			;;
		read)
			[[ -r $p ]]
			ok=$?
			;;
		write)
			[[ -w $p ]]
			ok=$?
			;;
		enter)
			[[ -d $p && -x $p ]]
			ok=$?
			;;
		esac
		if ((json)); then
			_say "{\"path\":\"$p\",\"$mode\":$(_bool $ok)}"
		elif ((!quiet)); then
			_say $([[ $ok -eq 0 ]] && echo "true" || echo "false")
		fi
		return $ok
	}

	# --- command/package mode (Homebrew) --------------------------------------
	local have_brew=1
	if command -v brew >/dev/null 2>&1; then have_brew=0; fi

	_brew_has() {
		[[ $have_brew -ne 0 ]] && return 1
		brew info --json=v2 --quiet --formula "$1" >/dev/null 2>&1 && {
			echo formula
			return 0
		}
		brew info --json=v2 --quiet --cask "$1" >/dev/null 2>&1 && {
			echo cask
			return 0
		}
		return 1
	}
	_brew_installed() {
		[[ $have_brew -ne 0 ]] && return 1
		brew list --formula --versions "$1" >/dev/null 2>&1 && return 0
		brew list --cask --versions "$1" >/dev/null 2>&1 && return 0
		return 1
	}

	_cmd_use() {

		local name=$1
		local in_path=1
		command -v -- "$name" >/dev/null 2>&1 && in_path=0
		local version=""
		if [[ $in_path -eq 0 ]]; then
			version=$("$name" --version 2>/dev/null | head -n1)
			[[ -z "$version" ]] && version=$("$name" -V 2>/dev/null | head -n1)
			[[ -z "$version" ]] && version=$("$name" -v 2>/dev/null | head -n1)
		fi

		local kind="" brew_avail=1 brew_inst=1
		kind=$(_brew_has "$name")
		[[ $? -eq 0 ]] && brew_avail=0
		_brew_installed "$name" && brew_inst=0

		if ((json)); then
			local ver_json=$([[ -n $version ]] && printf '%s' "$version" | sed 's/"/\\"/g;s/^/"/;s/$/"/' || echo "null")
			_say "{\"name\":\"$name\",\"in_path\":$(_bool $in_path),\"version\":$ver_json,\"brew_available\":$(_bool $brew_avail),\"brew_kind\":\"${kind:-null}\",\"brew_installed\":$(_bool $brew_inst)}"
		else
			if [[ $in_path -eq 0 ]]; then
				_say "🧰 can use: \"$name\" is on PATH"
				[[ -n "$version" ]] && _say "   ↳ $version"
				((have_brew == 0)) && ((brew_inst == 0)) && _say "🍺 Homebrew: installed"
			else
				_say "❌ can't use: \"$name\" not found on PATH"
				if ((have_brew == 0)); then
					if ((brew_inst == 0)); then
						_say "🍺 Homebrew: installed (but not on PATH?)"
						_say "   • try: echo 'eval \"$(brew shellenv)\"' >> ~/.zprofile && source ~/.zprofile"
					elif ((brew_avail == 0)); then
						if [[ "$kind" == "cask" ]]; then
							_say "🍺 Homebrew: available as a cask"
							_say "   • install: brew install --cask $name"
						else
							_say "🍺 Homebrew: available"
							_say "   • install: brew install $name"
						fi
					else
						_say "🍺 Homebrew: not found"
					fi
				else
					_say "🍺 Homebrew not installed (skip check)"
				fi
			fi
		fi
		return $in_path
	}

	_pkg() {
		local name=$1 kind="" brew_avail=1 brew_inst=1
		kind=$(_brew_has "$name")
		[[ $? -eq 0 ]] && brew_avail=0
		_brew_installed "$name" && brew_inst=0
		if ((json)); then
			_say "{\"name\":\"$name\",\"brew_available\":$(_bool $brew_avail),\"brew_kind\":\"${kind:-null}\",\"brew_installed\":$(_bool $brew_inst)}"
		else
			if ((have_brew != 0)); then
				_say "🍺 Homebrew not installed"
				return 1
			fi
			if ((brew_inst == 0)); then
				_say "🍺 installed: $name"
			elif ((brew_avail == 0)); then
				if [[ "$kind" == "cask" ]]; then
					_say "🍺 available (cask): $name"
					_say "   • install: brew install --cask $name"
				else
					_say "🍺 available: $name"
					_say "   • install: brew install $name"
				fi
			else
				_say "🍺 not found: $name"
			fi
		fi
		((brew_avail == 0)) && return 0 || return 1
	}

	# dispatch
	if [[ -n "$subcmd" ]]; then
		case "$subcmd" in
		use)
			_cmd_use "$target"
			return $?
			;;
		pkg)
			_pkg "$target"
			return $?
			;;
		haz | run | read | write | enter)
			if [[ -e "$target" || "$target" == */* ]]; then
				_file_pred "$subcmd" "$target"
				return $?
			else
				_cmd_use "$target"
				return $?
			fi
			;;
		esac
	fi

	# no subcmd: auto file vs command
	if [[ -e "$target" || "$target" == */* ]]; then
		_file_list "$target"
	else
		_cmd_use "$target"
	fi
}
