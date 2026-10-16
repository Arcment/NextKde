# R104 — the segmented TRACK's radius: `LiquidSegmentedControl.qml:87` `height * 0.38` -> **`height * 0.48`** (10.64 -> 13.44 on the 28-tall track).

**Why this round.** Next #1 from R103: the last unmeasured *shape* constant in the segmented control and the last unblocked item in C05.

**The absolute measurement is DEGENERATE — recorded as a negative result.** A least-squares rounded-rect fit
`x(y) = x0 + r - sqrt(r^2 - (r - (y - y0))^2)` to the **rim-core trace** (argmin of the luma per row, both edges, mirrored about
x=502) recovers the **reference** track at **r = 11.25** (SSE 0.28, y0 9.5, y1 37.5, H 28.0) and, on the same rows, at **r = 13.50**
(SSE 0.15, y0 8.5, y1 38.0, H 29.5) — **r and y0/y1 are not separable when only the arc is visible**, and the two run a tie.
The instrument validated on our own track (true r = 0.38 x 28 = 10.64) reads **11.00** — a **+0.36 bias**, and the bias *flips sign*
(-1.14) when the two rows of horizontal top/bottom edge are left in. ⇒ **the reference's track radius is NOT absolutely measurable
beyond r in [11, 13.5] on H ~ 28-30.**

**The decisive instrument is WITHIN-IMAGE, and it cancels that bias.** Compare the track's corner *inset profile* — per row, the rim
core's x minus its own nadir column — against **the same control's own lens**, same image, same rows, same method:

| dy from the rim's top row | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| **REF track** (col 388, top y9) | 7 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | 1 | **0** |
| **REF lens** (col 450, top y12) | 6 | 4 | 3 | 2 | 1 | 1 | **0** | | | | |
| **ours BEFORE** (col 562, top y36) | 6 | 4 | 3 | 2 | 1 | 1 | 1 | **0** | | | |
| **ours AFTER** | 8 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | **0** | |

The reference's **track** corner is uniformly **1-2 px wider (rounder) than its own lens's** at every depth. **Ours before was
IDENTICAL to our lens's** (both nadir at dy 7-8) — the outer capsule's corner was exactly as tight as the inner one, which is
geometrically what a concentric pair must not be. ⇒ **the defect was a two-token capsule (0.38 outer / 0.48 inner), not a radius value.**

**The fix is therefore one token, not a new number: `0.48` on both.** `:87` `height * 0.38` -> **`height * 0.48`**: track r
**10.64 -> 13.44**, lens r unchanged at **11.52** (R101), delta **1.92** against the **2 px** lens inset ⇒ **concentric by construction**
(the 0.08 px shortfall is sub-pixel). Our AFTER profile then reproduces the reference's to **<= 1 px on every row** (see table), and
the ref's own numbers agree: its track H measured **30** by rim-core span (ours 28, hard in QML) ⇒ ref r/H **0.46-0.48** = **the same token.**

**Scope, stated.** `:87` is inside the shared control, so this is app-wide by construction — `KosSettingsDialog.qml:174` and `:212` and
`WallpaperPreviewBar.qml`. It is a fix rather than a regression there because the token is now the one the *lens already used*, so every
host gains a concentric pair. **`:117/119` (R102) and `:121` (R101) untouched.**

**Figure.** `docs/ui-calendar/r104-track-corner-3panel.png` — **REF / ours-before / ours-after**, the track's left-end corner at **x6 NEAREST**,
each anchored on its own rim top-left; captions on the final canvas.

**Verdict: C05's track radius CLOSED — the last unblocked *shape* constant in the control. What remains of C05 is the pointer half
(no harness action drives it) and the label COUNT (ruling-blocked).**

# R103 — the segment's slot **PITCH**: `Main.qml:178` `segmentWidth: 196` is a **spec literal** (L03 width 180–210). **Verdict only — NO code changed.**

**Why this round.** Next #1 from R102: the last unblocked *shape* error in the segmented control — the pitch (ref "56.75" vs our 64).

