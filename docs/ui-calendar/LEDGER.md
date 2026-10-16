# R086 — **仍差 #8 CLOSED: the today day-header disc is 22 px — the reference's own diameter, not a scaled 29.**
CODE CHANGE, one geometry line: `apps/calendar/qml/CalendarScheduleView.qml`'s header date mark `20x20 / radius 10` -> **`22x22 / radius 11`**
(plus the comment above it). Nothing else touched. **The "22 ref px x1.33 => 29" derivation is WITHDRAWN**: 29 applied the window-height
ratio (522->692 = 1.33) to a *type* element, but our type does **not** render at 1.33x the ref's — measured with one instrument on both
images, the ref's gutter-label ink is **9 px** and ours is **9 px**, and the ref's day-number ink inside the disc is **9 px** vs ours
**9 px** (a 12 px font on our side). **The two numbers are already 1:1, so the disc must be too: 22.** After the change: ref disc
**x536..557 x y101..122 = 22x22, colour (235,75,70)**; ours **x879..900 x y126..147 = 22x22, colour (229,72,77)** (= `todayRed`
`#E5484D`, a pre-existing token shared with the now-line — **not changed this round**). Vertical: ref disc centre y111.5 vs its
weekday ink centre 111; ours 136.5 vs 137.5 — **<=1 px, unchanged**. **Isolation proof:** the before/after pixel diff is exactly three
bands — **y126-147 = the disc** (1170 px), **y297-318 = the now-line, which moves with wall-clock** (captures 2 min apart, 01:50 ->
01:52), and 6 px at y62-63. **Every row from y148 to y296 — the whole all-day band (156..231) and the grid down to the now-line — is
byte-identical**, and `sectionRule` y155 still reads 242. The grey non-today *selected* disc shares the same Rectangle, so it becomes 22
as well (no ref anchor for that state; the geometry stays shared). Figure `docs/ui-calendar/r086-today-disc-cmp.png` — ref "Wed 1"
above our "Sat 17", **both at the same 1:1 pixel scale**.

---
# R085 — **N02 dark leg: no code change. The four-part now-line carries over to dark part-for-part; one extrapolation recorded.**
VERIFICATION ROUND (N02's dark clause). Capture `r084-leg.sh dark r084-dark 2026-10-17 0` — **no rebuild** (R084's binary is current),
**no edit**. Clock 01:46 vs the light leg's 01:43 ⇒ every part must move **+2 rows together** (3 min at `hourHeight` 40 = 2.0 px);
that the *four* parts move as one is itself the test of R084's "one geometry source" claim. Measured, light → dark:
**pill x4..45 (42×20) y293..312 → y295..314**, fill `(229,72,77)` **both legs** (identical, not a per-theme token); **dot centre y303.5
→ y305.5** (bbox y299..308 → y301..310, Δ+2); **now-line y303-304 → y305-306**, strong segment over Sat **`(229,72,77)` both legs**;
**faint `(252,236,237)` → `(50,34,35)`**, continuous over x60..799 by row mean (control rows 255 / 30) — i.e. **the faint rule does not
drop out in dark**; `y294` half-hour line and `y314` (hour 2, suppressed label row) unchanged: light `(244,244,244)`/`(237,237,237)`,
dark `(43,43,43)`/`(59,59,59)` = the untouched `gridLineMinor`/`gridLine` tokens. `02:00` suppressed in both (|314−305.5| = 8.5 ≤ 14).
**One extrapolation, NOT fixed:** the faint rule's luminance contrast is **7.4 in dark vs 15.5 in light** (ΔL: (50,34,35) vs field
(30,30,30); (252,236,237) vs white), so at 0.10 alpha the dark faint rule reads as a whisper and the line *looks* like it stops at the
dot — visible in the ×6 crop only. **No ref anchor exists** (the ref image has no dark mode) ⇒ recorded, not changed; alpha is a shared
token and the ref's structure is matched. Figure `docs/ui-calendar/r085-nowline-dark-cmp.png` (light/dark pill, dot, ×6 faint rule).

