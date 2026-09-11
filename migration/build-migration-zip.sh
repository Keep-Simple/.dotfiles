#!/usr/bin/env bash
# Run on the OLD machine. Produces ~/migration-<date>.zip with everything the
# dotfiles repo does NOT track: live secrets, auth state, SSH keys, Documents.
# Stage mirrors $HOME so setup.sh is a single rsync plus a permission pass.
set -euo pipefail

JUNK_EXCLUDES=(node_modules .venv venv __pycache__ dist build target .gradle .next .terraform vendor .DS_Store)

STAGE="$(mktemp -d "${TMPDIR:-/tmp}/migration-build.XXXXXX")"
H="$STAGE/home"
mkdir -p "$H"/{.ssh,.claude,.docker,.kube,.config/gh,.config/ngrok,.config/ggshield,.config/configstore}

# Single files. Missing ones are skipped rather than aborting the build.
copy() { [ -e "$1" ] && cp -p "$1" "$2" || echo "skip (absent): $1"; }

copy ~/.zshenv                              "$H/.zshenv"
copy ~/.zsh_history                         "$H/.zsh_history"
copy ~/.npmrc                               "$H/.npmrc"
# Repo-tracked work.sh, .gitconfig and .npmrc all hardcode this path; TLS in
# curl/git/npm/node hard-errors if it is missing.
copy ~/zscaler-ca-bundle.pem                "$H/zscaler-ca-bundle.pem"
copy ~/.claude.json                         "$H/.claude.json"
copy ~/.claude/history.jsonl                "$H/.claude/history.jsonl"
copy ~/.claude/RTK.md                       "$H/.claude/RTK.md"
copy ~/.claude/settings.local.json          "$H/.claude/settings.local.json"
copy ~/.docker/config.json                  "$H/.docker/config.json"
copy ~/.kube/config                         "$H/.kube/config"
copy ~/.config/gh/hosts.yml                 "$H/.config/gh/hosts.yml"
copy ~/.config/ngrok/ngrok.yml              "$H/.config/ngrok/ngrok.yml"
copy ~/.config/ggshield/auth_config.yaml    "$H/.config/ggshield/auth_config.yaml"
copy ~/.config/configstore/snyk.json        "$H/.config/configstore/snyk.json"

cp -p ~/.ssh/personal_key ~/.ssh/personal_key.pub ~/.ssh/id_ed25519 \
      ~/.ssh/id_ed25519.pub ~/.ssh/allowed_signers ~/.ssh/config "$H/.ssh/"

# gcloud: virtenv is an 83M regenerable Python venv, logs are noise.
rsync -a --exclude virtenv --exclude logs ~/.config/gcloud/ "$H/.config/gcloud/"

# Whole transcript store, not just memory/: 259M raw, ~81M once deflated, and
# none of it is regenerable. Directory names encode absolute repo paths, so
# these only reattach to /resume when the new Mac keeps the same $HOME.
# `claude-transcripts` (stowed to ~/.local/bin) does the same job standalone.
rsync -a ~/.claude/projects/ "$H/.claude/projects/"

# Vimium C marks sit in Brave's per-profile LevelDB. No export covers them and
# Brave Sync skips extension storage, so dump paste-ready snippets instead.
mkdir -p "$H/migration-manual"
if "$(dirname "$0")/vimium-marks" > "$H/migration-manual/vimium-marks.txt"; then
	echo "dumped Vimium C marks"
else
	echo "skip: vimium-marks found no Brave profile with Vimium C"
	rm -f "$H/migration-manual/vimium-marks.txt"
fi

RSYNC_EXCLUDES=(--exclude 'personal/projects/openclaw-backups')
for d in "${JUNK_EXCLUDES[@]}"; do RSYNC_EXCLUDES+=(--exclude "$d"); done
rsync -a "${RSYNC_EXCLUDES[@]}" ~/Documents/ "$H/Documents/"

cp "$(dirname "$0")/setup.sh" "$STAGE/setup.sh"
cp "$(dirname "$0")/README.md" "$STAGE/README.md"
chmod +x "$STAGE/setup.sh"

OUT=~/migration-"$(date +%Y%m%d)".zip
(cd "$STAGE" && zip -ry "$OUT" . >/dev/null)
rm -rf "$STAGE"

echo
echo "Built $OUT ($(du -h "$OUT" | cut -f1))"
echo "Contains live secrets (SNYK_TOKEN, GITHUB_PRIVATE_TOKEN, LITELLM_MASTER_KEY, gcloud + gh tokens)."
echo "Transfer via AirDrop/USB only, never email/Slack/cloud upload. Delete after transfer."
echo
echo "Before wiping this Mac, do the browser steps README.md lists under"
echo "'Manual steps': export Tab Session Manager sessions in each Brave profile."
