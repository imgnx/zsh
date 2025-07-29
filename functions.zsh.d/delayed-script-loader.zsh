#!/bin/zsh

# Delayed script loader hook and periodic bin folder scanner

# --- Periodic stats updater for prompt ---
_imgnx_stats_last=0
PERIOD_STATS=10 # seconds
imgnx_update_stats() {
	local now=$(date +%s)
	((now - _imgnx_stats_last < PERIOD_STATS)) && return
	_imgnx_stats_last=$now
	# Get CPU usage (top 1 line), MEM usage (in MB), and Zsh process count
	local cpu mem zshcount
	cpu=$(ps -A -o %cpu | awk 'NR>1 {s+=$1} END {printf "%.1f", s}')
	mem=$(ps -A -o rss | awk 'NR>1 {s+=$1} END {printf "%.1f", s/1024}')
	zshcount=$(pgrep -c zsh 2>/dev/null || ps -eo comm | grep -c "^zsh")
	export IMGNX_STATS="nzQt:  $zshcount        CPU: $cpu      RAM: $mem MB"
}

# Better Prompt
better_prompt() {
	COLOR="$(ggs)"
	REMOTE=""
	URL=""
	# PS1="%K{#000000}%F{#FFFFFF}%n@%B%F{#00FFFF}$LOCAL_IP%b%f%k%s"
	PS1='%F{green}%n@$LOCAL_IP %~%f
'$(basename $SHELL)'%# '
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		# List each remote name and its URL, one per line
		for remote in $(git remote); do
			URL=$(git remote get-url "$REMOTE" 2>/dev/null)
			PS1+='%F{'$COLOR'} '$(git remote 2>/dev/null)'%F{#8aa6c0}/'$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '%F{#202020}no git%f')'%f'
		done
	else
		echo "no git"
	fi
	PS1+='
'$(if [[ "$PWD" == "/" ]]; then echo "/"; elif [[ "$PWD" == "$HOME" ]]; then echo "~"; else dirname "${PWD/#$HOME/~}" | sed 's|\(.*\)\(.\{20\}\)$|…\2|' || echo ''; fi)'%f%B%F{#FFFF00}'/$(basename "$PWD")'%f%b
%B%F{#FF007B}'$(basename $SHELL)' %f%F{#FFFFFF}%m =>%b %F{#7BFF00}'

	# Set PS1 with performance stats, user, local IP, and git info
	local stats="${IMGNX_STATS:-}"
	local color branch gitinfo
	color="$(ggs)"
	gitinfo=""
	branch=""
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'no git')
		gitinfo="%F{$color} $(git remote 2>/dev/null)%F{#8aa6c0}/$branch%f"
	fi
	PS1=""
	[[ -n "$stats" ]] && PS1+="%F{yellow}$stats%f\n"
	PS1+='%F{green}%n@$LOCAL_IP %~%f'
	[[ -n "$gitinfo" ]] && PS1+=" $gitinfo"
	PS1+='\n%B%F{#FF007B}'$(basename $SHELL)' %f%F{#FFFFFF}%m =>%b %F{#7BFF00}'
	RPS1='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f\n'

	#     COLOR="$(ggs)"
	#     if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	#         echo "no git"
	#     else
	#         git remote -v | awk '{print $1, $2}' | sort | uniq
	#     fi
	#     PS1='%F{'$COLOR'}%B '$(git remote 2>/dev/null)'%F{#8aa6c0}/'$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '%F{#202020}no git%f')'%f%b %n %B%F{#FF007B}'$LOCAL_IP'%b%f
	# %F{#007BFF} '$(dirname "$PWD" | sed 's|\(.*\)\(.\{20\}\)$|…\2|' || echo '')'%f%F{yellow}'/$(basename "$PWD")'%f
	# %B%F{#FF007B}'$(basename $SHELL)' %f%F{#FFFFFF}=>%b %F{#00FF00}';

	# Show "cnf [<config-dir> (<file>)]" before typing, then hide it once typing starts
	RPS1='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f''\n
	'
}
# --- Prepend stats to prompt ---

# Update PS1 before each prompt
precmd_better_prompt() {
	better_prompt
}

