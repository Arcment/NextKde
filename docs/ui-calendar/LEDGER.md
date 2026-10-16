# R115 — **M04 read for the first time.** The clause has three halves and the frame settles all three: **today PASSES in form** (solid red disc, white number, byte-for-byte the reference's construction) **but is 15 px where the clause says 18–20**; **"other selection" FAILS** (ours is a hollow **blue** ring with a dim gray digit, the clause says **gray**); **"outside-month muted" PASSES** (114 vs 216). One capture, one figure, **0 source files touched, no build, no relaunch**.

**Why this round.** M04 was the only spec ID in the whole `spec.md` that had **never been read** — every prior M leg used `date 2026-04-02`, whose week (Apr 2026) contains **no today**. `date 2026-10-15` is the launch week: it contains **today = Sat Oct 17** *and* the **selection = Thu Oct 15** (the launch date). **Both states render in the same frame** — the fixture M04 has been missing since R008.

## 本轮 (R115)
Atomic step: **read M04.** Files: `docs/ui-calendar/r115-m04-states.png` (new figure — ref mini month 1:1 above ours 1:1, then three ×6 zooms: *ref today / our selection / our today*), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`. Capture `r115-m04-week.png` is **free** — it reuses the still-live R113 dark instance (`live-app.pid` 188348, `kill -0` clean) at 1100x692 with the sidebar expanded.

### The three halves, measured
1. **today — form PASS, size the open question.** Our disc: **x 159..171 (15 px wide), y 599..613 (15 rows)**, core **(229,72,77)**, digit **white** (89 px with min channel > 170). The reference's, measured 1:1 for the first time: **x 91..105, y 395..409 = 15x15**, core **(207,51,35)**, digit **white** (31 px > 200). **Identical construction: solid disc + white number.** M04's literal is *"red **18–20** circle"*. **15 fails the literal.** The reference is not the clause either: its mini-month column pitch is **24.25** (weekday-header ink centres **25 / 49.5 / 73.5 / 97.5 / 122**, plus `10` at 146.5 and `11` at 169.5) against our **28.0** ⇒ **scale 1.155** (the sidebar ratio 220/192 = 1.146 agrees) ⇒ the ref disc in our layout would be **17.3 px**, also under 18. **So the clause is not a restatement of the reference at any scale we can measure, and our 15 is small under both readings.**
2. **"other selection gray" — FAIL.** Ours is a **hollow ring**: outer **x 102..116 / y 599..613** (15x15), ring peak **(0,136,255)** with the AA ladder `(22,84,139) (14,102,179) (7,119,218)`, and the selected digit `15` drawn in **(63,63,66)** — 32 px, the modal non-plane tone of the cell, i.e. a **dim gray-blue glyph inside a blue outline**. M04's *own today clause* shows what the state is meant to be — a **filled disc with a white number** — so "other selection **gray**" is that same disc in gray. **Blue-and-hollow is neither.**
3. **"outside-month muted" — PASS.** Same 40 plane, same 7 columns: row 6 (Nov 2..8) cell 0 ink **(114,114,114)** vs in-month row 4 cell 0 ink **(216,216,216)** ⇒ **0.53** of the in-month luminance. Muted, and measurable.

### What this round corrects
- **R114's by-product (vi) was wrong on one word.** It recorded the selection digit as keeping *"the ordinary text tone"*. It does not: in-month digits are **~216–220**, the selected digit is **63**. R112/R114 read the ring at a threshold that never separated the digit from it. **The ×6 zoom is what settled it** — at 1:1 a 9-row glyph inside a 15 px ring is not legible enough to carry a tone claim.
- **Re-witnessed (R114's by-products).** Our six date bands here sit at **tops 561/582/603/624/645/666** — the *same* geometry as the April capture, so the mini-month grid is **month-independent**; and the disc again overhangs its 9-row band by **4 above / 2 below** (599..613 about 603..611).

### Recorded, not claimed
- The same frame shows **our locale is `2026年10月` / `一二三四五六日` with the week starting Monday** (Oct 12 sits in column 一), where the reference reads **`April 2026` / `S M T W T F S`**. A pre-existing divergence in the mini month's *heading and header row*, **unfiled** — M02's clauses (equal arrows, seven equal columns, six equal date rows) are all still satisfied and are **not** affected by it.
- Our sidebar's **pure-black bottom-left wedge** (R114) is visible at the foot of the 1:1 strip, on the dark leg, again.

## Verdicts
**M04 — read, and it does not pass: 1 of 3 halves PASS (outside-month muted), 1 PASSES in form but misses its size literal (today), 1 FAILS outright (other selection).** M04 therefore moves from **PENDING / never read** to **MEASURED, 2 gaps open** — and both gaps are plain implementation questions in the mini-month delegate, **not ruling-blocked**. **Verification only: nothing was fixed this round.**

# R114 — **M01, M02 and M03 PASS on the DARK leg** — the mini calendar is now re-read on **both legs of the current build**, and the dark leg is **byte-identical to the light one on every disc-free path** (the two arrow ink boxes, the title's ink box at four thresholds, all six date-band rows, the per-column ink runs at x=26 and x=194). Arrows **x24..27 / x192..195, y523..527** (4x5 each) => half-open centres **26.0 / 194.0** => **84.0 / 84.0** about the sidebar centre **110.0**; **7 equal columns** (header centres 26/54/82/110/138/166/194, pitch **28.0 on 6/6**) and **6 equal date rows** (tops **561/582/603/624/645/666**, pitch **21.0 on 5/5**) drawn as six **9-row** bands => one baseline; block edges **12..208** => **12 / 12**; no cell border (longest non-plane run in the block **44 px**); x211..219 pure **(40,40,40)** => no sidebar scrollbar.

**Why this round.** M was the last spec family unwitnessed on dark. **0 source files touched, no build, no capture, no relaunch** — the R113 dark instance was still alive (`live-app.pid` 188348) and `r113-t-rules-dark-strip.png` was already at the required state (1100x692, expanded sidebar, `date 2026-04-02`).

## 本轮 (R114)
Atomic step: **re-verify M01/M02/M03 on the dark leg** — 0 source files touched, **no build, no capture, no relaunch**. Files: `docs/ui-calendar/r114-m-dark-pair.png` (new figure: the dark mini month above the light one, same crop x0..220 y505..692 at x2 NEAREST, with the SAME guides on both panels — magenta column centres **26+28i**, blue band tops **561+21i**, green block edges **12/208**; every guide lands identically), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md` (which also took the archived R113 header block).
**New and load-bearing: the sidebar's 1 px rim at x220 exists on BOTH legs (dark `(53,53,53)`, light `(224,224,224)`) — a whole-sidebar ink scan must stop at x219.** A scan over x0..**220** on dark returns **ONE band (490,691)**, because the rim makes every row read as ink; the same scan on light *looked* clean only because 224 is within 8 of the 228 plane, so it slipped under the threshold. **A whole-sidebar test that passes on light can be silently vacuous on dark.**
**By-products (recorded, not claimed as clauses).** The mini month carries **no fill of its own** on either leg — the block's field IS the plane — so M01's **12/12 is arithmetic, not tonal** (it follows from `cellWidth 196/7 = 28.0` and the column centres and can never be read off an edge). **A band scan on a disc-bearing row must be disc-free (x <= 99):** the 15x15 selection disc (x102..116, **y557..571**) extends 4 px above and 2 px below the 9-row band, which is why a full-width row-1 band reads 557..571 while R112's disc-free scan read 561..569. The disc is **15x15 on both legs**, a **blue ring** (dark core `(25,106,178)`, light ~`(39,152,250)`) with the digit in the ordinary text tone; the selected weekday's **header glyph is accent-tinted on both legs** (x105..114 y542..549). A pure-**black** region (x0..6, y677..691, 122 px) sits at the sidebar's bottom-left on **both** legs — theme-independent, invisible to R112's 200..227 test. And **an ink box on a dark leg is threshold-sensitive at ±1 px** (R112's `x24..28/y523..528` and this round's `x24..27/y523..527` are the same glyph at two thresholds) — **the reliable instrument is the PAIR**, which agreed byte for byte.