# R084 — **N02: the current-time line is now the ref's four-part object (faint rule + today's strong rule + dot + gutter pill).**
One change, `apps/calendar/qml/CalendarScheduleView.qml`: six root properties (`nowRow`, `nowInHour`, `nowLineY`, `nowLabel`,
`todayColumn`, `nowLabelClearance`) + the gutter Label's `visible` + a new `nowPill` + the old per-cell 1px line replaced by
**`nowLine` (2px) + `nowDot` (9px)**. Before this round the line was **1px, today-column-only, `AppTheme.destructive`, no dot, no
badge**. Ref, measured: a **2-ref-px rule — full strength across today's column (x487..569 = Wed 1), ~10% across the whole grid
x243..813**, a **d≈6.5 dot centred on today's left rule (488.5 vs 487)**, and a **31×15 capsule pill** in the gutter whose right
edge (239) sits on the hour labels' ink edge (238) and whose centre (**y238**) is the **TRUE now y for 9:41 — not a tick**. The
pill's row **drops the hour label it collides with**: in the ref 9AM (ink y216-224) survives while 10AM is gone. Ours after: pill
**42×20, x4..45** (= ref ×1.35/×1.33), `01:00` ink **y270-278** survives and the next label is suppressed, line **y303-304**
strong over **Sat 802..951** `(229,72,77)` / faint `(252,236,237)` elsewhere, dot **9px centred x=802**. Colour
**`AppTheme.destructive` → `root.todayRed`**: `#E5484D` (229,72,77) vs the ref's (235,76,70), where the old token is (216,59,59).
Band, chips, separators, `itemStableId` untouched. Figure `docs/ui-calendar/r084-nowline-compare.png`. (2026-10-17)

## 本轮 (R084)
Atomic step: **one code change + its light-leg regression.** Budget: 1 ref composite + 5 measurement calls + 3 Edits + 1 build (7
targets, clean) + 1 new leg driver + 2 analysis calls = ~21 Bash. **The now-line needs the CURRENT week AND a scroll:** local time
was **01:43**, so `usefulStartHour()` returns 7 and the hour-1 line sits off-screen ⇒ new `r084-leg.sh` appends
`{"action":"position","contentY":0}` (`harness/Main.qml:263`) — **every future current-time capture must send `position` or the
line is invisible**. Leg: pid 145631 → 147363, `capture-r084-light.png true`, 3050463 bytes, md5 `075f80b4…`. `code-writer` still
NOT registered; the edit was made directly (R072–R083 precedent). **Dark leg NOT captured (budget) — see 仍差 #1.**

## E01/E02 + N02 status (tester's call, R084)
Timed chip — **bar PASS (R077), no border PASS (R078), dark same-hue ink PASS (R079)**. Band chip — **ink PASS (R080)**.
**The band chip's ring icon is MEASURED (R081) but NOT built — blocked on ruling H** and on one decision: ring **16** (vertical ratio)
vs **22** (horizontal ratio). **R084 changed no chip code ⇒ R080's regression evidence stands.**
**N02 — line + dot + pill PASS on the light leg (R084)**, structure-for-structure against the ref (faint rule + today's strong rule
+ dot + gutter pill; the three parts share one geometry source). Open residue: (a) the **dark leg was NOT captured** (budget) — the
line now uses the `todayRed` token in *both* themes, so the dark leg is **extrapolation with no ref anchor**; (b) the **today header
disc size** (仍差 #8). The spec's "line 1 at proper tick" is satisfied by the *true* time position, which is what the ref does
(9:41 ⇒ y238.4, not the 220/247 ticks).

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
8. **The today day-header disc is 20px; the ref's is 22 ref px ⇒ 29 at our scale** (R084: ref x536..557 × y100..122 = 22×23, a
   filled `todayRed` disc with a white number, inline after the weekday name — `CalendarScheduleView.qml`'s header cell). N02's own
   clause ("today marker visible") PASSES; this is the *size* only, so it is cosmetic-adjacent but ref-anchored.
   - *Demoted from #8 (R084):* the band-chip fill alpha — ref **0.16** vs ours **0.17** (R080), a 1-level difference on the 0.17
     leg. Still not worth a round unless something else takes us into `allDayChip`'s fill.
- *Cosmetic / settled, no ID:* the band's empty third slot is visibly ruled (R074's separators cross it). `secondary` hover = neutral
  grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius **16** vs spec 24/32 — **keep 16**. Topmost
  visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on the viewport top (R066; scroll artifact).
