# R044 — two fresh runs, two recorder intervals: the enter is **220ms** in both ⇒ R043's 440ms does **not** reproduce (2026-10-16, light)

## 本轮 (R044)
Atomic step: Next round #1 of R043 = finish the interval-60 control on a **fresh** enter. Measurement only,
**no product code touched**. The R043 instance was killed (its pid file pointed at a live `kos-calendar`; it is
not left running between rounds) and the app was restarted twice, once per leg.

Route, identical in both legs (FLAT command fields, per R043's trap): `date 2026-04-02` → `view day` →
`date 2026-04-02` → `openItem {kind:"todo", titleContains:"Green planning"}` → `pointerObject detailsEdit` move
(resolves (682,376), `found:true`) → burst, then 0.20/0.30/0.40s later move/press/release on `detailsEdit` —
byte-identical trigger timing to R043. Driver: `r044-drive.py <tag> <interval>`.

**Probe upgraded, and this is what made the round decisive.** R043's geometric read (pill left edge,
`s=(557−left)/173`) has only **7px** of travel for the full 0.96→1.00 scale, so ±1px quantisation = ±0.14 in `p`
— it cannot separate 220 from 440. Replaced with a **calibrated blend probe**: five points inside the card's
empty band (y≈490, x∈{450,557,660}; y≈470, x∈{430,690}), each calibrated against its *own* pre-dialog backdrop
measured from the last undimmed frame (`backdrop = pre × 0.8`), α = (m − backdrop)/(247 − backdrop). Range is
~49 grey levels instead of 7px, and it self-checks: at the dim's first frame every point reads exactly α=0.00,
and α lands on 1.00 and stays. All five points agree to ±0.01 at every frame (three distinct backdrops).

| leg | frames | pacing (idle → during anim) | α(t) | OutCubic fit | t0 |
|---|---|---|---|---|---|
| **c60** (interval 60, dur 1200) | 19, 61→1156ms | 60ms → 60ms (**flat**) | 0.00 @482(dim off) · 0.34 @547 · 0.89 @635 · 0.98 @685 · 1.00 @752 | **D = 225ms** (547→635 pair); 685 predicted 0.983 vs 0.98 measured | 518ms |
| **c12** (interval 12, dur 1200) | 30, 13→1197ms | 33ms → **62ms** (2× starvation) → 33ms | 0.00 @358 · 0.49 @405 · 0.84 @461 · 0.98 @523 · 1.00 @581 | **D = 219ms** (405→461), **D = 228ms** (461→523) | 361ms |

**Both legs ⇒ D ≈ 220ms = declared `motionNormal` (`AppTheme.qml:175`), within 4%.** The geometric axis
corroborates on c60: strict accent match puts the pill's left edge at its final 384 from 685ms on (not
detectable at 547/635 because the ramp leaves the ±14 colour window), and 388 @547 by loose hue — the same
ordering the α curve gives.

**Neither predicted outcome occurred.** The control was pre-registered as a fork: shrink below 440 ⇒ the burst
stretches time; stay at 440 ⇒ the product is genuinely 2×. It returned **220ms at interval 60**, i.e. R043's
440ms **does not reproduce**, and the pre-registered "instrument stretches time ~2×" reading is **refuted** by
its own control — c12 starved exactly as R043's run did (33→62ms pacing) and still reported the animation
honestly at 220ms. The two legs agree with each other and with the declared duration.

**Where the two runs diverge, with numbers.** R043's *early* points match mine: their α=0.47 at Δt≈47ms after
the dim vs my 0.49 at Δt≈44ms. The split starts at Δt≈120ms — mine 0.84, theirs 0.69 — and widens (Δ197:
mine ≈1.00, theirs 0.84; Δ274: theirs 0.94). Their capture deltas over the same frames grew 47→73→77→77→82→85;
mine grew 41→43→39→47→56→62→58→61 then fell back to 33. So R043's instance was under heavier capture load
*and* reported a slower animation, while a moderately starved instance does not. That correlation is left as
**the open question** — I have not shown *why* heavy load would delay a wall-clock animation, only that a
moderate load does not. Not papered over.

**Dim snap re-confirmed on both fresh runs, and it now has a sharper shape:** the page goes 255→204 in a single
frame while the card sits at **α=0.00 in that very frame** — c60 482→547ms, c12 319→358ms. The dim therefore
leads the card's first non-zero frame; it is a separate un-animated step, exactly as
`KosWorkspaceDialog.qml:24-27` predicts (`Overlay.modal` is a plain `Rectangle`; `KosDialog.qml` animates only
`revealProgress`). 仍差 #1 unchanged and now measured on three independent enters.

