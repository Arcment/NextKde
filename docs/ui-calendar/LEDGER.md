# R070 — **The "all-day band tint" premise was wrong: the reference tints the WEEKEND COLUMNS, not the band.**
Re-measured on the ref (vertical profiles of empty columns): weekday columns are **255** in band *and* grid, Sat/Sun are **249** in *both*. Implemented the real thing — a weekend section tint over the whole schedule field (band + hour grid, header row excluded). Light measured exact: **249 on Sat/Sun, 255 on weekdays, in both regions.** (2026-10-17)

## 本轮 (R070)
Atomic step: the standing Next-round #1 ("give the all-day band its section tint"). **Its premise did not survive measurement**, so
the round implements the ref-anchored fact it was reaching for. One file, one token, one helper, two 5-line additions.
Build + light capture ≈ 26 Bash calls ≈ 9 min. Evidence → `r070-weekend-tint-light.png`.

**The falsification.** The reference was re-measured column-by-column instead of sampled at one point. Vertical profile of the two
*empty* columns — Tue (x=440) and Sat (x=770) — from y=124 to y=185:
`Tue: 124=242, 125=249, 126..181=255, 182=236, 183/184=217, 185=249` ·
`Sat: 124=242, 125=244, 126..181=249, 182=236, 183/184=217, 185=249`.
So the band interior is **255 on a weekday column** — white, exactly like the hour grid, not 249. The `249` is the **weekend
column's field colour**, and it is identical above (band) and below (grid): `<img> Sat y500 = 249, Sun y500 = 249, Mon/Tue/Wed/Thu/Fri y500 = 255`.
`y=125` is not a tint row at all — it is the **half-strength row of the 242 top boundary** (242→255 blends to 249 over white,
242→249 blends to 244 over the weekend tint; both consistent with one semi-transparent rule over the local background).
The earlier "249 weekday / 244 weekend band tint" note (R068) was this same artefact read as a fill.

**No band-only tint exists in the reference.** The day-header row is *not* tinted either (weekend columns read 254 vs weekday 255 there —
below the noise floor), so the tint starts at the top rule and runs to the bottom of the hour grid.

**The change.** `apps/calendar/qml/CalendarScheduleView.qml`:
- new `weekendField` — light `#F9F9F9` (249,249,249), dark `Qt.rgba(1,1,1,0.03)` — plus `isWeekendColumn(column)`, which reads
  `dateForColumn(column).getDay()` and returns true for 0/6. **Date-driven, not position-driven**: our week is Mon-start, so Sat/Sun
  are the *last two* columns, whereas the ref's Sun-start week has them first and last.
- a `Rectangle { anchors.fill: parent }` as the **first** child of the all-day band's `allDayColumn` Item (stacks below the chips
  and below the column separators), and the same as the **first** child of the `hourCell` delegate.
- the hour-grid one is guarded `hourCell.columnIndex > 0` — column 0 is the gutter and `dateForColumn(-1)` is the *previous*
  Sunday, which would otherwise have tinted the whole gutter column.

**Measured (light, our 1100x692 capture):** row 180 (inside the band): weekday x=600/700 = **(255,255,255)**,
weekend x=880/900/1050 = **(249,249,249)** — exact target. Row 400 (empty hour grid): same 255/249 split.
Full row 180 histogram over x 0..1099: **298 px at 249**, matching the two weekend columns (2 x 149.7 = 299.4) to the pixel.
The four structural rules are untouched on the tinted column (x=1050): **155=242, 204/205=217 (2px), 206=237** — the tint rect
sits behind them, as designed. The day-header row is unchanged.

**Eyes** (`r070-weekend-tint-light.png`): 周六 4 / 周日 5 now read as a distinct section from the top rule down to the window floor,
and the header row above stays white — the band's left edge no longer looks like a cut-off rectangle.

**Not done this round:** the **dark leg** (relaunch + capture). `weekendField` dark is *derived*, not measured —
`white@0.03` on the (30,30,30) field ≈ 37. **Next round's first job.**

