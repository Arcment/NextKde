# R108 — **A03 measured on the R106 capture: the corner clause PASSES and is witnessed on both inner joints; the continuity clause is OPEN — the run carries a 3px LIGHT break at every day boundary. The obvious fix was built and captured, and it FAILS: two translucent chips overlapping double-composite into a seam DARKER than the fill (191 vs 220). Reverted.**

**Why this round.** A03 was marked PASS at R087 by the same class of inference A02's was, so it had to be read on a capture before it was trusted. R106 left the fixture that can answer it (`r106-band-3row.png`, week of Mar 30–Apr 5, `Multi-day review` 20260330→ spanning Mon/Tue/Wed as a 3-column run) and the expanded-sidebar column map (separators 272/391/510/629/748/867/986, pitch 119).

| A03 clause | ref | ours (measured R108) | verdict |
|---|---|---|---|
| **only outer corners rounded** | **no subject** — every ref band chip is single-day | run = Mon [rounded-left, **square-right**] · Tue [square, square] · Wed [**square-left**, rounded-right]. Mon's right edge is **388 on every row 157–180**; Tue is **392–507 constant**; Wed's left is **511 constant** while its right ramps **622@157 → 626@163 → 622@180**; Mon's left ramps **277@157 → 273@163 → 277@180**. Nearest single-day neighbours (Thu 630–745, Fri 749–864) round on **both** ends | **PASS** (witnessed, not inferred) |
| **visually continuous** | **no subject** — the reference has no multi-day strip to be continuous | at **every** inner joint (Mon\|Tue @388–392, Tue\|Wed @507–511) the pixels are **fill 220 → 255, 255 → gridLine 237 → fill 220**: a **3 px light break** per day boundary. The separator is a real rule: x=391 reads 237 for **y156–230**, i.e. the day-column separators run **unbroken through the band** (A01's own design) | **OPEN** |
| **the overlap fix** | — | negative `Layout` margins closed the break, but the joint then reads **390 = 191, 391 = 205** against a **220** fill: the chip is `withAlpha(itemColor, 0.17)`, so two overlapping chips composite TWICE and the seam is **29/255 = 11 % DARKER** than the bar | **FAIL** — reverted |

**The geometric cause is one pixel of slack, in three pieces.** Each day column is 119.0 px (833/7) and draws its own 1px separator as its **first** pixel; the chips live in a `ColumnLayout` inset by `allDayBandInset: 1`. So a chip is 116 px inside a 119 px column, and the joint is: 2 px of field (the column's leftover + the layout's rounding) **plus** the neighbour's separator **plus** the neighbour's own 1 px inset = 3 px. Closing it needs the two fills to *meet*, and the leftover is only known to ±1 — which is what disqualifies an exact-fit margin and makes an overlapping one necessary.

**And an overlapping join cannot be translucent.** This is the round's load-bearing negative result. `CalendarScheduleView.qml:548` paints the chip as `AppTheme.withAlpha(itemColor, dark ? 0.32 : 0.17)`; over white that resolves to 220. Two of them stack to 191. So the fix is not a margin — it is to make the chip **opaque**: `AppTheme.mix(backdrop, itemColor, a)` (`AppTheme.qml:197`, returns alpha 1), after which an overlap is invisible and the extension can be generous on both sides and immune to the ±1. That refactor needs the backdrop token (weekday field **255 light / (30,30,30) dark**; weekend `weekendField` `#F9F9F9` light / `white@0.03` dark — itself translucent and therefore needing compositing), and it cannot be signed off on a light leg alone. **It is the next round's atomic step, and it is specified.**

**A03's continuity clause has NO reference anchor and must be judged on the spec sentence alone.** All of the reference's band chips are single-day — row 1 is `Antonio…`(Sun) · `FaceTi…`(Mon) · `April Fool…`(Wed) · `Take o…`(Thu) · `Good Fri…`(Fri), each its own rounded pill inset ~6–7 ref-px from its column rule (Wed 494–562 in a 487–569 column) with the 242-weight rule at 324/406/487 showing between them. There is no multi-day bar anywhere in the capture. So, like A02's clause (a), this one is an **internal law**, and the spec's words are the instrument.

**No source file survives this round** — the one-hunk change to `CalendarScheduleView.qml` was reverted and the tree rebuilt, so the source fingerprint is unchanged from R107.

**Evidence figures — `docs/ui-calendar/r108-a03-bandform-2panel.png`** (ref band rows 1–3 at ×2 above ours, x243..813 vs x266..1100 — the whole run-and-neighbours form in one read) and **`docs/ui-calendar/r108-a03-joint-before-after-x10.png`** (the Mon|Tue joint at **×10**, R106 light-break above, R108 attempted-join below: 220 fill / 255,255 / 237 rule against 220 fill / **191** seam).

# R107 — **A02 re-verified on the R106 capture pair: "All-day band expands uniformly; shared bottom edge and subtle stronger separator" — all THREE clauses PASS, two of them ref-anchored. No code changed: this round is the verification R106 made possible.**

**Why this round.** A02 was marked PASS at R087, but until R106 `allDayBandRows` was a hard **3**, so "the band **expands** uniformly" had no observable subject — exactly as A01's minimum had none. R106 left the two legs the claim needs on disk (`r106-band-min.png` = 0 all-day items, `r106-band-3row.png` = 4 items on Thu capped to 3 rows). This round measures A02's three clauses on that pair, against the ref where the ref can answer.

| A02 clause | ref (measured 1:1) | ours (measured R107) | verdict |
|---|---|---|---|
| **(a) expands uniformly** | **unwitnessable in the ref** — the reference has exactly ONE band size (3 rows); it cannot show expansion | **26 @ 0 rows (the 1-row floor) → 76 @ 3 rows = +25 per row**: band = 2 + 24N + (N−1); the 3-row leg's rows are **24/24/24 with gaps 1/1** (157-180 / 182-205 / 207-230), i.e. no row stretches; `sectionRule` **pinned at 155 on BOTH legs** (growth is downward-only); everything below translates by exactly **+50** (`allDaySeparator` 182→232, grid top rule 184→234) | **PASS** — witnessed at both ends of the range; the 1–2-row middle is **not in the fixture** (extrapolation) |
| **(b) shared bottom edge** | band's last row ends **181** → **2px 217 separator at 183-184** → **1px 244 rule at 185** → field **250**: one shared edge, no gap, no second box, no header strip between | last row ends **231** → **2px 217 at 232-233** → **1px 237 at 234** → field 255. Same three-row structure, same separator token, spanning **all 7 columns** (100 % row coverage on both legs) | **PASS** (ref-anchored) |
| **(c) subtle stronger separator** | separator **217** against the ref's own `sectionRule` 124 = **242** and its in-grid rules **242–249** ⇒ **Δ ≥ 25**; and **2 px** where every other rule is **1 px** | separator **217 (2px)** against `sectionRule` **242 (1px)**, hour **237**, half-hour **244** ⇒ Δ 25 to the section rule, 20 to the hour line; the ordering **242 / 237 / 244 > 217** holds on **both** legs | **PASS** (ref-anchored) |

**The one clause the ref cannot answer is the one clause that is an internal law.** With a single band height the reference has nothing to say about expansion, so (a) is settled by our own two legs fitting the affine law `1 + 25N` exactly at N = 1 (the floor) and N = 3. (b) and (c) are pure ref comparisons and both land on the same junction: **a 2 px 217 separator, then the grid's own 1 px rule, then the field** — the band's bottom edge *is* the grid's top edge.

**A second capture exists that the R106 ledger did not record.** `r106-band-2row.png` is **NOT** a 2-row leg: its band rows 155–244 are numerically identical to `r106-band-3row.png` (same row means to 2 dp); the two images differ only in **37 rows inside 126–571**, i.e. the day header and the timed grid. It is a second capture of the **same** 3-row band (different date) — useful only as a **reproducibility** check, which it passes.

**No fixture carries 1 or 2 all-day rows in a column**, so the middle of the expansion range stays unwitnessed: the only week with ≥3 items in a column is Mar 30–Apr 5 (Thu Apr 2 carries 4, capped at 3) and the only empty week is Apr 6+ (R106 added it). Recorded as an extrapolation, not a finding.

**Evidence figure — `docs/ui-calendar/r107-a02-shared-edge-3panel.png`**: ref 1:1 / ours 3-row / ours 0-row, each panel **28 rows tall at ×5, anchored 6 rows above its own separator**; **red = the 2 px 217 separator, blue = the grid's top rule**. Captions carry the measured tones.

# R106 — **A01's clause table built; the ONE clause that was neither closed nor G-blocked — (a) "band min about 28" — was MEASURED-OPEN and is now CLOSED.** The band was a hard 3-row box: 76 px whether the week carried four all-day items or none.

**Why this round.** Next #1 from R105. A01 has carried the tree's **oldest open ruling (G: spec "gap 2 / inset 2-3" vs the ref's measured 1)** and, since R075, a verdict claiming *all four clauses match the ref* — an **inference from a single 3-row week**. Classifying the four clauses honestly leaves exactly one that is **neither already-closed nor G-blocked**: **clause (a), the band's MINIMUM height**, never observed, because `allDayBandRows: 3` was a hard constant — a box that cannot shrink has no minimum to measure.

| A01 clause | spec | ref (measured) | ours before | ours now | verdict |
|---|---|---|---|---|---|
| **(a) band min ~28** | 28 | **20** = 1+18+1 — the rows HUG: rule y124, first chip y126, last row ends 181 against the separator 183-184 | **76, hard-coded** | **26** = 1+24+1 | **PASS** — 26 vs 20 x our 1.33 vertical factor = **26.6**, and -7 % of the spec's 28 |
| (b) row 18 | 18 | 18 (pitch 19) | 24 = 18 x 1.33 (R072) | 24 | closed (ref-anchored) |
| (c) vertical gap 2 | 2 | **1** | 1 | 1 | G-blocked — **spec erratum** |
| (d) column inset 2-3 | 2-3 | **1**, both axes (R073) | 1 | 1 | G-blocked — **spec erratum** |

**One atomic change — the band's row count becomes content-derived** (`CalendarScheduleView.qml`): `:64` `allDayBandRows: 3` -> **`allDayMaxRows: 3`** (A04's cap, renamed to what it is) plus a new content-derived **`allDayContentRows`** (max `allDayItems().length` over the 7 columns) and **`allDayBandRows: Math.max(1, Math.min(allDayMaxRows, allDayContentRows))`**; `:483` R089's overflow formula re-pointed from `allDayBandRows` to **`allDayMaxRows`** (without that, a 1-item column in a 1-row band renders `+1` instead of its chip — the floor and the cap must not share a variable); `:411` the band's gutter label `Layout.preferredHeight: 48` (stale since R073) -> **`root.allDayBandHeight`** (a 48-tall label in a 26-tall row would have pinned the row back to 48).

