# R104 — the segment's TRACK radius: `LiquidSegmentedControl.qml:87` `height * 0.38` → **`height * 0.48`** (10.64 → 13.44 on the 28-tall track). **C05's last unblocked *shape* constant — CLOSED.**

**Why this round.** Next #1 from R103: `:87` `0.38` on a 28 track, against the lens's `0.48` on a 24 lens (R101) and against the reference.

**The absolute measurement is DEGENERATE — the negative result R103 predicted.** A least-squares rounded-rect fit
(`x(y) = x0 + r − √(r² − (r − (y − y0))²)`) to the **rim-core trace** (per-row argmin of luma, both edges, mirrored about x=502) returns the ref
track at **r = 11.25** (SSE 0.28, y0 9.5, y1 37.5, H 28.0) **and**, on the same rows, at **r = 13.50** (SSE 0.15, y0 8.5, y1 38.0, H 29.5) — a tie.
**r and y0/y1 are not separable from an arc-only trace.** Validated on our own track (truth 0.38·28 = **10.64**) the same fit reads **11.00**
(**+0.36 bias**) — and the bias **flips to −1.14** if the two rows of horizontal top/bottom edge stay in. ⇒ **the ref's track radius is only bounded:
r ∈ [11, 13.5] on H ≈ 28–30.**

**The decisive instrument is within-image and cancels that bias.** Per-row corner *inset profile* (rim-core x minus its own nadir column), the
**track** against **the same control's own lens** — same image, same rows, same method:

| dy from the rim's top row | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| **REF track** (col 388, top y9) | 7 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | 1 | **0** |
| **REF lens**  (col 450, top y12) | 6 | 4 | 3 | 2 | 1 | 1 | **0** | | | | |
| **ours BEFORE** (col 562, top y36) | 6 | 4 | 3 | 2 | 1 | 1 | 1 | **0** | | | |
| **ours AFTER** | 8 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | **0** | |

The ref's **track** corner is uniformly **1–2 px rounder than its own lens's**; **ours before was IDENTICAL to our lens's** (both nadir dy 7–8) —
the outer capsule was exactly as tight as the inner one, which is what a concentric pair must not be. ⇒ **the defect was a two-token capsule
(0.38 outer / 0.48 inner), not a bad radius value, and the fix is ONE token on both, not a new number.** Track r **10.64 → 13.44**, lens r
unchanged **11.52**, Δ **1.92** against the **2 px** inset ⇒ **concentric by construction** (0.08 px short). Our AFTER profile then matches the ref to
**≤ 1 px on every row**, and the ref agrees: its track H measures **30** by rim-core span (ours 28, hard in QML) ⇒ ref r/H **0.46–0.48 = the same token.**

## ## 本轮 (R104)
Atomic step: **one number at `:87`** (`0.38` → `0.48`), then one build → one light leg → one ×6 3-panel compare. **`:117/119` (R102) and `:121`
(R101) untouched.** 17 Bash calls, 3 image reads. Files: `shared/qml/controls/LiquidSegmentedControl.qml:87`, `docs/ui-calendar/LEDGER.md`,
`docs/ui-calendar/r104-track-corner-3panel.png`, + this file and `rounds.md` (uncommittable). **Scope: `:87` is in the SHARED control ⇒ app-wide
by construction (`KosSettingsDialog.qml:174`/`:212`, `WallpaperPreviewBar.qml`) — a fix there, not a regression, because the token is now the one the
lens already used. Not separately captured this round.**

