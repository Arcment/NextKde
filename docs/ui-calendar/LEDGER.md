# R074 — **A01 step 4 done: the all-day band now carries the grid's column separators.**
The band drew **none** (y=215 was uniform 255) while the ref's separators run **unbroken through it**. Ref re-measured 1:1:
x=324/406/487 read **244/236/242** = one line at three subpixel coverages on 81.3px columns, full coverage ≈**236** = the
ref's own hour-line token ⇒ reuse `gridLine`, no new token. Added to the band's `allDayColumn` delegate (after the weekend
tint): a 1px **left edge** per column + a **right rim only on the last column**. **Our capture reproduced the prediction
exactly:** y=215 now reads 1px **237** at **52/202/352/502/652/802** — identical to the grid row y=250 — with **single-width**
boundaries (x=501 = 255, **502 = 237**, x=503 = 255). The R073 y-map is byte-for-byte unchanged. (2026-10-17)

## 本轮 (R074)
Atomic step: the standing Next-round #1 — **A01 step 4: the band's column separators**. Evidence:
`docs/ui-calendar/r074-band-separators-light.png` (1100x692 light, `view week` + `date 2026-04-02`).
Edit = `CalendarScheduleView.qml` `allDayColumn` (after the R070 weekend-tint Rectangle): two Rectangles, both
`anchors.top/bottom: parent.bottom` (full delegate height = band interior 156..231), `width: 1`, `color: root.gridLine`;
the first `anchors.left: parent.left`, the second `anchors.right: parent.right` with
`visible: allDayColumn.index === root.dayCount - 1`. Mirrors the `hourCell` idiom exactly (one edge per boundary; grid uses
`columnIndex === root.dayCount`).

**Row run-scan, y=215 (band's empty third slot), x 52..1099, threshold <250:** `52·237 | 202·237 | 352·237 | 502·237 |
652·237 | 802..1099 = 249` (the weekend tint span, separator at 952 merged into it — the same run appears at y=250 in the
grid). **y=250 (grid) is identical** ⇒ band and grid separators are now one continuous rule at the same x and weight.
**Boundary width check:** x=501 `255` · **502 `237`** · 503 `255`, and 651 `255` · **652 `237`** · 653 `255` ⇒ 1px, no doubling
(R065 held).
**Vertical profile x=577 (Thursday interior), y 120..245:** 155 `242` · 156 (≥250, white = **inset 1**) · 157-180 chip ·
181 gap · 182-205 chip · 232-234 (separator+first hour line, adjacent rows, grouped) — **the R073 y-map is unchanged.**
No geometry touched: inset 1, row 24, gap 1, band 76, radius 5, the four rule tokens, the weekend tint.
**Light only: `gridLine` is already verified in both legs (dark white@0.13 → 59), and the change is pure geometry.**

## 仍差 (top 8, visual-impact order)
1. **A01 step 5 — the chip radius.** Ours **5**, ref ~6 ref-px × 1.33 ⇒ **~8**. Two corners per chip; small but it is the last
   unmatched *form* item of the band. Ours now: **row 24 / gap 1 / inset 1 / radius 5 / band 76 / 2-row content 49 /
   separators present**.
2. **E01/E02 — the chip language, the biggest unexamined mass.** Ref chip = light desaturated same-hue fill + **dark same-hue
   text** + a **3px solid same-hue LEFT STRIPE** (R073 confirmed the stripe at 1:1: x=491-493 = (187,62,216) for the pink chip) +
   small radius; a *second* all-day style is near-white (248) with a **coloured ring icon**. Ours: blue-filled all-day pills; the
   timed chip is `radius: 5` + 1px border + no stripe. Contradicts our dark theme's solid-saturated-fill/white-text idiom ⇒ the
   first question is whether that translation is legitimate. **No ruling needed, just never reviewed.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's**
   right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`.
   **R058 re-confirmed both directions.** App-wide. **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
6. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO (due 11:00)
   is dropped silently. **R072 re-aimed it at the BAND:** the band is now the reference's **3-row** form (76px) but `slice(0, 2)`
   means the third slot can *never* fill — Thursday (3 all-day items) shows 2 rows and a visibly empty third. Same family: the
   month day cell holds 1 chip + `N` where the ref stacks 3. **Needs ruling D.**
7. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure** — ruling C) and **E03 clause 3 is
   blocked on a ruling, not failed (R049)**: no view produces a tall block while the ref's week view shows proportional 30-min vs
   60-min chips ⇒ **ruling E**. Clauses 1+2 PASS (R048).
