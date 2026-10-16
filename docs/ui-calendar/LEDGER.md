## R101 — C05's segment pill **radius**, measured: `LiquidSegmentedControl.qml:121` `height * 0.42` → `height * 0.48`
The R100 Next #1 asked for the pill's radius as a per-row fill-start inset fit. Two of its premises were wrong and were
corrected first: the **reference's pill is h = 24, not ~17** (ours is also 24 ⇒ the comparison is 1:1, not a ratio transfer),
and ours measures 64 wide on the dark leg but 62 on the light one (the 2 px is the lens's own 1px `white@16%` border at
`:123-124`, bright on the dark plane and invisible on the light one).
**The method is validated by recovering our own token.** Same fit, same interior rows, threshold = the midpoint of each
image's own two constants: `0.42`→10.1 (token 10.08), `0.46`→11.2 (11.04), `0.48`→11.4 (11.52), **reference → 11.7**
(sse 4.51 vs our 19.51; 13/14 rows within ±0.5). A per-row probe threshold gives the ref 11.1 instead, so the honest answer
is the band **11.4–11.7** (ratio 0.475–0.49) — our old 0.42 sat outside it, 0.48 sits inside.
**The residual top-row misfit is material, not radius**: the lens gradient opens at `white@9%` and the 1px `white@16%` border
lift the top rows above the threshold. Figures: `r101-seg-radius-3panel.png` (ref ×5 / 0.46 ×5 / 0.48 ×5), `r101-seg-light.png`.
**Not chased:** the track's radius (`:87`, 0.38) — the ref's track edge is 249 on a 255 plane, unmeasurable; the concentric
hypothesis would want the same 0.48 there.
**Still差 #3 (new, next round):** the pill's WIDTH — ref 51 in a 56.75 slot (2.9 px/side), ours 64 in a 65.33 slot (1.2 px/side).
# R100 — C05/L03's segment **label order**: the reference ascends `Day · Week · Month · Year`; ours was the exact reverse. **Fixed (a remap, not a token).**

**Why this round.** Next #1 was C05's label *list* — the reading round R099 prescribed: grep `viewIndex` + `labels` consumers,
decide whether our list is reversed vs L03's "Day/week/month" and the ref, then make one atomic edit.

**What the reading found (crop ×5 of the ref toolbar strip `x385..625 y12..40`).** The reference reads **`Day · Week · Month ·
Year`** — granularity **ascending**, pill on `Week` — and L03's own wording is "**Day**/week/**month** segment". Ours was
`labels: [qsTr("Month"), qsTr("Week"), qsTr("Day")]` (`Main.qml:1713`): the **exact reverse** of both.

**The contract that forbids "just flip the array".** `root.viewIndex` publishes `0=month / 1=week / 2=day` with **five**
consumers, none of which may move: `activeView` (`:229`), `Ctrl+1..3` (`:1544-1546`), `--view` → `requestedViewIndex` (`:1054`),
the `KosPageCache` page order (`:2372`), and the review harness (`harness/Main.qml:218` =
`["month","week","day"].indexOf(command.view)`). ⇒ the segment must **mirror** the contract, never redefine it.

**Change — 3 lines in one component, nothing else.** `Main.qml:1713-1728`: `labels` → `[Day, Week, Month]`;
`currentIndex: root.viewIndex` → `2 - root.viewIndex`; `onSelectionRequested: index => root.viewIndex = index` → `2 - index`.
Week still lands on segment **1** ⇒ the pill's measured geometry (R097/R098) is untouched *by construction*.

**Acceptance (light, `contentY 280` — the same leg as R098/R099, so all three are comparable).** Three drives over the **same
live instance**, no relaunch: `view=week` ⇒ pill on the **2nd** segment (`周`); `view=day` ⇒ **1st** (`日`); `view=month` ⇒
**3rd** (`月`) ⇒ **the remap is bidirectional, not cosmetic.** Figures: `docs/ui-calendar/r100-seg-order.png` (ref ×4 over
ours ×4, same 1:1 scale) and `r100-seg-remap.png` (the three drives). **C05's label-order clause now holds in the light leg;
dark is extrapolation (a label remap carries no colour).**

