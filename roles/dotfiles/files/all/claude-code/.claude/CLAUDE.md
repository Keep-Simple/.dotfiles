# Global rules

Temp files: use `$TMPDIR`, never `/tmp/`. `/tmp/` is world-writable on macOS. Applies to `curl -o`, `>`, `mktemp`, scratch dirs.

Symlinked dotfiles: `~/.claude/*` and other `$HOME` configs are stow symlinks into `~/.dotfiles/roles/dotfiles/files/...`. Edit tool refuses symlinks. Resolve with `readlink -f <path>` first, then edit the real target under `~/.dotfiles/`.

Sandbox retry: if a Bash command fails with "Operation not permitted", immediately retry with `dangerouslyDisableSandbox: true` — don't ask, don't explain first, just retry. Briefly note the sandbox restriction after.
