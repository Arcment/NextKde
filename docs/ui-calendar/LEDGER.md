# R048 — **E03 row elision, week view: clauses 1+2 PASS measured; clause 3 not judgeable there** (2026-10-16)

## 本轮 (R048)
Atomic step: Next round #1 of R047 = **E03, the long title's *row* elision, week view first**. Measurement +
judgment only, **no product code touched, no build**.

Route, light, one restart: `date 2026-04-02` → `view week` → `captureClient r048-week.png` (1100x692).

**Declared criterion first** (`CalendarScheduleView.qml`): all-day chip (`:292`) and timed chip (`:413`) are a
`Label` with `anchors.fill: parent`, **`leftMargin: 5` / `rightMargin: 4`**, `font.pixelSize: 9`,
`verticalAlignment: VCenter`, **`elide: Text.ElideRight`**. Chips are fixed **`Layout.preferredHeight: 21`**
(`:389`); a cell renders **`cellItems.slice(0, 2)`** (`:388`; all-day `:270`); a trailing
`Item { Layout.fillHeight: true }` (`:428`) top-packs the cell.

**Grid geometry measured:** vertical rules at y 165..470 sit at **x = 52, 201.5, 351.5, 501.5, 651.5, 801.5,
951.5** ⇒ column pitch **149.5**; chips inset **3px** ⇒ **144 wide**; chip fill light **(216,234,245)**; hour-row
pitch ≈ **54px**.

| # | E03 clause | verdict | evidence |
|---|---|---|---|
| 1 | short blocks show **one readable priority line** | **PASS** | every chip is one line, VCentered, no wrap, colour-coded by list (six columns checked) |
| 2 | long titles **elide inside bounds** | **PASS (2 measurements)** | below |
| 3 | **tall blocks top align** | **NOT JUDGEABLE HERE** | `:389` fixes every chip at 21px ⇒ the week view has **no duration-proportional block** to test. Not a pass, not a fail — deferred. **E03 stays PENDING.** |

**Clause 2, Latin — 周一 30 · 11:00** ("Long review with a deliberately lengthy title"). Chip x **55→198**; ink
**61→192**; text-box left declared 60 (first ink 61 ✓), text-box right declared **194** ⇒ last ink **192**, *2px
inside the declared box, 6px clear of the chip edge*. Tail is a literal **`…`**: three dark dots at **x 186 / 189 /
192**, **pitch 3px**, min-lum 77 — not a fade, not a hard clip; no ink at 194–198 (fill 213–222), 199–200 white
gutter.

**Clause 2, CJK — 周四 2 · 11:00 second chip** ("[R019 LONG TASK] 任务长标题…"). Chip x **505→648**, ink
**511→641**; `…` dots at **634 / 637 / 640**; limit 644 ⇒ inside. The glyph **immediately before** the dots is a
**complete** CJK box (**625–632**, 8px, clean fill gap at 633) ⇒ **no mid-glyph clip, no ellipsis-over-glyph
overlap** — the failure mode CJK elision usually has.

**New observation, NOT filed as an E03 defect (仍差 #9):** `slice(0, 2)` silently caps a cell at two chips with no
`+N`. On 2026-04-02 11:00 the fixtures hold **three** items (the "Long review…" event, the VTODO at
`calendar.ics:91` due `20260402T110000`, and the VTODO at `:287`) and the cell renders **two** — the `:91` VTODO is
dropped with no trace. E03's text covers elision, not overflow ⇒ needs a ruling, not a silent fix.

**Instrument note:** `ElideRight` emits a literal `…`, not a gradient fade, and at 9px the dots read as *faint
grey* even in a 4x NEAREST zoom — **confirm elision by column min-lum profile** (dark minima at 3px pitch), never by
eye alone. Sampling a chip's interior must avoid the text rows (a row 1px off the chip's bottom edge reads as white
and silently invalidates a scan).

# R046 — **P01's long-text sub-case re-judged after 21 rounds: PASS**, light, measured (2026-10-16)

## 本轮 (R046)
Atomic step: Next round #1 of R045 = re-judge **P01 (long text)** — the last ID in 仍差 whose fixtures were
restored at R025 and never re-judged. **Measurement + judgment only, no product code touched.**

