# R078 — **E01/E02 step 2: the timed chip has no border, and the ref says so on the two edges that can prove it.**
Deleted `timedChip`'s `border.width: 1` + `border.color: withAlpha(itemColor, 0.34)`. **R077 could only read the chip's left
edge, which abuts the column rule at x=406 and so cannot tell "no border" from "border hidden by the rule".** This round read
the top and bottom edges — of **two different chips** — as raw 1:1 profiles. Ref Wed blue chip **top**: 255 → 242 (rule) →
249 → **230,242,254** (AA) → (222,237,254) fill. Ref Wed blue chip **bottom**: fill → **224,235,248** (AA) → 242 (rule) →
253,242,241 (next chip). Ref Tue blue chip **top**: 255 → 249 → 236 (hour line) → **239,246,255** (AA) → fill. **Every
transition goes LIGHTER than the fill; never darker.** A 1px ring at any alpha lands as a row darker *and* more saturated —
none of the three has one. Fill, text, `radius: 5`, the R077 bar (a child, structurally unaffected) and the whole all-day
band untouched. (2026-10-17)

## 本轮 (R078)
Atomic step: **E01/E02 step 2 — delete the timed chip's 1px border.** Evidence: `docs/ui-calendar/r078-noborder-light.png`
(light week, `view week` + `date 2026-04-02`), `r078-noborder-dark.png` (dark leg), `r078-noborder-compare.png`
(ref | ours at ×6 NEAREST, both edges).
**Measured on ours, both legs.** Light: column rule `237` at **x=502** → white 503-504 → fill `(216,234,245)` from **x=505**;
top row **277** is fill, bottom **292** → white **293**. Dark: rule `(59,59,59)` at 502 → grid `(30,30,30)` → fill
`(36,69,90)` from **x=505**; top **277**, bottom **292→293** identical. **The R077 bar reads `509-512 = (48,140,198)` in both
legs — bit-identical to R077's dark reading, so it survived the edit.**
**Why both themes:** the deleted border was a colour (`withAlpha(…, 0.34)`), so it is a colour change even though it reads as
a deletion — same rule R077 applied to the bar.
**Not touched:** `timedChip`'s fill alpha, `radius: 5`, the R077 bar, the Label margins; the all-day chip and band entirely.

## E01/E02 status (tester's call, R078)
**`Chip carries a saturated same-hue bar at its left edge` — PASS** (timed chip, the only family the ref anchors it on),
light + dark. **`Chip has no border/ring` — now PASS**, on ref-anchored evidence from three independent edges, light + dark.
**Still NOT passed and NOT started:** the ref's chip **text is dark same-hue** (red chip ink **(117,37,34)** on a (251,228,227)
wash; blue chip ink (99,131,172)+) where ours is grey `AppTheme.text`. **Do not read this round as "the chip language is
done".**

## 仍差 (top 8, visual-impact order)
1. **E01/E02 step 3 — the chip's text colour.** Ref text = **dark same-hue** (measured above); ours = `AppTheme.text`. **Next
   round #1.** Open sub-question: the ref's ink is a *translation* of the calendar colour, not the colour at reduced alpha —
   settle which before writing a number.
2. **The all-day BAND chip's icon — ours has NONE.** Four 12×12 blobs at x247-258 / 329-340 / 491-502 / 654-665 ⇒ ~4 ref px
   inside each column rule, on an 18-ref-px row ⇒ ours ~**15 px at ×1.33, ~5 px in**. Ring-shaped (hollow centres), *coloured
   per calendar*. Needs a decision on the icon's source/shape before it can be built — **do not start it without one.**
3. **A02 — band expansion / shared bottom edge.** The band's height is a fixed 76; the ref grows it with the number of all-day
   rows and shares the bottom edge with the 2px `allDaySeparator`. **Never reviewed. Needs a fixture with 1 and 4 all-day rows
   to be measurable at all** — do not start without deciding that first.
4. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the
   **suffix's** right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`.
   **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
6. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
7. **`slice(0, 2)` per cell drops a 3rd item with no `+N`** (R048; R076 proved R072's "aim it at the band" wrong — Apr 2
   carries exactly 2 all-day items). The month day cell holds 1 chip + `N` where the ref stacks 3. **Needs ruling D — and
   needs a 3-all-day-item day before the band half can be reproduced at all.**
8. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (R076: Thu chip 489..567 in a 487..569
   column). ~3.7 px at our scale ⇒ near-identical; **do not chase it without a ruling** — it rides on ruling G (the spec's
   "inset 2–3" is the same number read in ref px).
- *Cosmetic, no ID:* the band's empty third slot is visibly ruled (R074's separators cross it) — **ruling D, do not patch.**
  `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius **16** vs
  spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on
  the viewport top (R066; scroll artifact, not a form defect).

## 最近已改 (most recent 8)
1. R078 — **E01/E02 step 2**: `timedChip`'s `border.width: 1` + `border.color: withAlpha(itemColor, 0.34)` **deleted**
   (`CalendarScheduleView.qml:631-633`), replaced by a comment carrying the three-edge measurement. Nothing else touched.
2. R077 — **E01/E02 step 1**: `timedChip` gained a saturated same-hue left bar — derived `stripeWidth`/`stripeInset` (= 4, from
   `chipHeight/4`), capsule `radius: width/2`, vertical margin 2, `color: itemColor(modelData)`; Label `leftMargin` 5 → 13.
3. R076 — **A03**: `allDayChip`'s `radius` → four corner radii, square where `allDayContinues(item, columnDate, ±1)`; new
   injected `itemRecord` on the view (bound in `Main.qml`'s two `CalendarScheduleView`s) + `isoDay` / `isoDayPattern` /
   `lastCoveredDay` / `allDayContinues`. Single-day chips bit-identical to R075.
4. R075 — **A01 step 5**: `allDayChip` `radius: 5` → `Math.round(root.allDayRowHeight / 3)` = **8** (ref r≈6 on an 18px row).
5. R074 — **A01 step 4**: the band's `allDayColumn` gained the grid's column separators (1px `gridLine` left edge + right rim
   on the last column); y=215 = 237 at 52/202/352/502/652/802, identical to the grid; boundaries single-width.
6. R073 — **A01 step 3**: `allDayBandInset` 3 → **1**; band 80 → **76** (derived); separator 236/237 → **232/233**, first hour
   line 238 → **234**. Verified the gap stayed 1.
7. R072 — **A01 step 2**: row 18→**24**, gap 2→**1**, band 48→**80**, all derived from four new tokens; the band's
   `ColumnLayout` re-anchored to stop surplus spreading into the spacings.
8. R071 — **measurement only.** Dark weekend tint = **(37,37,37)** in band *and* grid; weekday 30; gutter and header row
   untinted; 155 = 39 and 204/205 = 84 unchanged.

## 外推待确认 (live only — R053's 9 older items, R070/R072's settled notes and the earlier blocks are archived to rounds.md tail)
- **A CHIP EDGE CAN ONLY PROVE "NO BORDER" IF IT DOES NOT ABUT A RULE (R078).** The left edge sits on the column rule and
  R077 mis-read a 1px border there; a **top or bottom** edge — or, better, two of them on two chips — carries the answer.
  **Idiom: read the RAW profile across the edge and check monotonicity** — a real border is a row darker *and* more saturated
  than the fill; a corner/AA row is *lighter*. Ours has neither, so on a chip whose fill is a light wash, **an AA transition
  and no-transition are the same verdict.**
- **THE REF'S SAME-HUE LEFT STRIPE IS A TIMED-GRID-CHIP PROPERTY, AND THE BAND CHIP HAS AN ICON INSTEAD (R077).** R073's
  "x=491-493 = (187,62,216) stripe" is the **band icon's left arc** (ring, hollow centre x495-496). ⇒ **never cite the ref for
  a stripe in the all-day band**, and never read a saturated 3px run without checking it is constant-width top-to-bottom.
  Corollary: **the band's chips do have a coloured element — a ~12×12 per-calendar ring icon ~4 px inside their column rule.**
- **THE REF BAR IS AN ABSOLUTE STROKE, NOT A FRACTION OF THE CHIP (R077).** 2.4 ref px on an 11 ref px 30-min chip *and* on a
  22 ref px 60-min chip. ⇒ ours stays `chipHeight/4` = 4 on the fixed 16 px chip **regardless of duration**. The horizontal
  scale is the one to use for its width (×1.85 on the column); the ink envelope is ~2.4 px, not the 3 px it reads at its
  thinnest.
- **OUR `timedChip` GEOMETRY AFTER R078 (light 1100x692):** chip = column + 3 (Container `anchors.margins: 3`), so Thu =
  **505..648**; **fill 505-508, bar 509-512** (4 px, capsule), text ink from **518**. Light fill `(216,234,245)`, dark fill
  `(36,69,90)`, bar `(48,140,198)` in both legs. **No border pixel at any edge, light or dark.** The Label's `leftMargin` is
  derived (`inset + width + 5`) — do not retype 13 if either token moves.
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076).** Measured, not assumed: all 21 band rows carry the column
  rule unbroken with chip fills on both sides, and every chip's fill is inset 1–2 px inside **one** column. ⇒ **A03's clause
  has no ref anchor; the ref can only anchor single-day all-day chips.** Corollary: **a claim that "the ref does X for
  multi-day strips" cannot be made from this image** — say "spec-only" instead.
- **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The ICS carries `DTEND;VALUE=DATE:20260403` for
  `Multi-day review`, the record's end is the **inclusive last day (Apr 2)**, and the popover proves the truth: it prints
  **`2026年3月30日星期一 – 2026年4月1日星期三`**. `Main.qml:itemDetailsRange` and the new `lastCoveredDay` both subtract one day
  and **agree with the popover** ⇒ the model is consistent; any new range math must subtract one day and be checked against
  that popover string. **Corollary: the corner rule and the column membership use *different* sources (record `start`/`end`
  vs the service's date expansion) — they agree today, so any future all-day membership change must be re-checked against the
  corners. Second corollary: R072's "Thursday carries 3 all-day items" is WRONG — Apr 2 holds exactly 2 (`Design sync`,
  `Release notes`); nothing is hidden by `slice(0, 2)` on this fixture.**
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** The ref does the
  same (its rule is unbroken through every band row). ⇒ **if the R074 separators are ever removed, A03's rendering collapses
  back into "one pill per day". The two changes are a pair.**
- **`itemRecord` IS A NEW INJECTED PROPERTY ON `CalendarScheduleView` (R076), bound in `Main.qml`'s two schedule views
  (`itemAllDay:`/`itemRecord:`/`itemHour:` neighbours). A view that omits it gets `({})` ⇒ `continuesLeft/Right` false ⇒ every
  chip fully rounded (falls back to the R075 shape, no crash, no binding error).** Any *new* schedule-view instance must bind
  it or silently lose A03.
- **A LITERAL `8` WOULD HAVE BEEN WRONG TO WRITE; `row/3` IS THE RULE (R075).** Ref chip radius ≈ **6 ref-px on an 18 ref-px
  row = one third of the row height**. **Any future corner — or bar, R077's `chipHeight/4` — must be derived from the box it
  sits in, not typed.** Corollary: **the ref's corner is a SQUIRCLE (continuous curvature)** — its first row reads 4.5 where a
  true circle of r=6 would read ~6 ⇒ **compare arc *length and orientation* against the box, never the first-row inset alone.**
- **MEASURING A CORNER, A JOINT OR A STRIPE (R075/R076/R077/R078).** Corner: per-row **fill-start inset** — the row where the
  inset reaches 0 is the radius. Joint: per-row **`!= white` envelope** — flat over all rows = square, symmetric 4·2·1·1·0… =
  round. Stripe: a saturated run whose **width is constant over the chip's full height** (a ring's arc fakes a 3px run on its
  tangent rows). Border: **monotonicity of the raw profile across an edge that does not abut a rule**. **Caveat: read the
  *fill* channel, not luminance** — antialiased text and ring icons sit inside the chip and poison a luminance scan.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT
  filename**; it lands in the app's CWD, which is **whatever directory `start-review-vm.sh` was launched from** — R078 launched
  from the task dir and the PNGs appeared **there** (R075 saw the repo root). **Always read the success flag in
  `live-runtime-vm.log`** (`… capture <name> true`) and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim
  on `index === root.dayCount - 1`. **Measured: y=215 (band) and y=250 (grid) produce the SAME run list** (52/202/352/502/652/802,
  all 237) and the boundary pixels are single-width (501=255, 502=237, 503=255). ⇒ **no band-only token; never "invent" a
  lighter band line.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED by R074–R078.** `sectionRule` **y=155** (242,
  1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips:
  **157-180**, gap **181**, **182-205**, third slot 206-231. **R072: the band grew 48 → 80 and R073 shrank it to 76, so it is
  net +28 vs R070 — the grid has permanently lost ~28px of viewport; check the visible hour range before touching either.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075/R076/R077).** Rows **y126-143, y145-162, y164-181** ⇒ **row 18, gap 1,
  pitch 19**; top rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 on BOTH legs** (R073); content
  **125..182 = 58**; band total **60**. Chip radius **≈6 = row/3**; chip fill inset **1–2 px**; **per-calendar ring icon 12×12
  ~4 px inside the column rule**. Ours now: row 24 / gap 1 / inset 1 / radius 8 / band 76 / 2-row content 49 / separators
  present / strip continuous — every *form* item matched **except the icon (see 仍差 #2)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077 + R078).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**; chip
  spans its column's full width minus ~1 px each side (rule 487 → fill 488…569). Fill = light desaturated same-hue wash (blue
  (222,237,254), red (251,228,227)); **text = dark same-hue** (red ink (117,37,34)); **left bar 2.4 px, ~3 px in, round caps**;
  **no border/ring on any edge (R078, three edges)**. Ours: fill `withAlpha(itemColor, .19 light / .36 dark)`, text
  `AppTheme.text`, bar done (R077), border deleted (R078). Ref chip ink starts **7 ref px** in from the fill edge. Ours: chip =
  column + 3, text ink from column + 16.
- **REF EVENT CHIP COLOUR IDIOM (R063 + R075 + R077).** Light desaturated same-hue fill + dark same-hue text + saturated
  same-hue left bar + small radius. **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are
  HIG+token-anchored only. **The ref's tinted chips carry their icon at the LEFT INSIDE EDGE** (the purple star's disc starts
  ~2 px in, the ring icon at ~4 px) — which is why a corner crop of a ref chip always contains the icon: **crop the *second*
  chip row for a clean corner, or read the numeric profile instead.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R078):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51;
  separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×149px delegates starting at 52
  (delegate edges land on 201.7/351.4/501.1…, so a band chip at inset 1 shows its fill on 53..200 / 203..350 / 353..500, and a
  timed chip — Container margins 3 — starts at 55/205/355/505…). Columns **Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4 ·
  Sun 5** (locale week starts Monday) ⇒ **weekend = the last two**. **The band's right rim is on Sun's right edge (x=1102) and
  is therefore clipped at 1100.**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` /
  dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24),
  `sectionRule` (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` now has ZERO consumers in this view.** *Don't call
  `sectionRule` "the lightest": `gridLineMinor` 244 is numerically lighter.* **The requirement is the ORDERING: ref 242 (top
  boundary) < 237 (hour line) < 217 (band bottom, 2px); ours light sectionRule 242 < gridLine 237 < allDaySeparator 217, dark
  39 < 59 < 84.** `gridLineMinor` is a **half-hour line**, a different role — never fold it in. **R074: `gridLine` is consumed
  by THREE things — the grid's top/left/right edges AND the band's column separators.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with
  `Layout.fillWidth: true` ⇒ full window width, matching the ref. **R068: the top boundary spans identically.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right edge:
  adjacent edges land on the same pixel row and render as 2px. The right rim is drawn only by `columnIndex === root.dayCount`.
  **R067 corollary:** the separator and the first hour line are **adjacent rows** with different weights — never read them as
  one band. **R074 applied it to the band verbatim** and **measured it single-width.**
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill. **Weekend
  columns are 249 light / 37 dark; the gutter is NOT tinted. The all-day band shares the column's fill.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical
  centring via `-Math.round(implicitHeight/2)`, **not** a tuned constant. **A gutter scan must start at x ≥ 3** or the x=0 rim
  merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height =
  `Math.round(root.hourHeight * 21 / 54)` = **16**. Half-hour line = `Math.round(parent.height / 2)` = **20**. **R072 added a
  second derived family for the band — the four `allDay*` tokens; R077 added the chip's `stripeWidth`/`stripeInset`.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px
  sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels
  193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day
  columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35,
  h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). Hour lines and vertical separators are both
  **1px (237,237,237)**. Gutter label (ref x 215..238): digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge
  238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R078).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `openItem` searches
  `reviewWindow.selectedItems` — **the items of the *selected* date**, so a popover test must send `date` first, and **"no
  popover appeared" is a usable negative result.** `review-command.py` takes **ONE argv that is a JSON list**, bumps
  `sequence` itself, writes **in place** (never `os.replace`) — it is **6 lines**; read it rather than guess. **R069–R078: the
  whole drive list in ONE invocation works fine.**
- **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it (`nohup … & disown`). A
  rebuilt binary needs a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~24 s to the new pid
  (26 s is a safe sleep). Include `resize 1100x692`. It starts in `--view week --date 2026-10-15`, so every drive list must
  re-send `view week` + the date. **The theme is fixed at launch — a dark leg costs a full kill+relaunch; a second capture in
  the same theme costs only a drill.** **App stderr goes to `live-runtime-vm.log`** — read the capture success flags there
  before believing any capture.
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**):
  VEVENTs Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 /
  **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`** all-day strip with
  **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`** (line 574) ⇒ it **covers Mon 30 · Tue 31 · Wed 1 only**
  (R076, popover-confirmed) and therefore **does not appear on Thursday at all**. `Design sync` + `Release notes` are two
  separate **single-day** all-day VEVENTs on **2026-04-02** (R072) ⇒ **Apr 2 carries exactly 2 all-day items**, both rendered,
  both fully rounded. VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00,
  `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK] 任务长标题与编辑表单检查`** (the record for any
  wrapping-title test). **R077: the timed chips land in 5 consecutive hour cells on Thursday (319/359/399/439/479 by stripe
  band) — the VTODOs render as timed chips too, 7 stripe bands in a column.** **R078: Thu chip rows measured at x=600 are
  277-292 / 317-332 / 357-372 / 397-402 / 405-406 / 409-412 / 415-420 / 423-425 / 427-430 / 517-532 / 677-691.**
- **Row-band measurement idiom (worked twenty times, R046/R062–R078):** scan the target column (or row) for pixels that are
  **not** the background, threshold, group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column
  mean over a wide span** is the cheapest way to find horizontal lines. **Caveats:** keep the window strictly inside the
  region; the all-day separator and the first hour line can be **adjacent rows** (232/233 vs 234 — different weights, don't
  merge); the x=0 rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact —
  **but a row-mean over a *populated* grid is poisoned by chips (R078), so find hour lines in an empty column instead.**
  **R070: the decisive idiom for a *per-column* property is a VERTICAL profile of one empty column.** **R071: fix the column
  map first with a single row run-scan in an empty grid row.** **R072: a vertical profile of the band column also catches a
  LAYOUT defect (7/13/6 spacing) that a screenshot alone reads as "roughly right".** **R074: an ASYMMETRIC check — the same
  run-scan at the band row AND the grid row — proves "now matches" in one call.** **R075: for a CORNER, per-row fill-start
  inset.** **R076: for a JOINT, the per-row `!= white` envelope.** **R077: for a STRIPE, a saturation run-scan whose width must
  be constant over the chip's full height; a classified 2D ASCII dump (one char per pixel) is the cheapest way to see an icon
  you were told was a stripe.** **R078: for a BORDER, a raw RGB profile across an edge that abuts no rule — check
  monotonicity.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert
  `im.size` first. **A composite (a 1:1 strip pasted above a 2–3× zoom) answers "overall form + local detail" in ONE image
  read.** **R075: for a SHAPE comparison, scale the two crops so the *feature* is the same size.** **R076: label the rows in
  the composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is to see
  pixel structure.** **R078: a ×6 `NEAREST` edge crop is the right tool for "is there a 1px ring" — but back it with the raw
  numbers; the eye cannot reliably beat them at 1px.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name
  them **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend
  with `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that
  heading.** `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude
  Opus 5` trailer.** **R069/R071: two different PNGs can be byte-identical in SIZE — `md5sum` before concluding a capture is
  stale (R078: both legs are 3050463 bytes and differ).**