8. **The band's 2-row cap now reads slightly wrong given the separators** — cosmetic side effect of item 6: the empty third slot
   is now visibly ruled (three separators crossing an empty area), which draws the eye to the unfilled slot. **Do not fix the cap
   here; it is ruling D.**
- *Cosmetic, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge.
  D02 radius **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an
  hour line exactly on the viewport top (R066; scroll artifact, not a form defect).

## 最近已改 (most recent 8)
1. R074 — **A01 step 4**: the band's `allDayColumn` gained its column separators — 1px `gridLine` **left edge** per column +
   right rim on the last column. y=215 now 237 at 52/202/352/502/652/802, identical to the grid; boundaries single-width.
2. R073 — **A01 step 3**: `allDayBandInset` 3 → **1**; band 80 → **76** (derived); separator 236/237 → **232/233**, first hour line
   238 → **234**. Verified the gap stayed 1 (no re-spreading).
3. R072 — **A01 step 2**: `CalendarScheduleView.qml` row 18→**24**, gap 2→**1**, band 48→**80**, all derived from four new tokens;
   the band's `ColumnLayout` re-anchored (top/left/right + `height: implicitHeight`) to stop surplus spreading into the spacings.
4. R071 — **measurement only, no code change.** Dark weekend tint verified = **(37,37,37)** in band *and* grid; weekday 30; gutter
   and header row untinted; 155 = 39 and 204/205 = 84 unchanged. Hour line reads 65 on tinted columns (translucent token).
5. R070 — **weekend section tint** (dark leg closed by R071): `weekendField` + `isWeekendColumn()`; one background `Rectangle`
   first-child in the band's `allDayColumn` and in `hourCell` (gutter-guarded). Light 249/255, dark 37/30.
6. R069 — separator **above** the all-day band: `AppTheme.border` → new `sectionRule` **#F2F2F2 / white@0.04**; light 242, dark 39.
7. R068 — **measurement only.** Ref top separator = 1px (242,242,242); weight inversion found.
8. R067 — all-day band bottom separator 1px → **2px** local `allDaySeparator` (#D9D9D9 / white@0.24); light 217, dark 84.

## 外推待确认 (live only — R053's 9 older items and the earlier blocks are archived to rounds.md tail)
- **THE BAND NOW RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** Added in `allDayColumn`: left-edge 1px `gridLine` per column
  + right rim on `index === root.dayCount - 1`. **Measured: y=215 (band) and y=250 (grid) produce the SAME run list**
  (52/202/352/502/652/802, all 237) and the boundary pixels are single-width (501=255, 502=237, 503=255). **The ref's separators
  are continuous through the band at its hour-line weight** (x=324/406/487 = 244/236/242 = one line, three subpixel coverages,
  full coverage ≈236). ⇒ **no band-only token; never "invent" a lighter band line.** **Corollary: never read a
  subpixel-attenuated separation colour as a distinct token without checking a second column.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED by R074.** `sectionRule` **y=155** (242, 1px);
  band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips: **157-180**,
  gap **181**, **182-205**, third slot 206-231. **R072: the band grew 48 → 80 and R073 shrank it to 76, so it is net +28 vs
  R070 — the grid has permanently lost ~28px of viewport; check the visible hour range before touching either number again.**
- **A `ColumnLayout` TALLER THAN ITS ITEMS SPREADS THE SURPLUS INTO ITS SPACINGS (R072; R073 + R074 re-confirmed safe.)**
  Measured in R072: a band 74px tall holding two 24px chips on `spacing: 1` rendered the leading gap as **7**, the between-gap
  as **13** and the trailing gap as **6**. **The fix is to remove the surplus, not to fight the distribution:**
  `anchors.top/left/right` + `height: implicitHeight`. **Any future band-height work must re-check this.**
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073).** Rows **y126-143, y145-162, y164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 on BOTH legs** (R073); content **125..182 = 58**;
  band total **60**. Our scale: vertical **×1.33** (40 hour pitch vs 27), horizontal **×1.85** (150px column vs 81.3). **Ours now:
  row 24 / gap 1 / inset 1 / radius 5 / band 76 / 2-row content 49 / separators present.** Radius (ref ~6 → ~8) is the last
  unmatched form item.
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074):** x=0 rim (53,53,53) dark / (224,224,224) light; gutter x 1..51; separators at
  **x=52/202/352/502/652/802 in BOTH the band and the grid**, **pitch 150**, 7×149px delegates starting at 52; columns
  **Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4 · Sun 5** (locale week starts Monday) ⇒ **weekend = the last two columns**.
  Thursday's delegate is **502..651**, so its chip at inset 1 runs **503..650**. **The band's right rim is on Sun's right edge
  (x=1102) and is therefore clipped at 1100 — visible only if the window widens.**