## 仍差 (top 7, visual-impact order) — **every remaining item is ruling-blocked**
1. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies exactly three, so **three is
   spec-correct**; adding a view is not an atomic step. Ref word centres **418/474/530/586, pitch 56.0**; ours **595/660/723, pitch 64.0**
   (`(W−4)/n` both; 196 is L03's midpoint). **Blocked on a ruling.**
2. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12×12 ring, stroke 3 / hole 6, inset 3
   from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17–19 ref px right of the ring's
   outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family** (stroke ~1.5, hole ~9)
   on the neutral-248 chips. **Do NOT build either until H is answered.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right edge
   (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
6. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day** before it can be
   reproduced at all. **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell).
7. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on **ruling G**.
- **CLOSED in R104: C05's TRACK RADIUS** — `:87` `0.38` → `0.48`; the capsule pair is concentric (Δ1.92 vs a 2 px inset) and our corner profile
  matches the reference's to ≤1 px. ⇒ **C05 is now spec-complete but for the label COUNT (ruling-blocked) and the pointer half (undrivable).**
- **CLOSED in R103: 仍差 #3 in full — the slot PITCH is spec-mandated** (L03 width 180–210: the ref's pitch needs 172, and the floor forces
  slot ≥ 58.67 > 56.0). **`Main.qml:178` `196` stays.**
- **CLOSED in R102: the pill's horizontal padding** (`:117` `2 +` → `4 +`, `:119` `segmentWidth` → `segmentWidth - 4`; pill 64 → 60 = 93.75 % of its
  slot, against the ref's 51–52.4/56 = 91.1–93.6 %). **R101: the pill radius** (`:121` `0.42` → `0.48`). **R100: L03's label ORDER.** **R099: C05's
  label token.** **R098: C05's dark leg.** **R097: C05 clause 1's chrome** (`Main.qml:94-103` track+lens, opaque #E7E7E7=231 / dark #3C3C3C).
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger.)*

