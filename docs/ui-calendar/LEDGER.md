# R034 — D05 dark editing captured: R033's fix holds in dark, and `buttonNeutral`'s dark hue is now visibly wrong (2026-10-16)

## 本轮 (R034)
Atomic step: **D05 dark + editing state — capture the 3-row footer in dark, judge R033 there** (was 仍差 #1).
**No code change.** Verification/measurement round. Artifact: `r034-editor-edit-dark.png` (1100x692),
`_r034-footer3x.png` (3x footer crop, x375..740 y540..660).
Route (the corrected one): `date 2026-04-02` → `view day` → `openItem` → `pointer move` (682,441) →
`pointer press` → `pointer release` → `captureClient`. First try, no wasted cycle.

Measurements (Pillow; card surface = **(38,38,38)**, dialog card bottom ≈ y668.4):

| row | fill | ink rows | fill x-extent |
|---|---|---|---|
| Save (保存) | **(48,140,198)** accent, same as light | y547.4..578.4 → **31px** | 384..730 |
| Cancel (取消) | **(61,70,82)** | y584.4..615.4 → **31px** | 384..730 |
| Delete (删除日程) | **(61,70,82)** — byte-identical to Cancel | y621.4..652.4 → **31px** | 384..730 |

1. **R033's fix holds in dark, literally.** Delete's fill is byte-identical to Cancel's (61,70,82) across
   x384..730. No rim: the only non-card pixels outside the fill are single-pixel AA, and Delete's AA is
   *identical* to Cancel's — top y621 (52,57,64), bottom y652 (47,51,56), left x392 (55,62,71),
   right x722 (57,64,74). R032's 1px rim is absent in dark too.
2. **No shadow.** y653 is (38,38,38) immediately — no gradient rows beneath the capsule, same as light.
3. **Geometry equals D05 exactly.** All three rows 31px high (= `AppTheme.controlHeight`; see 外推 #1),
   all 347px wide, pitch 37, gaps 579..584 / 615..621 = **6px** = `EventEditorDialog.qml:220 spacing: 6`
   byte-for-byte. Order Save / Cancel / Delete; Delete only when `root.editing`. **D05 flipped to PASS**
   (spec.md:106) for the editing footer, both themes.
4. **(a) Is the dark Delete capsule distinguishable from Cancel by fill? NO — and that is correct.**
   Identical fill/geometry/AA; the label colour is the *only* differentiator. Same design as light (R033),
   so this is consistency, not a defect.
5. **(b) Does the dark red label still read destructive? YES.** Core red **(249,104,97)** (max observed;
   plateaus (247,102,92)/(239,102,96)), i.e. the dark variant of `AppTheme.destructive`, sitting on
   (61,70,82). Contrast 3.27:1 (vs Cancel's near-white 8.3:1) — dimmer by intent, and the *hue* is
   unmistakable. Reads as the destructive row on the 3x crop with no reservation.
6. **(c) Is the fill a dead slab next to the dark card? NO — the opposite.** Fill/card separation is
   Y≈1.60:1 in dark vs **1.19:1 in light**. The capsule is *more* legible in dark, not less. So the
   dead-slab worry is closed; R033 is confirmed in dark.
7. **But the hue is visibly slate-blue.** On the 3x crop the Cancel/Delete capsules are a cool steel
   tint over a warm-neutral (38,38,38) card — this promotes 仍差 #7 from a numeric note to a
   **seen** defect with a concrete cause (外推 #2). This is the next round.

## 仍差 (top 8, visual-impact order)
1. **`buttonNeutral` dark hue (61,70,82) is slate-blue** — now *seen* at 3x, not just measured. Cause and
   target in 外推 #2. This is Next round #1.
2. `CalendarTaskEditorDialog` footer still the old outlined secondary — **no `lightLabel`**, no
   `flatPrimary`, and its Delete (`:306`) still carries the rim+shadow removed from `EventEditorDialog`.
   Last rim+shadow Delete in the family. (Was #6; D05's qualified PASS in spec.md points here.)
3. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow; all still unmeasured.
4. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
5. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
6. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination.
7. `KosButton.qml:67-68` — secondary buttons regain a 1px `AppTheme.border` rim on **hover or
   activeFocus**. Cancel and Delete now share it. Never checked against the ref. Low priority, recorded
   not fixed.
8. Light-theme `buttonNeutral` (227,229,230) on card (247,247,247) = 1.19:1 — accepted as correct
   (R033 #6), listed only so nobody re-opens it: the *light* value is fine, only the *dark* one is wrong.

## 最近已改 (most recent 8)
1. R034 — verification/measurement round only, **no code change**; D05 → PASS (editing footer).
2. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.
3. R032 — verification/measurement round only, **no code change**; D07 premise corrected.
4. R031 `KosButton.qml` `+flatPrimary` (strokeWidth/elevation/showInnerHighlight) + `EventEditorDialog.qml:227`.
5. R030 — verification/measurement round only, **no code change**.
6. R029 `KosButton.qml` +L11-15 (`lightLabel`), `EventEditorDialog.qml:226`.
7. R028 `AppTheme.qml` `buttonNeutral`, `KosButton.qml` (`secondary` flat fill), `EventEditorDialog.qml:234`.
8. R027 `EventEditorDialog.qml:175-248` — footer → vertical full-width `ColumnLayout`, Save/Cancel/Delete order.

## 外推待确认 (do NOT assume)
- **`controlHeight` renders as 31px here, not the spec's 34.** `AppTheme.qml:168` is
  `Math.round((modernDesign ? 34 : 36) * densityScale)` and `densityScale` (`:166-167`) is
  `Application.font.pixelSize / 13` clamped to [0.88,1.28]. The harness sets **no** font override
  (`harness/Main.qml` only *reports* `reviewWindow.font.pixelSize`), so this profile's font size makes
  densityScale ≈ 0.912 ⇒ 34×0.912 ≈ 31. Ink measurement confirms 31.0 exactly (sub-pixel AA blend
  fractions: top 0.598, bottom 0.402). **D05's "=34" is the densityScale=1.0 value**; what D05 actually
  tests — 竖排/通栏/等宽/同高/仅填充色区分 — holds. Do not "fix" 31 → 34.
- **`buttonNeutral` dark is derived from the wrong base.** `AppTheme.qml:103-105`:
  `dark ? mix(card, white, 0.13)`. Solving the measured (61,70,82) backwards gives `card` dark ≈
  **(32,42,56)** — a blue-slate *token*, whereas the **rendered** dark card surface is **(38,38,38)**.
  So the button is mixed from an opaque tinted token, not from what is actually drawn underneath it —
  the exact R030 diagnosis, now with a cause. Fix direction: neutral base, keep the luminance step.
  A neutral grey with today's Y (0.0599) is **≈ (69,69,69)**; `renderSurface`/the drawn (38,38,38) is the
  base it should be mixed from. Verify by re-running *this* round's route.
- **D06's white primary is a HIG-convention match, not a reference-pixel match** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all** (0 accent-blue pixels). Dark D06 is
  likewise convention-judged, as is "no shadow on an alert primary". Do not re-derive this.
- **D07's red-on-neutral flat fill is a CONVENTION judgment** (no alert in the ref). Now judged in
  **both** themes (light R033 #6, dark R034 #4/#5) — PASS in both. The fallback (red-tinted flat fill) is
  explicitly **not** warranted. Carry the judgment, not a measurement.
- `flatPrimary`/`lightLabel`/`secondary` are all opt-in, default false ⇒ the rest of the app still shows
  the old outlined secondary and the old `accentText` primary **with** its shadow+rim. Not a regression.
- The accent measured is (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6, so this
  profile's value comes from the system palette. Which one D06 should be judged against is unresolved.
- macOS alert has no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- `{"action":"pointer","kind":"click"}` is a **no-op** (`ReviewInput.cpp:67-92` maps only `press`/`release`;
  anything else falls through to `MouseMove`+`NoButton`). Use `move`/`press`/`release`. The 编辑 affordance
  in the details popover is centred at **(682,441)**, not (678,440).
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send
  `{"action":"date","date":"2026-04-02"}` first.
- The review app is **not** left running between rounds. `ps|grep -c kos-calendar` counts the loop's own
  cmdline, and `pkill -f "<binary path>"` **kills the driving shell too** (R031 lost a command chain to
  this, exit 144). Always `kill "$(cat live-app.pid)"`.
- `start-review-vm.sh` does not return (it blocks on the VM/app) — run it as a background Bash call or
  with a timeout, then drive via `review-command.py`. A return of "timed out" there is normal.

## Next round (pick ONLY #1)
**Fix `buttonNeutral`'s dark hue — the slate-blue capsules seen in R034 #7.** Scope: `AppTheme.qml:103-105`
only. Keep both branches' *luminance step*; change the dark base so the result is hue-neutral.
Target: mix from the **rendered** dark surface (38,38,38) rather than the tinted `card` token, giving
**≈ (69,69,69)** — hue-neutral, Y≈0.0599 (unchanged), so the fill/card separation stays ≈1.60:1.
Constraints: do **not** touch `buttonNeutralHover`/`buttonNeutralPressed` (they mix *from* `buttonNeutral`
and will follow automatically), do **not** touch the light branch (R033 accepted it), do **not** change
`controlHeight`, and do not regress `KosButton.qml:67-68`'s hover rim. Judge by re-running **this**
round's route in dark and re-measuring the three rows; the light theme must stay byte-identical to R033
(same route in light). Watch for: does a neutral (69,69,69) still separate from the (38,38,38) card at
all, and does the red label's 3.27:1 contrast survive?
