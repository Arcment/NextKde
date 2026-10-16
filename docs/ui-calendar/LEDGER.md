# R028 — D06 half-PASS: secondary is now a flat gray filled capsule; the primary's label is BLACK, not white (2026-10-16)

## 本轮 (R028)
Atomic step: 直译 the reference's *secondary* onto the footer — 浅灰填充、同款胶囊、无描边无阴影、文字居中深色.
Done; **D06 secondary half PASS**. The primary half of the same spec ID **FAILS** (see 仍差 #1) — found this
round, not fixed (build/capture budget spent).

Change (3 files, 1 shared + 2 lines of product QML):
- `shared/qml/foundation/AppTheme.qml` +L101-110 — new opt-in tokens `buttonNeutral` /
  `buttonNeutralHover` / `buttonNeutralPressed`, derived from `card` (light: `mix(card, black, 0.095)`,
  dark: `mix(card, white, 0.13)`). Second arg **must** be `Qt.rgba(...)` — `mix()` at L189 reads `second.r`.
- `shared/qml/foundation/KosButton.qml` — `property bool secondary: false` (opt-in, default false so no other
  caller changes) + in `background: KosSurface`: a `secondary` fillColor branch, and `secondary` ⇒
  `strokeWidth 0`, `elevation 0`, `showInnerHighlight false` while unhovered/unfocused ⇒ flat filled capsule.
- `apps/calendar/qml/EventEditorDialog.qml:234` — one line: `secondary: true` on the Cancel button (the only
  caller of the new flag). Save / Delete / geometry / `standardButtons` untouched.

Measured 1:1 from `r028-editor-light.png` (1100x692, relaunched, `view week` → pointer move/press/release
`target:"toolbarAdd"`, three writes ≥1.3s apart):
card renders (247,247,247); Save fill (48,140,198) x386..728 = **343px**, y585..614 = **30px**;
Cancel fill **(227,229,230)** x383..731 (Δ≤2px vs Save with AA ⇒ 等宽 ✓), y622..651 = **30px** (同高 ✓);
gap y616..620 ≈ 5-6px; insets symmetric ⇒ 通栏 ✓; primary on top ✓.
**Contrast now matches the reference**: 227/247 = 0.919 vs reference 214/232 = 0.922 (Δ 20 vs 18 units).
Cancel has no stroke and no shadow below it (y653 is card again) ⇒ it reads as a *filled* pill, not an outline.

Why the first attempt undershot (recorded so it is not re-derived): the token `AppTheme.card` is ≈ (251,253,254),
but the dialog paints `cardSurface` at 54% alpha and renders (247,247,247). A token-space 7.8% darkening
therefore rendered as only 6.1% — first capture measured the fill at (232,233,234). Setting the light amount to
**0.095** reproduces the reference's *rendered* ratio. Build `ninja -C .build/calendar-review kos-calendar`
clean; no QML errors.

## 仍差 (top 8, visual-impact order)
1. **D06 second half FAILS — the primary's label must be WHITE; it renders near-black.** Evidence from
   `r028-editor-light.png` row y599 inside the Save button: darkest glyph pixel **(11,9,31)**, and **no pixel in
   that row is lighter than the accent fill (48,140,198)**. 4x zoom confirms black 保存 on blue. Reference
   Primary = white on #007AFF. Cause: `AppTheme.qml:148-151` `accentUsesDarkText = contrastRatio(accent, black)
   >= contrastRatio(accent, white)` — for this profile's accent (48,140,198) black wins (5.70 vs 3.68), so
   `accentText = blackSeed`. Apple picks white on #007AFF even though black is nominally higher-contrast.
2. D05 dark + editing-state (3-row) capture; `buttonNeutral`'s dark branch is **unverified**.
3. Primary's drop shadow bleeds into the 6px gap: rows y616-620 read 236..241 instead of card 247 (Save carries
   `elevation 0.68` because `emphasized`). The reference's inter-button gap is clean card colour (232).
4. D07 destructive weight: Delete is still a filled red pill, co-equal with Save.
5. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow, all unmeasured.
6. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
7. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
8. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination; **`CalendarTaskEditorDialog` footer is not yet translated** to the
   stacked/filled style and still shows the old outlined secondary.

## 最近已改 (most recent 8)
1. R028 `AppTheme.qml` +L101-110, `KosButton.qml` (`secondary` + flat fill), `EventEditorDialog.qml:234`.
2. R027 `EventEditorDialog.qml:175-248` — footer → vertical full-width `ColumnLayout`, ref order Save/Cancel/Delete.
3. R026 — verification/driver round only. 4. R025 — R019 fixtures re-seeded; `date`/`view` key names. 32d60c0.
5. R024 — P01 TASK details popover verified in light, bd0070f. 6. R023 `EventDetailsPopover.qml` shadow. d9be5ef.
7. R022 — editor delete pinned into fixed footer (d8c10bf). 8. R021 aborted.

## 外推待确认 (do NOT assume)
- `buttonNeutral`'s **dark** branch (`mix(card, white, 0.13)`) is a guess: macOS dark alerts put the secondary
  *lighter* than the card too, but no dark capture was taken this round.
- `accentText` is a **shared, app-wide** token; forcing white on `emphasized` buttons would move every app's
  primary labels. Not done — see Next round for the containment proposal.
- The accent measured here is (48,140,198); `defaultAccentSeed` is #3478f6, so this profile's value is coming
  from the system palette. Which one D06 should be judged against is unresolved.
- macOS alert has no third action; our Delete row is an extrapolation of "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- `secondary` is opt-in and default false, so no other caller changed — but that also means the rest of the app
  still shows the old outlined secondary; do not read that as a regression.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.

## Next round (pick ONLY #1)
**D06 second half** — the primary's label must be white. Recommended containment (smallest blast radius, keeps
one atomic step): add an opt-in to `KosButton.qml` next to `secondary`, e.g. `property bool lightLabel: false`,
and have the contentItem resolve `emphasized ? AppTheme.accentText : ...` → when `lightLabel` is set, use
`AppTheme.whiteSeed` (or `"white"`) instead of `accentText`; then set it on the Save button in
`apps/calendar/qml/EventEditorDialog.qml:224-227`. Keep the accent fill, keep 保存 on top, keep the R027/R028
geometry (343px wide, 30px tall, ~6px gap) and the R028 flat gray Cancel — verify all of them survived.
Do NOT change the shared `accentText`/`accentUsesDarkText` rule (app-wide blast radius) — record it as an
extrapolation instead. Then capture light `r029-editor-light.png` the same way (relaunch after the edit, then
`view week` → pointer move/press/release `target:"toolbarAdd"` as **three separate writes ≥1.3s apart**), and
measure the label's lightest glyph pixel: it must be **lighter** than the fill, not darker.

## Environment (unchanged, condensed)
Loop runs ON the VM (`/home/amao/nextkde`, build `.build/calendar-review`). Launch with
`tmp/ui-acceptance/calendar/start-review-vm.sh light|dark` (detached; it refuses while an owned PID lives —
`kill $(cat live-app.pid)` then confirm with `ps | grep kos-calendar`; product QML edits require a relaunch).
`review-command.py` writes `harness/command.json` **in place** — an atomic replace trips the QML directory-watch
reload. **One command per call, ≥1.2s apart.** Screenshots: no `DISPLAY`/`XAUTHORITY`, so write
`{"action":"captureClient","path":"<abs>"}` in place and poll for the file; measure from a 1:1 Pillow read,
never the downscaled view. `pointer` needs `move` → `press` → `release` as separate writes (`kind:"click"` is a
silent no-op) and takes `target:"<objectName>"`; `toolbarAdd` at (62,50) opens the editor reliably.
`X` in the footer stack ≈ x386..730, Save y585..614, Cancel y621..651 in the 1100x692 client.
