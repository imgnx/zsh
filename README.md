# Zsh Order of Execution

### 🌀 Login Shell (typically when you log in from a TTY, SSH, or via a terminal set to start a login shell)

1. ~/.zshenv – Always sourced (minimal environment setup)

2. ~/.zprofile – Like ~/.profile (used for login-session-specific config)

3. ~/.zshrc – Interactive shell settings (aliases, prompts, etc.)

4. ~/.zlogin – Run after .zshrc (like .bash_login)

(Shell exits) → ~/.zlogout – Only in login shells

---

### ⚡ Interactive Non-Login Shell (e.g., launching a terminal window that is not a login shell)

1. ~/.zshenv

2. ~/.zshrc

---

### 🧱 Script / Non-Interactive Shell (when running a script like zsh myscript.zsh)

4. ~/.zshenv – and that’s it.

---

### 📁 Notes on Other Files

~/.zshenv is always sourced, regardless of shell type.

~/.zprofile is like Bash’s ~/.profile.

~/.zshrc is meant for interactive setup only.

~/.zlogin is like .bash_login, but in Zsh.

~/.zlogout is for cleanup when logging out.

---

### 🔥 Bonus Tip: Precedence

> If you're setting ZDOTDIR, then all of these are resolved relative to $ZDOTDIR (e.g., ~/.config/zsh/.zshrc
> if you point it there).
