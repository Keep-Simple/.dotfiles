## Problem Statement

Seven browser keyboard shortcuts stopped working in Brave.

The Shortcut Forwarding Tool provided them. It is a small companion extension to Vimium C. Vimium C's own keybindings only fire while a normal web page has focus. The Shortcut Forwarding Tool registers browser-level commands that fire anywhere, including `brave://` pages, the new tab page, a PDF, and the address bar. It relays each one to Vimium C. The bindings currently in `vimium_c.json` are `userCustomized1` through `userCustomized7`, mapped to `removeTab`, `restoreTab`, `Vomnibar.activateTabs`, `visitPreviousTab`, `moveTabLeft`, `moveTabRight` and `moveTabToNextWindow`.

The extension is Manifest V2. Chromium 151 removed the last mechanism for running MV2 extensions, and Google deleted MV2 listings from the Chrome Web Store on 31 August 2026. Brave keeps an MV2 carve-out, but it is an allowlist of four extension IDs: AdGuard, NoScript, uBlock Origin, uMatrix. The Shortcut Forwarding Tool is not one of them.

Upstream will not fix this. `gdh1995/vimium-c-helpers` has had no code pushed since 16 July 2023. Issue #38 reports exactly this breakage and has been open and unanswered since 19 September 2025. No fork on GitHub has ported it. All twelve forks still declare `"manifest_version": 2`.

## Solution

Fork the `shortcuts` extension into its own repository and port it to Manifest V3.

The port keeps the `key` field from the original manifest, which pins the extension ID to `clnalilglegcjmlgenoppklmfppddien`. That ID is already listed in the tracked `extAllowList` in `vimium_c.json`, so Vimium C accepts messages from the ported build with no config change. Existing key bindings and the seven `userCustomized<N>` slot assignments carry over untouched.

One capability cannot survive MV3. The extension's own options page can no longer load Vimium C's `injector.js`, so Vimium C keybindings will not work while that 366-pixel settings popup has focus. Nothing else changes.

Brave loads the build through Load unpacked in developer mode. The port lives in a separate repository rather than a directory in the dotfiles repo, so it can go upstream as a pull request.

## User Stories

1. As a Brave user, I want `userCustomized1` to close the current tab again, so that I stop reaching for a shortcut that silently does nothing.
2. As a Brave user, I want all seven of my existing `userCustomized<N>` bindings to work, so that I do not have to relearn a keyboard workflow I have used for years.
3. As a Brave user, I want the shortcuts to fire on `brave://` pages and the new tab page, so that I keep the coverage that made the forwarding tool worth installing over plain Vimium C.
4. As a Brave user, I want the ported extension to keep the ID `clnalilglegcjmlgenoppklmfppddien`, so that my existing `extAllowList` keeps working and I do not have to edit Vimium C's advanced options.
5. As a Brave user, I want my saved target extension ID and keep-alive setting to survive the upgrade, so that reinstalling does not silently reset my configuration.
6. As a Brave user, I want the options page to still tell me when Vimium C is unreachable, so that I can tell a misconfigured allowlist apart from a broken extension.
7. As a Brave user, I want the options page to show me the ID to paste into Vimium C when the allowlist rejects us, so that recovery does not require reading source code.
8. As a Brave user, I want all 32 command slots to remain available, so that I can add bindings 8 through 32 later without another port.
9. As a Brave user, I want the extension to survive Brave restarts, so that I do not re-enable it every morning.
10. As a Brave user, I want the extension to survive Brave upgrades past Chromium 151, so that this is the last time I have to think about manifest versions.
11. As someone setting up a new machine, I want a documented install path, so that a fresh laptop gets working shortcuts without me reverse-engineering the setup.
12. As someone setting up a new machine, I want to know that unpacked extensions do not auto-update, so that I understand what maintenance I have signed up for.
13. As a maintainer of my own dotfiles, I want the Vimium C config and the extension it depends on to stay discoverable together, so that a future me can see why `extAllowList` contains that ID.
14. As a developer picking this up cold, I want the reason the options page lost Vimium C keybindings written down, so that I do not waste an afternoon trying to fix it.
15. As a developer picking this up cold, I want the Chromium bug reference recorded, so that I can check whether the restriction ever lifts.
16. As a developer, I want the command-to-message translation isolated as a pure function, so that I can verify the slot-renaming logic without launching a browser.
17. As a developer, I want an automated check that the manifest declares version 3, so that a bad edit fails before I discover it in Brave's extension list.
18. As a developer, I want an automated check that no `chrome-extension://` origin appears in the CSP, so that I do not reintroduce a directive Chromium strips silently at load.
19. As a developer, I want an automated check that the `key` field is unchanged, so that an accidental deletion does not silently change the extension ID and break the Vimium C allowlist.
20. As a developer, I want the check to run with plain `node` and no dependencies, so that it works on any machine without an install step.
21. As a developer, I want the dead keep-alive timer removed rather than ported, so that the next reader does not assume it does something.
22. As a developer, I want the storage migration to cover both the service worker and the options page, so that the two halves cannot disagree about which extension to forward to.
23. As a contributor, I want the fork to live in its own repository, so that the port can be offered back to `gdh1995/vimium-c-helpers` as a pull request.
24. As a contributor, I want the diff scoped to the `shortcuts` directory, so that a reviewer can see the port without wading through the other three helpers.
25. As a contributor, I want upstream's license and attribution preserved, so that the fork is redistributable.
26. As a user who has to debug this later, I want the manual acceptance steps written into the spec, so that "does it work" has a definite answer.

