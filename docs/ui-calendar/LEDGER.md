# R054 — **仍差 #3 RETIRED as a phantom: the event editor's bar is a REAL scrollbar, range 38px** (2026-10-16)

## 本轮 (R054)
Atomic step: R053's Next round #1 = "fix the event editor's twin defect: measure, then gate".
**No code was written — the measurement refuted the premise.**

**A. The instrument that settled it.** `{action:"scrollInfo"}` dumps every Flickable/ScrollView/TextArea with
`contentHeight/height/contentY/width/clip/visible/interactive` plus `sceneX/sceneY`, and — unlike `objectNamed`,
`inspectGeometry` and `regionPosition` — it reaches the dialog Flickables, because the *event* editor's Flickable has
no `objectName` (only the task editor's does). Run it **before** any pixel probe on a dialog. Output =
one `[UIReview] scrollInfo [...]` line in `live-runtime-vm.log`.

**B. Measurement — dark, pid 103791, `escape` → `date 2026-04-02` → `view day` → `resize 1100x692` (own batch, 3.5s
settle) → `openItem {kind:"event", titleContains:"Design review"}` (14:30) → `pointerObject detailsEdit`
move/press/release → `scrollInfo` → `nativeRecord` 800/200.**

| probe | value | reading |
|---|---|---|
| event-editor Flickable | `contentHeight 418`, `height 380`, `contentY 0`, `w 340`, `sceneX 387.6`, `sceneY 131.4`, `clip true` | **range 38px — the form does NOT fit** |
| task-editor Flickable (same dump, closed) | `contentHeight 295`, `height 520`, `objectName "editorScroll"` | R053's gate is correct: `295 ≤ 520` ⇒ no bar |
| bar column @ y150/200/300/400 | **`(29,20,26)` at x 723–725**, card `(38,38,38)` either side | the inner half of a 6px bar centred on the right edge **727.6** |
| thumb extent @ x=724 | **y 133..475 = 342px of a 380px track = 0.90** | expected `380/418 = 0.909` ⇒ **a proportional scrollbar** (R053's stray mark read 1.00 on range 0) |
| notes viewport / footer | `h 96 @ sceneY 453.4` / button ListView `sceneY 531.4 h 40` | unchanged from R041's layout |
| by eye (`r054-clip-bar2x.png`) | the 备注 box is cut at the clip line (y 511) **with no bottom border** | the form is genuinely clipped — the exact state P03's overlay bar exists to signal |

**C. Why the gate must NOT be ported.** Card height is capped at 620 ⇒ Flickable 380; `contentHeight 418` is
width-independent (dialog width = `min(380, w-48)`; at 760x540 the card is 508 ⇒ Flickable 268 ⇒ overflow 150). So
`contentHeight > height` holds at **every** window size, and R053's gated policy would be a **permanent no-op**.
`EventEditorDialog.qml:271` stays a bare `policy: ScrollBar.AsNeeded`. **0 build→screenshot loops.**

**D. Caveat filed, not fixed.** R053's gate is correct by construction, but its *root-cause story* ("a bare
`AsNeeded` never hides an attached bar") rests on a pixel sighting on a form that `scrollInfo` now reports as
`295 ≤ 520` at 1100x692. Re-derive it with `scrollInfo` before quoting that mechanism.

**E. Fixture note.** `[UI] Gold review 2026-04-02` is a **VTODO** (DUE 12:00), not a VEVENT — R053's Next#1 quoted it
as `kind:"event"`. The 2026-04-02 VEVENTs are Morning planning 08:00 / Short appointment 10:15 / Long review… 11:00 /
**Design review 14:30** / Evening session 18:00.

Evidence: `r054-event-wide.png` (1100x692 full frame), `r054-clip-bar2x.png` (notes box cut at the clip line),
`r054-bar3x.png` (the bar column). *Discipline:* **29 Bash calls (budget 25 — overrun)**, 0 build loops,
measurement-only. The overrun is the cost of *locating* the subject — 2 calls went on finding the right 2026-04-02
VEVENT (R053's quoted fixture is a TODO), 6 on probes/comparisons, 5 on mirror+commit bookkeeping.

# R053 — **仍差 #3 FIXED: the task editor gets a real overlay scrollbar, and the wide form never shows one** (2026-10-16)

## 本轮 (R053)
Atomic step: R052's Next round #1 = "make the wide task-dialog form fit, **then** port the event editor's P03 bar".
**(a) was a false premise again.** The wide form *already* fits — its notes box is drawn complete (bottom border
`453–455`, unclipped) with its content ending at `y 455`, ~45px above the footer at `500`. `contentHeight` is
`295` at **both** window sizes; the clip line at 760x540 is `360/361` ⇒ height `236` ⇒ range `59` (295-236), which
is exactly the 59px measured in R052. Nothing to remove.
**So the port was done alone** (`apps/calendar/qml/CalendarTaskEditorDialog.qml`, `contentItem`), and its *policy*
had to be gated — the verbatim P03 block (`EventEditorDialog.qml:268-281`) reproduces R052's regression exactly.

**A. The real root cause, measured.** With `policy: ScrollBar.AsNeeded` (event editor, verbatim) at **1100x692**, the
frame carried a `(23,23,23)` column at **x 723–725 @ y300** — a near-full-length thumb on a form that fits
(`size ≥ 1`). `AsNeeded` therefore does **not** hide an attached bar here; the bar is only ever *shown*, never
re-evaluated off. Fix: gate the policy on the same predicate the wheel handler uses —
`policy: editorScroll.contentHeight > editorScroll.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff`.
(`AlwaysOff` is a `policy` *assignment*, so the engine's own `setVisible` and a QML `visible:` binding cannot fight.)

**B. Evidence — dark, pid 103791, `date 2026-04-02` → `view day` → `openItem todo "Green planning 2026-04-02"` →
`pointerObject detailsEdit` move/press/release → `resize` → `nativeRecord` (resize needs ~3s to settle: a recording
started inside 1s still carries the *old* window size in its frames).**

| probe | 760x540 | 1100x692 |
|---|---|---|
| **bar column @ y300** | **`(23,23,23)` at x 553–555** (x548-552 and x556+ are card `(38,38,38)`) | **`(38,38,38)` x 716–732 — no bar**; whole x 708–742 × y 90–650 holds exactly **1** `(23,23,23)` pixel (the card's bottom-right AA corner at 739,635) |
| **thumb @ x554** | **y 127..311** (contentY 0) → **y 173..357** after 2× wheel-down (`x350 y300 angleY-600`) ⇒ **it travels** | — |
| form right edge @ y450 | — | notes field fill `(34,39,47)` + its own *lighter* right border `(57,59,64)/(67,67,67)` at 722–725 — a field edge, not a bar |
| unscrolled form, x=350 / x=500 | **151 / 191 / 232 / hint 276..285 / notes 323..clip 361 / footer 396·433·470** — R041's numbers exactly | **187 / 227 / 268 / 359..455 / 516·553·590** — R041's numbers exactly |

No layout regression at either size; the 59px range, the 96px notes viewport and the clip line are all unchanged.

**C. Geometry, worth recording** (it misled two rounds): the attached bar is centred on the Flickable's **right
edge** and the Flickable's `clip: true` cuts its outer half ⇒ a 6px bar **renders 3px**, and at wide its inner edge
(x 724) sits inside the form, which is why a stray bar reads as a *rendering fault* rather than as chrome.

# R052 — **仍差 #3 RETIRED: the editor dialogs do NOT compress — the "39px notes viewport" is a CLIP line** (2026-10-16)

## 本轮 (R052)
Atomic step: R051's Next round #1 = fix 仍差 #3 ("the editor dialogs compress instead of scrolling at 760x540").
**The premise was false.** The dialogs never compress; "96 → 39px" is the *visible* fraction of a 96px notes box
that the scroll viewport clips at y=360/361. One candidate fix for the real defect it hid was implemented,
measured, found to regress the **wide** window, and **reverted** ⇒ **no net code change this round**
(`git diff` empty for `CalendarTaskEditorDialog.qml`).

**A. Static proof (pre-existing frames, no app needed).** `r041-narrow-0021.png` (760x540 dark) at x=350: the notes
box fill `(34,39,47)` runs **y 326→360 with NO bottom border** and stops dead at card fill; the *wide* frame ends
the same box with **rounded** corners (fill-run 335→321px over y 444→452, border 453–455). A 38px box would show
that rounded bottom. The fill stays the **full 335px wide** (x 220–554 = exactly the wide frame's x 390–724) down
to its last drawn row ⇒ **clipped, not resized**. The field bands above are h **31/31/31** at both sizes.

**B. Live proof the form scrolls** (dark, pid 101088; `date 2026-04-02` → `view day` → `openItem todo
"Green planning"` → `pointerObject detailsEdit` move/press/release → `resize 760x540` → `nativeRecord r052-rev` →
2× `windowWheel x350 y300 angleY:-600` → `nativeRecord r052-revscroll`):

| x=350 band | narrow unscrolled | after 2× wheel-down | wide |
|---|---|---|---|
| fields | 151..181, 191..221, 232..262 | **132..162, 173..203** (title row gone above) | 187..217, 227..257, 271..294 |
| hint text | 276..284 | 217..225 | 311..320 |
| **notes box** | **323..360 (clipped)** | **264..360 = h97** | 359..455 = h97 |
| 保存/取消/删除任务 | 396/433/470..501 | **unmoved** | 516/553/590 |

**Rigid translation, exactly −59px, field heights unchanged (31/31), footer immobile.** The notes box is **96px
(97 with borders) in the narrow *and* wide windows**. And the **59px scroll range equals the 59px that was hidden**
(an undrawn box bottom would be 419; clip at 360) — one number from two independent derivations.
⇒ **`CalendarTaskEditorDialog.qml:32-33` is TRUE of the layout.** R040's "73px" and R041's "39px" were both
readings of the *clip line*, never of the box. 仍差 #3 is retired as a phantom.

**C. The real defect, measured → fixed → reverted.** `CalendarTaskEditorDialog.qml:182-184` claims "the attached
scrollbar"; only the **event** editor has one (`EventEditorDialog.qml:268-281`, P03: `AsNeeded`, 6px, no track,
`blackSeed`@0.40/0.30 — its own comment names the symptom "a clipped form reads as scrollable instead of as a
rendering fault"). Ported verbatim (clean build, block at :189-203): **narrow works** — thumb `(23,23,23)` at
x 553–555 travelling y 126..311 (`contentY=0`) → 173..358 (max); **renders 3px wide, not the declared 6** — but
**wide REGRESSES**: `r052-wide-0006.png` carries a **permanent dark line at x 723–725, y 162..477**, while the
pre-change cross-section of `r041-taskdialog-dark.png` at y=300, x 718–736 is **constant (38,38,38)**. `AsNeeded`
cannot hide it: the **wide form is scrollable by a few px**, so `size` < 1 and a near-full-length thumb is painted
on a **D11-PASS** surface. Reverted (`git checkout --`, `git diff` empty, rebuilt); re-shot the reverted build and
the x 548..562 @y300 cross-section is uniform again, the unscrolled profile reproduces R041's numbers exactly
(151/191/232/276/323..360/396/433/470) and B still holds.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. Measured over four transitions (R043–R045): enter = page steps 255→204 in one frame with the card
   still at α=0.00; exit = 204→255 in one frame with the card still at α=1.00. App-wide. Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **NEW (was #3's real defect, R052): the task editor's form has no scroll affordance at 760x540, and the wide
   form is a few px too tall.** At 760x540 the form scrolls 59px but **wheel-only** — the user sees the notes box
   amputated mid-box with no hint (the event editor's P03 bar exists precisely for this, its comment says so).
   Porting P03 fixes the narrow case but paints a permanent 3px line at x 723–725 at 1100x692, because the wide
   form *is* scrollable: `AsNeeded` never hides a bar whose `size` < 1. Root order matters — **first make the wide
   form fit (contentHeight ≤ height at 1100x692), then port P03**. Acceptance numbers are already measured
   (see Next round #1). The **event editor carries the same latent mark** ⇒ decide whether to fix both.
4. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day
   21px, all fixed, no duration→height code path), while the ref's week view *does* show proportional top-aligned
   blocks ⇒ decide reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
5. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never
   checked vs ref. `buttonNeutralHover`/`Pressed` never captured; **no button has ever been hovered**. Also open
   from R045: the disabled footer button's accent→disabled blend animates (~0.69 → 0.63 over 52ms).
6. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it.
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3 fixtures; the
   `calendar.ics:91` VTODO (due 11:00) is dropped silently. Needs a ruling.
8. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`
   measured). Same family as #7. Needs a ruling.
- *Cosmetic, no ID, folded out of the top-8 (in rounds.md):* D02's radius is **16** vs the spec's named
  `largeRadius` 24 / `windowCornerRadius` 32 — recommendation stands: **keep 16**.

## 最近已改 (most recent 8)
1. R052 — **attempted** port of the event editor's P03 overlay scrollbar into `CalendarTaskEditorDialog.qml`,
   measured (works narrow, **regresses wide**), **REVERTED**; ships no net code change. Retires 仍差 #3 as a
   phantom with static + live proof, and files its real defect as new #3.
2. R051 — measurement + judgment only, no code change; P01 dark narrow leg PASS ⇒ P01 CLOSED (4 legs).
   Corrected R047's dot colour (accent blue, not green).
3. R050 — measurement only; P01 narrow leg PASS (light); the popover is immune to the dialog finding.
4. R049 — measurement only; E03 clause 3 **BLOCKED on a ruling**; new 仍差 #8.
5. R048 — measurement only; **E03 clauses 1+2 PASS**.
6. R047 — measurement only; **P01 long-text dark leg PASS**.
7. R046 — measurement only; **P01 long-text light PASS**; ref confirmed to contain **no popover**.
8. R045 — measurement only; exit re-measured ⇒ **≈125ms = declared `motionFast` 120**; D10 full pass.

## 外推待确认 (do NOT assume)
- **A clipped box is NOT a resized box.** In a dialog the form's viewport floor at 760x540 is **y=360/361**; a form
  element that reaches it is clipped there. **A rounded-corner bottom + a lower fill-run width = a real box end; a
  full-width fill that stops dead = the clip line.** Never read a clipped box's visible height as its height.
- **The dialog form scrolls RIGIDLY.** One wheel-down translates *every* form element by the same Δ (−59px at
  760x540 after max scroll) and never moves the footer. **If two form elements move by different Δ, that IS
  compression** — that test, not a single box's height, is the compression detector.
- **The notes viewport is 96px (97 with borders) at 760x540, 1100x692, light and dark.** A different notes height
  means a different field, not a smaller window.
- **The task dialog's form right edge at 1100x692: x 723–725 at y=300 is `(38,38,38)` with no bar.** A dark
  `(23,23,23)` column there = the P03 overlay bar (a regression), **not** a border — field borders read *lighter*
  than the card (`(65,66,67)`), never darker. Same cross-section at 760x540: the bar sits at x 553–555.
- **The P03 overlay bar renders 3px wide, not the declared 6**, and its thumb ≈185px of a 237px track ⇒ `size`
  ≈0.78 at 760x540.
- **`ScrollBar.AsNeeded` does NOT hide a bar whose `size` < 1.** A few px of content overshoot = a permanently
  visible near-full-length bar. **Measure `contentHeight ≤ height` before attaching any bar.**
- **Scroll range is self-checking:** at 760x540 it is **59px** and the undrawn notes-box bottom would be at 419 vs
  the clip at 360 — the same 59. If those two disagree, one of the two probes is wrong.
- **The task dialog's 4 form rows are NOT compressible in practice** — h 31/31/31 at both window sizes; the card
  clamp is `min(380, w−48)` × `min(560, h−64)` (`:21-22`) and is the only thing that shrinks with the window.
- **Harness `windowWheel` = `{action:"windowWheel", x, y, angleY}`**; `resize` = `{width,height}`; `openItem` =
  `{kind, titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`. Fields are FLAT.
- **`review-command.py` is not executable in this environment — invoke it as `python3 review-command.py '<json>'`.**
- **The popover's card geometry is window-size-invariant and content-driven** (P01, 4 legs): fill **340×188** for
  the "Long review…" fixture at 760x540 and 1100x692, light and dark. A *different* card height means a *different
  fixture* — the event (date+location+notes) is h≈186, the task "A deliberately long task title…" is h134.
  **Never explain a popover geometry change by window size.**
- **The status dot is 10×10 at card-relative (14,31), peak (48,140,198) accent blue, in BOTH themes** (R051).
  R047's "(57,196,135) green dot" does NOT reproduce — no green pixel exists in either dark frame.
- **Harness `openItem(NULL)` vertical centring does not reproduce at 760x540** (card top 226 + h188 ⇒ centre 320
  vs window centre 270); at 1100x692 it is exact in both themes. Harness-driven popover *position* is unjudgeable.
- **R041's "card centre sits +7px right of window centre" does NOT reproduce on the popover** (R050/R051: exact
  centring, gaps 210/210 and 380/380). Do not apply it to overlays.
- **`resize` does land, but `captureClient` returns the stale pre-resize buffer** ⇒ after any `resize`, capture
  with `nativeRecord`, not `captureClient`.
- **A live instance is reusable, but check its theme first.** `/proc/<pid>/environ` `KOS_APPEARANCE` is ground
  truth; `start-review-vm.sh` only *prints* "Owned review instance still running" and `exit 1`s, silently leaving a
  light instance in place for a dark round. Kill by the pid **read from `live-app.pid`** — never
  `pkill -f 'kos-calendar'` (matches the driving shell; exit 144). A reverted rebuild requires a **kill+relaunch**:
  the running process keeps the old binary.
- **`nativeRecord` frames land in the app's CWD**, which is *wherever `start-review-vm.sh` was invoked from* —
  the repo root if launched from there, `tmp/ui-acceptance/calendar/` if launched from there. Check both.
- **Month-view geometry (R049, 1100x692 light).** Row pitch **60.7px**; day-number ink tops
  **y 165/226/287/348/408**; chip fill band **y 183 → 200 (h 18)**; chip x-runs **(6,148) (164,305) (321,463)
  (636,778) (794,935)** ⇒ pitch **157.5**, chip w **143**, gap **16**. Selected-day rect **x 473 → 626** (w 154).
- **Month chip fill is per-list tinted, NOT the week chip's uniform (216,234,245)**: measured **(241,247,251)** and
  **(222,236,246)**. Locate a month chip by *shape/position*, not fill. The month grid draws **no cell borders**.
- **`CalendarScheduleView.qml` line numbers drift** (~+6 since R048). Timed chip now **`:394`/`:395`**, all-day chip
  `:277`, hour row `:353`. **Re-anchor by content, never by an earlier round's line number.**
- **There is no third "agenda" view.** Week and day are the *same* `CalendarScheduleView` with `dayCount` 7 vs 1
  (`Main.qml:2502` / `:2532`).
- **The ref is the Week view** (`Day|Week|Month|Year`, Week active): all-day row stacks up to **3** chips per day
  column; timed blocks are **duration-proportional and top-aligned**; red `9:41` now-line.
- **Per-day segmentation of a multi-day event is correct, not a defect** (ref does the same; no spanning bar).
- **The week view has NO duration-proportional blocks.** Every timed chip is `Layout.preferredHeight: 21`.
- **Week-grid geometry: vertical rules at x = 52, 201.5, 351.5, 501.5, 651.5, 801.5, 951.5** (pitch 149.5) at
  1100x692. Chips inset 3px ⇒ 144 wide. Chip fill light **(216,234,245)**. Hour-row pitch ≈ 54px.
- **`ElideRight` here emits a literal `…`, not a fade** — three dots at pitch 3px. Confirm by column min-lum
  profile, not by eye at 1x.
- **A cell renders at most 2 chips in the schedule view** (`slice(0, 2)`) and **at most 1 in the month view**.
  Three long fixtures collide on 2026-04-02 11:00; the `calendar.ics:91` VTODO is silently dropped.
- **`openItem` centres the popover; it does NOT anchor it.** `Main.qml:1314` → `openAt(null)`;
  `EventDetailsPopover.qml:258-277` null branch. **Never judge popover position from a harness-driven open.**
- **P01/E03 are judged against HIG convention, not the ref** where the ref has no such surface. The ref has **no
  popover**; it *does* show row elision with a trailing `…`.
- **The popover header is dot → title → `closeButton` (22×22, `objectName:"detailsClose"`), `:96-125`.** The ✕
  sits 20px inside the card's right edge at both window sizes and both themes.
- **`EventDetailsPopover.qml:57` is `width: 340 + 2*shadowInset`**, height content-driven, notes in a
  `Layout.maximumHeight: 120` ScrollView (`:171-174`) — this is *why* P01 passes.
- **The `EventDetailsPopover` qsTr source is English (`"Edit"`, `:224`) but the VM renders `编辑`.** Not a bug.
- **The secondary line left-aligns to the status dot (x = fill+14), not to the title (fill+32).** Expected.
- **`openItem` alone raises the *popover*, not the Dialog** — no dim, page stays 255. The Dialog requires
  `pointerObject detailsEdit` **move, press, release** (three commands).
- **A fresh enter needs an app restart** after `escape` (the day-view selection is not restored).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`). Wrapping it in
  `timeout 180` kills the app.
- **`captureClient` key is `path`**, not `file`; **`capture` is NOT a harness action.**
- **The α probe is the instrument of record.** Backdrop per point from the last *undimmed* frame, ×0.8;
  α = (m − backdrop)/(247 − backdrop). Pill left edge is only a ±0.14 cross-check.
- **Frame pacing degrades under capture load, reported timing does not.** Use the *discrete* dim step
  (204↔255 at (1040,400) light) as the t0 anchor.
- **In-place write only** to `command.json` (atomic replace trips the QML dir watcher). `review-command.py '<json>'`
  does it, and auto-increments `sequence`. Poll is `interval:100`.
- **`nativeRecord` is the burst mechanism**: `{action,prefix,duration,interval}` → `<prefix>-NNNN.png`.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark.**
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)) — locate a light
  field box by its **border** (222,224,226) only.
- **The popover's fill is `#F5F5F5` light / `#262626` dark — NOT the editor dialogs' `#F7F7F7`.**
- **D02's radius is 16**, not 24. **D03's fill is `#F7F7F7`**, not `cardSurface`.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
- The task dialog's footer buttons are **full-width stacked** — not macOS's content-sized right-aligned row.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6.
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34.**
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**. `pointerObject` needs THREE commands: `move`, `press`, `release`.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `long-label.py` is the *sidebar list* fixture (S05), currently "Inbox".
- Save is deliberately NOT exercised (isolated-profile discipline).
- **`tmp/` is gitignored.** The committable artifact is a mirror under **`docs/ui-calendar/`**: copy the
  screenshot in and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md` /
  `rounds.md` can never be committed — expected, not a failure.

## Next round (pick ONLY #1)
**#1 — make the wide task-dialog form fit, then port the P03 bar (this is new 仍差 #3).** Two steps in one
atomic change, in `apps/calendar/qml/CalendarTaskEditorDialog.qml` only:
(a) **Measure first, do not guess:** at 1100x692 the form's `contentHeight` exceeds the Flickable's `height` by a
few px (proved indirectly — the ported `AsNeeded` bar stayed visible with a near-full-length thumb). Determine the
overshoot and remove it (the form's bottom inset/margin) so `contentHeight ≤ height` at 1100x692.
(b) Then port the event editor's P03 block (`EventEditorDialog.qml:268-281`) verbatim into `editorScroll`.
**Acceptance, already-measured numbers:** at **1100x692** the cross-section at y=300, x 723–725 must stay
**`(38,38,38)`** (pre-change value; a `(23,23,23)` column = the bar is still showing ⇒ FAIL); at **760x540** a
`(23,23,23)` thumb must appear at **x 553–555** and travel the track between `contentY=0` and max scroll
(measured extremes: y 126..311 → 173..358). The reverted-state baselines to not regress are the R041 values:
field bands 151/191/232, hint 276..284, notes box 323..360, footer 396/433/470. **Do not touch the popover**
(P01 CLOSED) and do not change the notes-area `ScrollBar.vertical` at `:373`.

**#2 — 仍差 #5: capture `KosButton` hover / pressed / focus in both themes** (no ruling needed; the ref's
`buttonNeutralHover`/`Pressed` have never been shot and no button has ever been hovered). Continuous frames
required for the hover/disabled transitions.

**#3+ — everything else in 仍差 needs a ruling** (#1 dim snap, #2 shadow, #4 E03 clause 3, #7/#8 per-cell caps).
