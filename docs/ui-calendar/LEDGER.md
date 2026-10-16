# R082 — **the Thu band-chip order swap is RUN-TO-RUN, not theme-dependent. R080's "light vs dark" reading was confounded by the run.**
No code changed, no build — three launches of the **same** build, same fixture, same view/date (week of **Mon 2026-03-30**, i.e.
`view week` + `date 2026-04-02`), each cropped to the Thu column's band and stacked into one x3 composite
(`r082-thu-band-3legs.png`, x498..656 y150..214). The two chips are the fixture's **two single-day all-day VEVENTs on 2026-04-02**.
**Result: light1 = `Release notes` r0 / `Design sync` r1; dark1 = `Release notes` r0 / `Design sync` r1; light2 = `Design sync` r0 /
`Release notes` r1.** So the two **light** launches disagree with each other ⇒ **the swap reproduces without changing theme: it is an
unstable order, not a dark-mode branch.** The band y-map held **exactly** on all three captures (row0 y157-180, gap y181, row1 y182-205,
section rule y155 = 242 light / 39 dark, fill (220,236,246) light / (35,65,83) dark) ⇒ the swap is content, not layout.
**Confirmed numerically**, not by eye: a per-column max-deviation-from-fill profile over x504..648 is **character-identical between
legs** — light1.r0's profile string equals light2.r1's, and light1.r1's equals light2.r0's. **Mechanism (read, not guessed):** the model
*does* sort (`Main.qml:1159-1166`: all-day first, then `itemDateTime(left).localeCompare(...)`), then `CalendarScheduleView.qml:136-145`
`allDayItems()` filters it order-preserving; the two fixture events have **identical `DTSTART;VALUE=DATE:20260402`/`DTEND:...20260403`**
(UIDs `…r072-allday-a` `Design sync`, `…-b` `Release notes`) ⇒ **the comparator returns 0 and the tie is decided upstream** — and the
upstream order is neither the file order nor its reverse (light1/dark1 render b,a; light2 renders a,b) ⇒ **nondeterministic upstream
ordering for equal-start all-day items.** Fix is one deterministic tiebreak in that sort; not attempted this round.

# R081 — **the ref's all-day band chip icon is a 12x12 RING: outer 12, stroke 3, hole 6, inset 3 from the chip's fill on left/top/bottom.**
Measured on the ref only — **no code changed, no build, nothing was built.** The band chip's ring icon was 仍差 #1 and had never been
measured, so this round measured it: a x6 `NEAREST` crop of six ref rings plus raw row/column profiles. The ring is **12x12 ref px**
(Wed1 r0 x491-502, y129-140) inside a chip fill spanning y126-143 ⇒ **vertically centred, 3 px top and bottom**; its **outer left edge
sits 3 px right of the chip's fill left edge** on **all four** chips checked (Wed1 fill 488/ring 491, Fri3 651/654, Sun29 r2 244/247,
Mon30 326/329) — and the fill is **rule + 1**. **Two stroke weights exist**: stroke **3 / hole 6** in purple (187,62,216) and blue-grey
(133,148,172), stroke **~1.5 / hole ~9** in blue (76,121,232) and salmon (235,186,179); both are 12 outer, and the correlation is
**thick ⇔ tinted-wash fill, thin ⇔ neutral-248 fill** (R080's *unexplained* family). The *reason* is not measurable off a PNG ⇒ **ruling
H**. Text ink starts **17-19 ref px** right of the ring's outer-left edge. **Nothing is built until H is answered** (decoration vs
checkable control). Figure: `r081-bandicon-ref-geometry.png`. (2026-10-17)

