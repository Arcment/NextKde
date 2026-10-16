## R092 — R091's fix is verified in the DARK leg: two fresh dark legs are **0 px** apart whole-page.

**No code change.** R091 changed one binding path in the timeline's reposition trigger
(`CalendarScheduleView.qml:276`), and its acceptance pair ran light only — a dark leg has its own launch (the theme is
fixed at launch), so the fix's dark side was unverified. `leg.sh dark r091e` / `leg.sh dark r091f`:

- **`contentY` reads `240` in BOTH legs' `stop` probe** (`contentHeight 960`, `width 1102`) — the R091 instrument.
- **Whole-page `ImageChops.difference`, threshold >6 RGB-sum: 0 differing pixels, 0 contiguous y-runs.** The md5s still
  differ (`45d86358…` vs `4916f52e…`) while the pixels do not — the R083/R091 rule re-confirmed a third time: PNG bytes
  are not the instrument.
- **Non-vacuous**: the Mon column (x52..202) does carry 4 timed chips in both legs — reading the saturated bar at x60,
  the runs are `317..332 / 359..370 / 397..412 / 437..452` **identically in both legs**. (x58/x63 miss the `359..370`
  run, the short 10:15 chip — the bar is 4 px wide at x59..62, so an x60 read is the right instrument.)
- **The 0 px is a true structural zero, not a masked one**: the driven week is 2026-03-30..04-06 while "today" is
  2026-10-17 ⇒ `todayColumn = -1` ⇒ **no now-line is drawn at all**, not even the faint rule (`px(400,63) = (30,30,30)`,
  the pure field). So no time-dependent ink can hide a difference. R085's dark faint-rule ΔL 7.4 is therefore NOT
  exercised by this pair — it needs a week containing today; expect a non-zero pair there.

Figure `r092-dark-zero-diff.png` (leg E). **Scope: pixels only. No chip, band, grid, token or fixture was touched, so
A04 / E01 / E02 / N02 evidence stands unchanged.**

## R091 — the "initial-scroll race" is the 450 ms `autoScrollTimer` WINDOW, not PIM arrival. Fixed.

**Reproduced on the unmodified build.** Two fresh light legs (`leg.sh light r091a` / `r091b`): the whole-page diff is
**154,551 px — R090's own number** — and one chip's left bar sits 40 px lower in one leg (Mon x60 `280..290` vs `320..330`).
**But both legs' trailing `{"action":"stop"}` probe reads `contentY 240`** (`harness/Main.qml:263` logs the pre-command
value) — the scroll is NOT the variable.

**What actually differs is *when* the capture landed.** Grid lines and gutter-label ink bands are at identical y in both;
the *text* of the labels is one hour apart (topmost `07:00` vs `06:00`) and the chips follow the labels, i.e. the capture
shows the PREVIOUS week's offset (`280` = hour 7, the empty-week fallback — the launch week 2026-10-12..18 carries no
fixture items) while the probe 0.6 s later shows the settled `240`. Figure `r091-pre-fix-one-hour-offset.png`.

**Mechanism:** `positionTimeline()` was reachable only through `autoScrollTimer` (`interval 450`); the drive list's
`captureClient` lands ~0.6 s after `date`, so it can fall *inside* that window. **R090's "PIM arrival race" is a
misdiagnosis of this window** — no model-empty run is needed to explain the pair, and the timer never races PIM here.

**Fix (`CalendarScheduleView.qml:276`):** `repositionTimeline()` = `positionTimeline()` immediately **+** the timer as a
settle-net, wired to `onFirstDateChanged` / `onDayCountChanged` / `onVisibleChanged`. No chip, band, grid or token changed.

**After:** `leg.sh light r091c` / `r091d` → chip bars identical in both legs (**Mon x60 `320..330`**, Sat x660 `320..330`)
and a **whole-page diff of 0 px**. (The two PNGs still have different md5s — 0 differing pixels prove PNG bytes are not
the instrument, R083 re-confirmed.) A04 / E01 / E02 / N02 untouched.

*2026-10-17*

# R090 — **regression leg came back DIRTY: the two legs are one `hourHeight` (40 px) apart in initial scroll. Not a content regression — a startup RACE. No code changed.**

