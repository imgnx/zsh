activate_venv_update_ps1() {
	if [[ $PY_DEBUG == 1 ]]; then
		echo -e "\`venv_autoactivate\`: Attempting to activate [venv]:
\$REALPATH: $1
\$ACTFILE: $2
"
		echo "\`venv_autoactivate\`: PS1 has venv: $PS1_HAS_VENV"
	fi

	REALPATH="$1"
	ACTFILE="$2"
	VERSION="$(python -V | awk '{print $2}')"
	local DIR="$(basename $(dirname $REALPATH))"
	local BASE="$(basename $REALPATH)"
	if [[ $PS1_HAS_VENV == 1 ]]; then
		echo "Cannot activate [${DIR}/${BASE}]. .venv is $PS1_HAS_VENV for $ACTIVE_VENV"
		return 1
	fi
	source "$ACTFILE"
	export PS1L1="$(print -P $PS1 | head -n 1)"
	export PS1L2="$(print -P $PS1 | tail -n +2)"
	export ACTIVE_VENV=" Python .venv: [${DIR}/${BASE}] (v${VERSION})"
	export PS1="$PS1L1 $ACTIVE_VENV
$PS1L2"
	export PS1_HAS_VENV=1
}

venv_autoactivate() {
	add-zsh-hook -d precmd venv_autoactivate
	if [[ $PY_DEBUG == 1 ]]; then
		echo "exec: venv_autoactivate in $ZDOTDIR/fn.sh"
	fi
	VENVAUTO_FILE="$ZDOTDIR/.zsh_venv_auto"
	PS1_HAS_VENV="${PS1_HAS_VENV:-0}"
	export VIRTUAL_ENV_DISABLE_PROMPT=1
	local errno=1 # pessimistic default
	local net=1   # safety net: allows retry once
	local ACTFILE dir decision reply

	TRAPEXIT() {
		unset VIRVUAL_ENV
		unset PS1_HAS_VENV
		# If we failed AND net is still armed, retry exactly once
		if ((errno != 0 && net == 1)); then
			net=0
			echo -e "\033[1m\033[38;2;255;125;0mWait!\033[0m"
			venv_autoactivate
		fi
	}

	# Bail immediately in $HOME
	if [[ "$(realpath "$PWD")" == "$(realpath "$HOME")" ]]; then
		errno=0
		return
	fi

	# Already in a venv → nothing to do
	if [[ -n "$VIRTUAL_ENV" ]]; then
		export VIRTUAL_ENV=""
		deactivate >/dev/null 2 &>1 # Simple. They get it wrong, we destroy it.
	fi

	if [[ "$PY_DEBUG" == 1 ]]; then
		echo "Searching for activation file..."
	fi

	# Locate activation script
	# `-mindepth 3 maxdepth 3` should lock it down to the exact place where .venv is located.
	ACTFILE=$(find . -maxdepth 3 -mindepth 3 -type f -name activate 2>/dev/null | head -n 1)

	if [[ "$PY_DEBUG" == 1 ]]; then
		echo "Results: $ACTFILE"
	fi

	if [[ -z "$ACTFILE" ]]; then
		errno=0
		return
	fi

	dir=$(realpath "$(dirname "$ACTFILE")")
	REALPATH="$(realpath ./)"

	# Check remembered decisions
	record=$(grep "^$dir " "$VENVAUTO_FILE" 2>/dev/null)
	decision=$(echo $record | awk '{print $2}')

	case "$decision" in
	always)
		echo "Python .venv activated\!" | lolcat -paf
		activate_venv_update_ps1 $REALPATH $ACTFILE
		errno=0
		return
		;;
	never)
		echo "\033[41m autovenv disabled: \033[0m ${record}"
		errno=0
		return
		;;
	esac

	# Prompt user
	echo -en "\033[5m\033[48;2;0;123;255mActivate .venv in $dir?\033[0m \033[1m
	1. (y)es
	2. (n)o
	3. (a)lways
	4. (N)ever\033[0m

Decision:"
	read -k 1 -r reply
	echo

	case "$reply" in
	[yY1])
		echo -e "$ACTFILE set to \033[48;2;0;255;0mactivate once\033[0m"
		activate_venv_update_ps1 $REALPATH $ACTFILE
		;;
	[aA3])
		echo -e "$ACTFILE set to \033[48;2;0;255;0malways\033[0m"
		activate_venv_update_ps1 $REALPATH $ACTFILE
		echo "$dir always" | tee "$VENVAUTO_FILE"
		;;
	[N4])
		echo -e "$ACTFILE set to \033[48;2;255;20;0mnever\033[0m"
		echo "$dir never" | tee "$VENVAUTO_FILE"
		;;
	*) ;; # explicit no-op
	esac

	errno=0
}

venvreset() {
	if [[ "$1" == "edit" ]]; then
		${EDITOR:-emacs} "$VENVAUTO_FILE"
	else
		rm$() -f "$VENVAUTO_FILE"
		echo "Cleared all venv auto-activation decisions."
	fi
}

add-zsh-hook precmd venv_autoactivate
add-zsh-hook chpwd venv_autoactivate