# R069 — **Weight inversion FIXED. The rule above the all-day band is now lighter than the hour line: (242,242,242) light / (39,39,39) dark.**
New local token `sectionRule` (`CalendarScheduleView.qml:66-71`); the last `AppTheme.border` consumer in this view (`:249`) now uses it. Width and span untouched — still 1px, still `Layout.fillWidth: true`. Both themes measured exact and uniform over the full 1100px. (2026-10-17)

## 本轮 (R069)
Atomic step: the standing Next-round #1 — fix the inverted weight of the separator **above** the all-day band.
One file, one token, one line changed. Build + light capture + dark capture. ~18 Bash calls ≈ 7 min.
Evidence → `r069-toprule-light.png`, `r069-toprule-dark.png`, `r069-ref-vs-ours-3x.png`.

**The change.** `apps/calendar/qml/CalendarScheduleView.qml`: added `sectionRule` after `allDaySeparator`
(`:66-71`) — light `#F2F2F2`, dark `Qt.rgba(1,1,1,0.04)`; and `:249` `color: AppTheme.border` → `color: root.sectionRule`.
`Layout.preferredHeight: 1` and `Layout.fillWidth: true` deliberately unchanged.

**Light, row-mean over x 0..1099 (exact dump at x=600/700/800/900 identical):**

| row | value | what |
|---|---|---|
| 154 / 156 | (255,255,255) | field white either side |
| **155** | **(242,242,242)** | **the separator — target hit exactly, 1px** |
| 204 / 205 | (217,217,217) | all-day bottom separator, still 2px, unchanged |
| 206 | (237,237,237) | first hour line, unchanged |
| 226 | (244,244,244) | half-hour line, unchanged |

**Dark:** y=155 **(39,39,39)** (=30 + 225×0.04, exactly as derived), neighbours the (30,30,30) field; hour line
206 ≈**59** (white@0.13, unchanged), half-hour 226 **43** (unchanged), all-day separator 204/205 **84**
(white@0.24, still 2px, unchanged).

**Weight order now matches the ref in both themes.** Ref: top **242** < hour **237** < bottom **217**.
Ours light: **242 < 237 < 217**. Ours dark: **39 < 59 < 84**. The inversion is gone; the ref's four-weight
class system now has its fourth member in our tree.

**Visual check (crop `r069-ref-vs-ours-3x.png`, ref band on top, ours below, 3×):** our band's top rule now reads
as faint as the ref's and the only heavier rule is at the band's bottom — the earlier "darker line above than
below" impression is no longer there. The crop also re-exposes, unchanged, the A01/E01 gap: our all-day chips are
**blue-filled pills**; the ref's are **neutral light-grey with a coloured left stripe**. Next unexamined mass.

## R068 — **Measurement only: the ref's separator *above* the all-day band is 1px (242,242,242), NOT 2px.**
So no code change (per the R067 brief). But the same crop exposes a **weight inversion**: the ref's top boundary is
its *lightest* rule (242 < its own hour line 237), while ours (223,225,228) is *darker* than our `gridLine` (237).
That inversion is now the top 仍差 and next round's #1. (2026-10-17)

## 本轮 (R068)
Atomic step: the standing Next-round #1 — "close the separator story". **Zero source edits, zero builds, zero
launches** (nothing changed, so nothing to relaunch). ~16 Bash calls ≈ 6 min. Evidence crop →
`docs/ui-calendar/r068-ref-allday-band-5x.png`.

**Answer: 1px.** Ref row **y=124 = (242,242,242)**, uniform, `min 229 / max 242 / mean 242.0` over x 244..812
(the 229s are the 6 column separators). y=123 = (254,254,254), y=125 = (244/249) ⇒ **one** row. Contrast R067's
bottom separator: y=182 **(233..236)** partial AA → y=183 **217** → y=184 **217** ⇒ two rows. **Discriminator:
a hairline is 2px only if it owns two full-value rows; a single row whose neighbours are white and a surface
tint is 1px.** Row-means cannot tell these apart — dump exact RGB at several x.
- **Span already correct:** the run reaches the gutter's left edge (x=194…246 all 242; x=186/190 = 236 =
  sidebar), i.e. x≈192..812, exactly like the bottom one. `:240-243` is already `Layout.fillWidth: true`.
