# !/bin/zsh
# shellcheck disable=all

fnsh() {
	$EDITOR "/Users/donaldmoore/.config/zsh/fn.sh"
}
alias functions="fnsh"
alias fn="fnsh"

# Keep this at the top!
# Start of __wrap_notice
# ! Keep this at the top!
__wrap_notice() {
# ! Keep this at the top!
  if [[ "${ZSH_DEBUG:-false}" == "true" ]]; then
    local name="$1" path
    path=$(command -v "$name" 2>/dev/null || true)
    [[ -n "$path" ]] && echo "[wrap] $name -> $path"
  fi
} # End of __wrap_notice ! Keep this at the top!
# End of __wrap_notice ! Keep this at the top!



gemini() {
	 # Define the options with brief descriptions
  options=("copy" "Copy files"
           "move" "Move files (copy + delete source)"
           "update" "Update files (only newer files)"
           "reformat" "Reformat files (like renaming or restructuring)"
           "help" "Display help about rsync and options"
           "q" "Quit")

  echo "Choose an action to perform:"

  # Use select to display the options with descriptions
  select choice in "${options[@]}"; do
    case $choice in
      "copy")
        echo "You chose to copy files."
        echo "Running rsync with copy options..."
        echo "Command: rsync -avh --no-links \"$1\" \"$2\""
        echo "Press [ENTER] to continue..."
        read
        rsync -avh --no-links "$1" "$2"
        break
        ;;
      "move")
        echo "You chose to move files."
        echo "Running rsync with move options..."
        echo "Command: rsync -avh --remove-source-files \"$1\" \"$2\""
        echo "Press [ENTER] to continue..."
        read
        rsync -avh --remove-source-files "$1" "$2"
        break
        ;;
      "update")
        echo "You chose to update files."
        echo "Running rsync with update options..."
        echo "Command: rsync -avh --update --no-links \"$1\" \"$2\""
        echo "Press [ENTER] to continue..."
        read
        rsync -avh --update --no-links "$1" "$2"
        break
        ;;
      "reformat")
        echo "You chose to reformat files."
        echo "Running rsync with reformat options..."
        echo "Command: rsync -avh --no-links --backup --suffix=.bak \"$1\" \"$2\""
        echo "Press [ENTER] to continue..."
        read
        rsync -avh --no-links --backup --suffix=.bak "$1" "$2"
        break
        ;;
      "help")
        # Display help for rsync command
        echo "Help: Rsync Command and Options"
        echo
        echo "rsync is a powerful tool for copying and synchronizing files."
        echo
        echo "Commonly used rsync options:"
        echo "  -a, --archive        Archive mode (preserves symbolic links, permissions, timestamps, etc.)"
        echo "  -v, --verbose        Verbose output"
        echo "  -h, --human-readable Human-readable output (e.g., with units like K, M, G)"
        echo "  --no-links           Skip symbolic links"
        echo "  --remove-source-files Removes source files after they have been copied (useful for move)"
        echo "  --update             Skip files that are newer on the destination"
        echo "  --backup             Backup any overwritten files"
        echo "  --suffix=.bak        Add a suffix (e.g., .bak) to backup files"
        echo
        echo "For more details on rsync, check the official documentation."
        break
        ;;
      "q")
        echo "Exiting..."
        break
        ;;
      *)
        echo "Invalid choice, please try again."
        ;;
    esac
  done
}
alias gmi=gemini

dusort () {
  du -sh -- **/* **/.*
  if [[ $? -ne 0 ]]; then
    du -sh -- * .*
  fi | sort -hr | uniq | bat || exit 1
}
alias dsort="dusort"

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
                duration=$OPTARG  # If -d is passed, set the duration in minutes
                ;;
            *)
                echo "Usage: schedule_reminder [-d duration_in_minutes] <reminder_message>"
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))  # Remove the options from the arguments list

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
	/bin/cp "$@";
}
cpn() {
	cp "$@";
}
cp() {
	echo "The \`cp\` command is configured to **not** overwrite files. Use \`ucp\` if you **do** want it to overwrite Enter."
	echo -n "Press [ENTER] to continue."
	read
	/bin/cp -v -n "$@";
}

