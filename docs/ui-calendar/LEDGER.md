# R112 — **M01, M02 and M03 PASS**, re-read on the current build at the EXPANDED sidebar geometry — the first mini-month reading ever taken at the geometry the app ships. The mini month is the sidebar's last child, below the groups and on the *same* `categoryInset` they use (block edges **x12..x208** in a **220** px sidebar => **12 / 12**, and the group rows' ink also starts at **x12**); it cannot be compressed (`cellWidth 196/7 = 28.0` and `cellHeight 21.0`, both exact => pitch **28.0 on 6/6** columns and **21.0 on 5/5** rows; height pinned min = preferred = max; **and the sidebar carries no scrollbar at all**); its two arrows are **byte-identical mirrored ink boxes** (4x5 at **x24..28 y523..528** and **x192..196 y523..528**, **84.0** each side of the sidebar centre **110.0**) with the title between them (ink centre **109.5**); it draws **7 equal columns** (28.0, identical in all six date rows *and* in the weekday header) and **6 equal date rows** (21.0); the dates are `font.pixelSize: 11` on **one baseline** (every band exactly **9 rows** at the same +0 offset: 561..569 / 582..590 / ... / 666..674); 1- and 2-digit numbers are **both centred on the column** (12 px ink box 20..31 vs 6 px 23..28, both centre **26.0**); and there is **no cell border anywhere** (`background: null`; no row *or* column in y505..690 carries a >100 px run of any 200..227 tone — between bands the field is **216/216 px of pure (228,228,228)**).

**Why this round.** M01/M02/M03 were "PASS R008 + final regression due", R109 rebuilt the binary, and — the real gap — **the sidebar was never expanded in any mini-calendar reading**, so the mini month had only ever been seen at R008's 760x540 collapsed geometry. This round is the re-read at the shipped geometry: **0 source files touched, no build, and no new leg** — it reuses R111's light capture (same build, no source change since).

| | measured on `r111-t-rules-light.png` (light, 1100x692, expanded sidebar, `date 2026-04-02`, `contentY 240`) | verdict |
|---|---|---|
| **M01** | the mini block = the sidebar's last child, below Calendars/Task lists (last group ink y397 -> title band y519); block edges **x12..x208** of a 220 px sidebar => **12 / 12**, the same inset the groups use (their ink starts **x12**); `cellWidth = 196/7 = 28.0` and `cellHeight = 21.0` both exact => nothing is squeezed; **no scrollbar in the sidebar at all** (x211..219 pure 228 at y100/300/500/650) => the category list does not overflow onto the block | **PASS** |
| **M02** | arrows **byte-identical and mirrored**: left ink x24..28 y523..528, right ink x192..196 y523..528 => **84.0** either side of the sidebar centre **110.0**; title ink 78..141 centre **109.5** (0.5 = the conventional rounding); column centres **26.0 + 28.0i** => **28.0 on 6/6**; row band tops **561 + 21.0i** => **21.0 on 5/5** | **PASS** |
| **M03** | `font.pixelSize: 11` (in 10-11); each of the six bands is **9 rows at the same +0 offset** (561..569 ... 666..674) => one baseline; 2-digit ink **12 px** (20..31) and 1-digit **6 px** (23..28) both give centre **26.0** => the single digit is *centred on the column*, not left-aligned to the 2-digit box; `background: null` and **no >100 px run of any 200..227 tone in any row or column** of y505..690 | **PASS** |

