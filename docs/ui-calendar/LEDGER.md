# R071 — **The dark leg of the weekend tint: measured, exact, and visible. No code change was needed.**
`weekendField` dark = `white@0.03` over the (30,30,30) field ⇒ predicted **36.75 → 37**; measured **37, exactly**, on both
weekend columns in **both** the all-day band and the hour grid. Weekday columns stay **30**, the gutter stays **30**, and the
day-header row is **not** tinted. On the tinted column y=155 = **39** and y=204/205 = **84** are unchanged; the hour line at
y=206 reads **65** vs **59** on a weekday — the dark `gridLine` token is *translucent*, so it blends with the tint under it,
where the light `#EDEDED` line is opaque and does not. (2026-10-17)

## 本轮 (R071)
Atomic step: R070's standing Next-round #1 — "the dark leg: measure `weekendField` in the dark theme; verify, do not assume."
**Measurement-only round; the derived token survived contact.** Evidence: `docs/ui-calendar/r071-weekend-tint-dark.png`
(1100x692, dark, `view week` + `date 2026-04-02`). Kill-by-pid of the light app, `start-review-vm.sh dark`, relaunch pid
128304, one flat 4-command drive list (`resize` + `view` + `date` + `captureClient`). *The new PNG is byte-the-same **size**
as R070's light one (3050463) — `md5sum` differs; R069's warning earned its keep for the second round running.*

**Method.** R070's decisive idiom, reused: a full-width **row run-scan** to fix the column map, then a **vertical profile**
per column. Row 400 (empty grid) returns the whole grid in one line — the cheapest possible column map.

**Column map (row 400, dark).** `x=0` = 1px rim **(53,53,53)**, gutter `x 1..51` = **30**, then 1px separators at
**x=52/202/352/502/652/802** ⇒ **pitch 150** and 7 columns of 149px: Mon 53..201, Tue 203..351, Wed 353..501, Thu 503..651,
Fri 653..801, **Sat 803..951**, **Sun 953..1099**.

**The three checks, all PASS.**
1. **Weekday column stays 30.** Fri x=700: band interior y=156..203 = **30**, grid y=400 = **30**.
2. **Weekend reads the derived value in BOTH regions.** Sat x=880 and Sun x=1050: band y=156..203 = **(37,37,37)** *and*
   grid y=400 = **(37,37,37)**. Derived `white@0.03` over 30 = 30 + 0.03×225 = **36.75 → 37** — the token is right and the
   tint is real, not an artefact of the chip rendering.
3. **The four rules hold on the tinted column.** y=155 = **(39,39,39)** (`sectionRule`, 30 + 0.04×225 = 39) and y=204/205 =
   **(84,84,84)** (`allDaySeparator`, 30 + 0.24×225 = 84) — identical to a weekday column.

**Exclusions, measured not assumed.** The **gutter** (band row y=180, x 1..54) = **30**; the **day-header row**
(y 119..154 on a weekend column) = **30**, and a full-width scan at y=130 is 30 across ⇒ the header is not tinted, matching
the ref's 254-vs-255. The `hourCell` tint rect's `columnIndex > 0` guard does its job.

**The one asymmetry found (recorded, not a defect).** The dark `gridLine` token is **translucent** `white@0.13`: over 30 it
gives **59**, over the tint 37 it gives **37 + 0.13×218 = 65.3 → 65**. **Measured: y=206 = 59 on Fri, 65 on Sat/Sun.** The
light token is the **opaque** `#EDEDED` = 237, so R070 measured 237 on *both* ⇒ light is layering-invariant, dark is not.
This is the honest consequence of a translucent rule over a lighter field and the ref has **no dark theme** to arbitrate; a
Δ6/255 = 2.4% shift on a 1px line is not a form defect. Same cause, one pixel over: the shared separator at **x=802** reads
**(65,65,65)** rather than 59, i.e. the Sat cell's fill reaches one pixel left, under the boundary line. Noted so a future
round does not "discover" it as a bug.

**Eyes.** 周六 4 / 周日 5 read as one continuous lighter section from the `sectionRule` at the top of the all-day band down to
the window floor; the header row above and the gutter to the left stay dark. Δ7 on a 149px-wide, ~500px-tall field is
subtle but unambiguous at 100%. **The tint is not "nothing".**