**The finding (new, live): the initial scroll is a race with PIM arrival.** `capture-r089.png` md5 `2029858ad5e3afb429d3cfd0bf8aa6f8`
vs `capture-r090.png` md5 `e947d8a55aba4450e5cc231b9305d860` — whole-page diff **154,551 px in 15 runs over the whole grid**, not the expected
now-line band. Gutter labels and hour lines sit at the **same absolute y** in both (row means 237.0/244.0 identical at y234/254/274/294 —
`hourHeight` 40 ⇒ a 40 px scroll maps both sets onto themselves) while **every timed chip bar moved exactly −40 px** (Mon x60
`319..330` → `279..290`). Root cause in source: `CalendarScheduleView.qml:244 usefulStartHour()` returned **6** in r089 (earliest timed item
08:00 ⇒ 8−2, `contentY 240`) and **7** in r090 = its **hard-coded fallback**, i.e. it ran against an empty model (`contentY 280`). Caller
`positionTimeline()` (`:270`) is fired by `autoScrollTimer` (`:283-289`, `interval 450`) which re-arms on firstDate/dayCount/visible but
**never on model population** ⇒ win the race → 06:00, lose it → 07:00, one hour of empty grid above the first chip. **This is why every
regression leg from here on is nondeterministic until it is fixed** — and it is the next round's single subject.

**The regression answer, recovered (viewport-clamped realignment).** r089 screen `274..691` ↔ r090 screen `234..651` (= same content) ⇒
**450 px, ONE run at r089 y664..691 (bottom 28 rows, maxrow 55)** = a realignment boundary artifact. Non-scrolling zone y0..233 = header +
all-day band ⇒ **163 px, confined to y38..60 x35..75 = the sidebar-toggle glyph's AA**. ⇒ **The band's 3 chips + `+2`, all four band rules,
every hour/half-hour line, every gutter label and every timed chip are byte-identical. R088+R089 stay independently regression-verified;
A04 remains PASS.** Figure `docs/ui-calendar/r090-scroll-race.png`. (2026-10-17)

## ## 本轮 (R090)
Atomic step: **the regression leg the plan called for.** ONE capture (`leg.sh light r090`), then the whole-page diff. It came back dirty, so
the round's deliverable became the **diagnosis** (measured −40 px, then grep → `usefulStartHour` → the 450 ms timer never re-arming on the
model) plus the **recovered containment proof** by realigning within the viewport. **No code was touched** — the fix is a second thing and
belongs to R091. ~21 Bash (2 legs-worth of driving but only 1 launch, 4 measurement scripts, 1 fixture/log grep, 1 source grep+sed, 2 doc writes).
**`code-writer` is still NOT registered** (agent list: claude / Explore / general-purpose / Plan / statusline-setup); implementer/test role was
me, R072–R090 precedent — **do not retry it each round.** The R087 fixture (4 all-day items on Thu, 1 on Fri) is **still live**.

## The chip-ink hoist (R089, structural — read this before touching a chip)
**`inkColor` reached its THIRD consumer** (timedChip R079, allDayChip R080, the band's `+N` row R089), so the rule now lives **once** at
`CalendarScheduleView.qml`'s root as **`chipInk(item)`**; both chip delegates are `readonly property color inkColor: root.chipInk(modelData)`.
**If a fourth consumer appears, call `root.chipInk(item)`; do not inline the expression again.**

## E01/E02 + N02 status (unchanged R077–R089)
Timed chip — **bar PASS (R077), no border PASS (R078), dark same-hue ink PASS (R079)**. Band chip — **ink PASS (R080)**.
**The band chip's ring icon is MEASURED (R081) but NOT built — blocked on ruling H** (ring 16 vertical-ratio vs 22 horizontal). **R089's hoist
is binding-equivalent (whole-page diff) ⇒ R080's regression evidence stands.** **N02 — line + dot + pill PASS on the light leg (R084) AND the
dark leg (R085).** Open residue: the **dark faint rule's ΔL is half the light leg's** (7.4 vs 15.5) — a theme fact, **not a defect**.
**N02's today header disc CLOSED R086** (22 px, the ref's own diameter).

## 仍差 (top 7, visual-impact order)
1. **THE INITIAL SCROLL IS A RACE (NEW, R090) — the only *defect* in this list that is neither cosmetic nor ruling-blocked.** Losing the race
   to PIM arrival drops the view on the hard-coded hour 7 instead of the first event's hour − 2. Fix = make `positionTimeline()` re-run when
   the model populates (or bind it), so `usefulStartHour()` is always evaluated against data. **Blocks every future regression leg until fixed.**
   Source: `CalendarScheduleView.qml:244` / `:270` / `:283-289`.
2. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole 6,
   inset 3 from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px right of
   the ring's outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family**
   (stroke ~1.5, hole ~9) on the neutral-248 chips. **Do NOT build either until H is answered.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right
   edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
6. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day before it
   can be reproduced at all** (the live fixture is a week-view fixture). **The only remaining `slice(0, 2)` with a content cap** (`:689` is
   the grid hour cell — no ref counter-example either). **Note the band's own cap is now gone (R089); this is the last one.**
7. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on
   **ruling G**. Do not chase without a ruling.
- **CLOSED in R089: 仍差 #1 (old) / A04 step 2 — the band's silent overflow.** Spec-only (no ref anchor); the `+2` row is a HIG-convention
  design call, proved contained by the whole-page diff. **A04 is now fully PASS.**
- **CLOSED in R088: A04 step 1 — the band's 2-item cap.** Ref-anchored and byte-contained.
- **CLOSED in R087: A02 — "the all-day band expands uniformly".** A **ref-satisfied-for-height** clause, not a defect.
- **CLOSED in R086: the today header disc's size.** 20 → **22 px** (`radius 11`); "×1.33 ⇒ 29" withdrawn.
- *Cosmetic / settled, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius
  **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on the
  viewport top (R066; scroll artifact). Band-chip fill alpha ref **0.16** vs ours **0.17** (R080) — not worth a round.

## ## 最近已改 (most recent 8)
1. R090 — **verdict + diagnosis, NO code changed**: the regression leg is one `hourHeight` off; root cause = the initial-scroll race in
   `usefulStartHour()`/`autoScrollTimer`; containment recovered by viewport-clamped realignment (see 外推).
2. R089 — **A04 step 2**: band `ColumnLayout` → `id: allDayStack` + `allDayOverflow`/`allDayVisible`; Repeater model
   `slice(0, allDayStack.allDayVisible)`; trailing `+N` `Label`; chip ink hoisted to root **`chipInk(item)`** (3rd consumer).
2. R088 — **A04 step 1**: `:454 slice(0, 2)` → `slice(0, root.allDayBandRows)` + a 2-line comment.
3. R087 — **verdict + fixture, NO code changed**: 3 all-day VEVENTs added ⇒ **Thu = 4 all-day items**; ref band re-measured ⇒ A02 closes, A04 opens.
4. R086 — **the header date mark**: `width/height/radius` `20/20/10` → **`22/22/11`** on the shared today/selected disc.
5. R085 — **verdict only, NO code changed**: N02's dark leg captured; pill 42×20 at x4..45, fill `(229,72,77)` both themes.
6. R083 — **`Main.qml`**: `itemStableId(item)` + the sort comparator's tie fallback (UID, then title) ⇒ the all-day tie order is total.
7. R082 — **verdict only**: the Thu band-chip order swap is **run-to-run**, not theme-dependent; mechanism = equal `DTSTART` ties.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A CROSS-LEG WHOLE-PAGE DIFF MUST FIRST MEASURE THE SCROLL OFFSET, OR IT REPORTS A ONE-HOUR SHIFT AS A 154k-PIXEL REGRESSION (R090).**
  The launcher's `contentY` is `usefulStartHour() * hourHeight` and **`hourHeight` equals the hour-line pitch (40)** ⇒ a 40 px scroll offset
  **leaves every hour line, half-hour line and gutter label at the same absolute y** while moving every chip. So the tell is not the lines —
  it is **one chip's bar y** (scan a chip's saturated left bar in a fixed column; `319..330` vs `279..290` = exactly −40). **Recipe:**
  (1) read one chip bar in each leg; (2) if they differ by k·40, realign **viewport-clamped** — r089 screen `(274..691)` ↔ r090 screen
  `(234..651)`, i.e. floor to the viewport top on BOTH sides, **never by pasting whole images** (that drags the *fixed* all-day band into the
  scrolled comparison and invents a 57k-px run at y155..245); (3) the residual is the answer.
- **THE INITIAL SCROLL IS A RACE WITH PIM ARRIVAL (R090).** `usefulStartHour()` (`CalendarScheduleView.qml:244`) returns `earliest − 2`, and
  `7` when the model is still empty; it is called by `positionTimeline()` (`:270`) from `autoScrollTimer` (`:283-289`, `interval 450`) which
  re-arms on `firstDate`/`dayCount`/`visible` **but not on model population**. ⇒ **two same-theme legs can legitimately land on different
  hours, and a "the view starts at 07:00" report is this, not a layout bug.** Also: the *fallback* is what the user sees whenever the model is
  slow, so "the view opens one hour above the first chip" is a real defect, not just a test artifact.
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS THE CHEAPEST REGRESSION PROOF (R088).** Threshold per pixel at
  **>6 RGB-sum** (kills AA), then group the differing rows into contiguous y-runs and read each run's x-range. It returned
  **"exactly one run, y207..230, x503..650"** for a one-line change — a *containment* proof that "the four rules didn't move" cannot give.
  Use it whenever a change is supposed to touch one region. **Caveat: the now-line moves with wall-clock, so two legs more than ~1.5 min
  apart can differ at y≈303 for no content reason** (R085/R083) — check the run's x-range: a now-line artifact is full-width, a content
  change is column-bounded.
