# R055 — **D08 dark leg: hover/pressed/focus captured — the focus ring is REAL (2px `focusRing`), and all three fills are distinct** (2026-10-16)

## 本轮 (R055)
Atomic step: R054's Next round #1 = "capture `KosButton` hover / pressed / focus in both themes".
Done: **the dark leg** (light leg carried to Next #1 — one theme = one atomic step).
First time in 55 rounds that a button has ever been hovered or pressed. No code change.

Drive (dark, 1100x692, the still-running pid 103791): `escape` → `date 2026-04-02` → `view day` →
`openItem {kind:"event", titleContains:"Design review"}` (popover) → `pointerObject detailsEdit` move/press/release
(dialog) → `nativeRecord r055-b3 7000ms/250` while `pointer {x:557,y:599}` move → press → drag-out → release,
then `pointer {x:557,y:562}` move. 28 frames, **0 build→screenshot loops needed** (no source change).

Measured by a 1px column scan at x=450 (exact box edges, dark, card fill (38,38,38)):
| button | y span | normal | hover | pressed |
|---|---|---|---|---|
| 保存 (primary, `flatPrimary`) | 535..565 (h 31) | **(48,140,198)** | **(69,152,204)** | **(85,161,208)** |
| 取消 (secondary) | 572..602 (h 31) | **(69,69,69)** | **(79,79,79)** | **(89,89,89)** |
| 删除日程 (destructive 2nd) | 609..639 (h 31) | (69,69,69) + red label | — | — |
Pitch 37, gap 6, x 384..730 — unchanged, still matches D05.

- **Three distinct fills on both kinds ⇒ hover ≠ pressed ≠ normal. PASS.**
- **The focus ring is real and measured: 2px, colour (45,115,159)** on the top **and** bottom edge rows
  (572,573 / 601,602) in the **normal and pressed** frames. (45,115,159) = `AppTheme.focusRing` = `accent@0.76`
  over the card = (48,140,198)·0.76 + (38,38,38)·0.24 = (46,116,160) ⇒ **D08's `focusRing` clause PASSES**.
- **At dialog open the ring sits on 取消 (secondary), not 保存** — the primary draws no ring, so *it* is not the
  focused item. `EventEditorDialog.qml:223-247`.
- **While hovered the ring is replaced by a 1px gray `borderHover` (81,81,81)** + a 1px (46,46,46) AA row, and it
  returns on leave. `KosSurface.qml:61-64` is `border.width: focused ? max(2,strokeWidth) : strokeWidth` /
  `color: focused ? focusRing : (hovered ? borderHover : …)`, so a **1px gray edge on a hovered button proves
  `focused == false` while hovered** — hovering drops `activeFocus` on this build. Recorded as an
  observation, **not** filed as a defect (D08 only demands a visible ring; the ref's idle alert shows none).

Evidence (mirrored to `docs/ui-calendar/`): `r055-dark-save-{normal,hover,press}.png`,
`r055-dark-cancel-{normal,hover,press}.png` (2x crops; the ring rows are visible in the normal/pressed ones),
`r055-b3-0012.png` (full dialog frame with the ringed 取消), and the 28-frame `r055-b3-*` series.

**Round-level discipline note:** **24 Bash calls (budget 25)**, 0 build→screenshot loops. Two wasted loops inside
the round: drive1's timing put `press(取消)` at ~6.1s inside a 6.2s recording (**no pressed frame** — the 0.15s
per-send sleeps + poll latency are not in the sleep arithmetic), and drive2 skipped `openItem` so `detailsEdit`
was found *outside* the popover and **no dialog opened** (28 frames of nothing). Both are now in 外推.

## 仍差 (top 7, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. Enter = page steps 255→204 in one frame with the card still at α=0.00; exit = 204→255 in one frame
   with the card still at α=1.00. App-wide. **Needs a ruling**; a fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs a ruling.**
3. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view *does* show proportional top-aligned blocks ⇒ decide
   reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
4. **D08 is only *partly* closed (R055):** dark leg captured (three fills + ring, above); still open — the **light
   leg**, the **task-editor footer** (`CalendarTaskEditorDialog.qml:81-98`) and a **toolbar** `KosButton`
   (`Main.qml:2379`) for the spec's "每个按钮", and a ruling on the **hover-drops-the-ring** behaviour. **No ruling
   needed for the capture itself.**
5. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it.
6. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs a ruling.**
7. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #6. **Needs a ruling.**
- *Cosmetic, no ID, folded out of the top list (in rounds.md):* D02's radius is **16** vs the spec's named
  `largeRadius` 24 / `windowCornerRadius` 32 — recommendation stands: **keep 16**.

## 最近已改 (most recent 8)
1. R055 — measurement only; **D08 dark leg captured** (hover/pressed/focus, above). No code change.
2. R054 — measurement only; **still-difference #3 RETIRED as a phantom** (event Flickable 418/380, thumb ratio 0.90
   = a real bar); added `scrollInfo` to the toolbox. No code change.