**Premise corrected.** R045's plan guessed "the long title is a *week*-view row". **P01's subject is the detail
popover** (`spec.md:54` — "Detail popover neutral surface, light border/soft shadow; clear title/time/location/
notes hierarchy"); the *row* elision is **E03** ("long titles elide inside bounds"). So the popover was judged.
Fixture confirmed in place: `profile/pim/calendar.ics:91` `SUMMARY:A deliberately long task title to inspect
elision`, a VTODO due 2026-04-02T11:00. `long-label.py` (the S05 *sidebar list* long name) is a different
fixture and is currently **restored to "Inbox"** — it was not needed here.

Route, light, one leg: `date 2026-04-02` → `view day` → `captureClient` (row) → `openItem {kind:"todo",
titleContains:"deliberately long"}` → `captureClient` (popover). Diff bbox between the two frames =
(368,266,732,428) — the popover and nothing else.

**Result: PASS on every P01 clause, numbers below.** `EventDetailsPopover.qml` — surface `#F5F5F5` (`:20`),
radius 12 (`:86`), border 1px `rgba(0,0,0,0.12)` (`:21-22`, `:88-89`), shadowInset 14 (`:30`), content width
340 (`:56-57`), padding 14 (`:58`).

| property | declared | measured |
|---|---|---|
| card (surface box) | 340 wide | **x 380→719 = 340**; y 278→413 = **136** ⇒ matches the declared column stack to 1px |
| fill | `#F5F5F5` | **(245,245,245) exactly** |
| border | `rgba(0,0,0,0.12)` | 1px at x=380/719 reading (172,172,172) — the border composite *on the shadow's own edge* (172/0.88 = 195.5 ⇒ shadow α≈0.23 there) |
| shadow | `#40000000`, radius 14, inset 14 | gradient visible x 368→379 (≈12px) and below the card to y≈424 |
| title | 15px DemiBold, `#1A1A1A`, WordWrap, **max 3 lines**, ElideRight | **2 lines**, cap-top rows 297–314 / 319–333, **pitch 22px**, darkest pixel **(26,26,26)** = `#1A1A1A` exactly |
| secondary | 12px `rgba(0,0,0,0.55)` | darkest **(116,113,114)** vs predicted 110 (AA-lightened) ✓ |
| status dot | 10×10, radius 5, list colour | **10×10 at x 394–403, y 309–318**, colour **(57,196,135)** |
| Edit pill | h 26, right-aligned to content | **44×24 at x 660–703, y 375–398**; right edge 703 vs content limit 705 |

**The long-text question answered.** Line 1 spans x **412→635**, line 2 **413→516**. The content right limit is
`719 − 14 = 705`. So the title **wraps at a word boundary, needs only 2 of its 3 allowed lines, and finishes
70px short of the edge — no ellipsis, no clipping, no overflow.** Position is consistent with the declared
`RowLayout`: fill+14 = 395 → dot 10 → spacing 8 → title at 413 (measured 412/413), and the secondary line
left-aligns to the *dot* (measured x 395), not the title. Hierarchy reads title (15 DemiBold, `#1A1A1A`) >
secondary (12, 0.55) > action pill — P01's "clear hierarchy" clause is satisfied by pixel, not by eye alone.

**Three recorded observations, none filed as a defect:**
1. **Line pitch 22px for a 15px font (1.47)** is looser than macOS's ~1.2. Root cause is the CJK-capable font
   stack's default leading — the *same* mechanism already recorded as `controlHeight` rendering 31 vs 34.
   App-wide, not popover-specific. New 仍差 #8.
2. **`.loop/refs/macos-calendar.png` contains no popover at all** (814x522 month view + sidebar; verified this
   round). So P01 is a **HIG-convention** match like D01/D02/D03/D06/D07/D10 — **not** a reference-pixel match,
   and no ref-derived number exists to judge it against. It does show the row convention: macOS elides row
   titles with a trailing `…` ("Antonio…", "April Fool…", "Status…"). Relevant to **E03**, not P01.
3. **Do not read anything into the popover's screen position.** `openItem` → `Main.qml:1314 itemDetails.showItem`
   → `openAt(null)` (`EventDetailsPopover.qml:258-277`), whose `null` branch **centres** the popover. Measured
   x 380 / y 278 are exactly `(1100−340−28)/2 + 14` and `(692−164)/2 + 14` — the centring arithmetic, to the
   pixel. A real click passes a point instead. Harness artifact, **not** a defect; recorded in 外推.

**One dead end, recorded:** the long task's **row is not on screen** at the day view's default scroll position —
`crop-row.png` over x 340–760, y 240–450 is empty grid (bands + lines only; the popover floats over it because
of the centring above). Judging E03's row elision therefore needs a **scroll** to the 11:00 slot first; it is
**not** covered by this round's evidence and is filed as Next round #2.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`, so it can only be on/off. **Measured on four transitions (R043 enter, R044-c60, R044-c12,
   R045 exit)**: enter = page steps 255→204 in one frame with the card still at α=0.00; exit = page steps
   204→255 in one frame with the card still at α=1.00. App-wide (every workspace dialog). Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **Form compresses instead of scrolling at 760x540** (R041-corrected): notes viewport **96 → 39px**, card
   555 → 471. `CalendarTaskEditorDialog.qml:32-33` claims "only the form above it scrolls". App-wide sibling: the
   event editor shares the shape. Same class as #1 (comment says one thing, layout another).
4. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16.
5. Card centre sits **+7px right** of window centre at both window sizes, both themes (R041). Cosmetic.
   (Not re-measured this round; the popover's centre read −0.5px, which is the centring arithmetic, not #5.)
6. **P01 long-text is CLOSED (this round, light, PASS).** Still un-re-judged inside P01: **dark** and
   **narrow-window** popover. O01–O03 tooltip, O08/X07 four-overlay coordination, E03 row elision.
7. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never
   checked vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered.
8. NEW/observed: **line pitch 22px at font 15 = 1.47** (R046) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it. Also still open from R045: the
   disabled footer button's accent→disabled colour blend animates (~0.69 → 0.63 over 52ms) — recorded so a
   pill-based α probe is not fooled again.

## 最近已改 (most recent 8)
1. R046 — measurement + judgment only, **no code change**; **P01 long-text → PASS** (card 340×136 at 380,278,
   fill (245,245,245), title 2 lines x 412→635 vs limit 705, `#1A1A1A` exact, dot 10×10 (57,196,135), pill
   44×24); ref confirmed to contain **no popover**; `openAt(null)` centring identified as a harness artifact.
2. R045 — measurement only, no code change; exit re-measured at honest sampling ⇒ **≈125ms = declared
   `motionFast` 120**; R042's 240ms excluded by 6 grey levels; D10 full pass; probe moved to uniform-bar
   underlay (α resolution 0.125 → 0.032).
3. R044 — measurement only, no code change; enter = **220ms at both interval 60 and 12** (declared
   `motionNormal`); R043's 440ms does not reproduce; five-point calibrated α probe introduced.
4. R043 — measurement only, no code change; enter ⇒ 2× declared (later refuted by R044); dim snap structurally
   confirmed; `args`→flat command schema trap documented.
5. R042 — measurement only, no code change; D10 exit **scale** → PASS (0.971 vs 0.9728 declared), 仍差 #5 closed.
6. R041 — measurement only, no code change; dark task-dialog footer → PASS, 仍差 #6 closed; light≡dark layout
   established; R040's narrow notes number corrected 73 → 39px.
7. R040 — measurement only, no code change; D11 → PASS; `nativeRecord`-across-resize recipe established.
8. R039 — measurement only, no code change; D10 `KosDialog` enter half → PASS, dim-snap escalated.

## 外推待确认 (do NOT assume)
- **`openItem` centres the popover; it does NOT anchor it.** `Main.qml:1314` → `openAt(null)`;
  `EventDetailsPopover.qml:258-277`'s `null` branch sets x = (host.w − root.w)/2 clamped, same for y. Measured
  x 380 / y 278 = that arithmetic exactly (root.w = 340+2·14, root.h = 136+2·14). **Never judge popover
  position from a harness-driven open** — only its material, content and hierarchy. A real click passes a point.
- **P01 is judged against HIG convention, not against the ref.** `.loop/refs/macos-calendar.png` (814x522) is a
  month view + sidebar with **no popover** (verified R046). Same class as D01/D02/D03/D06/D07/D10. The ref *does*
  show row elision with a trailing `…` ("Antonio…", "April Fool…", "Status…") — that is **E03**'s target.
- **The `EventDetailsPopover` qsTr source is English (`"Edit"`, `EventDetailsPopover.qml:224`) but the VM renders
  `编辑`.** Translations are live in the review profile. Do not report a source/render label mismatch as a bug.
- **The secondary line left-aligns to the status dot (x = fill+14), not to the title (x = fill+32).** Title sits
  at fill+14+10+8 = 32 because it is the second child of a `RowLayout` (`:96-117`). Expected, not a defect.
- **`openItem` alone raises the *popover*, not the Dialog** — no dim, page stays 255. The Dialog (and its dim,
  and `revealProgress`) requires `pointerObject detailsEdit` **move, press, release** (three commands) after it.
- **A fresh enter needs an app restart.** After `escape` the day-view selection is gone; the route does NOT
  restore it: `date`/`view`/`date`/`openItem` leaves `detailsEdit` resolving to (682,376) with `found:true` for
  move/press/release, but the click is **inert**. Restart via `start-review-vm.sh light`; `kill` the pid in
  `live-app.pid` first **by content — never `pkill -f 'kos-calendar'`: that pattern matches the driving shell
  itself** and kills the tool call (exit 144).
- **`captureClient` works pre-resize and returns a fresh frame** (R046: two calls 6s apart over DIFFERENT states
  gave different md5s at identical byte size 3050463 — **equal file size is NOT evidence of a stale buffer;
  compare md5, not `ls -la`**). It still returns a stale 1100x692 buffer *after* a resize, reproduced 5×.
- **The α probe is the instrument of record.** Backdrop must be measured per point from the last *undimmed*
  frame and scaled ×0.8; α = (m − backdrop)/(247 − backdrop). Self-checks: α=1.00 while α=1 is expected, α=0.00
  at the end. The pill left edge is only a ±0.14-in-p resolution cross-check, never the primary read.
- **Frame pacing degrades under capture load, reported timing does not.** R045 ex2 deltas during the animation:
  82 → 36 → 50 → 48 → 35 → 53ms (≈50ms, 2 samples inside a 125ms window) and still fits 125ms. Prefer a
  *discrete* event (the dim 204↔255 step) as the t0 anchor — it brackets t0 to one frame regardless of pacing.
- **Harness command fields are FLAT** (`Main.qml:217/221/225`): `command.date`, `command.view`, `command.kind`,
  `command.titleContains`. **`args` nesting is a silent no-op that still advances `sequence`** — it looks like it
  ran. Verified: `review-command.py` passes a JSON array through verbatim.
- **`nativeRecord` frame paths resolve against the app's CWD, which is the CWD of whoever ran
  `start-review-vm.sh`.** Launching it from `tmp/ui-acceptance/calendar/` produced **94 frames with
  `"saved":false`** and no error — the only tell is `"saved":false`. Prefixes assume repo root: start from there.
- **The recorder is wall-clock** (`Main.qml:24`, `Date.now() − nativeRecordStarted`) behind a QML `Timer`
  (`:19-22`) whose blocking `capture()` (`:36`) starves the loop. Poll timer for `command.json` is `interval:100`
  (`:98-100`), so command latency is 0–100ms; in-place write only (an atomic replace trips the QML dir watcher).
- **The dim gone ⇒ page 255, present ⇒ 204** at (1040,400) in light (0.20). A genuine discontinuity no clock
  error can manufacture; it is the most reliable **t0 anchor** for a dialog transition, in *both* directions.
- **`pointerObject` needs THREE commands, one per event: `kind` ∈ {`move`,`press`,`release`}.** There is no
  `events` array — `harness/Main.qml:131-135` forwards `command.kind` to `ReviewInput.cpp:67`. A single call with
  an unknown/absent kind silently sends one `MouseMove` (`.cpp:73` initialises `type = MouseMove`) and closes
  nothing.
- **`capture` is NOT a harness action.** It falls through to the manual branch (`harness/Main.qml:249`) and
  prints only `contentY/width/height/contentHeight` — **it saves nothing**. Use `captureClient` or `nativeRecord`.
- **`nativeRecord` is the burst mechanism** (`harness/Main.qml:112-121`): `{action:"nativeRecord", prefix,
  duration, interval}` → `<prefix>-NNNN.png`. Reported `duration` = requested + one interval; real spacing
  ≈ interval + ~21ms idle, up to ~62ms under animation load, ~60ms flat at interval 60.
- **Frames track `resize`, `captureClient` does not** (R040/R041): burst first, resize second, read frame 3+.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark** — not KosDialog, not the calendar
  app. `CalendarTaskEditorDialog.qml:8` extends `KosWorkspaceDialog`.
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)). Locate a light
  field box by its **border** (222,224,226) only; fill-based probes over-reach (this is how R040 got 73px).