- **THE REF ALL-DAY BAND DOES NOT EXPAND WITH ITS ROW COUNT (R087).** All 7 ref columns share **one uniform 3-row strip** while carrying
  **0, 1, 2 and 3** chips; bottom separator y183-184 row-mean **217.0 constant over x250..810**. ⇒ **any "the band should grow/shrink per
  column" claim is spec-only.** **A band that is 3 slots tall must RENDER 3 — a cap below the slot count is a pure defect (now fixed,
  R088).** The ref-anchored way a **4th+** item is handled is **not visible in this image**; the ref never exceeds 3 ⇒ **A04 step 2 has no
  ref anchor and must be labelled spec-only.**
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the
  ref's (522→692) and our grid pitch 1.48× (27→40), **but our type is at the ref's own physical size**: gutter-label ink **9 = 9**, day-number
  ink in the disc **9 = 9**. So "ref 22 × 1.33 = 29" overshot by 30%. **The instrument: measure one text ink height in both images with the
  same threshold (digits are cleanest); if it is 1:1, every size anchored to that text is 1:1 too.** Corollary: our header row is 36 tall vs
  the ref's ~28 — a *layout* difference, not a licence to inflate the type or the disc inside it.
- **THE CURRENT-TIME OBJECT IS FOUR PARTS WITH ONE GEOMETRY SOURCE (R084).** `nowRow` / `nowInHour` / `nowLineY` / `nowLabel` /
  `todayColumn` / `nowLabelClearance` at `CalendarScheduleView.qml`'s root. **Do not re-derive a y per part.**
- **OUR NOW-LINE, MEASURED (R084, light 1100x692, `contentY 0`):** pill **42×20 at x4..45**; **line 2px at y303-304**; strong segment =
  today's column **802..951** `(229,72,77)`; faint `(252,236,237)` (= 0.10 alpha) across **52..1101**; **dot 9px centred x=802**. **Column
  boundaries are 52/202/352/502/652/802/952/1102** — `dayColumnWidth = (1102−52)/7 = 150`. Sat 17 ⇒ 802..951.
- **THE DARK FAINT RULE IS HALF THE LIGHT ONE IN LUMINANCE — A THEME FACT, NOT A BUG (R085).** Same 0.10 alpha, but the blend runs toward
  opposite poles: light `(252,236,237)` vs white ⇒ **ΔL 15.5**; dark `(50,34,35)` vs (30,30,30) ⇒ **ΔL 7.4**. ⇒ **never judge a faint
  overlay's presence by eye in either theme — take the row mean over an empty span against a control row 4 px away.**
- **THE REF'S NOW-LINE IS CONTINUOUS ACROSS THE WHOLE WEEK (R084)** — a green chip sat under it. ⇒ **a faint overlay over a coloured chip is
  indistinguishable from a tint by eye: sample a known-empty column too.** **THE REF'S PILL DROPS THE HOUR LABEL IT COLLIDES WITH (R084)**
  (9AM ink survives, 10AM gone) ⇒ ours hides a label when `|label tick − nowLineY| ≤ 14`, and only when `todayColumn >= 0`.
- **A CURRENT-TIME CAPTURE NEEDS `position contentY` (R084).** The launcher opens at hour 7 (`usefulStartHour()`). Drive
  `{"action":"position","contentY":0}` (`harness/Main.qml:263`) before the capture; the log prints the **pre-command** `contentY`.
- **AN EQUAL-START TIE IS NOW DECIDED BY US, AND THE KEY IS THE UID (R083).** `Main.qml`'s sort falls back to `itemStableId` (record
  `seriesId` = the VEVENT UID, then `id`) then `itemTitle` — a **total order**. **Any "same-time items are in the wrong order" report: read
  this line.** No ref anchor exists for the winner; it is a *stability* choice.
- **TWO SAME-THEME LAUNCHES CAN BE PIXEL-IDENTICAL INSIDE A REGION AND STILL HAVE DIFFERENT md5s (R083)** — the now-line moves with
  wall-clock. ⇒ **never treat a differing md5 as evidence of a content difference; diff the region.** (R088: the md5 *did* change and the
  diff named the one changed run in a single call — that is the pair of facts to quote.)