**Ring, exact.** Wed1 r0 centre row: x491(188,66,218) 492(187,62,216) 493(193,78,220) | wash x494-499 | x500(201,103,225)
501(187,62,217) 502(189,68,218) ⇒ stroke 3 / hole 6 / outer 12. Centre column: ring y129-131, hole y132-136, ring y137-140 (the 4th row
of that run is AA). Sun29 r0 blue-grey is pixel-identical in form (x247-249 / hole / x256-258). **Thin family:** Mon30 r0 =
x329(76,121,232) 330(164,186,241) | hole x331-338 | x339(102,141,235) 340(138,167,238) ⇒ outer 12, stroke ~1.5, hole ~9; Fri3 r2
salmon (235,186,179) is 1 px with heavy AA. **Ring colour = the item colour at full saturation, no alpha** (re-confirms R080) — and it is a
**ring, not a stripe** (R077's x491-493 read was this ring's left arc).
**Chip geometry re-confirmed on ring-bearing chips.** Fill left = **rule + 1** (Wed1 488/rule 487, Fri3 651/650, Sun29r2 244/243, Mon30
~326/324); fill spans **y126-143 = 18 rows** ⇒ R072's row 18 / gap 1 / pitch 19 holds; fills (244,226,249) purple, (234,236,240)
blue-grey, (248,248,248) neutral.
**THE SCALE IS ANISOTROPIC — the round's one open design number.** Ref chip fill is 18 tall x 81 wide, ours is 24 x 148 ⇒ **x1.33
vertical, x1.83 horizontal**, and a circle cannot use both. Recommended (vertical ratio, so the icon fits the 24-px row): **ring
16 = round(row x 2/3), stroke 4 = 16 x 3/12, hole 8, inset 4 = round(24 x 3/18) on left/top/bottom, text ink at fill_left + 28** (ref
3+12+6 = 21, x1.33). The horizontal ratio would give ring 22 / inset 5.5 — rejected: 22 on a 24-px row leaves 1 px and puts the title at
+38. **No ref anchor exists for the two-weight rule** — record the correlation, do not encode it.
**Archived out of state.md (superseded by the above):** *the ref's same-hue left stripe is a TIMED-GRID-CHIP property; the band chip has
an icon instead (R077)* — R073's "x=491-493 = (187,62,216) stripe" is the band ring's left arc (hollow centre x495-496); never cite the
ref for a stripe in the all-day band.
**Evidence:** `docs/ui-calendar/r081-bandicon-ref-geometry.png` (6 rings, x6 NEAREST, 1-ref-px grid).
**Next:** the icon is blocked on **ruling H**; the next unblocked step is the Thu band-chip order swap (仍差 #8).
# R080 — **the all-day band chip's ink is the calendar colour at HALF VALUE — measured on the REF, not inferred from the timed chip.**
The band chip's Label was `AppTheme.text` (grey) while the timed chip's was the R079 hue ink, so the two chip families disagreed in one
screenshot. The ref had **never** been measured for the band-chip ink, so this round measured it first: each coloured ref band chip's **ink
core against its own ring-icon colour** (the icon is the item colour) reads **purple (187,62,217) → (93,30,108)** and **blue-grey
(133,148,173) → (67,74,86)** — **1:2 on every channel**, the .5 rounding down on the odd ones. Same rule as R079, now anchored in the
*band* by the ref. Edit: `allDayChip` gained the same derived `inkColor`; its Label `color:` → `allDayChip.inkColor`. (2026-10-17)

## 本轮 (R080)
Atomic step: **the all-day band chip's Label `color:` `AppTheme.text` → a derived `inkColor`** (`CalendarScheduleView.qml`, `allDayChip`
+ Label only). No border, radius, separator, `slice(0,2)`, inset or geometry change.
**Ref measurement first — the round's real content.** Ref band rows y126-143 / 145-162 / 164-181, chips inset ~1 inside the column rule.
Per coloured chip, the ink core (extreme cluster) vs the ring icon at chip_start+6:
- purple ring **(187,62,217) → ink (93,30,108)** (April Fool…, Passover, Good Fri… — three chips, same numbers)
- blue-grey ring **(133,148,173) → ink (67,74,86)** (Sun "Antonio…", two rows)
Both are **exactly half on every channel** (187/2=93.5→93, 217/2=108.5→108, 173/2=86.5→86). ⇒ **the band chip's ink is R079's rule, and
the ring-icon colour *is* the item colour** (useful for the future icon work: the icon is `itemColor`, no alpha).
**Our legs after the edit (coverage test `t = (fill − pixel)/(fill − ink)`, which must agree per channel).** Light blue (48,140,198),
fill (220,236,246): (125,155,175) ⇒ **0.48/0.49/0.48**; (50,90,118) ⇒ 0.87/0.88/0.87; (101,133,154) ⇒ 0.61/0.62/0.63 — spread ≤0.019,
**25 px <0.05**. Dark, fill (35,65,83), ink (152,198,227): (92,130,153) ⇒ **0.49/0.49/0.49**, **40 px <0.05**.
**Why a grey ink is excluded even though the pixel *count* separates only ~2.3× in light.** The decisive statistic is the **B−R gap**: the
fill's B−R is **26 light / 48 dark**, so *no* neutral endpoint can produce the observed **50 at t=0.48** (light) or **61 at t=0.49**
(dark); only an endpoint of the fill's own hue can. (Reason for the weak count: on our low-saturation blue the hue direction and the grey
direction are only **9.6° apart**; a green or gold band chip would separate them sharply. Our band fixture is blue only.)
**Regression:** band fills + the timed chip's light fill (216,234,245) read as in R079; multi-day strip joints square, corners, radii,
separators intact; `slice(0,2)` untouched. **Evidence:** `docs/ui-calendar/r080-bandink-{light,dark,compare,dark-band-x2}.png`.