## Archive — R113 .. R102
R113 T01/T02/T03 on the **dark** leg (+ the translucent-dark-`gridLine` composite); R112 M01/M02/M03 light (+ the half-open-interval calibration); R111 T light; R110 dark A03(b); R109 A03(b) light + opaque pre-blend; R108 A03(a); R107 A02 3/3; R106 A01(a) band floor 26; R105 L03 5/5; R104 C05 radius 0.48; R103 slot pitch is a spec literal; R102 C05 pill width. **Full text: `rounds.md` tail (append-only).**

## 仍差 (top 8, visual-impact order) — **items 1-6 are ruling-blocked; #7 is unfiled, #8 is a spec clause**
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
8. **M04 is PENDING and has never been read, and R114's by-product says it is probably wrong.** The clause: *"Mini today red 18–20 circle with white number; other selection gray; outside-month muted."* What we ship, measured on both legs: a **blue 15 px ring** with the digit in the **normal text tone** for the selection. **The today disc has never been captured at all** (the Apr-2026 fixture week contains no today) — `date 2026-10-15` is the launch week and *does* contain today, so one capture separates the two states. **Not ruling-blocked; this is a spec clause, so it is read first and fixed only after the verdict is recorded.**
- **ALL CLOSED:** T01/T02/T03 (R111) · A03 on **both clauses and both legs** (R109/R110) · A02 3/3 (R107) · A01 but for G (R106) · L03 5/5 (R105) · C05 but for its two blocked halves (R104) · C05's pitch question (R103) · the pill's padding+radius, L03's label order, C05's label token (R102-R099) · C05's dark leg (R098) · clause 1's chrome (R097). **Full text: `rounds.md` tail.**
- *(archived to rounds.md tail: R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger, R108's band measurements.)*

## ## 最近已改 (most recent 8)  [R114 appended; R105 archived to rounds.md]
0. R114 — **verification only**: M01/M02/M03 on the DARK leg, reusing the still-live R113 dark capture. 0 source files touched, no build, no capture, no relaunch. Figure `r114-m-dark-pair.png`.
1. R113 — **verification only**: T01/T02/T03 on a fresh DARK leg at R111's exact geometry. 0 source files touched, no build. Figure `r113-t-rules-dark.png`.
2. R112 — **verification only**: M01/M02/M03 on R111's light capture at the expanded sidebar. Figure `r112-m-mini-month.png`.
3. R111 — **verification only**: T01/T02/T03 on a fresh light leg. Figure `r111-t-rules-3panel.png`.
4. R110 — **verification only**: the dark leg of A03(b). Figure `r110-a03b-dark-joint.png`.
5. R109 — **A03(b)**: `CalendarScheduleView.qml` — `scheduleField` token + `allDayBackdrop()`, `allDayJointOverlap: 4`, the chip's opaque `mix(backdrop, itemColor, a)` fill, `Layout.leftMargin: -4` when continuing with a column to its left.
6. R108 — **A03 measured; 1 hunk written and REVERTED** (the chip delegate's negative `Layout` margins failed on their own evidence).
7. R107 — **verification only**: A02 re-verified 3/3; figure `r107-a02-shared-edge-3panel.png`.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE SIDEBAR'S 1 px RIM AT x220 EXISTS ON BOTH LEGS (R114, load-bearing).** Dark `(53,53,53)` at x220 with the plane 40 at x219; light `(224,224,224)` with the plane 228. **A whole-sidebar ink scan must stop at x219:** over x0..**220** the dark leg returns a single band (490,691) because every row contains the rim, while the light leg's rim is only 4 tones off the plane and hides under a threshold of 8. **A whole-sidebar test that passes on light can be silently vacuous on dark — always name the x range and check the rim.**
- **THE MINI MONTH HAS NO FILL OF ITS OWN (R114, load-bearing).** The block's field IS the sidebar plane ((40,40,40) dark / 228 light, the dominant tone in **every** row of the block), so **M01's 12 / 12 margins are arithmetic, not tonal**: they follow from `cellWidth 196/7 = 28.0` and the column centres 26.0 + 28.0i (=> cells 12..208 in a 220 px sidebar) and can never be read off a fill edge. The same is true on light.
- **A BAND SCAN ON A DISC-BEARING ROW MUST BE DISC-FREE (R114).** The 15x15 selection disc (x102..116, y557..571) extends **4 px above and 2 px below** the 9-row text band, so a full-width scan of the Apr 2 row reads 557..571 while a scan over **x <= 99** reads 561..569 (R112's clean six 9-row bands). The disc is **15x15 on both legs**; its ring is blue (dark core `(25,106,178)`, light ~`(39,152,250)`) and the digit keeps the ordinary text tone — **not M04's "gray selection" / "red today"**. It never appears in the Apr-2026 fixture's today state, because today (2026-10-17) is not in that week.
- **THE PAIR, NOT THE BOX, IS THE INSTRUMENT ON A DARK LEG (R114).** An ink box reads ±1 px differently against a 40 plane than against 228 (dark `x24..27 / y523..527` vs light/R112 `x24..28 / y523..528` for the SAME glyph at two thresholds). So a dark-leg fidelity claim must rest on a **pair comparison** — arrow vs arrow, dark vs light, at two thresholds — where it agreed byte for byte, and never on an absolute box edge.
- **A PIXEL RUN p..q IS THE HALF-OPEN INTERVAL [p, q+1) — ITS CENTRE IS (p+q+1)/2 (R112, load-bearing calibration).** The inclusive form `(p+q)/2` shifts every centre 0.5 px left; on the mini month it produced margins **11.5 / 12.5** where the layout can only have equal ones (`Main.qml:2122-2123` sets the *same* `categoryInset` on both sides). The source broke the tie, and the half-open form then reproduced `categoryInset` = **12 / 12** exactly. **Corollary (the project's own R066/R111 convention): a GAP written as `line - last_ink_pixel` ("ink 44, line 52 => gap 8") is the inclusive form and reads 1 larger than the continuous gap.** Mixing the two forms is a 1 px error — so state which form a gap came from.
- **A DARK `gridLine` COMPOSITES, A LIGHT ONE DOES NOT (R113, load-bearing).** The dark separators read **59** over the weekday field 30 and **65** over the weekend tint 37 — one token, `white@0.13`, two backdrops. The light `#EDEDED` is opaque and reads 237 everywhere. => **"all separators share one tone" is a light-leg fact; a dark scan must expect two, and a differing separator tone is not a separator-tone bug until the backdrop under it is checked.**
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
**#1 — M04, the one spec ID that has NEVER been read (and R114's by-product says it is probably wrong).** One capture at `date 2026-10-15` — the launch week, which **does** contain today (2026-10-17) — to read the mini month's three states at once: **today** ("red 18–20 circle with white number"), **other selection** ("gray"), **outside-month** ("muted"). Our by-product from R114: the *selection* disc is a **blue 15 px ring with the digit in the normal text tone** (x102..116, y557..571, both legs) — likely an M04 gap, but the *today* surface is entirely unread, so this leg is the only way to know. **Check `kill -0 $(cat live-app.pid)` first: if a dark instance is alive the capture is FREE** (`date 2026-10-15` -> `sidebar expanded` -> `captureClient` -> `stop`); otherwise one kill+relaunch. **Verification only — record the M04 verdict; do not fix it in the same round.**
**#2 — 仍差 #7, the month chevrons (unfiled, NOT ruling-blocked).** Our two `KosToolButton`s in `Main.qml`'s `miniCalendarHeading` draw **4x5 px** of ink (now re-measured R114: x24..27 / x192..195, y523..527, both legs) where the ref's arrows are **9 px** tall. M02 demands only *equal* arrows — satisfied — so this is a plain glyph-size question: one atomic edit + one light leg.
**Then:** the chain in spec order — **S02/S03/S05, C01-C04/C06, E01/E02** (clauses 1+2+3 PASS), **L01-L07** (L03 done R105).
**T01/T02/T03 done BOTH legs (R111 light / R113 dark). M01/M02/M03 done BOTH legs (R112 light / R114 dark). A03 done BOTH clauses and BOTH legs (R108-R110). A01 done but for G (R106); A02 done (R107). M04 NEVER read (next round).**
**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R114 were done inline.**
**The binary was rebuilt at R109 (the guarded version) and every figure from R109 on comes from THAT build; any pre-R109 screenshot predates the opaque fill, so re-run a leg before comparing.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105 5/5; A02 PASS 3/3 R107; A03 PASS both clauses, both legs (R108/R109/R110); T01/T02/T03 PASS BOTH legs (R111 light, R113 dark); M01/M02/M03 PASS BOTH legs (R112 light, R114 dark); M04 PENDING/never read; A01** PASS-pending-final-regression with clause (a) measured R106; **A04** fully PASS (+2 row re-verified mid-band R106); **E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02/A03/A04 M04 closed R093 + R094**; **S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**; **C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
