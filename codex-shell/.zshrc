# Minimal interactive settings for Codex-only shells.

setopt autocd \
       correct \
       interactivecomments \
       nobeep \
       prompt_subst \
       inc_append_history_time \
       share_history \
       hist_ignore_dups \
       hist_ignore_space \
       extended_history \
       mark_dirs

bindkey -e

autoload -Uz colors
colors

autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
compinit -d "$ZSH_COMPDUMP"

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git
precmd() { vcs_info }

PROMPT='%n@%m %~ %# '
RPROMPT='${vcs_info_msg_0_}'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export EDITOR="${EDITOR:-vi}"
export PAGER="${PAGER:-less}"
