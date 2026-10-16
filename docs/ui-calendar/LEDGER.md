## R100 — C05/L03's segment LABEL ORDER: the reference ascends `Day · Week · Month · Year`; ours was the exact reverse
**Verdict + fix.** R099 measured the ref's four word centres (418/474/530/587) but left the list alone; this round re-cropped the
toolbar strip at ×5 and read the words themselves: the reference's segmented control reads **`Day · Week · Month · Year`** —
granularity **ascending**, left to right, pill on `Week` — and L03 words it "**Day**/week/**month** segment". Ours was
`labels: [Month, Week, Day]` (`Main.qml:1713`), the **exact reverse** of both.

**Why it is a remap and not a token edit.** `root.viewIndex` publishes `0=month / 1=week / 2=day` and that contract has **five**
consumers that must not move: `activeView` (`:229`), `Ctrl+1..3` (`:1544-1546`), `--view ` via `requestedViewIndex` (`:1054`),
the `KosPageCache` page order (`:2372`), and the review harness (`harness/Main.qml:218`,
`['month','week','day'].indexOf(command.view)`). So the segment **mirrors** the contract instead of redefining it:
`labels: [Day, Week, Month]`, `currentIndex: 2 - root.viewIndex`, `onSelectionRequested: index => root.viewIndex = 2 - index`
(`Main.qml:1713-1728`). Week still lands on segment **1**, so the pill's measured geometry (R097/R098) is untouched.

**Acceptance (light, 1100x692, `contentY 280` — the same leg as R098/R099, so the three are comparable).** Three drives over the
**same live instance**, no rebuild: `view=week` ⇒ pill on the **2nd** segment (`周`); `view=day` ⇒ **1st** (`日`);
`view=month` ⇒ **3rd** (`月`). The remap is proven **bidirectional**, not merely cosmetic. Figures:
`docs/ui-calendar/r100-seg-order.png` (ref ×4 over ours ×4, same 1:1 scale) and `r100-seg-remap.png` (the three drives).

**Left alone deliberately.** The ref's **4th** segment (`Year`) has no counterpart view in this app; L03 specifies three
("Day/week/month"), so three is spec-correct and adding a year view is not an atomic step. Recorded as an open question, not
chased. Dark leg is extrapolation — the change is a label-order remap with no colour content.

## R099 — C05's *inactive* label: the reference has NO muted segment label; ours was 130 levels too light
**Verdict + fix (verdict-driven, not pixel-fishing).** The ref's toolbar capsule (`x385..620 y0..40`) cropped at ×4 and ×8 and
probed word by word: **all four** reference labels — `Day` (unselected), `Week` (on the pill), `Month`, `Year` — carry the **same
pure-black ink** (peak `(0,0,0)`; top-5% mean **23 / 11 / 15 / 20**; `n<100` = 60 / 76 / 85 / 53). The pill alone marks the
selection — there is no two-tone. Ours read `labelSecondary` = `#3C3C43@60%` ⇒ peak **(147,145,150)**, top-5% **152**,
**`n<100` = 0**, a **~130-level** gap that is plainly visible at ×4.

**Change — 1 token, nothing else.** `apps/calendar/qml/Main.qml:1717-1722`: `mutedTextColor: root.tahoe.labelSecondary` →
`root.tahoe.labelPrimary`. After (`r099-seg-light.png`, light, `contentY 280`): unselected `月` peak **25** / top-5% **34** /
`n<100` **49**; `日` peak **11** / **25** / **38**; selected `周` **unchanged** (`(13,0,22)`, `21,12,28`, `100`) ⇒ no regression
on the state that already matched. One ×4 stack carries the whole verdict (`docs/ui-calendar/r099-seglabel.png`: ref / before /
after). Dark leg is extrapolated, not claimed: `labelPrimary` dark = `#F2F2F2`, so the dark muted ink collapses to the same
single white tone.

**Also recorded — NOT chased (needs a ruling).** The reference's segment set is **`Day · Week · Month · Year`** (4 segments,
label centres x≈418 / 474 / 530 / 587, pitch ≈56), while ours is **`Month / Week / Day`** (3, centres 594 / 660 / 724, pitch 64)
— the **reverse** of both the reference's granularity order and L03's own wording, "Day/week/month segment". Reordering the
label list would remap `viewIndex`, so it is not an atomic token edit.