- **CLOSED in R083: 仍差 #8, the nondeterministic Thu band-chip order.** R082's 3-leg experiment showed light1 == dark1 ≠ light2 on the
  same build; the comparator's `itemDateTime` tie was resolved upstream by an unstable emitter order. The tiebreak now decides it.

## 最近已改 (most recent 8)
1. R084 — **`CalendarScheduleView.qml` N02**: `nowRow`/`nowInHour`/`nowLineY`/`nowLabel`/`todayColumn`/`nowLabelClearance`;
   `nowPill` (42×20 `todayRed` capsule, white time, rightMargin 6); the gutter Label hides when the pill would collide; the old
   1px per-cell line → `nowLine` (2px, strong on today's column / 0.10 elsewhere) + `nowDot` (9px on today's left rule); colour
   `AppTheme.destructive` → `root.todayRed`. Nothing else touched.
2. R083 — **`Main.qml`**: new `itemStableId(item)` + the sort comparator's tie fallback (UID, then title) ⇒ the all-day tie order is
   a total order. Everything else untouched.
3. R082 — **verdict only, NO code changed**: the Thu band-chip order swap is **run-to-run**, not theme-dependent; R080's theme rule
   withdrawn; the mechanism named (equal `DTSTART` ties in the model's sort). Figure in `docs/ui-calendar/`.
4. R081 — **measurement only, NO code changed**: the band chip's ring icon → 12x12 / stroke 3 / hole 6 / inset 3 / item-colour ink; the
   thin-stroke second family found; the anisotropic-scale question raised. Detail now lives in `LEDGER.md` R081.
5. R080 — **the band chip's ink**: `allDayChip` gained a derived `inkColor` (same expression as `timedChip`), Label `color:` →
   `allDayChip.inkColor`. Ref-anchored 1:2 on two ref colours.
6. R079 — **E01/E02 step 3**: `timedChip` Label `color:` `AppTheme.text` → derived `inkColor` = the colour halfway to its pole.
7. R078 — **E01/E02 step 2**: `timedChip`'s `border.width: 1` + `border.color` **deleted**.
8. R077 — **E01/E02 step 1**: `timedChip` gained a saturated same-hue left bar — derived `stripeWidth`/`stripeInset` (= 4, from
   `chipHeight/4`), capsule radius, vertical margin 2, `color: itemColor(modelData)`; Label `leftMargin` 5 → derived.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE CURRENT-TIME OBJECT IS FOUR PARTS WITH ONE GEOMETRY SOURCE (R084).** `nowRow` / `nowInHour` / `nowLineY` / `nowLabel` /
  `todayColumn` / `nowLabelClearance` at `CalendarScheduleView.qml`'s root; the pillow/pill/line/dot and the suppressed label all
  read them. **Do not re-derive a y per part** — that is how the four drift apart.
- **OUR NOW-LINE, MEASURED (R084, light 1100x692, `contentY 0`, clock 01:43):** pill **42×20 at x4..45** (`rightMargin 6`), centred
  on the true now y; **line 2px at y303-304**; strong segment = today's column **802..951** `(229,72,77)`; faint `(252,236,237)`
  (= 0.10 alpha) across **52..1101**; **dot 9px centred x=802**; the `01:00` label ink **y270-278** survives and the next label is
  gone. **Column boundaries are 52/202/352/502/652/802/952/1102** — `dayColumnWidth = (1102−52)/7 = 150`; the older "pitch 149"
  phrasing is the *delegate count* dressed up as a width. Sat 17 ⇒ 802..951.
- **THE REF'S NOW-LINE IS CONTINUOUS ACROSS THE WHOLE WEEK, WEEKEND INCLUDED (R084).** A first read said it stopped at x=732; the
  truth is a **green chip sat under it** (green (226,243,229) + 10% red = (227,226,213) — the "weekend tint" I misread at x753/783).
  ⇒ **a faint overlay over a coloured chip is indistinguishable from a tint by eye: always sample a known-empty column too.**
- **THE REF'S PILL DROPS THE HOUR LABEL IT COLLIDES WITH (R084).** Pill y231..245; **9AM ink y216-224 survives, 10AM is gone**.
  ⇒ ours hides a label when `|label tick − nowLineY| ≤ 14` (pill 20 tall + label ink 9 ⇒ half-sum 14.5), and only when today is in
  the shown week (`todayColumn >= 0`) — otherwise a week without today would lose a label for nothing.
- **A CURRENT-TIME CAPTURE NEEDS `position contentY` (R084).** The launcher opens at hour 7 (`usefulStartHour()`), so with a local
  time outside 6..21 the line is off-screen. Drive `{"action":"position","contentY":0}` (`harness/Main.qml:263`) before the capture.
  The harness logs the **pre-command** `contentY`, so the log line still reads 280 even when the command set 0 — trust the pixels.
- **AN EQUAL-START TIE IS NOW DECIDED BY US, AND THE KEY IS THE UID (R083).** `Main.qml`'s sort falls back to `itemStableId` (record
  `seriesId` = the VEVENT UID, then `id`) and then `itemTitle`. Because UIDs are unique this is a **total order**, so the result no longer
  depends on the engine's sort stability. **Any future "same-time items are in the wrong order" report: this is the line to read.** The
  rendered winner for the fixture's Thu pair is `Design sync` (UID `…allday-a`); no ref anchor exists for it — it is a *stability*
  choice, not a match.
