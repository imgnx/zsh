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
	export IMGNX_STATS="
ZshQ:\t${zshcount}\tCPU:\t${cpu}\tRAM:\t${mem}MB"
}

# Better Prompt
better_prompt() {
	local color branch gitinfo stats stat_parts stat
	color="$(ggs)"
	stats="${IMGNX_STATS:-}"
	
	branch=""
	gitinfo=""

	# Git info
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		branch=${$(git rev-parse --abbrev-ref HEAD 2>/dev/null):-no git}
		[[ -n "$branch" && "$branch" != "no git" ]] && branch="/$branch"
		local remote="$(git remote 2>/dev/null)"
		local remote_part=""
		[[ -n "$remote" ]] && remote_part=" $remote"
		gitinfo="%F{$color}${remote_part}%F{#8aa6c0}$branch%f"
	fi

	# Compose PS1
	PS1=""
	card=0
	if [[ -n "$stats" ]]; then
		card=$((card+1))
		# Split stats by tabs, colorize each part
		stat_parts=("${(@s:\t:)stats}")
		for stat in $stat_parts; do
			case card in
				1) PS1+="%F{#FF007B}${stat}%f" ;; # CPU
				2) PS1+="%F{#007BFF}${stat}%f" ;; # RAM
				3) PS1+="%F{#7BFF00}${stat}%f" ;; # Zsh count
				*) PS1+="%F{#fca864}${stat}%f" ;; # Default color
			esac
		done
	fi
	PS1+='%F{green}%n@'"${LOCAL_IP}"' %~%f
'
	[[ -n "$gitinfo" ]] && PS1+=" $gitinfo"
	PS1+='
%B%F{#FF007B}'"$(basename $SHELL)"' %f%F{#FFFFFF}%m %F{#7BFF00}=>%b
'

	RPS1='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f
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
		if [[ "$DEBUG_MODE" == "true" ]]; then
			echo "[DEBUG] $new_path is already whitelisted" >&2
			# TEMP LOGGING: Log current whitelist and blacklist
			if [[ -f "$WHITELISTED_CONFIG_BIN_PATH_FILE" ]]; then
				echo "[LOG] Whitelisted paths:" >&2
				cat "$WHITELISTED_CONFIG_BIN_PATH_FILE" >&2
			fi
			if [[ -f "$BLACKLISTED_CONFIG_BIN_PATH_FILE" ]]; then
				echo "[LOG] Blacklisted paths:" >&2
				cat "$BLACKLISTED_CONFIG_BIN_PATH_FILE" >&2
			fi
		fi
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
	export ZLOADING="delayed-script-loader.zsh"
	# echo -e "✅ INTERACTIVE │ l: [\033[38;5;207;3;4m${ZLOADING:-.zshenv}\033[0m] │ pfc: ${SKIP_PREFLIGHT_LOAD_CHECK:-0}"

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
