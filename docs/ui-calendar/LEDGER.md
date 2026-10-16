## R109 — A03 clause (b): the all-day run is now continuous. PASS.

**Source.** `apps/calendar/qml/CalendarScheduleView.qml` — three hunks plus one guard:
a local `scheduleField` token (`#FFFFFF` / `#1E1E1E`) and `allDayBackdrop(column)`, which **composites** the weekend tint into the field before the
blend (its dark leg is `white@0.03`, translucent — using it raw would drop the alpha); `allDayJointOverlap: 4` beside `allDayBandInset`; and the
chip itself — `color:` becomes `AppTheme.mix(backdrop, itemColor, dark ? 0.32 : 0.17)` (**alpha 1**) and the chip gains a left `Layout.leftMargin`
of `-4` when it continues, gated on `allDayColumn.index > 0` so a week-spanning strip cannot paint into the gutter. The chip's Label left margin
adds the reach back, so the title's x is unchanged. **This is a token change: the chip fill is no longer translucent.**

**Evidence (light, 1100x692, `date 2026-04-02`, sidebar expanded).** The run's fill envelope is **Mon 273 … Wed 626 unbroken**: at both inner
joints (`388..393`, `507..512`) every pixel of every band row reads the chip fill **`(220,235,245)`** — no `255` field, no `237` rule. R108's
3 px break is gone. The outer ends still ramp (Mon 281→273→281, Wed 618→625→618) and the single-day neighbours still round on both ends
(Thu 638→630→638, Fri 757→749→757). `mix(255, itemColor, 0.17)` is **identical** to the old translucent value, so the bar's colour did not move.

Figure: `r109-a03-joint-2panel.png` (1:1 band strip with joint guides above a pair of x6 joint zooms).

