#!/usr/bin/env bash
# Run on the NEW machine, from inside the extracted zip dir.
# Restores the staged $HOME mirror, then fixes and verifies permissions.
set -euo pipefail

[ -d home ] || { echo "run this from inside the extracted zip (no ./home dir here)"; exit 1; }

rsync -a home/ ~/

# path<TAB>mode. Everything not listed keeps whatever rsync preserved.
PERMS='
.ssh	700
.ssh/personal_key	600
.ssh/id_ed25519	600
.ssh/allowed_signers	600
.ssh/personal_key.pub	644
.ssh/id_ed25519.pub	644
.ssh/config	644
.zshenv	600
.zsh_history	600
.npmrc	644
zscaler-ca-bundle.pem	644
.claude.json	600
.claude/RTK.md	600
.kube/config	600
.config/gh/hosts.yml	600
.config/ngrok/ngrok.yml	600
.config/ggshield/auth_config.yaml	600
.config/configstore/snyk.json	600
'

fail=0
while IFS="$(printf '\t')" read -r rel mode; do
	[ -n "$rel" ] || continue
	path="$HOME/$rel"
	[ -e "$path" ] || continue
	chmod "$mode" "$path"
	# BSD stat by absolute path: brew coreutils shadows `stat` with the GNU one,
	# whose -f means something else entirely.
	got="$(/usr/bin/stat -f '%Lp' "$path")"
	if [ "$got" != "$mode" ]; then
		echo "FAIL: $rel perm=$got want=$mode"
		fail=1
	fi
done <<EOF
$PERMS
EOF

find ~/.config/gcloud -type f -exec chmod 600 {} +

if [ "$fail" -eq 0 ]; then
	echo "PASS: all files placed with correct permissions"
else
	echo "one or more checks FAILED, see above"
	exit 1
fi
