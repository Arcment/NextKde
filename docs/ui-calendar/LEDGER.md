# R056 — **D08 light leg captured: three distinct fills PASS and the light `focusRing` (accent@0.64 = (120,179,216)) renders 2px on the box edges — but light shows NO ring at a clean open, and the light footer is 12px lower than R055's dark footer although the dialog geometry is identical** (2026-10-16)

## 本轮 (R056)
Atomic step: R055's Next #1 = "D08 light leg". Done. No code change, **0 build→screenshot loops**.
Drive (light 1100x692, pid 103791 → **107851**): kill dark pid → `start-review-vm.sh light` → `escape` → `date 2026-04-02` →
`view day` → `openItem "Design review"` → `pointerObject detailsEdit` ×3 → one 9-command list: `nativeRecord r056-lit
9000ms/250` + `pointer 557,587` move/press/drag-out/release + `pointer 557,550` move/press/drag-out/release → **36 frames**.
State→frame map taken from the log's per-frame `elapsedMs`, not from hand arithmetic.

1px column scan at x=450 (light, card **(247,247,247)**):
| button | y span | normal | hover | pressed |
|---|---|---|---|---|
| 保存 (primary) | 547..578 | **(48,140,198)** | **(69,152,204)** | **(85,161,208)** |
| 取消 (secondary) | 584..615 | **(227,229,230)** | **(215,216,217)** | **(204,205,206)** |
| 删除日程 (destructive 2nd) | 621..650 | (227,229,230) + red label | — | — |
Pitch 37, gap 6, x 384..730 — same as dark.

- **Three distinct fills on both kinds ⇒ PASS (light leg).** `accentHover`/`accentPressed` match dark digit-for-digit;
  `buttonNeutralHover/Pressed` = base mixed 0.055/0.105 toward black, both exact.
- **Ring = #78b3d8 (120,179,216) = `accent`@0.64 = light `focusRing`**, 2px, top rows 585,586 **and** bottom 613,614 —
  same geometry as dark ⇒ **D08's `focusRing` clause PASSES in light**.
- **The light button base is ≈(251,252,254), not the dialog fill (247,247,247):** `mix(card,black,0.095)` predicts
  (224,224,224), measured (227,229,230) (+3/+5/+6 bluer). The hover hairline likewise: measured (209,211,215) vs
  `borderHover` over the card = (198,202,207).
- **Hover drops the ring** (1px gray edge) and it returns on leave — the same behaviour R055 saw in dark.
- **UNEXPLAINED #A — no ring at a clean open in light.** Frames 251/501 ms and a separate clean re-open
  (`r056-open`, 11 frames) both show 取消 flat across all rows 584..615. R055 measured the ring **on 取消 at open** in dark.
- **UNEXPLAINED #B — the light footer is 12px lower** (保存 547..578 vs R055 dark 535..565) **while the dialog geometry
  is identical**: the visible event-editor Flickable reads `sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418`
  in light = R055's dark numbers. R054's "Save 546..577" that R055 retired as *resize lag* is within 1px of this light
  reading ⇒ **that retirement looks wrong; the offset is probably light-vs-dark, not lag.**
- Both handed to Next #1 — one dark re-measure with this round's method decides them.

Evidence (mirrored to `docs/ui-calendar/`): `r056-lit-footer-normal.png`, `r056-lit-cancel-{hover,press,focusring}.png`,
`r056-lit-save-{hover,press,focusring}.png` (2x crops of x 384..736 × y 528..662).

**Discipline: 28 Bash calls (budget 25 — OVER).** Two wasted detours, both now in 外推: (a) `nativeRecord` with
`interval == duration` yields **0 frames** (stop timer wins the race); (b) I burned calls inferring "is the dialog open?"
from logs — **one frame answers it**.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. Enter = page 255→204 in one frame with the card still α=0.00; exit = 204→255 in one frame with the card
   still α=1.00. App-wide. **Needs a ruling**; fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs a ruling.**
3. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view shows proportional blocks ⇒ decide
   reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
