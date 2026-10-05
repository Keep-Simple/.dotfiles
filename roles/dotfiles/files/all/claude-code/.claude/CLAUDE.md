# Global rules

- Temp files: use `$TMPDIR`, never `/tmp/`. `/tmp/` is world-writable on macOS. Applies to `curl -o`, `>`, `mktemp`, scratch dirs.

- Sandbox retry: if a Bash command fails with "Operation not permitted", immediately retry with `dangerouslyDisableSandbox: true` — don't ask, don't explain first, just retry. Briefly note the sandbox restriction after.

- Before writing prose meant for humans (docs, PR descriptions, commit bodies, issues, Slack/email drafts, memory files), invoke the `unslop` skill to cut AI tells. Skip for code, code comments, and terminal chat replies.

## Code comments

- Default to zero comments. The code shows how it works. A comment earns its place only by carrying why: a non-obvious constraint, a deliberate deviation, a gotcha, a workaround.
- Never narrate the code. No "loop over users", no restating a name, type or signature, no `} // end if`.
- Never narrate the change. No "fixed X", "updated to Y", "as requested", "was previously Z", "new in this version". A comment has to read correctly to someone who opens the file fresh and never saw the diff. Change context goes in the commit message.
- Never leak the working session. No Jira keys or ticket IDs, no PR or issue numbers, no "per review feedback", no plan step or phase markers, no TODO invented mid-task to park work that was asked for. That context belongs in the commit, the PR body or the tracker, never in the source.
- A comment has to stand on its own with any link removed. Write the substance, not a pointer to it. Banned: spec section numbers, design docs, "see the requirements".
- One summary line on a public function or endpoint is fine. Restating a single clear line inline never is.
- Cut every comment that survives down to the one fact a reader needs at that line, in the fewest words. A five-line block almost never survives intact.

@RTK.md
@snyk-ecosystem.md
