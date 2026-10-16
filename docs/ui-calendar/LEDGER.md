# R076 — **A03 done: the multi-day all-day strip is ONE bar; only the run's outer ends round.**
The ref was walked 1:1 first for a chip crossing a column rule — **there is none in this reference week.** Every band row
carries its rule unbroken (x=324/406/487/569/650/732 read **236/242/229 on all 21 band rows**, chip fills on both sides
stopping 1–2 px short) ⇒ the ref week holds **no multi-day all-day event**, so A03 is **spec-only, no ref anchor**; the ref
does settle the half the clause needs — **the day boundary is drawn *through* the band.** Edit: one injected accessor
(`itemRecord`, bound in `Main.qml`'s two schedule views) + `isoDay`/`lastCoveredDay`/`allDayContinues` in the view +
`allDayChip`'s single `radius` split into four corner radii. **Our capture, per-row fill envelope:** Mon 30 `insetL 4·2·1·1·0…`,
`insetR 1` on all 24 rows (round left / **square right**); Tue 31 both edges flat (**square/square**); Wed 1 `insetL` flat,
`insetR 5·3·2·2·1…1·2·2·3·5` (**square left** / round right) ⇒ one bar, outer ends only. Single-day items continue neither
way and are **unchanged** (Thu 2's `Design sync`/`Release notes` still fully rounded). (2026-10-17)

## 本轮 (R076)
Atomic step: the standing Next-round #1 — **A03: is the multi-day strip continuous, which corners round?** Evidence:
`docs/ui-calendar/r076-strip-light.png` (1100x692 light, `view week` + `date 2026-04-02`) + the ref|before|after composite
`docs/ui-calendar/r076-strip-compare.png` (ref band 1:1 / ours AFTER 1:1 / ours BEFORE 1:1 / ours AFTER 2x, Mon..Thu rows).

**Ref number the round turned on (measurement-only half).** `refs/macos-calendar.png` band rows y126-143/145-162/164-181; at
every separator on every band row the rule is *visible and darker than both neighbours* (487 → `486=255 · 487=242 · 488=238
· 489=purple`; 569 → `567=purple · 568=252 · 569=229 · 570=248`) ⇒ **the ref's chips never cross a column rule**, and the
Thu chip's fill-left edge per row (`y126→499, 127→494, 128→492, 129→491, 130→490, 131→490, 132..138→489, 139→491, 140→492,
141→493, 142→496`) is **a symmetric arc on BOTH edges** (right edge mirrors it) ⇒ **do not read the ref as authorising
"outer corners only" for a *single-day* chip; it says nothing about a multi-day run at all.**
**Ours after the edit** (chips x53..200 / 203..350 / 353..500, rows y157..180, `!=white` = envelope): the joint between two
continued chips is **flat for all 24 rows** — the only thing between them is the R074 1 px rule. **Not touched:** the R075
radius (`row/3` = 8), row 24 / gap 1 / inset 1 / band 76, the R074 separators, the four rule tokens, the weekend tint, the
timed chip (`radius: 5`). **Light only, and it must stay that way: the change is pure corner geometry on a fill
`AppTheme.withAlpha` already verifies in both legs.**

## A03 status (tester's call, R076)
**`Multi-day all-day strip visually continuous, only outer corners rounded` — PASS.** Verified on the fixture that can show
it: `Multi-day review` runs **Mon 30 · Tue 31 · Wed 1** (three columns = exactly one interior joint to test) and renders as
one bar. **Caveat recorded, not a failure: the clause has NO ref anchor in this image** (see 本轮) — it is satisfied against
the spec text plus the macOS idiom, so it is **PASS, and re-checkable only by the spec.** The supporting measurement that
stopped this being guesswork: the popover prints **`2026年3月30日星期一 – 2026年4月1日星期三 · 全天`** ⇒ the run is Mon–Wed,
so Wed's right end *is* the strip's end and a rounded corner there is correct — **the corner test and the coverage agree.**

## 仍差 (top 8, visual-impact order)
1. **E01/E02 — the chip language, the biggest unexamined mass.** Ref chip = light desaturated same-hue fill + **dark same-hue
   text** + a **3px solid same-hue LEFT STRIPE** (R073 measured it 1:1: x=491-493 = (187,62,216) over a light purple fill at
   488-489) + small radius; a *second* all-day style is near-white (248) with a **coloured ring icon**. Ours: blue-filled
   all-day pills; the timed chip is `radius: 5` + 1px border + no stripe. Contradicts our dark theme's
   solid-saturated-fill/white-text idiom ⇒ first question is whether that translation is legitimate, **second** is the
   stripe's width at our scale (ref 3 px on an 81 px column; ours is 150 px ⇒ ×1.85 ⇒ ~6, or literal 3 — the round must rule
   on it from the crop, not assume). **No ruling needed, just never reviewed.**
2. **A02 — band expansion / shared bottom edge.** The band's height is a fixed 76 today; the ref grows the band with the
   number of all-day rows and shares the bottom edge with the 2px `allDaySeparator`. **Never reviewed. Needs a fixture with
   1 and 4 all-day rows to be measurable at all** — do not start it without deciding that first.
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's**
   right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`.
   **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
6. **`slice(0, 2)` per cell drops a 3rd item with no `+N`** (R048). **R072 aimed it at the BAND — and R076 shows that
   claim was wrong:** with `Multi-day review` absent from Apr 2, Thursday's band holds exactly **2** all-day items, so this
   fixture hides nothing and the empty third row is simply unused. The month day cell holds 1 chip + `N` where the ref
   stacks 3. **Needs ruling D — and needs a 3-all-day-item day before the band half can be reproduced at all.**
7. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure** — ruling C) and **E03 clause 3
   is blocked on a ruling, not failed (R049)**: no view produces a tall block while the ref's week view shows proportional
   30-min vs 60-min chips ⇒ **ruling E**. Clauses 1+2 PASS (R048).
8. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (R076, measured on the ref: Thu chip
   489..567 in a 487..569 column). ~3.7 px at our scale ⇒ visually near-identical; **do not chase it without a ruling**, it
   rides on A01's erratum G (the spec's "inset 2–3" is the same number read in ref px).
