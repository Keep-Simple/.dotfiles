# Known Issues & Workarounds

## yabai 7.1.25 — window move across spaces broken (2026-05-11)

**Symptom:** `yabai -m window --space N` silently does nothing. All space-move keybindings (skhdrc `move_to_space`) broken.

**Root cause:** yabai 7.1.25 switched from SA-based space moves to `SLSBridgedMoveWindowsToManagedSpaceOperation` (new SkyLight private API targeting macOS Tahoe/26). The API exists on macOS 26 but the call silently fails with partial SIP config (Filesystem Protections disabled + Authenticated Root enabled). The old SA-based codepath was removed.

**Workaround:** pinned at 7.1.24.

**To revert workaround when fixed:**
1. `brew unpin asmvik/formulae/yabai`
2. Update Brewfile: remove `pin: true` from `brew "asmvik/formulae/yabai"`
3. `brew upgrade asmvik/formulae/yabai`
4. Re-sign: `codesign -fs "yabai-cert" $(which yabai)`
5. Update sudoers hash: `sudo visudo -f /private/etc/sudoers.d/yabai` → paste `shasum -a 256 $(which yabai) | cut -d" " -f1`
6. Restart yabai: `launchctl unload ~/Library/LaunchAgents/com.asmvik.yabai.plist && launchctl load ~/Library/LaunchAgents/com.asmvik.yabai.plist`
7. Test: `yabai -m window --space 3`

**Tracking:** https://github.com/asmvik/yabai/issues/2788

---

## skhd-zig 0.1.2 — auto-registers SMAppService on upgrade (2026-05-11)

**Resolved 2026-09-10:** migrated back to C skhd (`koekeishiya/formulae/skhd`), which has no
SMAppService support and no post-install service registration. Kept for history — the
`--uninstall-service` / `--uninstall-grabber` flags below are zig-only and do not exist on C skhd.

**Symptom:** After `brew upgrade skhd-zig`, skhd starts independently via launchd (parent PID 1) instead of as a child of yabai. `$YABAI` env var not set → skhdrc `.define focus_space : $YABAI/focus_space.sh` expands to empty path → all yabai script bindings broken.

**Root cause:** skhd-zig 0.1.2 added `--install-service` via SMAppService. The brew post-install hook auto-registered it, causing skhd to start at login independently before yabai runs, with bare launchd env (no `$YABAI`).

**Workaround applied (2026-05-19: re-triggered on upgrade to 0.1.3, rolled back to 0.1.2 + pinned):**
```bash
# cleanup first (per README):
skhd --uninstall-service
sudo skhd --uninstall-grabber
# rollback:
brew uninstall skhd-zig
cd /opt/homebrew/Library/Taps/jackielii/homebrew-tap && git checkout 8abb548 -- Formula/skhd-zig.rb
brew install skhd-zig
brew pin skhd-zig
git checkout HEAD -- Formula/skhd-zig.rb
# unregister post_install auto-registration (MUST use --uninstall-service, not launchctl bootout — bootout is session-only, SMAppService re-registers on next login):
skhd --uninstall-service
```
skhd is started by yabairc (`yabairc:75`: bare `skhd` call) and inherits env from yabai which sources `$HOME/.profile`.

**Brewfile:** `brew "jackielii/tap/skhd-zig", pin: true` — prevents `brew bundle` from upgrading.

**Watch out on next skhd-zig upgrade:** `brew install` post_install ALWAYS runs `--start-service`. Always run `skhd --uninstall-service` after any install/upgrade. If `pgrep -P 1 skhd` returns a PID, service re-registered.

---

## yabai binary re-sign wipes accessibility permission (2026-05-11)

**Symptom:** After `codesign -fs "yabai-cert" $(which yabai)`, yabai logs `could not access accessibility features! abort..` and stops managing windows.

**Cause:** macOS ties accessibility grants to binary signature. Re-signing = new identity = permission revoked.

**Fix sequence after any re-sign:**
1. System Settings → Privacy & Security → Accessibility → remove yabai → re-add
2. Restart yabai (launchctl unload/load)

---

## sudoers hash must be updated after every yabai binary change (2026-05-11)

**Symptom:** `sudo yabai --load-sa` in yabairc logs `sudo: password required` → SA never loads → space moves, layout changes don't work.

**Cause:** sudoers uses `sha256:` hash to allow NOPASSWD. Any binary replacement (upgrade, re-sign, manual copy) changes the hash.

**Fix:**
```bash
shasum -a 256 $(which yabai) | cut -d" " -f1
sudo visudo -f /private/etc/sudoers.d/yabai
# update hash in: nickyasnohorodskyi ALL = (root) NOPASSWD: sha256:<hash> /opt/homebrew/bin/yabai --load-sa
```
