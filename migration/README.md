# Migrating to a new Mac

The ansible playbook rebuilds config. It installs packages, links dotfiles,
applies macOS defaults, and sets up the shell and editor. It restores no data.
Everything here covers the data: secrets, auth state, SSH keys, `~/Documents`,
Claude Code transcripts, and browser state. This repo is public, so it tracks
none of that.

A script handles most of the move. The rest happens inside a browser, where
only you can do it.

## Order of operations

On the old Mac:

1. Do the [manual steps](#manual-steps) below. You cannot do the browser ones
   after you wipe the machine.
2. Run `migration/build-migration-zip.sh`. It writes `~/migration-<date>.zip`.
3. AirDrop or USB the zip across. Not email, not Slack, not cloud storage. It
   holds live tokens and private keys.

On the new Mac:

4. Unzip it, `cd` into it, and run `./setup.sh`. It copies the staged `$HOME`
   into place and checks the file modes.
5. Run the bootstrap one-liner from the root README. It clones this repo and
   runs the playbook.
6. Finish the manual steps, restoring what you exported in step 1.

Run step 4 before step 5. The playbook needs `~/.ssh` and `~/.zshenv` already
in place.

## What the zip carries

Read `build-migration-zip.sh` rather than trusting this list to stay current.
It copies SSH keys and `allowed_signers`, `~/.zshenv` and shell history, the
gcloud, gh, kube, docker, ngrok, ggshield and snyk auth files, the Zscaler CA
bundle, `~/Documents` without build junk, and the whole Claude Code transcript
store (`~/.claude/projects`, about 81M compressed) with `history.jsonl`.

`claude-transcripts`, stowed to `~/.local/bin`, backs up and restores that
transcript store on its own when you want it without a full move.

## Manual steps

### Open and pinned tabs in Brave

No profile file copies cleanly. The session files are SNSS binaries that need
both copies of Brave quit and both versions matched. Brave Sync lists another
device's tabs without restoring them.

Use [Tab Session Manager][tsm] instead. Its restore path sets
`pinned: tab.pinned`, and it rebuilds tab groups when `saveTabGroupsV2` is on.

On the old Mac, before you wipe it, install the extension in each profile and
export from Settings, then Sessions, then Export. On the new Mac, install it in
each profile and import the file.

Do this per profile. Extensions and their storage do not cross profile
boundaries.

### Bookmarks in Brave

Start a sync chain at `brave://settings/braveSync` in each profile. Or open the
bookmarks manager, export to HTML, and import on the other side.

### Vimium C marks

Marks live in Vimium C's own `chrome.storage.local`. Its Backup exports
settings only, Brave Sync skips extension storage, and extension isolation
stops any other extension from reading them.

`build-migration-zip.sh` runs `vimium-marks` and writes the output to
`~/migration-manual/vimium-marks.txt` on the new Mac. To restore one profile,
open a window of that profile, go to `brave://extensions`, open Vimium C's
service worker console, and paste that profile's `chrome.storage.local.set(...)`
line.

Run `vimium-marks` by hand any time to print the marks and the snippets. It
walks every Brave profile, reads the LevelDB records directly, and covers
global marks and the local per-URL ones. Pass `--snippet <profile>` to print
one profile's line alone, which pipes into `pbcopy`.

### gh

The tokens sit in the macOS keychain, not in a file, so there is nothing to
copy. Run `gh auth login` once per account, then `gh auth switch -u Keep-Simple`.

The zip includes `~/.config/gh/hosts.yml`, which lists the accounts and
`git_protocol` but holds no tokens.

[tsm]: https://chromewebstore.google.com/detail/tab-session-manager/iaiomicjabeggjcfkbimgmglanimpnae