- Ref hour lines re-confirmed **1px (237,237,237)** at y=220/221, x=260.

**The inversion.** Ref, lightest→heaviest: top boundary **242** < hour lines **237** < bottom separator **217**
(2px). Ours: top boundary **223,225,228** **>** hour lines **237**. Width and span of ours are right; **only the
weight is inverted.** Not fixed this round — that is next round's #1 (one Rectangle, maybe one token).

**A01 data, recorded (no code change).** The ref's all-day band is a **tinted section**, not white field:
weekday ≈**249**, weekend ≈**244**; the hour grid below is **255 white on weekdays, 249 on Sun/Sat** (y=210/216).
Band rows in col 1 (bg 244): chip fill **126..142 / 144..161 / 163..180** ⇒ **h ≈17, pitch ≈18.5, gap ≈1**;
first row **2px** under the y=124 line, last row **1px** above y=183. Chip **x 244..323** inside a column bounded
243/324 ⇒ **inset ≈1**, pill **radius ≈6**. Scaled (×1.33 h / ×1.35 w): h **≈22.6**, pitch **≈24.6**, gap
**≈1.3**, inset **≈1.35**, radius **≈8**, band content **≈77**. Ours: min 28 / row 18 / gap 2 / inset 2–3 ⇒
**rows ~20% short, inset ~2× too big.**

**Method cost paid (don't repeat):** a `max(px) < 252` run-scan cannot find chip edges in this ref — the band
backgrounds (249 weekday / 244 weekend) are themselves non-white, so every run returns the whole column. Use a
**per-column background reference + difference threshold**, then confirm edges with an exact value dump.

## 仍差 (top 8, visual-impact order)
1. **INVERSION: our separator *above* the all-day band is 1px `AppTheme.border` (223,225,228) — heavier than
   our own hour lines (237).** The ref's is 1px **(242,242,242)**, its **lightest** rule (< 237). Width/span
   already match. Ref-anchored, no spec ID. **← next round's #1.**
2. **Ref gutter labels are 12-hour and two-tone (dark hour number + smaller lighter `AM`/`PM`)**; ours is
   single-size 24-hour `07:00`. The ref right-aligns on the **suffix's** right edge. **Needs ruling F.**
3. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed both directions**. App-wide. **Needs ruling A.**
4. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
5. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**). **Needs ruling C.**
6. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block, while the ref's week
   view shows **proportional 30-min vs 60-min chips** ⇒ **ruling E**. Clauses 1+2 PASS (R048).
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs ruling D.** Same family: the month day cell holds 1 chip + `N`
   where the ref stacks 3 (`CalendarMonthView` cap is 1).
8. **A01 — the all-day band's own form, still unreviewed but now MEASURED (R068).** Ours: min 28 / row 18 /
   gap 2 / inset 2–3 vs the ref's ≈22.6 / 24.6 / 1.3 / 1.35 scaled, plus **a band background tint we don't
   have** (249 weekday / 244 weekend) — ref-anchored, no spec ID. **Next after #1.**
- *Cosmetic, no ID, folded out:* **the ref grid field is not uniformly 249** — weekday columns are **255 white**,
  only **Sun/Sat are 249** in the hour grid; our week is Mon–Sun so ours would be Sat/Sun (R068, no ID). Two
  neutral-button idioms diverge and one has no ref (R061): `secondary` hover = neutral grey 79, no edge; `flat`
  hover = accent tint (35,60,81) **with** a 1px edge. Light `buttonNeutral` base reads ≈(251,252,254) vs the
  rendered card (247,247,247) (R056). D02's radius is **16** vs the spec's 24/32 — **keep 16**. Hover is a flat
  fill, no `borderHover` edge (R057/R060). The topmost visible gutter label is **half-clipped** when a scroll
  offset lands an hour line exactly on the viewport top (R066; scroll artifact, not a form defect).