- **The popover's fill is `#F5F5F5` (245,245,245) — NOT the editor dialogs' `#F7F7F7`.** Two different neutrals;
  do not carry a measurement from one to the other (R046 confirms the popover's at (245,245,245) exactly).
- **D02's radius is 16**, not 24 (`smallRadius + 4`, both dialogs). **D03's fill is `#F7F7F7`**, not
  `cardSurface` — deliberate P02 override, identical in both dialogs.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion`
  (`:26`, false here). **No duration scale exists in AppTheme.** `KosDialog.qml:10-11` — the *only* animated
  properties are `opacity`/`scale` via `revealProgress`; exit = `AppTheme.motionFast` + **InCubic** (`:24-32`).
- The task dialog's footer buttons are **full-width stacked** (保存 accent pill spans x 384–730, centre 557;
  取消 below it) — not macOS's content-sized right-aligned row. Already recorded as a HIG-convention match.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6. Unresolved which D06 is
  judged against. macOS alerts have no third action; our Delete row extrapolates "destructive goes last".
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:171` × densityScale ≈0.912 ⇒ 31).
  Same CJK-leading mechanism as 仍差 #8.
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  The long-title task is at `:91`, a VTODO due **2026-04-02T11:00**. `long-label.py` is the *sidebar list*
  fixture (S05) and is currently restored to "Inbox".
