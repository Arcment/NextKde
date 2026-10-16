# R093 — M04 colour: the mini month's today disc, blue → `AppTheme.todayRed`

The mini month drew today in `root.tahoe.accent` (`#0088FF` = (0,136,255)) — the **one** place in the app where "today" was
not red. The ref's today red is one red app-wide (**pill and now-line row (235,76,70)**; mini disc **(207,51,35)**, 15x15 at
x91..105/y395..409), and our own week header disc / now-line / now-dot / time pill are all `#E5484D` (229,72,77).

**Fix:** hoisted `#E5484D` into `AppTheme.todayRed` (`shared/qml/foundation/AppTheme.qml`), repointed
`CalendarScheduleView.qml:111` at it (same value), and pointed `Main.qml:2204` at it. Exactly one literal left.

**Evidence** (light 1100x692, `view week` + `date 2026-10-15` + `sidebar expanded`) — `r093-mini-today-red.png`:
- mini today disc (Oct 17, Sat) **20x20 at x156..175/y597..616, fill (229,72,77)**, white numeral.
- control: week header today disc still **21x22 at x928..948/y126..147 = (229,72,77)** ⇒ the two markers now agree.
- build clean: `ninja -C .build/calendar-review kos-calendar kos-pim-service` 15/15.

**Still open (仍差 #7):** disc **20 px vs the ref's 15** (mini row pitch ours ≈25.4 vs ref ≈26.7 ⇒ ~1:1) — next round.
**Ruling H still unanswered** (no rulings channel exists in the tree) ⇒ the all-day band ring icon was **not** built.
**Instrument note:** the app launches with the sidebar **collapsed** — R082–R092's legs contained no mini calendar at all;
any sidebar evidence needs `{"action":"sidebar","expanded":true}`.

# R092 — R091's fix is **verified in the DARK leg**: two fresh dark legs are **0 px** apart whole-page. Verdict only, NO code changed.

**Why it was needed:** R091 changed one binding path (`CalendarScheduleView.qml:276`) but its acceptance pair ran **light only**,
and a dark leg is a separate launch (the theme is fixed at launch) ⇒ the fix's dark side was unverified.

**`leg.sh dark r091e` / `leg.sh dark r091f` — all three assertions pass:**
- **(b) `contentY` reads `240` in BOTH `stop` probes** (`contentHeight 960`, `width 1102`) — the R091 instrument.
- **(c) whole-page `ImageChops.difference` at >6 RGB-sum: 0 differing px, 0 contiguous y-runs.** md5s still differ
  (`45d86358…` / `4916f52e…`) while the pixels do not — R083/R091's rule, third confirmation. **PNG bytes are not the instrument.**
- **(a) non-vacuous:** Mon (x52..202) carries 4 timed chips in both legs; the saturated bar read at **x60** gives runs
  `317..332 / 359..370 / 397..412 / 437..452` — **identical in both**. (The bar is 4 px at x59..62; x58/x63 miss the
  `359..370` short 10:15 chip, so x60 is the right read.)

**The 0 px is a TRUE structural zero, not a masked one.** Driven week 2026-03-30..04-06 vs today 2026-10-17 ⇒ `todayColumn = -1`
⇒ **no now-line is drawn at all, not even the faint rule** (`px(400,63) = (30,30,30)`, the pure field) ⇒ no time-dependent ink can
hide a difference. **Corollary: R085's dark faint-rule ΔL 7.4 is NOT exercised by this pair — it needs a week containing today.**
Figure `docs/ui-calendar/r092-dark-zero-diff.png`. Scope: pixels only; no chip, band, grid, token or fixture touched.

## ## 本轮 (R092)
Atomic step: **close Next-round #1 (R091's dark-leg regression).** Two dark legs + one whole-page diff + one bar-position read +
one now-line probe = ~8 Bash. **`code-writer` is still NOT registered** (agent list: claude / Explore / general-purpose / Plan /
statusline-setup); R072–R092's work was done directly — **do not retry it each round.** The R087 fixture (4 all-day items on Thu,
1 on Fri) is **still live**. `leg.sh` still carries the trailing `stop` probe (tmp/, not committable).