**Open.** The **dark leg** (alpha 0.32, and `allDayBackdrop`'s weekend branch) is next round's #1. `:550`'s completed-item `opacity: 0.5`
re-creates the same defect class and is recorded, not fixed.

# R108 — **A03 measured on the R106 capture. Clause "only outer corners rounded" PASSES and is now WITNESSED on both inner joints. Clause "visually continuous" is OPEN: the run carries a 3px LIGHT break at every day boundary. The obvious fix was built, launched and captured — and it FAILED (two translucent chips overlapping composite to a seam 29/255 DARKER than the fill), so it was reverted. Source fingerprint unchanged from R107.**

**Why this round.** A03 was marked PASS at R087 by the same class of inference A02's was, so it had to be read on a capture first. R106 supplied the fixture (`r106-band-3row.png`: `Multi-day review` 20260330 → spanning Mon/Tue/Wed as a 3-column run) and the expanded-sidebar column map (272/391/510/629/748/867/986, pitch 119).

| A03 clause | ours (measured R108) | verdict |
|---|---|---|
| **(a) only outer corners rounded** | run = Mon [rounded-left, **square-right** — right edge **388 on every row 157–180**] · Tue [square, square — **392–507 constant**] · Wed [**square-left** 511 constant, rounded-right **622@157 → 626@163 → 622@180**]; Mon's left ramps **277@157 → 273@163 → 277@180**. Single-day neighbours Thu (630–745) and Fri (749–864) round on **both** ends | **PASS** (witnessed, `:540-547`) |
| **(b) visually continuous** | at **every** inner joint (388–392, 507–511): fill **220** → **255, 255** → gridLine **237** → fill **220** = a **3 px light break** per day boundary. x=391 reads 237 for **y156–230** ⇒ the day-column separators run unbroken **through** the band | **OPEN** |
| **the attempted join** | negative `Layout` margins closed the break, but the joint then read **390 = 191, 391 = 205** against a **220** fill — `:548` is `withAlpha(itemColor, 0.17)`, so two overlapping chips composite twice ⇒ **11 % darker** | **FAIL → reverted** |

**The reference cannot arbitrate clause (b), and it nearly misled the round.** Every ref band chip is **single-day** — row 1 = `Antonio…`(Sun) · `FaceTi…`(Mon) · `April Fool…`(Wed) · `Take o…`(Thu) · `Good Fri…`(Fri), each its own rounded pill inset ~6–7 ref-px from its column rule (Wed **494–562** in a **487–569** column) with its 242-weight rule at 324/406/487 showing between. There is **no multi-day bar anywhere in the capture**. Worse: the ref's Saturday column reads **246–253 on every sampled row**, which a "fill" detector happily reports as a chip — it is the **249 weekend tint**. So A03(b) is an **internal law** judged on the spec sentence, exactly like A02's clause (a).

## ## 本轮 (R108)
Atomic step: **A03 on the R106 capture** — 1 source hunk written (`CalendarScheduleView.qml` chip delegate, negative `Layout` margins), **2 builds, 1 launch, 1 capture**, measured, **reverted** (the attempt failed on its own evidence), rebuilt. Files: `docs/ui-calendar/r108-a03-bandform-2panel.png` + `r108-a03-joint-before-after-x10.png` (new figures), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`.
## ## Archive — R107 (完整细节见 rounds.md 尾部)
Atomic step: **A02 re-verification** — 0 source files touched, no build, no leg. A02 3/3 PASS; corrected `r106-band-2row.png` → a second **3-row** leg.
## ## Archive — R106
Atomic step: **A01 clause (a), the band's minimum height** — `allDayBandRows: 3` → content-derived `clamp(contentRows,1,3)`. Band 76 → **26** on an all-day-empty week; **76 byte-identical** on the 3-row week. 1 build, 1 launch, 3 captures.
## ## Archive — R105
Atomic step: **measure, then record L03 PASS** — no build, no leg, no source file touched. L03 5/5.

## 仍差 (top 7, visual-impact order) — **#1 is actionable; #2–#7 are ruling-blocked**
1. **A03(b) — the multi-day run is not visually continuous: a 3 px LIGHT break (2 px field + the 1 px gridLine 237) at every day boundary.** Fully measured, cause fully identified. **The fix is an OPAQUE chip pre-blend, not a margin** — see Next round #1. **The only open item in this file that is NOT blocked on a ruling.**
2. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies exactly three, so **three is
   spec-correct**; adding a view is not an atomic step. Ref word centres **418/474/530/586, pitch 56.0**; ours **595/660/723, pitch 64.0**
   (`(W−4)/n` both; 196 is L03's midpoint). **Blocked on a ruling.**
3. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12×12 ring, stroke 3 / hole 6, inset 3
   from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17–19 ref px right of the ring's
   outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family** (stroke ~1.5, hole ~9)
   on the neutral-248 chips. **Do NOT build either until H is answered.**
4. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right edge
   (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
6. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
7. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day** before it can be
   reproduced at all. **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell).
- *(dropped from the top 7 in R108: the ref band chips' inset ~2 vs our inset 1 — near-identical (~3.7 px at our scale) and it rides on ruling G.)*
- **RE-OPENED in R108: A03 clause (b).** R087's PASS covered clause (a) (which this round confirms **witnessed**, not inferred) but (b) was never
  read on a capture. The 3 px break is now measured at both inner joints.
- **CLOSED in R107: A02 — all three clauses PASS.** (a) expansion witnessed (**+25/row**, top rule pinned, everything below +50); (b) the band's
  bottom edge *is* the grid's top edge; (c) 217 vs 242/237/244.
- **CLOSED in R106: A01 clause (a) — the band's MINIMUM height.** 1 row = **26 px** (ref 20 × 1.33 = 26.6, spec 28). A01 = PASS-pending-ruling-G.
- **CLOSED in R105: L03 — ALL FIVE CLAUSES PASS.**
- **CLOSED in R104: C05's TRACK RADIUS** — `:87` `0.38` → `0.48` (concentric with the lens). ⇒ C05 is spec-complete but for the label COUNT
  (ruling-blocked) and the pointer half (undrivable).
- **CLOSED in R103: 仍差's pitch question — the slot PITCH is spec-mandated** (L03 180–210 forces slot ≥ 58.67 > 56.0). `Main.qml:178` `196` stays.
- **CLOSED in R102/R101/R100/R099: the pill's padding and radius, L03's label ORDER, C05's label token.** **R098: C05's dark leg, R097: clause 1's chrome.**
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger.)*

## ## 最近已改 (most recent 8)
0. R108 — **A03 measured; 1 hunk written and REVERTED**: the chip delegate's negative `Layout` margins (R108 attempt) failed on its own
   evidence (191 seam vs 220 fill) and the tree was rebuilt unchanged. Figures `r108-a03-bandform-2panel.png`, `r108-a03-joint-before-after-x10.png`.
1. R107 — **verification only**: A02 re-verified 3/3 on the R106 capture pair; figure `r107-a02-shared-edge-3panel.png`.
2. R106 — **A01's clause (a)**: the band's row count is now content-derived (one-row floor, A04's 3-row cap). Band 76 → **26** on an all-day-empty
   week; **76 byte-identical** on the 3-row week. A01 clause (a) **PASS**.
3. R105 — **L03 PASS 5/5** (verification only): our rim centre 659.5 vs region centre 660.0; ref rim centre 502.0 vs **its** region centre 502.5
   once the sidebar is read as **192**, not 243.
4. R104 — **C05's segment TRACK RADIUS**: `LiquidSegmentedControl.qml:87` `height * 0.38` → **`height * 0.48`** (concentric with the lens).
5. R103 — **verdict only**: the slot PITCH is a **spec literal** (L03 180-210). Figure `r103-seg-pitch-2panel.png`.
6. R102 — **C05's pill WIDTH**: `:117` `2 +` → **`4 +`**, `:119` → `segmentWidth - 4`. Pill 64 → 60.
7. R101 — **C05's pill radius**: `:121` `height * 0.42` → **`height * 0.48`**.
8. R100 — **C05/L03's label ORDER**: `Main.qml:1713-1728` → `[Day, Week, Month]` + `2 - index` mirroring.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A TRANSLUCENT CHIP CANNOT BE JOINED BY OVERLAP (R108, load-bearing).** `:548` paints the band chip `AppTheme.withAlpha(itemColor, dark ?
  0.32 : 0.17)`; over white that is **220**, and **two overlapping chips stack to 191** — the seam is **29/255 = 11 % DARKER** than the bar. So a
  "close the gap" fix must be an **opaque pre-blend** (`AppTheme.mix(backdrop, itemColor, a)`, `AppTheme.qml:197`, returns alpha 1), after which an
  overlap is invisible and the extension can be generous on both sides, **immune to the ±1 rounding**.
- **THE JOINT'S 3 px IS ONE PIXEL OF SLACK IN THREE PIECES (R108, load-bearing).** A column is **119.0 px** (833/7) and draws its own 1 px
  separator as its **FIRST** pixel; the chips sit in a `ColumnLayout` inset `allDayBandInset: 1` ⇒ a chip is **116 px inside a 119 px column**.
  Joint = 2 px field (column leftover + layout rounding) + the neighbour's separator + the neighbour's own 1 px inset. **The leftover is known only
  to ±1 — that is what disqualifies an exact-fit margin and makes an overlapping one necessary.**
- **ONLY A LEFT-EXTENSION CAN HIDE A RULE (R108, load-bearing).** Each column's separator belongs to **that column's own delegate**, which is
  later in the RowLayout than the previous column's chips ⇒ it paints **above** them. So a right-extension can never cover the neighbour's rule;
  the neighbour's own chip, extending **left**, can. **The ref's equivalent rule (242) is likewise a real line between chips.**
- **A03's "ONLY OUTER CORNERS ROUNDED" IS IMPLEMENTED AND NOW WITNESSED (R108).** `:540-547` suppresses the corner on a continuing side; measured
  Mon square-right (388 at every row), Tue square/square (392–507), Wed square-left + rounded-right (622→626→622). Single-day neighbours round on
  both ends. **No further work on clause (a).**
- **THE REF HAS NO MULTI-DAY ALL-DAY STRIP (R108, load-bearing).** All 7 columns carry single-day chips only ⇒ **A03(b) is an internal law, judged
  on the spec sentence alone.** Record it as such; never claim a ref anchor for it.
- **A 246..253 FILL DETECTOR CANNOT SEPARATE THE REF'S 249 WEEKEND TINT FROM ITS 250 CHIP (R108).** The ref's Saturday column reads 246–253 on
  every sampled row — that is the tint, not a chip. **The discriminator is each column's OWN background**, never an absolute band.
- **A02'S CLAUSE (a) IS AN INTERNAL LAW, NOT A REF QUESTION (R107, load-bearing).** The reference has exactly **one** band size, so "expands
  uniformly" can never be settled against it. Ours is settled by the affine fit `1 + 25N` at **N = 1 (floor, 26 px)** and **N = 3 (76 px)** with
  the top rule pinned — and by the **+50 translation of everything below** (separator 182→232, grid rule 184→234). **The 1–2-row middle is not in
  the fixture**: per-column all-day capacity is {0, 3} only. **Record it as an extrapolation, never as witnessed.**
- **THE REF'S BAND/GRID JUNCTION IS THREE ROWS OF INK: 217,217 (2px) + ONE 1px RULE (R107, load-bearing).** Ref 183-184 = 217 2px, **185 = 244 1px**,
  field 250. Ours: 232-233 = 217 2px, **234 = 237 1px**, field 255. **A "shared edge" check is: separator tone + the very next row's tone.**
- **THE REFERENCE'S IN-GRID RULES ARE 242–249 AND ARE NOT FULL-WIDTH UNIFORM (R107).** Its **hour pitch is 27**; its gutter label ink sits at
  189-197 / 216-224 / 271-278 / 299-305 / 325-333 (the 247 band is swallowed by the red now-pill at 232-245, centre 238 = the now-line).
- **THE ALL-DAY BAND IS CONTENT-SIZED WITH A ONE-ROW FLOOR (R106, load-bearing).** `allDayBandRows = clamp(maxItemsAcrossThe7Columns, 1, 3)`:
  **26 px** on an all-day-empty week, **76** on the 3-row week. **`allDayMaxRows` (the cap, 3) and `allDayBandRows` (the drawn rows) must stay
  separate variables** — R089's `+N` overflow is keyed to the CAP.
- **OUR WEEKS START MONDAY, AND AN EXPANDED SIDEBAR SHIFTS THE DAY COLUMNS (R106, load-bearing).** With the sidebar expanded the gutter runs
  **221..272** and the separators sit at **272/391/510/629/748/867/986** — **pitch 119**, not 150. So **`x=577` is the 3rd day column; Thursday is
  629..747 (x~690)**. The y-map is x-independent, so every *vertical* number stands; only *horizontal* reads need the leg's sidebar state stated.
- **AN ALL-DAY-EMPTY WEEK STILL SHOWS A 26 px BAND (R106, extrapolation).** The spec says "min about 28", so the band has a floor rather than a
  hide; the ref has no all-day-empty week to anchor hide-vs-26.
- **THE REF'S SIDEBAR IS 192 px WIDE — "243px sidebar" WAS A CONFLATION (R105, load-bearing).** The 237-plane ends at **x=191**; the white hour
  gutter runs **192..243** and the first *day column* starts at **243**. ⇒ the reference's **main region is 192..813, centre 502.5** — and its
  segment's rim centre is **502.0**. **R063–R104 carried the wrong denominator ⇒ any ref-centredness number derived from "grid 243..812" must be recomputed.**
- **A CENTRED-IN-REGION SEGMENT IS −0.5 px ON BOTH SIDES, AND THAT IS THE CONVENTION (R105, load-bearing).** ref −0.5 of a 622-wide region; ours
  −0.5 of an 878-wide one. **The residual is the same absolute sub-pixel and scales with nothing** ⇒ the reference centres on **sidebar edge .. window right**.
- **A LOCALIZED LABEL IS NOT A 4th WORD (R105).** The segment renders 日/周/月 under this locale. **L03 names the segment semantically, so the locale
  is not one of its clauses.** *On this leg the segment renders the CJK glyphs; R107's ref-leg numbers (418/474/530/586) are the English ref's.*
- **A CAPSULE'S OUTER RADIUS IS MEASURED AGAINST ITS OWN INNER ELEMENT, NEVER IN ABSOLUTE PX (R104, load-bearing).** An outer/inner pair sharing
  an inset **must differ in radius by exactly that inset**. **Two tokens (0.38/0.48) were the bug; one token on both is the fix.**
- **AN ARC-ONLY FIT CANNOT SEPARATE r FROM y0 AND IS THEREFORE NOT AN ABSOLUTE INSTRUMENT (R104, load-bearing).** **Report the bound (11–13.5), not a point.**
- **A PILL'S HORIZONTAL PADDING IS MEASURED AGAINST ITS OWN SLOT, AND THE SLOTS OF A SEGMENTED CONTROL TILE (R102, load-bearing; R103).**
  `track_width / n` is **not** a slot width. **R103: the rule applies to both sides or the comparison is void. Correct ref slot = (228−4)/4 = 56.0.**
- **A WHOLE-CONTROL WIDTH CAN BE A SPEC LITERAL THAT OVERRIDES THE REFERENCE (R103, load-bearing).** **L03 fixes 180–210; with 3 labels that forces
  slot ≥ 58.67, above the ref's 56.0.** ⇒ a 3-label control can never match a 4-label reference's pill width; **check the width band first.**
- **WORD CENTRES BEAT CONTROL EDGES FOR A PITCH (R103, load-bearing).** The ref track's outer edge is a **rim** between a 250 fill and a 255 plane —
  not a fill boundary, so a mid-threshold fit on it is invalid.
- **THE REFERENCE'S SEGMENTED CONTROL AND OURS SHARE ONE RADIUS TOKEN (R101–R104).** Ref lens **r ≈ 11.5 on h 24 (0.48)**; ref track **r ≈ 13.4–13.5**;
  ours now **0.48 on both**. ⇒ a *shape* comparison is legitimate; a *size* comparison needs the slot **and the label count**.
- **A RADIUS IS MEASURED 1:1 AGAINST A SAME-HEIGHT ELEMENT, AND THE METHOD MUST RECOVER A KNOWN TOKEN FIRST (R101, load-bearing).**
  **threshold = the midpoint of THAT IMAGE's own two constants**; **only when the profile is monotone across the edge. R104: prefer the *within-image*
  track-vs-lens profile, which cancels the fit's bias entirely.**
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, load-bearing).** **`n<100` discriminates an ink *token* difference from an
  AA-coverage difference. A semantic two-tone is a native-app idiom this reference does not share.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100).** `viewIndex` (0=month/1=week/2=day) has five consumers.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** **R101: the lens's 1px white@16% border makes the DARK leg measure
  2 px wider than the LIGHT leg (62 vs 60) — a capture comparison must state its leg.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** Reachable range **[120, 227]** on white.
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).** `LiquidSegmentedControl`'s geometry is likewise shared, so a
  radius or padding edit is app-wide by construction.
- **R096 (compressed): THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER** (compare ΔL only), and **A RADIUS IS THE
  PER-ROW FILL-START INSET** — never eyeball one off an upscaled crop.
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** `captureClient{path}` / `escape` / `resize{width,height}` / `sidebar{expanded}` / `view{view}` /
  `date{date}` / `position{contentY}` / `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` / `openItem{kind,titleContains}`.
  ⇒ **`hovered`/`pressed` chrome cannot be driven**; **a static screenshot can never settle an animation.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** **R108's leg read `contentY 240 width 885 height 458 contentHeight 960`.**
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088).** Threshold **>6 RGB-sum**.
  **R107 used it to prove two captures share a band: 37 differing rows, all outside it.**
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the ref's but
  **our type is at the ref's own physical size**: gutter ink **9 = 9**, day-number ink **9 = 9**, segment label ink rows 11 = 11 (R099).
  **R101–R104 extend this to *controls*: both segment pills are h = 24 and both capsules now fit one radius token.**
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** All five ref colours 1:2 on every channel ⇒ any "same-hue text/tint"
  on a chip is `c + (pole − c) * 0.5`. **Corollary: dark chip colours are extrapolation.**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R108).** Corner: per-row **fill-start inset** (body mode, R098; **interior rows,
  indexed from the first counted row, validated on a known token — R101/R102**; **R103: only on a monotone edge**; **R104: on a 250-on-255 fill use
  the rim's argmin core, and compare the outer element against the inner one in the SAME image**). Joint: per-row **`!= white` envelope**;
  **R107: a shared *horizontal* edge is separator-tone + the very next row's tone; R108: a shared *vertical* edge is the pair of fill edges plus
  whatever sits between them, and a JOIN must be read as an absolute tone against the fill (a translucent overlap reads DARKER, not lighter).**
  Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw profile across an edge that abuts
  no rule**. Ink: the **per-channel coverage agreement test PLUS the channel-gap argument**; cross-capture: **top-5 %-coverage mean** and **`n<100`**.
  **Pitch: word centres, not edges (R103).**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat filename**; read the
  success flag in `live-runtime-vm.log`, then `ls` the actual CWD. **Pillow crops need ABSOLUTE paths** — the shell CWD moves between calls.
  **R107: our PNGs are written at zlib level 0 — three different captures share a byte size, so compare `md5sum`, never the size.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. **The R097–R108 working leg (ONE Bash call): kill `live-app.pid` → `nohup ./start-review-vm.sh
  light|dark &` → `sleep 36..40` → `review-command.py` with `resize`/`sidebar`/`view`/`date`/`position`/`captureClient`/`stop` → grep
  `capture <name>.png true` + the `manual stop contentY` probe.** `leg.sh` has NO `sidebar` action.
- **OUR COLUMN MAP AT 1100x692 (R071-R108) — THE SIDEBAR-COLLAPSED MAP (R106 amendment, load-bearing):** x=0 rim; gutter x 1..51;
  separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**, **With the sidebar EXPANDED the map is different: gutter 221..272,
  separators 272/391/510/629/748/867/986 (pitch 119), Thu = 629..747.**
  **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's segment track spans x562..757 (w 196)
  centred on the main region, now `radius: 13.44` (R104); the lens x630..689 (w 60) on segment 2 = Week, `radius: 11.52` (R101); our segment label
  centres are x595.5 / 659.5 / 723.0 (pitch 64.0) — `(W−4)/3 = 64`; the capsule is y36..63 (28 tall), the lens y38..61 (24) with
  `segmentWidth - 4` since R102.** **Fixture day: Thu Apr 2 = 4 all-day items ⇒ 3 chips; Fri Apr 3 = 1. The launch week (Oct 12–18) carries
  NOTHING, so `date 2026-10-15` is the cheapest way to get a month that CONTAINS today; `date 2026-04-02` is the strip week.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R108.** `sectionRule` **y=155**
  (242 light / 39 dark, 1px); **3-row leg** band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); grid top rule **234** (237).
  Chips **157-180**, gap **181**, **182-205**, gap 206, **207-230**. **0-row leg: interior 156..181 = 26, separator 182-183, grid rule 184.**
  ⇒ **band = 2 + 24N + (N−1) = 1 + 25N; everything below the separator translates by 25 per row.**
- **OUR ALL-DAY CHIP'S HORIZONTAL GEOMETRY (R108, load-bearing).** In the 3-row strip week, band row 1: Mon chip **273..388**, white **389,390**,
  gridLine **237 at 391**, Tue **392..507**, white 508,509, rule 510, Wed **511..626**. ⇒ **chip = 116 px in a 119 px column, inset 1 each side,
  and a 3 px break at every joint.** The `Multi-day review` chip's fill is **220** (R channel) on white.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087 + R107/R108).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **grid top rule y=185** 1px (244); **inset ≈1 both legs**; content **125..182 = 58**.
  Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**.
  **R108: every ref band chip is SINGLE-DAY, inset ~6–7 ref-px from its column rule (Wed 494-562 in 487-569); there is no multi-day bar.**
  Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 (or 26 at the floor) / hue ink — every *form* item matched **except the icon (仍差 #3)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light desaturated
  same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round caps**; **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:95-112`: `gridLine` (light `#EDEDED` / dark white@0.13),
  `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` /
  dark white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, dark 39 < 59 < 84.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns 249 light / 37 dark; the gutter is NOT
  tinted.** **Sidebar plane light = (228,228,228); the mini month's weekend cells (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at
  x ≥ 3**; compare the digits, not the bands.
- **`hourHeight` is THE pitch constant (R064).** `:53`. Chip height = **16**. Half-hour line = **20**. **R072 added the four `allDay*` tokens;
  R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`;
  R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`; R094 the mini disc's `15`;
  R097 `tahoe.segmentTrack`/`segmentPill`; R099 the segment's `mutedTextColor`; R101 `LiquidSegmentedControl.qml:121`; R102 `:117`/`:119`;
  R104 `:87`; R106 `CalendarScheduleView.qml:64/76-83/483/411`; R108 `:548` (the band chip's translucent fill — the NEXT round's target).**
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
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R108).** `harness/Main.qml` matches `command.action` only; a command with no `action`
  **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes **in place** (never
  `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` —
  background it; a rebuilt binary needs a **kill+relaunch** (**~36–40 s to a usable state**). Include `resize 1100x692`; the app starts in
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
- **Compositing (R077/R080/R088/R097/R099/R101–R108).** **A composite (a 1:1 strip above a 2–4× zoom) answers "overall form + local
  detail" in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes it self-describing.** **`LANCZOS` for a ×1.8 upscale of a
  ref crop; `NEAREST` when the point is pixel structure.** **R080: a `Counter` mode over a cell gives the fill in one call (R098: over the *body*
  rows). R097: a black-bar two-panel `old-above / new-below`; R099: `ref / before / after`; R101: `ref / rA / rB` settles a *measured constant*;
  R102: red guide lines at the slot boundaries; R103: blue/green/red for track-edge / slot-boundary / word-centre; R104: three-panel `ref / before /
  after` of the SAME CORNER at ×6; R107: a three-panel junction at ×5, 28 rows, each panel anchored 6 rows above its OWN separator; R108: a
  **×10 two-panel of a vertical joint**, before above / after below.**
  **Captions go on the FINAL canvas at 1x — text drawn *before* an ×N upscale is illegible, and the canvas height must include the caption block
  (it was clipped twice). Keep the caption shorter than the panel width or the panels' captions overlap.** **No `numpy` here.**
- **A WIDE, SHALLOW CROP CANNOT BE READ AT ×5+ (R107).** **Crop to the feature (≤30 rows) and anchor on the feature, or the eye has nothing to land on.**

## ## Next round (pick ONLY #1)
**#1 — A03(b): make the band chip's fill OPAQUE, then close the joint by overlap.** The failure of R108's negative-margin attempt is fully diagnosed:
the chip is `AppTheme.withAlpha(itemColor, dark ? 0.32 : 0.17)` (`CalendarScheduleView.qml:548`), so two overlapping chips composite twice and the
seam reads **191 against a 220 fill**. The step is therefore: **(1)** add a backdrop token beside `weekendField` (`:114-121`) — the weekday field is
**255 light / (30,30,30) dark**, the weekend backdrop is `weekendField` itself and must be **composited** first (light `#F9F9F9` is already opaque;
dark `white@0.03` is not, and must become the resolved ~**37**); **(2)** paint the chip with **`AppTheme.mix(backdrop, itemColor, dark ? 0.32 : 0.17)`**
(`AppTheme.qml:197`, returns alpha **1**) instead of `withAlpha`; **(3)** restore the negative `Layout` margins — and with an opaque fill they may be
**generous on both sides** (`-(allDayBandInset + 1)` each way, or 1 px more for rounding slack), because an overlap is now invisible and the ±1
leak is harmless. **Acceptance: at BOTH inner joints (≈388–392 and ≈507–511) every pixel of the band row matches the chip fill (220 ±1) across the
run with no 255 and no 237 between; the run's outer ends must still ramp (Mon 277→273→277, Wed 622→626→622) and the single-day neighbours Thu/Fri
must still round on both ends.** **The light leg can settle this; the dark leg (0.32) is a required follow-up leg, not part of this step.**
**Careful: an opaque chip removes the weekend tint's contribution to the chip's own colour — state the change in the LEDGER as a token change.**

**Then:** the chain in spec order — **T01/T02/T03**, M01-M03, S02/S03/S05, C01-C04/C06, E01/E02 (clauses 1+2+3 PASS), **L01-L07**.
**L03 done (R105); A01 done but for G (R106); A02 done (R107); A03(a) done (R108), A03(b) OPEN.**

**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month
`slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel
exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R108 were done inline.**
**The binary was rebuilt at R108 after the revert, so it matches the R107 source — but re-run a leg before comparing against any pre-R108 screenshot.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105 5/5; A02 PASS 3/3 R107; A03(a) PASS R108, A03(b) OPEN — re-verified on the R106 capture, not inferred.**
T01/T02/T03 and **A01** PASS-pending-final-regression **with clause (a) measured R106**; **A04** fully PASS (+2 row re-verified mid-band R106);
**E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02/A03/A04 M04 closed R093 + R094**;
**M03/M02/M01/S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**;
**C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
