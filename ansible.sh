#!/usr/bin/env bash

set -euoE pipefail

cwd="$HOME/.dotfiles"

_usage() {
  printf "
Usage:
  my -h, --help
  my COMMAND [ARGS]
  [ARGS] are ansible-playbook args

COMMAND:
  run             [ARGS]   Run playbook with args on local pc
  system_defaults [ARGS]   Only apply system defaults, without running other playbook steps
  dotfiles_link   [ARGS]   Only link dotfiles, without running other playbook steps
  dotfiles_unlink [ARGS]   Only unlink dotfiles, without running other playbook steps
  update          [ARGS]   Upgrade brew, tpm, lazy/mason, zinit, asdf, bmad
  ansible_deps    [ARGS]   Install ansible dependencies for this playbook
  run_remote      [ARGS]   Run playbook with args on remote pc, using 'inventory' file
    \n"
}

_install_ansible_deps() {
  echo "⚪ [ansible] installing deps..."
  ansible-galaxy install -r $cwd/requirements.yaml --force
  echo "✅ [ansible] deps installed!"
}

# `-K` makes ansible-playbook prompt for a become password. That prompt is
# wrong on a machine where sudo needs no password, and fatal under the
# documented `curl ... | sh` install: stdin is the script, so the prompt reads
# EOF and the run dies. Ask only when sudo actually asks.
#
# `-k` is what makes this safe. Without it the probe passes on a warm sudo
# timestamp, so a `my run` started within five minutes of any other sudo would
# drop `-K`, then die twenty tasks later when the timestamp expired and become
# had no password to fall back on. With a command, `-k` ignores the cached
# credentials without clearing them, so this asks the policy, not the cache.
_become_flag() { sudo -kn true 2>/dev/null || echo -K; }

_run_playbook() {
  echo "⚪ [ansible] running playbook..."
  local playbook_opts=(
    "--inventory=$cwd/inventory"
    "$cwd/main.yaml"
  )
  playbook_opts+=($@)
  echo "parameters: ${playbook_opts[*]}"
  ANSIBLE_CONFIG="$cwd/ansible.cfg" ansible-playbook ${playbook_opts[*]}
  echo "✅ [ansible] configured!"
}

command="${1-}"
case $command in
run)
  _run_playbook $(_become_flag) "${@:2}"
  ;;
run_remote)
  _run_playbook -Kk -e hosts_var=remote_servers "${@:2}"
  ;;
dotfiles_link)
  _run_playbook --tags "dotfiles" "${@:2}"
  ;;
system_defaults)
  _run_playbook $(_become_flag) --tags "system" "${@:2}"
  ;;
dotfiles_unlink)
  _run_playbook --tags "dotfiles" -e dotfiles_state=absent "${@:2}"
  ;;
update)
  echo "⚪ [brew] upgrading ansible first, so the playbook doesn't upgrade itself mid-run..."
  brew upgrade ansible
  _run_playbook --tags "update" "${@:2}"
  cache_dir="$HOME/.cache/dotfiles-update"
  summary="$cache_dir/summary.txt"
  details_dir="$cache_dir/details"
  [ -s "$summary" ] && { echo; cat "$summary"; }
  if [ -d "$details_dir" ]; then
    has_any=0
    for f in "$details_dir"/*.txt; do
      [ -s "$f" ] && { has_any=1; break; }
    done
    if [ "$has_any" = 1 ]; then
      printf '\n\033[2m── details ──\033[0m\n'
      for f in "$details_dir"/*.txt; do
        [ -s "$f" ] || continue
        tool=$(basename "$f" .txt)
        printf '\n\033[1;36m%s\033[0m\n' "$tool"
        cat "$f"
      done
    fi
  fi
  ;;
ansible_deps)
  _install_ansible_deps
  ;;
"" | -h | --help | *)
  _usage
  ;;
esac