## The chip-ink hoist (R089, structural — read this before touching a chip)
**`inkColor` reached its THIRD consumer** (timedChip R079, allDayChip R080, the band's `+N` row R089), so the rule now lives **once**
at `CalendarScheduleView.qml`'s root as **`chipInk(item)`**; both chip delegates are `readonly property color inkColor:
root.chipInk(modelData)`. **If a fourth consumer appears, call `root.chipInk(item)`; do not inline the expression again.**

## E01/E02 + N02 status (unchanged R077–R092)
Timed chip — **bar PASS (R077), no border PASS (R078), dark same-hue ink PASS (R079)**. Band chip — **ink PASS (R080)**.
**The band chip's ring icon is MEASURED (R081) but NOT built — blocked on ruling H** (ring 16 vertical-ratio vs 22 horizontal).
**R089's hoist is binding-equivalent (whole-page diff) ⇒ R080's regression evidence stands.** **N02 — line + dot + pill PASS on the
light leg (R084) AND the dark leg (R085).** Open residue: the **dark faint rule's ΔL is half the light leg's** (7.4 vs 15.5) — a theme
fact, **not a defect**. **N02's today header disc CLOSED R086** (22 px, the ref's own diameter).

## 仍差 (top 6, visual-impact order)
1. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole 6,
   inset 3 from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px right of
   the ring's outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family**
   (stroke ~1.5, hole ~9) on the neutral-248 chips. **Do NOT build either until H is answered.**
2. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right
   edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
3. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
4. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
5. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day before it
   can be reproduced at all** (the live fixture is a week-view fixture). **The only remaining `slice(0, 2)` with a content cap** (`:689` is
   the grid hour cell — no ref counter-example either). **The band's own cap is gone (R089); this is the last one.**
6. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on
   **ruling G**. Do not chase without a ruling.
- **CLOSED in R092: R091's fix holds in the DARK leg** — 0 px / 0 y-runs between two fresh dark legs, `contentY 240` in both probes,
  and the 0 is structural (no today column ⇒ no now-line ink at all). **R091's fix is now regression-covered on BOTH themes.**
- **CLOSED in R091: the initial-scroll nondeterminism** — fixed, and its mechanism re-stated (the 450 ms window, not PIM arrival). The
  154,551 px pair is gone: 0 px between two fresh light legs.
- **CLOSED in R089: 仍差 #1 (old) / A04 step 2 — the band's silent overflow.** Spec-only (no ref anchor); the `+2` row is a HIG-convention
  design call, proved contained by the whole-page diff. **A04 is now fully PASS.**
- **CLOSED in R088: A04 step 1 — the band's 2-item cap.** Ref-anchored and byte-contained.
- **CLOSED in R087: A02 — "the all-day band expands uniformly".** A **ref-satisfied-for-height** clause, not a defect.
- **CLOSED in R086: the today header disc's size.** 20 → **22 px** (`radius 11`); "×1.33 ⇒ 29" withdrawn.
- *Cosmetic / settled, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02
  radius **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line
  exactly on the viewport top (R066; scroll artifact). Band-chip fill alpha ref **0.16** vs ours **0.17** (R080) — not worth a round.

## ## 最近已改 (most recent 8)
0. R092 — **verdict only, NO code changed**: the dark leg was run as R091's missing acceptance half (`leg.sh dark r091e` / `r091f`).
   `contentY 240` both probes, whole-page diff **0 px**, Mon x60 bar runs identical, and the driven week carries no today ⇒ no
   now-line ⇒ a true structural zero. Figure `r092-dark-zero-diff.png`.
1. R091 — **`CalendarScheduleView.qml:276`**: `repositionTimeline()` (immediate `positionTimeline()` + `autoScrollTimer.restart()`)
   replaces the bare `autoScrollTimer.restart()` on firstDate/dayCount/visible ⇒ the 450 ms window that made two identical legs differ by
   one `hourHeight` is closed. Acceptance: two fresh light legs, **0 px** whole-page diff.
2. R090 — **verdict + diagnosis, NO code changed**: the regression leg was one `hourHeight` off (154,551 px); the accused mechanism
   (PIM-arrival race) is **corrected in R091** — the same pair is reproduced and is a capture-vs-450 ms-timer window.
3. R089 — **A04 step 2**: band `ColumnLayout` → `id: allDayStack` + `allDayOverflow`/`allDayVisible`; Repeater model
   `slice(0, allDayStack.allDayVisible)`; trailing `+N` `Label`; chip ink hoisted to root **`chipInk(item)`** (3rd consumer).
4. R088 — **A04 step 1**: `:454 slice(0, 2)` → `slice(0, root.allDayBandRows)` + a 2-line comment.
5. R087 — **verdict + fixture, NO code changed**: 3 all-day VEVENTs added ⇒ **Thu = 4 all-day items**; ref band re-measured ⇒ A02 closes, A04 opens.
6. R086 — **the header date mark**: `width/height/radius` `20/20/10` → **`22/22/11`** on the shared today/selected disc.
7. R085 — **verdict only, NO code changed**: N02's dark leg captured; pill 42×20 at x4..45, fill `(229,72,77)` both themes.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A LEG'S `contentY` IS NOW A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** The harness logs
  the **pre-command** `contentY`/`contentWidth`/`contentHeight` of the timeline for any timeline action (`harness/Main.qml:263`), and
  `stop` perturbs nothing. **The 2026-10-17 pair: the pixel diff said 154,551 px while the probe said `240` in BOTH legs** ⇒ the diff was
  a capture-window artifact. `contentHeight 960` = 24 h × 40. **Before blaming any binding, read the probe.**
- **THE OLD "ONE-HOUR SHIFT" TELL WAS THE REGRESSION ITSELF, NOT A MISALIGNMENT TO UNDO (R090's claim, corrected R091).** Do **not**
  viewport-realign two legs by hand to "recover" a clean diff — that hides the defect. A 40 px offset between two legs means the capture
  landed inside a delayed reposition (before R091) or a real regression; the decisive split is the `stop` probe: same `contentY` + different
  pixels = a *layout* difference, different `contentY` = a scroll difference. (R090's realigned "450 px run" conclusion is therefore
  **withdrawn as evidence**; A04's status rests on R088/R089 + R091's 0 px pair.)
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088, re-used R091).**
  Threshold per pixel at **>6 RGB-sum** (kills AA), group the differing rows into contiguous y-runs, read each run's x-range. R091 used it
  at both ends: the 154,551 px "runs over the whole grid" (the defect) and **0 px** (the fix). Caveat: a now-line artifact is full-width, a
  content change is column-bounded — and when the now-line's hour is scrolled **out** of the viewport the pair can be byte-clean.
- **THE REF ALL-DAY BAND DOES NOT EXPAND WITH ITS ROW COUNT (R087).** All 7 ref columns share **one uniform 3-row strip** while carrying
  **0, 1, 2 and 3** chips; bottom separator y183-184 row-mean **217.0 constant over x250..810**. ⇒ **any "the band should grow/shrink per
  column" claim is spec-only.** **A band that is 3 slots tall must RENDER 3 — a cap below the slot count is a pure defect (fixed R088).**
  The ref never exceeds 3 ⇒ **A04 step 2 has no ref anchor and must be labelled spec-only.**
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the
  ref's (522→692) and our grid pitch 1.48× (27→40), **but our type is at the ref's own physical size**: gutter-label ink **9 = 9**,
  day-number ink in the disc **9 = 9**. So "ref 22 × 1.33 = 29" overshot by 30%. **The instrument: measure one text ink height in both
  images with the same threshold (digits are cleanest); if it is 1:1, every size is 1:1 too.** Corollary: our header row is 36 tall vs the
  ref's ~28 — a *layout* difference, not a licence to inflate the type or the disc inside it.
- **THE CURRENT-TIME OBJECT IS FOUR PARTS WITH ONE GEOMETRY SOURCE (R084).** `nowRow` / `nowInHour` / `nowLineY` / `nowLabel` /
  `todayColumn` / `nowLabelClearance` at `CalendarScheduleView.qml`'s root. **Do not re-derive a y per part.**
- **OUR NOW-LINE, MEASURED (R084, light 1100x692, `contentY 0`):** pill **42×20 at x4..45**; **line 2px at y303-304**; strong segment =
  today's column **802..951** `(229,72,77)`; faint `(252,236,237)` (= 0.10 alpha) across **52..1101**; **dot 9px centred x=802**.
  **Column boundaries are 52/202/352/502/652/802/952/1102** — `dayColumnWidth = (1102−52)/7 = 150`.
- **THE DARK FAINT RULE IS HALF THE LIGHT ONE IN LUMINANCE — A THEME FACT, NOT A BUG (R085).** Same 0.10 alpha, opposite poles: light
  `(252,236,237)` vs white ⇒ **ΔL 15.5**; dark `(50,34,35)` vs (30,30,30) ⇒ **ΔL 7.4**. ⇒ **never judge a faint overlay by eye in either
  theme — take the row mean over an empty span against a control row 4 px away.**
- **THE REF'S NOW-LINE IS CONTINUOUS ACROSS THE WHOLE WEEK (R084)** — a green chip sat under it ⇒ **a faint overlay over a coloured chip is
  indistinguishable from a tint by eye: sample a known-empty column too.** **THE REF'S PILL DROPS THE HOUR LABEL IT COLLIDES WITH (R084)**
  (9AM ink survives, 10AM gone) ⇒ ours hides a label when `|label tick − nowLineY| ≤ 14`, and only when `todayColumn >= 0`.
- **A CURRENT-TIME CAPTURE NEEDS `position contentY` (R084).** The launcher opens at hour 7 (`usefulStartHour()`'s fallback — the launch
  week carries no fixture items). Drive `{"action":"position","contentY":0}` (`harness/Main.qml:263`) before the capture.
- **AN EQUAL-START TIE IS NOW DECIDED BY US, AND THE KEY IS THE UID (R083).** `Main.qml`'s sort falls back to `itemStableId` (record
  `seriesId` = the VEVENT UID, then `id`) then `itemTitle` — a **total order**. **Any "same-time items are in the wrong order" report:
  read this line.** No ref anchor exists for the winner; it is a *stability* choice.
- **TWO SAME-THEME LAUNCHES CAN HAVE DIFFERENT md5s AND 0 DIFFERING PIXELS (R083, re-confirmed R091).** ⇒ **never treat a differing md5 as
  evidence of a content difference; diff the region** (and now: read the `contentY` probe).
- **THE BAND CHIP'S ICON IS A 12x12 RING, INSET 3 FROM THE CHIP'S FILL (R081).** Outer **12**, **stroke 3**, **hole 6**, vertically
  centred (fill 18 ⇒ 3/3), outer left edge **3 px right of the fill's left edge**, **colour = `itemColor`, full saturation, no alpha**.
  Text ink starts **17-19 ref px** right of the ring's outer-left edge ⇒ **ours @x1.33: 16 / stroke 4 / inset 4 / text at fill_left + 28**.
  The ring is **not a stripe** — R077's x491-493 read was this ring's left arc.
- **THE REF HAS TWO RING WEIGHTS AND THE RULE IS UNKNOWN (R081).** Stroke **3 / hole 6** on the tinted-wash chips; stroke **~1.5 / hole ~9**
  on the **neutral-248** chips. ⇒ **record the correlation only, never encode a rule off it.** Needs ruling H first.
- **OUR SCALE IS ANISOTROPIC: x1.33 VERTICAL, x1.83 HORIZONTAL (R081).** Any circular or square icon must pick one axis — **use the
  vertical ratio for anything that must fit the 24-px row**; the horizontal one only for things that span the column.
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Measured on **five** ref colours, all **1:2 on every
  channel**, plus nine of our chips in both legs. ⇒ **any future "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`.** Corollary: the
  *dark* leg is the ref's rule mirrored, not a ref measurement — **dark chip colours are extrapolation** and must be labelled as such.
- **IN A CHIP, THE RING ICON'S COLOUR IS THE ITEM COLOUR (R080).** ⇒ when the band icon is built, its colour is `itemColor(item)` with no
  `withAlpha`. **AN INK IS SETTLED BY THE COVERAGE TEST PLUS THE B−R GAP (R079/R080)** — `t = (fill − pixel)/(fill − ink)` must agree per
  channel (±0.05); **THE HULL FAILS AS AN INK INSTRUMENT (R079/R080/R083)** — never read an ink off the extreme pixel; **R083's
  top-5%-coverage MEAN is the reproducible scalar.**
- **THE REF'S ALL-DAY BAND HAS TWO CHIP FAMILIES, AND ONE IS UNEXPLAINED (R080).** (a) *Coloured*: same-hue wash + same-hue ink at 1:2 +
  same-hue ring. (b) *Neutral*: fill **248**, ink **(38,38,38)** — a pair that **cannot** be `itemColor`/`itemColor/2` — while the **ring**
  is strongly coloured. **Do not cite the neutral chips for any ink or fill rule.**
- **A CROSS-ROUND PNG IS NOT POSITION-ALIGNED (R079, strengthened R082/R083).** **R083's refinement: the layout map and, for a same-theme
  pair, even the content can be pixel-stable — but MEASURE it per region, never assume; the file hash is not the instrument.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. ⇒ kill the pid from `live-app.pid`, keep the launcher's stderr, check the pid changed.
  **`leg.sh <theme> <name>` does the whole leg (kill, launch, sleep 30, one flat drive list, `contentY` probe, md5, capture flag) in one
  call.**
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
  ink on the band's own background, NO fill, `leftPadding: 5`, `font.pixelSize: 9`, height bound to `allDayRowHeight`.** Measured: Thu slot
  3 = y207..230, x503..650. **The ref's 7 columns carry ≤3 chips ⇒ NO ref anchor exists for `+N`'s form, its ink, or whether it should be
  `+N` at all — label every future change here spec-only.**
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076)** ⇒ **A03's clause has no ref anchor; say "spec-only".**
  **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The record's end is the **inclusive last day**.
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** ⇒ if the R074 separators
  are ever removed, A03's rendering collapses back into "one pill per day". **The two changes are a pair.** **`itemRecord` IS AN INJECTED
  PROPERTY ON `CalendarScheduleView` (R076)**, bound in `Main.qml`'s two schedule views; a view that omits it gets `({})` ⇒ every chip
  fully rounded.
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R091).** Corner: per-row **fill-start inset**. Joint: per-row
  **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw
  profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap argument**, and for a
  cross-capture comparison the **top-5%-coverage mean**. Ordering/content: **a per-column deviation-from-fill ASCII ramp**; a word-space GAP
  in it gives the word-length signature. **R087: for "does the layout respond to content", new fixture + a row-mean scan of one populated
  and one empty column — and grep the model expression first. R088: prove containment with the whole-page diff-count, not a rule re-read.
  R091: ask the app what its `contentY` is (trailing `stop` probe) BEFORE attributing a cross-leg pixel difference to any binding.**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT filename**;
  **always read the success flag in `live-runtime-vm.log`** and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`; measured y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237).
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R091.** `sectionRule` **y=155** (242 light / 39 dark,
  1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap
  **181**, **182-205**, gap 206, **207-230**. **Net +28 vs R070 — the grid has permanently lost ~28px of viewport.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**;
  top rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217), **row-mean constant 217.0 over x250..810**; **inset ≈1 both
  legs**; content **125..182 = 58**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3,
  hole 6, 3 px inside the fill edge**. **R087: all 7 columns live in the SAME 3-row strip and carry 0/1/2/3 chips — the band never
  expands.** Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 / separators present / hue ink — every *form* item matched **except the
  icon (仍差 #1)**; capacity now matches too (R088).
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**; span = its column's
  full width minus ~1 px each side. Fill = light desaturated same-hue wash (blue (222,237,254), red (251,228,227)); **text = dark same-hue =
  the bar at 1:2** (R079); **left bar 2.4 px, ~3 px in, round caps**; **no border/ring on any edge** (R078). Ours: fill
  `withAlpha(itemColor, .19 light / .36 dark)`, ink halfway to the pole, bar done, border deleted. Ref chip ink starts **7 ref px** in from
  the fill edge; ours: chip = column + 3, text ink from column + 16.
- **REF EVENT CHIP COLOUR IDIOM (R063/R075/R077/R079/R080).** Light desaturated same-hue fill + dark same-hue text + saturated same-hue
  left bar (timed) or ring icon (band) + small radius. **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are
  HIG+token-anchored only. The ref's tinted chips carry their icon at the LEFT INSIDE EDGE ⇒ **crop the *second* chip row for a clean
  corner, or read the numeric profile instead.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R091):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51; separators at
  **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×150px delegates starting at 52. Columns **Mon 30 · Tue 31 ·
  Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5** (locale week starts Monday) ⇒ **weekend = the last two**; the band's right rim is on Sun's right
  edge (x=1102) and is clipped at 1100. **Fixture day: Thu Apr 2 (x502..651) = 4 all-day items ⇒ 3 chips; Fri Apr 3 (x652..801) = 1.**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark
  white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule`
  (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` has ZERO consumers in this view.** Requirement is the ORDERING: ref 242 < 237 <
  217; ours light 242 < 237 < 217, dark 39 < 59 < 84. `gridLineMinor` is a **half-hour line**, a different role. **R074: `gridLine` is
  consumed by THREE things — the grid's top/left/right edges AND the band's column separators.** **THE ALL-DAY SEPARATOR IS 2px AND SPANS
  THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with `Layout.fillWidth: true`. **ONE LINE PER BOUNDARY (R065).**
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark; the gutter
  is NOT tinted. The all-day band shares the column's fill.** (R088: a row-mean over a Sat/Sun span reads 249 and never dips below the
  250 threshold — a weekend span looks like "one continuous band"; check the fill, not just the threshold.)
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical centring via
  `-Math.round(implicitHeight/2)`. **A gutter scan must start at x ≥ 3** or the x=0 rim merges every text band into one — **and a band scan
  finds the label's *ink rows*, never its *text*: two legs whose labels read one hour apart return the SAME band list (R091). Compare the
  digits, not the bands.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**.
  Half-hour line = `Math.round(parent.height / 2)` = **20**. **R072 added the four `allDay*` tokens; R077 the chip's `stripeWidth`/
  `stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`; R091 the
  timeline's reposition trigger (`:276`).**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar + mini
  calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 =
  **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns, 1px separators at
  x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the
  contract says 40; 40 was chosen). Hour lines and vertical separators are both **1px (237,237,237)**. Gutter label (ref x 215..238):
  digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge 238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue
  31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R091).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`, `position{contentY}`,
  `wheel{angleY}`, `flick{velocity,cancelFirst}`, `stop`, `openItem{kind,titleContains}`); a command with no `action` **silently hits the
  fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes **in place** (never
  `os.replace`), and **sleeps 0.6 s between commands** — that 0.6 s is what used to land the capture inside the 450 ms reposition window.
  **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it. **It EXITS 1 without launching if
  `live-app.pid` still points at a live `kos-calendar`** — kill that pid first (never `pkill`). A rebuilt binary needs a **kill+relaunch**;
  ~24 s to the new pid. Include `resize 1100x692`; it starts in `--view week --date 2026-10-15`, so every drive list must re-send
  `view week` + the date. **The theme is fixed at launch — a dark leg costs a full kill+relaunch.** **App stderr goes to
  `live-runtime-vm.log`** — read the capture flags there. **`leg.sh <theme> <name>` does the whole leg in one call.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root
  `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06**
  (R091 re-read the ICS) plus a **`Multi-day review`** all-day strip **`20260330` → `20260403`** ⇒ Mon 30 · Tue 31 · Wed 1 render as ONE
  chip each (identical row mean, R088) and Thursday does NOT carry it. **R087 ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and
  `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** UID-ordered since R083 ⇒ **Thu's order is `Design sync` /
  `Release notes` / `R087 card C` / (`R087 card D`, hidden)**. VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review`
  12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK] 任务长标题与编辑表单检查`**.
  **The rendered week also shows `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist` — re-read the ICS before predicting a cell.**
  **The launch week (2026-10-12..18) carries NOTHING — R091.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert `im.size` first.
  **A composite (1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read.** **R076: label the rows in the
  composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.**
  **R080: a `Counter` mode over a cell gives the fill in one call.** **R082/R083: a ×3 `LANCZOS` stacked composite with a black label bar
  per leg is the whole verdict in ONE image read; it can make two IDENTICAL inks *look* different across panels — confirm with numbers.
  R087: a ×2 two-panel stack at each panel's own 1:1 scale is enough for "how many rows / where is the shared edge". R091: a 1:1 full-width
  two-panel stack of y150..470 with a black label bar per panel is enough to see TWO LEGS' HOUR LABELS disagree — and it is the fastest way
  to tell "the chips moved" from "the scroll was different".**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## ## Next round (pick ONLY #1)
**#1 — build the all-day BAND CHIP'S RING ICON — but ONLY IF ruling H has been answered.** R081 measured it fully and it is still
**仍差 #1**; check the ruling first (it is the one thing standing between us and the last ref-anchored fidelity item in the all-day
track). If H is still unanswered, **do not build it** — the spec decision is 16 (vertical ratio, fits the 24-px row) vs 22 (horizontal),
and R081's note is explicit: **any circular icon must pick one axis — use the vertical ratio for anything that must fit the 24-px row.**
Numbers ready to hand over: `CalendarScheduleView.qml`'s `allDayChip` delegate, **ring 16x16, stroke 4, hole ~8, inset 4 from the fill's
left/top/bottom, colour = `itemColor(item)` at full saturation (no `withAlpha`)**, text ink then starts at `fill_left + 28`.
**Do NOT touch `chipInk`** (R089's hoisted rule) and **do not add a "neutral-248" family variant** — the two-weight correlation is
recorded but unexplained (R081).

**Then (all still ruling-blocked, in visual-impact order):** #2 12-hour two-tone gutter labels (ruling F); #3 dim snap
(`KosWorkspaceDialog.qml:24-27`, ruling A); #4 shadow magnitude (ruling B); #5 month `slice(0, 2)` — the last content cap, also needs a
3-all-day-item *month* day + ruling D; #6 band-chip inset 1 vs the ref's ~2 (ruling G). **Nothing else in the all-day/grid track is both
ref-anchored and unblocked.**

**Blocked on rulings A–H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E;
clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs
the ref's measured 1**. **The `code-writer` subagent is NOT registered in this session — do not retry it each round.**
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04 fully PASS** —
step 1 R088, step 2 R089 spec-only + byte-contained, R091's light 0 px pair and **R092's dark 0 px pair** the byte-level
reconfirmations; **E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**;
everything else PENDING or ruling-blocked. **R091+R092 changed/verified ONE binding path in the timeline's scroll trigger — no chip,
band, grid or token code was touched, and the 0 px pairs on both themes say so in pixels.**)