3. R053 — **ported P03 into the task editor and gated its policy on real scrollability**; narrow bar PASS, wide PASS.
4. R052 — attempted P03 port, measured, reverted; retired the old #3 as a phantom (clip line ≠ compressed box).
5. R051 — measurement only; P01 dark narrow leg PASS ⇒ P01 CLOSED (4 legs). Corrected R047's dot colour.
6. R050 — measurement only; P01 narrow leg PASS (light); popover immune to the dialog finding.
7. R049 — measurement only; E03 clause 3 **BLOCKED on a ruling**; new 仍差 #8 (now #7).
8. R048 — measurement only; **E03 clauses 1+2 PASS**.

## 外推待确认 (do NOT assume)
*(R053's 9 older items + R054's block are archived to rounds.md — read them there, don't re-derive.)*
- **`pointer` takes flat `{action:"pointer", x, y, kind:"move"|"press"|"release"}`**; x/y are window/contentItem
  coords. With a bare x/y the log prints `hover n/a down n/a`; pass `target` (`{action:"pointer", target:"取消", …}`
  resolves via `objectNamed` **then** `controlNamed`, which matches `item.text`/`item.hint` + a callable `clicked`)
  to get real `hover`/`down` values — **and always pass x/y too as the fallback, otherwise a miss sends NaN.**
  `target` needs UTF-8 CJK labels for these dialogs.
- **The `press` → `move` off the button → `release` outside** idiom is the way to capture *pressed* without firing
  the click: dragging out pops the button back up (frames show the normal fill again) and the release does nothing.
  The dialog stays open and the button keeps `activeFocus`.
- **Timing: `review-command.py`'s 0.6s (and my own 0.15s) per-send sleeps + poll latency make hand-computed stage
  times ~0.5–1.0s optimistic.** A press scheduled at "t=5.15s" inside a 6.2s recording landed at ~6.1s and produced
  **no frame**. Budget **≥2.5s of slack** after the last state change you need, or use a longer `duration`.
- **Reopening the dialog needs the FULL chain** — `escape`, then a **fresh `date`**, then `view day`, then
  **`openItem`**, then `pointerObject detailsEdit` ×3. `detailsEdit` resolves even with **no popover open** (it
  found a point at (682,428) and the click did nothing) ⇒ *always* confirm the dialog is up (a frame, or
  `scrollInfo`) before driving the footer.
- **The event-editor footer is at y 535..639 at 1100x692** (保存 535..565 / 取消 572..602 / 删除 609..639, x 384..730,
  centre x ≈ 557). **R054's 13px-lower reading (Save 546..577) was a post-`resize` layout lag**, not a different
  dialog: the same `Design review` dialog opened fresh sits at the values in the table above. Trust a freshly opened
  dialog, not one measured right after a `resize`.
- **`AppTheme.focusRing` dark = `withAlpha(accent, 0.76)`** (`AppTheme.qml:141`) ⇒ renders **(45,115,159)** over the
  card; `borderHover` renders **(81,81,81)**; secondary `buttonNeutral` (69,69,69) → `buttonNeutralHover` (79,79,79,
  +0.055 white) → `buttonNeutralPressed` (89,89,89, +0.105 white) — matches `AppTheme.qml:106-112` exactly.
  Primary `accentHover`/`accentPressed` = (69,152,204)/(85,161,208). **`strokeWidth` for a `flatPrimary` primary is
  forced to 0, but a focused one still draws `border.width = max(2,0) = 2`.**
- **`scrollInfo` is THE instrument for dialog geometry** — `{action:"scrollInfo"}` dumps every Flickable/ScrollView/
  TextArea with `contentHeight/height/contentY/width/clip/visible/interactive/activeFocus` plus `sceneX/sceneY`, and
  it reaches dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` **cannot**. One
  `[UIReview] scrollInfo [...]` line per call in `live-runtime-vm.log`.
- **Event editor dialog geometry at 1100x692 (dark):** card fill `(38,38,38)`; Flickable `sceneX 387.6, sceneY 131.4,
  w 340, h 380, contentHeight 418 (range 38)` — the form does **not** fit (R054). Card reserves ~240px of chrome vs
  the task editor's ~100px. `contentHeight 418` is width-independent (dialog width = `min(380, w-48)`).
- **Task-dialog form: `contentHeight` = 295** at 760x540 and 1100x692; 96px notes viewport, 4 rows h 31, stacked
  footer. At 1100x692 the Flickable is 520 ⇒ not scrollable.
- **Unscrolled baselines (dark, x=350 narrow / x=500 wide): narrow 151 / 191 / 232 / hint 276..285 / notes 323..clip 361
  / footer 396·433·470; wide 187 / 227 / 268 / notes 359..455 / footer 516·553·590.**
- **A wheel probe is only evidence of "not scrollable" if its point is on a non-control item.** Proven point:
  `windowWheel x350 y300 angleY:-600` at 760x540; at 1100x692 that y lands on the due-date field (use y≈315).
- **`resize` needs ~3s to settle and its frames/geometry lag one resize.** Resize in its own batch, `sleep 3`, then record.
- **A fresh enter needs an app restart** after `escape` (the day-view selection is not restored).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); `timeout 180` kills the app.
  A rebuilt binary requires a **kill+relaunch**. Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'`.
- **`nativeRecord` frames land in the app's CWD** = where `start-review-vm.sh` was invoked. `nativeRecord` =
  `{action,prefix,duration,interval}` → `<prefix>-NNNN.png`; **frame counts vary — glob the prefix, never assume an index.**
  It is **timer-based and non-blocking** (50ms timer, captures via `grabWindow`), so pointer commands interleave with it.
- **Harness shapes:** `windowWheel` = `{action,x,y,angleY}`; `resize` = `{width,height}`; `openItem` =
  `{kind,titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`; `pointerObject`
  needs THREE commands (`move`,`press`,`release`). Fields are FLAT.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`**, and it accepts a
  LIST of commands (0.6s apart). **In-place write only** to `command.json` (atomic replace trips the QML dir watcher).
  Poll is `interval:100`. **`Bash` CWD drifts between calls — always `cd` to the task dir explicitly.**
- **Fixtures on 2026-04-02:** VEVENTs = Morning planning 08:00 / Short appointment 10:15 / Long review with a
  deliberately lengthy title 11:00 / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) =
  `[UI] Green planning` (09:00), `[UI] Gold review` (12:00, **not** a VEVENT), `[UI] Red review` (16:00),
  `A deliberately long task title to inspect elision` (11:00), `[R019 LONG TASK] …` (11:00).
- **Light theme**: the notes field is indistinguishable from the card fill (#F7F7F7 vs (248,248,249)) — locate a light
  field box by its **border** (222,224,226) only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7`
  light / `#262626` dark. Accent (48,140,198) in both themes; `defaultAccentSeed` #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — this is why the primary's *pressed* state was
  captured by press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in
  and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — D08 light leg: repeat R055's capture with `KOS_APPEARANCE=light`** (kill the dark pid from `live-app.pid`,
relaunch with `light`, then `date 2026-04-02` → `view day` → `openItem "Design review"` → `pointerObject
detailsEdit` ×3 → `nativeRecord r056-lit-l 7000/250` with `pointer {x:557,y:599}` move → press → drag-out →
release, then `pointer {x:557,y:561} move`). Compare the same column scan at x=450 against the dark table above and
against `_ref-alert-crop.png`. Light tokens to expect: `focusRing` = accent@**0.64**, `borderHover` light,
`buttonNeutralHover/Pressed` mix toward **black**. Budget slack: ≥2.5s between the last state change and the end of
the recording.

