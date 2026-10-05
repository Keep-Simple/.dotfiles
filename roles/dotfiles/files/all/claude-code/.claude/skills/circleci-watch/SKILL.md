---
name: circleci-watch
description: Watch a CircleCI workflow via the CircleCI MCP until green; reruns proven infra or flaky failures, rebases the PR when it conflicts or falls behind, stops and diagnoses anything else. Use when asked to watch or babysit CI, a CircleCI workflow, run, or branch.
---

# CircleCI watch

One invocation is one **tick**: read state, act, schedule the next tick. `/loop` carries the ticks; the conversation carries the watch state.

## Authority

Invoking this skill authorizes, on the watched lineage and its PR branch only:
- `rerun_workflow` with `from_failed: true`, at most 5 times per commit.
- Rebasing the PR branch onto its base and force-pushing it with lease.
- `cancel_workflow` on the workflow that push makes obsolete.

Every other CircleCI write stays with the user: any other cancel, approving a hold, triggering a pipeline, a full rerun, or touching another lineage.

## First tick

Watch state for this lineage already in context: skip to Tick.

1. Resolve the target to a run and a workflow:
   - Workflow UUID or CircleCI URL: take the UUID after `/workflows/` or from `workflowId=`. `get_workflow` gives its run.
   - Run UUID: `list_run_workflows`. Several workflows and none named: ask.
   - Nothing given: project `gh/<org>/<repo>` from `git remote get-url origin`, branch from `git branch --show-current`, then `list_runs {project, branch, limit: 1}`.
2. Print the watch state as a short block; every later tick reprints it when it changes:
   `project · branch · PR · run · workflow name · current workflow id · lineage · reruns used · deadline (absolute, now + 6h) · classified job ids · PR checked at`
3. Inside `/loop`: run Tick now. Outside: invoke the `loop` skill with no interval and args `/circleci-watch <workflow-id>`.

## Tick

1. Watch state holds `awaiting <sha>`: `list_runs {project, branch, limit: 1}`. Its revision is a prefix of `<sha>`: make it the watched run, take its workflow with the watched name, clear `awaiting`. Otherwise schedule.
2. PR check, when `PR checked at` is unset or 5 minutes old, or the workflow has ended: `gh pr view <branch> --repo <owner>/<repo> --json number,url,headRefName,headRefOid,baseRefName,mergeable,mergeStateStatus`.
   - `mergeable: CONFLICTING` or `mergeStateStatus: DIRTY` is a conflict, `BEHIND` is behind. Either one: follow [REBASE.md](REBASE.md) in place of the rest of this tick.
   - `UNKNOWN`: GitHub is still computing; check next tick.
   - No PR for the branch: skip PR checks for the rest of the watch.
3. `list_run_workflows {run}`. The newest workflow carrying the watched name is current, whoever reran it. Its `current_outcome` reads `failed` while other jobs still run.
4. Act on its state:

| State | Action |
|---|---|
| running, nothing failed | schedule |
| running, `current_outcome: failed` | classify new failures. Any stop-class: Stop. Every failed job retryable: schedule, and rerun once the workflow ends |
| on hold | Stop: an approval needs a human |
| ended `succeeded` | Stop: green |
| ended `failed` | classify new failures. Every failed job retryable and reruns used < 5: `rerun_workflow {workflow, from_failed: true}`, append the new id to lineage, schedule. Otherwise Stop |
| ended `canceled` | `list_runs {project, branch, limit: 1}`. A run newer than the watched one: follow its workflow with the watched name, reset reruns used, schedule. Otherwise Stop |
| past deadline | Stop: timeout |

5. Schedule: `ScheduleWakeup` at 60s with the same prompt, `noop: true` when nothing changed.

Waiting for the end before rerunning lets every job report and keeps running jobs alive.

## Classifying a failed job

Classify each failed job once, keyed by job id; `list_workflow_jobs` gives ids and outcomes. `not_run` and `canceled` jobs sit downstream of the real failure: skip them.

A job is retryable only with proof:
- **infra**: job outcome `infrastructure_fail`, `timedout` or `timed_out`.
- **flaky**: `list_job_tests {job}` returns failures and every message is a jest `Exceeded timeout of <n> ms for a test` or a network error (`ECONNRESET`, `ETIMEDOUT`, `EAI_AGAIN`, `socket hang up`, `TLS handshake timeout`, `connection reset by peer`, `temporary failure in name resolution`).
- **setup**: `list_job_tests` matched 0 and `get_job` shows the failed step is `spinup_environment`, `checkout` or `setup_remote_docker`.

Everything else is stop-class: one assertion among many timeouts, a lint or compile step, a failure whose output you could not read. `get_job` returns every step of every parallel execution, so reach for it only when `list_job_tests` matched 0.

## Stop

1. Inside `/loop`: `ScheduleWakeup {stop: true}`.
2. Stop-class failures: load the CircleCI MCP skill `debug-failing-run` with `get_skill` and diagnose those jobs with it.
3. Report outcome first (`CI green after 1 rerun`, `CI red: SARIF assertion in acceptance linux`), then lineage, reruns used, and the diagnosis when red.