- **TWO SAME-THEME LAUNCHES CAN BE PIXEL-IDENTICAL INSIDE A REGION AND STILL HAVE DIFFERENT md5s (R083).** light1 vs light2: identical
  fill, count, top-5% ink mean and extreme pixel in the band, three distinct file hashes — the **now-line moves with wall-clock** between
  launches. ⇒ **never treat a differing md5 as evidence of a content difference; diff the region.** (Pairs with R069/R071/R079/R082:
  a differing md5 also does NOT prove two captures are different, since the point is the reverse direction — size equality is not
  staleness either. Diff the pixels, in both directions.)
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
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Measured on **five** ref colours — three *timed* bars
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
- **THE HULL FAILS AS AN INK INSTRUMENT (R079, re-confirmed R080/R083).** Our light band chip's *darkest* pixel is (60,71,121) — off the
  fill→ink segment (G too dark) — while dozens of mid-coverage pixels fit the assumed ink to ±0.005. **Never read an ink off the extreme
  pixel in either theme. R083's instrument is the top-5%-coverage MEAN, which reproduced to the last digit across two launches.**
- **THE REF'S ALL-DAY BAND HAS TWO CHIP FAMILIES, AND ONE IS UNEXPLAINED (R080).** (a) *Coloured*: same-hue wash + same-hue ink at 1:2 +
  same-hue ring (purple, blue-grey). (b) *Neutral*: fill **248**, ink **(38,38,38)** — a neutral pair that **cannot** be `itemColor` and
  `itemColor/2` of the same source — while the **ring** is strongly coloured. **Do not cite the neutral chips for any ink or fill rule;
  they are not explained by our model.**