## ## 最近已改 (most recent 8)
0. R104 — **C05's segment TRACK RADIUS**: `LiquidSegmentedControl.qml:87` `height * 0.38` → **`height * 0.48`** (10.64 → 13.44 on the 28 track;
   lens 11.52 unchanged ⇒ Δ1.92 against a 2 px inset = **concentric**). One token on both elements. Figure
   `r104-track-corner-3panel.png` (REF / before / after, ×6, anchored on each rim's top-left).
1. R103 — **verdict only, NO code changed**: the slot PITCH is a **spec literal** (L03 180–210; the ref's 56.0 needs 172 for 3 labels).
   Figure `r103-seg-pitch-2panel.png`.
2. R102 — **C05's pill WIDTH**: `:117` `2 +` → **`4 +`**, `:119` → **`segmentWidth - 4`**. Pill 64 → 60.
3. R101 — **C05's pill radius**: `:121` `height * 0.42` → **`height * 0.48`**. Ref pill h=24, r fit 11.4–11.7.
4. R100 — **C05/L03's label ORDER**: `Main.qml:1713-1728` → `[Day, Week, Month]` + `2 - index` mirroring (`viewIndex` consumers untouched).
5. R099 — **C05's inactive label**: `Main.qml:1717-1722` `mutedTextColor: labelSecondary` → **`labelPrimary`** (1 token).
6. R098 — **verdict only**: C05's dark leg (`r098-seg-dark.png`): plane 30 / track **43** / pill fill **60**.
7. R097 — **C05 clause 1's chrome**: `Main.qml:94-103` `segmentTrack` + `segmentPill`; `:1715-1716` repointed.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A CAPSULE'S OUTER RADIUS IS MEASURED AGAINST ITS OWN INNER ELEMENT, NEVER IN ABSOLUTE PX (R104, load-bearing).** An outer/inner pair that
  shares an inset **must differ in radius by exactly that inset**; our track was **10.64 against a lens of 11.52 in a 2 px inset** — the outer corner
  tighter than the inner, which is unbuildable as a concentric pair. **Two tokens (0.38/0.48) were the bug; one token on both is the fix** —
  `0.48·28 − 0.48·24 = 1.92 ≈ 2`. **The reference's own difference is 1–2 px/row at every depth, so the *relative* profile is the instrument.**
- **AN ARC-ONLY FIT CANNOT SEPARATE r FROM y0 AND IS THEREFORE NOT AN ABSOLUTE INSTRUMENT (R104, load-bearing).** The ref track fits
  r = 11.25 (y0 9.5) and r = 13.50 (y0 8.5) equally well — **a tie that survives trimming the horizontal-edge rows, and whose sign flips with it.**
  Validate any fit on a **known token**: here it read **+0.36 high** on a truth of 10.64. **Report the bound (11–13.5), not a point.**
- **A PILL'S HORIZONTAL PADDING IS MEASURED AGAINST ITS OWN SLOT, AND THE SLOTS OF A SEGMENTED CONTROL TILE (R102, load-bearing; R103).**
  `:31` `segmentWidth = (width - 4) / labels.length` + `x: 2 + index * segmentWidth` ⇒ interior slots are **adjacent**; `track_width / n` is **not**
  a slot width. **R103: R102 then made exactly that error on the REFERENCE ("227/4 = 56.75") — the rule applies to both sides or the comparison is void.
  Correct ref slot = (228−4)/4 = 56.0, confirmed by the word centres (56.0).**
- **A WHOLE-CONTROL WIDTH CAN BE A SPEC LITERAL THAT OVERRIDES THE REFERENCE (R103, load-bearing).** **L03 fixes 180–210 wide; with 3 labels that
  forces slot ≥ 58.67, above the ref's 56.0.** ⇒ a 3-label control can never match a 4-label reference's pill width; **check the width band before
  deriving a pitch.**
- **WORD CENTRES BEAT CONTROL EDGES FOR A PITCH (R103, load-bearing).** The ref track's outer edge is a **rim (231–245) between a 250 fill and a
  255 plane — darker than both**, so it is not a fill boundary and a mid-threshold fit on it is invalid. Word centres are crisp (ink 0–90) and their
  centroid recovered the track's own centre to **0.0 px (502.0)** ⇒ symmetric placement. **R104 adds: the rim is still the right instrument for a
  *corner* — as an argmin core, not a threshold — because it is the only strong signal in a 250-on-255 fill.**
- **THE REFERENCE'S SEGMENTED CONTROL AND OURS SHARE ONE RADIUS TOKEN (R101 + R102 + R103 + R104).** Ref lens **r ≈ 11.5 on h 24 (0.48)**; ref track
  **r ≈ 13.4–13.5 on H ~ 28–30 (0.46–0.48)**; ours now **0.48 on both**. **The ref's slots are 56.0 wide, ours 64.0 — and that residual is L03's, not
  a defect.** ⇒ a *shape* comparison is legitimate; a *size* comparison needs the slot **and the label count**.
- **A RADIUS IS MEASURED 1:1 AGAINST A SAME-HEIGHT ELEMENT, AND THE METHOD MUST RECOVER A KNOWN TOKEN FIRST (R101, load-bearing).** Fit
  `r − √(r² − (r − (dy+0.5))²)` to the **interior rows dy0..H−2 counted from the first row below the threshold** (**index from the first counted row**);
  **threshold = the midpoint of THAT IMAGE's own two constants**, never a probe pixel that can land on a glyph — **and only when the profile is
  monotone across the edge. R104: prefer the *within-image* track-vs-lens profile, which cancels the fit's bias entirely.**
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, load-bearing).** Ref `Day/Week/Month/Year` = `(0,0,0)` with `n<100`
  60/76/85/53; ours before = 147/152 with **`n<100` = 0**. ⇒ **`n<100` discriminates an ink *token* difference from an AA-coverage difference.**
  **A semantic two-tone is a native-app idiom this reference does not share.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100).** `viewIndex` (0=month/1=week/2=day) has five consumers
  spanning QML, shortcuts, the CLI and the *review harness*.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** `:94-99` gives the *track* a specular `Gradient`, `:128-136` the
  *lens* a stronger one, and `:124` adds a 1px `border.color: white@16%`. Reading the top row yields **99** where the body is **60** (dark).
  **R101: that border makes the DARK leg measure 2 px wider than the LIGHT leg (62 vs 60) — a capture comparison must state its leg.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** `:105-114` paints `lensShadow` (black@**10%** light /
  **24%** dark) directly under the lens ⇒ a veil lands at **210**, not the 231 the over-white arithmetic predicts. Reachable range **[120, 227]** on
  white. **Corollary R101: the light leg's CURRENT pill fill is 231 = the token exactly; a stale capture (`r097-seg.png`) reads 205, not a baseline.**
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).** `LiquidSegmentedControl` has exactly **four** palette
  properties and **one** consumer each for the last two (`:188`). The calendar passes all four; the two settings instances
  (`KosSettingsDialog.qml:174`/`:212`) pass **none**. **The *geometry* is likewise shared — `:87` (track), `:117/119` (lens) are global, so a
  radius or padding edit is app-wide by construction and lands in the settings dialog too (R104's `:87` did exactly this).**
- **THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER (R096).** Ref plane **237**, selected row **226**; ours plane
  **228** with `selectionFill` **215**. Compare only ΔL against the layer's own plane. **R097 bounds it: the toolbar row is NOT a vibrancy layer —
  both planes are white 255, so absolute Δ's DO transfer there.**
- **A RADIUS IS MEASURED AS THE PER-ROW FILL-START INSET, AND r=6 FITS 4,2,1,1,0 (R096).** **Do not eyeball a radius off an upscaled crop.**
  Pick rows by the **body** mode (R098). **R104: on a 250-on-255 fill there is no fill-start to find — use the rim's argmin core instead.**
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** The flat action set is `captureClient{path}` / `escape` / `resize{width,height}` /
  `sidebar{expanded}` / `view{view}` / `date{date}` / `position{contentY}` / `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` /
  `openItem{kind,titleContains}`. ⇒ **`hovered`/`pressed` chrome cannot be driven**; **a static screenshot can never settle an animation.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** The harness logs the
  **pre-command** timeline geometry (`harness/Main.qml:263`). R104's leg read **`contentY 280`, `contentHeight 960`** — identical to R098–R102,
  so the six legs are comparable.
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088).** Threshold **>6 RGB-sum**,
  group differing rows into y-runs, read each run's x-range.
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the ref's but
  **our type is at the ref's own physical size**: gutter ink **9 = 9**, day-number ink **9 = 9**, segment label ink rows 11 = 11 (R099). **R101–R104
  extend this to *controls*: both segment pills are h = 24 and both capsules now fit one radius token — so pill and radius comparisons are 1:1, and
  only the slot pitch differs, which is a layout quantity pinned by L03.**
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** All five ref colours 1:2 on every channel ⇒ any "same-hue
  text/tint" on a chip is `c + (pole − c) * 0.5`. **Corollary: dark chip colours are extrapolation.**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R104).** Corner: per-row **fill-start inset** (body mode, R098; **interior rows,
  indexed from the first counted row, validated on a known token — R101/R102**; **R103: only on a monotone edge**; **R104: on a 250-on-255 fill use the
  rim's argmin core, and compare the outer element against the inner one in the SAME image**). Joint: per-row **`!= white` envelope**. Stripe: a
  saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw profile across an edge that abuts no rule**.
  Ink: the **per-channel coverage agreement test PLUS the channel-gap argument**; for a cross-capture comparison the **top-5%-coverage mean**, and
  **`n<100` as the token-vs-AA discriminator (R099)**. **Pitch: word centres, not edges (R103).**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat filename**; read the
  success flag in `live-runtime-vm.log`, then `ls` the actual CWD. **Pillow crops need ABSOLUTE paths** — the shell CWD moves between calls.
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. **The R097–R104 working leg (ONE Bash call): kill `live-app.pid` → `nohup ./start-review-vm.sh
  light|dark &` → `sleep 36` → `review-command.py` with `resize`/`sidebar`/`view`/`date`/`position`/`captureClient`/`stop` → grep
  `capture <name>.png true` + the `manual stop contentY` probe.** `leg.sh` has NO `sidebar` action.
