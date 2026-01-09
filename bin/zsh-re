__wrap_notice rg
re() {
	# prog="search"

	help() {

		cat <<'EOF'
search: a path-first wrapper for ripgrep (rg)

USAGE:
  search <path> <pattern> [-- rg flags...]
  search <pattern> [path] [-- rg flags...]

EXAMPLES:
  search . taku
  search src "TODO|FIXME" -n
  search . "export default" -tjs
  search "taku" . --hidden --no-ignore
  search --files .
  search --help

RULES:
  - If the first arg is a directory/file that exists, it's treated as <path>.
  - Otherwise, the first arg is treated as <pattern>.
  - If you include a literal '--', everything after it is passed straight to rg.
  - With no args, defaults to: search . <you forgot the pattern>

COMMON SHORTCUTS:
  -tjs / -tts / -trs / -tpy etc. are passed to rg as-is.
  Use rg --help for the full flag list.

EOF
	}

	if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
		help
		exit 0
	fi

	if [[ "${1:-}" == "" ]]; then
		help
		exit 2
	fi

	args=("$@")
	pass=()
	pre=()
	post=()
	seen_dd=0

	for a in "${args[@]}"; do
		if [[ "$seen_dd" == "0" && "$a" == "--" ]]; then
			seen_dd=1
			continue
		fi
		if [[ "$seen_dd" == "0" ]]; then
			pre+=("$a")
		else
			post+=("$a")
		fi
	done

	first="${pre[0]:-}"
	second="${pre[1]:-}"

	path=""
	pattern=""
	rest=()

	if [[ -n "$first" && (-d "$first" || -f "$first") ]]; then
		path="$first"
		pattern="${second:-}"
		if [[ "${#pre[@]}" -gt 2 ]]; then
			rest=("${pre[@]:2}")
		else
			rest=()
		fi
	else
		pattern="$first"
		if [[ -n "$second" && (-d "$second" || -f "$second") ]]; then
			path="$second"
			if [[ "${#pre[@]}" -gt 2 ]]; then
				rest=("${pre[@]:2}")
			else
				rest=()
			fi
		else
			path="."
			if [[ "${#pre[@]}" -gt 1 ]]; then
				rest=("${pre[@]:1}")
			else
				rest=()
			fi
		fi
	fi

	if [[ -z "${pattern:-}" ]]; then
		printf '%s\n' "error: missing <pattern>" >&2
		printf '%s\n' "try:  search . <pattern>  OR  search <pattern> ." >&2
		exit 2
	fi

	if command -v rg >/dev/null 2>&1; then
		exec rg "${rest[@]}" "${post[@]}" -- "${pattern}" "${path}"
	else
		printf '%s\n' "error: rg not found in PATH" >&2
		exit 127
	fi
}

# grep() {
# echo -e -n "\033[0mYou are using a wrapper on \033[38;2;91;0;255mRust:Ripgrep (\`rg\`)\033[0m. For the actual grep package, use \033[38;2;255;255;91m/usr/bin/grep\033[0m. $@";
#    rg -Hin -e="/$1/ig" "${2:}"
# }

#grep() {
#    if ! command -v rg >/dev/null 2>&1; then
#	print -u2 -- "rg wrapper: ripgrep (rg) not found; falling back to system grep."
#	command grep "$@"
#	return $?
#    fi
##
###

#    local stderr_log statu#s
#    stderr_log=$(mktemp -t rg-grep.XXXXXX) || return 1#

#    if ! command rg -p "$@" 2> "$stderr_log"; then###
#	status=$?
#	if [[ -s "$stderr_log" ]]; then
#	    print -u2 -- "rg wrapper: command failed (exit $status):"
#	    cat "$stderr_log" >&2
#	else
#	    print -u2 -- "rg wrapper: command failed (exit $status) running: rg -p $*"

#	fi
#	rm -f "$stderr_#"
#	return $status
#    fi
#
#     rm -f "$stderr_log"
# }