- *Cosmetic, no ID:* the band's empty third slot is visibly ruled (R074's separators cross it) — **ruling D, do not patch.**
  `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius **16** vs
  spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on
  the viewport top (R066; scroll artifact, not a form defect).

## 最近已改 (most recent 8)
1. R076 — **A03**: `allDayChip`'s `radius` → four corner radii, square where `allDayContinues(item, columnDate, ±1)`;
   new injected `itemRecord` on the view (bound in `Main.qml`'s two `CalendarScheduleView`s) + `isoDay` / `isoDayPattern` /
   `lastCoveredDay` / `allDayContinues`. Single-day chips bit-identical to R075.
2. R075 — **A01 step 5**: `allDayChip` `radius: 5` → `Math.round(root.allDayRowHeight / 3)` = **8** (ref r≈6 on an 18px row).
3. R074 — **A01 step 4**: the band's `allDayColumn` gained the grid's column separators (1px `gridLine` left edge + right rim
   on the last column); y=215 = 237 at 52/202/352/502/652/802, identical to the grid; boundaries single-width.
4. R073 — **A01 step 3**: `allDayBandInset` 3 → **1**; band 80 → **76** (derived); separator 236/237 → **232/233**, first hour
   line 238 → **234**. Verified the gap stayed 1.
5. R072 — **A01 step 2**: row 18→**24**, gap 2→**1**, band 48→**80**, all derived from four new tokens; the band's
   `ColumnLayout` re-anchored to stop surplus spreading into the spacings.
6. R071 — **measurement only.** Dark weekend tint = **(37,37,37)** in band *and* grid; weekday 30; gutter and header row
   untinted; 155 = 39 and 204/205 = 84 unchanged.
7. R070 — **weekend section tint**: `weekendField` + `isWeekendColumn()`; one background `Rectangle` first-child in the band's
   `allDayColumn` and in `hourCell` (gutter-guarded). Light 249/255, dark 37/30.
8. R069 — separator **above** the all-day band: `AppTheme.border` → new `sectionRule` **#F2F2F2 / white@0.04**; light 242, dark 39.

## 外推待确认 (live only — R053's 9 older items and the earlier blocks are archived to rounds.md tail)
- **THE REFERENCE WEEK CONTAINS NO MULTI-DAY ALL-DAY EVENT (R076).** Measured, not assumed: all 21 band rows carry the
  column rule unbroken with chip fills on both sides, and every chip's fill is inset 1–2 px inside **one** column. ⇒ **A03's
  clause has no ref anchor; the ref can only anchor single-day all-day chips.** Corollary: **a claim that "the ref does X for
  multi-day strips" cannot be made from this image** — say "spec-only" instead.
- **ALL-DAY RANGE ARITHMETIC SUBTRACTS EXACTLY ONE DAY — NEVER TWO (R076).** The ICS carries
  `DTEND;VALUE=DATE:20260403` for `Multi-day review`, the record's end is the **inclusive last day (Apr 2)**, and the popover
  proves the truth: it prints **`2026年3月30日星期一 – 2026年4月1日星期三`**. `Main.qml:itemDetailsRange` and the new
  `lastCoveredDay` both subtract one day and **agree with the popover** ⇒ the model is consistent; any new range math must
  subtract one day and be checked against that popover string. **Corollary: the corner rule and the column membership use
  *different* sources (record `start`/`end` vs the service's date expansion) — they agree today, so any future all-day
  membership change must be re-checked against the corners.** **Second corollary (a correction to the record):
  R072's "Thursday carries 3 all-day items" is WRONG — Apr 2 holds exactly 2 (`Design sync`, `Release notes`); nothing is
  hidden by `slice(0, 2)` on this fixture.**
- **A SQUARE JOINT ONLY READS AS "ONE BAR" BECAUSE THE COLUMN RULE IS DRAWN THROUGH THE BAND (R074 + R076).** The ref does
  the same (its rule is unbroken through every band row). ⇒ **if the R074 separators are ever removed, A03's rendering
  collapses back into "one pill per day".** The two changes are a pair.
- **`itemRecord` IS A NEW INJECTED PROPERTY ON `CalendarScheduleView` (R076), bound in `Main.qml`'s two schedule views
  (`itemAllDay:`/`itemRecord:`/`itemHour:` neighbours). A view that omits it gets `({})` ⇒ `continuesLeft/Right` false ⇒
  every chip fully rounded (falls back to the R075 shape, no crash, no binding error).** Any *new* schedule-view instance
  must bind it or silently lose A03.
- **A LITERAL `8` WOULD HAVE BEEN WRONG TO WRITE; `row/3` IS THE RULE (R075).** Ref chip radius ≈ **6 ref-px on an 18 ref-px
  row = one third of the row height**. **Any future corner in this view must be derived from the box it rounds, not typed.**
  Corollary: **the ref's corner is a SQUIRCLE (continuous curvature)** — its first row reads 4.5 where a true circle of r=6
  would read ~6 ⇒ **compare arc *length and orientation* against the box, never the first-row inset alone.**
- **MEASURING A CORNER: THE DECISIVE IDIOM IS A PER-ROW FILL-START INSET (R075).** Crop the chip's top-left, then for each
  row print the **x where the fill reaches full coverage**, minus the chip's left edge. The row where the inset reaches **0**
  is the **radius**. **R076 addendum — the cheap screening version:** for a *joint* (round vs square) a `!= white` envelope is
  enough and costs one scan: **flat over all 24 rows = square; symmetric 4·2·1·1·0…0·1·1·2·4 = round.** **Caveat: read the
  *fill* channel, not luminance** — antialiased text and the ring icon sit inside the chip and poison a luminance scan.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** The app's CWD is
  the **task dir** (`/proc/<pid>/cwd` → **`/home/amao/nextkde`**), so pass a **FLAT filename**; the PNG lands in the repo
  root and must be moved. **Always read the success flag in `live-runtime-vm.log`** (`… capture <name> true`).
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim
  on `index === root.dayCount - 1`. **Measured: y=215 (band) and y=250 (grid) produce the SAME run list**
  (52/202/352/502/652/802, all 237) and the boundary pixels are single-width (501=255, 502=237, 503=255). ⇒ **no band-only
  token; never "invent" a lighter band line.** **Corollary: never read a subpixel-attenuated separation colour as a distinct
  token without checking a second column.** R075/R076 re-confirmed: the separator is still 237.
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED by R074, R075 and R076.** `sectionRule` **y=155**
  (242, 1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips:
  **157-180**, gap **181**, **182-205**, third slot 206-231. **R072: the band grew 48 → 80 and R073 shrank it to 76, so it is
  net +28 vs R070 — the grid has permanently lost ~28px of viewport; check the visible hour range before touching either.**
- **A `ColumnLayout` TALLER THAN ITS ITEMS SPREADS THE SURPLUS INTO ITS SPACINGS (R072).** Measured: a band 74px tall holding
  two 24px chips on `spacing: 1` rendered the leading gap as **7**, the between-gap as **13** and the trailing gap as **6**.
  **The fix is to remove the surplus, not to fight the distribution:** `anchors.top/left/right` + `height: implicitHeight`.
  **Any future band-height work must re-check this.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075/R076).** Rows **y126-143, y145-162, y164-181** ⇒ **row 18, gap 1, pitch 19**;
  top rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 on BOTH legs** (R073); content
  **125..182 = 58**; band total **60**. Chip radius **≈6 = row/3**; chip fill inset **1–2 px** inside its column. The ref renders
  a *second*, near-white chip style beside the tinted ones. Our scale: vertical **×1.33** (40 hour pitch vs 27), horizontal
  **×1.85** (150px column vs 81.3). **Ours now: row 24 / gap 1 / inset 1 / radius 8 / band 76 / 2-row content 49 /
  separators present / strip continuous — every *form* item matched.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074/R075/R076):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51;
  separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×149px delegates starting at 52
  (delegate edges land on 201.7/351.4/501.1…, so a chip at inset 1 shows its fill on 53..200 / 203..350 / 353..500).
  Columns **Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5** (locale week starts Monday) ⇒ **weekend = the last two**.
  **The band's right rim is on Sun's right edge (x=1102) and is therefore clipped at 1100.**
- **WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070/R071).** Ref: weekday columns **255** in band *and* grid,
  Sat/Sun **249** in both; the band has **no tint of its own**; the day-header row is not tinted. Ours: `weekendField`
  (light `#F9F9F9` = 249, dark `white@0.03` = 37) + `isWeekendColumn(column)` (`getDay()` ∈ {0,6} — date-driven so it survives
  a Mon-start week), consumed by **two** first-child background Rectangles: the band's `allDayColumn` and the `hourCell`
  delegate (**guarded `columnIndex > 0`**). **R074: the band's separators are drawn ON TOP of the tint.**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` /
  dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24),
  `sectionRule` (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` now has ZERO consumers in this view.** *Don't call
  `sectionRule` "the lightest": `gridLineMinor` 244 is numerically lighter.* **The requirement is the ORDERING: ref 242 (top
  boundary) < 237 (hour line) < 217 (band bottom, 2px); ours light sectionRule 242 < gridLine 237 < allDaySeparator 217, dark
  39 < 59 < 84.** `gridLineMinor` is a **half-hour line**, a different role — never fold it in. **R074: `gridLine` is consumed
  by THREE things — the grid's top/left/right edges AND the band's column separators.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with
  `Layout.fillWidth: true` ⇒ full window width, matching the ref. **R068: the top boundary spans identically.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right
  edge: adjacent edges land on the same pixel row and render as 2px. The right rim is drawn only by
  `columnIndex === root.dayCount`. **R067 corollary:** the separator and the first hour line are **adjacent rows** with
  different weights — never read them as one band. **R074 applied it to the band verbatim** and **measured it single-width.**
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill. **Weekend
  columns are 249 light / 37 dark; the gutter is NOT tinted. The all-day band shares the column's fill.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical
  centring via `-Math.round(implicitHeight/2)`, **not** a tuned constant. **A gutter scan must start at x ≥ 3** or the x=0 rim
  merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height =
  `Math.round(root.hourHeight * 21 / 54)` = **16**. Half-hour line = `Math.round(parent.height / 2)` = **20**. **R072 added a
  second derived family for the band — the four `allDay*` tokens; use them.**
- **REF EVENT CHIPS (R063 + R073 + R075).** Chip = **light desaturated same-hue fill + dark same-hue text + a 3px solid
  same-hue LEFT STRIPE** + **radius ≈ row/3** (R075). **R073 measured the stripe at 1:1: x=491-493 = (187,62,216) over a
  light purple fill (488-489) — 3px, fully saturated, not a compression artifact.** Contradicts our dark theme's
  solid-saturated-fill + white-text ⇒ the E family's first question is whether our dark translation is legitimate.
  **R070/R073 addendum:** a *second* all-day chip style is **near-white (248) with a coloured ring icon**.
  **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are HIG+token-anchored only.
  **R075 addendum: the ref's tinted chips carry their icon at the LEFT INSIDE EDGE** (the purple star's disc starts ~2px in),
  which is why a corner crop of a ref chip always contains the icon — **crop the *second* chip row for a clean corner, or
  read the numeric profile instead.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px
  sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels
  193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day
  columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35,
  h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). Hour lines and vertical separators are both
  **1px (237,237,237)**. Gutter label (ref x 215..238): digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge
  238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075/R076).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `openItem` searches
  `reviewWindow.selectedItems` — **the items of the *selected* date**, so a popover test must send `date` first, and
  **"no popover appeared" is a usable negative result.** `review-command.py` takes **ONE argv that is a JSON list**, bumps
  `sequence` itself, writes **in place** (never `os.replace`). **R069–R076: the whole drive list in ONE invocation works fine.**
- **launch/re-launch:** `start-review-vm.sh` blocks on `wait "$app_pid"` — background it (`nohup … & disown`). A rebuilt binary
  needs a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~20s to the new pid. Include
  `resize 1100x692`. It starts in `--view week --date 2026-10-15`, so every drive list must re-send `view week` + the date.
  **R076: the app stays usable between captures — a second capture that needs no rebuild costs only a drill, not a relaunch.**
  **The app's CWD is `/home/amao/nextkde`, so a flat capture filename lands in the repo root — move it into `tmp/`.**
  App stderr goes to **`live-runtime-vm.log`** — read the capture success flags there before believing any capture.
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**):
  VEVENTs Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 /
  **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`** all-day strip with
  **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`** (line 574) ⇒ it **covers Mon 30 · Tue 31 · Wed 1 only**
  (R076, popover-confirmed) and therefore **does not appear on Thursday at all**.
  `Design sync` + `Release notes` are two separate **single-day** all-day VEVENTs on **2026-04-02** (R072) ⇒ **Apr 2 carries
  exactly 2 all-day items**, both rendered, both fully rounded. VTODOs (kind `"todo"`): `[UI] Green planning` 09:00,
  `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00,
  **`[R019 LONG TASK] 任务长标题与编辑表单检查`** (the record for any wrapping-title test).
- **Row-band measurement idiom (worked eighteen times, R046/R062–R076):** scan the target column (or row) for pixels that are
  **not** the background, threshold, group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column
  mean over a wide span** is the cheapest way to find horizontal lines. **Caveats:** keep the window strictly inside the
  region; the all-day separator and the first hour line can be **adjacent rows** (232/233 vs 234 — different weights, don't
  merge); the x=0 rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact.
  **R070: the decisive idiom for a *per-column* property is a VERTICAL profile of one empty column.** **R071: fix the column
  map first with a single row run-scan in an empty grid row.** **R072: a vertical profile of the band column also catches a
  LAYOUT defect (7/13/6 spacing) that a screenshot alone reads as "roughly right".** **R074: an ASYMMETRIC check — the same
  run-scan at the band row AND the grid row — proves "now matches" in one call.** **R075: for a CORNER, per-row fill-start
  inset.** **R076: for a JOINT, the per-row `!= white` envelope — flat = square, symmetric = round.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert
  `im.size` first. **A composite (a 1:1 strip pasted above a 2–3× zoom) answers "overall form + local detail" in ONE image
  read.** **R075: for a SHAPE comparison, scale the two crops so the *feature* is the same size — otherwise the eye reads
  the scale difference as a shape difference.** **R076: label the rows in the composite (`ImageDraw.text`, the default bitmap
  font is enough) — a three-row before/after/ref stack is unreadable unlabelled.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md`
  can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.** A prepend Edit whose
  only `old_string` is the previous round's heading **deletes that heading** — re-append it. **R069/R071: two different PNGs can
  be byte-identical in SIZE — `md5sum` before concluding a capture is stale.**

## Next round (pick ONLY #1)
**#1 — E01/E02: the ref chip's 3px same-hue LEFT STRIPE.** This is the biggest unexamined visual mass and the stripe is the
one part of it already **measured 1:1** (R073: `macos-calendar.png` x=491-493 = **(187,62,216)** over the light purple fill at
488-489 — 3px, fully saturated). **Step 1 only, and atomic: add the left stripe to the all-day chip.** Do **not** touch the
fill/text colour translation, the radius, or the band geometry in the same round. **The one number to rule on before editing:
the stripe is 3 *ref* px on an 81 px ref column and our column is 150 px (×1.85 ⇒ ~6)** — read the ref crop again and derive
it (a typed `3` would repeat R075's literal-`8` mistake; our vertical family uses ×1.33, our horizontal ×1.85, so pick the
axis the *stroke* belongs to and say why). **Do NOT touch** the four corner radii just set (R076), the R074 separators, the
R075 radius, or any band geometry. **Evidence either way:** the light capture + a ref|ours stripe composite mirroring
`docs/ui-calendar/r076-strip-compare.png`.

**Then (unlocked, ref-anchored, one per round):** **A02** — but it **cannot start until a fixture with 1 and 4 all-day rows
exists** (the fixed 76px band is unmeasurable against a ref that grows); **N02** (now-line + red badge — needs a capture of the
**current** week); V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only); the E01/E02 fill+text translation (needs a
ruling on whether our dark saturated-fill/white-text idiom is legitimate).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` rewrite an already-nested
`path` into a flat basename so a round stops paying the R075 diagnosis cost.

**Still blocked on rulings A–G** (unchanged): dim snap, shadow magnitude, popover Esc, `slice(0,2)` / month 1-chip cap (D also
now needs a 3-all-day-item day to be reproducible in the band), E03 clause 3, **F = 12-hour two-tone gutter labels**,
**G = A01's spec literals (gap 2, inset 2–3) vs the ref's measured 1**. **The `code-writer` subagent is NOT registered in this
session** — R072–R076's edits were made directly; do not retry `code-writer` each round. **Not `DONE` — all spec IDs do not
pass.** (T01/T02/T03 and **A01** are PASS-pending-final-regression; **A03 PASS**; A01 also carries ruling G; everything else is
PENDING or ruling-blocked.)
