## R112 — M01/M02/M03 PASS (light, expanded sidebar; the first mini-month reading at the shipped geometry)
**Verification only — 0 source files touched, no build, no new leg** (reuses R111's capture). Figure: `r112-m-mini-month.png` — the ref's mini month above ours, both 1:1, guides labelled.
- **M01** block edges **x12..x208** of a 220 px sidebar => **12 / 12** = the groups' own inset (their ink starts x12); `cellWidth 196/7 = 28.0`, `cellHeight 21.0`, height pinned min = preferred = max; **no scrollbar anywhere in the sidebar**.
- **M02** arrows byte-identical and mirrored (x24..28 / x192..196, y523..528), **84.0** each side of the centre 110.0, title centre 109.5; **7 equal columns** (28.0 on 6/6), **6 equal rows** (21.0 on 5/5).
- **M03** `font.pixelSize: 11`; all six bands **9 rows** at the same +0 offset (one baseline); 1- and 2-digit both centred on the column (centre 26.0); `background: null` and no 200..227 run in any row or column.
- **Calibration:** a pixel run p..q is **[p, q+1)**, centre **(p+q+1)/2** — the inclusive form had produced an impossible 11.5 / 12.5 margin split; the half-open form reproduces `categoryInset` 12/12.
- **By-products:** our chevrons are 4x5 px where the ref's are 9 px tall (equal to each other, so not a clause failure — an unfiled ref-fidelity gap); the archived "mini month weekend cells 214" did **not** reproduce (pure 228 across, Sat/Sun included) — 214 is the selection disc's rim.

# R111 — **T01, T02 and T03 PASS on a fresh light leg.** R109's band work did not disturb the grid's three rules. Hour rules `(237,237,237)` and half-hour rules `(244,244,244)` land on *exactly one* row each at pitch **20/20**; the hour pitch is **40.0** across 11 consecutive intervals with `contentHeight 960` = 24x40; the tone ordering **242 < 237 < 217** holds; every tone is neutral `R=G=B`, so `gridLine` has not drifted to the blue-tinted `AppTheme.border`; and every gutter label's 9-row band centres **exactly on its own tick**, right-aligned with a **gap of 8** to the grid line at x272.

**Why this round.** T01/T02/T03 were PASS-pending-final-regression from R064-R066 — and R109 rebuilt the binary, so every figure that witnessed them predates the opaque all-day fill. This round is the re-read on the current build: **0 source files touched, no build**, one kill+relaunch to the light theme, one capture, one read.

**T01 — the pitch.** A gutter ink scan over x222..272 gives label bands at y270-278, 310-318, 350-358, ... 670-678. Their centres are **274.0 / 314.0 / 354.0 / 394.0 / 434.0 / 474.0 / 514.0 / 554.0 / 594.0 / 634.0 / 674.0** — **11/11 diffs of exactly 40.0**. The rule profile at x274 (the first day column's bare left edge) alternates **237 at 234/274/314/354/.../674** and **244 at 254/294/334/.../654** — hour-to-half and half-to-hour both **20.0**. The harness logs `contentHeight 960` = 24x40. The hour rules span **x272..x1099**, from the grid's left edge to the window's *last* pixel: the grid is not clipped short on the right, and the viewport's bottom (y691 = 234+458) is grid content.

**T02 — the rules.** `sectionRule` y155 = `(242,242,242)`; `allDaySeparator` y232-233 = `(217,217,217)`, 2 px; grid top rule y234 = `(237,237,237)`; in-grid hour `(237,237,237)` / half-hour `(244,244,244)`. All four are neutral, so the ordering **242 < 237 < 217** is the ref's and no rule has picked up the blue-tinted `AppTheme.border` (which renders 223/225/228 and would invert it). **Nothing stacks:** the profile y272..278 at x276 is non-white on **y274 alone** — one row per boundary, so R065's 2 px `(223,225,228)` defect has not returned. The day/gutter separators are **1 px 237** at **272/391/510/629/748/867** (pitch 119), and chips still paint above the lines.

**T03 — the labels.** Each label band is **9 rows** (font 11) and its centre sits **exactly on its own tick** — e.g. the 07:00 band is y270..278, centre **274.0**, and the hour rule is at y274. Ink runs **x238..264**, so the right gap to the grid line at x272 is **8** — inside the contract's 6-8, and identical to R066's collapsed-leg reading (ink 44, line 52).

**By-products, and one artifact of the leg.** In a rule row the only non-white pixels left of x272 are the label's own ink: **the rules do not cross the gutter**. And at `contentY 240` the topmost visible label is hour 6, whose 9-row band would be y230..238 — the rows above y234 are outside the scroll viewport, so the capture shows **234..238** and the visible band's centre reads 2 px late. That is clipping, not misalignment: the clipped band's ink x-extent is **identical (238..264)** to its siblings, and the full band's centre (234) is the tick.

**Verdicts.** T01 **PASS**, T02 **PASS**, T03 **PASS**. The T dark leg's tones (`gridLine` 59 / `gridLineMinor` 43) were read R065 and are **not** re-witnessed since R109's rebuild — one dark leg is owed before T is called final-regressed.

**Artifacts.** `docs/ui-calendar/r111-t-rules-3panel.png` — a 1:1 strip (x221..1100, y146..300) with colour-coded guides drawn in the empty gutter, above an x6 contrast-stretched rule stack, an x6 honest junction zoom, and an x6 honest label zoom, over a stacked caption block.

# R110 — **A03 IS PASS ON BOTH LEGS. The dark leg's two inner joints read the chip fill `(36,65,84)` on every pixel of every band row — no field tone `(30,30,30)`, no rule tone `(59,59,59)` — and band rows 157–164 / 175–180 form a SINGLE contiguous fill interval `274 … 625`, so the run is one bar on dark exactly as it is on light. The dark leg's two unknowns are both settled: the weekday backdrop the pre-blend starts from is **30**, not the weekend's 37, and the alpha is **0.32**.**

**Why this round.** R109 closed clause (b) on the light leg but shipped two dark-leg code paths it could not read: `allDayBackdrop`'s weekend branch composites a *translucent* `weekendField` (`white@0.03`), and the chip's alpha is `0.32` on the dark leg against `0.17` on light. If the pre-blend started from the wrong field, or used the wrong alpha, every dark chip would be a wrong absolute colour even though the joint still read continuous. This round is the read.

| A03 clause | dark leg (R110, measured) | verdict |
|---|---|---|
| **(a) only outer corners rounded** | the run's fill envelope ramps **281@157 → 273@165–172 → 281@180** on the left and **618@157 → 625@165–172 → 618@180** on the right — the same corner ramp as R109's light reading (radius 8) | **PASS** |
| **(b) visually continuous** | at joint 1 (`385..393`) and joint 2 (`504..512`) every pixel of **every** band row 157–180 = **`(36,65,84)`**. **Zero `(30,30,30)` field. Zero `(59,59,59)` rule.** The ink-free rows 157–164 and 175–180 are a single *contiguous* interval `274..625` | **PASS** |
| **fill identity** | measured `(36,65,84)`; predicted `mix(field 30, accent, 0.32)`. Back-solving gives accent ≈ `(49,139,199)` against the light leg's `(49,137,196)` — two legs, two alphas, two backdrops, agreeing within rounding. **A wrong backdrop (37) would read `(41,70,89)`; the old light alpha (0.17) would read `(33,49,59)`.** Both are excluded | **PASS** |

## ## 本轮 (R110)
Atomic step: **the dark leg of A03 clause (b)** — **0 source files touched, no build**, one kill+relaunch to the dark theme, one capture. Files: `docs/ui-calendar/r110-a03b-dark-joint.png` (new figure), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`. **Also read on the same capture: the weekend columns are pure `(37,37,37)` at (1000,300) and (900,600), so `allDayBackdrop`'s weekend composite resolves to the documented ~37 — but no weekend all-day CHIP exists in the fixture, so a weekend chip's fill stays unwitnessed.**
## ## Archive — R109 (完整细节见 rounds.md 尾部)
Atomic step: **A03 clause (b), light leg** — the chip's fill became an OPAQUE pre-blend (`AppTheme.mix(backdrop, itemColor, a)`) and the reach became `allDayJointOverlap: 4` on `Layout.leftMargin`, gated on `allDayColumn.index > 0`. Light joints read `(220,235,245)` on every band row; the guard proved invisible (max 1/255).
Atomic step: **A03 clause (b)** — 3 hunks in `apps/calendar/qml/CalendarScheduleView.qml` (a local `scheduleField` token + `allDayBackdrop()` function, an `allDayJointOverlap: 4` token, the chip delegate's `Layout.leftMargin` + `color`) plus a 4th one-line guard (the reach is gated on `allDayColumn.index > 0`). **2 builds, 2 launches, 2 captures.** Second capture differs from the first by **max 1/255** (AA only) ⇒ the guard is a no-op on this fixture, as predicted — **Mon is column 0 and `continuesLeft` is false there.** Files: `docs/ui-calendar/r109-a03-joint-2panel.png` (new figure), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`.
## ## Archive — R108 (完整细节见 rounds.md 尾部)
Atomic step: **A03 measured on the R106 capture** — clause (a) PASS witnessed on both inner joints; clause (b) OPEN at a 3 px light break; the negative-margin fix was built, launched, captured, and **reverted on its own evidence** (191 seam vs 220 fill).
## ## Archive — R107
Atomic step: **A02 re-verification** — 0 source files touched, no build, no leg. A02 3/3 PASS.
## ## Archive — R106
Atomic step: **A01 clause (a), the band's minimum height** — `allDayBandRows` → content-derived `clamp(contentRows,1,3)`. Band 76 → **26** on an all-day-empty week; **76 byte-identical** on the 3-row week.
## ## Archive — R105
Atomic step: **measure, then record L03 PASS** — no build, no leg, no source file touched. L03 5/5.

## 仍差 (top 6, visual-impact order) — **all six are ruling-blocked**
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
- **CLOSED in R110: the DARK LEG OF A03(b).** Both dark joints read the chip fill on every band row; the ink-free rows are one interval. **A03 clause (b) is now PASS on both legs.**
- **CLOSED in R109: A03 clause (b).** Both inner joints read the chip fill across the run; clause (a) re-witnessed on the same capture. **A03 is now PASS on both clauses.**
- **CLOSED in R107: A02 — all three clauses PASS.** (a) expansion witnessed (**+25/row**); (b) the band's bottom edge *is* the grid's top edge; (c) 217 vs 242/237/244.
- **CLOSED in R106: A01 clause (a) — the band's MINIMUM height.** 1 row = **26 px**. A01 = PASS-pending-ruling-G.
- **CLOSED in R105: L03 — ALL FIVE CLAUSES PASS.**
- **CLOSED in R104: C05's TRACK RADIUS** — `:87` `0.38` → `0.48`. ⇒ C05 spec-complete but for the label COUNT (ruling-blocked) and the pointer half (undrivable).
- **CLOSED in R103: 仍差's pitch question — the slot PITCH is spec-mandated.** `Main.qml:178` `196` stays.
- **CLOSED in R102/R101/R100/R099: the pill's padding and radius, L03's label ORDER, C05's label token.** **R098: C05's dark leg, R097: clause 1's chrome.**
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger, R108's band measurements.)*

## ## 最近已改 (most recent 8)
0. R110 — **verification only**: the dark leg of A03(b). 0 source files touched, no build. Figure `r110-a03b-dark-joint.png`.
1. R109 — **A03(b)**: `CalendarScheduleView.qml` — new `scheduleField` token + `allDayBackdrop()`, new `allDayJointOverlap: 4`, chip `color` →
   `AppTheme.mix(backdrop, itemColor, a)`, chip `Layout.leftMargin` → `-4` when continuing with a column to its left, Label leftMargin compensated.
   Figure `r109-a03-joint-2panel.png`.
2. R108 — **A03 measured; 1 hunk written and REVERTED**: the chip delegate's negative `Layout` margins failed on their own evidence and the tree
   was rebuilt unchanged. Figures `r108-a03-bandform-2panel.png`, `r108-a03-joint-before-after-x10.png`.
3. R107 — **verification only**: A02 re-verified 3/3 on the R106 capture pair; figure `r107-a02-shared-edge-3panel.png`.
4. R106 — **A01's clause (a)**: the band's row count is now content-derived (one-row floor, A04's 3-row cap). **76 byte-identical** on the 3-row week.
5. R105 — **L03 PASS 5/5** (verification only).
6. R104 — **C05's segment TRACK RADIUS**: `LiquidSegmentedControl.qml:87` `height * 0.38` → **`height * 0.48`**.
7. R103 — **verdict only**: the slot PITCH is a **spec literal** (L03 180-210). Figure `r103-seg-pitch-2panel.png`.
8. R102 — **C05's pill WIDTH**: `:117` `2 +` → **`4 +`**, `:119` → `segmentWidth - 4`. Pill 64 → 60.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **AN OPAQUE PRE-BLEND MUST RESOLVE THE WEEKEND TINT FIRST (R109, load-bearing).** `weekendField`'s dark leg is `white@0.03` — **translucent** — so
  feeding it to `mix()`/`withAlpha()` drops its alpha and the blend starts from the untinted field. `allDayBackdrop()` composites it explicitly:
  dark ⇒ `mix(field, white, 0.03)` ≈ **37**; light `#F9F9F9` is already opaque so it passes through. **R110 read the weekend FIELD on dark: pure
  `(37,37,37)` at (1000,300) and (900,600) — the composite resolves to the documented 37.** **The weekend CHIP is still UNWITNESSED — the
  fixture's Sat/Sun all-day columns are empty (R107).** Never claim a weekend chip backdrop was read.
- **`opacity: 0.5` ON A COMPLETED ITEM RE-CREATES THE EXACT DEFECT R109 FIXED (R109, load-bearing).** `CalendarScheduleView.qml:550` still fades a
  completed chip with item `opacity`, which composites the chip against what is *below* it — two overlapping 50 % chips would stack darker than the
  bar, exactly as R108's translucent overlap did. **No completed all-day item exists in the fixture. Recorded, not fixed.**
- **A03 IS PASS ON BOTH CLAUSES AND ON BOTH LEGS (R110).** (a) outer-corner-only, witnessed R108 / re-read R109 light / re-read R110 dark;
  (b) visually continuous, witnessed R109 light and R110 dark. **No further work on A03.**
- **A TRANSLUCENT CHIP CANNOT BE JOINED BY OVERLAP (R108, load-bearing).** `withAlpha(itemColor, 0.17)` over white is **220** and two overlapping
  chips stack to **191** — 11 % darker. **A join must be an opaque pre-blend (R109's `AppTheme.mix(backdrop, itemColor, a)`), after which the
  extension can be generous and immune to the ±1 rounding.** R109 is the confirmation: reach = 3 px measured, 4 px shipped.
- **THE JOINT'S 3 px IS ONE PIXEL OF SLACK IN THREE PIECES (R108, load-bearing).** A column is **119.0 px** (833/7) and draws its own 1 px
  separator as its **FIRST** pixel; the chips sit in a `ColumnLayout` inset `allDayBandInset: 1` ⇒ a chip is **116 px inside a 119 px column**.
  Joint = 2 px field (column leftover + layout rounding) + the neighbour's separator + the neighbour's own 1 px inset. **The leftover is known only
  to ±1 — that is what disqualifies an exact-fit margin and makes an overlapping one necessary.**
- **ONLY A LEFT-EXTENSION CAN HIDE A RULE (R108, load-bearing).** Each column's separator belongs to **that column's own delegate**, which is
  later in the RowLayout than the previous column's chips ⇒ it paints **above** them. So a right-extension can never cover the neighbour's rule;
  the neighbour's own chip, extending **left**, can. **R109 shipped exactly that: `Layout.leftMargin` only, never a right one.**
- **A CONTINUATION IS A DATE FACT; A COLUMN IS A PLACE (R109, load-bearing).** `allDayContinues()` (`:243-252`) is pure date arithmetic, so it returns
  `true` on column 0 for an item that started in the *previous week* — with a reach attached that would paint 4 px into the gutter with no rounding
  column. **Gate the reach on `allDayColumn.index > 0`.** The corner suppression (clause (a)) still reads the ungated flag.
- **THE REF HAS NO MULTI-DAY ALL-DAY STRIP (R108, load-bearing).** All 7 ref columns carry single-day chips only ⇒ **A03(b) is an internal law, judged
  on the spec sentence alone.** Record it as such; never claim a ref anchor for it.
- **A 246..253 FILL DETECTOR CANNOT SEPARATE THE REF'S 249 WEEKEND TINT FROM ITS 250 CHIP (R108).** **The discriminator is each column's OWN background**, never an absolute band.
- **A02'S CLAUSE (a) IS AN INTERNAL LAW, NOT A REF QUESTION (R107, load-bearing).** The reference has exactly **one** band size. Ours is settled by
  the affine fit `1 + 25N` at **N = 1 (floor, 26 px)** and **N = 3 (76 px)** with the top rule pinned — and by the **+50 translation of everything
  below**. **The 1–2-row middle is not in the fixture.** **Record it as an extrapolation, never as witnessed.**
- **THE REF'S BAND/GRID JUNCTION IS THREE ROWS OF INK: 217,217 (2px) + ONE 1px RULE (R107, load-bearing).** Ref 183-184 = 217 2px, **185 = 244 1px**,
  field 250. Ours: 232-233 = 217 2px, **234 = 237 1px**, field 255. **A "shared edge" check is: separator tone + the very next row's tone.**
- **THE REFERENCE'S IN-GRID RULES ARE 242–249 AND ARE NOT FULL-WIDTH UNIFORM (R107).** Its **hour pitch is 27**; its gutter label ink sits at
  189-197 / 216-224 / 271-278 / 299-305 / 325-333 (the 247 band is swallowed by the red now-pill at 232-245, centre 238 = the now-line).
- **THE ALL-DAY BAND IS CONTENT-SIZED WITH A ONE-ROW FLOOR (R106, load-bearing).** `allDayBandRows = clamp(maxItemsAcrossThe7Columns, 1, 3)`:
  **26 px** all-day-empty, **76** on the 3-row week. **`allDayMaxRows` (the cap, 3) and `allDayBandRows` (the drawn rows) must stay separate variables.**
- **OUR WEEKS START MONDAY, AND AN EXPANDED SIDEBAR SHIFTS THE DAY COLUMNS (R106, load-bearing).** With the sidebar expanded the gutter runs
  **221..272** and the separators sit at **272/391/510/629/748/867/986** — **pitch 119**. So **`x=577` is the 3rd day column; Thursday is
  629..747 (x~690)**. The y-map is x-independent; only *horizontal* reads need the leg's sidebar state stated.
- **AN ALL-DAY-EMPTY WEEK STILL SHOWS A 26 px BAND (R106, extrapolation).** The spec says "min about 28", so the band has a floor rather than a hide.
- **THE REF'S SIDEBAR IS 192 px WIDE — "243px sidebar" WAS A CONFLATION (R105, load-bearing).** The 237-plane ends at **x=191**; the white hour
  gutter runs **192..243** and the first *day column* starts at **243**. ⇒ the reference's **main region is 192..813, centre 502.5** — and its
  segment's rim centre is **502.0**. **R063–R104 carried the wrong denominator ⇒ any ref-centredness number derived from "grid 243..812" must be recomputed.**
- **A CENTRED-IN-REGION SEGMENT IS −0.5 px ON BOTH SIDES, AND THAT IS THE CONVENTION (R105, load-bearing).**
- **A LOCALIZED LABEL IS NOT A 4th WORD (R105).** **L03 names the segment semantically, so the locale is not one of its clauses.**
- **A CAPSULE'S OUTER RADIUS IS MEASURED AGAINST ITS OWN INNER ELEMENT, NEVER IN ABSOLUTE PX (R104, load-bearing).**
- **AN ARC-ONLY FIT CANNOT SEPARATE r FROM y0 AND IS THEREFORE NOT AN ABSOLUTE INSTRUMENT (R104, load-bearing).** **Report the bound (11–13.5), not a point.**
- **A PILL'S HORIZONTAL PADDING IS MEASURED AGAINST ITS OWN SLOT, AND THE SLOTS OF A SEGMENTED CONTROL TILE (R102, load-bearing; R103).**
  **R103: the rule applies to both sides or the comparison is void. Correct ref slot = (228−4)/4 = 56.0.**
- **A WHOLE-CONTROL WIDTH CAN BE A SPEC LITERAL THAT OVERRIDES THE REFERENCE (R103, load-bearing).** **L03 fixes 180–210 ⇒ a 3-label control can never match a 4-label reference's pill width.**
- **WORD CENTRES BEAT CONTROL EDGES FOR A PITCH (R103, load-bearing).**
- **THE REFERENCE'S SEGMENTED CONTROL AND OURS SHARE ONE RADIUS TOKEN (R101–R104).** Ref lens **r ≈ 11.5 on h 24 (0.48)**; ref track **r ≈ 13.4–13.5**; ours **0.48 on both**.
- **A RADIUS IS MEASURED 1:1 AGAINST A SAME-HEIGHT ELEMENT, AND THE METHOD MUST RECOVER A KNOWN TOKEN FIRST (R101, load-bearing).**
  **threshold = the midpoint of THAT IMAGE's own two constants**; **only when the profile is monotone across the edge. R104: prefer the *within-image* track-vs-lens profile.**
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, load-bearing).** **`n<100` discriminates an ink *token* difference from an AA-coverage difference.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100).** `viewIndex` (0=month/1=week/2=day) has five consumers.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** **R101: the lens's 1px white@16% border makes the DARK leg measure 2 px wider (62 vs 60) — a capture comparison must state its leg.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** Reachable range **[120, 227]** on white.
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).**
- **R096 (compressed): THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER** (compare ΔL only), and **A RADIUS IS THE PER-ROW FILL-START INSET**.
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** `captureClient{path}` / `escape` / `resize{width,height}` / `sidebar{expanded}` / `view{view}` /
  `date{date}` / `position{contentY}` / `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` / `openItem{kind,titleContains}`.
  ⇒ **`hovered`/`pressed` chrome cannot be driven**; **a static screenshot can never settle an animation.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** **R109's leg read `contentY 240 width 885 height 458 contentHeight 960`.**
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088).** Threshold **>6 RGB-sum**.
  **R109 used it to prove the `index > 0` guard is invisible: two captures differ by max 1/255 across the whole page.**
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).**
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R109).** Corner: per-row **fill-start inset** (body mode, R098; **interior rows,
  indexed from the first counted row, validated on a known token — R101/R102**; **R103: only on a monotone edge**; **R104: on a 250-on-255 fill use
  the rim's argmin core, and compare the outer element against the inner one in the SAME image**). Joint: per-row **`!= white` envelope**;
  **R107: a shared *horizontal* edge is separator-tone + the very next row's tone; R108: a shared *vertical* edge is the pair of fill edges plus
  whatever sits between them, and a JOIN must be read as an absolute tone against the fill (a translucent overlap reads DARKER, not lighter);
  R109: after the join, the acceptance is "the fill envelope is unbroken and contains no 255 and no rule tone".**
  Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw profile across an edge that abuts
  no rule**. Ink: the **per-channel coverage agreement test PLUS the channel-gap argument**; cross-capture: **top-5 %-coverage mean** and **`n<100`**.
  **Pitch: word centres, not edges (R103).**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat filename**; read the
  success flag in `live-runtime-vm.log`, then `ls` the actual CWD. **Pillow crops need ABSOLUTE paths** — the shell CWD moves between calls.
  **R107: our PNGs are written at zlib level 0 — three different captures share a byte size, so compare `md5sum`, never the size.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. **The R097–R109 working leg (ONE Bash call): kill `live-app.pid` → `nohup ./start-review-vm.sh
  light|dark &` → `sleep 38` → `python3 review-command.py '<json list>'` with `resize`/`sidebar`/`view`/`date`/`position`/`captureClient`/`stop` →
  grep `capture <name>.png true` + the `manual stop contentY` probe.** **`review-command.py` IS NOT EXECUTABLE — always `python3 review-command.py`
  (R109 lost a Bash call to `./review-command.py: Permission denied`).** `leg.sh` has NO `sidebar` action.
- **OUR COLUMN MAP AT 1100x692 (R071-R109) — THE SIDEBAR-COLLAPSED MAP (R106 amendment, load-bearing):** x=0 rim; gutter x 1..51;
  separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**, **With the sidebar EXPANDED: gutter 221..272, separators
  272/391/510/629/748/867/986 (pitch 119), Thu = 629..747.**
  **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's segment track spans x562..757 (w 196)
  centred on the main region, now `radius: 13.44` (R104); the lens x630..689 (w 60) on segment 2 = Week, `radius: 11.52` (R101); our segment label
  centres are x595.5 / 659.5 / 723.0 (pitch 64.0) — `(W−4)/3 = 64`; the capsule is y36..63 (28 tall), the lens y38..61 (24) with
  `segmentWidth - 4` since R102.** **Fixture day: Thu Apr 2 = 4 all-day items ⇒ 3 chips; Fri Apr 3 = 1. The launch week (Oct 12–18) carries
  NOTHING, so `date 2026-10-15` is the cheapest way to get a month that CONTAINS today; `date 2026-04-02` is the strip week.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R109.** `sectionRule` **y=155**
  (242 light / 39 dark, 1px); **3-row leg** band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); grid top rule **234** (237).
  Chips **157-180**, gap **181**, **182-205**, gap 206, **207-230**. **0-row leg: interior 156..181 = 26, separator 182-183, grid rule 184.**
  ⇒ **band = 2 + 24N + (N−1) = 1 + 25N; everything below the separator translates by 25 per row.**