**R102's premise for this item was FALSE, and it was the error R102 itself had diagnosed.** *"Ref slot = 227/4 = 56.75"* is `track_width / n` — the
exact bug R102's own headline names for our side; the true slot is `(W − 4)/n`, the 4 px being the control's own outer inset. Re-derived on the ref:
**slot = (228 − 4)/4 = 56.0**, and the **direct** measurement agrees — word centres **418 / 474 / 530 / 586** ⇒ pitch **55.5 / 57.0 / 56.0 = 56.0**
(their centroid 502.0 = the track's own centre, so the four words are symmetrically placed ⇒ the *centres*, not the edges, are the instrument).

**The spec settles it.** `spec.md:17` **L03**: *"Day/week/month segment centered within main region; **height 28 and width 180–210**"*. Ours is
**196×28** — `Main.qml:171`/`:178` name it as the design constant — and **196 is the band's midpoint (195)**. A 3-label control at the ref's pitch
= 3×56 + 4 = **172**, **8 px under L03's floor of 180**; conversely the floor already forces slot ≥ (180−4)/3 = **58.67 > 56.0**. ⇒ **the ref's pitch
is unreachable inside L03, so no number moves.**

**Measured 1:1.** Ref track **x389..616 (W 228–229)**, the pill **centred in its slot** (fitted W 51–52.4, centre **474.0** = slot 2's centre exactly).
Ours: track **x562..757 (W 196)** unchanged, slot **64.0**, word centres **595 / 660 / 723** ⇒ pitch **64.0**. ⇒ **the discriminator is 4 labels vs 3,
not a defect.** Side effect: R102's "52.4/56.75 = 92.3 %" re-reads as ref **51/56 = 91.1 %** (direct, sharp-edged) or **52.4/56 = 93.6 %** (fit) against
ours **93.75 %** ⇒ **our pill's *relative* width is already ≥ the reference's; the residual is absolute, and it is L03's.**

**Negative result.** The ref **track has no measurable fill edge** — its edge pixels read **231–245** between a **250** fill and a **255** plane, *darker
than both* ⇒ that is a **rim/shadow, not a fill boundary**, and a mid-threshold fit on it is invalid. Any track-edge-derived quantity is ±1 px, so
**a pitch must be taken from the word centres** (it was).

**Figure.** `docs/ui-calendar/r103-seg-pitch-2panel.png` — REF ×3 and ours ×3, `NEAREST`, **blue = track edge, green = slot boundary, red = word
centre**, captions drawn on the final canvas at 1×. **Verdict: 仍差 #3 CLOSED in full; `Main.qml:178` `196` stays. Next: the track radius at
`LiquidSegmentedControl.qml:87` (`height * 0.38`) against the lens's `0.48` (R101).**

# R102 — C05's segment pill **WIDTH**: measured, `LiquidSegmentedControl.qml:117/119` → `segmentWidth - 4` + re-centre. **Fixed (2 numbers, one component).**

**Why this round.** Next #1 from R101: the pill's horizontal slot inset — the last unblocked *shape* error in the control.

**R101's premise for this item was FALSE, and it was checked before acting.** R101 wrote *"ours is w 64 in a 65.33 slot ⇒ 1.2 px per side"*.
The slots **tile**: `:31` `segmentWidth = (width - 4) / labels.length` with `:117` `x: 2 + index * segmentWidth` ⇒ an interior pill is
**adjacent to its neighbour, gap 0**, and the true inset was **0 px per side**. The `65.33` is `track_width / 3` — it counts the control's own
2 px outer inset as per-slot padding. **The pill's horizontal padding was not too small; it did not exist.**

**The reference re-measured with R101's validated fit** (per-row fill-start inset, threshold = the midpoint of *that* image's own two constants,
interior rows only). Ref pill **W = 52.4, h 24, r ≈ 11.5** — the fit recovers r = 11.5 on **all eight** interior rows:

| dy | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|
| model r=11.5 | 8.15 | 5.82 | 4.36 | 3.25 | 2.39 | 1.70 | 1.14 | 0.72 |
| ref measured | 7.7 | 5.7 | 4.2 | 3.2 | 2.7 | 1.7 | 1.2 | 0.7 |

⇒ **the reference's radius token is the same `0.48` as ours; WIDTH is the discriminator.** Ref slot = 227/4 = **56.75** ⇒ pill/slot = **92.3 %**.
Ours was 64/64 = **100 %**.

**The edit.** `:119` `width: root.segmentWidth` → `segmentWidth - 4`; `:117` `x: 2 + …` → `4 + …` (re-centre). ⇒ **60 px in a 64 px slot =
93.75 %**, i.e. a uniform 2 px padding — the mirror of the lens's own vertical inset (`:118` `y: 2`, `:120` `height: root.height - 4`).
**The label delegates are untouched** (`:149-150` still `2 + index * segmentWidth` / `segmentWidth`): `4 + i·segW + (segW−4)/2 ≡ 2 + i·segW + segW/2`,
the same centre by algebra. `lensShadow` tracks `lens.x`/`lens.width` and follows for free.

**Acceptance** (light, `contentY 280`, `contentHeight 960` — the same leg as R098–R101, so all five are comparable). Build clean, one launch,
one capture, 2 image reads, 17 Bash calls. **Pill x630..689 = w 60** (was x628..691 = 64); **track x562..757 unchanged**; **pill centre x659.5
unchanged**; the **radius fit re-run ⇒ r ≈ 11.5, unchanged** (the corner rows are identical by construction). Residual 2.0 vs the ref's
2.18 px/side = **0.2 px**, below the ref W fit's own resolution (52–53). Figure: `docs/ui-calendar/r102-seg-width-3panel.png`
(**REF / before / after ×5**, `NEAREST`, black-barred and labelled, **red lines = slot boundaries**).

**Also measured, and recorded as UNMEASURABLE: the ref *track*'s vertical extent.** Its fill waves 248↔255 on a 255 plane — a 250 band at y7-8
confined to x403..601, 255 at y9-10, 249 at y15-19, 253 at y30-32, 255 at y36-37, 248-252 at y39-43. ⇒ the pill's *vertical* inset in the
reference cannot be established at any threshold trusted here. **Ours stays at 2, unchanged.**

**Deliberately NOT chased:** the **slot PITCH** (ref 56.75 vs our 64). Our track is a hard-coded `Main.qml:178` `segmentWidth: 196`, documented
at `:171` as "the segmented control is 196x28". A like-for-like 3-label control at the ref's pitch would be ≈174 wide ⇒ a pill of ≈52.4, not 60.
**Whether 196 is a spec literal has to be settled before that number moves — that is Next #1.**

## ## 本轮 (R102)
Atomic step: **measure the pill's horizontal padding 1:1 and apply the single rule it justifies.** One build, one launch, one capture.
Files touched: `shared/qml/controls/LiquidSegmentedControl.qml:117,119`, the docs mirror, `LEDGER.md` (+ this state file and `rounds.md`,
which cannot be committed). **Verdict: the ref's pill is 92.3 % of its slot and ours was 100 %; we are now 93.75 %, and the radius token needed
no change — it was already right.**

## 仍差 (top 8, visual-impact order)
1. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies exactly three ("Day/week/month"), so
   **three is spec-correct** and our three now read in the ref's order (`Day · Week · Month`, R100). **Adding a year view is not an atomic step
   ⇒ this is a question, not work.** Ref word centres **418/474/530/587, pitch 56**; ours **594/660/724, pitch 64**. **Blocked on a ruling.**
2. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12x12 ring, stroke 3 / hole 6, inset 3
   from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17-19 ref px right of the ring's
   outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family** (stroke ~1.5, hole ~9)
   on the neutral-248 chips. **Do NOT build either until H is answered.**
3. **The segment's slot PITCH — ref 56.75/slot in a 227 track; ours 64/slot from `Main.qml:178` `segmentWidth: 196`.** The pill is h = 24 on
   both sides, so this is a real absolute gap (our pill 60 vs the ref's 52.4), **not** a scaling artefact. `:171` documents 196 as "the segmented
   control is 196x28", so **check the spec literal first**. **Next #1.**
4. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right edge
   (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
6. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
7. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day** before it can be
   reproduced at all. **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell).
8. **Ref band chips are inset ~2 ref-px from their column rule; ours sit at inset 1** (near-identical, ~3.7 px at our scale). Rides on **ruling G**.
   Do not chase without a ruling.
- **CLOSED in R102: 仍差 #3's inset half** — `LiquidSegmentedControl.qml:117/119` `2 +` → `4 +` and `width: root.segmentWidth` →
  `segmentWidth - 4`; pill 64 → 60 in a 64 slot (93.75 %), against the ref's 52.4/56.75 = 92.3 %. **The radius token was already right.**
- **CLOSED in R101: C05's pill-radius clause** — `LiquidSegmentedControl.qml:121` `0.42` → `0.48`; the fit recovers 0.42→10.1, 0.46→11.2,
  0.48→11.4 against a reference of 11.4–11.7 on a 24-tall pill. **The track's radius is separate and unmeasured (see 外推).**
- **CLOSED in R100: C05/L03's label ORDER** — `Main.qml:1713-1728` reads `Day · Week · Month`; `viewIndex` preserved by mirroring (`2 - index`).
  **What remains of C05 is only the pointer half (no harness action drives it) and the label COUNT (ruling-blocked).**
- **CLOSED in R099: C05's label-token residue** (one ink in both states). **R098: C05's dark leg** (60 vs track 43 vs plane 30).
  **R097: C05 clause 1's structural half** (one capsule renders, `GlassPill` is dead source).
- **CLOSED in R094: M04's size clause** (mini today disc 20 → 15 px). **R093: M04's colour clause** (→ `AppTheme.todayRed`).
- **CLOSED in R092/R091: the initial-scroll nondeterminism (0 px); R089: A04 step 2 — A04 fully PASS.**
- *Cosmetic / settled, no ID:* `secondary` hover = neutral grey 79 no edge; `flat` hover = accent tint (35,60,81) **with** a 1px edge. D02 radius
  **16** vs spec 24/32 — **keep 16**. Topmost visible gutter label is **half-clipped** when a scroll offset lands an hour line exactly on the
  viewport top (R066). Band-chip fill alpha ref **0.16** vs ours **0.17** (R080) — not worth a round. **MEASURED R096: S04 — clauses 1 and 3
  hold; clause 2 is already `radius: 6` on `CategoryRow`.**

## ## 最近已改 (most recent 8)
0. R102 — **C05's segment pill WIDTH**: `LiquidSegmentedControl.qml:117` `x: 2 +` → **`4 +`**, `:119` `width: root.segmentWidth` →
   **`segmentWidth - 4`**. Pill **64 → 60** in a 64 slot (100 % → 93.75 %); ref 52.4/56.75 = 92.3 %. Track, pill centre and label columns unmoved;
   **radius fit re-run ⇒ 11.5, unchanged.** Figures `r102-seg-width-3panel.png` (REF / before / after ×5, red slot lines), `r102-seg-light.png`.
1. R101 — **C05's segment pill radius**: `LiquidSegmentedControl.qml:121` `height * 0.42` → **`height * 0.48`** (1 number). Ref pill **h=24,
   r fit 11.4–11.7**; the same fit recovers ours at 0.42→10.1 / 0.46→11.2 / 0.48→11.4.
2. R100 — **C05/L03's label ORDER**: `Main.qml:1713-1728` `[Month, Week, Day]` → `[Day, Week, Month]` **+** `currentIndex: 2 - root.viewIndex`
   **+** `onSelectionRequested: ... 2 - index`. The `2 -` mirror keeps all five `viewIndex` consumers untouched ⇒ **order only.**
3. R099 — **C05's inactive label**: `Main.qml:1717-1722` `mutedTextColor: labelSecondary` → `labelPrimary` (**1 token**).
4. R098 — **verdict only, NO code changed**: C05's dark leg captured (`r098-seg-dark.png`). plane 30 / track **43** / pill **60**.
5. R097 — **C05 clause 1's chrome**: `Main.qml:94-103` `segmentTrack` + `segmentPill` (**opaque** #E7E7E7=231 / dark #3C3C3C);
   `Main.qml:1715-1716` repointed. Step Δ20 = the ref's.
6. R096 — **verdict only, NO code changed**: S04's "selected row gray radius 6" governs **`CategoryRow`**; first-ever expanded-sidebar capture
   `r096-sidebar.png`. Clause 3 holds (ours −9 vs −13).
7. R095 — **verdict only, NO code changed**: the mini month's weekday header does not tint the today column (7/7 letters R==G==B).
   *(archived to rounds.md tail: R094 size, R093 colour, R092 dark-leg verdict, R091 `CalendarScheduleView.qml:276` `repositionTimeline()`.)*

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **A PILL'S HORIZONTAL PADDING IS MEASURED AGAINST ITS OWN SLOT, AND THE SLOTS OF A SEGMENTED CONTROL TILE (R102, load-bearing).** `:31`
  `segmentWidth = (width - 4) / labels.length` + `x: 2 + index * segmentWidth` ⇒ interior slots are **adjacent**; `track_width / n` is **not** a
  slot width, it silently adds the control's own 2 px outer inset. **Divide the interior, and state whether the inset is per-slot or per-control.**
- **THE REFERENCE'S SEGMENTED CONTROL AND OURS SHARE ONE RADIUS TOKEN AND DIFFER ONLY IN WIDTH (R101 + R102).** The same fit on the same
  24-tall pill gives the ref **r ≈ 11.5** and ours **r ≈ 11.5** (`0.48 · 24`). ⇒ **the ref's `Day/Week/Month/Year` words are 52.4 wide at 56.75
  pitch; ours are 60 at 64 — the residual is the slot pitch, not the pill's shape.** Corollary: a *shape* comparison between these two controls
  is legitimate; a *size* comparison needs the slot.
- **A RADIUS IS MEASURED 1:1 AGAINST A SAME-HEIGHT ELEMENT, AND THE METHOD MUST RECOVER A KNOWN TOKEN FIRST (R101, load-bearing).** Fit
  `r − sqrt(r² − (r − (dy+0.5))²)` to the **interior rows dy0..H−2 counted from the first row below the threshold** (R101 counted from the
  geometric top and mis-indexed by one; **R102: index from the first counted row and the same numbers recover 11.5 exactly**). **Threshold = the
  midpoint of THAT IMAGE's own two constants**, never a probe pixel that can land on a glyph.
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, load-bearing).** Ref `Day/Week/Month/Year` = `(0,0,0)` with `n<100`
  60/76/85/53; ours before = 147/152 with **`n<100` = 0**. ⇒ **`n<100` is the discriminator between an ink *token* difference and an AA-coverage
  difference.** **A semantic two-tone is a native-app idiom this reference does not share.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100).** `viewIndex` (0=month/1=week/2=day) has five consumers
  spanning QML, shortcuts, the CLI and the *review harness*; flipping the label array alone would have silently inverted `--view`, `Ctrl+1..3`,
  the page cache and every harness `view` command.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** `:94-99` gives the *track* a specular `Gradient` and `:128-136`
  the *lens* a stronger one, while `:124` adds a 1px `border.color: white@16%`. Reading the top row yields **99** where the body is **60** (dark).
  **R101 adds: that same border makes the DARK leg measure 2 px wider than the LIGHT leg (64 vs 62) — a capture comparison must state its leg.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** `:105-114` paints `lensShadow` (black@**10%** light /
  **24%** dark) directly under the lens ⇒ a veil lands at **210**, not the 231 the over-white arithmetic predicts. Reachable range under that
  shadow is **[120, 227]** on a white plane. **Corollary R101: the light leg's CURRENT pill fill is 231 = the token exactly; a stale capture
  (`r097-seg.png`) reads 205, so it is NOT a valid baseline.**
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).** `LiquidSegmentedControl` has exactly **four** palette
  properties and **one** consumer each for the last two (`:188`). The calendar passes all four; the two settings instances
  (`KosSettingsDialog.qml:174`/`:212`) pass **none**. **The *geometry* is likewise shared — `:87` (track), `:117/119` (lens) are global, so a
  radius or padding edit is app-wide by construction and lands in the settings dialog too.**