**Evidence — light, 1100x692, sidebar expanded, one launch, three captures.** `r106-band-min.png` (week of Apr 6, **0 all-day items**): `sectionRule` 155 -> **band interior 156..181 = 26** -> `allDaySeparator` 182-183 -> first hour line 184. `r106-band-3row.png` (week of Apr 2, Thu 4 all-day items): **band 76 UNCHANGED** — chips 157-180 / 182-205, **A04's `+2` row still in slot 3 (207-230)**, separator 232-233, hour line 234 = the R073-R104 map **byte for byte**. The gutter `all-day` label's ink sits at rows **167-174 on both legs** — the label-height edit moved nothing. Figure **`docs/ui-calendar/r106-a01-band-min-3panel.png`**: ref 1:1 / ours 3-row / ours 0-item, with the section rule in red and the band's bottom separator in blue on each panel.

**A01 is PASS-pending-ruling-G with clause (a) now MEASURED rather than inferred.**

## ## 本轮 (R106)
Atomic step: **the band's minimum height** — 1 source file, 3 edits, **1 build, 1 launch, 3 captures** (19 Bash calls, ~20 min). Files: `apps/calendar/qml/CalendarScheduleView.qml`, `docs/ui-calendar/r106-a01-band-min-3panel.png` + `r106-band-3row.png` + `r106-band-min.png`, + this file and `rounds.md`.
## ## Archive — R105 (完整细节见 rounds.md 尾部)
Atomic step: **measure, then record L03 PASS** — 10 Bash calls, 2 image reads, **no build, no leg, no source file touched**. Files: `docs/ui-calendar/LEDGER.md`, `spec.md:17` (verdict; both `spec.md` and this file are uncommittable), `docs/ui-calendar/r105-l03-centre-2panel.png` (new figure), + this file and `rounds.md`.

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
- **CLOSED in R106: A01 clause (a) — the band's MINIMUM height.** The band was a hard 3-row constant, so the one A01 clause that is neither ref-closed nor G-blocked had no observable value; it is now content-derived with a one-row floor. **1 row = 26 px** (ref 20 x 1.33 = 26.6, spec 28). A01 = PASS-pending-ruling-G.
- **CLOSED in R105: L03 — ALL FIVE CLAUSES PASS.** (a) W **196** ∈ [180, 210] (render rim 562..757 = 196); (b) h **28** (y36..63); (c) **centred in the main region, −0.5 px**, matching the ref's own −0.5 px; (d) order **Day · Week · Month** (R100); (e) the pill is on **Week**, the active view. **The first ID of the final regression chain is closed.**
- **CLOSED in R104: C05's TRACK RADIUS** — `:87` `0.38` → `0.48`; the capsule pair is concentric (Δ1.92 vs a 2 px inset) and our corner profile
  matches the reference's to ≤1 px. ⇒ **C05 is now spec-complete but for the label COUNT (ruling-blocked) and the pointer half (undrivable).**