fnx_C6EE3E7B-5EB4-45F9-B13D-B451E169B079() {
	if pgrep -x "Hammerspoon" > /dev/null; then
		# If Hammerspoon is running, quit it
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
    remoteName="$(awk '{print $1}' <<< "$remote")"
    remoteUrl="$(awk '{print $2}' <<< "$remote")"

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

	RPROMPT='%F{#8aa6c0}cnf [%F{#928bbc}<config-dir> (%F{#8bb8b8}<file>%F{#928bbc})%F{#8aa6c0}]%f'
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


			
# --- wrapper helpers (must be defined before use) ----------------------------
# Suppress wrapper notices unless explicitly enabled via ZSH_DEBUG=true
__wrap_notice() {
  if [[ "${ZSH_DEBUG:-false}" == "true" ]]; then
    local name="$1" path
    path=$(command -v "$name" 2>/dev/null || true)
    [[ -n "$path" ]] && echo "[wrap] $name -> $path"
  fi
}


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


gpt() {
		# --- sanity ---------------------------------------------------------------
		command -v curl >/dev/null || { echo "gpt: curl not found"; return 127; }
		command -v jq >/dev/null || { echo "gpt: jq not found"; return 127; }
		[[ -n "$OPENAI_API_KEY" ]] || { echo "gpt: set \$OPENAI_API_KEY"; return 1; }

		# --- defaults -------------------------------------------------------------
		local model="${GPT_MODEL:-gpt-4o-mini}"
		local system="${GPT_SYSTEM:-You are a concise CLI assistant.}"
		local temperature="${GPT_TEMPERATURE:-0.3}"
		local stream="false"

		# --- parse args -----------------------------------------------------------
		local argv=()
		while [[ $# -gt 0 ]]; do
			case "$1" in
				-m) model="$2"; shift 2 ;;
				-s) system="$2"; shift 2 ;;
				-t) temperature="$2"; shift 2 ;;
				--stream) stream="true"; shift ;;
				-h|--help)
					cat <<'USAGE'
	gpt — talk to OpenAI from Zsh
	Usage:
		gpt "prompt text"
		echo "from stdin" | gpt
		gpt -m gpt-4o -t 0.1 "short, precise answer"
		gpt -s "You are terse." "one-liner"

	Flags:
		-m <model>         Model ID (default: gpt-4o-mini)
		-s <system>        System prompt
		-t <temperature>   0.0–1.0 (default: 0.3)
		--stream           Stream tokens
		-h, --help         Show this help

	Env:
		OPENAI_API_KEY (required), GPT_MODEL, GPT_SYSTEM, GPT_TEMPERATURE
USAGE
					return 0
					;;
				*) argv+=("$1"); shift ;;
			esac
		done

		# --- collect prompt (args or stdin) --------------------------------------
		local prompt
		if [[ ${#argv[@]} -gt 0 ]]; then
			prompt="${argv[*]}"
		else
			# read stdin without trimming newlines
			prompt="$(cat)"
		fi
		if [[ -z "$prompt" ]]; then
			echo "gpt: empty prompt (pass text or pipe stdin). Try: gpt -h"
			return 2
		fi

		# --- build JSON payload safely -------------------------------------------
		# escape newlines/quotes for JSON
		local esc_system esc_prompt
		esc_system=$(printf '%s' "$system" | jq -Rsa '.')[1,-2]
		esc_prompt=$(printf '%s' "$prompt" | jq -Rsa '.')[1,-2]

		# --- choose request style -------------------------------------------------
		if [[ "$stream" == "true" ]]; then
			# Stream tokens as they arrive (Chat Completions SSE)
			# Press Ctrl-C to stop; leaves what you’ve printed.
			curl -sS --no-buffer https://api.openai.com/v1/chat/completions \
				-H "Authorization: Bearer $OPENAI_API_KEY" \
				-H "Content-Type: application/json" \
				-d "$(cat <<JSON
	{
		"model": "$model",
		"temperature": $temperature,
		"stream": true,
		"messages": [
			{"role":"system","content":"$esc_system"},
			{"role":"user","content":"$esc_prompt"}
		]
	}
JSON
	)" | awk '
				/^data:/ {
					sub(/^data: /,"");
					if ($0 == "[DONE]") exit;
					# Print incremental content pieces if present
					if (match($0, /"content":"([^"]*)"/, m)) {
						gsub(/\\n/,"\n", m[1]);
						gsub(/\\t/,"\t", m[1]);
						gsub(/\\"/,"\"", m[1]);
						printf "%s", m[1];
						fflush();
					}
				}'
			echo
		else
			# One-shot request; pretty-print the assistant text
			curl -sS https://api.openai.com/v1/chat/completions \
				-H "Authorization: Bearer $OPENAI_API_KEY" \
				-H "Content-Type: application/json" \
				-d "$(cat <<JSON
	{
		"model": "$model",
		"temperature": $temperature,
		"messages": [
			{"role":"system","content":"$esc_system"},
			{"role":"user","content":"$esc_prompt"}
		]
	}
JSON
	)" | jq -r '.choices[0].message.content // .error.message // "No content"'
		fi
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
	command gcloud "$@"
}