# R098 — C05's **dark leg**, captured and **PASSED**: the segment's extrapolated dark tokens render at exactly their values. **No code changed.**

**Why this round.** R097 fixed the light leg's capsule with an **opaque** pill; the dark values (`segmentTrack` white@6%, `segmentPill`
`#3C3C3C`) were **extrapolation — no dark reference exists** — and the *old* dark pill was `contentPlane` = `#1E1E1E` = **the dark canvas
itself**, i.e. the same vanished-selection defect. One dark leg, one pass, no iteration: `kill` → `start-review-vm.sh dark` →
`resize 1100x692` → `sidebar{expanded:true}` → `view week` → `date 2026-10-15` → `captureClient r098-seg-dark.png` (**flag `true`**) →
`stop`; probe `contentY 280`. Figure (light-after 1:1 / dark 1:1 / dark ×3 `NEAREST`, one crop): `docs/ui-calendar/r098-seg-dark.png`.

**Measured — capsule x562..757 (196), lens x629..690 (62); the SAME x in both legs (the pill is on segment 2 = Week).** Fill = the
**mode over the body rows y45..61**, never the top row (see the new instrument in 外推).

| leg | plane | track | pill | pill−track | the two right round buttons (x1023..1048 / x1059..1084) |
|---|---|---|---|---|---|
| light, after R097 (`r097b-seg.png`) | 255 | 249 | 232 | **−17** | 248 |
| dark (`r098-seg-dark.png`) | 30 | **43** | **60** | **+17** | 96 |