- **A CROSS-ROUND PNG IS NOT POSITION-ALIGNED (R079, strengthened R082/R083).** Same session, view and date, two rounds: different chip
  sets at the same y, and in the dark pair a *green* chip in one round where the next has *blue*. **R082: true of two launches of the
  same build.** **R083's refinement: the *layout* map (columns, y-bands) and, for a same-theme pair, even the *content* can be
  pixel-stable — but that must be MEASURED per region, never assumed; the file hash is not the instrument.** ⇒ **re-derive the content
  map on every capture; keep treating layout maps as stable.**
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>` if `live-app.pid` points at a running `kos-calendar`. ⇒ **`kill "$(cat live-app.pid)"`
  first, keep the launcher's stderr, and check `live-app.pid` changed** (R083: 144185 → 145311 → 145475 → 145631). **`leg.sh <theme>
  <name>` does the whole leg (kill, launch, sleep 30, one flat drive list, md5) in one call; three legs fit one round comfortably.**
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
  (R082/R083 re-read, exact); ink `itemColor` halfway to the pole — light **(24,70,99)**, dark **(152,198,227)** for that blue. Row 0 = y
  **157-180**, gap **181**, row 1 = **182-205**, third slot **206-231**; band chip inset 1 ⇒ fills 53..200 / 203..350 / 353..500 /
  503..650…; Label `leftMargin: 5`. **R083: the Thu band region is byte-reproducible across two same-theme launches.**
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
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R083).** Corner: per-row **fill-start inset**. Joint: per-row
  **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a
  raw profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap argument**, and for
  a cross-capture comparison the **top-5%-coverage mean** (R083). **Ordering/content: a per-column deviation-from-fill profile rendered as
  an ASCII ramp string — equal strings are equal content (R082).** **Caveat: read the *fill* channel, not luminance** — antialiased text
  and ring icons poison a luminance scan. **R083: a word-space GAP in that ramp string gives the word-length signature of a title without
  reading a font (r0 28+19 px = 6+4 chars).**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **FLAT filename**; it
  lands in the app's CWD (= the directory `start-review-vm.sh` was launched from). **Always read the success flag in
  `live-runtime-vm.log`** (`… capture <name> true`) and then `ls` the actual CWD.
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`; measured y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237).
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R083 (dark too, R082).** `sectionRule` **y=155**
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
  expression twice. R083 added `Main.qml:itemStableId`. If a third consumer of the ink expression appears, hoist it, do not copy it.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026) + 243px sidebar + mini
  calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 =
  **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238. **7 equal day columns, 1px separators at
  x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the
  contract says 40; 40 was chosen). Hour lines and vertical separators are both **1px (237,237,237)**. Gutter label (ref x 215..238):
  digit **(89,89,89)**, `AM`/`PM` suffix **(176..193)**, right ink edge 238 vs grid line 243 ⇒ 5 ref-px. **Columns: Sun 29 · Mon 30 · Tue
  31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R083).** `harness/Main.qml` matches `command.action` only
  (`captureClient{path}`, `escape`, `resize{width,height}`, `sidebar{expanded}`, `view{view}`, `date{date}`,
  `openItem{kind,titleContains}`); a command with no `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is
  a JSON list**, bumps `sequence` itself, writes **in place** (never `os.replace`). The whole drive list in ONE invocation works fine.
- **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it (`nohup … > log 2>&1 &`). **It EXITS 1
  without launching if `live-app.pid` still points at a live `kos-calendar` (R079) — kill that pid first, keep the launcher's stderr, and
  check that `live-app.pid` changed.** A rebuilt binary needs a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never
  `pkill`. ~24 s to the new pid (30 s is a safe sleep). Include `resize 1100x692`; it starts in `--view week --date 2026-10-15`, so every
  drive list must re-send `view week` + the date. **The theme is fixed at launch — a dark leg costs a full kill+relaunch.** **App stderr
  goes to `live-runtime-vm.log`** — read the capture success flags there before believing any capture. **`leg.sh <theme> <name>` does the
  whole leg in one call (R082); three legs fit one round comfortably (R083).**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics`; the repo-root `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs
  Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately lengthy title** 11:00 / **Design review** 14:30 /
  Evening session 18:00; plus a **`Multi-day review`** all-day strip with **`DTSTART;VALUE=DATE:20260330` + `DTEND;VALUE=DATE:20260403`**
  (line 574) ⇒ covers Mon 30 · Tue 31 · Wed 1 only and **does not appear on Thursday**. `Design sync` (**ICS 832-834, UID
  `…r072-allday-a`**) + `Release notes` (**ICS 842-844, UID `…-b`**) are two separate **single-day** all-day VEVENTs on **2026-04-02**,
  **byte-identical in DTSTART/DTEND** ⇒ **Apr 2 carries exactly 2 all-day items**; since R083 their order is the UID order
  (`Design sync` first). VTODOs (kind `"todo"`): `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00,
  `A deliberately long task title to inspect elision` 11:00, **`[R019 LONG TASK] 任务长标题与编辑表单检查`**. **The rendered week also
  shows `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist` — re-read the ICS before predicting a cell's contents.**