4. **D08 still partly open:** dark leg (R055) + light leg (R056) captured; **open — the at-open ring discrepancy #A/#B
   below, the task-editor footer (`CalendarTaskEditorDialog.qml:81-98`), a toolbar `KosButton` (`Main.qml:2379`)** for
   the spec's "每个按钮", and a ruling on **hover-drops-the-ring**. **No ruling needed for the captures themselves.**
5. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID.
6. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs a ruling.**
7. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #6. **Needs a ruling.**
8. **Button fill/edge tokens don't match their own formulas** (R056): light `buttonNeutral` base reads ≈(251,252,254),
   not the rendered card (247,247,247). Cosmetic-to-2-Units, but it means the *predicted* light values in 外推 are off.
- *Cosmetic, no ID, folded out (in rounds.md):* D02's radius is **16** vs the spec's `largeRadius` 24 /
  `windowCornerRadius` 32 — recommendation stands: **keep 16**.

## 最近已改 (most recent 8)
1. R056 — measurement only; **D08 light leg captured**; #A/#B above. No code change.
2. R055 — measurement only; **D08 dark leg captured** (hover/pressed/focus). No code change.
3. R054 — measurement only; event Flickable 418/380 → the old "compressed box" still-difference RETIRED as a phantom;
   added `scrollInfo` to the toolbox. No code change.
4. R053 — **ported P03 into the task editor and gated its policy on real scrollability**; narrow + wide PASS.
5. R052 — attempted P03 port, measured, reverted; retired the old #3 as a phantom (clip line ≠ compressed box).
6. R051 — measurement only; P01 dark narrow leg PASS ⇒ P01 CLOSED (4 legs). Corrected R047's dot colour.
7. R050 — measurement only; P01 narrow leg PASS (light); popover immune to the dialog finding.
8. R049 — measurement only; E03 clause 3 **BLOCKED on a ruling**; new 仍差 #8 (now #7).

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056): a 500/500 request produced `frames:[]`.
  Keep `interval ≤ duration/4` (7000/250 and 9000/250 both fine). The log's `native recording` line carries
  **per-frame `elapsedMs`** — parse it to map state→frame instead of hand-arithmetic.
- **The 4-step open chain and the 3-step click CAN go in ONE command list** (R056): `escape`, `date`, `view`, `openItem`,
  `pointerObject detailsEdit`×3 = 7 items in one call works (the 0.6s spacing is enough), and the recording may be the
  **first** item of a list whose later items drive the pointer.
- **Hand-computed stage times are ~0.5–1.0s optimistic** (0.6s + 0.15s per-send sleeps + poll latency). Budget **≥2.5s
  of slack** after the last state change you need, or lengthen `duration`. Verify with `elapsedMs`.
- **The `press` → `move` off the button → `release` outside** idiom is how to capture *pressed* without firing the click:
  the button pops back to normal, the release does nothing, the dialog stays open, and the button keeps `activeFocus`.
