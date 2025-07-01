#!/bin/zsh
# shellcheck shell=zsh

if [[ -o interactive ]]; then
  echo -e "[\033[38;5;2m.zprofile\033[39m]"
fi

# if ! pgrep -x gpg-agent >/dev/null; then
#     gpg-agent --daemon --quiet
# fi

# . "$ZDOTDIR/aliases.zsh"
# . "$ZDOTDIR/functions.zsh"
# . "$ZDOTDIR/exports.zsh"
# . "$ZDOTDIR/variables.zsh"
# . "$ZDOTDIR/paths.zsh"
# . "$ZDOTDIR/prompt.zsh"
# . "$ZDOTDIR/plugins.zsh"
# . "$ZDOTDIR/ohmyzsh.zsh"
# . "$ZDOTDIR/zinit.zsh"
# . "$ZDOTDIR/doom.zsh"

# Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

# ============================
# Environment Variables
# ============================
export EXA_COLORS="ln=1;35"
export ICLOUD_DRIVE="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export BACKUPS="$ICLOUD_DRIVE/_____BACKUPS"
export BK="$ICLOUD_DRIVE/_____BACKUPS"
export WORKBENCH="$HOME/_____WORKBENCH"
export SCRIPTS="$HOME/scripts"
export TAKU="$WORKBENCH/taku"
export MEDIA="$ICLOUD_DRIVE/_____MEDIA"
export SAMPLES="$ICLOUD_DRIVE/_____MEDIA/_____SAMPLES"
export BKGD="$SAMPLES/bkgd.mp3"
export CONTAINERS="$HOME/_____CONTAINERS"
export LABS="$WORKBENCH/_____LABS"
export DOWNLOADS="$HOME/Downloads"
export LOGPATH="$ICLOUD_DRIVE/Logs/"
export CALCULATOR="/Users/donaldmoore/Library/Mobile Documents/com~apple~CloudDocs/_____WORKBENCH/src/utils/financial/calculator"

# ============================
# Functions
# ============================
function media() { cd $MEDIA; }
function wk() { cd $WORKBENCH; }
function samp() { cd $SAMPLES; }
function scripts() { cd $SCRIPTS; }
function bkgd() { afplay "$BKGD"; }
function labs() { cd $LABS; }
function elev8r() { afplay "$SAMPLES/Media/bkgd.mp3" &>/dev/null; }
function pid() { pgrep "$1" | pbcopy; }
function k() { pgrep "$1" | xargs kill; }
function license() {
  echo "Writing LICENSE file..."
  cat ~/LICENSE | tee ./LICENSE
}
# function tree() {
#   local level=${1:-1}
#   shift
#   eza --tree -a --level=$level --color=always --group-directories-first --icons "$@"
# }
# function cd_domain() { ... } # (Keep the full function here)
# function plink() { ... } # (Keep the full function here)
function duhast() { df -ahicY; }
# function npm() { ... } # (Keep the full function here)
function hello() { echo "Hello"; }
# function purge() { ... } # (Keep the full function here)
# This would essentially clear out ~/_____CONTAINERS as well as
# any other temporary files and force an iCloud sync.
function config() { emacs $WORKBENCH/.vscode/Workbench.code-workspace; }
function codespace() { code -r $WORKSPACE/.vscode/Workbench.code-workspace; }
function console() { logger -t "imgnx" $@; }
# function scan() { ... } # (Keep the full function here)

# ============================
# Plugins and Integrations
# ============================
if command -v code >/dev/null 2>&1; then
  export VSCODE_SUGGEST=1
  source "$(code --locate-shell-integration-path zsh)"
fi

if [ -f '/Users/donaldmoore/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/donaldmoore/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/Users/donaldmoore/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/donaldmoore/google-cloud-sdk/completion.zsh.inc'
fi

# print -P "✔︎ %F{yellow}.zprofile%f"