**Deliberately not chased:** the ref's **4th** segment (`Year`) — no such view exists in this app and L03 specifies three.

## ## 本轮 (R100)
Atomic step: **read the label-list contract, then apply the one remap it justified.** The implementer step was done inline (3
lines in one component; `code-writer` is still not registered in this session — R099 precedent). Build clean, one launch, three
captures on that one instance, 2 image reads. Files touched: `Main.qml:1713-1728`, the docs mirror, `LEDGER.md` (+ this state
file and `rounds.md`, which cannot be committed). **Verdict: our three labels now read in the reference's granularity order,
the pill still marks Week, and the `viewIndex` contract is provably intact in both directions.**

## 仍差 (top 8, visual-impact order)
1. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies exactly three
   ("Day/week/month"), so **three is spec-correct**; our three now read in the ref's order (`Day · Week · Month`, R100). Adding a
   year view is not an atomic step ⇒ **this is a question, not work.** `Day/Week/Month/Year` ref word centres are **418/474/530/587,
   pitch 56**; ours (3) are **594/660/724, pitch 64**. **Blocked on a ruling.**
2. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole
   6, inset 3 from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px
   right of the ring's outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the
   thin-stroke family** (stroke ~1.5, hole ~9) on the neutral-248 chips. **Do NOT build either until H is answered.**
