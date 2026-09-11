
## Global rules (repo-specific)

Before debugging a tool that behaves oddly, read `known-issues.md`. It records diagnosed breakages with their root cause, what was ruled out, and the repro command.

Symlinked dotfiles: `~/.claude/*` and other `$HOME` configs are stow symlinks into `~/.dotfiles/roles/dotfiles/files/...`. Edit tool refuses symlinks. Resolve with `readlink -f <path>` first, then edit the real target under `~/.dotfiles/`.

## Repo Purpose

Personal dotfiles + machine bootstrap. Ansible playbook drives full setup; GNU Stow symlinks dotfile packages into `$HOME`. Primary target: macOS (`macos` branch). Linux (Debian/Fedora) partially supported.

Bootstrap entrypoint (one-liner): `setup.sh` → installs ansible deps → clones repo to `~/.dotfiles` → runs `ansible.sh run`.

`migration/` holds the machine-to-machine move, which the playbook does not
cover: the playbook restores config, `migration/` restores data. `README.md`
there is the procedure. `build-migration-zip.sh` runs on the old Mac and zips
up everything this repo deliberately does not track (live secrets, auth state,
SSH keys, `~/Documents`, the whole `~/.claude/projects` transcript store), and
the `setup.sh` inside that zip restores it on the new Mac and verifies the file
modes. Not stowed, not run by ansible. Run it before `my run`, so the SSH keys
and `~/.zshenv` are in place.

No script finishes the browser state. Each Brave profile needs its own Tab
Session Manager export and import, and its own Vimium C marks.
`migration/vimium-marks` reads those marks out of Brave's per-profile LevelDB
and prints a `chrome.storage.local.set(...)` line to paste into the profile's
service worker console. The build script dumps them to
`~/migration-manual/vimium-marks.txt`. The README covers both.

## Common Commands

All wrapped by `ansible.sh` (also installed as `~/.local/bin/my`):

```
my run                      # full local playbook (asks sudo pw unless sudo is passwordless)
my run --tags packages      # subset by tag: setup|repo|packages|dotfiles|devenv|system
my dotfiles_link            # only stow links
my dotfiles_unlink          # unstow (sets dotfiles_state=absent)
my system_defaults          # only macOS defaults
my ansible_deps             # ansible-galaxy install -r requirements.yaml --force
my run_remote               # run on hosts in inventory[remote_servers] (-Kk)
my update                   # async-parallel upgrade: brew, tpm, asdf, skills, yazi, claude, zinit, lazy, mason
```

Pass extra ansible args after the subcommand (e.g. `my run --check --diff -vv`, `my run --tags dotfiles --start-at-task=...`).

### Debugging `my update`