bucket() {
	command gsutil cp -r "$1" gs://imgfunnels.com/
}

pbucket() {
    command gsutil cp -r "$1" gs://re_imgnx
}

# Ensure Emacs uses XDG init dir (Emacs 29+: --init-directory)
__wrap_notice emacs
emacs() {
    local initdir="${EMACSDIR:-$XDG_CONFIG_HOME/emacs}"
    if command emacs --help 2>&1 | grep -q -- '--init-directory'; then
        command emacs --init-directory "$initdir" "$@"
    else
        EMACSDIR="$initdir" DOOMDIR="${DOOMDIR:-$XDG_CONFIG_HOME/doom}" DOOMLOCALDIR="${DOOMLOCALDIR:-$XDG_CONFIG_HOME/emacs/.local}" command emacs "$@"
    fi
}

lock() {
	chflags -R uchg "$@"
}

unlock() {
	chflags -R nouchg "$@"
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
		card=$((card+1))
		# Split stats by tabs, colorize each part
		 # Split stats string by tab into array, handle empty or unset
		if [[ -n "$stats" ]]; then
			stat_parts=(${(s:$'\t')stats})
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
			card=$((card+1)) # Increment card for each stat
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
            -*) flags+=("$1");;  # Collect flags
            *) files+=("$1");;   # Collect file paths
        esac
        shift
    done

    for file in "${files[@]}"; do
        local abs_path="$(realpath "$file" 2>/dev/null)"

        # Check if the file is in any user's .Trash directory
        if [[ "$abs_path" =~ ^/Users/.*/\.Trash/ ]]; then
            /bin/rm "${flags[@]}" "$file"  # Call /bin/rm directly if file is in any user's .Trash
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

urm() {
	/bin/rm "$@"
}

init() {
	# Due to issues with corruption, this is the new ~/bin
	. $HOME/src/init/main.sh
}

ufind() {
	# Unix find
	/usr/bin/find "$@"
}

midi() {
    cd "/Users/donaldmoore/src/dinglehopper/stdln/midi"
	# todo: cargo build? python? node? How do you run it
	#
}

__wrap_notice find
find() {
	tempfile=$(mktemp)
	trap 'rm -f "$tempfile"' EXIT
	if /usr/bin/find "$@" > "$tempfile"; then
      bat "$tempfile"
	else
		/usr/bin/find "$@"
	fi
}

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
	echo "$before -> $after"
}

