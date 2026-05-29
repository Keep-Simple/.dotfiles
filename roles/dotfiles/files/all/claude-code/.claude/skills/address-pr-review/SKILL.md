---
name: address-pr-review
description: Fetch GitHub PR review comments, store progress in a tracking file, then walk through each issue one-by-one with the user, reply to GitHub when confirmed done. Use when user says "address PR review", "address review comments", "go through PR feedback", or /address-pr-review.
---

# Address PR Review Comments

**Goal:** Systematically work through every PR review comment with the user, track progress in a file, and post GitHub replies when each issue is resolved.

**Your Role:** Fetch comments, build a tracking file, present issues one at a time. On "address": autonomously fix the issue using available tools and agents, confirm the GitHub reply with the user, then ask about committing. On "won't do" or "skip": no fix attempted.

---

## Step 1 — Identify PR

Try to detect the PR from the current branch:

```bash
gh pr view --json number,url,headRefName,title 2>/dev/null
```

If that returns nothing, ask the user for a PR number. Store as `$PR_NUMBER`.

Ask: `Include bot comments? (y)es / (n)o  [default: n]  (snyk-io high/critical findings always included regardless)` — store as `$INCLUDE_BOTS`.

Ask: `Fix mode? (i)nline / (b)atch  [default: i]` — store as `$FIX_MODE`.
- **(i)nline** — fix each issue immediately when you pick "address", then reply and optionally commit before moving on
- **(b)atch** — triage all comments first (address/won't-do/skip) posting replies as you go, then fix all `[x]` items together at the end via coder agent in a fresh context

---

## Step 2 — Fetch Comments

Fetch all three comment types and thread resolution status in parallel:

```bash
# Inline review comments (on specific lines) — ALL including replies
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments \
  --paginate \
  --jq '[.[] | {
    id: .id,
    node_id: .node_id,
    type: "inline",
    author: .user.login,
    is_bot: (.user.type == "Bot"),
    body: .body,
    path: .path,
    line: (.line // .original_line),
    url: .html_url,
    created_at: .created_at,
    in_reply_to_id: .in_reply_to_id
  }]'

# General PR-level review comments
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/reviews \
  --paginate \
  --jq '[.[] | select(.body != "" and .body != null) | {
    id: .id,
    node_id: .node_id,
    type: "review",
    author: .user.login,
    is_bot: (.user.type == "Bot"),
    body: .body,
    state: .state,
    url: .html_url,
    created_at: .submitted_at
  }]'

# Issue-style PR comments (general conversation)
gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments \
  --paginate \
  --jq '[.[] | {
    id: .id,
    node_id: .node_id,
    type: "issue_comment",
    author: .user.login,
    is_bot: (.user.type == "Bot"),
    body: .body,
    url: .html_url,
    created_at: .created_at
  }]'

# Thread resolution status (GraphQL — paginate until all threads fetched)
# Run with cursor="" initially; repeat with cursor set to endCursor until hasNextPage is false.
# Accumulate all resolved comment IDs across pages.
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100, after: $cursor) {
          pageInfo { hasNextPage endCursor }
          nodes {
            isResolved
            comments(first: 100) {
              nodes { databaseId }
            }
          }
        }
      }
    }
  }
' -f owner={owner} -f repo={repo} -F number=$PR_NUMBER -f cursor="" \
  --jq '{
    hasNextPage: .data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage,
    endCursor:   .data.repository.pullRequest.reviewThreads.pageInfo.endCursor,
    resolvedIds: [.data.repository.pullRequest.reviewThreads.nodes[]
                  | select(.isResolved)
                  | .comments.nodes[].databaseId]
  }'
# If hasNextPage is true, re-run with -f cursor="<endCursor>" and merge resolvedIds until hasNextPage is false.
```

To get `{owner}` and `{repo}`:
```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

**Resolved thread filter:** Build the full set of comment IDs that belong to resolved threads (where `isResolved: true`) by paginating through all `reviewThreads` pages. Before building the tracking file, drop any inline comment whose `id` appears in that set. Threads where `isResolved: false` (including outdated threads) are kept — outdated means the diff changed, not that the issue was addressed. The `id` field from the REST API equals the `databaseId` field from GraphQL — this is the cross-API join key.

**Time filter:** If the user specified a time range (e.g. "since yesterday", "last 2 days"), filter by `created_at`. Otherwise include all comments.

**Thread grouping:** For inline comments, group replies under their root comment using `in_reply_to_id`. Root comments have no `in_reply_to_id`. Each root comment carries its full reply chain as context. If a root comment is filtered out (resolved thread), also drop all its replies.

**Bot filter — apply after Step 3 assigns severity:** Classify all comments first (Step 3), then apply this filter:
- If `$INCLUDE_BOTS` is `n`, exclude any comment where `is_bot: true`, **except** `snyk-io` comments whose assigned severity is `blocking` — those must always be included.
- **`snyk-pr-review-bot`**: follows the normal `$INCLUDE_BOTS` decision — no special treatment.

**Exclude from root issue list:**
- Nothing. Include all comments, including your own. Your own comments may be questions you asked or context you added — they are still part of the review.

---

## Step 3 — Detect Severity

All keyword matching is **case-insensitive**. For each comment, assign severity in priority order (first match wins):

- **blocking** — body contains any of: `blocking`, `must`, `required`, `lgtm pending`, `changes requested`, `[h]`, `[high]`, `h:`; or review `state == "CHANGES_REQUESTED"`; or the comment author is `snyk-io` and the body contains any of: `critical`, `high severity`, `severity: high`, `severity: critical`, `[critical]`, `[high]`. (`snyk-io` high/critical is always blocking — this is the single definition; the bot filter in Step 2 references this result.)
- **suggestion** — body contains any of: `[m]`, `[medium]`, `m:`, `should`, `suggest`, `consider`, `recommend`
- **nit** — body contains any of: `[l]`, `[low]`, `l:`, `nit`, `minor`, `style`, `optional`, `nitpick`
- **question** — body contains `?` and none of the above keywords
- **info** — everything else (bot summaries, coverage reports, etc.)

If a `snyk-io` comment is found but none of the snyk-io blocking keywords match (e.g. severity is medium or low), warn the user: "snyk-io comment #$ID did not match high/critical keywords — classified as `$SEVERITY`. Verify manually."

Order for the session: **blocking → suggestion → nit → question → info**

Within each severity group: file-by-file for inline comments, then general comments.

---

## Step 4 — Build Tracking File

Create `.pr-review-$PR_NUMBER.md` in the project root (the directory containing `.git/`; fall back to cwd if none found).

> **Note:** The first write to this file may trigger an approval prompt depending on the IDE/tool. Approve it once — subsequent edits in the session will not prompt again.

```markdown
# PR #$PR_NUMBER Review Tracker
<!-- Generated by address-pr-review skill -->
<!-- PR: $PR_URL -->
<!-- Fetched: $TIMESTAMP -->
<!-- Total: $TOTAL_COUNT comments -->

## Progress: 0 / $TOTAL_COUNT done

---

## Blocking ($BLOCKING_COUNT)

### [ ] Comment #$ID — @$AUTHOR — $SEVERITY
**File:** `$PATH:$LINE` *(omit if not inline)*  
**Link:** $URL  
**Body:**
> $BODY

**Thread replies:** *(omit section if no replies)*
> @$REPLY_AUTHOR: $REPLY_BODY
> @$REPLY_AUTHOR2: $REPLY_BODY2

---

## Suggestions ($SUGGESTION_COUNT)

...

## Nits ($NIT_COUNT)

...

## Questions ($QUESTION_COUNT)

...

## Info / Bot ($INFO_COUNT)

...
```

Each comment block uses:
- `### [ ]` — pending
- `### [>]` — queued to fix (batch mode only: triaged as "address", fix not yet implemented)
- `### [x]` — fixed (implementation done)
- `### [~]` — won't do / skipped permanently

Tell the user the file location and total counts before starting the session.

---

## Step 5 — Review Session Loop

Maintain running counts throughout the session: `$DONE` (count of `[x]`), `$QUEUED` (count of `[>]`), `$WONT` (count of `[~]`), `$SKIPPED` (count of skipped `[ ]`), `$REMAINING` (count of pending `[ ]`).

Work through comments in severity order. For each pending (`[ ]`) comment:

### Present the comment

Show:
```
─────────────────────────────────────────
Done: $DONE  Queued: $QUEUED  Won't do: $WONT  Skipped: $SKIPPED  Remaining: $REMAINING

[$SEVERITY] #$ID — @$AUTHOR  (append [bot] if is_bot)
$PATH:$LINE  (omit if not inline)
$URL

$BODY

  ↳ @$REPLY_AUTHOR: $REPLY_BODY    ← include all replies in chronological order
  ↳ @$REPLY_AUTHOR2: $REPLY_BODY2  ← omit this block entirely if no replies
─────────────────────────────────────────
```

### Ask the user

```
Your call? (a)ddress / (w)on't do / (s)kip
```

- **(a)ddress** — fix the issue, offer reply, mark done
- **(w)on't do** — offer reply explaining why, mark declined
- **(s)kip** — come back later, no reply

Accept single letters (`a`, `w`, `s`) or full words. Wait for the user's response. Do not proceed until they answer.

### Posting a reply (shared logic for "address" and "won't do")

Suggest a reply based on context, then show:
```
Reply: "$SUGGESTED_TEXT" — (y)es / (n)o / (e)dit
```
- **(y)es** — post as-is
- **(n)o** — skip reply
- **(e)dit** — user types their own text, then post

Accept single letters (`y`, `n`, `e`) or full words. Before posting, check whether a reply from this account already exists on the thread; if so, skip posting and proceed to mark done.

Post via:
- **Inline comments** — reply to the thread:
  ```bash
  gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments \
    --method POST \
    --field body="$REPLY_TEXT" \
    --field in_reply_to=$COMMENT_ID
  ```
- **Review-level comments** — post a PR issue comment:
  ```bash
  gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments \
    --method POST \
    --field body="Re: $URL\n\n$REPLY_TEXT"
  ```
- **Issue comments** — reply in the same thread:
  ```bash
  gh api repos/{owner}/{repo}/issues/$PR_NUMBER/comments \
    --method POST \
    --field body="$REPLY_TEXT"
  ```

### On "address"

**If `$FIX_MODE=i` (inline):**

1. **Fix the issue immediately** — use available tools and agents to implement the fix. If the comment references a specific file:line, edit it. If research is needed first (e.g. clarify intent, find related code), do it before editing. Do not ask the user to do the fix.
2. Offer reply (see above). Suggested reply: brief description of what was done.
3. Ask: `Commit the fix? (y)es / (n)o` — if yes, suggest a commit message, ask which files to stage, then commit. Never `git add .` blindly.
4. Mark `[ ]` → `[x]` in the tracking file. Save immediately.
5. Move to next comment.

**If `$FIX_MODE=b` (batch):**

1. Mark `[ ]` → `[>]` in the tracking file. Save immediately.
2. Move to next comment. No reply posted yet — fixes and replies happen at session end.

### On "won't do"

1. Offer reply (see above). Suggested reply: brief explanation of why it won't be addressed.
2. Mark `[ ]` → `[~]` in the tracking file. Save immediately.
3. Move to next comment.

### On "skip"

Leave `[ ]` as-is. No reply. Save tracking file. Move to next comment.

---

## Step 6 — Session End

When all comments are processed (no more `[ ]` items), print summary:
```
All done.
Done: X  |  Queued: Q  |  Won't do: W  |  Skipped: Y

Tracking file: .pr-review-$PR_NUMBER.md
```
If `$SKIPPED > 0`, also print: `Resume skipped items: /address-pr-review`

**If `$FIX_MODE=b` and `$QUEUED > 0`:** work through all `[>]` items in order:

For each `[>]` item:
1. Implement the fix using available tools. Use the severity, author, file:line, and comment body as context.
2. If fix fails → stop immediately. Report which item failed and why. Leave it as `[>]`. Do not proceed to remaining items.
3. If fix succeeds → mark `[>]` → `[x]`. Save tracking file.
4. Compose a reply describing what was actually done. Show: `Reply: "$SUGGESTED_TEXT" — (y)es / (n)o / (e)dit`. Post on confirmation.

After all `[>]` items are processed (or batch stopped on failure): commit. Group related fixes into logical commits — same file or tightly coupled changes = one commit, unrelated fixes = separate commits. Never one commit per trivial line change, never one blob for everything. Suggest commit message(s) and ask which files to stage. Never `git add .` blindly.

---

## Step 7 — Resume Behavior

On activation, check if `.pr-review-$PR_NUMBER.md` already exists in the project root (or cwd fallback, matching Step 4 detection) for the detected PR:

- If yes: load it, re-run the GraphQL thread resolution query (paginated, same as Step 2) to get current resolved state. Any pending `[ ]` comment whose thread is now resolved: auto-skip it (mark `[~]`, note "resolved on GitHub since last session"). Then resume from the first remaining pending `[ ]` item. If `[>]` items exist (batch mode was mid-fix when session ended), go directly to the batch fix loop in Step 6 for those items.
- If no: run from Step 2

---

## Constraints

- **Never post a reply without user confirmation.**
- **Never mark done without user saying "address".**
- **Never PATCH (edit) an existing comment.** Always POST a new reply. Use `in_reply_to=$COMMENT_ID` for inline threads. Never call `PATCH /pulls/comments/{id}` or `PATCH /issues/comments/{id}`.
- If a `gh api` call fails, show the error, ask the user if they want to retry or continue without posting.
