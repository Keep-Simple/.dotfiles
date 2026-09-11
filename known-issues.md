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

## tmux root-table Alt bindings swallow terminal query replies (2026-09-11)

**Symptom:** yazi in tmux opens its find prompt pre-filled with `62;52;c`, spawns extra tabs on every launch, and image/PDF preview appears broken. Earlier the same junk landed in nvim pickers (snacks.nvim).

**Root cause:** TUIs ask kitty what it supports (DA1 `\e[?c`, XTVERSION `\eP>q`) through tmux DCS passthrough. Kitty answers on the tmux *client's* input, so tmux parses the reply as typed keys. Key lookup runs first, and `\e` + char is exactly how tmux encodes a Meta key, so the reply's ESC prefix matches a root-table (`bind-key -n`) binding. tmux consumes the prefix and forwards the remaining bytes to the focused pane as keystrokes:

| Reply | Bytes | Matched | Leftover typed into the pane |
|---|---|---|---|
| DA1 | `\e[?62;52;c` | `M-[` | `?62;52;c` — `?` opens yazi find-previous, rest fills it |
| XTVERSION | `\eP>\|kitty(0.48.2)\e\\` | `M-P` | `>\|kitty(0.48.2)` — two `t` open two tabs, `y` yanks |

Gating a binding with `if-shell` blocks the command, not the consumption: tmux consumes at key-match time, before the binding runs. Only an unbound key leaves the sequence intact for the pane.

**Fix:** never bind an escape-sequence introducer in the root table. `M-[` (CSI), `M-]` (OSC), `M-P` (DCS), `M-O` (SS3), and for the same reason `M-\` (ST), `M-^` (PM), `M-_` (APC), `M-X` (SOS). Prefix-table bindings are safe, only `-n` intercepts. Commit a2cf2d5 moved prompt navigation to `M-U`/`M-D` (my prompts) and `M-u`/`M-d` (Claude's `⏺ ` replies), and `gh pr view --web` to `M-o`.

**Ruled out by test:** `escape-time` (leak identical at 0 and 10), `extended-keys always` (changes how kitty encodes *your* keystrokes, not how tmux parses a reply), yazi's `[tasks] image_alloc`/`image_bound`.

**Repro:** run yazi in a focused tmux window, then `tmux capture-pane -p -t <win> | head -3`. A leak shows the find prompt in line 1 and a tab bar in line 2. Bisect by unbinding one suspect key at a time with `tmux unbind -n 'M-['`.

**Gotcha:** `tmux source-file` does not remove bindings deleted from the config. After renaming or dropping a binding, run `tmux unbind -n <oldkey>` against the running server (or `tmux kill-server`), otherwise the old key stays live and the bug persists after a reload.

## asdf-rust installs `.default-cargo-crates` only at rust-install time (2026-09-11)

**Symptom:** on a freshly bootstrapped laptop, `recon` is missing, so tmux `M-I` (`display-popup -E ... recon`) opens and closes instantly. `M-i` still works, since `recon-jump.sh` is pure shell and needs no binary.

**Root cause:** the asdf-rust plugin runs `install_default_cargo_crates` inside `bin/install`, so `$HOME/.default-cargo-crates` is read only while `asdf install rust <ver>` runs. A crate added to that file after rust was installed never gets picked up, and a crate whose build failed on the first bootstrap is never retried (`asdf install` skips an already-installed version). The playbook's own ordering is fine: stow runs before `asdf install`.

**Fix:** the `Install default cargo crates` task in `roles/dotfiles/tasks/additional_setup.yaml` runs after `asdf install` and installs whatever is still missing. `cargo install` prints "Ignored ... is already installed" and exits 0 when there is nothing to do, so the task is idempotent and reports changed only when stdout contains "Installing".

**Manual equivalent**, if you add a crate and don't want a full provision run:

```bash
R=~/.asdf/installs/rust/$(awk '$1=="rust"{print $2}' ~/.tool-versions)
CARGO_HOME=$R RUSTUP_HOME=$R PATH="$R/bin:$PATH" cargo install --git https://github.com/gavraz/recon --locked
asdf reshim rust
```

Both `CARGO_HOME` and `RUSTUP_HOME` matter. asdf-rust keeps the toolchain inside the install dir, so a bare `cargo install` reaches for `~/.rustup`, finds no default toolchain, and fails with "rustup could not choose a version of cargo to run".
