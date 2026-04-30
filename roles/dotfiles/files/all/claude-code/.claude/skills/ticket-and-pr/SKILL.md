---
name: ticket-and-pr
description: >
  Create a tracker ticket (Jira/Linear/etc via available MCP), a branch, a commit,
  and a PR in one verified flow. Detects project key from current branch when possible,
  respects the repo's PR template if it exists, and asks the user to confirm titles
  and descriptions before any external write.
  Trigger: "ticket and pr", "jira and pr", "open pr with ticket", "ship this with a ticket",
  or /ticket-and-pr.
---

# ticket-and-pr

## Purpose

End-to-end workflow for shipping a change with traceability:

1. Create a ticket in the project's issue tracker.
2. Create a branch named after the ticket key.
3. Commit current changes with a Conventional Commit subject + ticket key suffix.
4. Push and open a PR against the right base branch.

Designed to be repo-agnostic and tracker-agnostic — pick whatever MCP / CLI is available.

## When to use

User asks for any combination like:
- "create a jira and pr"
- "ticket + branch + pr"
- "open a PR with a ticket"
- "ship this with a ticket"

If the user only asks for a PR (no ticket), use the existing built-in PR creation flow instead.

## Procedure

Treat every external write (ticket creation, branch creation, push, PR open) as confirmable. Show drafts first, act only after the user agrees.

### 1. Resolve tracker

- Prefer an Atlassian/Jira/Linear MCP tool that is already loaded for this session.
- For Atlassian: call `getAccessibleAtlassianResources` to discover the cloudId rather than hardcoding it.
- If no tracker MCP is available and the user's request implies one, ask which tracker to use (or fall back to creating only the branch+PR and letting the user fill in the ticket).

### 2. Resolve project key

- Inspect the current branch with `git rev-parse --abbrev-ref HEAD`. If it matches `<type>/<KEY>-<NUM>_<slug>` (e.g. `refactor/IDE-1786_...`), reuse that project key (`IDE`).
- Otherwise inspect recent commits / other branches for a key prefix.
- If still ambiguous, ask the user.

### 3. Draft ticket

Generate a minimal title + description from the conversation context. Keep both short; the body should explain *what* and *why* in 2–4 sentences. Do not invent labels, components, or epic links unless the user provided them.

Show the draft to the user. Wait for explicit "yes" / corrections. Only then create the ticket and capture the returned key (e.g. `IDE-1981`).

### 4. Branch

- Default base: the current branch (so stacked work keeps its base). Ask if unsure.
- Name format: `<type>/<KEY>_<kebab-slug>` where `<type>` matches the change (`fix`, `feat`, `refactor`, `chore`, `docs`, `test`).
- `git checkout -b <branch>`.

### 5. Commit

- Follow the repo's `CLAUDE.md` rules if present (atomic commits, conventional format, hooks). Default to a single commit unless the diff splits cleanly into independent units — if it does, ask before splitting.
- Subject: Conventional Commit + ` [<KEY>]` suffix. Body: short *why*.
- Never use `--no-verify`. If a hook fails, fix the issue and create a new commit.

### 6. Push + PR

- `git push -u origin <branch>`.
- Create the PR via `gh pr create`:
  - **Base branch**: same as the branch you forked from (often not `main` — check with `git rev-parse --abbrev-ref --symbolic-full-name @{upstream}` on the parent or ask).
  - **Title**: same as the commit subject (with `[<KEY>]` suffix).
  - **Body**: if the repo has `.github/PULL_REQUEST_TEMPLATE.md` (or `.github/pull_request_template.md`, or `docs/pull_request_template.md`), let `gh` auto-populate it and only fill in the obvious slots (summary, ticket link). Do NOT impose a custom Summary/Test plan structure when a template exists. If no template exists, use a minimal `## Summary` + `## Test plan` body.
- Return the PR URL.

## Output

Final message to user, short:
- Ticket key + URL
- Branch name
- PR URL

## Notes

- All external actions are confirmable. If the user says "just do it" / "go", skip per-step confirmation but still show the final draft of the ticket before creation.
- Don't push to `main`/`master`. Don't force-push without explicit instruction.
- If the repo's `CLAUDE.md` says something different (e.g. specific PR body sections, label requirements), follow the repo over this skill.
