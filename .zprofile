# shellcheck shell=zsh

# if [[ -o interactive ]]; then
#   print -n -P "[%F{green}.zprofile%f]"
# fi
# ============================
# Plugins and Integrations
# ============================

if [ -f '/Users/donaldmoore/google-cloud-sdk/path.zsh.inc' ]; then
	. '/Users/donaldmoore/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/Users/donaldmoore/google-cloud-sdk/completion.zsh.inc' ]; then
	. '/Users/donaldmoore/google-cloud-sdk/completion.zsh.inc'
fi
