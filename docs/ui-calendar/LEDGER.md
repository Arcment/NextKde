# R032 — editing-state (3-row) footer captured in light; the recorded D07 premise was WRONG (2026-10-16)

## 本轮 (R032)
Atomic step: **capture + judge the editing-state 3-row footer in light** (was 仍差 #1). No code change —
measurement round, same shape as R030. Artifacts: `r032-popover-light.png`, `r032-editor-edit-light.png`
(both 1100x692), `_r032-footer3x.png` (3x footer crop).

Route (new, works, and is the *only* way into `root.editing`):
`date 2026-04-02` → `view day` → `openItem` (details popover: `Main.qml:1309` → `itemDetails.showItem`) →
**raw-coordinate** click at (678,440) (`detailsEdit`) → `captureClient`.
Gotcha: `{"action":"pointer","target":"detailsEdit"}` silently no-ops — the driver resolves targets with
`objectNamed(contentItem)`, and the popover is a `Popup`, not a child of `contentItem`; the log said
`pointer move detailsEdit NaN NaN hover n/a` and the click was dropped. Use `x`/`y`.

Judgment (measured with Pillow, light, editing):
1. **R031 holds in the editing state.** Save fill (48,140,198) x384..730, AA at 383/731; y579 → back to
   card (247,247,247) with no rim and no halo. Same for Cancel: (227,229,230) x384..730, flat.
2. **The 6px rhythm is even.** All three rows share x384..731 (identical width) and ~31px height
   (Save y547.5..579, Cancel y584.4..615.4, Delete y621..652.5); gaps ≈5.4 / ≈5.6 = the declared
   `spacing: 6` minus AA. Delete is stacked LAST and only exists when `root.editing` — correct.
3. **D07 as recorded was wrong — Delete is NOT "a filled red pill".** In light editing it is the *only*
   row still in the old outlined language: 1px gray rim (left x383 (229,229,232), right x731 (223,224,227),
   top y621 (228,229,231), bottom y651-652 (231,234,236)/(228,229,231)) + a ~7px soft drop shadow beneath
   (240→243→246→247 across y653..659), fill (246,250,252) = `AppTheme.button` = the card's own
   (247,247,247) luminance. Label core red (219,75,75) ≈ `AppTheme.destructive` #d83b3b.
   Cause: `KosButton.qml:67-80` — `destructive` alone leaves `strokeWidth 1`, `strokeColor AppTheme.border`,
   `elevation 0.42`, `showInnerHighlight true`; only `secondary` and `flatPrimary && emphasized` are flat.
   ⇒ the stack mixes two button languages, and the most consequential action is its *lightest*, hollowest
   row: it reads as a hole with an outline, not a button.

## 仍差 (top 8, visual-impact order)
1. D07 finish: the editing footer's Delete row still carries rim+shadow (see 本轮 #3). One-line target
   identified — `secondary: true` at `EventEditorDialog.qml:244` (label color already resolves to
   `AppTheme.destructive` *independently* of `secondary`, `KosButton.qml:41`, so no QML change is needed).
2. D05 dark + editing-state (3-row) capture still not done (dark 2-row WAS done in R030).
3. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow, all unmeasured.
4. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
5. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
6. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination.
7. `CalendarTaskEditorDialog` footer not yet translated to the stacked/filled style — still the old outlined
   secondary, **no `lightLabel`**, no `flatPrimary`, and its Delete (`:306`) has the same rim+shadow as #1.
   Deliberate: translating it is its own atomic step.
8. `buttonNeutral` dark hue still slate-tinted (61,70,82) vs its neutral (38,38,38) surround (R030, unresolved).

## 最近已改 (most recent 8)
1. R032 — verification/measurement round only, **no code change**; D07 premise corrected.
2. R031 `KosButton.qml` `+flatPrimary` (strokeWidth/elevation/showInnerHighlight) + `EventEditorDialog.qml:227`.
3. R030 — verification/measurement round only, **no code change**.
4. R029 `KosButton.qml` +L11-15 (`lightLabel`), `EventEditorDialog.qml:226`.
5. R028 `AppTheme.qml` `buttonNeutral`, `KosButton.qml` (`secondary` flat fill), `EventEditorDialog.qml:234`.
6. R027 `EventEditorDialog.qml:175-248` — footer → vertical full-width `ColumnLayout`, Save/Cancel/Delete order.
7. R026 — verification/driver round only. 8. R025 — R019 fixtures re-seeded; `date`/`view` key names. 32d60c0.

## 外推待确认 (do NOT assume)
- **D06's white primary is a HIG-convention match, not a reference-pixel match** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all** (0 accent-blue pixels). Dark D06 is
  likewise convention-judged, as is "no shadow on an alert primary". Do not re-derive this.
- The target for #1 (neutral flat fill + red label = the iOS/macOS sheet "destructive row" convention) is a
  **convention** judgment, not measured from the ref (no alert in it). If the review judges red-on-neutral
  as not reading destructive enough, the fallback is a red-tinted flat fill — one step, not both.
- `buttonNeutral` dark **value** (61,70,82) is blue-tinted vs its neutral (38,38,38) surround; direction is
  right, hue is unresolved (mixed from the opaque tinted `card`, not the rendered surface tone).
- `flatPrimary`/`lightLabel`/`secondary` are all opt-in, default false ⇒ the rest of the app still shows
  the old outlined secondary and the old `accentText` primary **with** its shadow+rim. Not a regression.
- The accent measured is (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6, so this profile's
  value comes from the system palette. Which one D06 should be judged against is unresolved.
- macOS alert has no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; the launcher's `--date 2026-10-15`
  lands on an empty day, so always send `{"action":"date","date":"2026-04-02"}` first.
- The review app is **not** left running between rounds. `ps|grep -c kos-calendar` counts the loop's own
  cmdline, and `pkill -f "<binary path>"` **kills the driving shell too** (the pattern matches its own
  cmdline — R031 lost a command chain to this, exit 144). Always `kill "$(cat live-app.pid)"`.

## Next round (pick ONLY #1)
**Finish D07: flatten the editing footer's Delete row.** `apps/calendar/qml/EventEditorDialog.qml:244` —
add `secondary: true` to the `destructive: true` KosButton. Do **not** touch `KosButton.qml` and do **not**
touch any other `destructive: true` site (10 of them: todo/music/calendar-task editors, menus). Expected
result, light editing: Delete fill (227,229,230) — byte-identical to Cancel — x384..730, label still
(219,75,75), and the rim/shadow rows (y621 (228,229,231); y651-659 (231..247)) collapse to plain card
(247,247,247). Verify by the same route as this round plus a vertical scan at x=563 and lateral scans at
y=637, then re-judge: does a neutral capsule with a red label still read as destructive, and is the stack
now one language (three flat capsules, red text as the only differentiator)?
