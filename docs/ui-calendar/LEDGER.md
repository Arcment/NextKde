# R067 — **The all-day band's bottom separator is now 2px (217,217,217), exactly the reference's value; the hour line below it stays 1px.**
Pre-round it was 1px `AppTheme.border` (223,225,228) — the same weight as every other rule, so the grid had no
strength hierarchy. (2026-10-17)

## 本轮 (R067)
Atomic step: the standing 仍差 #1 — "all-day band bottom separator: 1px → 2px (217,217,217)".
**Code change**, one file, 2 edits (1 local token + 1 Rectangle). 1 build, 2 relaunch+capture circuits
(light, then dark), ~22 Bash calls ≈ 13 min.

Change — `apps/calendar/qml/CalendarScheduleView.qml`:
- **New local token** (`:59-64`, after `gridLineMinor`): `allDaySeparator` = light **`#D9D9D9`** (217,217,217) /
  dark **`Qt.rgba(1,1,1,0.24)`**. Local on purpose: `AppTheme.border` is app-wide and blue-tinted, and `border`
  is shared with cards/fields/buttons — same reasoning R065 used for `gridLine`/`gridLineMinor`.
- **The separator Rectangle** (`:323-327`, was 316-320): `Layout.preferredHeight: 1` → **`2`**,
  `color: AppTheme.border` → **`color: root.allDaySeparator`**.
- The **other** 1px `AppTheme.border` rectangle in the same `ColumnLayout` — the one *above* the all-day band
  (`:240-243`) — is **byte-identical**: only the band's bottom boundary was in scope.

**Measured PASS.** Light, field is pure white: **y=204 and y=205 both exactly (217,217,217)** = 2px, spanning
**x 0..1099** (the whole main region *including* the gutter). The **first hour line** is the *next* row,
**y=206 (237,237,237), 1px** — R065's adjacent-rows caveat respected, the two did **not** merge. Half-hour line
y=226 (244,244,244), 1px. Dark, field (30,30,30): y=204/205 **(84,84,84)** 2px, y=206 **(59,59,59)** 1px hour,
y=226 **(43,43,43)** 1px half. **Geometry is identical in both themes (204/205/206)** ⇒ no layout shift; the
separator is a `ColumnLayout` sibling of the `ScrollView`, so +1px only shortened the grid viewport by 1px.
**Pitch intact:** 206 → 226 = 20 = half of `hourHeight` 40 ⇒ T01 unregressed.
Crops: `r067-alldaysep-light-2x.png`, `r067-alldaysep-dark-2x.png` (copied here).

**Ref re-measured first (the gate for the whole round).** `macos-calendar.png` y=**183 and 184 both (217,217,217)**,
y=182 (234,234,234) a partial AA edge — so **2px**; the run spans **x 192..812**, i.e. 621 px across the 620px
main region: **from the gutter's own left edge all the way to the right rim**, crossing *under* the gutter rather
than stopping at the grid line at x=243. Our `Layout.fillWidth: true` sibling reproduces that exactly (x 0..1099).
The ref's hour lines are 1px ≈237 (R065) ⇒ 217 is a **deliberate strength step**, not a different rule.
**Consequence for the y-map** (our 1100x692 light, `view week` + `date 2026-04-02`): title row text 94-105 →
1px (224,224,224) at **118** → day-header text 133-141 → 1px `AppTheme.border` (223,225,228) at **155** (this is
the rect *above* the all-day band) → all-day chips 168-188 → **R067's 2px at 204/205** → first hour line 206.

**Dark token derivation (recorded, no dark reference exists).** Light separator `#D9D9D9` = black@0.149 over
white; light hour line `#EDEDED` = black@0.0706; ratio **2.11×**. R065's dark hour line is white@0.13 ≈ 1.85×
its light 0.0706 — a standard dark-theme visibility compensation. Applying **0.149 × 1.85 ≈ 0.275**, I took the
slightly conservative **0.24**. Measured result: separator 84 vs hour 59 ⇒ **Δ25 on the 30..255 field = 11.1% of
range**, vs light's Δ20 = 7.8% — marginally stronger in dark, same ordering, same direction as the ref's
hierarchy. **Not a defect**, but it is the one number here with no reference behind it; if a dark ref ever
appears, re-derive. (Deltas: dark hour→half = 59→43.)