## E01/E02 status (tester's call, R080)
Timed chip — **bar PASS (R077), no border PASS (R078), dark same-hue ink PASS (R079)**. Band chip — **ink now PASS on the ref's own
numbers (R080)**. **Still open in the chip language: the band chip's ring icon (ours has none) — needs a ruling, see 仍差 #1.**

## 仍差 (top 8, visual-impact order)
1. **The all-day BAND chip's icon — ours has NONE** (this is now the biggest visible chip-family gap). Ref: four **12×12 ring-shaped**
   blobs (hollow centres) at x247-258 / 329-340 / 491-502 / 654-665, i.e. **~4 ref px inside the column rule** on an 18-px row ⇒ ours ~15 px
   at ×1.33, ~5 px in, at the chip's **left inside edge**, colour = `itemColor` (**R080: the ring colour *is* the item colour**). Text
   must then shift right the way the ref's does. **Needs a ruling on the icon's source/shape** (is it a ring outline we draw, or a
   checkable circle?) — **do not start without one.**
2. **A02 — band expansion / shared bottom edge.** Band height is a fixed 76; the ref grows it with the number of all-day rows and shares
   the bottom edge with the 2px `allDaySeparator`. **Never reviewed; needs a fixture with 1 and 4 all-day rows to be measurable at all.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right
   edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
6. **`slice(0, 2)` per cell drops a 3rd item with no `+N`** (R048). The month day cell holds 1 chip + `N` where the ref stacks 3.
   **Needs ruling D — and a 3-all-day-item day before the band half can be reproduced at all.**
7. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on
   **ruling G** (the spec's "inset 2–3" is the same number read in ref px). Do not chase without a ruling.
8. **The two Thu band chips swap order between the light and dark launches** (light: `Release notes` then `Design sync`; dark: reversed)
   — observed in R080's own two captures with the same fixture. An **ordering instability** in the model/view, not a rendering defect.
   Low impact, no ID. **Unverified whether it is run-to-run or theme-dependent — do not patch blind.**
- *Cosmetic / settled, no ID:* the band's empty third slot is visibly ruled (R074's separators cross it). `secondary` hover = neutral
  grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius **16** vs spec 24/32 — **keep 16**. Topmost
  visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on the viewport top (R066; scroll artifact).
  **Ref band-chip fill alpha ≈0.16, ours 0.17** (purple wash (244,226,249) / blue-grey (234,236,240) both solve to 0.16) — a ~1-level
  difference, not worth a round.

## 最近已改 (most recent 8)
1. R080 — **the band chip's ink**: `allDayChip` gained a derived `inkColor` (same expression as `timedChip`), Label `color:` →
   `allDayChip.inkColor`. Ref-anchored 1:2 on two ref colours. Nothing else in the band.
2. R079 — **E01/E02 step 3**: `timedChip` Label `color:` `AppTheme.text` → derived `inkColor` = the colour halfway to its pole.
3. R078 — **E01/E02 step 2**: `timedChip`'s `border.width: 1` + `border.color` **deleted**. Nothing else touched.
4. R077 — **E01/E02 step 1**: `timedChip` gained a saturated same-hue left bar — derived `stripeWidth`/`stripeInset` (= 4, from
   `chipHeight/4`), capsule radius, vertical margin 2, `color: itemColor(modelData)`; Label `leftMargin` 5 → derived.
5. R076 — **A03**: `allDayChip`'s `radius` → four corner radii, square where `allDayContinues(item, columnDate, ±1)`; new injected
   `itemRecord` + `isoDay`/`isoDayPattern`/`lastCoveredDay`/`allDayContinues`.
