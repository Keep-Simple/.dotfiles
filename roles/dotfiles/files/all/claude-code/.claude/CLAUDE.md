# Global rules

- Temp files: use `$TMPDIR`, never `/tmp/`. `/tmp/` is world-writable on macOS. Applies to `curl -o`, `>`, `mktemp`, scratch dirs.

- Sandbox retry: if a Bash command fails with "Operation not permitted", immediately retry with `dangerouslyDisableSandbox: true` — don't ask, don't explain first, just retry. Briefly note the sandbox restriction after.

- Before writing prose meant for humans (docs, PR descriptions, commit bodies, issues, Slack/email drafts, memory files), invoke the `unslop` skill to cut AI tells. Skip for code, code comments, and terminal chat replies.

@RTK.md
@snyk-ecosystem.md
