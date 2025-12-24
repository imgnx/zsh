# Codex Shell

This profile gives Codex a clean, isolated zsh without touching the user's configuration.

## How to start it (monolih / Codex)

- `cd ~/.config/zsh`
- Run `./bin/codex-shell` to launch the clean shell (it sets `ZDOTDIR` to `codex-shell/`).
- Confirm you are in the sandboxed profile with `echo $ZDOTDIR` → `.../codex-shell` and a simple `user@host <cwd> %#` prompt.
- Exit as usual with `exit` or `Ctrl+D`. This never touches the user's primary shell configs.

## Notes

- History is written to `~/.local/state/zsh/codex-history`, separate from the user's history.
- PATH is rebuilt with macOS defaults, Homebrew, and the standard `~/.local/bin` and `~/bin`.
- Prompt is simple (`user@host <cwd> %#`) with a right-side git branch indicator via `vcs_info`.
