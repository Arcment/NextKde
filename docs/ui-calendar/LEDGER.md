# R033 — D07 landed: the editing footer's Delete row is now a flat neutral capsule (2026-10-16)

## 本轮 (R033)
Atomic step: **finish D07 — flatten the editing footer's Delete row** (was 仍差 #1).

Change: `apps/calendar/qml/EventEditorDialog.qml:245` — added `secondary: true` after `destructive: true`
on the editing-only Delete `KosButton`. One added line, one file. `KosButton.qml` untouched. No other
`destructive: true` site touched. Artifacts: `r033-popover-light.png`, `r033-editor-edit-light.png`
(both 1100x692), `_r033-footer3x.png` (3x footer crop).

**Driver correction (cost me one wasted cycle — read this before driving):**
`{"action":"pointer","kind":"click"}` is a **no-op**. `ReviewInput.cpp:67-92` only maps `"press"` and
`"release"` to real button events; any other kind (incl. `click`) falls through to the default
`QEvent::MouseMove` with `NoButton`. It still sends the move, so the click target *does* show hover — the
diff bbox collapses to just the button rect — which looks like a near-miss and is easy to misdiagnose.
R032's "raw-coordinate click at (678,440)" means **three** commands: `move`, `press`, `release`. With only
`press`+`release` it also works (no preceding move needed).
Also: the 编辑 affordance in the details popover actually sits at x≈659..705, y≈429..453 — centre **(682,441)**.
The round's shorthand "(678,440)" is inside it but 2px off centre; use (682,441).

Route: `date 2026-04-02` → `view day` → `openItem` → `move/press/release` (682,441) → `captureClient`.

Judgment (Pillow, light, editing, `x=563` vertical scan + `y=637` lateral):
1. **Delete is now flat and byte-identical to Cancel.** Fill **(227,229,230)** across x384..730, y622..651;
   AA only at x383 (240,240,241), x731 (236,237,237), y621 (235,236,237), y652 (239,240,240). R032's
   1px rim (x383 (229,229,232) / x731 (223,224,227) / y621 (228,229,231) / y651-652 (231,234,236)) is gone.
2. **The shadow is gone.** R032's y653..659 gradient (240→243→246→247) is now flat card (247,247,247)
   from y653 all the way down. No halo under the capsule.
3. **Label still reads destructive.** Core red (217,73,73) ≈ R032's (219,75,75) ≈ `AppTheme.destructive`;
   AA skirt (221,138,138)/(223,170,170) at y632-633/636. Resolved by `KosButton.qml:41` independently of
   `secondary`, exactly as the round predicted — no QML change was needed for the color.
4. **Save and Cancel are regression-free.** Save (48,140,198) y548..578, back to card at y579. Cancel
   (227,229,230) y585..605, card at y616. Both byte-identical to R032.
5. **Rhythm preserved.** Rows y548..578 / y585..614 / y622..651 (≈31/30/30px), gaps ≈6/≈6, all x384..730
   (identical width, 346px), rounded full capsules. Order Save / Cancel / Delete unchanged; Delete still
   only exists when `root.editing`.
6. **Visual verdict (my own eye, 3x crop `_r033-footer3x.png`): PASS, and the earlier worry was unfounded.**
   The stack now reads as ONE language — three flat capsules, one filled blue primary, two neutral, with
   red text as the only differentiator. The neutral capsule does **not** dilute "destructive": on a
   (247,247,247) dialog card, a (227,229,230) capsule with red lettering reads unmistakably as the
   destructive row — the macOS/iOS sheet convention. It also fixes the inversion noted in R032, where the
   most consequential action was the *lightest, hollowest* row in the stack. No fallback to a red-tinted
   flat fill is warranted.

## 仍差 (top 8, visual-impact order)
1. D05 **dark** + editing-state (3-row) capture still not done — the one thing that would confirm R033 in
   dark. (dark 2-row WAS measured in R030.)
2. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow; all still unmeasured.
3. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
4. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
5. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination.
6. `CalendarTaskEditorDialog` footer not yet translated to the stacked/filled style — still the old outlined
   secondary, **no `lightLabel`**, no `flatPrimary`, and its Delete (`:306`) still carries the rim+shadow
   just removed from `EventEditorDialog`. It is now the **last** rim+shadow Delete in the dialog family.
   Deliberate: translating it is its own atomic step.
7. `buttonNeutral` dark hue still slate-tinted (61,70,82) vs its neutral (38,38,38) surround (R030, unresolved).
8. `KosButton.qml:67-68` — secondary buttons regain a 1px `AppTheme.border` rim on **hover or activeFocus**
   (`strokeWidth` → 1). Now that Delete is secondary, Cancel and Delete share this. Consistent across the
   two, reads as intended hover affordance; never checked against the ref. Low priority, recorded not fixed.

## 最近已改 (most recent 8)
1. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.
2. R032 — verification/measurement round only, **no code change**; D07 premise corrected.
3. R031 `KosButton.qml` `+flatPrimary` (strokeWidth/elevation/showInnerHighlight) + `EventEditorDialog.qml:227`.
4. R030 — verification/measurement round only, **no code change**.
5. R029 `KosButton.qml` +L11-15 (`lightLabel`), `EventEditorDialog.qml:226`.
6. R028 `AppTheme.qml` `buttonNeutral`, `KosButton.qml` (`secondary` flat fill), `EventEditorDialog.qml:234`.
7. R027 `EventEditorDialog.qml:175-248` — footer → vertical full-width `ColumnLayout`, Save/Cancel/Delete order.
8. R026 — verification/driver round only. (R025 — R019 fixtures re-seeded; `date`/`view` key names. 32d60c0.)

## 外推待确认 (do NOT assume)
- **D06's white primary is a HIG-convention match, not a reference-pixel match** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all** (0 accent-blue pixels). Dark D06 is
  likewise convention-judged, as is "no shadow on an alert primary". Do not re-derive this.
- **D07's red-on-neutral flat fill is a CONVENTION judgment**, not measured from the ref (no alert in it).
  It is now implemented and I judged it to read destructive in light editing (R033 #6). The fallback
  (red-tinted flat fill) is explicitly **not** warranted in light. Dark remains unverified — carry the
  judgment, not a measurement.
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
- `start-review-vm.sh` does not return (it blocks on the VM/app) — run it as a background Bash call or with
  a timeout, then drive via `review-command.py`. A return of "timed out" there is normal, not a failure.

## Next round (pick ONLY #1)
**D05 dark + editing state: capture the 3-row footer in dark and judge R033's fix there.** Same route as
this round (with the corrected `move`/`press`/`release` at (682,441)). Expected in dark: Delete fill =
`AppTheme.buttonNeutral` dark (61,70,82 per R030 — *the value itself is suspect, see 外推*), x384..730, no
rim, no shadow rows beneath; label = `AppTheme.destructive` dark variant, still clearly red and still
legible on that fill; gaps/width/order identical. Judge two things separately and say which: (a) is the
dark Delete capsule distinguishable at all from Cancel, and (b) does the dark red label still read
destructive against the dark neutral fill. If the fill reads as a *dead* slab next to the dark card, that
promotes 仍差 #7 (`buttonNeutral` dark hue) to the next step.
