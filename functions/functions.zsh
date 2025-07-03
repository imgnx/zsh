#!/bin/sh
# shellcheck shell=bash
print -n -P "[%F{#202020}functions%f]"

# +imgnx-debug() {
#     echo "This will output all relevant debug information into your home directory at $HOME/+imgnx/"
#         # Create the directory if it doesn't exist
#     mkdir -p "$HOME/+imgnx"
#         # Dumping all shell functions
#     functions > "$HOME/+imgnx/functions.txt"
#         # Dumping all aliases with formatting
#     alias | awk -F'=' '{ print "alias " $1 "=" $2 }' > "$HOME/+imgnx/aliases.txt"
#         # Dumping environment variables
#     env > "$HOME/+imgnx/variables.txt"
#         # Dumping command hash values
#     hash > "$HOME/+imgnx/hashes.txt"
#         # Dumping current shell settings
#     set > "$HOME/+imgnx/shell_settings.txt"
#         # Dumping shell type and version
#     echo "Shell: $SHELL" > "$HOME/+imgnx/shell_info.txt"
#     echo "Shell version: $(zsh --version)" >> "$HOME/+imgnx/shell_info.txt"
#         # Dumping current working directory and system PATH
#     echo "Current directory: $(pwd)" > "$HOME/+imgnx/current_directory.txt"
#     echo "Current PATH: $PATH" >> "$HOME/+imgnx/current_directory.txt"
#         # Dumping list of running processes
#     ps aux > "$HOME/+imgnx/process_list.txt"
#         # Dumping disk usage
#     df -h > "$HOME/+imgnx/disk_usage.txt"
#         # Dumping network connections (listening ports)
#     netstat -tuln > "$HOME/+imgnx/network_connections.txt"
#         # Dumping command history
#     history > "$HOME/+imgnx/command_history.txt"
#         echo "All debug information has been saved to $HOME/+imgnx/."
# }
# F6596432_CA98_4A50_9972_E10B0EE99CE9 () {
# 	local mtime
# 	if [ "$OSTYPE" = darwin* ]
# 	then
# 		mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
# 	else
# 		mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
# 	fi
# 	local now=$(date +%s)
# 	if [ -n "$mtime" ] && [ "$mtime" -lt $((now - 10)) ]
# 	then
# 		6D078F25_9FBE_4352_A453_71F7947A3B01
# 	fi
# 	local sysline=""
# 	[ -f $SYSLINE_CACHE ] && sysline=$(<"$SYSLINE_CACHE")
# 	print -P "$(colorize \n$sysline)"
# }
# add-zsh-hook () {
# 	emulate -L zsh
# 	local -a hooktypes
# 	hooktypes=(chpwd precmd preexec periodic zshaddhistory zshexit zsh_directory_name)
# 	local usage="Usage: add-zsh-hook hook function\nValid hooks are:\n  $hooktypes"
# 	local opt
# 	local -a autoopts
# 	integer del list help
# 	while getopts "dDhLUzk" opt
# 	do
# 		case $opt in
# 			(d) del=1  ;;
# 			(D) del=2  ;;
# 			(h) help=1  ;;
# 			(L) list=1  ;;
# 			([Uzk]) autoopts+=(-$opt)  ;;
# 			(*) return 1 ;;
# 		esac
# 	done
# 	shift $(( OPTIND - 1 ))
# 	if (( list ))
# 	then
# 		if [ -n "$1" ]; then
# 			typeset -mp "${1}_functions"
# 		else
# 			for hook in $hooktypes; do
# 				typeset -mp "${hook}_functions"
# 			done
# 		fi
# 		return $?
# 	elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 ))
# 	then
# 		local fd=$(( 2 - help ))
# 		print -u$fd $usage
# 		return $(( 1 - help ))
# 	fi
# 	local hook="${1}_functions"
# 	local fn="$2"
# 	if (( del ))
# 	then
# 		if (( ${(P)+hook} ))
# 		then
# 			if (( del == 2 ))
# 			then
# 				set -A $hook ${(P)hook:#${~fn}}
# 			else
# 				set -A $hook ${(P)hook:#$fn}
# 			fi
# 			if (( ! ${(P)#hook} ))
# 			then
# 				unset $hook
# 			fi
# 		fi
# 	else
# 		if (( ${(P)+hook} ))
# 		then
# 			if (( ${${(P)hook}[(I)$fn]} == 0 ))
# 			then
# 				typeset -ga $hook
# 				set -A $hook ${(P)hook} $fn
# 			fi
# 		else
# 			typeset -ga $hook
# 			set -A $hook $fn
# 		fi
# 		autoload $autoopts -- $fn
# 	fi
# }