- **WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070/R071).** Ref: weekday columns **255** in band *and* grid,
  Sat/Sun **249** in both; the band has **no tint of its own**; the day-header row is not tinted. Ours: `weekendField`
  (light `#F9F9F9` = 249, dark `white@0.03` = 37) + `isWeekendColumn(column)` (`getDay()` ∈ {0,6} — date-driven so it survives a
  Mon-start week), consumed by **two** first-child background Rectangles: the band's `allDayColumn` and the `hourCell` delegate
  (**guarded `columnIndex > 0`**). **R074: the band's separators are drawn ON TOP of the tint (declared after it) — on a tinted
  column the separator still reads 237 light, so a run-scan there must not be read as "merged into the tint".**
- **FOUR LOCAL TOKENS OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` /
  dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24),
  `sectionRule` (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` now has ZERO consumers in this view** — do not
  reintroduce it. *Don't call `sectionRule` "the lightest": `gridLineMinor` 244 is numerically lighter.* **The requirement is the
  ORDERING: ref 242 (top boundary) < 237 (hour line) < 217 (band bottom, 2px); ours light sectionRule 242 < gridLine 237 <
  allDaySeparator 217, dark 39 < 59 < 84.** `gridLineMinor` is a **half-hour line**, a different role, outside the ordering —
  never fold it in. **R074: `gridLine` is now consumed by THREE things — the grid's top/left/right edges AND the band's column
  separators. All three share one token by design; the ref does the same (its band separators = its hour-line token).**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** A `ColumnLayout` sibling of the `ScrollView` with
  `Layout.fillWidth: true` ⇒ full window width, matching the ref. **R068: the top boundary spans identically. Do not "fix"
  either to start at the grid line.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a right edge:
  adjacent edges land on the same pixel row and render as 2px. The right rim is drawn only by `columnIndex === root.dayCount`.
  **R067 corollary:** the separator and the first hour line are **adjacent rows** with different weights — never read them as one
  band. **R074 applied it to the band verbatim** (left edge + last-column rim) and **measured the result single-width**
  (501=255, 502=237, 503=255).
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill. **Weekend
  columns are 249 light / 37 dark; the gutter is NOT tinted. The all-day band shares the column's fill (white on weekdays).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`, vertical centring
  via `-Math.round(implicitHeight/2)`, **not** a tuned constant. Anchored on **top + right** ⇒ it cannot contribute to the cell's
  implicit height. **A gutter scan must start at x ≥ 3** or the x=0 rim merges every text band into one.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used for the scroll offset and the cell height;
  chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**. Half-hour line = `Math.round(parent.height / 2)` = **20**.
  Anything that hardcodes 40 or 16 again will drift. **R072 added a second derived family for the band — use the tokens.**
- **REF EVENT CHIPS (R063 + R073 — E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text + a 3px
  solid same-hue LEFT STRIPE** + small radius. **R073 measured the stripe at 1:1: x=491-493 = (187,62,216) over a light purple
  fill (488-489) — 3px, fully saturated, so it is not a compression artifact.** Contradicts our dark theme's
  solid-saturated-fill + white-text ⇒ the E family's first question is whether our dark translation is legitimate. **R070/R073
  addendum:** a *second* all-day chip style is **near-white (248) with a coloured ring icon** (`FaceTi…`/`Buy pots`/`Status…`, and
  the blue ring at x=329-340 in R073). **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families
  (弹框/浮层) are HIG+token-anchored only.
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar
  + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels
  193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns,
  1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots 12px ⇒ 1:1.
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). Hour lines and vertical
  separators are both **1px (237,237,237)**. Gutter label (ref x 215..238): digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**,
  right ink edge 238 vs grid line 243 ⇒ 5 ref-px.
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R074).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `review-command.py` takes **ONE
  argv that is a JSON list** (a bare list → `json.loads(sys.argv[1])`; `dict` is auto-wrapped), bumps `sequence` itself, writes
  **in place** (never `os.replace` — the QML watcher would reload and invalidate state). `captureClient` writes a **relative**
  path against the app's CWD ⇒ **launch `start-review-vm.sh` from the task dir** (or `mv` the PNG and check with `ls`).
  Success line: `qml: [UIReview] native app client capture <name> true`. **R069–R074: the whole drive list
  (`resize`+`view`+`date`+`captureClient`) in ONE invocation works fine.**