clean() {
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
	command tree -C "$@"
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

taku() {

	# Exit immediately if a command exits with a non-zero status
	set -e

	# Display the script's progress
	echo "Starting setup..."

	# 1. Create the project directory
	echo "Creating project directory..."
	mkdir -p web-audio-experiment
	cd web-audio-experiment

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

	# 8. Run the app (optional step, can be run later)
	echo "Project setup complete! Run 'npm start' to start the app."
}

function cd() {
	# which pushd
	# If I try t cd into $HOME/bin, take me to ~/dist. There is an issue with corruption on the drive.

	# Resolve paths for accurate comparison
	local target_path
	if [[ "$1" == "." || "$1" == "" ]]; then
		target_path="$PWD"
	elif [[ "$1" == "~"* ]]; then
		target_path="${1/#\~/$HOME}"
	elif [[ "$1" == /* ]]; then
		target_path="$1"
	else
		target_path="$PWD/$1"
	fi
	
	# Normalize the path by resolving any . or .. components
	target_path=$(realpath "$target_path" 2>/dev/null || echo "$target_path")
	
	# Check if trying to cd to $HOME/bin specifically
	if [[ "$target_path" == "$HOME/bin" ]]; then
		echo "⚠️  Redirected from $HOME/bin to $HOME/dist to avoid The Corruption"
		echo "💡 Use 'ucd' to access the actual Unix cd command if needed"
		set -- "$HOME/dist"
	fi
	builtin pushd "$@" > /dev/null
	#  cd "$@" || return

	if [[ "$PWD" == "$HOME/src" ]]; then
		when () {
			ufind ${1:-.} -maxdepth 1 -exec stat -f "%B %N" {} + | sort -nr | while read ts file
			do
				echo "$(date -r "$ts" '+%Y-%m-%d %H:%M:%S')  $file"
			done
		}
		when | head -n 20
	fi
}

dir() {
	hash "$@"
}

cnf() {
	cd "$HOME/.config/$1"
}

copy() {
	$@ | pbcopy
	export v=$(pbpaste)
}

# v() {
#  echo $(pbpaste)
# }

alias ugit=/usr/local/bin/git
__wrap_notice git

git() {
  if [[ "$1" == "sum" ]]; then
    git log --oneline
    read -r -p "Press any key to continue..."
    git status --short
    /usr/local/bin/git diff --minimal --color=always | less -R
  elif [[ "$1" == "remote" || "$1" == "log" || "$1" == "branch" || "$1" == "acp"  ]]; then
    dash "$XDG_CONFIG_HOME/git/aliases.sh" "$@"
  elif [[ "$1" == "list" ]]; then
	  find /Volumes/ -type d -name ".git" | tee $HOME/tmp/git.list;
	  say "Here's your list of git repositories";
	  bat "$HOME/tmp/git.list"

  else
    /usr/local/bin/git "$@"
  fi
}

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
	if (( add2pathCounter % 100 == 0 )); then
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
		if (( add2pathCounter % 100 == 0 )); then
			echo -e "\033[38;5;3mWarning: Reached the 100 times checkpoint.\033[0m"
		fi
	fi
}


tabula_rasa() {
	if [[ -z "$TABULA_RASA" ]]; then
		export TABULA_RASA=1
		echo "Tabula Rasa mode is enabled. No configurations will be loaded."
		# Prompt the user to see if they want to continue and reload in Tabula Rasa mode.
		echo "Do you want to continue and reload in Tabula Rasa mode? (y/N)"
		read -r response
		if [[ "$response" == [Yy] ]]; then
			exec zsh -l
		fi
	else
		export TABULA_RASA=0
		# echo "Tabula Rasa mode is disabled. Configurations will be loaded."
	fi
}
i_manifest_gods_not_exiles		() {
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
d() {
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
k() {
	pgrep "$1" | xargs kill
}
pid() {
	pgrep "$1" | pbcopy
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
	find ${1:-.} -maxdepth 1 -exec stat -f "%B %N" {} + | sort -nr | while read ts file; do echo "$(date -r "$ts" '+%Y-%m-%d %H:%M:%S')  $file"; done
}

whoami() {
	cat << 'EOF'
__/\\\\\\\\\\\\___________________________________/\\\\\\\\\\\\_____/\\\______________/\\\__/\\\\____________/\\\\_        
_\/\\\////////\\\________________________________\/\\\////////\\\__\/\\\_____________\/\\\_\/\\\\\\________/\\\\\\_       
_\/\\\______\//\\\_______________________________\/\\\______\//\\\_\/\\\_____________\/\\\_\/\\\//\\\____/\\\//\\\_      
_\/\\\_______\/\\\__/\\/\\\\\\\__________________\/\\\_______\/\\\_\//\\\____/\\\____/\\\__\/\\\\///\\\/\\\/_\/\\\_     
	_\/\\\_______\/\\\_\/\\\/////\\\_________________\/\\\_______\/\\\__\//\\\__/\\\\\__/\\\___\/\\\__\///\\\/___\/\\\_    
	_\/\\\_______\/\\\_\/\\\___\///__________________\/\\\_______\/\\\___\//\\\/\\\/\\\/\\\____\/\\\____\///_____\/\\\_   
	_\/\\\_______/\\\__\/\\\_________________________\/\\\_______/\\\_____\//\\\\\\//\\\\\_____\/\\\_____________\/\\\_  
	_\/\\\\\\\\\\\\/___\/\\\__________/\\\___________\/\\\\\\\\\\\\/_______\//\\\__\//\\\______\/\\\_____________\/\\\_ 
		_\////////////_____\///__________\///____________\////////////__________\///____\///_______\///______________\///__
EOF
	/usr/bin/whoami "$@" | sed 's/^/👤 /'
}

# clean-hooks() {
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
# codespace() {
# 	code -r "$WORKSPACE/.vscode/Workbench.code-workspace"
# }


# Print the size of the current file.
# print -P -n "[%F{green}functions%f]"

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

# System Information
# function 6D078F25_9FBE_4352_A453_71F7947A3B01() {

# 	local ZSH_COUNT CPU_USAGE RAM
# 	local mtime
# 	if [[ "$OSTYPE" == darwin* ]]; then
# 		mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
# 	else
# 		mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
# 	fi
# 	[[ ! -d "$HOME/tmp" ]] && mkdsir -p "$HOME/tmp"
# 	[[ ! -f $SYSLINE_CACHE ]] && touch $SYSLINE_CACHE
# 	CPU_USAGE=$(LANG=C ps -A -o %cpu | awk '{s+=$1} END {printf "%.1f", s}')
# 	if vm_stat >/dev/null 2>&1; then
# 		RAM=$(vm_stat | awk "/Pages free/ { printf \"%.1f\", \$3 * 4096 / 1024 / 1024 }")
# 	else
# 		RAM=$(free -m | awk "/Mem:/ { printf \"%.1f\", \$4 }")
# 	fi
# 	ZSH_COUNT=$(pgrep -c zsh 2>/dev/null || ps -eo comm | grep -c "^zsh")
# 	if [[ $ZSH_COUNT -gt 30 ]]; then
# 		CONCURRENT_SHELLS="%F{#FF2000} ${ZSH_COUNT} %f"
# 	elif [[ $ZSH_COUNT -gt 20 ]]; then
# 		CONCURRENT_SHELLS="%F{#FF8000} ${ZSH_COUNT} %f"
# 	elif [[ $ZSH_COUNT -gt 15 ]]; then
# 		CONCURRENT_SHELLS="%F{#FFFF00} ${ZSH_COUNT} %f"
# 	elif [[ $ZSH_COUNT -gt 10 ]]; then
# 		CONCURRENT_SHELLS="%F{#80FF00} ${ZSH_COUNT} %f"
# 	else
# 		CONCURRENT_SHELLS="%F{#4400CC} ${ZSH_COUNT} %f"
# 	fi

# 	# Newline for sparsity
# 	echo -e "~zQt:| ${CONCURRENT_SHELLS} |~\tCPU:| ${CPU_USAGE}%% |~\tRAM:| ${RAM}MB" >"$SYSLINE_CACHE"
# }

# Prompt
# function F6596432_CA98_4A50_9972_E10B0EE99CE9() {
# 	local mtime
# 	if [[ "$OSTYPE" == darwin* ]]; then
# 		mtime=$(stat -f %m "$SYSLINE_CACHE" 2>/dev/null)
# 	else
# 		mtime=$(stat -c %Y "$SYSLINE_CACHE" 2>/dev/null)
# 	fi
# 	local now=$(date +%s)
# 	if [[ -n "$mtime" && "$mtime" -lt $((now - 10)) ]]; then
# 		6D078F25_9FBE_4352_A453_71F7947A3B01

# 	fi
# 	local sysline=""
# 	[[ -f $SYSLINE_CACHE ]] && sysline=$(<"$SYSLINE_CACHE")


# }

pppp() {
echo -e "\033[36m"
cat<<EOF
# Pick, Process, Push, Persist

How a computer processes items in a loop.

Breakdown:

Pick (Load):
Pick the data, value, or input for processing. In a loop, this is where you load the current item (e.g., a file name, or the current loop value).
You pick the value or item to work on next.

Process (Execute):
Process the data or command. This is the execution phase where your loop or command actually does something—whether it's comparing values, running a command, or modifying something.
You process the data or execute the logic.

Push (Offload temporarily):
Push the data out temporarily, like sending it to stdout, a buffer, or the screen. This is the point where you send the result somewhere briefly.
You push the result to an output (such as printing to the terminal).

Persist (Offload persistently):
Persist the result if needed. This might involve saving the output to a file, database, or storing the final result somewhere permanent.
You persist the data if necessary (e.g., write to a file, save a result).


Why it Works:

Pick: Like picking a fruit off a tree — you’re selecting the data to work with.

Process: The actual processing or execution of commands, like squeezing or pressing to shape something.

Push: Pushing the results somewhere temporary, like pushing a button.

Persist: When you keep or store the result, like a keepsake or an important piece of data.

Mnemonic:
"Pick, Process, Push, Persist" is a nice, rhythmic phrase that can help you remember the cycle of how a loop or command executes at both the shell and assembly level.

EOF
echo -e "\033[0m"
}