- **THE BAND CHIP'S ICON IS A 12x12 RING, INSET 3 FROM THE CHIP'S FILL (R081).** Outer **12**, **stroke 3**, **hole 6**, vertically centred
  (fill 18 ⇒ 3/3), outer left edge **3 px right of the fill's left edge**, **colour = `itemColor`, full saturation, no alpha**. Text ink
  starts **17-19 ref px** right of the ring's outer-left edge ⇒ **ours @x1.33: 16 / stroke 4 / inset 4 / text at fill_left + 28**. The ring
  is **not a stripe** — R077's x491-493 read was this ring's left arc.
- **THE REF HAS TWO RING WEIGHTS AND THE RULE IS UNKNOWN (R081).** Stroke **3 / hole 6** on the tinted-wash chips; stroke **~1.5 / hole ~9**
  on the **neutral-248** chips. ⇒ **record the correlation only, never encode a rule off it.** Needs ruling H first.
- **OUR SCALE IS ANISOTROPIC: x1.33 VERTICAL, x1.83 HORIZONTAL (R081).** Any circular or square icon must pick one axis — **use the vertical
  ratio for anything that must fit the 24-px row**; the horizontal one only for things that span the column (e.g. R077's stripe width).
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Measured on **five** ref colours, all **1:2 on every
  channel**, plus nine of our chips in both legs. ⇒ **any future "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`.** Corollary: the
  *dark* leg is the ref's rule mirrored, not a ref measurement — **dark chip colours are extrapolation** and must be labelled as such.
- **IN A CHIP, THE RING ICON'S COLOUR IS THE ITEM COLOUR (R080).** ⇒ **when the band icon is built, its colour is `itemColor(item)` with no
  `withAlpha`.**
- **AN INK IS SETTLED BY THE COVERAGE TEST PLUS THE B−R GAP (R079/R080).** `t = (fill − pixel)/(fill − ink)` must agree per channel (±0.05);
  **the exact discriminator is a channel gap the fill cannot reach.** **THE HULL FAILS AS AN INK INSTRUMENT (R079, re-confirmed R080/R083)** —
  never read an ink off the extreme pixel; **R083's top-5%-coverage MEAN is the reproducible scalar.**
- **THE REF'S ALL-DAY BAND HAS TWO CHIP FAMILIES, AND ONE IS UNEXPLAINED (R080).** (a) *Coloured*: same-hue wash + same-hue ink at 1:2 +
  same-hue ring. (b) *Neutral*: fill **248**, ink **(38,38,38)** — a pair that **cannot** be `itemColor`/`itemColor/2` — while the **ring** is
  strongly coloured. **Do not cite the neutral chips for any ink or fill rule.**
- **A CROSS-ROUND PNG IS NOT POSITION-ALIGNED (R079, strengthened R082/R083).** **R083's refinement: the layout map and, for a same-theme
  pair, even the content can be pixel-stable — but MEASURE it per region, never assume; the file hash is not the instrument.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. ⇒ kill the pid from `live-app.pid`, keep the launcher's stderr, check the pid changed.
  **`leg.sh <theme> <name>` does the whole leg (kill, launch, sleep 30, one flat drive list, md5, capture flag) in one call.**
- **A CHIP EDGE CAN ONLY PROVE "NO BORDER" IF IT DOES NOT ABUT A RULE (R078).** Read a **top or bottom** edge as a RAW profile and check
  monotonicity — a real border is a row darker *and* more saturated than the fill; a corner/AA row is *lighter*.
- **THE REF BAR IS AN ABSOLUTE STROKE, NOT A FRACTION OF THE CHIP (R077).** 2.4 ref px on both an 11 px and a 22 px chip ⇒ ours stays
  `chipHeight/4` = 4 **regardless of duration**. Use the horizontal scale for its width (×1.85 on the column).
- **OUR `timedChip` GEOMETRY AFTER R079/R080 (light 1100x692):** chip = column + 3; **fill 505-508, bar 509-512** (4 px, capsule), text ink
  from **518**. Light fill `(216,234,245)`, dark fill `(36,69,90)`, bar `(48,140,198)` both. **Our chip calendar colours are NOT the ref's**:
  blue **(48,140,198)** / green **(57,196,135)** / gold **(215,166,44)**.
- **OUR `allDayChip` AFTER R080 (re-confirmed R088):** fill `withAlpha(itemColor, dark ? 0.32 : 0.17)` — light blue **(220,236,246)**, dark
  **(35,65,83)**; ink halfway to the pole — light **(24,70,99)**, dark **(152,198,227)**. **Band rows 157-180 / 182-205 / 207-230** (gap 1,
  inset 1, height 24, per R088's corrected geometry); band chip inset 1 ⇒ fills 53..200 / 203..350 / 353..500 / 503..650…; Label
  `leftMargin: 5`. **R083: the Thu band region is byte-reproducible across two same-theme launches.** **R089: the model is
  `slice(0, allDayStack.allDayVisible)` — 3 chips when a column holds ≤3 items, else 2 chips + a `+N` row; there is no cap left to hit.**
- **THE BAND'S OVERFLOW ROW IS A SPEC-ONLY FORM, AND ITS GEOMETRY IS THE CHIP SLOT'S (R089).** When a column exceeds `allDayBandRows`,
  `allDayStack.allDayVisible = allDayBandRows − 1` and the last slot renders `"+" + allDayOverflow` — **plain `root.chipInk(hidden item)`
  ink on the band's own background, NO fill, `leftPadding: 5`, `font.pixelSize: 9`, height bound to `allDayRowHeight`** so the slot's
  rectangle is a chip's rectangle. Measured: Thu slot 3 = y207..230, x503..650 (the whole-page diff's single run). **The ref's 7 columns
  carry ≤3 chips ⇒ NO ref anchor exists for `+N`'s form, its ink, or whether it should be `+N` at all — label every future change here
  spec-only.** The `+N`'s ink is taken from the **first hidden** item; no rule in the ref or the HIG fixes that choice.
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076)** ⇒ **A03's clause has no ref anchor; say "spec-only".**
- **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The record's end is the **inclusive last day**.
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** ⇒ if the R074 separators are
  ever removed, A03's rendering collapses back into "one pill per day". **The two changes are a pair.**