**Cost of one wrong scan window (record me).** My first light scan covered **y 90..200** and therefore only found
the 1px (223,225,228) at **y=155** — which is the separator *above* the all-day band, **not** the one I changed.
The band's bottom separator is at **y=204**, outside that window. **Measure the y-map before claiming a target
row.** Also: launching from the task dir again put the captures in the task dir (R066's rule holds).

**Subagent note:** `code-writer` is **not registered in this session** (available: claude, Explore, general-purpose,
Plan, statusline-setup). Rather than spend the round on agent plumbing for a two-constant edit, I made the edits
directly. **The loop's identity split was not exercised this round.**

**Scope guards:** `hourHeight` (40) untouched; `gridLine`/`gridLineMinor` and every grid Rectangle untouched; the
gutter `Label` untouched; the all-day band's `min 28 / row 18 / gap 2` and `Layout.preferredHeight: 18` (`:289`)
untouched; the separator above the band untouched; chips untouched; `AppTheme.qml` untouched.

# R066 — **T03 PASS: gutter hour labels are 11px, right-aligned 8px from the grid, centred exactly on their tick.**
Pre-round they were font **9**, **centred** in the 52px gutter (ink right edge x=36 ⇒ a **16px** gap), and shifted
by a hardcoded `topMargin: -7` that was only correct at font 9. (2026-10-17)

## 本轮 (R066)
Atomic step: **T03 — "Time labels 10–11, right aligned 6–8 from grid, aligned with their actual hour tick"**.
**Code change**, one file, 3 edits + 1 comment. 1 build, 2 relaunch+capture circuits (light, then dark),
~16 Bash calls ≈ 12 min.

Change — `apps/calendar/qml/CalendarScheduleView.qml`, the gutter `Label` now at **lines 367-383** (was 367-377):
- `font.pixelSize: 9` → **`11`** (top of T03's 10–11 range; chosen over 10 because the ref's digit cap is 9 ref-px
  and our hour pitch is 40 vs the ref's 27, so we are already *under*-scaled — 11 is the closest the contract allows).
- `anchors.horizontalCenter: parent.horizontalCenter` → **`anchors.right: parent.right` + `anchors.rightMargin: 7`**.
  The gutter cell's `parent.right` **IS** the gutter/day boundary, i.e. exactly where the grid's left edge line is
  drawn — so `rightMargin: 7` puts the text box 7px off the grid line. (The day columns draw their own left edge
  at that same x, so no separate line has to be added.)
- `anchors.topMargin: -7` → **`anchors.topMargin: -Math.round(implicitHeight / 2)`**. This font's line box is
  **~1.47em**, so a hardcoded -7 only centres font 9; deriving it from `implicitHeight` keeps the digit band's
  centre on the tick at any size and cannot loop with `topMargin` (implicitHeight is text-derived).
- **Still anchored** (top + right) ⇒ it cannot contribute to the cell's implicit height, so the 40px row pitch
  is structurally safe. `text:` and `visible: hourCell.columnIndex === 0` are byte-identical.

**Measured PASS.** Light, grip x 3..49: label ink bands **241..249 / 281..289 / 321..329** (h **9**, was 7) at
x **18..44**; band **centres 245.0 / 285.0 / 325.0** — *exactly* on the hour lines 245/285/325, pitch **40**
(T01 unregressed). Ink right edge 44 vs the grid line at x=52 ⇒ **gap 8** (box gap 7) — contract 6–8.
Dark: gutter (30,30,30), identical geometry (241..249 / 281..289 / 321..329, centres 245/285/325, x 17..44, gap 8)
⇒ **no dark regression**. Crops `r066-gutter-light-5x.png` / `r066-gutter-dark-5x.png` / `r066-ref-gutter-5x.png`
(side-by-side `_r066-cmp-5x.png` in tmp).

**Ref comparison (side-by-side read, 5x).** Ref right-aligned label, right edge 238, grid line 243 ⇒ **5 ref-px**
(≈6.8 scaled) — ours 8, inside the contract. Ref digit cap **9 ref-px** = ours **9** at font 11.
**Two ref features the contract does NOT ask for (recorded, not defects):**
(a) the ref splits the label into a **large dark hour number + a smaller, lighter, baseline-aligned `AM`/`PM`**
(ours is single-size); (b) the ref is **12-hour** (`8 AM`, `Noon`, `1 PM`) — **ours stays 24-hour `07:00`**.
No spec ID covers either → **needs ruling F** if we want them.

## 仍差 (top 8, visual-impact order)
1. **All-day band bottom separator weight.** Ours is 1px (223,225,228) = `AppTheme.border`
   (`CalendarScheduleView.qml:308-312`); the ref's is **2px (217,217,217)** at y=183-184 — a deliberate
   strength hierarchy above the grid. Ref-anchored, unblocked, one file. **This is Next round #1.**
2. **Ref gutter labels are 12-hour and two-tone (hour + lighter `AM`/`PM`)** — see above. **Needs ruling F**
   (no spec ID). If ruled "match the ref", it is a `text:` rewrite + a second `Label` in the same delegate.
3. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain
   un-animated `Rectangle`. **R058 re-confirmed both directions**. App-wide. **Needs ruling A.**
4. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
5. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**). **Needs ruling C.**
6. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block, while the ref's
   week view shows **proportional 30-min vs 60-min chips** ⇒ **ruling E**. Clauses 1+2 PASS (R048).
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the
   `calendar.ics:91` VTODO (due 11:00) is dropped silently. **Needs ruling D.** Same family: the month day cell
   holds 1 chip + `N` where the ref stacks 3 (`CalendarMonthView` cap is 1).
8. **Two neutral-button idioms diverge, and one has no ref** (R061): `secondary` hover = neutral grey 79, no
   edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. Ref has no text button and no hover frame
   ⇒ **note**.
- *Cosmetic, no ID, folded out:* light `buttonNeutral` base reads ≈(251,252,254) vs the rendered card
  (247,247,247) (R056). D02's radius is **16** vs the spec's 24/32 — **keep 16**. Hover is a flat fill, no
  `borderHover` edge (R057/R060). The topmost visible gutter label is **half-clipped by the grid viewport**
  when a scroll offset lands an hour line exactly on the viewport top (R066; pre-existing, a scroll artifact,
  not a form defect).

## 最近已改 (most recent 8)
1. R066 — **T03 PASS**: gutter label font 9→**11**, `anchors.right` + `rightMargin: 7` (gap 16 → **8**),
   `topMargin: -Math.round(implicitHeight/2)`. Centres 245.0/285.0/325.0 exact, pitch 40. Light **and** dark.
2. R065 — **T02 PASS**: `gridLine`/`gridLineMinor` tokens; per-cell border box → four single-edge 1px
   Rectangles. Hour 1px (237,237,237), half 1px (244,244,244), separators 1px. Light **and** dark measured.
3. R064 — **T01 FIXED**: `hourHeight: 40` single constant; scroll offset + cell height + chip height derive
   from it. Measured 10× 40.0.
4. R063 — measurement only; ref re-read as a **week** view; T01 measured FAIL (54 vs ≈40).
5. R062 — popover title leading 22→20px (`FixedHeight` + `lineHeight: 20`); 仍差 (old #6) CLOSED.
6. R061 — measurement only; **D08 toolbar flat `KosButton` PASSES**.
7. R060 — measurement only; **D08 task-editor footer dark leg PASSES**; popover 编辑 y for todos = 375.
8. R059 — analysis only; popover-Esc re-ruled **not a spec failure** ⇒ **ruling C**.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **THE GUTTER LABEL IS NOW RIGHT-ANCHORED AND SIZE-DERIVED (R066).** `CalendarScheduleView.qml:373-383`.
  Its vertical centring comes from `-Math.round(implicitHeight/2)`, **not** from a tuned constant — if you
  change the font size again, do **not** reintroduce a hardcoded `topMargin`. It is anchored on **top + right**;
  unanchoring it vertically would let it inflate the 40px row height and break the whole pitch.
  `parent.right` of the gutter cell **is** the grid's left edge line (the day columns draw their own left edge
  at that same x) ⇒ `rightMargin` is measured against the grid line, not against the gutter's own rim.
- **THE GRID'S LINE TOKENS ARE LOCAL (R065).** `CalendarScheduleView.qml:51-58` owns `gridLine` /
  `gridLineMinor`. **`AppTheme.border` is NOT the grid line any more** — anything that reinstates
  `AppTheme.border` on a grid boundary brings back the blue-tinted (223,225,228) and the wrong weight. The
  all-day band separator (`:308-312`) deliberately still uses `AppTheme.border` — and 仍差 #1 is exactly that
  it should become a **local 2px (217,217,217)**.
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left
  and a right edge: adjacent edges land on the same pixel row/column and render as 2px. The right rim is drawn
  only by `columnIndex === root.dayCount`.
- **Our schedule grid field is pure WHITE (255,255,255)**, not the app's 247 card fill and not the ref's 249.
  Every grid-line contrast judgement must use 255 as the base. (R065)
- **The window's leftmost column x=0 is a 1px rim (224,224,224) light / (53,53,53) dark** — a gutter scan must
  start at **x ≥ 3** or that column merges every text band into one. (R066, cost me one wasted measurement.)
- **HARNESS COMMAND FORM IS FLAT (R064, hard-won).** `harness/Main.qml` matches `command.action` only
  (`:122 captureClient{path}`, `:204 escape`, `:208 resize{width,height}`, `:217 sidebar{expanded}`,
  `:221 view{view}`, `:225 date{date}`, `:230 openItem{kind,titleContains}`); a command with no `action`
  **silently hits the `:249` fallback** (`[UIReview] manual undefined …`) and does nothing.
  `review-command.py` does **not** flatten — write `{"action": k, **v, "sequence": prev+1}` **in place**
  (truncate+write, never `os.replace`) yourself. `captureClient` writes a **relative** path against the **app's
  CWD** — read it from `/proc/<pid>/cwd`, it follows *the directory you launched from* (R065: launching from the
  repo root put `_r065-grid-light.png` in the repo root, not the task dir). Confirmed success line:
  `qml: [UIReview] native app client capture <name> true`. **R066: launching from the task dir puts the capture
  in the task dir — do it that way.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used for the scroll offset
  (`:124`) and the cell height (`:365` after R066); chip height = `Math.round(root.hourHeight * 21 / 54)` =
  **16**. Anything that hardcodes 40 or 16 again will drift. The half-hour line is
  `Math.round(parent.height / 2)` = 20.
- **REF FACT SHEET (R063).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, Sun 29–Sat 4)
  + 243px sidebar + mini calendar. Main region: day headers → **all-day band** (3 rows) → hour grid 8 AM–8 PM.
  **Gutter hour labels 193/220/247/274/301/328 = pitch 27**; the red `9:41` pill **replaces** the 10 AM label.
  **Now-line y=238** = 9 AM line (220) + 0.683×27 ✓ (proportional, not snapped). **All-day band bottom separator =
  2px (217,217,217) at y=183-184** (stronger than the 1px hour lines, ≈237). **7 equal day columns, 1px separators
  at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots **12px** ⇒ **1:1**.
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** for us (contract says 40 — 40 was chosen).
  **R065 addition:** the ref's **hour lines and vertical separators are both 1px (237,237,237)**; its half-hour
  lines are **not measurable**. **R066 addition (gutter label, ref x 215..238, y 189..197):** the digit is
  **(89,89,89)** with a **9 ref-px cap band centred exactly on the hour line**; the `AM`/`PM` suffix is
  **(176..193) light grey, 12 ref-px wide, flush right**, i.e. the label is right-aligned on the **suffix's**
  right edge; right ink edge 238 vs the grid line 243 ⇒ **5 ref-px** gap. `Noon` has no suffix and is 24 ref-px wide.
