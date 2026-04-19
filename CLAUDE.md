
## Repo Purpose

Personal dotfiles + machine bootstrap. Ansible playbook drives full setup; GNU Stow symlinks dotfile packages into `$HOME`. Primary target: macOS (`macos` branch). Linux (Debian/Fedora) partially supported.

Bootstrap entrypoint (one-liner): `setup.sh` → installs ansible deps → clones repo to `~/.dotfiles` → runs `ansible.sh run`.

## Common Commands

All wrapped by `ansible.sh` (also installed as `~/.local/bin/my`):

```
my run                      # full local playbook (asks sudo pw via -K)
my run --tags packages      # subset by tag: setup|repo|packages|dotfiles|devenv|system
my dotfiles_link            # only stow links
my dotfiles_unlink          # unstow (sets dotfiles_state=absent)
my system_defaults          # only macOS defaults
my ansible_deps             # ansible-galaxy install -r requirements.yaml --force
my run_remote               # run on hosts in inventory[remote_servers] (-Kk)
```

Pass extra ansible args after the subcommand (e.g. `my run --check --diff -vv`, `my run --tags dotfiles --start-at-task=...`).

Brewfile mutation: shell wrapper in `roles/dotfiles/files/os_Darwin/zsh/.zshrc.d/brew.sh` overrides `brew` so `install/uninstall/tap/...` auto-`brew bundle dump` to `roles/packages/files/macos/Brewfile`. Use `brew-orphans` to find leaves not tracked, `brew-backup` / `brew-cleanup` for manual ops.

## Architecture

### Ansible role pipeline (`main.yaml`)

Roles execute in order, each tagged so subsets work via `--tags`:

1. **setup** (`tags: setup`) — OS-specific bootstrap. macOS: includes `elliotweiser.osx-command-line-tools` + `geerlingguy.mac.homebrew` (the latter `public: true` so its vars like `homebrew_brew_bin_path` are visible to later roles).
2. **repo** (`tags: repo`) — ensures `~/.dotfiles` exists (idempotent clone, `update: false`).
3. **packages** (`tags: packages`) — `os_Darwin.yaml` runs `brew bundle check`, temporarily flips `/etc/sudoers` to `NOPASSWD: ALL` around `brew bundle` (cask installs need sudo), then upgrades all formulae.
4. **dotfiles** (`tags: dotfiles`) — Stow links `stow_common_items` from `roles/dotfiles/files/all/` and `stow_items` from `roles/dotfiles/files/os_<system>/` into `$HOME`. Then `additional_setup.yaml` does: clone `tpm`, install tpm plugins, `pre-commit install`, asdf plugin add + install from `~/.tool-versions`.
5. **zsh** (`tags: devenv`) — bootstraps zinit (`zsh -ilc '@zinit-scheduler burst'`) and runs `apply-shortcuts`.
6. **nvim** (`tags: devenv`) — first headless run to bootstrap lazy.nvim plugins.
7. **system_defaults** (`tags: system`) — `all.yaml` (cross-platform: dev dirs) + `os_Darwin.yaml` (loops `macos_defaults` via `community.general.osx_defaults` + imports XML domains via `defaults import`). Notifies `Restart dock` handler.

### Stow layout

Vars `stow_common_items` (`vars/all/stow.yaml`) and `stow_items` (`vars/os_Darwin/stow.yaml`) list package directory names. Each name maps to a directory under `roles/dotfiles/files/{all,os_<system>}/<name>/` whose tree mirrors `$HOME` (e.g. `zsh/.config/...`, `bin/.local/bin/...`). Stow creates symlinks; `no_folding: true` prevents directory-level merges.

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