## 仍差 (top 8, visual-impact order)
1. **A01 — the all-day band's own form** (its tint sub-item is CLOSED/refuted in R070; its dark leg is CLOSED in R071). Ours:
   row 18, gap 2, inset 2–3, radius 5. Ref (R068): rows **≈22.6**, pitch ≈24.6, gap ≈1.3, inset ≈1.35, radius ≈8 (scaled
   ×1.33/×1.35) ⇒ **rows ~20% short, inset ~2× too big, radius 5 vs 8.** Ref-anchored, no spec ID. Steps 2–4, one per round.
2. **E01/E02 — the chip language, the biggest unexamined mass.** Ref chip = light desaturated same-hue fill + **dark same-hue
   text** + a **2–3px solid same-hue LEFT STRIPE** + small radius. Ours: all-day chips are blue-filled pills; the timed chip is
   `radius: 5` + 1px border + no stripe. This also contradicts our dark theme's solid-saturated-fill/white-text idiom ⇒ first
   question is whether that translation is legitimate. **No ruling needed, just never reviewed.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the
   **suffix's** right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
6. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**). **Needs ruling C.**
7. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block, while the ref's week view shows
   proportional 30-min vs 60-min chips ⇒ **ruling E**. Clauses 1+2 PASS (R048).
8. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO (due 11:00)
   is dropped silently. **Needs ruling D.** Same family: the month day cell holds 1 chip + `N` where the ref stacks 3.
- *Cosmetic, no ID, folded out:* two neutral-button idioms diverge and one has no ref (R061): `secondary` hover = neutral grey 79,
  no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. Light `buttonNeutral` base reads ≈(251,252,254) vs the
  rendered card (247,247,247) (R056). D02's radius is **16** vs the spec's 24/32 — **keep 16**. Hover is a flat fill, no
  `borderHover` edge (R057/R060). The topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line
  exactly on the viewport top (R066; scroll artifact, not a form defect).

# R070 — **The "band tint" premise was WRONG: the reference tints the WEEKEND COLUMNS, not the band.**
Re-measured: ref weekday columns are **255** in band *and* grid; Sat/Sun are **249** in *both*. Implemented that instead — a
weekend section tint over the whole schedule field (band + hour grid, day-header row excluded). Light measured exact:
**249 on Sat/Sun, 255 on weekdays, in both regions.** Dark token is *derived, unmeasured* — that is next round. (2026-10-17)

## 本轮 (R070)
Atomic step: standing Next-round #1 ("give the all-day band its section tint"). Its premise did not survive measurement, so the
round implements the ref-anchored fact it was reaching for. One file, one token, one helper, two 5-line additions.
Build + light capture. Evidence: `docs/ui-calendar/r070-weekend-tint-light.png`.

