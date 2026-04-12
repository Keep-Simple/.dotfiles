---
title: 'Add brew-orphans zsh function'
type: 'feature'
created: '2026-04-12'
status: 'done'
route: 'one-shot'
---

## Intent

**Problem:** No way to see which installed brew packages aren't tracked in the Brewfile, making it easy for manual installs to drift from the declarative package list.

**Approach:** Add a `brew-orphans` zsh function alongside the existing `brew` wrapper in `brew.sh` that diffs `brew leaves` / `brew list --cask` against the Brewfile using `comm`.

## Suggested Review Order

1. [`roles/dotfiles/files/os_Darwin/zsh/.zshrc.d/brew.sh:18-35`](roles/dotfiles/files/os_Darwin/zsh/.zshrc.d/brew.sh) — The new `brew-orphans` function. Uses short names (strips tap prefixes) for both sides of the formulae comparison to avoid false positives from tapped packages like `asmvik/formulae/yabai`.
