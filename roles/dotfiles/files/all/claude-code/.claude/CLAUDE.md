# Global rules

Temp files: use `$TMPDIR`, never `/tmp/`. `/tmp/` is world-writable on macOS. Applies to `curl -o`, `>`, `mktemp`, scratch dirs.