**Both dark tokens land exactly on their arithmetic** — track 43 = `white@6% over 30` = 43.5 ✓; pill 60 = `#3C3C3C` ✓ (an **opaque** fill
renders its absolute value, so R097's shadow-reachability trap cannot bite it). The pill is **Δ30 over the plane and Δ17 over its own track**
⇒ **the selection does not vanish. C05's dark leg PASSES.** The polarity flip (light −17, dark +17) is the *extrapolation* — a symmetric
mirror of the ref's measured sink — with **no dark reference to confirm it against**. Recorded, not claimed.

**Structure re-confirmed on the dark plane.** Non-plane runs in the row: the sidebar (x0..220), the segment capsule (x562..757), and
exactly **two** round buttons (x1023..1048, x1059..1084) — the **same x as the light leg** (1026..1045 / 1062..1081; the light run reads
narrower only because a 248-on-255 glass fill falls inside the `<250` threshold) ⇒ **the dark plane moved no chrome geometry**, and
"exactly one capsule" holds on both planes.

## ## 本轮 (R098)
Atomic step: **C05's own regression half — capture the dark leg and read it.** No implementation, no `code-writer`. **Nothing was edited
except this state file, `rounds.md` and `LEDGER.md`.** **Verdict: PASS** (numbers above). **Map correction produced by the round: our
toolbar capsule is `y36..63` (28 tall, a 1px `AppTheme.border` hairline top and bottom) and the lens `y38..61` (24 = `height − 4`), in
**both** legs — the earlier "toolbar row y≈22..58" is wrong by 14.** C05 is now settled as far as it *can* be: **clause 1's structural
half (R097) + its dark leg (R098) are closed**; what remains of C05 is the label-token residue (仍差 #2) and the pointer half, which no
harness action can drive.

## 仍差 (top 8, visual-impact order)
1. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole 6,
   inset 3 from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px right of
   the ring's outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family**
   (stroke ~1.5, hole ~9) on the neutral-248 chips. **Do NOT build either until H is answered.**
2. **C05's residual divergence: the segment's `textColor`/`mutedTextColor` are calendar-local** (`root.tahoe.labelPrimary`/
   `labelSecondary`) where the settings app takes `AppTheme.text`/`mutedText`. **Not ruling-blocked — a reading round** (the label pair is
   the last host-variable left in that control). **This is Next #1.**
3. **The segment pill's RADIUS is unmeasured 1:1.** Ours `height * 0.42` ≈ 10; the ref's pill *looks* near-full-round in the 4x crop, which
   at ref scale (pill h ≈ 17) is indistinguishable from 0.42·h by eye ⇒ **measure the pill's per-row fill-start inset before claiming either.**
   *(R098 note: the pill is 62 wide × 24 tall at our scale, so its per-row inset is readable directly from `r098-seg-dark.png`.)*
4. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right
   edge (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
6. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
7. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day before it
   can be reproduced at all.** **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell — no ref counter-example
   either). **The band's own cap is gone (R089); this is the last one.**
8. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on
   **ruling G**. Do not chase without a ruling.
- **CLOSED in R098: C05's dark leg** — the selection pill renders as a distinct step on the dark plane (60 vs track 43 vs plane 30); chrome geometry unchanged from the light leg.
- **CLOSED in R097: C05 clause 1's structural half** — one capsule renders, `GlassPill` is dead source, and the fills no longer conflict.
- **CLOSED in R094: M04's size clause** — the mini today disc's **20 → 15 px**, with the header disc re-measured as the control (22x22).
- **CLOSED in R093: M04's colour clause** — the mini today disc's blue → `AppTheme.todayRed`.
- **CLOSED in R092: R091's fix holds in the DARK leg** (0 px between two fresh dark legs; the 0 is structural — no today column).
- **CLOSED in R091: the initial-scroll nondeterminism** (0 px between two fresh light legs).
- **CLOSED in R089: A04 step 2 — the band's silent overflow. A04 fully PASS.**
- *Cosmetic / settled, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02
  radius **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line
  exactly on the viewport top (R066; scroll artifact). Band-chip fill alpha ref **0.16** vs ours **0.17** (R080) — not worth a round.
  **CLOSED R095: the mini month's weekday header does not tint today's column letter** (the "red 六" was a ×2 `LANCZOS` artifact).
  **MEASURED R096: S04 — clauses 1 and 3 hold; clause 2 is already `radius: 6` on `CategoryRow`; `SidebarRow`'s capsule is dead chrome.**

## ## 最近已改 (most recent 8)
0. R098 — **verdict only, NO code changed**: C05's dark leg captured (`r098-seg-dark.png`). plane 30 / track **43** / pill **60**
   (pill−track +17; light was −17). Both dark tokens exact. Chrome geometry identical to the light leg. Capsule `y36..63` (map correction).
1. R097 — **C05 clause 1's chrome**: `Main.qml:94-103` `segmentTrack` (light #787880@2.5%→252 / dark white@6%) + `segmentPill` (**opaque**
   #E7E7E7=231 / dark #3C3C3C); `Main.qml:1715-1716` repointed. Track 229..233→**250..252**, pill 254→**231..233**, step Δ20 = the ref's.
   Iteration 1 (a 17.5% veil pill) rendered **210** — see the lens-shadow instrument. Nothing else touched.
2. R096 — **verdict only, NO code changed**: S04's "selected row gray radius 6" governs **`CategoryRow`** (already `radius: 6`); the ref's
   only selection shape is the compact **"Personal"** row (ΔL −11, r=6, h 28, inset 10). Clause 3 holds (ours −9 vs −13). First-ever
   expanded-sidebar capture: `r096-sidebar.png`.
3. R095 — **verdict only, NO code changed**: the mini month's weekday header does not tint the today column (ref 7/7 letters R==G==B).
4. R094 — **M04 size**: `Main.qml:2199-2200` `width/height: 20` → `15`. Disc re-measured **15x15** vs the ref's 15x15; header disc 22x22.
5. R093 — **M04 colour**: `AppTheme.todayRed: "#E5484D"`; `CalendarScheduleView.qml:111` repointed; `Main.qml:2204` → `AppTheme.todayRed`.
6. R092 — **verdict only**: the dark leg as R091's missing acceptance half — whole-page diff **0 px**, a true structural zero.
7. R091 — **`CalendarScheduleView.qml:276`**: `repositionTimeline()` replaces the bare `autoScrollTimer.restart()`; two legs, **0 px**.
   *(archived to rounds.md tail: R090 — verdict + diagnosis of the 154,551 px capture-window artifact; R089 — A04 step 2.)*

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098, new and load-bearing).**
  `LiquidSegmentedControl.qml:94-99` gives the *track* a specular `Gradient` (white@4% → black@2%) and `:128-136` gives the *lens* a
  stronger one (white@9% → white@2.5%@0.58 → black@2.5%), while `:124` adds a 1px `border.color: white@16%` to the lens. Reading the top row
  yields **99** where the body is **60** (dark) — a phantom 39-level error. **The same overlay is present on the light leg (track 234 → 229
  top-to-bottom) and in both hosts** ⇒ **it is the shared control's own material, never a C05 host divergence.** Read light fills the same
  way: the light-after pill is 232 at the body and 239 at the top.
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).**
  `LiquidSegmentedControl.qml:105-114` paints `lensShadow` (black@**10%** light / **24%** dark) **directly under the lens**, so a pill's
  composite is `plane − 0.10·plane` first, then the veil: 255 → 227 → a #787880@17.5% veil lands at **210**, not the 231 the over-white
  arithmetic predicts (R097 iteration 1 is that exact error). ⇒ **read the composite, or use an OPAQUE fill when the target is absolute.**
  Corollary: the pill's reachable range under that shadow is **[120, 227]** on a white plane. **R098 confirms the other side: an opaque fill
  (the dark #3C3C3C) lands exactly on its token, 60.**
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097).** `LiquidSegmentedControl`'s interaction (`_visualIndex`,
  `_pressedIndex`, `scale 0.96`, the `Behavior`) is one code path for every host ⇒ **"chrome matches actual settings" reduces to: do the
  four palette properties equal the defaults?** The settings app passes none; the calendar passed four. **Any future shared-control chrome
  question: diff the property list, not the pixels.**