- **OUR ALL-DAY CHIP'S HORIZONTAL GEOMETRY (R108/R109, load-bearing).** Expanded sidebar, 3-row strip week, band row 1: **Mon chip 273..388**,
  **Tue 392..507**, **Wed 511..626** as *laid out*; with R109's reach the **Tue and Wed chips start at 388 and 507** so the painted envelope is
  **273 … 626 unbroken**. ⇒ **chip = 116 px in a 119 px column, inset 1 each side, and (before R109) a 3 px break at every joint.** The
  `Multi-day review` chip's fill is **`(220,235,245)`**.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087 + R107–R109).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **grid top rule y=185** 1px (244); **inset ≈1 both legs**; content **125..182 = 58**.
  Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**.
  **R108: every ref band chip is SINGLE-DAY, inset ~6–7 ref-px from its column rule (Wed 494-562 in 487-569); there is no multi-day bar.**
  Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 (or 26 at the floor) / hue ink — every *form* item matched **except the icon (仍差 #3)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light desaturated
  same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round caps**; **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:95-112`: `gridLine` (light `#EDEDED` / dark white@0.13),
  `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` /
  dark white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, dark 39 < 59 < 84.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — **re-stated as the local `scheduleField` token at R109**, and it
  must track `Root.tahoe.contentPlane` (`Main.qml:47-48`). **Weekend columns 249 light / 37 dark; the gutter is NOT tinted.**
  **Sidebar plane light = (228,228,228); the mini month's weekend cells (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at x ≥ 3.**
- **`hourHeight` is THE pitch constant (R064).** `:53`. Chip height = **16**. Half-hour line = **20**. **R072 added the four `allDay*` tokens;
  R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`;
  R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`; R094 the mini disc's `15`;
  R097 `tahoe.segmentTrack`/`segmentPill`; R099 the segment's `mutedTextColor`; R101 `LiquidSegmentedControl.qml:121`; R102 `:117`/`:119`;
  R104 `:87`; R106 `CalendarScheduleView.qml:64/76-83/483/411`; R108 `:548` (the band chip's translucent fill — R109's target);
  R109 `CalendarScheduleView.qml:87-92` (`allDayJointOverlap`), `:114-134` (`scheduleField` + `allDayBackdrop`), `:551-562` (the chip's
  `Layout.leftMargin` + opaque `color`), `:568` (the ink's compensating left margin).**
- **REF FACT SHEET (R063, compacted; R103/R104/R105/R107/R108 revise the segment, the sidebar and the band).** `.loop/refs/macos-calendar.png` =
  **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed Apr 1**) + **a 192px sidebar** (plane 237, ends **x=191**) holding the mini calendar
  + a **52px white hour gutter (192..243)**. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter
  labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label (centre = the now-line **y=238**), red **(235,76,70)**.
  **7 equal day columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.**
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
  **Toolbar row y4..36, holding the traffic dots, a 2-icon capsule x≈122..190, a round `+` x≈205..230, the Day/Week/Month/Year capsule at
  x388..616 (W 229, slot 56.0, selected pill W 51–52.4, h 24 y12..35, r 11.5, word centres 418/474/530/586, track rim core x388..616 / y8..38 =>
  H ≈ 31, r fit 11.25–13.5 = the lens's own 0.48 token, R104; **rim centre 502.0 = the main region's centre 502.5 to 0.5 px, R105**), and two
  round glass buttons (radar, search) at x≈735..810.** *The ref track has no measurable fill edge (R103), so all its edge-derived numbers carry ±1.*
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R109).** `harness/Main.qml` matches `command.action` only; a command with no `action`
  **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes **in place** (never
  `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` —
  background it; a rebuilt binary needs a **kill+relaunch** (**~38 s to a usable state**). Include `resize 1100x692`; the app starts in
  `--view week --date 2026-10-15` **with the sidebar COLLAPSED**. **The theme is fixed at launch — a dark leg costs a full kill+relaunch. App
  stderr → `live-runtime-vm.log`.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root `calendar-fixture.ics` is
  **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06** plus a **`Multi-day review`** all-day
  strip **`20260330` → `20260403`** (renders as a **3-column run on Mon/Tue/Wed**; Thursday does NOT carry it). **R087 ADDED**: `R087 card C`,
  `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** UID-ordered since R083.
  WTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00.
  **R107: the per-column all-day capacity in the fixture is {0, 3} — no 1- or 2-row week exists. The all-day columns carrying chips are Mon–Fri;
  Sat/Sun are empty (so the weekend chip backdrop is unwitnessed).**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.** `state.md`/`rounds.md`
  can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
  **R108: a `python3 -c "..."` whose payload contains markdown backticks is mangled by the shell — write the payload to a file and `python3 - <<'PY'`.**
- **Compositing (R077/R080/R088/R097/R099/R101–R109).** **A composite (a 1:1 strip above a 2–4× zoom) answers "overall form + local
  detail" in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes it self-describing.** **`LANCZOS` for a ×1.8 upscale of a
  ref crop; `NEAREST` when the point is pixel structure.** **R080: a `Counter` mode over a cell gives the fill in one call (R098: over the *body*
  rows). R097: a black-bar two-panel `old-above / new-below`; R099: `ref / before / after`; R101: `ref / rA / rB` settles a *measured constant*;
  R102: red guide lines at the slot boundaries; R103: blue/green/red for track-edge / slot-boundary / word-centre; R104: three-panel `ref / before /
  after` of the SAME CORNER at ×6; R107: a three-panel junction at ×5, 28 rows, each panel anchored 6 rows above its OWN separator; R108: a
  **×10 two-panel of a vertical joint**, before above / after below; **R109: a 1:1 band strip with green/magenta joint guides above a pair of
  ×6 joint zooms — when there is no "before" capture, the guides plus the numeric caption carry the claim.****
  **Captions go on the FINAL canvas at 1x — text drawn *before* an ×N upscale is illegible, and the canvas height must include the caption block
  (it was clipped twice).** **R109: side-by-side panel captions collide even at 615 px of canvas — stack caption LINES, one per panel, at full
  width.** **No `numpy` here.**
- **A WIDE, SHALLOW CROP CANNOT BE READ AT ×5+ (R107).** **Crop to the feature (≤30 rows) and anchor on the feature.**

## ## Next round (pick ONLY #1)
**#1 — T01/T02/T03, the grid's three rules, re-verified on a fresh LIGHT leg against the ref's measured tones.** The chain's next unverified block, and the cheapest: T01/T02/T03 are **PASS-pending-final-regression**, and the binary was rebuilt at R109, so every pre-R109 screenshot predates the opaque band fill. **Procedure: one kill+relaunch with `start-review-vm.sh light`, the same drive list (`resize 1100x692` / `sidebar expanded` / `view week` / `date 2026-04-02` / `position 240` / `captureClient` / `stop`), then read five tones on the SAME capture: `sectionRule` y=155 = **242**; `allDaySeparator` 232-233 = **217**; grid top rule 234 = **237**; `gridLine` **237**; `gridLineMinor` **244**. The requirement is the ORDERING **242 < 237 < 217** light — and `gridLine` must not have drifted to `AppTheme.border` (blue-tinted, renders 223/225/228, which inverts the order).** **Fix nothing this round unless a tone is off — this is a read.**
**Then:** the chain in spec order — **M01-M03**, S02/S03/S05, C01-C04/C06, E01/E02 (clauses 1+2+3 PASS), **L01-L07** (L03 done R105).
**A03 done on BOTH clauses and BOTH legs (R108 (a), R109 (b)-light, R110 (b)-dark). A01 done but for G (R106); A02 done (R107).**

**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month
`slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel
exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R110 were done inline.**
**The binary was rebuilt at R109 (the guarded version) and every figure from R109 on comes from THAT build; any pre-R109 screenshot predates the opaque fill, so re-run a leg before comparing.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105 5/5; A02 PASS 3/3 R107; A03 PASS both clauses, both legs (R108/R109/R110).
T01/T02/T03 and **A01** PASS-pending-final-regression **with clause (a) measured R106**; **A04** fully PASS (+2 row re-verified mid-band R106);
**E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02/A03/A04 M04 closed R093 + R094**;
**M03/M02/M01/S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**;
**C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