- **The ring follows the press, not the dialog:** nothing has a ring at open in light (R056 #A); press 取消 and it keeps
  the ring until 保存 is pressed at 3736 ms. So "which button is focused" is only knowable from a frame *after* a press.
- **Reopening the dialog needs the FULL chain** — `escape`, a **fresh `date`**, `view day`, `openItem`,
  `pointerObject detailsEdit` ×3. `detailsEdit` resolves even with **no popover open** (it found a point at (682,428)
  and the click did nothing) ⇒ always confirm the dialog is up (one frame) before driving the footer.
- **Light event-editor footer at 1100x692: 保存 547..578 / 取消 584..615 / 删除 621..650**, x 384..730, centre x ≈ 557,
  pitch 37. **Dark (R055): 535..565 / 572..602 / 609..639.** The 12px gap is unexplained (#B) — re-measure dark with the
  x=450 scan before trusting either set as "the" geometry.
- **Light tokens:** card/fill renders **(247,247,247)** but the button base is ≈**(251,252,254)**; `focusRing` light =
  `accent`@0.64 = **(120,179,216)**; hover hairline **(209,211,215)**; `accent` (48,140,198) /
  `accentHover` (69,152,204) / `accentPressed` (85,161,208) — the accent three are **identical in both themes**.
  `borderHover` dark = (81,81,81) exact.
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse
  the line as JSON and filter on `parent`.
- **Event editor dialog geometry at 1100x692 (BOTH themes):** card fill light #f7f7f7 / dark #262626; visible Flickable
  `sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418` (range 38, does not fit). A hidden second instance reads
  `sceneX 26.8, sceneY 31.6, h 580, contentHeight 422` — **use `visible:true` to pick the live one.**
- **Task-dialog form: `contentHeight` = 295** at 760x540 and 1100x692; 96px notes viewport, 4 rows h 31, stacked footer.
  At 1100x692 the Flickable is 520 ⇒ not scrollable.
- **A wheel probe is only evidence of "not scrollable" if its point is on a non-control item.** Proven point:
  `windowWheel x350 y300 angleY:-600` at 760x540; at 1100x692 that y lands on the due-date field (use y≈315).
- **`resize` needs ~3s to settle and its frames/geometry lag one resize.** Resize in its own batch, `sleep 3`, record.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); `timeout 180` kills the app.
  A rebuilt binary requires a **kill+relaunch**. Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'`.
  It takes **~12s** before the new pid appears in `live-app.pid`; the app may need another few seconds before it answers
  commands — a single `scrollInfo` settles that faster than reading logs.
- **`nativeRecord` frames land in the app's CWD** = the calendar task dir. `{action,prefix,duration,interval}` →
  `<prefix>-NNNN.png`; **frame counts vary — glob the prefix, never assume an index.** Timer-based and non-blocking.
- **Harness shapes:** `windowWheel` = `{action,x,y,angleY}`; `resize` = `{width,height}`; `openItem` =
  `{kind,titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`; `pointerObject` needs
  THREE commands (`move`,`press`,`release`). Fields are FLAT, and `pointer` needs `kind`.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`**; it accepts a LIST of
  commands (0.6s apart) and prints nothing on success. **In-place write only** to `command.json` (atomic replace trips
  the QML dir watcher). Poll is `interval:100`. **`Bash` CWD drifts between calls — always `cd` to the task dir explicitly.**
- **Fixtures on 2026-04-02:** VEVENTs = Morning planning 08:00 / Short appointment 10:15 / Long review with a
  deliberately lengthy title 11:00 / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) =
  `[UI] Green planning` (09:00), `[UI] Gold review` (12:00, **not** a VEVENT), `[UI] Red review` (16:00),
  `A deliberately long task title to inspect elision` (11:00), `[R019 LONG TASK] …` (11:00).
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its **border**
  only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark. Accent (48,140,198)
  in both themes; `defaultAccentSeed` #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — that is why *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in and
  **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — Re-measure the DARK event-editor footer with R056's exact method, to settle #A and #B at once.** Kill the light
pid from `live-app.pid`, relaunch `start-review-vm.sh dark`, then ONE list: `escape`, `date 2026-04-02`, `view day`,
`openItem "Design review"`, `pointerObject detailsEdit` ×3, `nativeRecord r057-dark2 6000/250`; then a second list with
`pointer {x:557,y:599}` move→press→drag-out→release and `pointer {x:557,y:562}` move. Scan x=450 over **y 520..660**
and report: does 取消 show the ring **at open** (R055 said yes, R056-light says no), and do the boxes land at 535..565 /
572..602 / 609..639 (R055) or 547..578 / 584..615 / 621..650 (R056-light)? Also grep the visible EventEditorDialog
Flickable from `scrollInfo` and compare with `sceneY 131.4, h 380, contentHeight 418`. **If dark lands at 547..578 the
whole footer sits 12px lower than R055 recorded and R055's dark table (plus the R054 "resize lag" retirement) needs a
correction in the ledger.**

**#2+ — everything else in 仍差 needs a ruling** (#1 dim snap, #2 shadow, #3 E03 clause 3, #6/#7 per-cell caps);
**#5 (line pitch)** is cosmetic with no ID; **#4's remaining legs** (task-editor footer, a toolbar `KosButton`,
hover-drops-the-ring) come after #1.
