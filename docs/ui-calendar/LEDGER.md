# R082 — **the Thu band-chip order swap is RUN-TO-RUN, not theme-dependent. R080's "light vs dark" reading was confounded by the run.**
Three launches of the **SAME build**, same fixture and view/date (`view week` + `date 2026-04-02`), each cropped to the Thu column's band:
**light1 = `Release notes` r0 / `Design sync` r1; dark1 = the SAME; light2 = REVERSED.** Two same-theme legs disagreeing is the whole
proof. **No code changed, no build.** Mechanism read, not guessed: the model *does* sort (`Main.qml:1159-1166`, all-day first then
`itemDateTime.localeCompare`), `allDayItems()` is an order-preserving filter, and the fixture's two Thu all-day VEVENTs have
**identical DTSTART/DTEND** ⇒ the comparator returns 0 ⇒ a stable sort keeps an **upstream order that is nondeterministic** (it is
neither file order nor its reverse). Figure: `docs/ui-calendar/r082-thu-band-3legs.png`. (2026-10-17)

## 本轮 (R082)
Atomic step: **classify the swap — no edit, no build.** Budget: 3 launches (pids 141747 → 143818 → 144014 → 144185) + 1 scan script +
1 composite read = well under budget. Each leg: kill `live-app.pid`, `start-review-vm.sh <theme>`, sleep 30, then ONE flat drive list
(`resize 1100x692` + `view week` + `date 2026-04-02` + `captureClient`). All three logged `capture … true`. **The three PNGs are the
same byte size, 3050463, and different md5** — the R069/R079 "same size ⇒ stale" trap checked and cleared.
**The numbers.** light1 r0 = `Release notes`, r1 = `Design sync`; **dark1 identical**; **light2 r0 = `Design sync`, r1 = `Release notes`.**
**The numeric form of the same fact:** per-column max-deviation-from-fill over x504..648 is a **character-identical ASCII string**
between legs — light1.r0 == light2.r1 and light1.r1 == light2.r0.
**Band y-map held on all three legs** (row0 157-180, gap 181, row1 182-205, third slot 206-231 empty; rule y155 = 242 light / 39 dark;
fill (220,236,246) light / (35,65,83) dark) ⇒ the swap is **content**, not layout; R073's y-map is exact two rounds on.
**What this kills.** R080's stated rule "the two Thu band chips swap order between the light and dark launches" is **withdrawn** — the
theme was confounded with the run. Never again attribute an ordering difference to the theme without two legs of the same theme.

## E01/E02 status (tester's call, R082)
Timed chip — **bar PASS (R077), no border PASS (R078), dark same-hue ink PASS (R079)**. Band chip — **ink PASS on the ref's own numbers
(R080)**. **The band chip's ring icon is MEASURED (R081) but NOT built — blocked on ruling H** (decoration vs checkable control) and on
one decision: ring **16** (vertical ratio) vs **22** (horizontal ratio). **R082 changed no code ⇒ R080's regression evidence stands.**

## 仍差 (top 8, visual-impact order)
1. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole 6,
   inset 3 from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px right of
   the ring's outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**, drawn at the chip's left inside edge; the
   title then shifts right. **Also unanswered: the thin-stroke family** (stroke ~1.5, hole ~9) on the neutral-248 chips. **Do NOT build
   either until H is answered.**
2. **A02 — band expansion / shared bottom edge.** Band height is a fixed 76; the ref grows it with the number of all-day rows and shares
   the bottom edge with the 2px `allDaySeparator`. **Never reviewed; needs a fixture with 1 and 4 all-day rows.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right
   edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
6. **`slice(0, 2)` per cell drops a 3rd item with no `+N`** (R048). The month day cell holds 1 chip + `N` where the ref stacks 3.
   **Needs ruling D — and a 3-all-day-item day before the band half can be reproduced at all.**
7. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on
   **ruling G**. Do not chase without a ruling.