- **Row-band measurement idiom (R046/R062–R083):** scan the target column (or row) for pixels that are **not** the background, threshold,
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
  the test, and it needs no threshold tuning. R083: the same ramp exposes word boundaries ⇒ title signatures without OCR; and the
  top-5%-coverage mean is the reproducible ink scalar.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script — assert `im.size`
  first. **A composite (1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read.** **R076: label the rows in
  the composite (`ImageDraw.text`).** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.**
  **R078: a ×6 `NEAREST` edge crop is right for "is there a 1px ring" — back it with raw numbers.** **R080: a `Counter` mode over a cell
  gives the fill in one call.** **R082/R083: a ×3 `LANCZOS` stacked composite with a black label bar per leg is the whole verdict in ONE
  image read. R083 caveat: a ×3 LANCZOS upscale can make two IDENTICAL inks *look* different across stacked panels — when the composite
  suggests a difference inside a replicated region, confirm it with the numbers before reporting it (it was a misread here).**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
  **R069/R071/R079/R082/R083: two different PNGs can be byte-identical in SIZE — `md5sum` before concluding a capture is stale; and per
  R083 a differing md5 does not imply differing content — diff the region.**

## Next round (pick ONLY #1)
**#1 — N02's dark leg: capture `r084-leg.sh dark r084-dark 2026-10-17 0` and read the same numbers as the light leg.** R084 moved
the line's colour to `root.todayRed` (`#E5484D`) in **both** themes and the dark leg was never captured, so this is the one place a
dark-leg surprise can hide (the 0.10 faint rule over a (30,30,30) field is the specific worry — `(50,34,35)` is only ~3% away from
the field). Compare pill bbox / line rows / strong-vs-faint colours / dot centre against the light numbers above; **the ref has no
dark mode, so the dark leg is a *visibility and consistency* check, not a match** — only fix it if something is actually broken.
**Do not touch the chips, the band, or the light-leg geometry.**

**Then (unlocked, ref-anchored, one per round):** **仍差 #8** — the today header disc 20px → 29 (ref 22 × 1.33), a one-line change in
the header cell. Then **A02** — blocked until a fixture with 1 and 4 all-day rows exists; V01–V05 (month — **no ref anchor**, use
`spec.md` + HIG only).

**Blocked on rulings A–H:** the **band icon (H, R081 — measured, needs only the ruling and one decision: 16 vs 22)**, dim snap (A),
shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), `slice(0,2)` / month 1-chip cap (D — also
needs a 3-all-day-item day), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the ref's
measured 1**. **The `code-writer` subagent is NOT registered in this session** — R072–R083's edits were made directly; do not retry
`code-writer` each round. **Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03
PASS**; **E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080); **N02 now the top open ref-anchored item**; everything else PENDING
or ruling-blocked. **R083 touched only `Main.qml`'s sort ⇒ R080's chip regression evidence still stands.**)