- **THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER (R096).** Ref plane **237**, selected row **226**; ours plane
  **228** with `selectionFill` **215**. Compare only ΔL against the layer's own plane. **R097 bounds it: the toolbar row is NOT a vibrancy layer —
  both planes are white 255, so absolute Δ's DO transfer there.**
- **A RADIUS IS MEASURED AS THE PER-ROW FILL-START INSET, AND r=6 FITS 4,2,1,1,0 (R096).** **Do not eyeball a radius off an upscaled crop.**
  Pick rows by the **body** mode (R098).
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** The flat action set is `captureClient{path}` / `escape` / `resize{width,height}` /
  `sidebar{expanded}` / `view{view}` / `date{date}` / `position{contentY}` / `wheel{angleY}` / `flick{velocity,cancelFirst}` / `stop` /
  `openItem{kind,titleContains}`. ⇒ **`hovered`/`pressed` chrome cannot be driven**; **a static screenshot can never settle an animation.**
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** The harness logs the
  **pre-command** timeline geometry (`harness/Main.qml:263`). R101/R102's probe read **`contentY 280`, `contentHeight 960`** — the same value as
  R098/R099/R100, so all five legs are comparable.
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088).** Threshold **>6 RGB-sum**,
  group differing rows into y-runs, read each run's x-range.
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).** Our window is 1.33× the ref's but
  **our type is at the ref's own physical size**: gutter ink **9 = 9**, day-number ink **9 = 9**; the segment label's ink rows are y45..55 = 11 vs
  the ref's y19..29 = 11 (R099). **R101/R102 extend this to *controls*: both segment pills are h = 24 and both fit the same radius token — so the
  pill comparison is 1:1 and only the *slot pitch* differs (56.75 vs 64), which is a layout quantity, not a licence to scale the pill.**
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).** All five ref colours 1:2 on every channel ⇒ any "same-hue
  text/tint" on a chip is `c + (pole − c) * 0.5`. **Corollary: dark chip colours are extrapolation.**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R102).** Corner: per-row **fill-start inset** (body mode, R098; **interior
  rows, indexed from the first counted row, and validate the method on a known token — R101/R102**). Joint: per-row **`!= white` envelope**.
  Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw profile across an edge that
  abuts no rule**. Ink: **the per-channel coverage agreement test PLUS the channel-gap argument**; for a cross-capture comparison the
  **top-5%-coverage mean**, and **`n<100` as the token-vs-AA discriminator (R099)**.
