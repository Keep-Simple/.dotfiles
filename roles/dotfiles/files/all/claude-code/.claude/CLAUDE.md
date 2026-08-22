# Global rules

- Temp files: use `$TMPDIR`, never `/tmp/`. `/tmp/` is world-writable on macOS. Applies to `curl -o`, `>`, `mktemp`, scratch dirs.

- Sandbox retry: if a Bash command fails with "Operation not permitted", immediately retry with `dangerouslyDisableSandbox: true` — don't ask, don't explain first, just retry. Briefly note the sandbox restriction after.

@RTK.md
@snyk-ecosystem.md