- **THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER (R096).** Ref plane **237**, selected row **226** (ΔL −11,
  neutral, r=6, h 28); ours plane **228** with `selectionFill` **215** (ΔL −13) over a **flat opaque** plane. Same token reads (207,51,35) on
  the sidebar vs (235,76,70) in the grid ⇒ **compare only ΔL against the layer's own plane.** **R097 bounds this: the toolbar row is NOT a
  vibrancy layer — the ref's toolbar plane and ours are both white 255, so absolute Δ's DO transfer there. Check the plane before invoking
  the caveat.**
- **A RADIUS IS MEASURED AS THE PER-ROW FILL-START INSET, AND r=6 FITS 4,2,1,1,0 (R096).** A circle of radius r predicts
  `r − sqrt(r² − (r − (dy+0.5))²)`; read the fill's per-row first/last x with a tight tolerance around the fill's own colour. **Do not
  eyeball a radius off an upscaled crop** (this is why 仍差 #3 is still unmeasured). **R098: pick the rows by the **body** mode, not the top —
  the lens's own specular ramp otherwise reads as a corner.**
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** The flat action set is
  `captureClient{path}` / `escape` / `resize{width,height}` / `sidebar{expanded}` / `view{view}` / `date{date}` / `position{contentY}` /
  `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` / `openItem{kind,titleContains}`. ⇒ **`hovered`/`pressed` chrome cannot be
  driven** — every clause phrased as "hover …"/"pressed …" is **static-only** unless a new harness action lands. **A static screenshot can
  never settle an animation or a hover clause.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** Every R082–R092 leg therefore contains **no sidebar and no mini calendar**;
  `{"action":"sidebar","expanded":true}` must be in the drive list (the harness applies it *before* the capture command).
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** The harness logs the
  **pre-command** timeline geometry for any timeline action (`harness/Main.qml:263`). **The 2026-10-17 pair: the pixel diff said 154,551 px
  while the probe said `240` in BOTH legs** ⇒ the diff was a capture-window artifact. `contentHeight 960` = 24 h × 40.
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088, re-used R091).**
  Threshold per pixel at **>6 RGB-sum** (kills AA), group the differing rows into contiguous y-runs, read each run's x-range.
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the
  ref's but **our type is at the ref's own physical size**: gutter-label ink **9 = 9**, day-number ink in the disc **9 = 9**. ⇒ "ref 22 ×
  1.33 = 29" overshot by 30 %. Corollary: our header row is 36 tall vs the ref's ~28 — a *layout* difference, not a licence to inflate type.
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** Measured on five ref colours, all 1:2 on every channel.
  ⇒ **any future "same-hue text/tint" on a chip is `c + (pole − c) * 0.5`.** Corollary: **dark chip colours are extrapolation.**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R098).** Corner: per-row **fill-start inset** (body mode, R098).
  Joint: per-row **`!= white` envelope**. Stripe: a saturated run whose **width is constant over the chip's full height**. Border:
  **monotonicity of a raw profile across an edge that abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap
  argument**; for a cross-capture comparison the **top-5%-coverage mean**. Mark/token: **a strict per-channel match to the token over a
  bbox, with a control region of the same token elsewhere in the same capture**. Ordering/content: a per-column deviation-from-fill ASCII
  ramp. **For a *fill under a shadow* neither an ink test nor an alpha calculation works — composite the stack or go opaque; for a fill
  under the control's own specular `Gradient`, take the body mode.** **Ask the app what its `contentY` is before attributing a cross-leg
  difference to any binding.**
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat filename**;
  **always read the success flag in `live-runtime-vm.log`** and then `ls` the actual CWD.
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. ⇒ kill the pid from `live-app.pid`, keep the launcher's stderr, check the pid changed.
  **`leg.sh <theme> <name>` does the whole leg in one call — but its drive list has NO `sidebar` action (R093) and its date is
  `2026-04-02`; for a mini-month leg run the four steps by hand.** **R097/R098's working leg (ONE Bash call): kill `live-app.pid` →
  `nohup ./start-review-vm.sh light|dark &` → `sleep 32–34` → `review-command.py` with `resize`/`sidebar`/`view`/`date`/`captureClient`/
  `stop` → grep `capture <name>.png true` + the `manual stop contentY` probe in `live-runtime-vm.log`.**