- **CLOSED in R103: 仍差 #3 in full — the slot PITCH is spec-mandated** (L03 width 180–210: the ref's pitch needs 172, and the floor forces
  slot ≥ 58.67 > 56.0). **`Main.qml:178` `196` stays.**
- **CLOSED in R102: the pill's horizontal padding** (`:117` `2 +` → `4 +`, `:119` `segmentWidth` → `segmentWidth - 4`; pill 64 → 60 = 93.75 % of its
  slot, against the ref's 51–52.4/56 = 91.1–93.6 %). **R101: the pill radius** (`:121` `0.42` → `0.48`). **R100: L03's label ORDER.** **R099: C05's
  label token.** **R098: C05's dark leg.** **R097: C05 clause 1's chrome** (`Main.qml:94-103` track+lens, opaque #E7E7E7=231 / dark #3C3C3C).
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger.)*

## ## 最近已改 (most recent 8)
0. R106 — **A01's clause (a)**: the band's row count is now content-derived (one-row floor, A04's 3-row cap). `allDayBandRows: 3` -> `allDayMaxRows` + `allDayContentRows`
   + a clamped `allDayBandRows`; R089's overflow re-pointed to the cap; the band's gutter label de-hard-coded. Band 76 -> **26** on an all-day-empty week; **76 byte-identical**
   on the 3-row week. A01 clause (a) **PASS**.
1. R105 — **L03 PASS 5/5** (verification only, **no code changed**): clause (c) our rim centre 659.5 vs region centre 660.0 (-0.5 px); ref rim centre 502.0 vs **its**
   region centre 502.5 (-0.5 px) once the sidebar is read as **192**, not 243. Figure `r105-l03-centre-2panel.png`.
2. R104 — **C05's segment TRACK RADIUS**: `LiquidSegmentedControl.qml:87` `height * 0.38` -> **`height * 0.48`** (10.64 -> 13.44; lens 11.52 unchanged => concentric).
3. R103 — **verdict only, NO code changed**: the slot PITCH is a **spec literal** (L03 180-210). Figure `r103-seg-pitch-2panel.png`.
4. R102 — **C05's pill WIDTH**: `:117` `2 +` -> **`4 +`**, `:119` -> `segmentWidth - 4`. Pill 64 -> 60.
5. R101 — **C05's pill radius**: `:121` `height * 0.42` -> **`height * 0.48`**.
6. R100 — **C05/L03's label ORDER**: `Main.qml:1713-1728` -> `[Day, Week, Month]` + `2 - index` mirroring.
7. R099 — **C05's inactive label**: `Main.qml:1717-1722` `mutedTextColor: labelSecondary` -> **`labelPrimary`**.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE ALL-DAY BAND IS CONTENT-SIZED WITH A ONE-ROW FLOOR (R106, load-bearing).** The reference band HUGS its rows (rule y124, first chip y126, last row ends 181, separator 183-184) => a 1-row reference band is **20**, not 60. Ours is now `allDayBandRows = clamp(maxItemsAcrossThe7Columns, 1, 3)`: **26 px** on an all-day-empty week, **76** on the 3-row week. **`allDayMaxRows` (the cap, 3) and `allDayBandRows` (the drawn rows) must stay separate variables** — R089's `+N` overflow is keyed to the CAP. The middle of the range (a week carrying 1 or 2 all-day rows) is **not in the fixture**, so content-following is witnessed only at 0 and 3.
- **OUR WEEKS START MONDAY, AND AN EXPANDED SIDEBAR SHIFTS THE DAY COLUMNS (R106, load-bearing).** With the sidebar expanded (which every leg since R093 drives) the gutter runs **221..272** and the separators sit at **272/391/510/629/748/867/986** — **pitch 119**, not 150. So **`x=577`, the column every band measurement since R073 profiled as "Thursday", is the 3rd day column; Thursday is 629..747 (x~690)**, and **Friday 748..866** (its headers read 周四 2 / 周五 3 in the R106 crop). The y-map is x-independent, so every *vertical* number in this ledger stands; only *horizontal* reads need the leg's sidebar state stated.
- **AN ALL-DAY-EMPTY WEEK STILL SHOWS A 26 px BAND (R106, extrapolation).** The spec says "min about 28", so the band has a floor rather than a hide; the ref has no all-day-empty week to anchor hide-vs-26. Our choice keeps the band and its gutter `all-day` label coherent — recorded as an extrapolation, not a finding.
- **THE REF'S SIDEBAR IS 192 px WIDE — "243px sidebar" WAS A CONFLATION (R105, load-bearing).** The 237-plane ends at **x=191**; the white
  **hour gutter** runs **192..243** (labels right-aligned, ink ending ≈242) and the first *day column* starts at **243**. ⇒ the reference's
  **main region is 192..813, centre 502.5** — and its segment's rim centre is **502.0**. **Measured against the grid (243..812, centre 527.5)
  the ref looks 25 px mis-centred; against the REGION it is centred to 0.5 px, exactly like ours.** R063–R104 carried the wrong denominator ⇒
  **any ref-centredness number derived from "grid 243..812" must be recomputed.**
- **A CENTRED-IN-REGION SEGMENT IS −0.5 px ON BOTH SIDES, AND THAT IS THE CONVENTION (R105, load-bearing).** ref −0.5 of a 622-wide region
  (−0.080 %), ours −0.5 of an 878-wide one (−0.057 %). **The residual is the same absolute sub-pixel and scales with nothing** ⇒ the reference
  centres on **sidebar edge .. window right**, not on the grid and not on the window itself. **L03's clause (c) PASSES.**
- **A LOCALIZED LABEL IS NOT A 4th WORD (R105).** The segment renders 日/周/月 under this locale — single CJK glyphs, ~10–11 px ink runs, which
  is what R099/R100/R102 actually measured. **L03 names the segment semantically, so the locale is not one of its clauses; do not re-open
  仍差 #1 as a label defect on this evidence.**
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
- **OUR COLUMN MAP AT 1100x692 (R071-R105) — THIS IS THE SIDEBAR-COLLAPSED MAP (R106 amendment, load-bearing):** x=0 rim; gutter x 1..51; separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**, **With the sidebar EXPANDED the map is different: gutter 221..272, separators 272/391/510/629/748/867/986 (pitch 119), Thu = 629..747.**
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
- **REF FACT SHEET (R063, compacted; R103/R104/R105 revise the segment and the sidebar).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026,
  **today = Wed Apr 1**) + **a 192px sidebar** (plane 237, ends **x=191** — NOT 243, R105) holding the mini calendar + a **52px white hour gutter (192..243)**. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter
  labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238, pill/line red **(235,76,70)**.
  **7 equal day columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35,
  h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
  **R097/R098/R101/R102/R103/R104/R105 give the toolbar row: y4..36 in the ref, holding (left→right) the traffic dots, a 2-icon capsule at x≈122..190,
  a round `+` at x≈205..230, the Day/Week/Month/Year capsule at x388..616 (W 229, slot 56.0, selected pill x449..499 + fit ⇒ W 51–52.4, h 24
  y12..35, r 11.5, word centres 418/474/530/586, track rim core x388..616 / y8..38 ⇒ H ≈ 31, r fit 11.25–13.5 with r/H 0.46–0.48 = the lens's own
  0.48 token, R104; **rim centre 502.0 = the main region's centre 502.5 to 0.5 px, R105**), and two round glass buttons (radar, search) at x≈735..810.** *The ref track has no measurable fill edge (R103), so all its
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
**#1 — A02, re-verified on the R106 captures, because R106 changed the thing A02 describes.** A02 = *"All-day band expands uniformly; shared bottom edge and subtle stronger
separator"*, marked PASS at R087 — but until R106 the band **could not expand at all** (a hard 3-row box), so "expands uniformly" was as inferential as A01's clause (a) was. The two
captures already on disk are the two legs the claim needs: **`r106-band-min.png`** (0 rows) and **`r106-band-3row.png`** (3 rows). Build A02's clause-by-clause table from `spec.md:35`
and classify each clause closed / ruling-blocked / still open; act only on a clause that is neither. The measurement to make: the `sectionRule` is pinned at **155 on both legs** and
the `allDaySeparator` **moves with the band (182-183 vs 232-233)** — i.e. the shared bottom edge, and the separator's 2px 217 is stronger than the 1px 242 rule. **No build, no leg
expected.** If A02 collapses to the same G/ref-blocked set, record it and move to A03.

**Then:** the chain in spec order — **T01/T02/T03**, M01-M03, S02/S03/S05, C01-C04/C06, E01/E02 (clauses 1+2+3 PASS), **L01-L07**. **L03 done (R105); A01 done but for G (R106).**

**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month
`slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel
exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R106 were done inline**
(R106 = 3 edits in one file, fully specified before the edit; delegating it would have cost more than it saved). **R106 DID build and launch — the binary is now 1 round newer than
the R104-era capture set, so re-run a leg before comparing against any pre-R106 screenshot.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105, 5/5 — closed.** T01/T02/T03 and **A01** PASS-pending-final-regression **with clause (a) now measured (R106)**; **A03** PASS;
**A04** fully PASS (its `+2` row re-verified mid-band at R106); **E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**
— *re-verification now due, see Next #1*; **A02/A03/A04 M04 closed R093 + R094**; **M03/M02/M01/S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**;
**C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