**The falsification (the round's real value).** Instead of sampling the band at one point, both *empty* columns were profiled
vertically, y=124..185: `Tue: 242, 249, 255×56, 236, 217, 217, 249` · `Sat: 242, 244, 249×56, 236, 217, 217, 249`.
Band interior on a **weekday** column is **255** — white, the same as the hour grid. In the hour grid (y=500) Sat/Sun = **249**,
weekdays = **255**. So the `249` is the **weekend column's field colour**, identical above and below; there is **no band-only
tint** in the ref. `y=125` (249 over white / 244 over the tint) is the **half-strength row of the 242 top boundary**, not a fill —
R068's "249 weekday / 244 weekend band tint" was that artefact misread. Day-header row: weekend 254 vs weekday 255 ⇒ below
noise, **not tinted**.

**The change** — `apps/calendar/qml/CalendarScheduleView.qml`:
- `weekendField` (light `#F9F9F9` = 249, dark `Qt.rgba(1,1,1,0.03)`) + `isWeekendColumn(column)` via `dateForColumn(column).getDay()`
  ∈ {0,6}. **Date-driven, not position-driven** — our week is Mon-start, the ref's is Sun-start.
- one `Rectangle { anchors.fill: parent }` declared **first** in the band's `allDayColumn` Item and **first** in the `hourCell`
  delegate, so it stacks below the chips and below the four edge rules.
- the grid one is guarded `hourCell.columnIndex > 0`: column 0 is the gutter and `dateForColumn(-1)` is the *previous* Sunday,
  which would have tinted the whole gutter column.

**Measured (light, 1100x692).** Row 180 (band): weekday x=600/700 = (255,255,255); weekend x=880/900/1050 = **(249,249,249)**.
Row 400 (empty grid): same split. Row-180 histogram over x 0..1099 = **298 px at 249**, matching two 149.7px columns to the pixel.
Rules on the tinted column x=1050 unchanged: **155=242, 204/205=217 (2px), 206=237** — the rect is behind them. Header row unchanged.

**Eyes:** 周六 4 / 周日 5 now read as one section from the top rule to the window floor; the band's left edge no longer looks cut off.

**Environment:** the `code-writer` subagent is still **not registered** — edits made directly. Do not retry it.

## 仍差 (top 8, visual-impact order)
1. **A01 — the all-day band's own form** (the tint sub-item is now CLOSED/refuted, R070). Ours: row 18, gap 2, inset 2–3,
   radius 5. Ref (R068): rows **≈22.6**, pitch ≈24.6, gap ≈1.3, inset ≈1.35, radius ≈8 (scaled ×1.33/×1.35) ⇒ **rows ~20% short,
   inset ~2× too big, radius 5 vs 8.** Ref-anchored, no spec ID. Steps 2–4, one per round.
2. **E01/E02 — the chip language, the biggest unexamined mass.** Ref chip = light desaturated same-hue fill + **dark same-hue
   text** + a **2–3px solid same-hue LEFT STRIPE** + small radius. Ours: all-day chips are blue-filled pills; the timed chip is
   `radius: 5` + 1px border + no stripe. This also contradicts our dark theme's solid-saturated-fill/white-text idiom ⇒ first
   question is whether that translation is legitimate. **No ruling needed, just never reviewed.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the
   **suffix's** right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
6. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**). **Needs ruling C.**
7. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block, while the ref's week view shows
   proportional 30-min vs 60-min chips ⇒ **ruling E**. Clauses 1+2 PASS (R048).
8. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO (due 11:00)
   is dropped silently. **Needs ruling D.** Same family: the month day cell holds 1 chip + `N` where the ref stacks 3.
- *Cosmetic, no ID, folded out:* two neutral-button idioms diverge and one has no ref (R061): `secondary` hover = neutral grey 79,
  no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. Light `buttonNeutral` base reads ≈(251,252,254) vs the
  rendered card (247,247,247) (R056). D02's radius is **16** vs the spec's 24/32 — **keep 16**. Hover is a flat fill, no
  `borderHover` edge (R057/R060). The topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line
  exactly on the viewport top (R066; scroll artifact, not a form defect).

## 最近已改 (most recent 8)
1. R070 — **weekend section tint**: new `weekendField` + `isWeekendColumn()`; one background `Rectangle` first-child in the band's
   `allDayColumn` and in `hourCell` (gutter-guarded). Light measured **249 Sat/Sun, 255 weekdays, band AND grid**; rules 242/217/237
   unchanged. Ref premise "band tint" refuted. **Dark leg pending.**
2. R069 — separator **above** the all-day band: `AppTheme.border` (223,225,228) → new `sectionRule` **#F2F2F2 / white@0.04**.
   Measured light **155 = (242,242,242)**, dark **39**. Inversion gone.
3. R068 — **measurement only, no code change.** Ref top separator = 1px (242,242,242); weight inversion found.
4. R067 — all-day band bottom separator 1px `AppTheme.border` → **2px** local `allDaySeparator` (#D9D9D9 / dark white@0.24).
   Measured light **204/205 = (217,217,217)**, hour line 206 stays 1px. Light **and** dark.
5. R066 — **T03 PASS**: gutter label font 9→**11**, `anchors.right` + `rightMargin: 7` (gap 16 → **8**),
   `topMargin: -Math.round(implicitHeight/2)`. Centres 245.0/285.0/325.0 exact, pitch 40. Light **and** dark.
6. R065 — **T02 PASS**: `gridLine`/`gridLineMinor` tokens; per-cell border box → four single-edge 1px Rectangles.
   Hour 1px (237,237,237), half 1px (244,244,244). Light **and** dark measured.
7. R064 — **T01 FIXED**: `hourHeight: 40` single constant; scroll offset + cell height + chip height derive from it. Measured 10× 40.0.
8. R063 — measurement only; ref re-read as a **week** view; T01 measured FAIL (54 vs ≈40).

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive. R065/R067/R068 moved their
full grid-token and ref-fact-sheet blocks to rounds.md; the live ones are below.)*
- **THE WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070, replaces R068's tint note).** Ref: weekday columns
  **255** in the all-day band **and** in the hour grid; **Sat/Sun 249** in both. The band has **no tint of its own**; the day-header
  row is not tinted (254 vs 255 ⇒ noise). `y=125` is the **half-strength row of the 242 boundary** (242 over white → 249,
  242 over the 249 tint → 244), not a fill. **Ours now:** `CalendarScheduleView.qml` `weekendField` (light `#F9F9F9`, dark
  `white@0.03` — *derived, unmeasured*) + `isWeekendColumn(column)` (getDay() ∈ {0,6}, **date-driven so it survives a
  Mon-start week**), consumed by **two** first-child background Rectangles: the band's `allDayColumn` Item and the `hourCell`
  delegate (**guarded `columnIndex > 0`** — `dateForColumn(-1)` is the previous Sunday and would tint the gutter).
  **Measured light:** row 180 and row 400 both 249 on Sat/Sun, 255 on weekdays; 298 of 1100 px at 249 on row 180.