- **`captureClient` RETURNS `false` ON A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075).** Pass a **flat filename**; read the
  success flag in `live-runtime-vm.log`, then `ls` the actual CWD. **Pillow crops need ABSOLUTE paths** — the shell CWD moves between calls.
- **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with
  `Owned review instance still running: <pid>`. **The R097–R102 working leg (ONE Bash call): kill `live-app.pid` → `nohup ./start-review-vm.sh
  light|dark &` → `sleep 34` → `review-command.py` with `resize`/`sidebar`/`view`/`date`/`position`/`captureClient`/`stop` → grep
  `capture <name>.png true` + the `manual stop contentY` probe.** `leg.sh` has NO `sidebar` action.
- **OUR COLUMN MAP AT 1100x692 (R071–R102):** x=0 rim; gutter x 1..51; separators at **x=52/202/352/502/652/802 in BOTH the band and the grid**,
  **pitch 150**, 7×150px delegates starting at 52. Weekend = the last two. **Sidebar x0..219; the toolbar's segment track spans x562..757 (w 196)
  centred on the main region; the lens x630..689 (w **60**) on segment 2 = Week; our segment label centres are x≈594 / 660 / 724; the capsule is
  y36..63 (28 tall, 1px `AppTheme.border` hairline top and bottom), the lens y38..61 (24) with `radius: 11.52` since R101 and `segmentWidth - 4`
  since R102; the two right round glass buttons are x1023..1048 / x1059..1084.** **Fixture day: Thu Apr 2 = 4 all-day items ⇒ 3 chips; Fri Apr 3 =
  1. The launch week (Oct 12–18) carries NOTHING, so `date 2026-10-15` is the cheapest way to get a month that CONTAINS today.**