- **`itemRecord` IS AN INJECTED PROPERTY ON `CalendarScheduleView` (R076)**, bound in `Main.qml`'s two schedule views. A view that omits it
  gets `({})` ⇒ every chip fully rounded. Any *new* schedule-view instance must bind it or silently lose A03.
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R088).** Corner: per-row **fill-start inset**. Joint: per-row
  **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw
  profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap argument**, and for a
  cross-capture comparison the **top-5%-coverage mean**. Ordering/content: **a per-column deviation-from-fill profile rendered as an ASCII
  ramp string**; a word-space GAP in it gives the word-length signature. **R087: for "does the layout respond to content", the cheapest
  decisive instrument is a NEW FIXTURE plus a row-mean scan of one populated and one empty column — and the answer was in the *source*
  (`slice(0, 2)`) before it was in the pixels, so grep the model expression the moment a count looks wrong. R088: then prove containment
  with the whole-page diff-count above, not with a rule-position re-read.**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT filename**;
  **always read the success flag in `live-runtime-vm.log`** and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`; measured y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237).
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R088.** `sectionRule` **y=155** (242 light / 39 dark,
  1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap
  **181**, **182-205**, gap 206, **207-230**. **Net +28 vs R070 — the grid has permanently lost ~28px of viewport.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**;
  top rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217), **row-mean constant 217.0 over x250..810 ⇒ shared bottom edge**;
  **inset ≈1 both legs**; content **125..182 = 58**; band total **60**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink =
  itemColor/2**; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**. **R087: all 7 columns live in the SAME 3-row strip and
  carry 0/1/2/3 chips — the band never expands.** Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 / separators present / hue ink — every
  *form* item matched **except the icon (仍差 #2)**; capacity now matches too (R088).
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**; span = its column's
  full width minus ~1 px each side. Fill = light desaturated same-hue wash (blue (222,237,254), red (251,228,227)); **text = dark same-hue =
  the bar at 1:2** (R079); **left bar 2.4 px, ~3 px in, round caps**; **no border/ring on any edge** (R078). Ours: fill
  `withAlpha(itemColor, .19 light / .36 dark)`, ink halfway to the pole, bar done, border deleted. Ref chip ink starts **7 ref px** in from
  the fill edge; ours: chip = column + 3, text ink from column + 16.
- **REF EVENT CHIP COLOUR IDIOM (R063/R075/R077/R079/R080).** Light desaturated same-hue fill + dark same-hue text + saturated same-hue
  left bar (timed) or ring icon (band) + small radius. **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are
  HIG+token-anchored only. The ref's tinted chips carry their icon at the LEFT INSIDE EDGE ⇒ **crop the *second* chip row for a clean
  corner, or read the numeric profile instead.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R088):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51; separators at
  **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×150px delegates starting at 52. Columns **Mon 30 · Tue 31 ·
  Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5** (locale week starts Monday) ⇒ **weekend = the last two**; the band's right rim is on Sun's right
  edge (x=1102) and is clipped at 1100. **R087/R088 fixture day: Thu Apr 2 (x502..651) = 4 all-day items ⇒ 3 chips; Fri Apr 3 (x652..801)
  = 1.**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark
  white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule`
  (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` has ZERO consumers in this view.** Requirement is the ORDERING: ref 242 < 237 <
  217; ours light 242 < 237 < 217, dark 39 < 59 < 84. `gridLineMinor` is a **half-hour line**, a different role. **R074: `gridLine` is
  consumed by THREE things — the grid's top/left/right edges AND the band's column separators.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with `Layout.fillWidth: true`
  ⇒ full window width. **R068: the top boundary spans identically.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right edge; the right
  rim is drawn only by `columnIndex === root.dayCount`.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark; the gutter
  is NOT tinted. The all-day band shares the column's fill.** (R088: a row-mean over a Sat/Sun span reads 249 and never dips below the
  250 threshold — a weekend span looks like "one continuous band"; check the fill, not just the threshold.)
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical centring via
  `-Math.round(implicitHeight/2)`. **A gutter scan must start at x ≥ 3** or the x=0 rim merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**.
  Half-hour line = `Math.round(parent.height / 2)` = **20**. **R072 added the four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`;
  R079 `timedChip.inkColor`; R080 `allDayChip.inkColor` — the same expression twice. R088 the band model. R083 added `Main.qml:itemStableId`.
  If a third consumer of the ink expression appears, hoist it, do not copy it.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar + mini
  calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 =
  **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns, 1px separators at
  x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the
  contract says 40; 40 was chosen). Hour lines and vertical separators are both **1px (237,237,237)**. Gutter label (ref x 215..238):
  digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge 238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue
  31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R088).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`, `position{contentY}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is
  a JSON list**, bumps `sequence` itself, writes **in place** (never `os.replace`). The whole drive list in ONE invocation works fine.