3. **The segment pill's RADIUS is unmeasured 1:1.** Ours `height * 0.42` ≈ 10; at ref scale (pill h ≈ 17) a near-full-round pill
   is indistinguishable from 0.42·h by eye ⇒ **measure the per-row fill-start inset at the BODY mode** (still 仍差 #3 from R098).
   `r098-seg-dark.png` has a 62x24 pill at 1:1, so it is cheap. **This is Next #2.**
4. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's**
   right edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`.
   App-wide. **Needs ruling A.**
6. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
7. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day
   before it can be reproduced at all.** **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell — no
   ref counter-example either). **The band's own cap is gone (R089); this is the last one.**
8. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides
   on **ruling G**. Do not chase without a ruling.
- **CLOSED in R100: C05/L03's label ORDER** — the segment now reads `Day · Week · Month` (`Main.qml:1713-1728`), matching the ref's
  granularity ascending and L03's wording; the `viewIndex` contract is preserved by mirroring (`2 - index`) and the pill still
  marks Week. **What remains of C05 is only the pointer half, which no harness action can drive.**
- **CLOSED in R099: C05's label-token residue** — the ref has a single black ink in both states; the muted token is gone
  (`mutedTextColor` → `labelPrimary`), the selected label unchanged. **C05's `inactive chrome` clause now holds in the light leg;
  its dark leg is extrapolated.**
- **CLOSED in R098: C05's dark leg** — the selection pill renders as a distinct step on the dark plane (60 vs track 43 vs plane 30).
- **CLOSED in R097: C05 clause 1's structural half** — one capsule renders, `GlassPill` is dead source, no conflicting fills.
- **CLOSED in R094: M04's size clause** — the mini today disc's **20 → 15 px**. **R093: M04's colour clause** — → `AppTheme.todayRed`.
- **CLOSED in R092: R091's fix holds in the DARK leg.** **CLOSED in R091: the initial-scroll nondeterminism (0 px).**
- **CLOSED in R089: A04 step 2 — the band's silent overflow. A04 fully PASS.**
- *Cosmetic / settled, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px
  edge. D02 radius **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands
  an hour line exactly on the viewport top (R066; scroll artifact). Band-chip fill alpha ref **0.16** vs ours **0.17** (R080) — not
  worth a round. **CLOSED R095: the mini month's weekday header does not tint today's column letter.** **MEASURED R096: S04 —
  clauses 1 and 3 hold; clause 2 is already `radius: 6` on `CategoryRow`; `SidebarRow`'s capsule is dead chrome.**

## ## 最近已改 (most recent 8)
0. R100 — **C05/L03's label ORDER**: `Main.qml:1713-1728` `labels:` `[Month, Week, Day]` → `[Day, Week, Month]` **+**
   `currentIndex: 2 - root.viewIndex` **+** `onSelectionRequested: ... 2 - index` (3 lines, one component). Ref reads
   `Day · Week · Month · Year` (×5 crop, own eyes); L03 says "Day/week/month". The `2 -` mirror keeps all five `viewIndex`
   consumers (:229 / :1544-1546 / :1054 / :2372 / harness:218) untouched ⇒ **no behavioural change, order only.** Probed
   bidirectionally on one live instance: week→2nd, day→1st, month→3rd. Figures `r100-seg-order.png`, `r100-seg-remap.png`.
1. R099 — **C05's inactive label**: `Main.qml:1717-1722` `mutedTextColor: labelSecondary` → `labelPrimary` (**1 token**). Ref's
   four labels all peak `(0,0,0)` (top-5% 11–23); ours was 147–152 with `n<100 = 0`. After: 25/11 peaks, `n<100` 49/38;
   **selected `周` bit-identical**. Nothing else touched.
2. R098 — **verdict only, NO code changed**: C05's dark leg captured (`r098-seg-dark.png`). plane 30 / track **43** / pill **60**
   (pill−track +17; light was −17). Both dark tokens exact. Chrome geometry identical to the light leg. Capsule `y36..63`.
3. R097 — **C05 clause 1's chrome**: `Main.qml:94-103` `segmentTrack` (light #787880@2.5%→252 / dark white@6%) + `segmentPill`
   (**opaque** #E7E7E7=231 / dark #3C3C3C); `Main.qml:1715-1716` repointed. Step Δ20 = the ref's. Iteration 1 (17.5% veil) → 210.
4. R096 — **verdict only, NO code changed**: S04's "selected row gray radius 6" governs **`CategoryRow`**; first-ever
   expanded-sidebar capture `r096-sidebar.png`. Clause 3 holds (ours −9 vs −13).
5. R095 — **verdict only, NO code changed**: the mini month's weekday header does not tint the today column (7/7 letters R==G==B).
6. R094 — **M04 size**: `Main.qml:2199-2200` `width/height: 20` → `15`. Disc 15x15 vs the ref's 15x15; header disc 22x22.
7. R093 — **M04 colour**: `AppTheme.todayRed: "#E5484D"`; `CalendarScheduleView.qml:111`; `Main.qml:2204`.
   *(archived to rounds.md tail: R092's dark-leg verdict, R091 — `CalendarScheduleView.qml:276` `repositionTimeline()`; R090/R089.)*

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, new and load-bearing).** Peak ink **and** the `n<100` pixel
  count settle it in one pass: ref `Day/Week/Month/Year` = `(0,0,0)` with `n<100` 60/76/85/53; ours before = 147/152 with
  **`n<100` = 0**. ⇒ **`n<100` (or "count of pixels darker than the darkest plausible token") is the discriminator between an ink
  *token* difference and an AA-coverage difference** — peak alone can be fooled by subpixel fringes (our selected label peaks
  `(13,0,22)`, a subpixel signature, and is *correct*). **A semantic two-tone (`labelColor`/`secondaryLabel`) is a native-app
  idiom this reference does not share; do not infer a muted token from "it looks grey at 1:1".**
- **THE REF'S SEGMENT SET IS 4, OURS IS 3 — THE *COUNT* IS SPEC-BOUND, THE *ORDER* WAS A BUG (R099 → R100 FIXED).** Ref word
  centres **418/474/530/587, pitch 56**; ours **594/660/724, pitch 64** (= `(196−4)/3`). **R100: our list WAS the ref's first
  three in reverse; it now reads `Day · Week · Month`.** The missing 4th (`Year`) is **L03-sanctioned** ("Day/week/month") and
  needs a view that does not exist ⇒ a ruling, not a fix. **Check whether an order difference is a binding or the list itself.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100, load-bearing).** `viewIndex`
  (0=month/1=week/2=day) has five consumers spanning QML, shortcuts, the CLI and the *review harness*; flipping the label array
  alone would have silently inverted `--view`, `Ctrl+1..3`, the page cache and every harness `view` command. **`labels` ascending
  + `currentIndex: N-1-index` + `onSelectionRequested: i => viewIndex = N-1-i`** fixes the visible order with a **zero** change to
  the index semantics — the acceptance test is therefore "drive every index and check the pill", not a screenshot.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** `LiquidSegmentedControl.qml:94-99` gives the *track*
  a specular `Gradient` (white@4% → black@2%) and `:128-136` the *lens* a stronger one, while `:124` adds a 1px `border.color:
  white@16%`. Reading the top row yields **99** where the body is **60** (dark) — a phantom 39-level error. **Present on both legs
  and in both hosts ⇒ it is the shared control's material, never a C05 host divergence.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** `:105-114` paints `lensShadow`
  (black@**10%** light / **24%** dark) directly under the lens ⇒ a veil lands at **210**, not the 231 the over-white arithmetic
  predicts. ⇒ **read the composite, or use an OPAQUE fill when the target is absolute.** Reachable range under that shadow is
  **[120, 227]** on a white plane; an opaque fill (dark #3C3C3C) lands exactly on its token (R098).
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).** `LiquidSegmentedControl` has exactly **four**
  palette properties (`backgroundColor`, `selectionColor`, `textColor`, `mutedTextColor`; `:18-19` defaults `AppTheme.text`/
  `mutedText`) and **one** consumer each for the last two (`:188 selected ? textColor : mutedTextColor`). The calendar passes all
  four; the two settings instances (`KosSettingsDialog.qml:174`/`:212`) pass **none**. ⇒ **"matches actual settings" reduces to
  diffing the property list — and the *values* are judged against the reference, not against `AppTheme`.** R099 is the proof: the
  `AppTheme` values would have made a matching state wrong.
- **THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER (R096).** Ref plane **237**, selected row **226**
  (ΔL −11, r=6, h 28); ours plane **228** with `selectionFill` **215** (ΔL −13). Same token reads (207,51,35) on the sidebar vs
  (235,76,70) in the grid ⇒ **compare only ΔL against the layer's own plane.** **R097 bounds it: the toolbar row is NOT a vibrancy
  layer — both planes are white 255, so absolute Δ's DO transfer there. Check the plane before invoking the caveat.**
- **A RADIUS IS MEASURED AS THE PER-ROW FILL-START INSET, AND r=6 FITS 4,2,1,1,0 (R096).** A circle of radius r predicts
  `r − sqrt(r² − (r − (dy+0.5))²)`. **Do not eyeball a radius off an upscaled crop.** Pick rows by the **body** mode (R098).
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** The flat action set is
  `captureClient{path}` / `escape` / `resize{width,height}` / `sidebar{expanded}` / `view{view}` / `date{date}` / `position{contentY}` /
  `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` / `openItem{kind,titleContains}`. ⇒ **`hovered`/`pressed` chrome cannot be
  driven** — every clause phrased as "hover …"/"pressed …" is **static-only**. **A static screenshot can never settle an animation.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** The harness logs
  the **pre-command** timeline geometry (`harness/Main.qml:263`). R099's probe read **`contentY 280`, `contentHeight 960`** — the
  same value as R098's, so the two legs are comparable.
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088, re-used R091).**
  Threshold **>6 RGB-sum**, group differing rows into y-runs, read each run's x-range.
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33×
  the ref's but **our type is at the ref's own physical size**: gutter ink **9 = 9**, day-number ink **9 = 9**; **and the segment
  label's ink rows are y45..55 = 11 rows vs the ref's y19..29 = 11 rows (R099)** ⇒ the label comparison is 1:1, no scaling. Our
  header row is 36 tall vs the ref's ~28 — a *layout* difference, not a licence to inflate type.
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** All five ref colours 1:2 on every channel ⇒ any
  "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`. **Corollary: dark chip colours are extrapolation.**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R099).** Corner: per-row **fill-start inset** (body mode,
  R098). Joint: per-row **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**.
  Border: **monotonicity of a raw profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS
  the channel-gap argument**; for a cross-capture comparison the **top-5%-coverage mean**, and **R099 adds the `n<100` count as the
  token-vs-AA discriminator**. Mark/token: **a strict per-channel match to the token over a bbox, with a control region of the same
  token elsewhere in the same capture**. Ordering/content: a per-column deviation-from-fill ASCII ramp.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat
  filename**; read the success flag in `live-runtime-vm.log`, then `ls` the actual CWD.
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. **The R097–R099 working leg (ONE Bash call): kill `live-app.pid` → `nohup
  ./start-review-vm.sh light|dark &` → `sleep 32–34` → `review-command.py` with `resize`/`sidebar`/`view`/`date`/`captureClient`/
  `stop` → grep `capture <name>.png true` + the `manual stop contentY` probe.** `leg.sh` has NO `sidebar` action and dates to
  `2026-04-02`.
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R099):** x=0 rim; gutter x 1..51; separators at **x=52/202/352/502/652/802 in BOTH
  the band and the grid**, **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's
  segment track spans x≈562..757 (w 196) centred on the main region; the lens x629..690 (w 62) on segment 2 = Week; our segment
  label centres are x≈594 / 660 / 724; the capsule is y36..63 (28 tall, 1px `AppTheme.border` hairline top and bottom), the lens
  y38..61 (24); the two right round glass buttons are x1023..1048 / x1059..1084.** **Fixture day: Thu Apr 2 = 4 all-day items ⇒ 3
  chips; Fri Apr 3 = 1. The launch week (Oct 12–18) carries NOTHING, so `date 2026-10-15` is the cheapest way to get a month that
  CONTAINS today.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R099.** `sectionRule` **y=155** (242 light / 39
  dark, 1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips
  **157-180**, gap **181**, **182-205**, gap 206, **207-230**.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch
  19**; top rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217), row-mean **217.0 constant over x250..810**; **inset
  ≈1 both legs**; content **125..182 = 58**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon
  12x12, stroke 3, hole 6, 3 px inside the fill edge**. **R087: the band never expands.** Ours: row 24 / gap 1 / inset 1 / radius 8
  / band 76 / hue ink — every *form* item matched **except the icon (仍差 #2)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light
  desaturated same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round
  caps**; **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark
  white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24),
  `sectionRule` (light `#F2F2F2` / dark white@0.04). **`AppTheme.border` has ZERO consumers in that view** (but the *shared*
  segmented control draws its own hairline with it — R097). Requirement is the ORDERING: ref 242 < 237 < 217; ours light
  242 < 237 < 217, dark 39 < 59 < 84. **`gridLine` is consumed by THREE things — the grid's top/left/right edges AND the band's
  column separators.**
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark;
  the gutter is NOT tinted.** **Sidebar plane light = (228,228,228); the mini month's weekend cells are tinted (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan
  must start at x ≥ 3** — and **a band scan finds the label's *ink rows*, never its *text*. Compare the digits, not the bands.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = **16**. Half-hour line = **20**.
  **R072 added the four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080
  `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093
  `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`; R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill` +
  the segment's repoint at `Main.qml:1715-1716`; R099 the segment's `mutedTextColor` at `Main.qml:1718`.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed
  Apr 1**) + 243px sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM.
  Gutter labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238, pill/line
  red **(235,76,70)**. **7 equal day columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.**
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). **Columns: Sun 29 · Mon
  30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.** **R097/R098 add the toolbar row: y4..36 in the ref, holding (left→right) the
  traffic dots, a 2-icon capsule at x≈122..190, a round `+` at x≈205..230, the Day/Week/Month/Year capsule at x≈389..615 (track
  249..253, selected pill 230..235, word centres 418/474/530/587), and two round glass buttons (radar, search) at x≈735..810.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R099).** `harness/Main.qml` matches `command.action` only; a command
  with no `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence`
  itself, writes **in place** (never `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:**
  `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` — background it; a rebuilt binary needs a **kill+relaunch** (~24 s to
  the new pid). Include `resize 1100x692`; the app starts in `--view week --date 2026-10-15` **with the sidebar COLLAPSED**. **The
  theme is fixed at launch — a dark leg costs a full kill+relaunch. App stderr goes to `live-runtime-vm.log`.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root
  `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 …
  2026-04-06** plus a **`Multi-day review`** all-day strip **`20260330` → `20260403`** (Mon/Tue/Wed render as ONE chip each;
  Thursday does NOT carry it). **R087 ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒
  **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** UID-ordered since R083 ⇒ **Thu's order is `Design sync` / `Release notes` /
  `R087 card C` / (`R087 card D`, hidden)**. VTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review`
  16:00, `A deliberately long task title to inspect elision` 11:00, `[R019 LONG TASK] …`. **The rendered week also shows
  `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist`.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script. **A composite (a
  1:1 strip above a 2–4× zoom) answers "overall form + local detail" in ONE image read**, and **labelling the rows
  (`ImageDraw.text`) is what makes it self-describing.** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the
  point is pixel structure.** **R080: a `Counter` mode over a cell gives the fill in one call (R098: use it for a segment fill —
  over the *body* rows).** **R097: a black-bar two-panel `old-above / new-below` ×3 `NEAREST` stack of the *same* region is the
  whole before/after verdict in one read; R099: a **three**-panel `ref / before / after` stack settles a token change *and* its
  reference in one read.** **No `numpy` in this interpreter.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## ## Next round (pick ONLY #1)
**#1 — the segment pill's RADIUS, measured as the per-row fill-start inset at the BODY mode (仍差 #2).** Still open since R098.
Ours is `height * 0.42` ≈ 10; at ref scale (pill h ≈ 17) a near-full-round pill is indistinguishable from 0.42·h by eye, so the
number has to be **measured, not eyeballed**: take the **body rows** of the pill in `r098-seg-dark.png` (62x24 at 1:1) and fit
`r − sqrt(r² − (r − (dy+0.5))²)` to the per-row fill-start inset (the R096 method). The ref's pill is ~17 tall in a 28-tall track
⇒ **its radius/height ratio is the transferable quantity**, not its pixels. **A token edit once measured — the same shape of step
as R097/R099.** If the fit is ambiguous (`r = 6` vs `r = 8`) prefer the token already in `tahoe` over a new number.

**Then:** #2 the ruling-blocked list in 仍差 order — the **Year segment (new, needs a view)**, the band ring icon (H), the 12-hour
two-tone gutter labels (F), the dim snap (A), the shadow magnitude (B), the month `slice(0,2)` (D), the band chips' inset (G).

**Blocked on rulings A–H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3
(C/E; clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2,
inset 2–3) vs the ref's measured 1**, **and now a 4th `Year` segment**. **No rulings channel exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round) — R097 used `general-purpose` as the stand-in
implementer; R098 needed none; R099's 1-token and R100's 3-line edits were done inline.**
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04** fully PASS;
**E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**; **M04 closed
R093 + R094**; **M03/M02/M01/S02/S03/S05/L01–L07/C01–C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**;
**C05: clause 1's structural half CLOSED R097, dark leg CLOSED R098, label-token residue CLOSED R099, label ORDER CLOSED R100 —
what remains of C05 is the pointer half, which no harness action can drive.**)