**#2+ — everything else in 仍差 needs a ruling** (#1 dim snap, #2 shadow, #3 E03 clause 3, #6/#7 per-cell caps);
**#5 (line pitch)** is cosmetic with no ID; **#4's remaining legs** (task-editor footer, a toolbar `KosButton`,
hover-drops-the-ring) come after the light leg.
# R054 — **仍差 #3 RETIRED as a phantom: the event editor's bar is a REAL scrollbar (range 38px)** (2026-10-16)

## 本轮 (R054)
Atomic step: R053's Next round #1 = "fix the event editor's twin defect: measure, then gate".
**There is no twin defect — the measurement refuted it, so no code was written this round.**

R053 predicted a stray near-full-length thumb wherever the event form fits. Measured (dark, pid 103791,
`date 2026-04-02` → `view day` → `openItem {kind:event, titleContains:"Design review"}` (14:30) →
`pointerObject detailsEdit` move/press/release → `resize 1100x692`):
- **`scrollInfo`** (new instrument, see 外推) reports the event editor's Flickable: **h 380, contentHeight 418,
  contentY 0, w 340, sceneX 387.6, sceneY 131.4, clip true, visible true ⇒ range 38px — the form does NOT fit.**
- The bar is at **x 724–725** (inner half of a 6px bar centred on the right edge 727.6) and its thumb spans
  **y 133..475 = 342px of a 380px track = 0.90**, exactly the expected `380/418 = 0.909` ⇒ it is a *correct,
  proportional* scrollbar, not R053's full-length stray mark (that one had ratio 1.00 on range 0).