- **REF EVENT CHIPS (R063, this is E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text
  + a 2–3px solid same-hue LEFT STRIPE** + small radius (≈3). Confirmed on `Portfolio…`/`Leadersh…`/`Presenta…`
  (red family), `Choir…` (olive/yellow), `Morning…` (blue), `Palm Sun…` (pink/magenta stripe). **This contradicts our
  dark theme's solid-saturated-fill + white-text** ⇒ the E family's first question is whether our dark translation is
  legitimate. Not yet judged. *(Our timed chip is `radius: 5`, a 1px border, no left stripe.)*
- **THE REF HAS NO POPOVER, NO MENU, NO TOOLTIP, NO HOVER FRAME.** The 弹框/浮层 section (`D`/`O`) is therefore
  HIG+token-anchored only, never pixel-anchored. Unchanged from R061/R062.
- **`lineHeight`: Qt's `ProportionalHeight` is a multiple of the *font's own* line box, not of `pixelSize` (R062).**
  With the app's CJK-capable stack that box is **1.47em** (22px at 15px), so `lineHeight: 1.2` *loosens*. To hit a
  **pixel** target use `lineHeightMode: Text.FixedHeight` + `lineHeight: <px>`. Measured valid pair:
  **FixedHeight 20 at font 15** in `EventDetailsPopover.qml:115-118`. **R066 corollary:** the same 1.47em box is
  why a size-tuned `topMargin` is unsafe — use `implicitHeight`.
- **`pointer{target:"<label>"}` is a free geometry + live-state probe for `KosButton`s (R061)** — matches
  `item.text === label`, so it needs the **rendered/translated** label (`"添加"`; a miss logs `NaN NaN` and the capture
  is a silent no-op). Log carries the resolved centre **and** `hover`/`down`. Needs the item `visible` (drive to
  **monthPage** for 添加). `scrollInfo` cannot see buttons; this can.
- **`flat:` and `secondary:` are different branch groups in `KosButton.qml:53-65`.** `flat` rest = `"transparent"`,
  hover/press = `buttonHover`/`buttonPressed` (accent tint) **and it gains a 1px `border` rim** (`:69`, `:80`; inner
  highlight = `!flat || hovered`). `secondary` = `buttonNeutral*` (neutral grey), never gets an edge.
  `AppTheme.qml:97-99` owns all three tokens.
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green planning"
  ⇒ **(673,375)**. Card height is content-driven, so a *reused* y is a **silent no-op**. Read 编辑's centre off a frame
  first. **R062 caveat:** the popover y also differs 11px **between binaries** ⇒ never diff a y against another binary.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. `pointerObject` needs THREE
  commands.
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING**, drawn 1px inside the
  perimeter, exact `(43,115,160)`/`(45,115,159)` = `accent`@0.76 dark. `pressScale` 0.968 is ≤1px at height 31 —
  **never read "no animation" from a 31px band.**
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204) /
  `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69)/(79,79,79)/(89,89,89); destructive
  **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge token.
  **Dark card fill = (31,36,43)**; **popover** dark = **(38,38,38)**; window = (30,30,30); flat-button hover/press =
  **(35,60,81)/(36,67,92)**; `border` dark rim ≈**(71,78,87)**. `windowRaised` is **not** a neutral grey.
  **R066: the gutter's own dark field = (30,30,30)** and its leftmost rim = (53,53,53).
- **Esc semantics (R059): `escape` is a key event addressed to whoever holds `activeFocusItem`.** It closes a
  **focused** popup and does **nothing** to a `modal:false` popup that never takes focus. Ask *who has focus* first.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** P01's popover is a
  **浮层** (`spec.md:120` O08). A requirement written in a `D` row does **not** automatically bind the popover.
- **Dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**,
  x 384..730, centre x ≈ 557, pitch 37, gap 6 (light ≤1px the same). The **task** editor is the same shape **32px
  higher** (516/553/590) — always say *which* editor a footer number belongs to.
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056). Keep `interval ≤ duration/4`; frames land
  at 0, interval, 2·interval…; the recorder is non-blocking so keep `duration` under the 0.6s command spacing.
- **Diff bounding boxes FIRST, sample pixels second** (R058): `ImageChops.difference(...).getbbox()` separates
  "nothing happened" (`None`) from "a view switch" (≈whole window) at no cost. **R061 caveat:** a *neighbouring*
  widget's hover state can inflate the bbox.
- **Row-band measurement idiom that has now worked six times (R046/R062/R063/R064/R065/R066):** scan the target
  column (or row) for pixels that are **not** the background, threshold, group into bands, read the band **centre**
  (text rows) or **start** (cap-tops). R065 used both directions: column x=1000 for the horizontal lines, row y=430
  for the vertical separators. R066 used column-scan over x 3..49 for the gutter labels. **R065 refinement:** a
  **row/column mean over a wide span** (x 62..1030) is the cheapest way to find the horizontal lines when chips make
  single-column probing noisy. **Caveat (R064):** keep the scan window strictly inside the intended region.
  **Caveat (R065):** the all-day band separator and the first hour line can be **adjacent rows** (204/205) — don't
  read them as one 2px line. **Caveat (R066):** the window's x=0 rim column will merge every band; start at x ≥ 3.
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open; press a button and the ring appears
  1–2px inset and **persists after release-outside**. On hover the ring is **covered by the hover fill**.
- **The reference macOS alert at rest shows NO focus ring** ⇒ "no ring at open" is the target, not a bug.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159)/(43,115,160).**
  `accent`(48,140,198) / `accentHover`(69,152,204) / `accentPressed`(85,161,208) are **identical in both themes**.
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse as
  JSON, filter `parent` + `visible:true`, and **take the last matching line**. It lists **Flickables/ScrollViews only
  — not `KosButton`s**.
- **The 4-step open chain and the 3-step click CAN go in ONE list**; the recording may be the **first** item.
  **`press` → `move` off the button → `release` outside** captures *pressed* without firing the click.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`). A rebuilt binary requires
  a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~12–14s before the new pid appears.
  Include `resize 1100x692` in the drive list. **The app's CWD follows YOUR launch CWD** — launch from the task dir
  (R065/R066) so the capture lands in the task dir. **R066: it also starts in `--view week --date 2026-10-15`**,
  so every drive list must re-send `view week` + `date 2026-04-02`.