6. R075 — **A01 step 5**: `allDayChip` `radius: 5` → `Math.round(root.allDayRowHeight / 3)` = **8**.
7. R074 — **A01 step 4**: the band's `allDayColumn` gained the grid's column separators (1px `gridLine` left edge + right rim on the last
   column); y=215 = 237 at 52/202/352/502/652/802, identical to the grid.
8. R073 — **A01 step 3**: `allDayBandInset` 3 → **1**; band 80 → **76** (derived); separator 236/237 → **232/233**, first hour line → **234**.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Now measured on **five** ref colours — three *timed* bars
  (red, blue, olive) and two *band* ring colours (purple (187,62,217), blue-grey (133,148,173)) — all **1:2 on every channel**, plus nine
  of our chips in both legs by the coverage test. ⇒ **any future "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`, never a typed
  hex and never an alpha.** Corollary: the *dark* leg is the ref's rule mirrored, not a ref measurement — the ref image has no dark mode,
  so **dark chip colours are extrapolation** and must be labelled as such.
- **IN A CHIP, THE RING ICON'S COLOUR IS THE ITEM COLOUR (R080).** The purple ring reads (187,62,217) and the timed-chip bar for the same
  calendar reads (187,62,216) — full saturation, no alpha. ⇒ **when the band icon is built, its colour is `itemColor(item)` with no
  `withAlpha`, and its own ink/edge colours can be measured off the ref the same way.**
- **AN INK IS SETTLED BY THE COVERAGE TEST PLUS THE **B−R GAP** (R079/R080).** `t = (fill − pixel)/(fill − ink)` must agree per channel
  (±0.05); but when the fill is only lightly saturated the *hue* direction and the *grey* direction can sit <10° apart (ours: 9.6° on the
  blue) and the pixel count separates weakly. **The exact discriminator is a channel gap the fill cannot reach: here `B − R` is 26 in the
  fill yet 50 in the ink's pixels at t≈0.48 — no neutral endpoint can do that.** Use the gap, not the count.
- **THE HULL FAILS AS AN INK INSTRUMENT (R079, re-confirmed R080).** Our light band chip's *darkest* pixel is (60,71,121) — off the
  fill→ink segment (G too dark) — while dozens of mid-coverage pixels fit the assumed ink to ±0.005. **Never read an ink off the extreme
  pixel in either theme.**
- **THE REF'S ALL-DAY BAND HAS TWO CHIP FAMILIES, AND ONE IS UNEXPLAINED (R080).** (a) *Coloured*: same-hue wash + same-hue ink at 1:2 +
  same-hue ring (purple, blue-grey). (b) *Neutral*: fill **248**, ink **(38,38,38)** — a neutral pair that **cannot** be `itemColor` and
  `itemColor/2` of the same source, since fill 248 implies a pale colour while ink 38 implies a dark one — while the **ring** is strongly
  coloured (Mon: blue (69,117,232) and salmon (199,167,162); Thu/Fri: greyed (184,184,184) text = declined). **Do not cite the neutral
  chips for any ink or fill rule; they are not explained by our model.**