## Next round (pick ONLY #1)
**#1 — E01/E02 step 3: the `timedChip` text is dark same-hue in the ref, grey `AppTheme.text` in ours.** Measured 1:1:
the red chip's ink is **(117,37,34)** on a (251,228,227) wash; the blue chip's ink starts **(99,131,172)**. Ours
(`CalendarScheduleView.qml` `timedChip`'s `Label`) is `color: AppTheme.text`. **Step 1 of the round is to settle the
translation, not to pick a number:** the ref ink is *not* the calendar colour at some alpha over the wash — check whether a
saturation/value mapping reproduces (59,134,247)→(99,131,172) and (235,76,70)→(117,37,34) with the *same* parameters; if it
does not, say so and pick the closest defensible rule (e.g. HSL lightness clamp) rather than fudging per colour. Then verify
the chosen rule on BOTH chips and in BOTH themes. **Do NOT change** the fill alpha, `radius: 5`, the R077 bar, the R078
border deletion, or anything in the all-day band. **Evidence:** a light + dark capture plus a ref|ours text-colour composite.

**Then (unlocked, ref-anchored, one per round):** **the all-day band chip's 12×12 per-calendar ring icon** (new in R077,
needs a ruling on the icon's source before it can start); **A02** — blocked until a fixture with 1 and 4 all-day rows exists;
**N02** (now-line + red badge — needs a capture of the **current** week); V01–V05 (month — **no ref anchor**, use `spec.md` +
HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` rewrite an already-nested
`path` into a flat basename so a round stops paying the R075 diagnosis cost.

**Still blocked on rulings A–G:** dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2
PASS R048), `slice(0,2)` / month 1-chip cap (D — also needs a 3-all-day-item day), **F = 12-hour two-tone gutter labels**,
**G = A01's spec literals (gap 2, inset 2–3) vs the ref's measured 1**. **The `code-writer` subagent is NOT registered in this
session** — R072–R078's edits were made directly; do not retry `code-writer` each round. **Not `DONE` — all spec IDs do not
pass.** (T01/T02/T03 and **A01** are PASS-pending-final-regression; **A03 PASS**; **E01/E02 clauses 1+2 PASS (timed chip bar +
no border)**; everything else is PENDING or ruling-blocked.)