- My own frame confirms the clip visually: the 备注 field's box is cut at the clip line (y 511) with **no bottom
  border** — the form is genuinely clipped, which is precisely what P03's overlay bar exists to signal.
- Therefore the R053 gate (`contentHeight > height ? AsNeeded : AlwaysOff`) would evaluate to `AsNeeded` at
  **every** window size (card capped at 620 ⇒ Flickable 380; contentHeight 418 is width-independent because the
  dialog is `min(380, w-48)`) ⇒ a **permanent no-op**. `EventEditorDialog.qml:271` stays a bare `AsNeeded`.

Evidence: `r054-event-wide.png` (full frame), `r054-clip-bar2x.png` (notes box cut at the clip line),
`r054-bar3x.png` (bar column) — mirrored under `docs/ui-calendar/` + LEDGER R054.

**Round-level discipline note:** **29 Bash calls (budget 25 — overrun)**, **0 build→screenshot loops** (measurement-only).
The overrun is inherent to a measurement round that has to *locate* its subject: 2 calls to find the right 2026-04-02
VEVENT (R053's quoted fixture is a TODO), 6 probe/compare calls, and 5 for mirror+commit bookkeeping. Trimming the
probe count is possible next time (run `scrollInfo` + `nativeRecord` in one batch).
The one wasted probe: the R054 drive script's first attempt used `openItem {kind:"event"}` with R053's literal
title ("Gold review 2026-04-02") — that fixture is a **VTODO**, not a VEVENT; the 2026-04-02 events are
Design review 14:30 / Long review 11:00 / Short appointment 10:15 / Evening session 18:00 / Morning planning 08:00.

## 仍差 (top 7, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. Enter = page steps 255→204 in one frame with the card still at α=0.00; exit = 204→255 in one frame
   with the card still at α=1.00. App-wide. **Needs a ruling**; a fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs a ruling.**
3. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view *does* show proportional top-aligned blocks ⇒ decide
   reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
4. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never checked vs
   ref. `buttonNeutralHover`/`Pressed` never captured; **no button has ever been hovered**. Also open from R045: the
   disabled footer button's accent→disabled blend animates (~0.69 → 0.63 over 52ms). **No ruling needed.**
5. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it.
6. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs a ruling.**
7. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #6. **Needs a ruling.**
- *Cosmetic, no ID, folded out of the top list (in rounds.md):* D02's radius is **16** vs the spec's named
  `largeRadius` 24 / `windowCornerRadius` 32 — recommendation stands: **keep 16**.
- *Retired this round:* R053's #3 (the event editor's "twin defect") — **phantom**, see 本轮.

## 最近已改 (most recent 8)
1. R054 — measurement only; **仍差 #3 RETIRED as a phantom** (event Flickable 418/380, thumb ratio 0.90 = a real
   bar); added `scrollInfo` to the toolbox. No code change.
2. R053 — **ported P03 into the task editor and gated its policy on real scrollability**; narrow bar PASS (thumb
   travels), wide PASS (no bar), form geometry = R041's at both sizes. Fixed the old #3; filed the event editor's
   *unmeasured* twin as new #3.