- **A CROSS-ROUND PNG IS NOT POSITION-ALIGNED (R079).** Same session, view and date, two rounds: different chip sets at the same y, and in
  the dark pair a *green* chip in one round where the next has *blue*. ⇒ **never A/B two rounds' captures pixel-for-pixel; re-derive the
  band map on every capture.** The R071 column map and the R073 y-map are layout maps and have held; content maps have not.
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>` if `live-app.pid` points at a running `kos-calendar` — a fresh launch then produces **no
  new process** and the *old* (e.g. other-theme) app answers the capture. ⇒ **`kill "$(cat live-app.pid)"` first, keep the launcher's
  stderr, and check `live-app.pid` changed (R080: 140999 → 141747).**
- **A CHIP EDGE CAN ONLY PROVE "NO BORDER" IF IT DOES NOT ABUT A RULE (R078).** Read a **top or bottom** edge (or two of them on two
  chips) as a RAW profile and check monotonicity — a real border is a row darker *and* more saturated than the fill; a corner/AA row is
  *lighter*. On a light-wash chip, an AA transition and no-transition are the same verdict.
- **THE REF'S SAME-HUE LEFT STRIPE IS A TIMED-GRID-CHIP PROPERTY; THE BAND CHIP HAS AN ICON INSTEAD (R077).** R073's "x=491-493 =
  (187,62,216) stripe" is the **band icon's left arc** (ring, hollow centre x495-496 — R080 reads the same colour as the ring's core).
  ⇒ **never cite the ref for a stripe in the all-day band**, and never read a saturated 3px run without checking it is constant-width
  top-to-bottom.
- **THE REF BAR IS AN ABSOLUTE STROKE, NOT A FRACTION OF THE CHIP (R077).** 2.4 ref px on an 11 px 30-min chip *and* on a 22 px 60-min
  chip ⇒ ours stays `chipHeight/4` = 4 on the fixed 16 px chip **regardless of duration**. The horizontal scale is the one to use for its
  width (×1.85 on the column).
- **OUR `timedChip` GEOMETRY AFTER R079/R080 (light 1100x692):** chip = column + 3 (Container `anchors.margins: 3`), so Thu = **505..648**;
  **fill 505-508, bar 509-512** (4 px, capsule), text ink from **518**. Light fill `(216,234,245)`, dark fill `(36,69,90)`, bar
  `(48,140,198)` light and dark. **Our chip calendar colours are NOT the ref's**: ours blue **(48,140,198)** / green **(57,196,135)** /
  gold **(215,166,44)** (read off the bars, which are `itemColor` with no alpha) — so our ink is the same *rule* on a different source.
- **OUR `allDayChip` AFTER R080:** fill `withAlpha(itemColor, dark ? 0.32 : 0.17)` — light blue reads **(220,236,246)**, dark **(35,65,83)**;
  ink `itemColor` halfway to the pole — light **(24,70,99)**, dark **(152,198,227)** for that blue. Row 0 = y **157-180**, gap **181**,
  row 1 = **182-205**; band chips inset 1 ⇒ fills 53..200 / 203..350 / 353..500 / 503..650…; Label `leftMargin: 5`.
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076).** Measured: all 21 band rows carry the column rule unbroken and every
  chip's fill is inset 1–2 px inside **one** column ⇒ **A03's clause has no ref anchor; say "spec-only".**
- **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The ICS carries `DTEND;VALUE=DATE:20260403` for `Multi-day
  review`; the record's end is the **inclusive last day (Apr 2)** and the popover prints `2026年3月30日星期一 – 2026年4月1日星期三`.
  `Main.qml:itemDetailsRange` and `lastCoveredDay` agree ⇒ any new range math must subtract one day and be checked against that popover.
  **R072's "Thursday carries 3 all-day items" is WRONG** — Apr 2 holds exactly 2 (`Design sync`, `Release notes`).
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** The ref does the same. ⇒
  **if the R074 separators are ever removed, A03's rendering collapses back into "one pill per day". The two changes are a pair.**
- **`itemRecord` IS AN INJECTED PROPERTY ON `CalendarScheduleView` (R076)**, bound in `Main.qml`'s two schedule views. A view that omits
  it gets `({})` ⇒ `continuesLeft/Right` false ⇒ every chip fully rounded (falls back to the R075 shape, no crash). Any *new*
  schedule-view instance must bind it or silently lose A03.
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R080).** Corner: per-row **fill-start inset**. Joint: per-row
  **`!= white` envelope** (flat = square, symmetric 4·2·1·1·0 = round). Stripe: a saturated run whose **width is constant over the chip's
  full height**. Border: **monotonicity of a raw profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement
  test PLUS the channel-gap argument** (R080). **Caveat: read the *fill* channel, not luminance** — antialiased text and ring icons sit
  inside the chip and poison a luminance scan.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT filename**; it
  lands in the app's CWD (= the directory `start-review-vm.sh` was launched from). **Always read the success flag in
  `live-runtime-vm.log`** (`… capture <name> true`) and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`; measured y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237).
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R080.** `sectionRule` **y=155** (242, 1px); band
  interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap **181**,
  **182-205**, third slot 206-231. **The band is net +28 vs R070 — the grid has permanently lost ~28px of viewport.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R080).** Rows **y126-143, y145-162, y164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 both legs**; content **125..182 = 58**; band total **60**.
  Chip radius **≈6 = row/3**; chip fill inset **1–2 px**; fill alpha **≈0.16**; **ink = itemColor/2** (R080); **per-calendar ring icon
  12×12, ~4 px inside the column rule**. Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 / 2-row content 49 / separators present /
  strip continuous / hue ink — every *form* item matched **except the icon (仍差 #1)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**; chip spans its
  column's full width minus ~1 px each side (rule 487 → fill 488…569). Fill = light desaturated same-hue wash (blue (222,237,254), red
  (251,228,227)); **text = dark same-hue = the bar at 1:2 on every channel** (R079); **left bar 2.4 px, ~3 px in, round caps**; **no
  border/ring on any edge** (R078, three edges). Ours: fill `withAlpha(itemColor, .19 light / .36 dark)`, ink halfway to the pole, bar
  done, border deleted. Ref chip ink starts **7 ref px** in from the fill edge; ours: chip = column + 3, text ink from column + 16.