- **Fixtures on 2026-04-02** (live file = `profile/pim/calendar.ics`; the repo-root *`calendar-fixture.ics` is a stale
  copy with no VTODOs*): VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title** 11:00 / **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`**
  all-day strip spanning 3 days. VTODOs (kind `"todo"`): `[UI] Green planning` (09:00), `[UI] Gold review` (12:00),
  `[UI] Red review` (16:00), `A deliberately long task title to inspect elision` (11:00), **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (11:00 — a *repeated* long string; **the record for any wrapping-title test**).
  **R065:** the week is **Mon 30 – Sun 5** (locale weeks start Monday, 7 columns, `dayColumnWidth` ≈ 149.7 at
  1100x692), and `date 2026-04-02` + `view week` puts **07:00 at the top of the viewport** (`contentY` = 280).
  **R066:** at that offset the very first visible hour line lands **on** the grid viewport's top edge, so its
  label is half-clipped — read the three *clean* bands (245/285/325) for any pitch claim.
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its **border**
  only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark; event-editor card at
  x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
  **R066: our text renders with subpixel (RGB) antialiasing** — single-pixel probes of glyph cores come back
  colour-fringed (e.g. (133,142,196) light / (141,142,118) dark). **Never read a text colour from one pixel**;
  use a band's dominant/median over many pixels, or just don't claim a text colour you didn't aggregate.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in and
  **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — all-day band bottom separator: 1px → 2px (217,217,217).** `apps/calendar/qml/CalendarScheduleView.qml:308-312`
(the `Rectangle` under the all-day band that currently uses `AppTheme.border`). Target: **height 2**, colour a
**local token** `allDaySeparator` = light **`#D9D9D9` (217,217,217)** / dark — **measure the dark leg first**
(do NOT reuse `AppTheme.border`, which is app-wide and blue-tinted; R065 set the precedent of a *local* grid
token precisely because `border` is shared with cards/fields/buttons). Keep the all-day band's own `min 28 /
row 18 / gap 2` intact. **Read the ref crop first** (`.loop/refs/macos-calendar.png`, x 250..420, y 176..192) to
confirm the 2px band and that it spans the *whole* main region (my R066 scan found it spanning x 192..251, i.e.
**including the gutter** — verify whether it should stop at the gutter or run under it).
Then verify: the separator is **2 rows** of (217,217,217) and the **first hour line below it stays 1px** (R065's
caveat: they can be adjacent rows — do not read them as one band).

**Then (unlocked, ref-anchored, never reviewed — one per round):** A01 (all-day band: min 28, row 18, gap 2,
inset 2–3 — ref rows ≈15 ref-px ⇒ ≈20 scaled), **E01/E02** (chip language — the biggest unexamined mass; the ref's
light-fill + dark-same-hue-text + 2–3px left stripe + radius 3 vs our `radius: 5` 1px-border fill),
N02 (now-line + red badge — needs a capture of the **current** week), V01–V05 (month — **no ref anchor**, use
`spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten the
nested form into `{"action": …}` so every later round stops paying the R064 diagnosis cost.

**Still blocked on rulings A–F** (unchanged, plus the new F; D/O family + the ref label form): dim snap, shadow
magnitude, popover Esc, `slice(0,2)` / month 1-chip cap, E03 clause 3, **F = 12-hour two-tone gutter labels**.
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 are PASS-pending-final-regression; everything else is
PENDING or ruling-blocked.)
