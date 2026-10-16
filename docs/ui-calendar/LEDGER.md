# R038 — D01/D02/D03 measured in-app on an existing capture → **all three PASS** (2026-10-16, light)

## 本轮 (R038)
Atomic step: Next-round #1 — measure D01 (scrim) / D02 (radius) / D03 (surface+border+shadow) on the capture we
already had. **No product code touched, no relaunch, no new screenshot.** Baseline = `r037-pop-light.png`
(popover open, **no scrim** — verified: (150,600) = 255,255,255), subject = `r037-after-click-light.png`.

**Dialog card geometry (first exact measurement).** Outer surface = **x368..747 (380 wide), y77..636 (560 tall)**,
i.e. exactly `width: Math.min(380, pw−48)` / `height: Math.min(560, ph−64)` for the 1100x692 client
(`CalendarTaskEditorDialog.qml:21-22`). Not clipped, not shrunk. Fill = flat **(247,247,247) = #F7F7F7**.

**D01 scrim → PASS.** Ratio subject/baseline_r = **0.798–0.800** at 11 probe points, including all four corners
(20,4) (1080,4) (20,688) (1080,688) and mid-edges ⇒ uniform **black @ α = 0.20**, whole window, multiplicative
(verified on pure white *and* on tinted pixels: (216,234,245)→(173,187,196), 253,233,191→202,186,153). Chrome
under the scrim stays readable. Not a pure-black mask, not a partial-coverage overlay.

**D02 radius → PASS, with one recorded deviation.** Corner fit (walk the arc at 4 thresholds, least-squares on the
circle) gives **R = 13.9–14.6**; the tangent/convergence reading gives **15–16** — i.e. the rendered value is the
code's `AppTheme.smallRadius + 4` = **16** (`CalendarTaskEditorDialog.qml:56`, identical at
`EventEditorDialog.qml:35`). No right angles. **Deviation: 16 is neither `largeRadius` (24) nor
`windowCornerRadius` (32)**, the two tokens D02's parenthetical names. Kept as PASS because (a) it is
token-derived, not ad-hoc; (b) it is the calendar app's established dialog value — 2/2 dialogs use exactly
`smallRadius + 4`, while inner fields use `smallRadius` (12) and `KosSurface`'s own default is `mediumRadius` (20);
(c) macOS alert panels are ~10–12pt, so 16 is *closer* to the reference platform than 24 — changing to 24 would
move away from the reference. Escalated to 外推待确认; the literal fix would be 2 edits.
Also recorded, not called a defect: KosSurface draws the surface rect's 1px `AppTheme.border` **plus** an inset 1px
`innerHighlight` (`KosSurface.qml:74-80`) = two concentric 1px lines. That is the shared *card* treatment (every
KosSurface in the app has it), not dialog-specific; visually it reads as a hairline + faint inner rim.

**D03 surface/border/shadow → PASS.** Reading the corner at 5× (`/tmp/r037-tl5x.png`) plus edge profiles
(dialog shot vs `0.8 × pop` baseline, which isolates the shadow to ±1 unit):
| element | measured |
|---|---|
| fill | 247,247,247 flat = **#F7F7F7** — NOT `cardSurface`. Deliberate: `P02` calendar-local neutral panel, same value in **both** dialogs. Recorded, not a defect. |
| 1px border | darkest ring **Δ−21** (right x747 = 183 vs 204) / **Δ−17** (left x368 = 187) / **Δ−20** (top y77 = 184 vs 204); expected for `border` = rgba(26,41,64,0.14) over the scrimmed bg ≈ Δ−25. Blue-tinted, no black. |
| shadow — extent | **~2px sideways** (x366..367 left, x748..749 right), **~7–8px below** (y637..644), **0px above** (y76 = 204 exactly) ⇒ offset +2px downward, as coded (`KosSurface.qml:26,42` `y: root.y + 2`) |
| shadow — layers | both present. Ambient `x−2,w+4,y+2,h+5,radius+3` @ `elevation`; Key `x−1,w+2,y+2,h+2,radius+1` @ `elevation×0.72`; `elevation` 0.5 × 0.38 (modernDesign) = **0.19** |
| shadow — strength | peak **Δ−10** at 1px below, then Δ−7,−7,−4,−4,−3,−3,−1 → smooth ramp = 2 layers reading as one soft falloff. Sides peak Δ−5/−1. Max ≈ **3.9%** opacity. No pure-black hard halo. |
| bottom inner highlight | 1px at **y635** (last row inside the surface) = 251 vs fill 247 → +4; matches `innerHighlight` rgba(1,1,1,0.58) over 247 (≈252) |
Two chrome artifacts must not be mistaken for shadow: a **full-width 2px grey band at y636–637** (present in *both*
shots; unscrimmed 223,225,228 — an app separator) and a **grid line at y640** spanning the day view.