## 最近已改 (most recent 8)
1. R068 — **measurement only, no code change.** Ref top separator = 1px (242,242,242); weight inversion found.
2. R067 — all-day band bottom separator 1px `AppTheme.border` → **2px** local `allDaySeparator` (#D9D9D9 /
   dark white@0.24). Measured light **204/205 = (217,217,217)**, hour line 206 stays 1px. Light **and** dark.
3. R066 — **T03 PASS**: gutter label font 9→**11**, `anchors.right` + `rightMargin: 7` (gap 16 → **8**),
   `topMargin: -Math.round(implicitHeight/2)`. Centres 245.0/285.0/325.0 exact, pitch 40. Light **and** dark.
4. R065 — **T02 PASS**: `gridLine`/`gridLineMinor` tokens; per-cell border box → four single-edge 1px Rectangles.
   Hour 1px (237,237,237), half 1px (244,244,244). Light **and** dark measured.
5. R064 — **T01 FIXED**: `hourHeight: 40` single constant; scroll offset + cell height + chip height derive from it.
   Measured 10× 40.0.
6. R063 — measurement only; ref re-read as a **week** view; T01 measured FAIL (54 vs ≈40).
7. R062 — popover title leading 22→20px (`FixedHeight` + `lineHeight: 20`); 仍差 (old #6) CLOSED.
8. R061 — measurement only; **D08 toolbar flat `KosButton` PASSES**.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive. R067 moved the full R065
grid-token and R063 ref-fact-sheet blocks to rounds.md; R068 moved nothing out — its new ref facts are above.)*
- **THREE LOCAL TOKENS NOW OWN THE GRID'S RULES (R065/R067).** `CalendarScheduleView.qml:51-64`:
  `gridLine` (light `#EDEDED` / dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06),
  **`allDaySeparator` (light `#D9D9D9` / dark white@0.24)**. **`AppTheme.border` is NOT any of them.** The only
  `AppTheme.border` rule left in this view is the separator **above** the all-day band (`:240-243`) — deliberately,
  but **R068 says that is the inversion to fix** (ref 242 vs our 223, and our hour line is 237). **The ref has a
  fourth weight class below/above these**: 242 (lighter than any of our three). Expect a new token, not a reuse.
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** It is a `ColumnLayout` sibling of the `ScrollView`
  with `Layout.fillWidth: true`, so it runs the full window width — matching the ref, whose run starts at the
  gutter's left edge (ref x≈192) and stops at the right rim (x=812). **R068: the top boundary spans identically
  (ref y=124 reaches x=194). Do not "fix" either to start at the grid line.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a
  right edge: adjacent edges land on the same pixel row/column and render as 2px. The right rim is drawn only by
  `columnIndex === root.dayCount`. **R067 corollary:** the separator (204/205) and the first hour line (206) are
  **adjacent rows** with different weights — never read them as one 2px+2px band. **R068:** our y=155 top boundary
  and the day-header text above it are *not* adjacent — there is real white between them.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill
  and not the ref's 249. **R068 refinement:** the ref's *weekday* hour-grid field is **255, the same white as ours**;
  the **249 belongs to the weekend columns (Sun/Sat)** and to the *all-day band* section tint. Compare like with
  like — do not quote "the ref's 249" against our 255 as if it were a field mismatch.
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
  watcher would reload and invalidate the state. `captureClient` writes a **relative** path against the **app's
  CWD**, which follows **your launch CWD** ⇒ **launch from the task dir**. Confirmed success line:
  `qml: [UIReview] native app client capture <name> true`.
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
  no suffix, 24 ref-px wide.
- **REF ALL-DAY BAND AS A FORM (R068).** Tinted section: weekday **249**, weekend **244**; hour grid below = 255
  weekday / 249 weekend. Rows **h ≈17, pitch ≈18.5, gap ≈1**, first row 2px under the top line, last row 1px above
  the bottom line ⇒ band content **58 ref-px**. Chip **inset ≈1**, **radius ≈6** (rounded). Scaled ×1.33/×1.35:
  h ≈22.6, pitch ≈24.6, gap ≈1.3, inset ≈1.35, radius ≈8, content ≈77.