- **FOUR LOCAL TOKENS NOW OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-71`:
  `gridLine` (light `#EDEDED` / dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06),
  `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` / dark white@0.04).
  **`AppTheme.border` now has ZERO consumers in this view** — do not reintroduce it; it is blue-tinted and app-wide.
  *Do not call `sectionRule` "the lightest rule in the view": `gridLineMinor` (244 light) is numerically lighter.*
  **The ref-anchored requirement is the ORDERING among the four structural rules, not the absolute minimum:**
  ref **242 (top boundary) < 237 (hour line) < 217 (band bottom, 2px)**; ours light **sectionRule 242 < gridLine 237
  < allDaySeparator 217**, dark **39 < 59 < 84**. `gridLineMinor` 244 is a **half-hour line** — a different role,
  T02-anchored, and sits outside that ordering; never fold it in. **R070: all three re-verified unchanged on a tinted
  column (x=1050): 155=242, 204/205=217, 206=237.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** It is a `ColumnLayout` sibling of the `ScrollView`
  with `Layout.fillWidth: true`, so it runs the full window width — matching the ref, whose run starts at the gutter's left
  edge (ref x≈192) and stops at the right rim (x=812). **R068: the top boundary spans identically (ref y=124 reaches x=194).
  Do not "fix" either to start at the grid line. R069: the (242,242,242) row is uniform over x 0..1099.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a
  right edge: adjacent edges land on the same pixel row/column and render as 2px. The right rim is drawn only by
  `columnIndex === root.dayCount`. **R067 corollary:** the separator (204/205) and the first hour line (206) are
  **adjacent rows** with different weights — never read them as one 2px+2px band. **R068:** our y=155 top boundary
  and the day-header text above it are *not* adjacent — there is real white between them.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill.
  **R070: the weekend columns are now 249 light** (the ref's own weekend value). The **gutter** stays 255 light — the tint is
  per *day* column only. **Do not quote "the ref's 249" as a field mismatch any more: the ref's weekday field is 255, the
  same as ours; only its weekend columns are 249, which we now match.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** `CalendarScheduleView.qml:373-383`: font 11,
  `anchors.right` + `rightMargin: 7`, vertical centring from `-Math.round(implicitHeight/2)`, **not** a tuned
  constant. Anchored on **top + right** ⇒ it cannot contribute to the cell's implicit height; unanchoring it
  vertically would inflate the 40px row and break the pitch. `parent.right` of the gutter cell **is** the grid's
  left edge line.
- **The window's leftmost column x=0 is a 1px rim (224,224,224) light / (53,53,53) dark** — a gutter scan must start
  at **x ≥ 3** or that column merges every text band into one. (R066, cost one wasted measurement.)
- **HARNESS COMMAND FORM IS FLAT (R064, hard-won).** `harness/Main.qml` matches `command.action` only
  (`:122 captureClient{path}`, `:204 escape`, `:208 resize{width,height}`, `:217 sidebar{expanded}`,
  `:221 view{view}`, `:225 date{date}`, `:230 openItem{kind,titleContains}`); a command with no `action`
  **silently hits the `:249` fallback** (`[UIReview] manual undefined …`) and does nothing. `review-command.py`
  takes a **flat** list/dict and bumps `sequence` itself, writing **in place** (never `os.replace`) — the QML dir
  watcher would reload and invalidate the state. `captureClient` writes a **relative** path against the **app's CWD**,
  which follows **your launch CWD** ⇒ **launch from the task dir**. Confirmed success line:
  `qml: [UIReview] native app client capture <name> true`. **R069/R070: the whole drive list
  (`resize`+`view`+`date`+`captureClient`) in ONE invocation works fine.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used for the scroll offset (`:124`)
  and the cell height (`:365`); chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**. The half-hour line is
  `Math.round(parent.height / 2)` = **20**. Anything that hardcodes 40 or 16 again will drift.
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026,
  Sun 29–Sat 4) + 243px sidebar + mini calendar. Day headers (text y108-116) → **all-day band (3 rows, y 124–184)**
  → hour grid 8 AM–8 PM. Gutter labels **193/220/247/274/301/328 = pitch 27**; the red `9:41` pill **replaces** the
  10 AM label. Now-line y=238 = 9 AM line + 0.683×27 (proportional, not snapped). **All-day band boundaries: TOP
  y=124 1px (242,242,242); BOTTOM y=183-184 2px (217,217,217)** (R068/R067); both span **x≈192..812**. **7 equal day
  columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots
  **12px** ⇒ 1:1. **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** for us (contract says 40 — 40
  was chosen). Hour lines and vertical separators are both **1px (237,237,237)**; half-hour lines are not
  measurable. In the band the column separators read **(244,244,244)** — lighter than in the hour grid. Gutter label
  (ref x 215..238, y 189..197): digit **(89,89,89)**, cap band **9 ref-px** centred on the hour line; `AM`/`PM`
  suffix **(176..193) 12 ref-px wide, flush right**; right ink edge 238 vs grid line 243 ⇒ **5 ref-px**. `Noon` has
  no suffix, 24 ref-px wide. **R070: the half-strength rows above/below the two boundaries read 249 (weekday) / 244
  (weekend) above and 236 + 249 below — they are AA of the boundary, not separate lines.**