## Implementation Decisions

**Repository layout.** The fork lives in a new standalone repository, not in the dotfiles tree. It mirrors upstream's structure so a pull request back to `gdh1995/vimium-c-helpers` stays a readable diff. The port covers only the `shortcuts` extension and leaves the `newtab`, `pdf-viewer` and NewTab Adapter helpers alone. It keeps upstream's `LICENSE.txt` and the `author` field.

**Extension identity.** The `key` field carries over verbatim. It pins the ID to `clnalilglegcjmlgenoppklmfppddien`, derived as the first sixteen bytes of the SHA-256 of the decoded public key, nibble-mapped to `a` through `p`. That ID is already present in the tracked `extAllowList`, so Vimium C accepts the fork's messages with no user action. The port drops `update_url`, since an unpacked build has nowhere to update from.

**Background context.** `background.scripts` with `persistent: false` becomes `background.service_worker`. The `chrome.commands.onCommand` listener must register synchronously at the top level of the worker so the event can wake it.

**Configuration storage.** `localStorage` is unavailable in a service worker, so both `targetExtensionId` and `keepAliveTime` move to `chrome.storage.local`. The options page moves with them even though `localStorage` would still work there, because a split would let the two halves disagree about the forwarding target. Reads become async. The service worker reads storage per command rather than caching, which removes the need for the options page to notify it of changes at all.

**Removed background-page coupling.** `chrome.extension.getBackgroundPage()` does not exist in MV3; the options page called it twice. Both calls go away, replaced by direct storage reads. The `window.setTargetExtensionId` and `window.setKeepAliveTime` exports go with them. A service worker has no `window`, and per-command storage reads leave nothing to push.

**Removed keep-alive.** The port deletes the keep-alive block rather than converting it. `refreshTimer()` sets a `setTimeout` whose only effect is to clear its own handle. It sends no ping and no message. It existed to hold an MV2 non-persistent background page alive via a pending timer, which is meaningless for a service worker. The `keepAliveTime` option and its `<details>` block in the options page are removed.

**Removed script injection.** The port drops the `content_security_policy` key, and with it the injection branch in the options page's `testTargetExtension` callback. MV3 restricts `content_security_policy.extension_pages` `script-src` to `'self'`, `'none'` and `'wasm-unsafe-eval'`, plus localhost for unpacked builds; Chromium strips any other extension's origin at load and logs an `Ignored insecure CSP value` warning.

Vendoring Vimium C's `injector.js` locally does not work around this. `injector.js` is a loader, not the payload. It messages Vimium C for a list of script URLs and assigns each to `script.src`, and those URLs point back at Vimium C's own origin. A local copy would hit the identical CSP rejection one step later. Making it work would mean vendoring Vimium C's entire content-script bundle, which is a fork of Vimium C rather than a port of this helper, and would break on every Vimium C release.

This is tracked as Chromium issue 40813203 (formerly crbug 1282890), "An extension can not load scripts of another extension's web_accessible_resources in Manifest V3", filed by the Vimium C maintainer in December 2021 and closed as intended behavior. The maintainer's own bug report rules out the `content_security_policy.sandbox` escape hatch, because a sandboxed page has no access to `chrome.*` APIs.

**Retained message probe.** The `{handler: "id"}` probe stays. It is plain cross-extension messaging, unaffected by CSP, and it drives the recovery path that surfaces `chrome.runtime.id` for pasting into Vimium C's allowlist. Only the injection branch inside its callback is removed.

**Manifest cleanups.** The port removes `options_ui.chrome_style`, which no longer exists in MV3, and raises `minimum_chrome_version` to the first version with service worker support. The 32 `commands` entries and their `__MSG_*` locale keys are untouched.

