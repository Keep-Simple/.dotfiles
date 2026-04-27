# Claude Code Notification Hooks

This directory contains the hook scripts for Claude Code notifications in tmux.

## Scripts

### on-user-prompt-submit.sh
Runs when you submit a prompt to Claude Code. Captures:
- Current tmux pane ID
- Repository name (or current directory)

These are saved to `/tmp/claude_${SESSION_ID}_pane` and `/tmp/claude_${SESSION_ID}_repo` for use by other hooks.

### on-stop.sh
Runs when Claude Code finishes a task. Sends a notification if:
- The frontmost app is NOT the terminal configured via `CLAUDE_HOOK_TERMINAL_APP` (default: `Ghostty`), OR
- The current pane is NOT the pane where Claude was invoked

This prevents notifications when you're actively watching Claude work.

### on-notification.sh
Runs when Claude Code sends a notification event. Displays the notification using terminal-notifier.

## Debugging

All scripts write debug logs to `/tmp/claude-hook-logs/`:
- `hook-user-prompt-submit.log`
- `hook-stop.log`
- `hook-notification.log`

To monitor the logs in real-time:

```bash
# Watch all hook logs
tail -f /tmp/claude-hook-logs/hook-*.log

# Watch a specific hook
tail -f /tmp/claude-hook-logs/hook-stop.log
```

## Troubleshooting

### Notifications not appearing

1. Check if terminal-notifier is installed:
   ```bash
   which terminal-notifier
   ```

2. Check the debug logs:
   ```bash
   tail -50 /tmp/claude-hook-logs/hook-stop.log
   ```

3. Verify the temp files are being created:
   ```bash
   ls -la /tmp/claude_*
   ```

4. Test terminal-notifier manually:
   ```bash
   terminal-notifier -title "Test" -message "Testing" -sound "Glass"
   ```

### Check hook execution

The debug logs show:
- All environment variables
- Whether conditions are met for notifications
- Any errors that occur

### Clear old session files

If you have stale session files:
```bash
rm /tmp/claude_*
```
