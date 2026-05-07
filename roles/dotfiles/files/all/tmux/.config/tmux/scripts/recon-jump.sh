#!/usr/bin/env bash
# Cycle to next Claude pane needing user attention.
# Order: panes showing a permission prompt (`❯ 1. Yes`/`No`), then stop-hook
# completion markers, newest first. If current pane is already in the list,
# advance to the next one (wrap around); otherwise jump to the head.
# Completion markers are cleared by the pane-focus-in hook, no rm needed here.
#
# Detection runs in pure shell (~12ms): tmux capture-pane | grep — vs ~600ms
# for `recon next`, which walks all .claude.jsonl files for token stats we
# don't need. Compatible with bash 3.2 (macOS /bin/bash).
set -u
shopt -s nullglob

# Debounce held-key autorepeat: tmux fires `run-shell -b` per OS keystroke,
# spawning many concurrent instances that each call `switch-client`. Atomic
# mkdir lock — losers exit immediately. Effective gap ≈ script runtime.
LOCK_DIR=${TMPDIR:-/tmp}/recon-jump.lock.d
mkdir "$LOCK_DIR" 2>/dev/null || exit 0
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

current=$(tmux display-message -p '#{pane_id}')

to_pane_id() { tmux display-message -p -t "$1" '#{pane_id}' 2>/dev/null; }

# Input detection: ported from gavraz/recon src/session.rs::pane_status.
# Walk pane content bottom-up over NON-EMPTY lines (max 10). Two signals:
#   - "Esc to cancel" on the very last non-empty line (permission prompt
#     footer). Anchored to last line so scrollback hits don't false-positive.
#   - "❯ N." (cursor + digit) anywhere in the last 10 non-empty lines —
#     covers both tool-permission prompts and AskUserQuestion menus.
# Counting non-empty lines (rather than raw `tail -N`) is the key difference;
# panes often have trailing blank rows that push the prompt out of a raw tail.
refs=()
while IFS= read -r r; do [ -n "$r" ] && refs+=("$r"); done < <(
    tmux list-panes -a -F '#{pane_id} #{pane_current_command}' \
        | awk '$2 ~ /^claude/ {print $1}' \
        | while read -r p; do
            tmux capture-pane -t "$p" -p 2>/dev/null | awk '
                /[^[:space:]]/ { lines[++n] = $0 }
                END {
                    for (i = n; i > 0 && (n - i) < 10; i--) {
                        L = lines[i]
                        if ((n - i) == 0 && index(L, "Esc to cancel")) exit 0
                        if (match(L, /❯[[:space:]]+[0-9]/))            exit 0
                    }
                    exit 1
                }
            ' && echo "$p"
        done
)

# Sort completion markers newest-first by mtime. Glob expansion (with nullglob)
# yields zero entries when no markers exist; stat handles the empty list cleanly.
markers=(/tmp/claude_*_completed)
if [ ${#markers[@]} -gt 0 ]; then
    while IFS= read -r m; do
        [ -z "$m" ] && continue
        sid=${m##*/claude_}; sid=${sid%_completed}
        pane=$(cat "/tmp/claude_${sid}_pane" 2>/dev/null) || continue
        [ -n "$pane" ] && refs+=("$pane")
    done < <(stat -f '%m %N' "${markers[@]}" 2>/dev/null | sort -rn | cut -d' ' -f2-)
fi

# Normalize to %pane_id, drop dead panes, dedupe (Input + completion may overlap).
# Plain string for dedupe — bash 3.2 has no associative arrays.
ids=()
seen=" "
for r in "${refs[@]:-}"; do
    [ -z "$r" ] && continue
    pid=$(to_pane_id "$r") || continue
    [ -z "$pid" ] && continue
    case "$seen" in *" $pid "*) continue ;; esac
    seen="$seen$pid "
    ids+=("$pid")
done

n=${#ids[@]}
if [ "$n" -eq 0 ]; then
    tmux display-message "No sessions waiting"
    exit 0
fi

idx=-1
for i in "${!ids[@]}"; do
    [ "${ids[$i]}" = "$current" ] && { idx=$i; break; }
done
if [ "$idx" -lt 0 ]; then
    next=${ids[0]}
else
    next=${ids[$(( (idx + 1) % n ))]}
fi

target=$(tmux display-message -p -t "$next" '#{session_name}:#{window_index}.#{pane_index}' 2>/dev/null)
if [ -z "$target" ]; then
    tmux display-message "Pane $next gone"
    exit 0
fi

tmux switch-client -t "$target" || tmux display-message "switch-client failed for $target"