Per-tool logs (raw, unfiltered): `~/.cache/dotfiles-update/<tool>.log` — `brew | tpm | asdf | skills | yazi | claude | zinit | lazy | mason`. Each tool's task tee's stdout+stderr to its own log; previous run is overwritten on re-run. Output:
- `~/.cache/dotfiles-update/summary.txt` — one colored line per tool (status icon, name, delta, body).
- `~/.cache/dotfiles-update/details/<tool>.txt` — multi-line color-coded breakdown (only emitted when there's something to show: package version diffs, lazy commit logs, claude failures/marketplace warns, yazi packages). Empty file → skipped by `ansible.sh`.

Both are printed by `ansible.sh update` post-run (summary first, then `── details ──` block).

Where each tool's update runs from:
- `brew | mason` → `roles/packages/tasks/os_Darwin.yaml`, `roles/nvim/tasks/main.yaml`
- `tpm | asdf | skills | yazi | claude` → `roles/dotfiles/tasks/additional_setup.yaml`
- `zinit` → `roles/zsh/tasks/main.yaml`
- `lazy` → `roles/nvim/tasks/main.yaml`

Underlying scripts (executable, all stowed to `~/.local/bin/`):
- `mason-update` — headless nvim lua loop; uses `pkg:get_latest_version()` (registry-cached, matches mason UI's "Outdated" tab) then `pkg:install():once("closed", ...)`. Empty output ≈ registry refresh returned 0 outdated (try `:Mason` in nvim to compare).
- `skills` — `npx skills@latest update --yes -g`. Updates mattpocock/skills (and any other globally installed skills packages) in `~/.claude/skills/`. No reload needed.
- `summarize-update <tool> <delta> <OK|FAIL>` — reads log on stdin, emits one colored summary line on stdout AND writes color-coded details to `$UPDATE_DETAILS_DIR/<tool>.txt` (defaults to `~/.cache/dotfiles-update/details/`). Per-tool awk parsers dispatched by case. Tweak parser there if log format changes; override `UPDATE_DETAILS_DIR` to test against existing logs without touching the live cache.
- `tmux-reload` — `tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"` against any running server (no-op when none). Called automatically at the end of the tpm update task; also safe to invoke manually after editing `tmux.conf`.
- `yazi-update` — wraps `ya pkg upgrade`. Snapshots `package.toml` pre-run, joins the `use=/rev=` pairs from the snapshot vs the post-run file, appends `pkg-diff: <use> <old> -> <new>` lines after a `---PKG-DIFF---` separator. Required because `ya pkg upgrade` prints `Upgrading package` + `HEAD is now at` for *every* dep on every run (same checkout-chatter lie as lazy), so the raw output can't tell us what actually changed.

Common pitfalls:
- **lazy update count**: lazy headless emits `HEAD is now at <hash>` for *every* plugin every run (git checkout output, fires even when HEAD didn't move). Don't grep that line — it's misleading. The lazy task snapshots `lazy-lock.json` pre-run, jq-diffs commits post-run, appends `lock-diff: <name>` per actually-changed plugin to `lazy.log` after a `---LOCK-DIFF---` separator. Parser counts only those lines.
- **yazi exits 1 with `aborted` for `catppuccin-mocha.yazi`**: ya pkg refuses to overwrite locally-modified flavors. Either `--discard` (loses edits) or remove `~/.config/yazi/flavors/catppuccin-mocha.yazi/` and re-run `ya pkg install`. `failed_when: false` on the wait task lets the run continue; parser tags `⚠ WARN` so it surfaces in the summary.
- **yazi update count**: `ya pkg upgrade` lies the same way as lazy (always says it upgraded everything). `yazi-update` snapshots `package.toml` and appends `pkg-diff:` lines after `---PKG-DIFF---` for actually-changed revs. Parser counts only those — body shows `N packages, M updated`.
- **Whole `Wait for update jobs` aborts**: a tool's shell exited non-zero and `failed_when: false` got removed. Re-add to `main.yaml` post_tasks wait task.
- **Update task didn't run at all**: check tag wiring — task must be `tags: ['update', 'never']` so `--tags update` includes it but full `my run` skips it.
- **Adding a new tool**: (1) new async task with `register: <tool>_async`, `tags: ['update', 'never']`, tee to `{{ update_log_dir }}/<tool>.log`; (2) add `{ name: <tool>, job: "{{ <tool>_async }}" }` to wait loop in `main.yaml`; (3) add a `case` arm in `summarize-update` — the body var feeds the one-line summary, and the awk block that pipes to `"$details_file"` populates the multi-line detail block (omit the details awk if the tool has nothing worth expanding).

### Reload behavior after `my update`

Updates write fresh files to disk, but already-running processes hold the old code in memory. Per-tool:

- **brew / mason** — CLI binaries replaced on disk; next invocation gets the new binary. Long-running daemons (`brew services`) are NOT restarted automatically.
- **tpm** — task ends by invoking `tmux-reload` (sources `tmux.conf` in any running server, no-op if none). Picks up `set` changes and new or changed bindings, but NOT deletions: a binding removed or renamed in `tmux.conf` stays live in the running server until `tmux unbind -n <oldkey>` or `tmux kill-server`. Full plugin re-init (resurrect/continuum state) also needs `tmux kill-server`.
- **asdf** — only refreshes plugin registries; installed tool versions don't change, so nothing to reload.
- **skills** — skill files updated under `~/.claude/skills/`; already-running sessions pick up changes on next invocation (skills are read per-use, not cached).
- **yazi** — package files updated under `~/.config/yazi/`; running yazi instances keep old plugins until restart.
- **claude** — output literally says `Restart to apply changes`. Cannot auto-restart user-owned Claude Code sessions.
- **zinit** — plugin git repos pulled; running zsh sessions keep cached code. `exec zsh` to reload current shell, or open a new one.
- **lazy** — plugin sources updated under `~/.local/share/nvim/lazy/`; running nvim keeps cached code until restart or `:Lazy reload <plugin>`.

### Brewfile mutation

Shell wrapper in `roles/dotfiles/files/os_Darwin/zsh/.zshrc.d/brew.sh` overrides `brew` so `install/uninstall/tap/...` auto-`brew bundle dump` to `roles/packages/files/macos/Brewfile`. Use `brew-orphans` to find leaves not tracked, `brew-backup` / `brew-cleanup` for manual ops.

## CI

`.github/workflows/macos.yaml`, two jobs, on every PR and every push to
`macos`. The README badge covers both.

`lint` runs `ansible-lint` on ubuntu. Config is `.ansible-lint`; `ansible.cfg`
sets `library = library` so the vendored `stow` module resolves.

`install` runs the README one-liner on a `macos-latest` runner, piping the
script to `sh` so any prompt hits EOF and fails the build. It then asserts
stow, lazy.nvim, tpm and the asdf `uv` install landed, and that `/etc/sudoers`
has no leftover `NOPASSWD` line, runs the playbook a second time, and parses
both play recaps. The recap check is what catches `ignored` and `rescued`
tasks, which do not change the exit code. Tasks carrying `failed_when: false`
are still invisible to both, so gate those with an assertion on their effect,
the way `uv` is.

Run it without pushing: `gh workflow run macos.yaml --ref <branch>`, then
`gh run watch`.

The job rewrites the Brewfile to seven formulae and one tap, and
`.tool-versions` to one line, before `setup.sh` reads the tree, because the
runner has about 14 GB free.
The workflow's header comment lists what a green run does and does not prove.
Read it before treating green as evidence that a fresh Mac works.

## Architecture

### Ansible role pipeline (`main.yaml`)

Roles execute in order, each tagged so subsets work via `--tags`:

1. **setup** (`tags: setup`) — OS-specific bootstrap. macOS: stats `{{ homebrew_brew_bin_path }}/brew`; includes `elliotweiser.osx-command-line-tools` + `geerlingguy.mac.homebrew` only on first run (when brew binary missing). `homebrew_brew_bin_path` / `homebrew_prefix` defined in `vars/os_Darwin/homebrew.yaml` so they're available without running this role.
2. **repo** (`tags: repo`) — ensures `~/.dotfiles` exists (idempotent clone, `update: false`).
3. **packages** (`tags: packages`) — `os_Darwin.yaml` runs `brew bundle check`, temporarily flips `/etc/sudoers` to `NOPASSWD: ALL` around `brew bundle` (cask installs need sudo), then upgrades all formulae.
4. **dotfiles** (`tags: dotfiles`) — Stow links `stow_common_items` from `roles/dotfiles/files/all/` and `stow_items` from `roles/dotfiles/files/os_<system>/` into `$HOME`. Then `additional_setup.yaml` does: clone `tpm`, install tpm plugins, `pre-commit install`, asdf plugin add + install from `~/.tool-versions`.
5. **zsh** (`tags: devenv`) — bootstraps zinit (`zsh -ilc '@zinit-scheduler burst'`) and runs `apply-shortcuts`.
6. **nvim** (`tags: devenv`) — first headless run to bootstrap lazy.nvim plugins.
7. **system_defaults** (`tags: system`) — `all.yaml` (cross-platform: dev dirs) + `os_Darwin.yaml` (loops `macos_defaults` via `community.general.osx_defaults` + imports XML domains via `defaults import`). Notifies `Restart dock` handler.

### Stow layout

Vars `stow_common_items` (`vars/all/stow.yaml`) and `stow_items` (`vars/os_Darwin/stow.yaml`) list package directory names. Each name maps to a directory under `roles/dotfiles/files/{all,os_<system>}/<name>/` whose tree mirrors `$HOME` (e.g. `zsh/.config/...`, `bin/.local/bin/...`). Stow creates symlinks; `no_folding: true` prevents directory-level merges.

**Symlinks: stow only.** Never hand-create symlinks in `$HOME` (no manual `ln -s`, no editor "create symlink" actions). Every link under `$HOME` must originate from a file in `roles/dotfiles/files/{all,os_*}/<pkg>/...` and be materialized via `my dotfiles_link` (which calls stow). Adding a file to an already-stowed package still requires re-running `my dotfiles_link` — stow's `no_folding: true` means new files are NOT picked up automatically. Symptom of forgetting: the file works when invoked by its absolute path under the repo, but anything that references it via the stowed `~/.config/...` / `~/.local/bin/...` path silently fails (e.g. tmux window opens and closes immediately, or `command not found`).

The `stow` Ansible module is vendored in-repo at `library/stow` (a Python module, not a directory) — `library/*` is gitignored except `!library/stow`. It handles GNU Stow 2.3 / 2.4 conflict-message regex differences and can purge conflicting plain files when `state: present` collides.

### Vars precedence

`pre_tasks` in `main.yaml` loads `vars/all/*.yaml` then `vars/os_{{ ansible_facts['system'] }}/*.yaml` with `tags: ['always']`. `dotfiles.target` = `~/.dotfiles`, `dotfiles.repo` upstream URL.

### Adding a new dotfile package

1. Create `roles/dotfiles/files/{all|os_Darwin|os_Linux}/<pkg>/<mirror-of-$HOME>/...`.
2. Append `<pkg>` to `stow_common_items` (cross-platform) or `stow_items` (OS-specific).
3. `my dotfiles_link --tags dotfiles`.

### Adding a new macOS default

Append to `macos_defaults` in `vars/os_Darwin/os_configs.yaml` (uses `osx_defaults` keys: `domain/key/type/value`). For settings without a clean `defaults write` form, drop XML into `roles/system_defaults/files/macos/xml_settings/<filename>` and reference via `macos_defaults_xml`.

### zsh runtime

`roles/dotfiles/files/os_Darwin/zsh/.zshrc` is the entrypoint:
- Sources `~/.zshrc.d/*` early (split between `all/zsh/.zshrc.d/` and `os_Darwin/zsh/.zshrc.d/`).
- Uses zinit with deep-cached `brew shellenv` (atclone writes `brew.zsh` once; rerun via `zinit update`).
- oh-my-posh prompt cached the same way.
- Plugins loaded in `wait` turbo mode; completions deferred.

## Branches & Remote

- `macos` is the working/main branch (PRs default here per local git config).
- Remote setup uses `inventory` `[remote_servers]` group; `my run_remote` adds `-Kk -e hosts_var=remote_servers`.

## Agent skills

### Issue tracker

GitHub Issues at `Keep-Simple/.dotfiles`; external PRs are not a triage surface. See `docs/agents/issue-tracker.md`.

### Triage labels

Default canonical labels (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context layout — `CONTEXT.md` + `docs/adr/` at repo root. See `docs/agents/domain.md`.
