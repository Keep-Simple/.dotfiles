# Rebase onto the PR base

Reached from a tick when the PR conflicts with its base or is behind it. Runs through to the push without waiting for the user; state each step's plan in the transcript before acting on it.

1. `git fetch origin <baseRefName> <headRefName>`, then check the checkout: `git remote get-url origin` is the PR repo, `git branch --show-current` is `headRefName`, `git status --porcelain` is empty. HEAD strictly behind `origin/<head>`: `git merge --ff-only origin/<head>`. HEAD must now equal `headRefOid`. Any failed check: Stop, naming what the user must fix.
2. Explain the plan:
   - Commits behind: `git rev-list --count origin/<head>..origin/<base>`.
   - Conflicts: `git merge-tree --write-tree --name-only --no-messages origin/<base> origin/<head>` prints a tree id, then one conflicted path per line, and exits 1 when there are any. `git show <tree>:<path>` shows each path's hunks.
   - Per conflicted path, one line: what the base changed, what the PR changed, the planned merge.
3. Record `H0 = headRefOid` and `B0 = git merge-base H0 origin/<base>`. Every Stop from here names `H0`: `git rebase --abort` mid-rebase, or `git reset --hard H0` after it, restores the branch.
4. `git rebase origin/<base>`. Resolve each conflict by intent. Stage `:2:` is the base side (git calls it ours during a rebase), `:3:` the PR commit being replayed, `:1:` their merge base. Keep both sides where compatible. Where both changed the same logic, keep the base's shape and re-apply the PR's behaviour. Update tests with the code. `git add`, then `GIT_EDITOR=true git rebase --continue`. Drop a commit only when the base already contains its effect. Explain any conflict the preview missed as you resolve it. Intent you cannot reconcile: `git rebase --abort`, Stop.
5. Conflicts resolved: build and test what they touched with the commands the repo documents (`AGENTS.md`, `CLAUDE.md`, `Makefile`). Red: Stop.
6. `git range-diff B0..H0 origin/<base>..HEAD`. Every original commit pairs with a rebased one (`=` or `!`), and every `!` is a resolution you explained. A commit left unpaired (`<`) is lost work: Stop.
7. `git push --force-with-lease=<head>:<H0> origin HEAD:<head>`. A rejected lease means someone else pushed: Stop.
8. Old workflow still running: `cancel_workflow`.
9. Record `awaiting <new HEAD sha>`, reset reruns used, and schedule the next tick.
