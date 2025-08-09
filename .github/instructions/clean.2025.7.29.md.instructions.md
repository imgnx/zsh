---
applyTo: "**/*"
---

1. .zshrc You already fixed early returns and compinit. Good! Make sure you do not have duplicate or
   conflicting alias/function definitions (e.g., for ls in both aliases.zsh and screencast_mode.sh). Only
   source scripts that are meant for Zsh, not scripts in other languages.
2. aliases.zsh Only define aliases here, not functions or scripts in other languages. If you want to override
   ls for screencast mode, do it conditionally and not in both places.
3. paths.zsh Only use for static path exports, as you are now handling dynamic path logic in your delayed
   loader. Remove any interactive or dynamic path logic from here.
4. functions.zsh.d Only source .zsh or .sh files here. Do not source .awk, .pl, .js, etc. Instead, create
   aliases for those executables (as you are now doing). For example, in your loader:
5. completions.zsh Make sure autoload -Uz compinit; compinit is run before any compdef calls.
6. paths.blacklist.txt and paths.whitelist.txt These are fine as-is. They are used by your loader for path
   management.
7. .zshenv, .zprofile, .zlogin, .zlogout Only put minimal, environment-wide settings in .zshenv. Use .zprofile
   for login shell setup, .zlogin for post-login, .zlogout for cleanup. Do not put interactive or prompt logic
   in .zshenv.
8. functions.zsh Only Zsh functions should be defined here. Do not define functions based on aliases (e.g.,
   ls() { ... } if ls is already an alias).
9. screencast_mode.sh Only define the ls function if not already aliased, or unalias it first:
10. General Do not source or execute scripts in other languages (Perl, AWK, JS) as Zsh scripts. Only source
    Zsh-compatible scripts in your loader. Summary:

Only source Zsh scripts in your loader. Use aliases for non-Zsh executables. Avoid function/alias conflicts.
Keep static path logic in paths.zsh, dynamic in your loader. Ensure compinit is run before completions.