- **OUR COLUMN MAP AT 1100x692 (R071–R104):** x=0 rim; gutter x 1..51; separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**,
  **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's segment track spans x562..757 (w 196)
  centred on the main region, now `radius: 13.44` (R104); the lens x630..689 (w 60) on segment 2 = Week, `radius: 11.52` (R101); our segment label
  centres are x595.5 / 659.5 / 723.0 (pitch 64.0) — `(W−4)/3 = 64`, so the labels tile like the lens does; the capsule is y36..63 (28 tall, 1px
  `AppTheme.border` hairline top and bottom), the lens y38..61 (24) with `segmentWidth - 4` since R102.** **Fixture day: Thu Apr 2 = 4 all-day items
  ⇒ 3 chips; Fri Apr 3 = 1. The launch week (Oct 12–18) carries NOTHING, so `date 2026-10-15` is the cheapest way to get a month that CONTAINS today.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R104.** `sectionRule` **y=155** (242 light / 39 dark, 1px);
  band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap **181**,
  **182-205**, gap 206, **207-230**.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 both legs**; content **125..182 = 58**. Chip radius **≈6 = row/3**;
  fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**. Ours: row 24 / gap 1 / inset 1 /
  radius 8 / band 76 / hue ink — every *form* item matched **except the icon (仍差 #2)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light desaturated
  same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round caps**; **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark white@0.13),
  `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` /
  dark white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, dark 39 < 59 < 84.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns 249 light / 37 dark; the gutter is NOT
  tinted.** **Sidebar plane light = (228,228,228); the mini month's weekend cells (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at
  x ≥ 3**; compare the digits, not the bands.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = **16**. Half-hour line = **20**. **R072 added the
  four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model;
  R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`;
  R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill` + the segment's repoint at `Main.qml:1715-1716`; R099 the segment's
  `mutedTextColor` at `Main.qml:1718`; R101 `LiquidSegmentedControl.qml:121` `height * 0.48`; R102 `:117` `x: 4 + …` and `:119`
  `width: root.segmentWidth - 4`; **R104 `:87` `height * 0.48` — the track now shares the lens's token.**