- **REF ALL-DAY BAND AS A FORM (R068).** Rows **h ≈17, pitch ≈18.5, gap ≈1**, first row 2px under the top line, last row
  1px above the bottom line ⇒ band content **58 ref-px**. Chip **inset ≈1**, **radius ≈6** (rounded). Scaled ×1.33/×1.35:
  h ≈22.6, pitch ≈24.6, gap ≈1.3, inset ≈1.35, radius ≈8, content ≈77. **Ours (R069 re-measured on our own capture):
  min 28 / row 18 / gap 2 / inset 2–3 / radius 5.** (R070 changed none of these — the band's field colour only.)
- **REF EVENT CHIPS (R063, this is E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text
  + a 2–3px solid same-hue LEFT STRIPE** + small radius. Confirmed on `Portfolio…`/`Leadersh…`/`Presenta…` (red),
  `Choir…` (olive/yellow), `Morning…` (blue), `Palm Sun…` (pink/magenta stripe). **This contradicts our dark
  theme's solid-saturated-fill + white-text** ⇒ the E family's first question is whether our dark translation is
  legitimate. Not yet judged. *(Our timed chip is `radius: 5`, a 1px border, no left stripe. **R068:** the ref's
  all-day pill radius ≈6 on a 17px row ⇒ ≈0.35×height; ours is 5 on 16.)* **R070 addendum:** the ref's `FaceTi…` /
  `Buy pots` / `Status…` all-day chips are **near-white (248) with a coloured ring icon**, i.e. a *second* all-day chip
  style beside the saturated ones — do not read every ref all-day chip as saturated.
- **THE REF HAS NO POPOVER, NO MENU, NO TOOLTIP, NO HOVER FRAME.** The 弹框/浮层 section (`D`/`O`) is therefore
  HIG+token-anchored only, never pixel-anchored. Unchanged from R061/R062.
- **`lineHeight`: Qt's `ProportionalHeight` is a multiple of the *font's own* line box, not of `pixelSize` (R062).**
  With the app's CJK-capable stack that box is **1.47em** (22px at 15px), so `lineHeight: 1.2` *loosens*. For a
  **pixel** target use `Text.FixedHeight` + `lineHeight: <px>`. Measured valid pair: **FixedHeight 20 at font 15**
  in `EventDetailsPopover.qml:115-118`. **R066 corollary:** the same 1.47em box is why a size-tuned `topMargin` is
  unsafe — use `implicitHeight`.
- **`pointer{target:"<label>"}` is a free geometry + live-state probe for `KosButton`s (R061)** — matches
  `item.text === label`, so it needs the **rendered/translated** label (`"添加"`; a miss logs `NaN NaN` and the
  capture is a silent no-op). Log carries the resolved centre **and** `hover`/`down`. Needs the item `visible`
  (drive to **monthPage** for 添加). `scrollInfo` cannot see buttons; this can.
- **`flat:` and `secondary:` are different branch groups in `KosButton.qml:53-65`.** `flat` rest = `"transparent"`,
  hover/press = `buttonHover`/`buttonPressed` (accent tint) **and it gains a 1px `border` rim** (`:69`, `:80`; inner
  highlight = `!flat || hovered`). `secondary` = `buttonNeutral*` (neutral grey), never gets an edge.
  `AppTheme.qml:97-99` owns all three tokens.
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green
  planning" ⇒ **(673,375)**. Card height is content-driven, so a *reused* y is a **silent no-op**. Read 编辑's
  centre off a frame first. **R062 caveat:** the popover y also differs 11px **between binaries** ⇒ never diff a y
  against another binary.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. `pointerObject` needs THREE
  commands.
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING**, drawn 1px inside the
  perimeter, exact `(43,115,160)`/`(45,115,159)` = `accent`@0.76 dark. `pressScale` 0.968 is ≤1px at height 31 —
  **never read "no animation" from a 31px band.**
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204)
  / `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69)/(79,79,79)/(89,89,89);
  destructive **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge
  token. **Dark card fill = (31,36,43)**; **popover** dark = **(38,38,38)**; window = (30,30,30); flat-button
  hover/press = **(35,60,81)/(36,67,92)**; `border` dark rim ≈**(71,78,87)**. `windowRaised` is **not** a neutral
  grey. **R066/R067: the schedule field dark = (30,30,30)** and its leftmost rim = (53,53,53).
- **Esc semantics (R059): `escape` is a key event addressed to whoever holds `activeFocusItem`.** It closes a
  **focused** popup and does **nothing** to a `modal:false` popup that never takes focus. Ask *who has focus* first.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** P01's popover is a
  **浮层** (`spec.md:120` O08). A requirement written in a `D` row does **not** automatically bind the popover.
- **Dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**,
  x 384..730, centre x ≈ 557, pitch 37, gap 6 (light ≤1px the same). The **task** editor is the same shape **32px
  higher** (516/553/590) — always say *which* editor a footer number belongs to.
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056). Keep `interval ≤ duration/4`; frames
  land at 0, interval, 2·interval…; the recorder is non-blocking so keep `duration` under the 0.6s command spacing.
- **Diff bounding boxes FIRST, sample pixels second** (R058): `ImageChops.difference(...).getbbox()` separates
  "nothing happened" (`None`) from "a view switch" (≈whole window) at no cost. **R061 caveat:** a *neighbouring*
  widget's hover state can inflate the bbox.
- **Row-band measurement idiom that has now worked eleven times (R046/R062–R070):** scan the target column (or row) for
  pixels that are **not** the background, threshold, group into bands, read the band **centre** (text rows) or
  **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to find horizontal lines when
  chips make single-column probing noisy. **Caveats:** keep the scan window strictly inside the intended region
  (R064 — and **R067: establish the y-map first, my window stopped 4px short of the target**); the all-day separator
  and the first hour line can be **adjacent rows** (204/205 vs 206 — different weights, don't merge, R065/R067);
  the x=0 rim column merges every band, start at x ≥ 3 (R066). **R068:** for edges inside the ref's *band*, the
  "background" is per-column and the field is 255 — a global `not-white` threshold returns whole columns.
  **R069: a row-mean over the FULL width (x 0..1099) is exact for a full-width rule.** **R070: the decisive idiom for a
  *per-column* property is a VERTICAL profile of one empty column (y=124..185) — a single-row sample of a chip-infested
  band gave a wrong answer for two rounds.**
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
  **R067:** Pillow crops need **absolute** paths — a bare relative path breaks the moment the harness `cd`s you into
  the task dir.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open; press a button and the ring
  appears 1–2px inset and **persists after release-outside**. On hover the ring is **covered by the hover fill**.
- **The reference macOS alert at rest shows NO focus ring** ⇒ "no ring at open" is the target, not a bug.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159)/(43,115,160).**
  `accent`(48,140,198) / `accentHover`(69,152,204) / `accentPressed`(85,161,208) are **identical in both themes**.
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse as
  JSON, filter `parent` + `visible:true`, and **take the last matching line**. It lists **Flickables/ScrollViews
  only — not `KosButton`s**.
- **The 4-step open chain and the 3-step click CAN go in ONE list**; the recording may be the **first** item.
  **`press` → `move` off the button → `release` outside** captures *pressed* without firing the click.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`). A rebuilt binary
  requires a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~12–14s before the new pid
  appears. Include `resize 1100x692` in the drive list. It starts in `--view week --date 2026-10-15`, so every drive
  list must re-send `view week` + `date 2026-04-02`. It loads `harness/Main.qml`, which imports
  `../../../..//apps/calendar/qml` **relative to the harness file** ⇒ the **source tree** is what renders, and a
  relaunch is required after every rebuild.