- **REF EVENT CHIP COLOUR IDIOM (R063/R075/R077/R079/R080).** Light desaturated same-hue fill + dark same-hue text + saturated same-hue
  left bar (timed) or ring icon (band) + small radius. **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are
  HIG+token-anchored only. The ref's tinted chips carry their icon at the LEFT INSIDE EDGE ⇒ **crop the *second* chip row for a clean
  corner, or read the numeric profile instead.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R080):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51; separators at
  **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×149px delegates starting at 52. Columns **Mon 30 · Tue 31 ·
  Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5** (locale week starts Monday) ⇒ **weekend = the last two**; the band's right rim is on Sun's right
  edge (x=1102) and is clipped at 1100.
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark
  white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule`
  (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` has ZERO consumers in this view.** The requirement is the ORDERING: ref 242 <
  237 < 217; ours light 242 < 237 < 217, dark 39 < 59 < 84. `gridLineMinor` is a **half-hour line**, a different role. **R074: `gridLine`
  is consumed by THREE things — the grid's top/left/right edges AND the band's column separators.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with `Layout.fillWidth:
  true` ⇒ full window width. **R068: the top boundary spans identically.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right edge; the right
  rim is drawn only by `columnIndex === root.dayCount`. **R067 corollary:** the separator and the first hour line are **adjacent rows** with
  different weights. **R074 applied it to the band verbatim** and measured it single-width.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark; the gutter
  is NOT tinted. The all-day band shares the column's fill.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical centring via
  `-Math.round(implicitHeight/2)`. **A gutter scan must start at x ≥ 3** or the x=0 rim merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height =
  `Math.round(root.hourHeight * 21 / 54)` = **16**. Half-hour line = `Math.round(parent.height / 2)` = **20**. **R072 added the four
  `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor` — the same
  expression twice. If a third consumer appears, hoist it, do not copy it a third time.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar + mini
  calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 =
  **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns, 1px separators at
  x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the
  contract says 40; 40 was chosen). Hour lines and vertical separators are both **1px (237,237,237)**. Gutter label (ref x 215..238):
  digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge 238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue
  31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R080).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is
  a JSON list**, bumps `sequence` itself, writes **in place** (never `os.replace`). The whole drive list in ONE invocation works fine.
- **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it (`nohup … > log 2>&1 &`). **It EXITS 1
  without launching if `live-app.pid` still points at a live `kos-calendar` (R079) — kill that pid first, keep the launcher's stderr, and
  check that `live-app.pid` changed.** A rebuilt binary needs a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never
  `pkill`. ~24 s to the new pid (30 s is a safe sleep). Include `resize 1100x692`; it starts in `--view week --date 2026-10-15`, so every
  drive list must re-send `view week` + the date. **The theme is fixed at launch — a dark leg costs a full kill+relaunch.** **App stderr
  goes to `live-runtime-vm.log`** — read the capture success flags there before believing any capture. **R080: a full light build+capture
  then a dark kill+relaunch+capture fits in one round comfortably.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs
  Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 / **Design review** 14:30 /
  Evening session 18:00; plus a **`Multi-day review`** all-day strip with **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`**
  (line 574) ⇒ covers Mon 30 · Tue 31 · Wed 1 only and **does not appear on Thursday**. `Design sync` + `Release notes` are two separate
  **single-day** all-day VEVENTs on **2026-04-02** ⇒ **Apr 2 carries exactly 2 all-day items**, both rendered, both fully rounded.
  VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task
  title to inspect elision` 11:00, **`[R019 LONG TASK] 任务长标题与编辑表单检查`**. **The rendered week also shows `[R019 LONG EVENT]`,
  `Prepare notes`, `Review checklist` — re-read the ICS before predicting a cell's contents.**