**Verdict: 仍差 #2's retraction stands, now on direct evidence rather than on a pre-registration.** Next round #1:
the exit half has never been measured at honest sampling — R042's 240ms (2× declared `motionFast` 120) was taken
with R043's method and is now suspect for exactly the same reason. Re-measure it with this probe.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`, so it can only be on/off. **Measured on three enters (R043, R044-c60, R044-c12)**: the page steps
   255→204 in one frame with the card still at α=0.00. App-wide (every workspace dialog). Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **Form compresses instead of scrolling at 760x540** (R041-corrected): notes viewport **96 → 39px**, card
   555 → 471. `CalendarTaskEditorDialog.qml:32-33` claims "only the form above it scrolls". App-wide sibling: the
   event editor shares the shape. Same class as #1 (comment says one thing, layout another).
4. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16.
5. Card centre sits **+7px right** of window centre at both window sizes, both themes (R041). Cosmetic.
6. P01 long-text (fixtures restored R025, never re-judged); O01–O03 tooltip; O08/X07 four-overlay coordination.
7. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never
   checked vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered.
8. **Exit duration never measured at honest sampling.** R042's exit ≈240ms (2× declared `motionFast` 120) came
   from R043's method; the enter measured by that same method was 2× too long. Slot marker pending the
   re-measurement — if the exit reads ≈120ms the slot closes for good; if it reads ≈240ms, re-file as a real D10
   deviation *on the exit only*.

## 最近已改 (most recent 8)
1. R044 — measurement only, **no code change**; five-point calibrated α probe introduced; enter = **220ms at both
   interval 60 and interval 12** (declared `motionNormal` 220); R043's 440ms does not reproduce; "instrument
   stretches time" refuted by its own control; dim snap re-measured on both fresh enters; "review app is not left
   running between rounds" honoured.
2. R043 — measurement only, no code change; enter ⇒ **2× declared** on two axes (geometric + blend), dim snap
   structurally confirmed, 仍差 #2 retracted; `args`→flat command schema trap documented.
3. R042 — measurement only, no code change; D10 exit **scale** → PASS (0.971 vs 0.9728 declared), 仍差 #5 closed.
4. R041 — measurement only, no code change; dark task-dialog footer → PASS, 仍差 #6 closed; light≡dark layout
   established; R040's narrow notes number corrected 73 → 39px.
5. R040 — measurement only, no code change; D11 → PASS; `nativeRecord`-across-resize recipe established.
6. R039 — measurement only, no code change; D10 `KosDialog` enter half → PASS, dim-snap escalated.
7. R038 — measurement only, no code change; D01/D02/D03 → PASS.
8. R037 — verification only, no code change; D05 task variant → PASS.

## 外推待确认 (do NOT assume)
- **A fresh enter needs an app restart.** After `escape` the day-view selection is gone and the route does NOT
  restore it: `date`/`view`/`date`/`openItem` leaves `detailsEdit` resolving to (682,376) with `found:true` for
  move/press/release, but the click is **inert** (page stayed 255 for all 19 frames of two R043 attempts).
  `openItem` is a silent no-op on an empty `selectedItems`. Restart via `start-review-vm.sh light` and `kill` the
  pid in `live-app.pid` first — **the pid file goes stale, so `kill` it by content, never `pkill -f 'kos-calendar'`:
  that pattern matches the driving shell itself** and killed the tool call (exit 144) once this round.
- **The α probe is the instrument of record.** Backdrop must be measured per point from the last *undimmed* frame
  and scaled ×0.8; α = (m − backdrop)/(247 − backdrop). Self-checks: α=0.00 at the dim's first frame, α=1.00
  thereafter. The pill left edge is only a ±0.14-in-p resolution cross-check, never the primary read.
- **Frame pacing degrades under capture load, reported timing does not.** interval 12: deltas 33ms idle → 62ms
  during the animation → 33ms after; the α curve over the same frames still fits OutCubic 220ms to within 4%.
  interval 60: deltas flat at 60ms through the animation. So `elapsedMs` is trustworthy at both intervals and a
  sparse-but-honest sample beats a dense-but-starved one.
- **Harness command fields are FLAT** (`Main.qml:217/221/225`): `command.date`, `command.view`, `command.kind`,
  `command.titleContains`. **`args` nesting is a silent no-op that still advances `sequence`** — it looks like it
  ran. Verified: `review-command.py` passes a JSON array through verbatim.