- **REF FACT SHEET (R063, compacted; R103/R104 revise the segment).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026,
  **today = Wed Apr 1**) + 243px sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter
  labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238, pill/line red **(235,76,70)**.
  **7 equal day columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35,
  h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
  **R097/R098/R101/R102/R103/R104 give the toolbar row: y4..36 in the ref, holding (left→right) the traffic dots, a 2-icon capsule at x≈122..190,
  a round `+` at x≈205..230, the Day/Week/Month/Year capsule at x389..616 (W 228–229, slot 56.0, selected pill x449..499 + fit ⇒ W 51–52.4, h 24
  y12..35, r 11.5, word centres 418/474/530/586, **track rim core x388..616 / y9..38 ⇒ H ≈ 30, r fit 11.25–13.5 with r/H 0.46–0.48 = the lens's own
  0.48 token, R104**), and two round glass buttons (radar, search) at x≈735..810.** *The ref track has no measurable fill edge (R103), so all its
  edge-derived numbers carry ±1.*
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R104).** `harness/Main.qml` matches `command.action` only; a command with no `action`
  **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes **in place** (never
  `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` —
  background it; a rebuilt binary needs a **kill+relaunch** (**~36 s to a usable state, R104**). Include `resize 1100x692`; the app starts in
  `--view week --date 2026-10-15` **with the sidebar COLLAPSED**. **The theme is fixed at launch — a dark leg costs a full kill+relaunch. App
  stderr → `live-runtime-vm.log`.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root `calendar-fixture.ics` is
  **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06** plus a **`Multi-day review`** all-day
  strip **`20260330` → `20260403`** (Mon/Tue/Wed render as ONE chip each; Thursday does NOT carry it). **R087 ADDED**: `R087 card C`, `R087 card D`
  (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** UID-ordered since R083 ⇒ **Thu's order is
  `Design sync` / `Release notes` / `R087 card C` / (`R087 card D`, hidden)**. VTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00,
  `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, `[R019 LONG TASK] …`. **The rendered week also shows
  `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist`.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.** `state.md`/`rounds.md`
  can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
- **Compositing (R077/R080/R088/R097/R099/R101/R102/R103/R104).** **A composite (a 1:1 strip above a 2–4× zoom) answers "overall form + local
  detail" in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes it self-describing.** **`LANCZOS` for a ×1.8 upscale of a ref
  crop; `NEAREST` when the point is pixel structure.** **R080: a `Counter` mode over a cell gives the fill in one call (R098: over the *body* rows).**
  **R097: a black-bar two-panel `old-above / new-below` ×3 stack; R099: a three-panel `ref / before / after`; R101: `ref / rA / rB` settles a
  *measured constant*; R102: red guide lines at the slot boundaries; R103: blue/green/red for track-edge / slot-boundary / word-centre; R104: a
  three-panel `ref / before / after` of the SAME CORNER at ×6, each panel anchored on its own rim's top-left — a corner comparison needs its own
  per-panel origin, not a shared one, because the two controls' heights differ by up to 2 px.** **Captions go on the FINAL canvas at 1x — text drawn
  *before* an ×N upscale is illegible, and the canvas height must include the caption block (it was clipped twice). Keep the caption shorter than the
  panel width or the panels' captions overlap.** **No `numpy` here.**

## ## Next round (pick ONLY #1)
**#1 — start the FINAL REGRESSION with L03, the ID whose control has been edited in five of the last eight rounds.** Everything left in 仍差 is
ruling-blocked (**and no rulings channel exists anywhere in the tree**), so the highest-value unblocked step is verification, not new work. L03
(`spec.md:17`: *"Day/week/month segment centered within main region; **height 28 and width 180–210**"*) is now **frozen** — C05's shape, order, token and
radius all closed (R097–R104) and `Main.qml:178` `196` ruled a spec literal (R103). Check its five clauses **on the R104 capture** (`r104-seg-light.png`,
already on disk — no new leg needed): **(a)** width **196 ∈ [180, 210]** ✓ by the QML constant, and re-measure the track's x-span to confirm the render
agrees; **(b)** height **28** = `y36..63`; **(c)** the capsule is **centred in the main region** (main region x220..1100 ⇒ centre 660; track x562..757 ⇒
centre **659.5** — 1.5 px off, i.e. it is centred on the **region**, not on the main region **minus the sidebar**, and the ref does the same: its track
centre **502 = the grid's own centre** (243..812 ⇒ 527.5)? **check this — it is the one L03 clause never directly verified.**); **(d)** the three labels
are `Day · Week · Month` in the spec's order (R100) with **one** ink (R099); **(e)** the pill is on the active view (Week = index 1). ⇒ **expect: L03
PASS recorded, or one clause promoted to 仍差.** Do not re-run a build or a leg unless (c) fails.

**Then:** the regression chain in spec order — **A01** (ruling-G-blocked on the spec literals vs the measured 1), then T01/T02/T03, M01–M03, S02/S03/S05,
C01–C04/C06, E01/E02 (clauses 1+2+3 already PASS), L01–L07 — then the ruling-blocked list in 仍差 order.

**Blocked / open on rulings A–H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses
1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the ref's measured 1**,
**and a 4th `Year` segment**. **No rulings channel exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round) — R097 used `general-purpose` as the stand-in implementer;
R098–R104 were done inline.**
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04** fully PASS; **E01/E02** clauses
1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**; **M04 closed R093 + R094**;
**M03/M02/M01/S02/S03/S05/L01–L07/C01–C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**; **C05: clause 1's structural half CLOSED
R097, dark leg CLOSED R098, label-token residue CLOSED R099, label ORDER CLOSED R100, pill radius CLOSED R101, pill horizontal padding CLOSED R102, slot
PITCH CLOSED R103 as spec-mandated, TRACK RADIUS CLOSED R104 — what remains of C05 is the pointer half (no harness action drives it) and the label COUNT
(ruling-blocked)**; **L03: clauses a/b/d/e verified across R100–R104 piecemeal, clause (c) never directly measured — Next #1**.)