- **OUR COLUMN MAP AT 1100x692 (R071/R072/R074–R098):** x=0 rim; gutter x 1..51; separators at **x=52/202/352/502/652/802 in BOTH the
  band and the grid**, **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's segment
  track spans x≈562..757 (w 196) centred on the main region; the lens x629..690 (w 62) on segment 2 = Week; the capsule is y36..63 (28 tall,
  1px `AppTheme.border` hairline top and bottom), the lens y38..61 (24); the two right round glass buttons are x1023..1048 / x1059..1084.**
  **Fixture day: Thu Apr 2 = 4 all-day items ⇒ 3 chips; Fri Apr 3 = 1. The launch week (Oct 12–18) carries NOTHING, so `date 2026-10-15`
  is the cheapest way to get a month that CONTAINS today.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R098.** `sectionRule` **y=155** (242 light / 39 dark,
  1px); band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap
  **181**, **182-205**, gap 206, **207-230**.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**; top
  rule **y=124** 1px (242); bottom separator **y=183-184** 2px (217), row-mean **217.0 constant over x250..810**; **inset ≈1 both legs**;
  content **125..182 = 58**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3, hole 6,
  3 px inside the fill edge**. **R087: the band never expands.** Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 / hue ink — every
  *form* item matched **except the icon (仍差 #1)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light
  desaturated same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round caps**;
  **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark white@0.13),
  `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light
  `#F2F2F2` / dark white@0.04). **`AppTheme.border` has ZERO consumers in that view** (but the *shared* segmented control draws its own
  hairline with it — R097). Requirement is the ORDERING: ref 242 < 237 < 217; ours light 242 < 237 < 217, dark 39 < 59 < 84.
  **`gridLine` is consumed by THREE things — the grid's top/left/right edges AND the band's column separators.**
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns are 249 light / 37 dark; the gutter
  is NOT tinted.** **Sidebar plane light = (228,228,228); the mini month's weekend cells are tinted (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start
  at x ≥ 3** or the x=0 rim merges every text band into one — **and a band scan finds the label's *ink rows*, never its *text*.**
  **Compare the digits, not the bands.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = **16**. Half-hour line = **20**. **R072 added
  the four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the
  band model; R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at
  `Main.qml:2204`; R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill` + the segment's repoint at `Main.qml:1715-1716`.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed Apr 1**) +
  243px sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels
  193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238, pill/line red **(235,76,70)**.
  **7 equal day columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692:
  w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** (the contract says 40; 40 was chosen). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 ·
  Fri 3 · Sat 4.** **R097/R098 add the toolbar row: y4..36 in the ref, holding (left→right) the traffic dots, a 2-icon capsule at
  x≈122..190, a round `+` at x≈205..230, the Day/Week/Month/Year capsule at x≈389..615 (track 249..253, selected pill 230..235), and two
  round glass buttons (radar, search) at x≈735..810.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R098).** `harness/Main.qml` matches `command.action` only; a command with no
  `action` **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes
  **in place** (never `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:** `start-review-vm.sh light|dark` blocks on
  `wait "$app_pid"` — background it; a rebuilt binary needs a **kill+relaunch** (~24 s to the new pid). Include `resize 1100x692`; the app
  starts in `--view week --date 2026-10-15` **with the sidebar COLLAPSED**. **The theme is fixed at launch — a dark leg costs a full
  kill+relaunch. App stderr goes to `live-runtime-vm.log`.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root
  `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06**
  plus a **`Multi-day review`** all-day strip **`20260330` → `20260403`** (Mon/Tue/Wed render as ONE chip each; Thursday does NOT carry
  it). **R087 ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items,
  Apr 3 exactly 1.** UID-ordered since R083 ⇒ **Thu's order is `Design sync` / `Release notes` / `R087 card C` / (`R087 card D`, hidden)**.
  VTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect
  elision` 11:00, `[R019 LONG TASK] …`. **The rendered week also shows `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist`.**
