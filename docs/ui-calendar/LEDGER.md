# R074 — **A01 step 4 done: the all-day band now carries the grid's column separators.**
Asymmetric read: our band drew **no** column separators while the reference's run **unbroken through it** at its hour-line
weight. Re-measured the ref at 1:1: separators at **x=324/406/487** read **244/236/242** — one line at three subpixel
coverages on 81.3px columns (full coverage ≈**236** = the ref's own hour-line token) ⇒ **no new token, reuse `gridLine`**.
`CalendarScheduleView.qml` `allDayColumn`: two 1px Rectangles added after the weekend tint — a **left edge** per column (the
hourCell idiom: one edge per boundary, so neighbours can never stack into 2px) with its **left pixel on the delegate's x**, plus
a **right rim only on `index === dayCount - 1`**. **Measured on our capture (1100x692 light, `view week` + `date 2026-04-02`):**
a row run-scan at **y=215** (the band's empty third slot, previously uniform 255) now reads 1px **237** at
**52 / 202 / 352 / 502 / 652 / 802** — **byte-identical to the grid's row y=250**, and the boundary pixels are single-width
(x=501 is 255, **502 is 237**, x=503 is 255 — no doubles). The R073 y-map is unchanged: **155** sectionRule 242 · **156** white
(inset 1) · **157-180** chip · **181** gap · **182-205** chip · **232-233** allDaySeparator · **234** first hour line, and the
x=577 vertical profile reports the same bands. Reused token: `gridLine` (light `#EDEDED` → 237, dark white@0.13). No geometry
touched: inset 1, row 24, gap 1, band 76, radius 5, the four rule tokens and the weekend tint are all as R073 left them.
Screenshot: `docs/ui-calendar/r074-band-separators-light.png`. (2026-10-17)

# R073 — **A01 step 3 done: the all-day band's inset now matches the reference — 3 → 1, band 80 → 76.**
The reference was re-measured at 1:1 **on both legs this round**. Vertical: the band's top rule is **y=124** and the first chip
starts at **y=126** ⇒ inset **≈1 ref-px**. Horizontal (new): the column separator sits at **x=324** and the near-white chip starts
at **x=326**; separator **x=487** → the pink chip starts at **x=488** ⇒ inset **≈1 ref-px on the horizontal leg too**, so the
single shared token is the right shape. One number: `CalendarScheduleView.qml` `allDayBandInset` **3 → 1**; the sibling
`allDayBandHeight` **derives** from it, so the band became 1*2 + 3*24 + 2*1 = **76**. **Measured on our capture (1100x692 light,
Thursday x=577):** sectionRule **155** (242, unchanged) · inset 156 = white (**1**) · chip1 **157-180** (**24**) · gap **181**
(**1**) · chip2 **182-205** (**24**) · third slot **206-231** empty · `allDaySeparator` **232-233** (217, 2px) · first hour line
**234** (237). Every value matched the round's prediction. **The gap did NOT re-inflate:** because the `ColumnLayout` is now
`height: implicitHeight`, shrinking the band removed surplus instead of re-triggering R072's 7/13/6 spreading. **Bonus evidence
for E01:** the ref's pink chip carries a **solid saturated 3px left stripe** (x=491-493, (187,62,216)) against a light purple
fill (488-489) — the stripe is real and 3px at 1:1, not a compression artifact. **(2026-10-17)**

# R072 — **A01 step 2 done: the all-day band's row geometry now matches the reference's scaled form — row 24, gap 1, band 80.**
Reference re-measured **at 1:1 this round**: all-day rows at **y126-143 / y145-162 / y164-181** ⇒ row **18**, gap **1**, pitch **19**,
inside a band whose top rule is **y=124** and whose 2px bottom separator is **y=183-184** ⇒ **band 60px**. Our vertical factor vs
the reference is **1.33** (40px hour pitch vs 27) ⇒ row **24**, gap **1**, band **80**. Ours: chip 18 → **24**, `spacing` 2 → **1**,
band 48 → **80**, all now **derived** from `allDayRowHeight / allDayRowGap / allDayBandRows / allDayBandInset` so the band can no
longer drift from the row height. **A trap found and fixed:** a `ColumnLayout` taller than its items spreads the surplus into its
**spacings** (leading half / between / trailing half) — the first capture rendered *inset 3 + gap 1* as **7 / 13 / 6**. **A01 steps 3
(inset) and 4 (radius) are untouched.** (2026-10-17)

## 本轮 (R072)
Atomic step: the standing Next-round #1 — **A01 step 2: the all-day band's ROW GEOMETRY (row height + gap only)**, ref-anchored, no
spec ID. Evidence: `docs/ui-calendar/r072-band-light.png` (1100x692 light, `view week` + `date 2026-04-02`); the pre-fix capture is
kept as `r072-band-light-spread.png` (the record of the ColumnLayout trap). **Fixture change:** the review profile gained two
all-day VEVENTs on **2026-04-02** (`Design sync`, `Release notes`, UIDs `ui-review-r072-allday-a/b@isolated.local`) — without them a
column renders only **one** all-day row and the *gap* is unmeasurable.

**Vertical profile, Thursday column (x=577), light:** 155 `sectionRule` (242, 1px) · 156-158 white = **inset 3** · **159-182 chip (24)** ·
**183 = the 1px gap** · **184-207 chip (24)** · 208-235 empty (third row slot; `slice(0, 2)` caps the column at two chips) ·
**236-237** `allDaySeparator` (217, 2px) · **238** first hour line (237). Neighbours: x=300 (Tue, one chip) puts its chip at the
**top** (159-182) with the slack below — spreading gone; x=860 (Sat) no chip, keeps the 249 tint. **Light measured first, dark skipped
on budget — the changed numbers are pure geometry (row height / gap), theme-invariant; the tint itself was verified in R071.**

## 仍差 (top 8, visual-impact order)
1. **A01 step 3 — the band's INSET.** Ours **3**, ref **1** ref-px ⇒ ×1.33 ⇒ target **1**. `allDayBandInset` feeds
   `allDayBandHeight`, so the band follows automatically: **80 → 76** and the bottom separator lifts 236/237 → 232/233. **Radius 5 vs
   ref ~6→8 is step 4, a separate round.** Ours now: **row 24 / gap 1 / inset 3 / radius 5 / band 80 / 2-row content 49.**
2. **E01/E02 — the chip language, the biggest unexamined mass.** Ref chip = light desaturated same-hue fill + **dark same-hue
   text** + a **2–3px solid same-hue LEFT STRIPE** + small radius. Ours: all-day chips are blue-filled pills; the timed chip is
   `radius: 5` + 1px border + no stripe. Contradicts our dark theme's solid-saturated-fill/white-text idiom ⇒ first question is
   whether that translation is legitimate. **No ruling needed, just never reviewed.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's**
   right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`.
   **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
6. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**). **Needs ruling C.**
7. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block, while the ref's week view shows
   proportional 30-min vs 60-min chips ⇒ **ruling E**. Clauses 1+2 PASS (R048).
8. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO (due 11:00)
   is dropped silently. **Needs ruling D.** Same family: the month day cell holds 1 chip + `N` where the ref stacks 3.
   **R072 raises the stake for the BAND too:** the band is now the reference's **3-row** form (80px) but `slice(0, 2)` means the
   third slot can *never* fill — Thursday (3 all-day items) shows 2 rows and a visibly empty third.
- *Cosmetic, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge.
  D02 radius **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an
  hour line exactly on the viewport top (R066; scroll artifact, not a form defect). The band's 3px inset + 8px total slack per
  column reads slightly airier than the reference's packed rows — this is step 3's job, not a new finding.

## 最近已改 (most recent 8)
1. R072 — **A01 step 2**: `CalendarScheduleView.qml` row 18→**24**, gap 2→**1**, band 48→**80**, all derived from four new tokens;
   the band's `ColumnLayout` re-anchored (top/left/right + `height: implicitHeight`) to stop surplus spreading into the spacings.
2. R071 — **measurement only, no code change.** Dark weekend tint verified = **(37,37,37)** in band *and* grid; weekday 30;
   gutter and header row untinted; 155 = 39 and 204/205 = 84 unchanged. Hour line reads 65 on tinted columns (translucent token).
3. R070 — **weekend section tint** (dark leg closed by R071): `weekendField` + `isWeekendColumn()`; one background
   `Rectangle` first-child in the band's `allDayColumn` and in `hourCell` (gutter-guarded). Light 249/255, dark 37/30.
4. R069 — separator **above** the all-day band: `AppTheme.border` → new `sectionRule` **#F2F2F2 / white@0.04**; light 242, dark 39.
5. R068 — **measurement only.** Ref top separator = 1px (242,242,242); weight inversion found.
6. R067 — all-day band bottom separator 1px → **2px** local `allDaySeparator` (#D9D9D9 / white@0.24); light 217, dark 84.
7. R066 — **T03 PASS**: gutter label font 9→**11**, `anchors.right` + `rightMargin: 7`, `topMargin: -Math.round(implicitHeight/2)`.
8. R065 — **T02 PASS**: `gridLine`/`gridLineMinor` tokens; per-cell border box → four single-edge 1px Rectangles.

## 外推待确认 (live only — R053's 9 older items and the rest of R070's block are archived to rounds.md tail)
- **A `ColumnLayout` TALLER THAN ITS ITEMS SPREADS THE SURPLUS INTO ITS SPACINGS (R072).** Measured: a band 74px tall holding two
  24px chips on `spacing: 1` rendered the leading gap as **7**, the between-gap as **13** and the trailing gap as **6** — i.e. the
  surplus (25px) went into a leading half-spacing, the between-spacing and a trailing half-spacing, *not* to the bottom, and the
  items kept their preferred height (no `Layout.fillHeight`). **The fix is to remove the surplus, not to fight the distribution:**
  `anchors.top/left/right` + `height: implicitHeight` puts the chips at the top on a true 1px gap. **Any future all-day-height work
  must re-check this — a fixed-height band plus a content-sized layout is the shape that works.**
- **THE ALL-DAY BAND'S NEW Y-MAP (R072, light, 1100x692) — the band grew 48 → 80, everything below it moved +32.** `sectionRule`
  **y=155** (unchanged, anchored by the layout above); band interior 156..235 = **80**; `allDaySeparator` **236-237** (was 204/205);
  first hour line **238** (was 206). The `hourHeight` pitch (40) and the scroll-offset derivation are untouched. **A taller band
  costs the grid 32px of viewport — re-check the visible hour range before growing it again.**
- **REF ALL-DAY BAND, RE-MEASURED 1:1 (R072 — supersedes R068's h≈17/pitch≈18.5).** Rows **y126-143, y145-162, y164-181** ⇒
  **row 18, gap 1, pitch 19**; top rule **y=124** 1px (242), bottom separator **y=183-184** 2px (217); inset **≈1**; content
  **125..182 = 58**; band total **60**. The first chip is a light blue-grey pill (core ~(231,233,237)); the third is pink
  (`Palm Sun…`); gap rows read **249** — the near-white residue of the rounded corners, not the field. **Ours now (R072): row 24 /
  gap 1 / inset 3 / radius 5 / band 80 / 2-row content 49.** Radius (ref ~6 → ~8) is the only form item still unmatched, step 4.
- **WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070/R071).** Ref: weekday columns **255** in band *and* grid,
  Sat/Sun **249** in both; the band has **no tint of its own**; the day-header row is not tinted. Ours: `weekendField`
  (light `#F9F9F9` = 249, dark `white@0.03` = 37) + `isWeekendColumn(column)` (`getDay()` ∈ {0,6} — date-driven so it survives a
  Mon-start week), consumed by **two** first-child background Rectangles: the band's `allDayColumn` and the `hourCell` delegate
  (**guarded `columnIndex > 0`**). **Both legs measured. R072 re-confirmed on the new capture (x=860 = 249, no chip).**
- **OUR COLUMN MAP AT 1100x692 (R071/R072):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51; separators at
  **x=52/202/352/502/652/802**, **pitch 150**, 7×149px; columns **Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5**
  (locale week starts Monday) ⇒ **weekend = the last two columns**. `dayColumnWidth` ≈ 149.7. **Thursday = x 503..651.**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine`
  (light `#EDEDED` / dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator`
  (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` now has ZERO
  consumers in this view** — do not reintroduce it. *Don't call `sectionRule` "the lightest": `gridLineMinor` 244 is numerically
  lighter.* **The requirement is the ORDERING: ref 242 (top boundary) < 237 (hour line) < 217 (band bottom, 2px); ours light
  sectionRule 242 < gridLine 237 < allDaySeparator 217, dark 39 < 59 < 84.** `gridLineMinor` is a **half-hour line**, a
  different role, outside the ordering — never fold it in. **R071: 155 = 39 and 204/205 = 84 verified unchanged on a tinted column.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with
  `Layout.fillWidth: true` ⇒ full window width, matching the ref. **R068: the top boundary spans identically. Do not "fix"
  either to start at the grid line.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right edge:
  adjacent edges land on the same pixel row and render as 2px. The right rim is drawn only by `columnIndex === root.dayCount`.
  **R067 corollary:** the separator and the first hour line are **adjacent rows** with different weights — never read them as one band.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill. **Weekend
  columns are 249 light / 37 dark; the gutter is NOT tinted.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical centring
  via `-Math.round(implicitHeight/2)`, **not** a tuned constant. Anchored on **top + right** ⇒ it cannot contribute to the cell's
  implicit height. **A gutter scan must start at x ≥ 3** or the x=0 rim merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used for the scroll offset and the cell height;
  chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**. Half-hour line = `Math.round(parent.height / 2)` = **20**.
  Anything that hardcodes 40 or 16 again will drift. **R072 added a second derived family for the band — use the tokens.**
- **REF EVENT CHIPS (R063 — E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text + a 2–3px solid
  same-hue LEFT STRIPE** + small radius. Contradicts our dark theme's solid-saturated-fill + white-text ⇒ the E family's first
  question is whether our dark translation is legitimate. Not yet judged. **R070 addendum:** the ref's `FaceTi…`/`Buy pots`/
  `Status…` all-day chips are **near-white (248) with a coloured ring icon** — a *second* all-day chip style.
  **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families (弹框/浮层) are HIG+token-anchored only.
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar
  + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels
  193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns,
  1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots 12px ⇒ 1:1.
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). Hour lines and vertical
  separators are both **1px (237,237,237)**; in the band the column separators read **(244,244,244)**. Gutter label (ref x 215..238):
  digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge 238 vs grid line 243 ⇒ 5 ref-px.
- **HARNESS COMMAND FORM IS FLAT (R064).** `harness/Main.qml` matches `command.action` only (`captureClient{path}`, `escape`,
  `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`, `openItem{kind,titleContains}`); a command with no
  `action` **silently hits the fallback**. `review-command.py` takes a **flat** list, bumps `sequence` itself, writes **in place**
  (never `os.replace` — the QML watcher would reload and invalidate state). `captureClient` writes a **relative** path against the
  app's CWD ⇒ **launch from the task dir**. Success line: `qml: [UIReview] native app client capture <name> true`.
  **R069–R072: the whole drive list (`resize`+`view`+`date`+`captureClient`) in ONE invocation works fine.**
- **launch/re-launch:** `start-review-vm.sh` blocks on `wait "$app_pid"` — background it (`nohup … & disown`). A rebuilt binary needs
  a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~15–20s to the new pid. Include `resize 1100x692`.
  It starts in `--view week --date 2026-10-15`, so every drive list must re-send `view week` + `date 2026-04-02`. It loads
  `harness/Main.qml`, which imports the **source tree** ⇒ the source edit renders on relaunch (a ninja rebuild is still the safe
  habit). **R072: two captures in one round = 2 kill+relaunch cycles at ~35s each; that is the round's budget.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**):
  VEVENTs Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 /
  **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`** all-day strip spanning **Mon 30 – Thu 2**.
  **R072 ADDED two all-day VEVENTs on 2026-04-02: `Design sync` and `Release notes`** (so Thursday carries **3** all-day items and
  the band's gap is measurable). VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00,
  `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (the record for any wrapping-title test).
- **Row-band measurement idiom (worked thirteen times, R046/R062–R072):** scan the target column (or row) for pixels that are
  **not** the background, threshold, group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column mean
  over a wide span** is the cheapest way to find horizontal lines. **Caveats:** keep the window strictly inside the region; the
  all-day separator and the first hour line can be **adjacent rows** (236/237 vs 238 — different weights, don't merge); the x=0 rim
  merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact. **R070: the decisive idiom for a
  *per-column* property is a VERTICAL profile of one empty column.** **R071: fix the column map first with a single row run-scan in
  an empty grid row.** **R072: a vertical profile of the band column is also how you catch a LAYOUT defect (7/13/6 spacing) that a
  screenshot alone reads as "roughly right".**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert
  `im.size` first. **A composite (a 1:1 strip pasted above a 2–3× zoom) answers "overall form + local detail" in ONE image read.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md`
  can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.** A prepend Edit whose
  only `old_string` is the previous round's heading **deletes that heading** — re-append it. **R069/R071: two different PNGs can
  be byte-identical in SIZE — `md5sum` before concluding a capture is stale.**

## Next round (pick ONLY #1)
**#1 — A01 step 3: the all-day band's INSET — `allDayBandInset` 3 → 1.** Ref-anchored (R072 measured 1:1 this round: the band's
top rule is y=124 and the first chip starts at y=126 ⇒ **inset ≈1 ref-px**; ref chip's rounded corner occupies the single row
y=125) × our 1.33 vertical factor ⇒ **≈1.3, take 1**. One number: `CalendarScheduleView.qml` — `readonly property int
allDayBandInset: 3` → **1** (the sibling `allDayBandHeight` **derives** from it, so the band becomes 1*2 + 3*24 + 2*1 = **76** and
the bottom separator lifts 236/237 → **232/233**; record the new y-map). **Do NOT touch radius (step 4), the four rule tokens, the
weekend tint, or `allDayRowHeight`/`allDayRowGap`.** Verify with the same vertical profile on **x=577** (Thursday, two chips):
expect chip1 = **157-180**, gap **181**, chip2 = **182-205**, separator **232-233**, first hour line **234**. Note that the
`ColumnLayout` is now `height: implicitHeight`, so shrinking the band does **not** re-introduce spreading — confirm that (the gap
must stay **1**, not grow).

**Then (unlocked, ref-anchored, one per round):** A01 step 4 (radius 5 → ≈8), then **E01/E02** (the chip language — ref = light
same-hue fill + dark same-hue text + 2–3px left stripe vs our `radius: 5` 1px-border fill and blue all-day pills), N02 (now-line +
red badge — needs a capture of the **current** week), V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten an already-nested
form into `{"action": …}` so every later round stops paying the R064 diagnosis cost.

**Still blocked on rulings A–F** (unchanged): dim snap, shadow magnitude, popover Esc, `slice(0,2)` / month 1-chip cap, E03
clause 3, **F = 12-hour two-tone gutter labels**; plus the D/O family. **The `code-writer` subagent is NOT registered in this
session** — this round's edits were made directly (three literals + one layout anchor); do not retry `code-writer` each round.
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 are PASS-pending-final-regression; everything else is PENDING or
ruling-blocked.)