- **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it. **It EXITS 1 without launching if
  `live-app.pid` still points at a live `kos-calendar` (R079)** — kill that pid first (never `pkill`), keep the launcher's stderr, check the
  pid changed. A rebuilt binary needs a **kill+relaunch**; ~24 s to the new pid. Include `resize 1100x692`; it starts in `--view week
  --date 2026-10-15`, so every drive list must re-send `view week` + the date. **The theme is fixed at launch — a dark leg costs a full
  kill+relaunch.** **App stderr goes to `live-runtime-vm.log`** — read the capture flags there. **`leg.sh <theme> <name>` does the whole leg
  in one call (R082); three legs fit one round comfortably (R083).**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root
  `calendar-fixture.ics` is **stale, no VTODOs** — do not edit it): VEVENTs Morning planning 08:00 / Short appointment 10:15 / **Long review
  with a deliberately lengthy title** 11:00 / **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`** all-day strip
  with **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`** ⇒ **Mon 30 · Tue 31 · Wed 1 render as ONE chip each with an
  identical row mean (R088: 203.576 three times), and Thursday does NOT carry it.** **R087 ADDED**: `R087 card C` and `R087 card D`
  (`…r087-allday-c/-d`, both `20260402`) and `R087 sole` (`…-e`, `20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.**
  Pre-R087 Apr 2 held exactly 2 (`Design sync` `…r072-allday-a`, `Release notes` `…-b`), UID-ordered since R083 ⇒ **Thu's order is
  `Design sync` / `Release notes` / `R087 card C` / (`R087 card D`, hidden)**. VTODOs (kind `"todo"`): `[UI] Green planning` 09:00,
  `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK]
  任务长标题与编辑表单检查`**. **The rendered week also shows `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist` — re-read the ICS
  before predicting a cell's contents.**
- **Row-band measurement idiom (R046/R062–R088):** scan the target column (or row) for pixels that are **not** the background, threshold,
  group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to
  find horizontal lines. **Caveats:** keep the window strictly inside the region; the separator and the first hour line can be **adjacent
  rows** (R088 saw sep 232-233 and hour line 234 merge into one group at threshold 250 — read the full-width row means to split them); the
  x=0 rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact — **but a row-mean over a
  *populated* grid is poisoned by chips, so find hour lines in an empty column instead.** **R070: a VERTICAL profile of one empty column is
  decisive for a per-column property.** **R071: fix the column map first.** **R072: a vertical profile also catches a LAYOUT defect.**
  **R074: the same run-scan at the band row AND the grid row proves "now matches" in one call.** **R075: for a CORNER, per-row fill-start
  inset.** **R076: for a JOINT, the per-row `!= white` envelope.** **R077: for a STRIPE, a saturation run-scan whose width is constant over
  the full height; a classified 2D ASCII dump is the cheapest way to see an icon you were told was a stripe.** **R078: for a BORDER, a raw
  RGB profile across an edge that abuts no rule.** **R079: for an INK, the coverage test — dark leg scans for the BRIGHTEST text pixels.
  R080: add the channel-gap check and use `Counter` modes for the fill. R082: for CONTENT IDENTITY across captures, a max-deviation-from-fill
  profile per column as an ASCII ramp string. R083: the same ramp exposes word boundaries; the top-5%-coverage mean is the reproducible ink
  scalar. R087: for "does layout respond to content", new fixture + a row-mean scan of one populated and one empty column — and grep the
  model expression first. R088: for REGRESSION/containment, the whole-page diff-count.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert `im.size` first.
  **A composite (1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read.** **R076: label the rows in the
  composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.**
  **R078: a ×6 `NEAREST` edge crop is right for "is there a 1px ring" — back it with raw numbers.** **R080: a `Counter` mode over a cell
  gives the fill in one call.** **R082/R083: a ×3 `LANCZOS` stacked composite with a black label bar per leg is the whole verdict in ONE
  image read. R083 caveat: a ×3 LANCZOS upscale can make two IDENTICAL inks *look* different across stacked panels — confirm with numbers.
  R087: a ×2 `LANCZOS` two-panel stack at each panel's own 1:1 scale is enough for "how many rows / where is the shared edge". R088: for
  "how many chips and what do they say", a ×3 `LANCZOS` crop of just the two columns under test + a black label bar is enough to read the
  chip TEXT, which is the only way to tell "3rd chip present" from "+N present".**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## ## Next round (pick ONLY #1)
**#1 — fix the initial-scroll race (R090's finding). ONE atomic change in `CalendarScheduleView.qml`.** Today the only thing that calls
`positionTimeline()` is `autoScrollTimer`, armed 450 ms after `firstDate`/`dayCount`/`visible` change and **never re-armed when the model
populates** (`:283-289`). Target behaviour: `usefulStartHour()` is evaluated **after** the day's items exist, so a launched Apr-2 week always
lands on `contentY = 6 * 40 = 240` (first chip `Morning planning` 08:00 ⇒ 8−2), never on the `7` fallback. Smallest candidates, in order:
(a) also re-arm `autoScrollTimer` on the model's count/rows changes; (b) have `positionTimeline()` mark itself "positioned" and re-run once
when the model first becomes non-empty; (c) drop the `7` fallback so an empty model cannot masquerade as "hour 7 is the answer". **Do not
change `hourHeight`, the band, or any chip** — this is one binding/timer change. **Acceptance, and it must be measured, not eyeballed:**
two consecutive fresh light legs (`leg.sh light r091a` / `r091b`) must produce the **same chip-bar y** (the R090 tell: scan a chip's
saturated left bar in the Mon column, x≈60) and a whole-page diff ≈0 outside the header-icon AA (163 px, y38..60 x35..75) — **no 40 px
offset, no 154k px**. If two legs still disagree, that is the finding, and the residual re-frames the round.
**Then (unlocked, ref-anchored, one per round):** nothing ref-anchored and unblocked remains in the all-day/grid track — the band icon needs
ruling H, 仍差 #3 ruling F, #4 ruling A, #5 ruling B, #6 ruling D + a month fixture, #7 ruling G. The next best unblocked step after the race is
to build the band-chip RING ICON if ruling H has been answered (fully measured in R081).

**Blocked on rulings A–H:** the **band icon (H, R081 — measured, needs only the ruling and one decision: 16 vs 22)**, dim snap (A),
shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month `slice(0,2)` / 1-chip cap (D — also needs
a 3-all-day-item *month* day), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the ref's measured
1**. **The `code-writer` subagent is NOT registered in this session** — R072–R089's edits were made directly; do not retry `code-writer`
each round. **Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04 fully
PASS — step 1 R088 ref-anchored, step 2 R089 spec-only + byte-contained, and R090's realigned leg re-confirmed the band (3 chips +
`+2`), all four band rules, the hour lines, the gutter labels and every timed chip as byte-identical**; **E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080);
**N02 closed on both legs (R085)**; **A02 closed R087**; everything else PENDING or ruling-blocked. **R089's only chip-code change was the
binding-equivalent ink hoist ⇒ R080's chip regression evidence still stands, and the whole-page diff says so in pixels.**)