8. **The Thu band-chip order is NON-DETERMINISTIC (R082 — CLOSED as a defect, fix deferred).** Equal-start all-day items tie in
   `Main.qml:1159-1166`'s comparator and the upstream order is unstable ⇒ light1 ≠ light2 on the same build. **The fix is one
   deterministic tiebreak in that sort (UID, then title) — no ruling needed**; the regression is the same 3-leg experiment. **Only
   affects fixture-shaped ties (identical DTSTART); no ref anchor exists for a tiebreak order, so pick any stable key.**
- *Cosmetic / settled, no ID:* the band's empty third slot is visibly ruled (R074's separators cross it). `secondary` hover = neutral
  grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius **16** vs spec 24/32 — **keep 16**. Topmost
  visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on the viewport top (R066; scroll artifact).
  **Ref band-chip fill alpha ≈0.16, ours 0.17** — a ~1-level difference, not worth a round.

## 最近已改 (most recent 8)
1. R082 — **verdict only, NO code changed**: the Thu band-chip order swap is **run-to-run**, not theme-dependent; R080's theme rule
   withdrawn; the mechanism named (equal `DTSTART` ties in the model's sort). Figure in `docs/ui-calendar/`.
2. R081 — **measurement only, NO code changed**: the band chip's ring icon → 12x12 / stroke 3 / hole 6 / inset 3 / item-colour ink; the
   thin-stroke second family found; the anisotropic-scale question raised. Detail now lives in `LEDGER.md` R081.
3. R080 — **the band chip's ink**: `allDayChip` gained a derived `inkColor` (same expression as `timedChip`), Label `color:` →
   `allDayChip.inkColor`. Ref-anchored 1:2 on two ref colours.
4. R079 — **E01/E02 step 3**: `timedChip` Label `color:` `AppTheme.text` → derived `inkColor` = the colour halfway to its pole.
5. R078 — **E01/E02 step 2**: `timedChip`'s `border.width: 1` + `border.color` **deleted**.
6. R077 — **E01/E02 step 1**: `timedChip` gained a saturated same-hue left bar — derived `stripeWidth`/`stripeInset` (= 4, from
   `chipHeight/4`), capsule radius, vertical margin 2, `color: itemColor(modelData)`; Label `leftMargin` 5 → derived.
7. R076 — **A03**: `allDayChip`'s `radius` → four corner radii, square where `allDayContinues(item, columnDate, ±1)`; new injected
   `itemRecord` + `isoDay`/`isoDayPattern`/`lastCoveredDay`/`allDayContinues`.
8. R075 — **A01 step 5**: `allDayChip` `radius: 5` → `Math.round(root.allDayRowHeight / 3)` = **8**.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **CROSS-LAUNCH CONTENT ORDER IS NOT STABLE, AND THE THEME IS NOT THE VARIABLE (R082).** Three legs of one build, same fixture and
  date: light1 == dark1 ≠ light2 on the Thu band-chip order. ⇒ **any "X differs between light and dark" claim needs two legs of the
  same theme**, and any ordering difference needs a tie analysis before it needs a theme analysis.
- **AN EQUAL-START TIE IS DECIDED UPSTREAM, NOT BY OUR SORT (R082).** `Main.qml:1159-1166` sorts all-day-first then by
  `itemDateTime` lexicographic, and `CalendarScheduleView.qml:136-145` `allDayItems()` filters order-preserving ⇒ two items with
  identical `DTSTART` **compare 0** and `Array.sort`'s stability just preserves whatever arrived. The fixture's Thu pair
  (`Design sync` UID `…r072-allday-a` / `Release notes` UID `…-b`, both `DTSTART;VALUE=DATE:20260402`) renders **b,a** in two legs and
  **a,b** in the third ⇒ the upstream order is neither the ICS order nor its reverse. **Any future "items are in the wrong order" bug:
  check for an equal key first.**
- **THE BAND CHIP'S ICON IS A 12x12 RING, INSET 3 FROM THE CHIP'S FILL (R081).** Outer **12**, **stroke 3**, **hole 6**, vertically
  centred (fill 18 ⇒ 3 top / 3 bottom), outer left edge **3 px right of the fill's left edge**, **colour = `itemColor`, full saturation,
  no alpha**. Text ink starts **17-19 ref px** right of the ring's outer-left edge ⇒ **ours @x1.33: 16 / stroke 4 / inset 4 / text at
  fill_left + 28**. The ring is **not a stripe** — R077's x491-493 read was this ring's left arc.
- **THE REF HAS TWO RING WEIGHTS AND THE RULE IS UNKNOWN (R081).** Stroke **3 / hole 6** on the tinted-wash chips (purple (187,62,216),
  blue-grey (133,148,172)); stroke **~1.5 / hole ~9** on the **neutral-248** chips (blue (76,121,232), salmon (235,186,179)). ⇒ **record
  the correlation only, never encode a rule off it.** An implementer needs ruling H first.
- **OUR SCALE IS ANISOTROPIC: x1.33 VERTICAL, x1.83 HORIZONTAL (R081).** Ref chip fill 18 tall x 81 wide vs ours 24 x 148. Any circular
  or square icon must pick one axis — **use the vertical ratio for anything that must fit the 24-px row**; the horizontal one only for
  things that must span the column (e.g. R077's stripe width).
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Now measured on **five** ref colours — three *timed* bars
  (red, blue, olive) and two *band* ring colours (purple (187,62,217), blue-grey (133,148,173)) — all **1:2 on every channel**, plus nine
  of our chips in both legs by the coverage test. ⇒ **any future "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`, never a typed
  hex and never an alpha.** Corollary: the *dark* leg is the ref's rule mirrored, not a ref measurement — the ref image has no dark mode,
  so **dark chip colours are extrapolation** and must be labelled as such.
- **IN A CHIP, THE RING ICON'S COLOUR IS THE ITEM COLOUR (R080).** The purple ring reads (187,62,217) and the timed-chip bar for the same
  calendar reads (187,62,216) — full saturation, no alpha. ⇒ **when the band icon is built, its colour is `itemColor(item)` with no
  `withAlpha`.**
- **AN INK IS SETTLED BY THE COVERAGE TEST PLUS THE **B−R GAP** (R079/R080).** `t = (fill − pixel)/(fill − ink)` must agree per channel
  (±0.05); but when the fill is only lightly saturated the *hue* direction and the *grey* direction can sit <10° apart (ours: 9.6° on the
  blue) and the pixel count separates weakly. **The exact discriminator is a channel gap the fill cannot reach: here `B − R` is 26 in the
  fill yet 50 in the ink's pixels at t≈0.48 — no neutral endpoint can do that.** Use the gap, not the count.
- **THE HULL FAILS AS AN INK INSTRUMENT (R079, re-confirmed R080).** Our light band chip's *darkest* pixel is (60,71,121) — off the
  fill→ink segment (G too dark) — while dozens of mid-coverage pixels fit the assumed ink to ±0.005. **Never read an ink off the extreme
  pixel in either theme.**
- **THE REF'S ALL-DAY BAND HAS TWO CHIP FAMILIES, AND ONE IS UNEXPLAINED (R080).** (a) *Coloured*: same-hue wash + same-hue ink at 1:2 +
  same-hue ring (purple, blue-grey). (b) *Neutral*: fill **248**, ink **(38,38,38)** — a neutral pair that **cannot** be `itemColor` and
  `itemColor/2` of the same source — while the **ring** is strongly coloured. **Do not cite the neutral chips for any ink or fill rule;
  they are not explained by our model.**
- **A CROSS-ROUND PNG IS NOT POSITION-ALIGNED (R079, strengthened R082).** Same session, view and date, two rounds: different chip sets
  at the same y, and in the dark pair a *green* chip in one round where the next has *blue*. **R082: this is true of two launches of the
  same build** — the *layout* map (columns, y-bands) has held for 8 rounds; **content maps never have**. ⇒ **never A/B two captures
  pixel-for-pixel for content; re-derive the content map on every capture, and treat layout maps as stable.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>` if `live-app.pid` points at a running `kos-calendar`. ⇒ **`kill "$(cat live-app.pid)"`
  first, keep the launcher's stderr, and check `live-app.pid` changed** (R082: 141747 → 143818 → 144014 → 144185). **R082: 3 launches
  in one round is comfortable; the `leg.sh` helper (kill → nohup launch → sleep 30 → one flat drive list → md5) is the shape to reuse.**
- **A CHIP EDGE CAN ONLY PROVE "NO BORDER" IF IT DOES NOT ABUT A RULE (R078).** Read a **top or bottom** edge as a RAW profile and check
  monotonicity — a real border is a row darker *and* more saturated than the fill; a corner/AA row is *lighter*.
- **THE REF BAR IS AN ABSOLUTE STROKE, NOT A FRACTION OF THE CHIP (R077).** 2.4 ref px on an 11 px 30-min chip *and* on a 22 px 60-min
  chip ⇒ ours stays `chipHeight/4` = 4 on the fixed 16 px chip **regardless of duration**. The horizontal scale is the one to use for its
  width (×1.85 on the column).
- **OUR `timedChip` GEOMETRY AFTER R079/R080 (light 1100x692):** chip = column + 3 (Container `anchors.margins: 3`), so Thu = **505..648**;
  **fill 505-508, bar 509-512** (4 px, capsule), text ink from **518**. Light fill `(216,234,245)`, dark fill `(36,69,90)`, bar
  `(48,140,198)` light and dark. **Our chip calendar colours are NOT the ref's**: ours blue **(48,140,198)** / green **(57,196,135)** /
  gold **(215,166,44)** (read off the bars, which are `itemColor` with no alpha) — so our ink is the same *rule* on a different source.
- **OUR `allDayChip` AFTER R080:** fill `withAlpha(itemColor, dark ? 0.32 : 0.17)` — light blue reads **(220,236,246)**, dark **(35,65,83)**
  (R082 re-read, exact); ink `itemColor` halfway to the pole — light **(24,70,99)**, dark **(152,198,227)** for that blue. Row 0 = y
  **157-180**, gap **181**, row 1 = **182-205**, third slot **206-231**; band chip inset 1 ⇒ fills 53..200 / 203..350 / 353..500 /
  503..650…; Label `leftMargin: 5`.
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076).** Measured: all 21 band rows carry the column rule unbroken and every
  chip's fill is inset 1–2 px inside **one** column ⇒ **A03's clause has no ref anchor; say "spec-only".**
- **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The ICS carries `DTEND;VALUE=DATE:20260403` for `Multi-day
  review`; the record's end is the **inclusive last day (Apr 2)** and the popover prints `2026年3月30日星期一 – 2026年4月1日星期三`.
  `Main.qml:itemDetailsRange` and `lastCoveredDay` agree ⇒ any new range math must subtract one day. **R072's "Thursday carries 3
  all-day items" is WRONG** — Apr 2 holds exactly 2 (`Design sync`, `Release notes`).
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** ⇒ **if the R074 separators
  are ever removed, A03's rendering collapses back into "one pill per day". The two changes are a pair.**
- **`itemRecord` IS AN INJECTED PROPERTY ON `CalendarScheduleView` (R076)**, bound in `Main.qml`'s two schedule views. A view that omits
  it gets `({})` ⇒ `continuesLeft/Right` false ⇒ every chip fully rounded (falls back to the R075 shape, no crash). Any *new*
  schedule-view instance must bind it or silently lose A03.
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R082).** Corner: per-row **fill-start inset**. Joint: per-row
  **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a
  raw profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap argument**.
  **Ordering/content: a per-column deviation-from-fill profile rendered as an ASCII ramp string — equal strings are equal content
  (R082).** **Caveat: read the *fill* channel, not luminance** — antialiased text and ring icons poison a luminance scan.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT filename**; it
  lands in the app's CWD (= the directory `start-review-vm.sh` was launched from). **Always read the success flag in
  `live-runtime-vm.log`** (`… capture <name> true`) and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`; measured y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237).
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R082 (dark too, R082).** `sectionRule` **y=155**
  (242 light / 39 dark, 1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237).
  Chips **157-180**, gap **181**, **182-205**, third slot 206-231. **The band is net +28 vs R070 — the grid has permanently lost ~28px
  of viewport.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081).** Rows **y126-143, y145-162, y164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 both legs**; content **125..182 = 58**; band total **60**.
  Chip radius **≈6 = row/3**; chip fill inset **1–2 px**; fill alpha **≈0.16**; **ink = itemColor/2** (R080); **ring icon 12x12, stroke
  3, hole 6, 3 px inside the chip's fill edge** (R081). Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 / 2-row content 49 /
  separators present / strip continuous / hue ink — every *form* item matched **except the icon (仍差 #1)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**; chip spans its
  column's full width minus ~1 px each side (rule 487 → fill 488…569). Fill = light desaturated same-hue wash (blue (222,237,254), red
  (251,228,227)); **text = dark same-hue = the bar at 1:2 on every channel** (R079); **left bar 2.4 px, ~3 px in, round caps**; **no
  border/ring on any edge** (R078). Ours: fill `withAlpha(itemColor, .19 light / .36 dark)`, ink halfway to the pole, bar done, border
  deleted. Ref chip ink starts **7 ref px** in from the fill edge; ours: chip = column + 3, text ink from column + 16.
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
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark; the
  gutter is NOT tinted. The all-day band shares the column's fill.**
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
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R082).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is
  a JSON list**, bumps `sequence` itself, writes **in place** (never `os.replace`). The whole drive list in ONE invocation works fine.