- **THE ALL-DAY BAND'S Y-MAP (R073, light, 1100x692) — re-confirmed UNCHANGED R074–R102.** `sectionRule` **y=155** (242 light / 39 dark, 1px);
  band interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); first hour line **234** (237). Chips **157-180**, gap **181**,
  **182-205**, gap 206, **207-230**.
- **REF ALL-DAY BAND, MEASURED 1:1 (R072/R073/R075–R081 + R087).** Rows **y126-143, 145-162, 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule
  **y=124** 1px (242); bottom separator **y=183-184** 2px (217); **inset ≈1 both legs**; content **125..182 = 58**. Chip radius **≈6 = row/3**;
  fill alpha **≈0.16**; **ink = itemColor/2**; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**. Ours: row 24 / gap 1 / inset 1 /
  radius 8 / band 76 / hue ink — every *form* item matched **except the icon (仍差 #2)**.
- **REF TIMED CHIP, MEASURED 1:1 (R077–R080).** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26 px**. Fill = light desaturated
  same-hue wash (blue (222,237,254)); **text = dark same-hue = the bar at 1:2**; **left bar 2.4 px, ~3 px in, round caps**; **no border on any edge**.
- **OUR COLUMN RULES + TOKENS (R065/R067/R069/R074).** `CalendarScheduleView.qml:51-75`: `gridLine` (light `#EDEDED` / dark white@0.13),
  `gridLineMinor` (light `#F4F4F4` / dark white@0.06), `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` /
  dark white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, dark 39 < 59 < 84.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark. **Weekend columns 249 light / 37 dark; the gutter is NOT
  tinted.** **Sidebar plane light = (228,228,228); the mini month's weekend cells (214,214,215).**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at
  x ≥ 3**; compare the digits, not the bands.
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`. Chip height = **16**. Half-hour line = **20**. **R072 added the
  four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model;
  R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`;
  R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill` + the segment's repoint at `Main.qml:1715-1716`; R099 the segment's
  `mutedTextColor` at `Main.qml:1718`; R101 `LiquidSegmentedControl.qml:121` `height * 0.48`; R102 `:117` `x: 4 + …` and `:119`
  `width: root.segmentWidth - 4`.**
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed Apr 1**) + 243px
  sidebar + mini calendar. Day headers (text y108-116) → **all-day band (y 124–184)** → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328
  = **pitch 27**; the red `9:41` pill **replaces** the 10 AM label. Now-line y=238, pill/line red **(235,76,70)**. **7 equal day columns, 1px
  separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36**
  (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.** **R097/R098/R101/R102 add the toolbar row: y4..36
  in the ref, holding (left→right) the traffic dots, a 2-icon capsule at x≈122..190, a round `+` at x≈205..230, the Day/Week/Month/Year capsule
  at **x≈389..616** (track 249..253 on a 255 plane, **its vertical extent unmeasurable — R102**, selected pill **x449..499 + fit ⇒ W 52.4, h 24
  y12..35, r 11.5**, word centres 418/474/530/587), and two round glass buttons (radar, search) at x≈735..810.**
- **HARNESS COMMAND FORM IS FLAT (R064, re-confirmed R075–R102).** `harness/Main.qml` matches `command.action` only; a command with no `action`
  **silently hits the fallback**. `review-command.py` takes **ONE argv that is a JSON list**, bumps `sequence` itself, writes **in place** (never
  `os.replace`), and **sleeps 0.6 s between commands**. **launch/re-launch:** `start-review-vm.sh light|dark` blocks on `wait "$app_pid"` —
  background it; a rebuilt binary needs a **kill+relaunch** (~34 s to a usable state). Include `resize 1100x692`; the app starts in
  `--view week --date 2026-10-15` **with the sidebar COLLAPSED**. **The theme is fixed at launch — a dark leg costs a full kill+relaunch. App
  stderr → `live-runtime-vm.log`.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root
  `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06** plus a
  **`Multi-day review`** all-day strip **`20260330` → `20260403`** (Mon/Tue/Wed render as ONE chip each; Thursday does NOT carry it). **R087
  ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.**
  UID-ordered since R083 ⇒ **Thu's order is `Design sync` / `Release notes` / `R087 card C` / (`R087 card D`, hidden)**. VTODOs: `[UI] Green
  planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00,
  `[R019 LONG TASK] …`. **The rendered week also shows `[R019 LONG EVENT]`, `Prepare notes`, `Review checklist`.**
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them
  **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with
  `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.**
  `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**
- **Compositing (R077/R080/R088/R097/R099/R101/R102).** **A composite (a 1:1 strip above a 2–4× zoom) answers "overall form + local detail"
  in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes it self-describing.** **`LANCZOS` for a ×1.8 upscale of a ref
  crop; `NEAREST` when the point is pixel structure.** **R080: a `Counter` mode over a cell gives the fill in one call (R098: over the *body*
  rows).** **R097: a black-bar two-panel `old-above / new-below` ×3 stack; R099: a three-panel `ref / before / after`; R101: `ref / rA / rB`
  settles a *measured constant*; R102 adds **red guide lines at the slot boundaries** so a *relative* measurement (the inset) is legible in a
  crop whose absolute widths differ.** **No `numpy` here.**

## ## Next round (pick ONLY #1)
**#1 — the segment's slot PITCH: `Main.qml:178` `segmentWidth: 196` (= 64/slot for 3 labels) against the ref's 56.75/slot in a 227 track
(4 labels).** This is the ONLY remaining unblocked *shape* error in the control: both pills are h = 24 and both fit `r = 0.48·24`, so the
absolute widths are comparable — the ref's is **52.4**, ours is **60**, and after R102's padding fix the entire residual is the pitch.
**Do this as a measurement + a spec check first, then one number:** (a) re-derive the ref's pitch from the track's own left/right edges and its
word centres (R100: 418/474/530/587 ⇒ pitch 56, 56, 57) and from the pill's centre (474) against slot centres — **confirm 56.75 and that the
pill is centred in its slot**; (b) `grep -n "196\|segmentWidth\|28" ` the spec (`tmp/ui-acceptance/calendar/spec.md`) for L03/the toolbar item
and for `Main.qml:171`'s "196x28" provenance — **if 196 is a spec literal, STOP and record why the pill is legitimately wider; if it is not,
`Main.qml:178` `196` → `174`** (3 × 56.75 + 4) and re-capture: **expect the pill 60 → 52, the track 196 → 174, the label centres x≈594/660/724 to
tighten toward the ref's pitch, and the pill's radius fit to stay at ~11.5.** **Do not touch `:87` (track radius) or `:121` (lens radius).**

**Then:** #2 the ruling-blocked list in 仍差 order — the **Year segment (new, needs a view)**, the band ring icon (H), the 12-hour two-tone gutter
labels (F), the dim snap (A), the shadow magnitude (B), the month `slice(0,2)` (D), the band chips' inset (G).

**Blocked / open on rulings A–H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E;
clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2–3) vs the
ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel exists anywhere in the tree.** **Also unmeasured, no ruling needed, but NOT
this round's item: the TRACK's radius (`:87` `height * 0.38` = 10.64) and the ref track's vertical extent (R102: unmeasurable).**
**`code-writer` is STILL not registered in this session (do not retry it each round) — R097 used `general-purpose` as the stand-in implementer;
R098/R099/R100/R101/R102 were done inline.**
**Not `DONE` — all spec IDs do not pass.** (T01/T02/T03 and **A01** PASS-pending-final-regression; **A03** PASS; **A04** fully PASS; **E01/E02
clauses 1+2+3 PASS** and the band ink PASS (R080); **N02 closed on both legs (R085)**; **A02 closed R087**; **M04 closed R093 + R094**;
**M03/M02/M01/S02/S03/S05/L01–L07/C01–C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**; **C05: clause 1's structural half
CLOSED R097, dark leg CLOSED R098, label-token residue CLOSED R099, label ORDER CLOSED R100, pill radius CLOSED R101, pill horizontal padding
CLOSED R102 — what remains of C05 is the pointer half (no harness action drives it), the slot pitch (Next #1) and the label COUNT (ruling-blocked).**)