**Verdict: D01 PASS · D02 PASS (deviation recorded) · D03 PASS.** All three were PENDING since R01 — now measured,
not assumed. The one thing a strict eye should still dislike is *magnitude*: at ~3.9% peak the card reads as a flat
white panel with a hairline rather than an elevated card. That is a **visual-quality** gap, not letter non-compliance
(D03 asks only that both shadow layers exist, be soft, and be free of a black halo), and the restraint is deliberate
(`modernDesign` 0.38 factor) and app-wide. Left as 仍差 #1 for the loop owner to rule on.

## 仍差 (top 8, visual-impact order)
1. **Shadow magnitude** (D03 follow-up, not letter compliance): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at
   1px. Changing it means touching `KosSurface.effectiveElevation`/the `0.38` factor — **app-wide**, affects every
   card. Needs an explicit ruling before anyone edits it. Do not "fix" silently.
2. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs the spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16 (see 本轮).
3. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
4. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
5. Task-dialog footer never captured in **dark** (shape shared with the dark-PASS event dialog ⇒ extrapolation only).
6. P01 long-text (fixtures restored R025, never re-judged); O01–O03 tooltip; O08/X07 four-overlay coordination.
7. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**. Never checked vs ref.
8. `buttonNeutralHover`/`Pressed` never captured; no button was hovered in R037 ⇒ no hover test has ever run.

## 最近已改 (most recent 8)
1. R038 — measurement only, **no code change**; D01/D02/D03 → PASS.
2. R037 — verification only, no code change; D05 task variant → PASS; R036's pointer blocker retracted.
3. R036 `CalendarTaskEditorDialog.qml` — footer override + labelSource/footerCol (Save/Cancel/Delete), in-form Delete removed.
4. R035 `AppTheme.qml:107` — dark `buttonNeutral` mixes from neutral #262626 ⇒ (69,69,69).
5. R034 — measurement only; D05 event footer → PASS (dark).
6. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.
7. R032 — verification only; D07 premise corrected.
8. R031 `KosButton.qml` `+flatPrimary` + `EventEditorDialog.qml:227`.

## 外推待确认 (do NOT assume)
- **D02's radius is 16, not 24.** `smallRadius + 4`, in both dialogs. See 仍差 #2 — needs a human ruling, not an edit.
- **D03's fill is `#F7F7F7`, not `cardSurface`.** Deliberate P02 override, identical in both dialogs. Light
  `AppTheme.card` (`:94`) is a blue-gray `mix(windowRaised, accent, 0.018)`; do not "restore" it.
- **`D03` shadow magnitude is ~3.9%.** Present and double-layered, but far weaker than the macOS reference. Pending ruling.
- **D06/D07 are HIG-convention matches, not reference-pixel matches** — `.loop/refs/macos-calendar.png` (814x522) has
  **no alert/dialog at all**. Also true of D01/D02/D03: they were judged against the repo's own tokens + platform
  convention, never against a reference-dialog pixel. Do not re-derive.
- macOS alerts have no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Accent measured (48,140,198) in both themes; `defaultAccentSeed` is #3478f6. Unresolved which one D06 is judged against.
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old outlined
  secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:168` × densityScale ≈0.912 ⇒ 31). Do not "fix".
- **Dark `buttonNeutral`'s neutral #262626 is this profile's *rendered* surface, asserted by measurement, not a token.**
- **Capture = the harness `captureClient` action** (`harness/Main.qml:122`, `ReviewInput.cpp:59` `window->grabWindow()`).
  Wait for the png **and** the `native app client capture <path> true` line. `capture` (bare) falls through to manual/timeline.
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** A targetless `pointer`'s
  `hover n/a down n/a` log line means nothing; `pointer {"target":…}` prints `NaN NaN` (Main.qml can't see Popup overlays).
- `{"action":"pointer","kind":"click"}` is a **no-op** (`ReviewInput.cpp:67-92` maps only `press`/`release`).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `openItem` (`harness/Main.qml:225`) needs `selectedItems` non-empty; `kind` = `"todo"`/`"event"`; it logs nothing.
- The review app is **not** left running between rounds (`kill "$(cat live-app.pid)"`; `pkill -f` kills the driving shell too,
  exit 144). `start-review-vm.sh` blocks — run it backgrounded.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).

## Next round (pick ONLY #1)
**D10 — KosDialog's reveal animation (opacity 0→1 + scale 0.96→1), captured as consecutive frames.**
This is the last *behavioural* item and the only one that can never be judged from a static shot.
Plan: relaunch light, drive to the open dialog exactly as R037 did (`date 2026-04-02` → settle → `view day` →
`openItem {kind:"todo", titleContains:"Green planning"}` → `pointerObject detailsEdit` move/press/release @ (682,376)),
and burst `captureClient` immediately after the press/release so the png sequence catches mid-transition
(`AppTheme.motionNormal` = 220ms ⇒ at ≥5 fps expect ~1–2 in-flight frames; if every frame is already at rest,
say so explicitly rather than claiming the animation passed). Then measure the card's **opacity** (fill 247 vs
background) and its **bounding-box width** (380 at rest; ~365 at scale 0.96) per frame — those two numbers alone
tell whether `revealProgress` actually ramps. Fallback if the burst cannot outrun 220ms: raise `motionNormal`
via the harness only if such a knob exists; otherwise record the blocker and move to 仍差 #4.
