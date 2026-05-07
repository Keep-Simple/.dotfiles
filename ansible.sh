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
  _run_playbook -K "${@:2}"
  ;;
run_remote)
  _run_playbook -Kk -e hosts_var=remote_servers "${@:2}"
  ;;
dotfiles_link)
  _run_playbook --tags "dotfiles" "${@:2}"
  ;;
system_defaults)
  _run_playbook -K --tags "system" "${@:2}"
  ;;
dotfiles_unlink)
  _run_playbook --tags "dotfiles" -e dotfiles_state=absent "${@:2}"
  ;;
update)
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