# --- Helper: Add a path to the whitelist and $PATH ---
whitelist() {
	local new_path="$1"
	[[ -z "$new_path" ]] && echo "Usage: whitelist /path/to/bin" && return 1
	grep -qxF "$new_path" "$WHITELISTED_CONFIG_BIN_PATH_FILE" 2>/dev/null && {
		echo "$new_path already in whitelist"
		return 0
	}
	echo "$new_path" >>"$WHITELISTED_CONFIG_BIN_PATH_FILE"
	# Was `export PATH="$new_path:$PATH"`
	add2path "$new_path"
	if [[ $? -ne 0 ]]; then
		echo "Failed to add $new_path to PATH"
	else
		echo "$new_path added to whitelist and PATH"
	fi
}

# --- Periodic scan for new bin folders ---
_zsh_bin_scan_last=0
zsh_bin_scan_period=300 # 5 minutes

scan_new_config_bins() {
	# Read new bin folders from the cron-generated file
	local output_file="$HOME/.config/zsh/last_bin_scan.txt"
	if [[ -f "$output_file" ]]; then
		while IFS= read -r dir; do
			[[ -z "$dir" ]] && continue
			grep -qxF "$dir" "$WHITELISTED_CONFIG_BIN_PATH_FILE" 2>/dev/null && continue
			grep -qxF "$dir" "$BLACKLISTED_CONFIG_BIN_PATH_FILE" 2>/dev/null && continue
			[[ ":$PATH:" == *":$dir:"* ]] && continue
			echo "New bin folder found: $dir"
			# Optionally: auto-whitelist or notify user
		done < "$output_file"
	fi
}

# --- Alias all executables in ~/.config/zsh/functions ---
alias_zsh_functions() {
	local func_dir="$HOME/.config/zsh/functions"
	if [[ -d "$func_dir" ]]; then
		for file in "$func_dir"/*(.x); do
			[[ -f $file && -x $file ]] || continue
			local alias_name="${file:t}"
			alias $alias_name="$file"
		done
	fi
}

# --- Delayed loader: source scripts in functions.zsh.d ---
# function D36B034A_2E4A_4D7D_A93C_4C5EB0A197A7() {
#     echo -e "[ delayed-script-loader ]"
#     printf '🔧 %s called. Sourcing scripts in %s/functions.zsh.d/\n' \
#         "${funcstack[1]}" "$ZDOTDIR"

#     for file in "$ZDOTDIR/functions.zsh.d/"*; do
#         [[ -f $file ]] || continue
#         local script_name=${file:t:r}
#         case "$file" in
#             *.zsh|*.sh)
#                 if source "$file"; then
#                     echo "✅ Sourced: $script_name"
#                 else
#                     echo "❌ Failed: $script_name"
#                 fi
#                 ;;
#             *)
#                 # If executable, create an alias for it
#                 if [[ -x $file ]]; then
#                     alias $script_name="$file"
#                     echo "🔗 Aliased: $script_name -> $file"
#                 fi
#                 ;;
#         esac
#     done

#     alias_zsh_functions
# }

# --- Register hooks (autoload only once) ---
# --- Interactive-Only ---
if [[ -o interactive ]]; then
	export ZLOADING=".zshenv"
	echo -e "✅ INTERACTIVE │ l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"

	autoload -Uz colors && colors
	autoload -Uz add-zsh-hook
	autoload -Uz compinit
	compinit

fi

# Hooks
export PERIOD=300
if ! [[ "${precmd_functions[*]}" == *_IMGNX_* ]]; then
	if typeset -f add-zsh-hook >/dev/null 2>&1; then
		export PERIOD_SCAN_BINS=300
		export PERIOD_ALIAS_FUNCS=600
		add-zsh-hook periodic scan_new_config_bins
		add-zsh-hook periodic imgnx_update_stats
		add-zsh-hook precmd precmd_better_prompt
	fi
fi

hooks() {
	echo "Current hooks:"
	echo "  precmd: ${precmd_functions[*]}"
	echo "  preexec: ${preexec_functions[*]}"
	echo "  periodic: ${periodic_functions[*]}"
}

# Load the "Better Prompt" script
better_prompt