## 本轮 (R112)
Atomic step: **re-verify M01/M02/M03 on the current build** — 0 source files touched, **no build**, **no new leg** (R111's light capture is the same binary). Files: `docs/ui-calendar/r112-m-mini-month.png` (new figure: the ref's mini month above ours, both 1:1, guides labelled), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`.
**One calibration was needed to get the margins right, and it is load-bearing.** A run of ink pixels **p..q spans the continuous interval [p, q+1)**, so its centre is **(p+q+1)/2**. The inclusive form `(p+q)/2` gave centres 25.5/.../193.5 and margins **11.5 / 12.5** — an asymmetry that is *impossible*, because both margins are literally the same property (`root.tahoe.categoryInset`, `Main.qml:2122-2123`). With `(p+q+1)/2` the same pixels give centres **26.0 + 28.0i** and margins **12 / 12**, reproducing `categoryInset` exactly. **The source broke the tie: use the half-open interval.**
**Three by-products read on the same capture (recorded, not claimed as clauses).** (i) **Our month chevrons are much smaller than the ref's** — ours 4x5 px of ink, the ref's 9 px tall on *both* arrows; M02 asks only for *equal* arrows, which holds, so this is an unfiled ref-fidelity gap, not a clause failure (now 仍差 #7). (ii) The selection disc on Apr 2 is a 15x15 `selectionFill` disc with its number in `tahoe.accent` and a 1 px border — the M04 surface, untouched this round (no *today* is on screen: now = 2026-10-17, the strip week is April). (iii) **The archived note "the mini month's weekend cells (214,214,215)" did NOT reproduce**: on this light leg the rows between digit bands are **216/216 px of pure (228,228,228) all the way across, Sat/Sun included**. The (214,214,215) first caught in the disc's box is the **selection disc's own antialiased rim** (4-9 px per row), not a weekend cell fill.

## Archive — R110 .. R102
R110 dark leg of A03(b) PASS; R109 A03(b) light + opaque pre-blend + `allDayJointOverlap: 4`; R108 A03(a) + a reverted margin fix; R107 A02 3/3; R106 A01(a) band floor 26; R105 L03 5/5; R104 C05 radius 0.48; R103 slot pitch is a spec literal; R102 C05 pill width. **Full text: `rounds.md` tail (append-only).**

## 仍差 (top 7, visual-impact order) — **items 1-6 are ruling-blocked; #7 is not**
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
7. **Our month chevrons are 4x5 px of ink where the ref's are 9 px tall** (both arrows, read at 1:1, R112). M02 demands only *equal* arrows — satisfied — so **this is not a clause failure, it is an unfiled ref-fidelity gap**. **Not ruling-blocked:** it is a plain glyph-size question on the two 28x28 `KosToolButton`s in `Main.qml`'s `miniCalendarHeading`.
- **ALL CLOSED:** T01/T02/T03 (R111) · A03 on **both clauses and both legs** (R109/R110) · A02 3/3 (R107) · A01 but for G (R106) · L03 5/5 (R105) · C05 but for its two blocked halves (R104) · C05's pitch question (R103) · the pill's padding+radius, L03's label order, C05's label token (R102-R099) · C05's dark leg (R098) · clause 1's chrome (R097). **Full text: `rounds.md` tail.**
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger, R108's band measurements.)*

## ## 最近已改 (most recent 8)  [R112 appended; R104 archived to rounds.md]
0. R112 — **verification only**: M01/M02/M03 re-read on R111's light capture at the **expanded** geometry. 0 source files touched, no build, no leg. Figure `r112-m-mini-month.png` (ref above / ours below, guides labelled).
1. R111 — **verification only**: T01/T02/T03 on a fresh light leg. Figure `r111-t-rules-3panel.png`.
2. R110 — **verification only**: the dark leg of A03(b). Figure `r110-a03b-dark-joint.png`.
3. R109 — **A03(b)**: `CalendarScheduleView.qml` — `scheduleField` token + `allDayBackdrop()`, `allDayJointOverlap: 4`, the chip's opaque `mix(backdrop, itemColor, a)` fill, `Layout.leftMargin: -4` when continuing with a column to its left.
4. R108 — **A03 measured; 1 hunk written and REVERTED** (the chip delegate's negative `Layout` margins failed on their own evidence).
5. R107 — **verification only**: A02 re-verified 3/3; figure `r107-a02-shared-edge-3panel.png`.
6. R106 — **A01's clause (a)**: the band's row count is now content-derived (one-row floor, A04's 3-row cap).
7. R105 — **L03 PASS 5/5** (verification only).

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A PIXEL RUN p..q IS THE HALF-OPEN INTERVAL [p, q+1) — ITS CENTRE IS (p+q+1)/2 (R112, load-bearing calibration).** The inclusive form `(p+q)/2` shifts every centre 0.5 px left; on the mini month it produced margins **11.5 / 12.5** where the layout can only have equal ones (`Main.qml:2122-2123` sets the *same* `categoryInset` on both sides). The source broke the tie, and the half-open form then reproduced `categoryInset` = **12 / 12** exactly. **Corollary (the project's own R066/R111 convention): a GAP written as `line - last_ink_pixel` ("ink 44, line 52 => gap 8") is the inclusive form and reads 1 larger than the continuous gap.** Mixing the two forms is a 1 px error — so state which form a gap came from.
- **A RULE ROW'S GUTTER SEGMENT IS THE LABEL, NEVER A LINE (R111, load-bearing).** The hour/half-hour rules span **x272..x1099** only — the grid's
  left edge to the window's last pixel. In a rule row the only non-white pixels left of x272 are the gutter label's own ink (`238..264`). => **"does the
  rule reach across the gutter?" must be scanned right of the label ink, never by a whole-row `!= white` test.**
- **A CLIPPED LABEL BAND IS STILL AN ALIGNMENT READING IF ITS INK X-EXTENT MATCHES ITS SIBLINGS (R111).** The topmost visible label is clipped by the
  scroll viewport (visible 234..238 of a 230..238 band), so its visible-band *centre* reads 2 px late. Judge alignment on unclipped bands, or on the
  clipped band's **identical ink x-extent**.
- **THE HOUR LABELS SCROLL WITH THE GRID (R111, load-bearing).** At `contentY 240` (= 6x40) the top tick is hour 6 at screen y234 and the label bands sit
  at 274/314/.../674 — a gutter scan must be indexed by **tick**, not by absolute hour. The y-map **above** the grid (155 / 156..231 / 232-233 / 234) is
  fixed and does not scroll; only the grid's own rules and labels move.
- **EXPANDED-SIDEBAR T03 GEOMETRY, MEASURED (R111).** Gutter **221..272**; label ink **x238..264**, right gap **8** to the grid line at 272 — the same 8
  as the collapsed leg's R066 reading (ink 44, line 52). Separators **1 px 237** at **272/391/510/629/748/867** (**pitch 119**); weekend tint **249**
  right of the x867 separator. Label band = **9 rows**, font 11.
- **T01/T02/T03 ARE PASS ON THE CURRENT BUILD, LIGHT LEG (R111).** Pitch 40.0/20.0, `contentHeight 960`, tones 237/244, ordering 242 < 237 < 217, label
  centres on ticks with gap 8. **The dark leg's 59/43 tones were read R065 and are NOT re-witnessed since R109's rebuild — one dark leg is owed before
  T can be called final-regressed.**
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
  `date{date}` / `position{contentY}` / `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` / `openItem{kind,titleContains}`.
  ⇒ **`hovered`/`pressed` chrome cannot be driven**; **a static screenshot can never settle an animation.**
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
**#1 — the T DARK LEG (owed, cheap, the last thing T is missing).** `gridLine` 59 / `gridLineMinor` 43 were measured at **R065**, *before* R109 rebuilt the binary ⇒ **one dark kill+relaunch closes T on both legs.** Re-read exactly R111's T01/T02/T03 rows on the dark capture: pitch 40/20, tones 59/43 one row each, ordering **39 < 59 < 84**, every label band centred on its own tick, gap 8. **Verification only — fix nothing unless a clause is demonstrably off.**
**#2 — M01-M03's dark leg is NOT read** (this round closed the light leg only). Cheap to fold into #1's dark leg if the mini month is legible there (sidebar plane dark 30, weekend field 37 per R110) — but #1 is the atomic step, so only take it if it costs no extra capture.
**Then:** the chain in spec order — **S02/S03/S05, C01-C04/C06, E01/E02** (clauses 1+2+3 PASS), **L01-L07** (L03 done R105).
**T01/T02/T03 done R111 (light). M01/M02/M03 done R112 (light). A03 done BOTH clauses and BOTH legs (R108-R110). A01 done but for G (R106); A02 done (R107).**
**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month
`slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel
exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R110 were done inline.**
**The binary was rebuilt at R109 (the guarded version) and every figure from R109 on comes from THAT build; any pre-R109 screenshot predates the opaque fill, so re-run a leg before comparing.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105 5/5; A02 PASS 3/3 R107; A03 PASS both clauses, both legs (R108/R109/R110).
**T01/T02/T03 PASS on a fresh light leg (R111); M01/M02/M03 PASS on the light leg at the expanded geometry (R112)**; **A01** PASS-pending-final-regression with clause (a) measured R106; **A04** fully PASS (+2 row re-verified mid-band R106);
**E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02/A03/A04 M04 closed R093 + R094**;
**S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**;
**C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