- **Pillow crops need ABSOLUTE paths**; a glob and a literal path in the same `for` list crashes the crop script. **A composite (a 1:1 strip
  above a 2–4× zoom) answers "overall form + local detail" in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes
  it self-describing.** **R077: `LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.** **R080: a
  `Counter` mode over a cell gives the fill in one call (R098: use it for a segment fill — over the *body* rows).** **R097: a black-bar
  two-panel `old-above / new-below` ×3 `NEAREST` stack of the *same* region is the whole before/after verdict in one read (and it is what
  caught the exchange); R098: the same stack with the light-after strip added is the whole *both-leg* verdict in one read.** **No `numpy` in
  this interpreter.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## ## Next round (pick ONLY #1)
**#1 — C05's label-token residue (仍差 #2), a READING round.** The segment's `textColor`/`mutedTextColor` are **calendar-local**
(`Main.qml`'s `tahoe.labelPrimary`/`labelSecondary`) while the settings app's two `LiquidSegmentedControl`s
(`KosSettingsDialog.qml:174`/`:212`) pass **none** ⇒ they take `AppTheme.text`/`mutedText`. **The method is settled (外推 #3: diff the
property list, not the pixels):** read `Main.qml`'s calendar instance and the settings instance side by side, then **measure the label ink in
both hosts in ONE capture** — the toolbar segment's selected label and an unselected one, in `r098-seg-dark.png` (dark) and `r097b-seg.png`
(light), against the same captures' own plane, and decide whether the two label pairs are the same two colours. **Verdict-only unless they
differ; if they differ, repoint the two properties at `AppTheme.text`/`mutedText` (2 tokens, nothing else).**
⚠ Read the *unselected* label too — the selected one sits on the pill and its ink is the higher-contrast pair.

**Then:** #2 the segment pill's radius (per-row fill-start inset at the **body** mode, 仍差 #3 — `r098-seg-dark.png` has a 62x24 pill at
1:1, so it is cheap now); #3 the ruling-blocked list in 仍差 order — the band ring icon (H), the 12-hour two-tone gutter labels (F), the dim
snap (A), the shadow magnitude (B), the month `slice(0,2)` (D), the band chips' inset (G).

**Blocked on rulings A–H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E;
clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the
ref's measured 1**. **No rulings channel exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round) — R097 used `general-purpose` as the stand-in
implementer; R098 needed no implementer at all.**
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04 fully PASS**;
**E01/E02 clauses 1+2+3 PASS** and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**; **M04 closed R093 +
R094**; **M03/M02/M01/S02/S03/S05/L01–L07/C01–C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**; **C05 clause 1's
structural half CLOSED R097 and its dark leg CLOSED R098 (this round); its label-token residue + its pointer half remain open.**)