- **Fixtures on 2026-04-02** (live file = `profile/pim/calendar.ics`; the repo-root *`calendar-fixture.ics` is a
  stale copy with no VTODOs*): VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title** 11:00 / **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`**
  all-day strip spanning 3 days. VTODOs (kind `"todo"`): `[UI] Green planning` (09:00), `[UI] Gold review` (12:00),
  `[UI] Red review` (16:00), `A deliberately long task title to inspect elision` (11:00), **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (11:00 — a *repeated* long string; **the record for any wrapping-title test**).
  The week is **Mon 30 – Sun 5** (locale weeks start Monday, 7 columns, `dayColumnWidth` ≈ 149.7 at 1100x692).
  **R070: column order = Mon 30, Tue 31, Wed 1, Thu 2, Fri 3, Sat 4, Sun 5 ⇒ the tinted columns are the LAST TWO.**
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its
  **border** only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark;
  event-editor card at x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
  **R066: our text renders with subpixel (RGB) antialiasing** — single-pixel probes of glyph cores come back
  colour-fringed (e.g. (133,142,196) light / (141,142,118) dark). **Never read a text colour from one pixel**; use
  a band's dominant/median over many pixels.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots
  in (name them **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest
  first). `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the
  `Co-Authored-By: Claude Opus 5` trailer.** Note: a prepend Edit that uses only the previous round's heading as
  `old_string` **deletes that heading** — re-append it. **R069: two different PNGs can come out byte-identical in
  size — `md5sum` before you conclude a capture is stale.**