- Save is deliberately NOT exercised (isolated-profile discipline).

## Next round (pick ONLY #1)
**Judgement split in two — P01's long-text PASS is light-only, and the day view was never scrolled to the row.**

**#1 — Finish P01 long-text: the *dark* leg (same route, one restart, no code change).**
- `start-review-vm.sh dark`; kill the pid in `live-app.pid` **by content** first (never `pkill -f 'kos-calendar'`).
- Route: `date 2026-04-02` → `view day` → `openItem {kind:"todo", titleContains:"deliberately long"}` →
  `captureClient`. **One capture of the popover only** — do not re-capture the row, it is empty at this scroll.
- Expected per source: surface `#262626` (`:20`), border `rgba(1,1,1,0.12)` (`:21-22`), title `#F2F2F2` (`:23`),
  secondary `rgba(1,1,1,0.58)` (`:24`). **Measure, do not assume** — report the four hex/rgb values and the title
  line count (expect 2) and right edge (expect ≈635).
- If all four match and the title still wraps to 2 lines inside the content limit, **P01's long-text sub-case is
  CLOSED on both themes**; say PASS with the numbers. If dark deviates, file the exact rect + the two colours.

**#2 (after #1) — E03's row elision, which R045's plan wrongly attributed to P01.** Needs a **scroll** to the
11:00 slot in the day view (and the week view, where the ref's `…` convention is actually visible) **before**
capturing; the default scroll position shows empty grid. Judge against the ref's own convention: does the row
title end in a trailing `…` at the row edge, or clip/overflow? `EventRow`'s declared `elide`/`maximumLineCount`
is the thing to read first (`grep -n elide`), then confirm by eye.
