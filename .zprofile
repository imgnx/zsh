# shellcheck shell=zsh

if [[ -o interactive ]]; then
  echo -e "[\033[38;5;2m.zprofile\033[39m]"
fi
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