# autoload_usb_config () {
# 	for vol in /Volumes/*
# 	do
# 		if [ -d "$vol" ] && [ -d "$vol/.config" ]; then
# 			if [ "$vol" = /Volumes/<->_<->(#U)[A-Z]## ]; then
# 				echo "🔌 Loaded config from USB: $vol"
# 				return
# 			fi
# 		fi
# 	done
# }
# bkgd () {
# 	afplay "$BKGD"
# }
# brew () {
# 	if [ "$1" = "link" ]
# 	then
# 		shift
# 		command brew link --overwrite "$@" 2>&1 | sed -e 's/^/🔧 /'
# 		return $pipestatus[1]
# 	fi
# 	command brew "$@" 2>&1 | sed -e 's/^/🔧 /'
# 	return $pipestatus[1]
# }
# cd () {
# 	builtin cd "$@" || return
# 	__TODO_CACHE[$PWD]=""
# 	ls
# }
# clean-hooks () {
# 	echo "Current hooks:"
# 	echo "  precmd: ${precmd_functions[*]}"
# 	echo "  preexec: ${preexec_functions[*]}"
# 	echo "  periodic: ${periodic_functions[*]}"
# 	echo ""
# 	echo "To clear hooks, run:"
# 	echo "  precmd_functions=()"
# 	echo "  preexec_functions=()"
# 	echo "  periodic_functions=()"
# }
# codespace () {
# 	code -r $WORKSPACE/.vscode/Workbench.code-workspace
# }
# colorize () {
# 	local AWKDIR="$HOME/.config/zsh/functions"
# 	case "$1" in
# 		(-b | --background) shift
# 			echo "$*" | gawk -f "$AWKDIR/colorize.bkgd.awk" ;;
# 		(-f | --foreground) shift
# 			echo "$*" | gawk -f "$AWKDIR/colorize.fore.awk" ;;
# 		(-h | --help) echo "Usage: colorize [-b|--background] [-f|--foreground] <text>"
# 			echo "Options:"
# 			echo "  -b, --background   Colorize text with background colors"
# 			echo "  -f, --foreground   Colorize text with foreground colors"
# 			echo "  -h, --help         Show this help message" ;;
# 		(*) echo "$*" | gawk -f "$AWKDIR/colorize.awk" ;;
# 	esac
# }
# colors () {
# 	emulate -L zsh
# 	typeset -Ag color colour
# 	color=(00 none 01 bold 02 faint 22 normal 03 italic 23 no-italic 04 underline 24 no-underline 05 blink 25 no-blink 07 reverse 27 no-reverse 08 conceal 28 no-conceal 30 black 40 bg-black 31 red 41 bg-red 32 green 42 bg-green 33 yellow 43 bg-yellow 34 blue 44 bg-blue 35 magenta 45 bg-magenta 36 cyan 46 bg-cyan 37 white 47 bg-white 39 default 49 bg-default)
# 	local k
# 	for k in ${(k)color}
# 	do
# 		color[${color[$k]}]=$k
# 	done
# 	for k in ${color[(I)3?]}
# 	do
# 		color[fg-${color[$k]}]=$k
# 	done
# 	for k in grey gray
# 	do
# 		color[$k]=${color[black]}
# 		color[fg-$k]=${color[$k]}
# 		color[bg-$k]=${color[bg-black]}
# 	done
# 	colour=(${(kv)color})
# 	local lc=$'\e[' rc=m
# 	typeset -Hg reset_color bold_color
# 	reset_color="$lc${color[none]}$rc"
# 	bold_color="$lc${color[bold]}$rc"
# 	typeset -AHg fg fg_bold fg_no_bold
# 	for k in ${(k)color[(I)fg-*]}
# 	do
# 		fg[${k#fg-}]="$lc${color[$k]}$rc"
# 		fg_bold[${k#fg-}]="$lc${color[bold]};${color[$k]}$rc"
# 		fg_no_bold[${k#fg-}]="$lc${color[normal]};${color[$k]}$rc"
# 	done
# 	typeset -AHg bg bg_bold bg_no_bold
# 	for k in ${(k)color[(I)bg-*]}
# 	do
# 		bg[${k#bg-}]="$lc${color[$k]}$rc"
# 		bg_bold[${k#bg-}]="$lc${color[bold]};${color[$k]}$rc"
# 		bg_no_bold[${k#bg-}]="$lc${color[normal]};${color[$k]}$rc"
# 	done
# }
# config () {
# 	emacs $WORKBENCH/.vscode/Workbench.code-workspace
# }
# console () {
# 	logger -t "imgnx" $@
# }
# d () {
# 	dirs -v | head -n 10
# }
# diff () {
# 	local arg1
# 	arg1=$(realpath "$1")
# 	local arg2
# 	arg2=$(realpath "$2")
# 	if [ -d "$arg1" ] && [ -d "$arg2" ]
# 	then
# 		local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/diff"
# 		mkdir -p -p "$cache_dir"
# 		local base1=$(basename "$arg1")
# 		local base2=$(basename "$arg2")
# 		local cache_file="$cache_dir/${base1}_vs_${base2}.txt"
# 		command diff -qr "$arg1" "$arg2" | tee "$cache_file"
# 		echo "Deleted (only in $arg1):"
# 		grep --color=auto -n "^Only in $arg1" "$cache_file" | sed "s|Only in $arg1/||"
# 		echo
# 		echo "Added   (only in $arg2):"
# 		grep --color=auto -n "^Only in $arg2" "$cache_file" | sed "s|Only in $arg2/||"
# 		echo
# 		echo "Modified:"
# 		grep --color=auto -n "^Files .* differ$" "$cache_file" | sed -e 's/^Files //' -e 's/ and .* differ$//'
# 		echo "Would you like to compare differentiating files? (y/n)"
# 		read -r answer
# 		if [ "$answer" != "y" ] && [ "$answer" != "Y" ]
# 		then
# 			echo "Skipping file comparison."
# 		fi
# 		return 0
# 	elif [ -f "$arg1" ] && [ -f "$arg2" ]
# 	then
# 		command code -d -n "$arg1" "$arg2"
# 	else
# 		echo "❌ Error: diff expects two files or two directories" >&2
# 		return 1
# 	fi
# }
# dna () {
# 	local dir=$(dirs -v | fzf --reverse | awk '{print $2}')
# 	echo "DEBUG: dir=$dir"
# 	[ -n "$dir" ] && cd "${dir/#\~/$HOME}"
# }
# duhast () {
# 	df -ahicY -ahicY
# }
# elev8r () {
# 	afplay "$SAMPLES/Media/bkgd.mp3" &> /dev/null
# }
# hello () {
# 	echo "Hello"
# }
# html2ansi () {
# 	script="$ZDOTDIR/functions/html2ansi.js"
# 	if [ ! -f "$script" ]
# 	then
# 		echo "Error: html2ansi.js not found in $ZDOTDIR/functions/"
# 	else
# 		node "$script" "$@" | while IFS= read -r line
# 		do
# 			local truncated=$(truncate_ansi_to_columns "$line")
# 			echo "$truncated"
# 		done
# 	fi
# }
# import () {
# 	prompt=("Did you mean to run \033[5;38;5;1mimport\033[0m in the current terminal? \033[38;5;5mimport\033[39m is currently set to run ImageMagick." 'You likely meant to add a shebang to the top of a JavaScript file and the terminal found an "import" statement instead.' "Here is the shebang for Node.js:\n\n\033[38;5;2m\#!/usr/bin/env node\033[39m\n\n" 'Is this what you meant to do? (y/N)')
# 	answer="$(safeguard "${prompt[@]}")"
# }
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
# isdark () {
# 	local COLOR="$1"
# 	local R=$((0x$(echo $COLOR | cut -c2-3)))
# 	local G=$((0x$(echo $COLOR | cut -c4-5)))
# 	local B=$((0x$(echo $COLOR | cut -c6-7)))
# 	local LUMINANCE=$((R * 299 + G * 587 + B * 114))
# 	if ((LUMINANCE < 128000))
# 	then
# 		return true
# 	else
# 		return false
# 	fi
# }
# k () {
# 	pgrep "$1" | xargs kill
# }
# labs () {
# 	cd $LABS
# }
# license () {
# 	echo "Writing LICENSE file..."
# 	cat ~/LICENSE | tee ./LICENSE
# }
# media () {
# 	cd $MEDIA
# }
# pid () {
# 	pgrep "$1" | pbcopy
# }
# pmodload () {
# 	local -A ices
# 	(( ${+ICE} )) && ices=("${(kv)ICE[@]}" teleid '')
# 	local -A ICE ZINIT_ICE
# 	ICE=("${(kv)ices[@]}") ZINIT_ICE=("${(kv)ices[@]}")
# 	while (( $# ))
# 	do
# 		ICE[teleid]="PZT::modules/$1${ICE[svn]-/init.zsh}"
# 		ZINIT_ICE[teleid]="PZT::modules/$1${ICE[svn]-/init.zsh}"
# 		if zstyle -t ":prezto:module:$1" loaded 'yes' 'no'
# 		then
# 			shift
# 			continue
# 		else
# 			[[ -z ${ZINIT_SNIPPETS[PZT::modules/$1${ICE[svn]-/init.zsh}]} && -z ${ZINIT_SNIPPETS[https://github.com/sorin-ionescu/prezto/trunk/modules/$1${ICE[svn]-/init.zsh}]} ]] && .zinit-load-snippet PZT::modules/"$1${ICE[svn]-/init.zsh}"
# 			shift
# 		fi
# 	done
# }
# resource () {
# 	local file="$1"
# 	if [ -f "$file" ]
# 	then
# 		source "$file"
# 		local basedir=$(dirname "$file")
# 		add2path "$basedir"
# 	else
# 		echo "Resource file '$file' not found."
# 	fi
# }
# samp () {
# 	cd $SAMPLES
# }
# scripts () {
# 	cd $SCRIPTS
# }
# truncate_ansi_to_columns () {
# 	local input="$1"
# 	local clean visible raw_line result i chr
# 	clean=$(echo "$input" | sed 's/\x1B\[[0-9;]*[mK]//g')
# 	local max=${COLUMNS:-80}
# 	local count=0
# 	result=""
# 	i=1
# 	while [ $i -le ${#input} ] && [ $count -lt $max ]
# 	do
# 		chr="${input[i]}"
# 		if [ "$chr" = $'\033' ]
# 		then
# 			while [ "${input[i]}" != "m" ] && [ $i -le ${#input} ]
# 			do
# 				result+="${input[i]}"
# 				((i++))
# 			done
# 			result+="${input[i]}"
# 		else
# 			result+="$chr"
# 			((count++))
# 		fi
# 		((i++))
# 	done
# 	echo "$result"
# }
# uuid () {
# 	uuidgen | tr '[:lower:]-' '[:upper:]_' | sed 's/^/MAIN_/'
# }
# visual_length () {
# 	emulate -L zsh
# 	local expanded=$(print -P -- "$1")
# 	local clean=$(print -r -- "$expanded" | sed $'s/\x1B\\[[0-9;]*[mGKH]//g')
# 	print ${#clean}
# }
# wk () {
# 	cd $WORKBENCH
# }
# xdg-lint () {
# 	echo "🔍 Scanning $HOME for non-XDG config files..."
# 	local whitelist=(".bashrc" ".zshrc" ".zshenv" ".bash_profile" ".profile" ".gitconfig" ".ssh" ".gnupg" ".gnupg2" ".gnome" ".local" ".config" ".cache" ".DS_Store" ".Trash" ".mozilla" ".npmrc")
# 	for file in $HOME/.*
# 	do
# 		[ -e "$file" ] || continue
# 		local name=${file##*/}
# 		if [[ ! " ${whitelist[@]} " =~ " ${name} " ]]
# 		then
# 			echo "⚠️  $name may be violating XDG spec. Consider moving it to:"
# 			echo "    $XDG_CONFIG_HOME/$name or $XDG_DATA_HOME/$name"
# 		fi
# 	done
# }