- **The recorder is wall-clock** (`Main.qml:24`, `Date.now() − nativeRecordStarted`) behind a QML `Timer`
  (`:19-22`) whose blocking `capture()` (`:36`) starves the loop. Poll timer for `command.json` is `interval:100`
  (`:98-100`), so command latency is 0–100ms; in-place write only (an atomic replace trips the QML dir watcher).
- **The dim gone ⇒ page 255, present ⇒ 204** at (1040,400) in light (0.20). A genuine discontinuity no clock
  error can manufacture; it is the most reliable **t0 anchor** for a dialog transition.
- **`pointerObject` needs THREE commands, one per event: `kind` ∈ {`move`,`press`,`release`}.** There is no
  `events` array — `harness/Main.qml:131-135` forwards `command.kind` to `ReviewInput.cpp:67`. A single call with
  an unknown/absent kind silently sends one `MouseMove` (`.cpp:73` initialises `type = MouseMove`) and **closes
  nothing**.
- **`capture` is NOT a harness action.** It falls through to the manual branch (`harness/Main.qml:249`) and prints
  only `contentY/width/height/contentHeight` — **it saves nothing**. Use `captureClient` (works pre-resize; returns
  a stale 1100x692 buffer after a resize, reproduced 5×) or `nativeRecord`.
- **`nativeRecord` is the burst mechanism** (`harness/Main.qml:112-121`): `{action:"nativeRecord", prefix, duration,
  interval}` → `<prefix>-NNNN.png`. Reported `duration` = requested + one interval; real spacing ≈ interval + ~21ms
  at interval 12 when idle, up to ~62ms under animation load, and ~60ms flat at interval 60.
- **Frames track `resize`, `captureClient` does not** (R040/R041): burst first, resize second, read frame 3+.
- Prefixes are relative to the app's CWD = **repo root**, not `tmp/ui-acceptance/calendar/`.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark** — not KosDialog, not the calendar
  app. `CalendarTaskEditorDialog.qml:8` extends `KosWorkspaceDialog`.
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)). Locate a light
  field box by its **border** (222,224,226) only; fill-based probes over-reach (this is how R040 got 73px).
- **D02's radius is 16**, not 24 (`smallRadius + 4`, both dialogs). **D03's fill is `#F7F7F7`**, not
  `cardSurface` — deliberate P02 override, identical in both dialogs.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion`
  (`:26`, false here). **No duration scale exists in AppTheme.**
- The task dialog's footer buttons are **full-width stacked** (保存 accent pill spans x 384–730, centre 557;
  取消 below it) — not macOS's content-sized right-aligned row. Already recorded as a HIG-convention match.
- **D06/D07 are HIG-convention matches, not reference-pixel matches** — `.loop/refs/macos-calendar.png` (814x522)
  has **no alert/dialog at all**. Same for D01/D02/D03/D10.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6. Unresolved which D06 is judged
  against. macOS alerts have no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:171` × densityScale ≈0.912 ⇒ 31).
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
- Save is deliberately NOT exercised (isolated-profile discipline).

## Next round (pick ONLY #1)
**Measure the exit's decay at honest sampling — the last unmeasured half of the same question.**
R042's exit ≈240ms (2× declared `motionFast` 120) was taken with R043's method, and this round showed that method
over-reports the *enter* by 2×. So 仍差 #8 is now the only live timing claim.
- `start-review-vm.sh light` (kill the pid in `live-app.pid` first, by content), run the flat route once to open
  the task editor, then `nativeRecord {prefix:"tmp/ui-acceptance/calendar/r045-exit", duration:1200,
  interval:12}` and ~0.3s later a single `escape` (or `pointerObject` on 取消 / the dim).
- Probe the **same five card points** with the same backdrop calibration; the card's α *decays* 1.00 → 0 here, so
  fit OutCubic on the decay. Re-run the same leg at `interval:60` for the pacing cross-check.
- Reads **≈120ms** ⇒ the exit matches declared `motionFast`; close 仍差 #8 permanently and record D10 as a full
  pass on both halves. Reads **≈240ms** ⇒ the exit really is 2× and gets re-filed as a D10 deviation affecting the
  exit only — then look for a second animation on the same property (`KosDialog.qml:24-32` had exactly one, so a
  doubled consumer would have to live elsewhere).
Report which, with numbers, before touching any code.