- **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it (`nohup … > log 2>&1 &`). **It EXITS 1
  without launching if `live-app.pid` still points at a live `kos-calendar` (R079) — kill that pid first, keep the launcher's stderr, and
  check that `live-app.pid` changed.** A rebuilt binary needs a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never
  `pkill`. ~24 s to the new pid (30 s is a safe sleep). Include `resize 1100x692`; it starts in `--view week --date 2026-10-15`, so every
  drive list must re-send `view week` + the date. **The theme is fixed at launch — a dark leg costs a full kill+relaunch.** **App stderr
  goes to `live-runtime-vm.log`** — read the capture success flags there before believing any capture. **R082: `leg.sh <theme> <name>`
  does the whole leg (kill, launch, sleep 30, drive, md5) in one call; three legs fit one round comfortably.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs
  Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 / **Design review** 14:30 /
  Evening session 18:00; plus a **`Multi-day review`** all-day strip with **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`**
  (line 574) ⇒ covers Mon 30 · Tue 31 · Wed 1 only and **does not appear on Thursday**. `Design sync` (**ICS 832-834, UID
  `…r072-allday-a`**) + `Release notes` (**ICS 842-844, UID `…-b`**) are two separate **single-day** all-day VEVENTs on **2026-04-02**,
  **byte-identical in DTSTART/DTEND** ⇒ **Apr 2 carries exactly 2 all-day items, and they are an order TIE (R082)**. VTODOs (kind
  `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect
  elision` 11:00, **`[R019 LONG TASK] 任务长标题与编辑表单检查`**. **The rendered week also shows `[R019 LONG EVENT]`, `Prepare notes`,
  `Review checklist` — re-read the ICS before predicting a cell's contents.**
- **Row-band measurement idiom (R046/R062–R082):** scan the target column (or row) for pixels that are **not** the background, threshold,
  group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to
  find horizontal lines. **Caveats:** keep the window strictly inside the region; the separator and the first hour line can be **adjacent
  rows**; the x=0 rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact — **but a row-mean
  over a *populated* grid is poisoned by chips, so find hour lines in an empty column instead.** **R070: a VERTICAL profile of one empty
  column is decisive for a per-column property.** **R071: fix the column map first.** **R072: a vertical profile also catches a LAYOUT
  defect (7/13/6 spacing).** **R074: the same run-scan at the band row AND the grid row proves "now matches" in one call.** **R075: for a
  CORNER, per-row fill-start inset.** **R076: for a JOINT, the per-row `!= white` envelope.** **R077: for a STRIPE, a saturation run-scan
  whose width is constant over the full height; a classified 2D ASCII dump is the cheapest way to see an icon you were told was a stripe.**
  **R078: for a BORDER, a raw RGB profile across an edge that abuts no rule.** **R079: for an INK, the coverage test — dark leg scans for
  the BRIGHTEST text pixels, the mirror of the light leg's darkest. R080: add the channel-gap check and use `Counter` modes for the fill.
  R082: for CONTENT IDENTITY across captures, a max-deviation-from-fill profile per column as an ASCII ramp string — string equality is
  the test, and it needs no threshold tuning.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert `im.size`
  first. **A composite (1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read.** **R076: label the rows in
  the composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.**
  **R078: a ×6 `NEAREST` edge crop is right for "is there a 1px ring" — back it with raw numbers.** **R080: a `Counter` mode over a cell
  gives the fill in one call.** **R082: a ×3 `LANCZOS` stacked composite with a black label bar per leg is the whole verdict in ONE image
  read — do this instead of reading three crops.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
  **R069/R071/R079/R082: two different PNGs can be byte-identical in SIZE — `md5sum` before concluding a capture is stale.**

## Next round (pick ONLY #1)
**#1 — make the Thu band-chip order deterministic (仍差 #8), the smallest fix the R082 verdict unlocks.** Add a **stable tiebreak** to
the existing sort at **`apps/calendar/qml/Main.qml:1159-1166`**: when `itemDateTime(left).localeCompare(itemDateTime(right)) === 0`,
fall back to `String(value(left,"seriesId", value(left,"id",""))).localeCompare(String(value(right,"seriesId", value(right,"id",""))))`
— i.e. the all-day items' **UID**, which the fixture carries (`…r072-allday-a` / `…-b`) and which is unique by construction; if that is
still 0, compare `itemTitle`. **Do not reorder anything else, do not touch the all-day-first rule, and do NOT touch the icon, fills,
inks, corners, separators or the timed chip.** Regress with **exactly R082's 3-leg experiment**: `leg.sh light light1`, `leg.sh dark
dark1`, `leg.sh light light2`, then the ASCII profile strings — **pass condition: all three legs' r0/r1 strings identical, and the same
title in r0 in all three.** Note the expected winner: `Design sync` (UID `…-a`) sorts before `Release notes` (`…-b`), so r0 becomes
`Design sync` — that is fine, it is a *stability* fix, not a ref match (no ref anchor exists for the tie).

**Then (unlocked, ref-anchored, one per round):** **N02** (now-line + red badge — needs a capture of the **current** week); **A02** —
blocked until a fixture with 1 and 4 all-day rows exists; V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only).

**Blocked on rulings A–H:** the **band icon (H, R081 — measured, needs only the ruling and one decision: 16 vs 22)**, dim snap (A),
shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), `slice(0,2)` / month 1-chip cap (D — also
needs a 3-all-day-item day), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the ref's
measured 1**. **The `code-writer` subagent is NOT registered in this session** — R072–R082's edits were made directly; do not retry
`code-writer` each round. **Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03
PASS**; **E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080); everything else PENDING or ruling-blocked. **R082 changed no code
⇒ R080's regression evidence still stands.**)