3. R052 — attempted P03 port, measured, reverted; retired the old #3 as a phantom (clip line ≠ compressed box).
4. R051 — measurement only; P01 dark narrow leg PASS ⇒ P01 CLOSED (4 legs). Corrected R047's dot colour.
5. R050 — measurement only; P01 narrow leg PASS (light); popover immune to the dialog finding.
6. R049 — measurement only; E03 clause 3 **BLOCKED on a ruling**; new 仍差 #8 (now #7).
7. R048 — measurement only; **E03 clauses 1+2 PASS**.
8. R047 — measurement only; **P01 long-text dark leg PASS**; dot is accent blue, not green.

## 外推待确认 (do NOT assume)
*(R053's 9 older items were archived to rounds.md R053 — α-probe method, month/week-grid geometry, popover centring,
`captureClient` key, `ElideRight`, month chip tinting, `flatPrimary` opt-ins. Read them there, don't re-derive.)*
- **`scrollInfo` is THE instrument for dialog geometry — it settles what three other probes could not.**
  `{action:"scrollInfo"}` dumps every Flickable/ScrollView/TextArea with `contentHeight/height/contentY/width/
  clip/visible/interactive` plus `sceneX/sceneY`, and it reaches the dialog Flickables that `objectNamed`,
  `inspectGeometry` and `regionPosition` **cannot** (only the *task* editor has `objectName:"editorScroll"`).
  Output = one `[UIReview] scrollInfo [...]` line per call in `live-runtime-vm.log`. **Use it before any pixel probe
  on a dialog.** Do not conclude "the bar is stray" from pixels alone — check `contentHeight > height` first.
- **Event editor dialog geometry at 1100x692 (dark, measured R054):** card fill `(38,38,38)`; Flickable
  `sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418 (range 38)`, `interactive:false`, `clip:true`;
  bar renders at **x 724–725**, thumb **y 133..475**; notes viewport h 96 at sceneY 453.4; footer button ListView
  sceneY 531.4 h 40. The card reserves **~240px** of chrome (vs the task editor's ~100px) — that is why the event
  form overflows where the task form does not. `contentHeight 418` is width-independent (**dialog width =
  `min(380, w-48)`**; at 760x540 the card is 508 ⇒ Flickable 268 ⇒ overflow grows to 150).
- **R053's root-cause story is unverified by the new instrument.** Its gate is *correct by construction*, but the
  premise behind it ("a bare `AsNeeded` never hides an attached bar") rests on a pixel sighting on a form that
  `scrollInfo` now reports as **295 ≤ 520 at 1100x692**. Re-derive with `scrollInfo` before quoting the mechanism
  to justify anything else (the gate itself is safe — it is exactly the wheel handler's predicate).
- **The attached bar is centred on the Flickable's right edge and `clip: true` cuts its outer half ⇒ a 6px bar renders
  3px.** At 760x540 it sits at x 553–555; at 1100x692 at x 723–725. **A dark `(23,23,23)` column there is a bar, NOT a
  border** (field borders read *lighter* than the card: `(65,66,67)`). A **partial** column (broken by the field
  rows' edges) is still the bar.
- **Task-dialog form: `contentHeight` = 295 at 760x540 and 1100x692; the Flickable's visible bottom (the clip line) is
  y 360/361 at 760x540 ⇒ height 236 ⇒ range 59.** At 1100x692 the Flickable is 520 ⇒ not scrollable, so R053's gate
  correctly hides its bar. The 96px notes viewport, the 4 rows (h 31/31/31) and the stacked footer never change with
  window size.
- **Unscrolled baselines (dark, x=350 narrow / x=500 wide): narrow 151 / 191 / 232 / hint 276..285 / notes 323..clip 361
  / footer 396·433·470; wide 187 / 227 / 268 / notes 359..455 / footer 516·553·590.** Compare against these before
  calling anything a regression.
- **A wheel probe is only evidence of "not scrollable" if its point is on a non-control item.** Labels and layout
  spacing propagate the wheel to the Flickable's `NoButton` MouseArea and scroll it; a `KosTextField`/ComboBox under
  the point eats it. **Proven point: `windowWheel x350 y300 angleY:-600` at 760x540** (the "Notes" label row). At
  1100x692 that same y lands on the due-date **field** — use a Label row (e.g. y≈315, the hint) instead.
- **`resize` needs ~3s to settle, and its frames lag one resize**: a `nativeRecord` started inside ~1s of a `resize`
  still carries the **old** window size. **Resize in its own batch, `sleep 3`, then record.** (R054 did this — batch
  `a` = escape/date/view/resize+3.5s, batch `b` = open+click+probe.)
- **`regionPosition`/`inspectGeometry` cannot reach a dialog Flickable that has no `objectName`** — they returned
  `[UIReview] region unavailable` three times in R053. `scrollInfo` (class-based) is the workaround. `regionPosition`
  works on `scheduleViewport`-style names reachable from `window.contentItem`.
- **The dialog's Flickable** (task editor, measured): top ≈ dialogTop + 83.5; event editor top = sceneY 131.4 with the
  card top ≈ 36. At 760x540 the task card is ~9px lower than `anchors.centerIn` would put it — unexplained, don't
  build on centring.
- **A fresh enter needs an app restart** after `escape` (the day-view selection is not restored).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); wrapping it in
  `timeout 180` kills the app. A reverted/rebuilt binary requires a **kill+relaunch** (the running process keeps the
  old binary). Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'` (exit 144).
- **`nativeRecord` frames land in the app's CWD** = wherever `start-review-vm.sh` was invoked (here
  `tmp/ui-acceptance/calendar/`). `nativeRecord` = `{action,prefix,duration,interval}` → `<prefix>-NNNN.png`;
  **frame counts vary — glob the prefix, never assume an index.**
- **Harness shapes:** `windowWheel` = `{action,x,y,angleY}`; `resize` = `{width,height}`; `openItem` =
  `{kind,titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`; `pointerObject`
  needs THREE commands (`move`,`press`,`release`); `scrollInfo` takes no args. Fields are FLAT.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`, and it accepts a
  LIST of commands** (one call can drive a whole sequence, 0.6s apart). A drive script needs its own sleeps; the
  helper only guarantees 0.6s between commands.
- **In-place write only** to `command.json` (atomic replace trips the QML dir watcher). Poll is `interval:100`.
- **Fixtures on 2026-04-02:** VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title 11:00** / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) =
  `[UI] Green planning 2026-04-02` (09:00), `[UI] Gold review 2026-04-02` (12:00), `[UI] Red review 2026-04-02` (16:00),
  `A deliberately long task title to inspect elision` (11:00), `[R019 LONG TASK] …` (11:00). **"Gold review" is a
  TODO — do not pass it as `kind:"event"`.** Always send `date` first, own batch.
  `openItem` → popover; the **Dialog** needs `pointerObject detailsEdit` move/press/release.
- **The task dialog's footer is fixed** (only the form above it scrolls) — Delete can never scroll out of reach.
- **Light theme**: the notes field is indistinguishable from the card fill (#F7F7F7 vs (248,248,249)) — locate a light
  field box by its **border** (222,224,226) only. The popover's fill is `#F5F5F5` light / `#262626` dark — the editor
  dialogs use `#F7F7F7` light / `#262626` dark. Accent measured (48,140,198) in both themes; `defaultAccentSeed` is #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders as **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline).
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in
  and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — 仍差 #4: capture `KosButton` hover / pressed / focus in both themes** (no ruling needed; this is R052's Next#2,
now carried two rounds — `buttonNeutralHover`/`Pressed` have never been captured and **no button has ever been
hovered**). Use the event editor's footer, which is 3 stacked full-width buttons: at 1100x692 dark the footer
ListView sits at `sceneY 531.4 h 40` ⇒ the Save row is centred near **y 551**, Cancel near **y 588**, Delete near
**y 624** (x ≈ 560). Drive `pointerObject`-free with `pointer` (`{action:"pointer",x,y,kind:"move"|"press"|"release"}`
— it logs `hover`/`down` for a `target`, so a bare x/y works) and take **continuous frames** with `nativeRecord`
(≥3 frames: idle → hover → pressed → released). Disabled state: type nothing into 标题 and re-probe Save. Both themes
(restart per theme — the binary reads `KOS_APPEARANCE`). Continuous frames are mandatory; a static frame cannot pass
this item.

**#2+ — everything else in 仍差 needs a ruling** (#1 dim snap, #2 shadow, #3 E03 clause 3, #6/#7 per-cell caps),
and **#5 (line pitch)** is cosmetic with no ID.