**Message contract.** The wire format to Vimium C is unchanged: `chrome.runtime.sendMessage(targetId, { handler: "shortcut", shortcut })`, with the slot-name normalization that rewrites `userCustomized0N` to `userCustomizedN` for single-digit slots. This is what makes the port viable. MV3 supports cross-extension messaging on both sides, and Vimium C is already MV3.

**Extracted seam.** The port lifts the command-to-message translation out of the listener into a pure function, so a test can call it without a browser:

```
toMessage(command, config) -> { id, msg }
  id  = config.targetExtensionId || VIMIUM_C_ID
  msg = { handler: "shortcut", shortcut: normalizeSlot(command) }

normalizeSlot("userCustomized01") -> "userCustomized1"
normalizeSlot("userCustomized10") -> "userCustomized10"
```

The listener becomes a thin wrapper: read storage, call `toMessage`, send.

## Testing Decisions

A good test here asserts on what leaves the extension and what Chromium reads on load. It does not assert on how configuration reaches the sender, which storage key holds it, or how the options page is wired. Those are free to change. The two observable things are the message a command produces and the manifest contract Chromium enforces.

**One seam, one file.** A single `test.mjs` run by `node test.mjs`, no dependencies and no framework, covering two groups:

*Translation.* Exercise `toMessage` directly. Single-digit slots normalize (`userCustomized01` to `userCustomized1`); double-digit slots pass through unchanged (`userCustomized10`); a non-slot command name passes through unchanged; an empty or missing `targetExtensionId` falls back to the Vimium C ID; a configured target overrides the fallback. The `handler` is always the literal `"shortcut"`.

*Manifest invariants.* Parse `manifest.json` and assert `manifest_version === 3`; `background.service_worker` present and `background.scripts` absent; no `chrome-extension://` substring anywhere in the serialized manifest; `commands` has 32 entries; `key` equals the expected value, which is the check that guards the extension ID and therefore the Vimium C allowlist.

The manifest group is the higher-value half. It catches the exact class of regression that Chromium reports as a load-time warning rather than an error, which is otherwise invisible until a shortcut mysteriously stops firing.

**Prior art.** There is none in the dotfiles repo. The only pre-commit hook is gitleaks, and no test files exist. The closest idiom is `summarize-update`, which takes an `UPDATE_DETAILS_DIR` environment override instead of using a test framework. The node self-check does the same, with plain assertions and no install step.

**Manual acceptance.** Load unpacked in Brave with developer mode on. Confirm the extension list shows ID `clnalilglegcjmlgenoppklmfppddien`. Open the options page and confirm it reports Vimium C as reachable. Assign the seven command slots in `brave://extensions/shortcuts`. Press each of the seven bindings and confirm the mapped Vimium C action fires. Repeat one of them on a `brave://` page to confirm the browser-level coverage that motivates the extension. Restart Brave and confirm the extension is still enabled and the bindings still fire.

## Out of Scope

- Restoring Vimium C keybindings inside the extension's own options page. Blocked by Chromium issue 40813203, closed as intended behavior, with no workaround short of forking Vimium C.
- The other helpers in `vimium-c-helpers`: `newtab`, the PDF viewer, and NewTab Adapter. They have the same MV2 problem and a harder version of it, since injection is their whole purpose rather than a cosmetic extra.
- Publishing to the Chrome Web Store. The build is loaded unpacked.
- Any change to Brave's four-extension MV2 carve-out, or to how `uBlock Origin` and friends are installed.
- Moving `vimium_c.json` out of the dotfiles repo, or automating its import into Vimium C.
- Automating install. Brave offers no supported way to load an unpacked extension from the command line, and `ExtensionInstallForcelist` needs a hosted CRX.
- Opening the upstream pull request. The separate repository makes it possible; whether to file it is a later call.

## Further Notes

I derived the extension ID rather than looking it up. Base64-decode the `key` field, SHA-256 it, take the first sixteen bytes, and map each nibble to `a` through `p`. The result, `clnalilglegcjmlgenoppklmfppddien`, is the fourth entry in the tracked `extAllowList`, which confirms the identity without needing the Web Store listing.

The cross-extension message contract has been stable across many Vimium C releases and is documented behavior on Vimium C's side, so version drift against Vimium C is a low risk. This is the main reason the messaging half of the extension ports cleanly while the injection half does not. Messaging is a published contract. Injection only ever worked because MV2's CSP was permissive.

Unpacked extensions do not auto-update. Brave may also show a developer-mode warning on launch. Both are accepted costs.

Upstream context, should anyone want to revive it: `gdh1995/vimium-c-helpers` had its last code push on 16 July 2023, has 19 open issues, and is not archived. Issue #38 is this exact breakage. Of the twelve forks, only two have commits beyond upstream, a Slovak translation and an unrelated new-tab background image. Neither touches the manifest version.