## Next round (pick ONLY #1)
**#1 — R070's dark leg: measure `weekendField` in the dark theme.** Kill the light app, relaunch
`start-review-vm.sh dark`, drive `resize 1100x692` + `view week` + `date 2026-04-02` + `captureClient r071-dark.png`,
then measure. **Target: the derived `white@0.03` ≈ (37,37,37) on the (30,30,30) field — verify, do not assume.**
Check the same three things as R070: weekday column stays (30,30,30); a weekend column reads the derived value in **both**
the band (row ≈180) and the grid (row ≈400); and **155 = 39, 204/205 = 84, 206 = 59** are unchanged on the tinted column.
If `white@0.03` is not distinguishable from the field, raise it and say so — a weekend tint that reads as nothing is a
failed step. **Do NOT touch the band's row height / gap / inset / radius this round**, and do not touch the four rules.

**Then (unlocked, ref-anchored, never reviewed — one per round):** A01 steps 2–4 (row height 18→≈22.6, gap 2→≈1.3,
inset 2–3→≈1.35, radius 5→≈8), **E01/E02** (chip language — the biggest unexamined mass: ref = light same-hue fill +
dark same-hue text + 2–3px left stripe vs our `radius: 5` 1px-border fill and blue all-day pills), N02 (now-line +
red badge — needs a capture of the **current** week), V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten an
already-nested form into `{"action": …}` so every later round stops paying the R064 diagnosis cost.

**Still blocked on rulings A–F** (unchanged): dim snap, shadow magnitude, popover Esc, `slice(0,2)` / month 1-chip
cap, E03 clause 3, **F = 12-hour two-tone gutter labels**; plus the D/O family. **The `code-writer` subagent is
NOT registered in this session** — use `general-purpose` or edit directly; do not retry `code-writer` each round.
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 are PASS-pending-final-regression; everything else is
PENDING or ruling-blocked.)