- **launch/re-launch:** `start-review-vm.sh` blocks on `wait "$app_pid"` — background it (`nohup … & disown`). A rebuilt binary needs
  a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~20s to the new pid. Include `resize 1100x692`.
  It starts in `--view week --date 2026-10-15`, so every drive list must re-send `view week` + `date 2026-04-02`. It loads
  `harness/Main.qml`, which imports the **source tree** ⇒ the source edit renders on relaunch (a ninja rebuild is still the safe
  habit). **Two captures in one round = 2 kill+relaunch cycles at ~35s each; that is the round's budget.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**):
  VEVENTs Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 /
  **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`** all-day strip spanning **Mon 30 – Thu 2**.
  **R072 ADDED two all-day VEVENTs on 2026-04-02: `Design sync` and `Release notes`** (so Thursday carries **3** all-day items and
  the band's gap is measurable). VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00,
  `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (the record for any wrapping-title test).
- **Row-band measurement idiom (worked sixteen times, R046/R062–R074):** scan the target column (or row) for pixels that are
  **not** the background, threshold, group into bands, read the band **centre** (text) or **start** (cap-tops). A **row/column mean
  over a wide span** is the cheapest way to find horizontal lines. **Caveats:** keep the window strictly inside the region; the
  all-day separator and the first hour line can be **adjacent rows** (232/233 vs 234 — different weights, don't merge); the x=0
  rim merges every band, start at x ≥ 3; for **full-width** rules a row-mean over x 0..1099 is exact. **R070: the decisive idiom
  for a *per-column* property is a VERTICAL profile of one empty column.** **R071: fix the column map first with a single row
  run-scan in an empty grid row.** **R072: a vertical profile of the band column also catches a LAYOUT defect (7/13/6 spacing)
  that a screenshot alone reads as "roughly right".** **R074: an ASYMMETRIC check — same run-scan run at the band row AND the
  grid row — proves "now matches" in one call; and a 3-pixel window round each boundary (501/502/503) proves single-width.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert
  `im.size` first. **A composite (a 1:1 strip pasted above a 2–3× zoom) answers "overall form + local detail" in ONE image read.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md`
  can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.** A prepend Edit whose
  only `old_string` is the previous round's heading **deletes that heading** — re-append it. **R069/R071: two different PNGs can
  be byte-identical in SIZE — `md5sum` before concluding a capture is stale.**

## Next round (pick ONLY #1)
**#1 — A01 step 5: the chip radius, 5 → ≈8.** Ref chips have a ~6 ref-px radius; our vertical scale is **×1.33** ⇒ ~8. Both the
all-day chip (`allDayChip`, `Layout.preferredHeight: root.allDayRowHeight`) and — separately, do not touch it this round unless
trivial — the timed chip (`radius: 5`) read the same today; **the atomic step is the ALL-DAY chip only**: change its `radius`
from **5** to **8** in `apps/calendar/qml/CalendarScheduleView.qml` (the `allDayChip` delegate's `radius:` line, around line 380
after R074's insertion). **Do NOT** change: inset 1, row 24, gap 1, band 76, the separators added in R074, the four rule tokens,
the weekend tint, or the timed chip. **Predicted measurable outcome:** the chip's top-left corner pixel walk changes — at the
chip's first row (y=157) the light-blue fill now starts **≈4px in from x=503** instead of **≈2**; measure the chip's leading
fill run on each of its first 3 rows to show the corner arc. **A radius change is a form change, so it needs a *zoom crop of
the chip's corner* (2–3× Nearest) read with the eyes, not just a run-scan.**

**Then (unlocked, ref-anchored, one per round):** **E01/E02** (the chip language — ref = light same-hue fill + dark same-hue
text + **3px** left stripe vs our `radius: 5` 1px-border fill and blue all-day pills), N02 (now-line + red badge — needs a
capture of the **current** week), V01–V05 (month — **no ref anchor**, use `spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten an already-nested
form into `{"action": …}` so every later round stops paying the R064 diagnosis cost. (R074 paid it again — the script takes ONE
argv that is a JSON **list**, not space-separated words.)

**Still blocked on rulings A–F** (unchanged): dim snap, shadow magnitude, popover Esc, `slice(0,2)` / month 1-chip cap, E03
clause 3, **F = 12-hour two-tone gutter labels**; plus the D/O family. **The `code-writer` subagent is NOT registered in this
session** — R072/R073/R074's edits were made directly (one literal each); do not retry `code-writer` each round.
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 are PASS-pending-final-regression; everything else is PENDING or
ruling-blocked.)