- **REF EVENT CHIPS (R063, this is E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text
  + a 2–3px solid same-hue LEFT STRIPE** + small radius. Confirmed on `Portfolio…`/`Leadersh…`/`Presenta…` (red),
  `Choir…` (olive/yellow), `Morning…` (blue), `Palm Sun…` (pink/magenta stripe). **This contradicts our dark
  theme's solid-saturated-fill + white-text** ⇒ the E family's first question is whether our dark translation is
  legitimate. Not yet judged. *(Our timed chip is `radius: 5`, a 1px border, no left stripe. **R068:** the ref's
  all-day pill radius ≈6 on a 17px row ⇒ ≈0.35×height; ours is 5 on 16.)*
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
- **Row-band measurement idiom that has now worked nine times (R046/R062–R068):** scan the target column (or row)
  for pixels that are **not** the background, threshold, group into bands, read the band **centre** (text rows) or
  **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to find horizontal lines when
  chips make single-column probing noisy. **Caveats:** keep the scan window strictly inside the intended region
  (R064 — and **R067: establish the y-map first, my window stopped 4px short of the target**); the all-day separator
  and the first hour line can be **adjacent rows** (204/205 vs 206 — different weights, don't merge, R065/R067);
  the x=0 rim column merges every band, start at x ≥ 3 (R066). **R068:** for edges inside the ref's *band*, the
  "background" is per-column (249 weekday / 244 weekend) and the field is 255 — a global `not-white` threshold
  returns whole columns. Reference the local background and confirm with an exact value dump.
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
  `old_string` **deletes that heading** — re-append it (cost me one fix-up in R067).

## Next round (pick ONLY #1)
**#1 — fix the inverted weight of the separator ABOVE the all-day band.** One file,
`apps/calendar/qml/CalendarScheduleView.qml:240-243`: `Layout.preferredHeight: 1` and `color: AppTheme.border`
stay at 1px, but the colour must move from (223,225,228) to the ref's **(242,242,242)** light — i.e. **lighter
than `gridLine` (237)**, our new lightest rule. Do **not** reuse `gridLine`/`gridLineMinor` (237 / 244 — the
244 one is close but is the half-hour line, a different semantic); add a fourth local token next to
`:51-64`, e.g. `sectionRule` = light **`#F2F2F2`** (242,242,242 — note `#F2F2F2` *is* exactly 242) / dark
**white@0.04** (derived: our dark hour line is white@0.13 for a 237-on-white equivalent, so a rule meant to be
*lighter* than it needs a *lower* alpha; take ≈0.04–0.05 and **measure**, don't assume). Also: the day-header
row's own **bottom** edge is the same Rectangle — confirm no other `AppTheme.border` consumer in this view
changes. After the edit: build, relaunch, capture light, and **measure y=155 as a row-mean over x 0..1099** —
target **(242,242,242)**, and verify the first hour line (206) and half-hour (226) are **unchanged** and that
the all-day separator at 204/205 is still 2px (217,217,217). Dark leg same day or next round if the circuit
budget runs out — **do not skip the light measurement.**

**Then (unlocked, ref-anchored, never reviewed — one per round):** A01 (the band's form — now **measured**, see
R068: rows ~20% short, inset ~2× too big, and we have no band background tint), **E01/E02** (chip language — the
biggest unexamined mass; the ref's light-fill + dark-same-hue-text + 2–3px left stripe vs our `radius: 5`
1px-border fill), N02 (now-line + red badge — needs a capture of the **current** week), V01–V05 (month — **no ref
anchor**, use `spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten an
already-nested form into `{"action": …}` so every later round stops paying the R064 diagnosis cost.

**Still blocked on rulings A–F** (unchanged): dim snap, shadow magnitude, popover Esc, `slice(0,2)` / month 1-chip
cap, E03 clause 3, **F = 12-hour two-tone gutter labels**; plus the D/O family. **The `code-writer` subagent gap is
a standing environment issue** — record it, don't retry it every round.
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 are PASS-pending-final-regression; everything else is
PENDING or ruling-blocked.)