- **Row-band measurement idiom (R046/R062–R080):** scan the target column (or row) for pixels that are **not** the background, threshold,
  group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to
  find horizontal lines. **Caveats:** keep the window strictly inside the region; the separator and the first hour line can be **adjacent
  rows**; the x=0 rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact — **but a row-mean
  over a *populated* grid is poisoned by chips, so find hour lines in an empty column instead.** **R070: a VERTICAL profile of one empty
  column is decisive for a per-column property.** **R071: fix the column map first.** **R072: a vertical profile also catches a LAYOUT
  defect (7/13/6 spacing).** **R074: the same run-scan at the band row AND the grid row proves "now matches" in one call.** **R075: for a
  CORNER, per-row fill-start inset.** **R076: for a JOINT, the per-row `!= white` envelope.** **R077: for a STRIPE, a saturation run-scan
  whose width is constant over the full height; a classified 2D ASCII dump is the cheapest way to see an icon you were told was a stripe.**
  **R078: for a BORDER, a raw RGB profile across an edge that abuts no rule.** **R079: for an INK, the coverage test — dark leg scans for
  the BRIGHTEST text pixels, the mirror of the light leg's darkest. R080: add the channel-gap check and use `Counter` modes for the fill.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert `im.size`
  first. **A composite (1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read.** **R076: label the rows in
  the composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.**
  **R078: a ×6 `NEAREST` edge crop is right for "is there a 1px ring" — back it with raw numbers.** **R080: a `Counter` mode over a cell
  gives the fill in one call; a per-candidate spread histogram is how an ink is confirmed or excluded.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
  **R069/R071/R079: two different PNGs can be byte-identical in SIZE — `md5sum` before concluding a capture is stale.**

## Next round (pick ONLY #1)
**#1 — the all-day band chip's 12×12 ring icon: measure its shape/geometry on the ref, and get a ruling on what it *is* before building it.**
This is now the largest remaining chip-family gap (ours has no icon; the ref has one on every band chip). The ref data is already in hand:
**four blobs at x247-258 / 329-340 / 491-502 / 654-665 on rows y126-143 / 145-162 / 164-181**, i.e. **~12×12, ~4 px inside the column
rule, hollow centre** (R077's "stripe" was its left arc at x491-493 = (187,62,216) = **the item colour**, per R080). Step 1 is a ×6
`NEAREST` crop of **one** ref ring (e.g. the Wed 1 purple one at x491-502, y127-141) plus a classified dump to get the ring's **outer
diameter, stroke width and centre offsets** — then write those numbers into state.md as the spec for whoever builds it. **Do NOT build it
this round**: the open question is whether the ring is a static decoration or a checkable control (macOS makes it a completion checkbox),
and that is **ruling H** — ask for it, do not guess. **Do NOT touch** the chip fills, inks, corners, separators, `slice(0,2)` or anything
in the timed chip.

**Then (unlocked, ref-anchored, one per round):** **A02** — blocked until a fixture with 1 and 4 all-day rows exists; **N02** (now-line +
red badge — needs a capture of the **current** week); V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only).
**Cheap and unblocked if a round wants a small step:** the Thu band-chip **order swap between the two legs** (仍差 #8) is observable and
needs only two captures to classify run-to-run vs theme-dependent.

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` rewrite an already-nested `path`
into a flat basename; have `start-review-vm.sh` exit loudly (or auto-kill the owned instance) so R079's silent no-launch cannot repeat.

**Still blocked on rulings A–H:** dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS
R048), `slice(0,2)` / month 1-chip cap (D — also needs a 3-all-day-item day), **F = 12-hour two-tone gutter labels**, **G = A01's spec
literals (gap 2, inset 2–3) vs the ref's measured 1**, **H = the band icon's nature (R080, new)**. **The `code-writer` subagent is NOT
registered in this session** — R072–R080's edits were made directly; do not retry `code-writer` each round. **Not `DONE` — all spec IDs
do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03 PASS**; **E01/E02 clauses 1+2+3 PASS, and the band chip's
ink PASS on the ref's own numbers (R080)**; everything else PENDING or ruling-blocked.)
