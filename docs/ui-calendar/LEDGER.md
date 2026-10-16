# R042 — D10 exit half: **scale-down measured and it matches the declaration** (2026-10-16, light)

## 本轮 (R042)
Atomic step: Next-round #1 = 仍差 #5 — the one D10 criterion never measured, the **exit** scale-down.
Verification round, **no product code touched**.

Route (light): `date 2026-04-02` → `view day` → `date 2026-04-02` → `openItem {kind:"todo",
titleContains:"Green planning"}` → **three separate commands** `pointerObject detailsEdit` kind `move` / `press` /
`release` (each found at (682,376)) → 编辑任务 open → burst-first: `nativeRecord {prefix:…/r042-exit,
duration:1000, interval:12}` then `escape` written 0.6s later. 30 frames, elapsed **13 → 975ms**, spacing ~33ms
(reported duration 1006). Escape landed between frame 0018 (615ms) and 0019 (649ms).

Probe: the **Save pill** (48,140,198 on card 247) is the high-contrast feature — the card fill alone is useless
here (247 vs the 255 page = 3%, quantisation eats the whole fade). Pill row y=531, and the card's top edge at x=557.

| frame | ms | pill x | pill opacity p (blend 48→255) | card opacity implied |
|---|---|---|---|---|
| 0017 | 579 | 383..731 | 1.00 | 1.00 |
| 0018 | 615 | 383..731 | **1.00** | 1.00 |
| 0019 | 649 | 383..731 | **0.70** | dim already gone |
| 0020 | 682 | 383..731 | 0.70 | plateau |
| 0021 | 715 | 384..731 | 0.68 | |
| 0022 | 749 | 384..730 | 0.65 | |
| 0023 | 782 | 385..730 | 0.58 | card top 516 → 515 |
| 0024 | 815 | 386..728 | 0.47 | card top 514 |
| 0025 | 849 | **388..726** | 0.32 | card top 513 |
| 0026 | 882 | — | 0 | gone |

**Verdict on the scale: PASS.** The pill's box contracts **symmetric about the card centre** (x 557): left
383 → 388 (+5), right 731 → 726 (−5), and the card's top edge at x=557 moves 516 → 513 (−3; predicted from the
same transform: 355.5 + 160.5·s). At frame 0025, p = 0.32 ⇒ declared scale `0.96 + 0.04·p` = **0.9728**;
measured from both pill edges = **0.971**. Two independent axes, matching to 0.2%. So `KosDialog.qml:10`'s
`scale` is genuinely driven by `revealProgress` on exit too, not just on enter — **仍差 #5 closed**.

**The exit's *timing* does not match the declaration, and the dim snap is sharper than R039 recorded.** The fade
runs 1.00 → 0 over **~230–250ms** (first change at 649, gone at 882), i.e. ≈2× the declared `motionFast` **120**
(`AppTheme.qml:174`); and **the dim (`Overlay.modal`, 0.20) leaves inside a single 34ms frame at 649 — the very
first frame of the exit**, not "70–100ms before the card finishes" in the sense of a late snap: it goes at the
*start*, in one frame, while the card is still at full scale. R039's observation is confirmed and sharpened.

**Confound, and the reason this is not a product verdict yet:** the mid-fade rate is *far* too slow for any
single InCubic — fitting 649→782 (p 0.70→0.58, Δt 0.08) against a 120ms curve would need D≈1660ms, and against
220ms D≈660ms. The shape (a 1–2 frame plateau at 0.70, then slow drift, then a fast finish) is what you'd get
if the burst's own `grabWindow` loop perturbs the animation clock. **Until a control is run, the duration number
is not evidence of a product defect** — see Next round.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): in light it leaves in **one frame at the
   start of the exit** (R042), not merely "early". App-wide (every workspace dialog). Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to the dialog's `revealProgress`. Do not "fix" silently.
2. **Exit timing / burst confounding** (R042, new): measured fade ≈230–250ms vs declared `motionFast` 120. Must be
   de-confounded by an identical burst over the **enter** (declared 220ms OutCubic) before it counts as a defect.
3. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
4. **Form compresses instead of scrolling at 760x540** (R041-corrected): notes viewport **96 → 39px**, card
   555 → 471. `CalendarTaskEditorDialog.qml:32-33` claims "only the form above it scrolls". App-wide sibling: the
   event editor shares the shape. Same class as #1/#2 (comment says one thing, layout another).
5. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16.
6. Card centre sits **+7px right** of window centre at both window sizes, both themes (R041). Cosmetic.
7. P01 long-text (fixtures restored R025, never re-judged); O01–O03 tooltip; O08/X07 four-overlay coordination.
8. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never checked
   vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered.

## 最近已改 (most recent 8)
1. R042 — measurement only, **no code change**; D10 exit **scale** → PASS (0.971 measured vs 0.9728 declared),
   仍差 #5 closed; exit duration and the one-frame dim snap escalated with a confound caveat.
2. R041 — measurement only, no code change; dark task-dialog footer → PASS, 仍差 #6 closed; light≡dark layout
   established; R040's narrow notes number corrected 73 → 39px.
3. R040 — measurement only, no code change; D11 → PASS; `nativeRecord`-across-resize recipe established.
4. R039 — measurement only, no code change; D10 `KosDialog` enter half → PASS, dim-snap escalated.
5. R038 — measurement only, no code change; D01/D02/D03 → PASS.
6. R037 — verification only, no code change; D05 task variant → PASS.
7. R036 `CalendarTaskEditorDialog.qml` — footer override + labelSource/footerCol (Save/Cancel/Delete).
8. R035 `AppTheme.qml:107` — dark `buttonNeutral` mixes from neutral #262626 ⇒ (69,69,69).

## 外推待确认 (do NOT assume)
- **`pointerObject` needs THREE commands, one per event: `kind` ∈ {`move`,`press`,`release`}.** There is no
  `events` array — `harness/Main.qml:131-135` forwards `command.kind` to `ReviewInput.cpp:67`. A single call with
  an unknown/absent kind silently sends one `MouseMove` (`.cpp:73` initialises `type = MouseMove`) and **closes
  nothing**; the log line prints `pointerObject <target> undefined {...}`. This cost R042 one wasted cycle.
- **The burst's `grabWindow` loop may perturb the animation clock** — a 120ms fade measured ~2×. Any animation
  *duration* read off a burst is suspect until an identical burst is run over a known duration (the enter).
- **The Save pill is the only high-contrast opacity probe inside the card in light** (48,140,198 vs 247 card).
  Card fill 247 vs page 255 (3%) is useless once the dim lifts; `(255−v)/(255−48)` recovers p to ~1%.
- **Dim gone ⇒ page white (255)**, dim present ⇒ 204. That single-step test dates the dim's exit to the frame.
- **`capture` is NOT a harness action.** It falls through to the manual branch (`harness/Main.qml:249`) and prints
  only `contentY/width/height/contentHeight` — **it saves nothing**. Use `captureClient` (works pre-resize; returns
  a stale 1100x692 buffer after a resize, reproduced 5×) or `nativeRecord`.
- **`nativeRecord` is the burst mechanism** (`harness/Main.qml:112-121`): `{action:"nativeRecord", prefix, duration,
  interval}` → `<prefix>-NNNN.png`. Completion log prints every frame's `path/elapsedMs/saved/visible`. Reported
  `duration` = requested + one interval; real spacing ≈ interval + ~21ms (12 → 33ms).
- **Frames track `resize`, `captureClient` does not** (R040/R041): burst first, resize second, read frame 3+.
- Prefixes are relative to the app's CWD = **repo root**, not `tmp/ui-acceptance/calendar/`.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark** — not KosDialog, not the calendar
  app. `CalendarTaskEditorDialog.qml:8` extends `KosWorkspaceDialog`.
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)). Locate a light
  field box by its **border** (222,224,226) only; fill-based probes over-reach (this is how R040 got 73px).
- **D02's radius is 16**, not 24 (`smallRadius + 4`, both dialogs). **D03's fill is `#F7F7F7`**, not
  `cardSurface` — deliberate P02 override, identical in both dialogs.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
- **D06/D07 are HIG-convention matches, not reference-pixel matches** — `.loop/refs/macos-calendar.png` (814x522)
  has **no alert/dialog at all**. Same for D01/D02/D03/D10.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6. Unresolved which D06 is judged against.
- macOS alerts have no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old outlined
  secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:171` × densityScale ≈0.912 ⇒ 31).
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `openItem` (`harness/Main.qml:225`) needs `selectedItems` non-empty; `kind` = `"todo"`/`"event"`; it logs nothing.
- The review app is **not** left running between rounds. Save is deliberately NOT exercised (isolated-profile discipline).

## Next round (pick ONLY #1)
**De-confound the burst — run the identical recipe over the ENTER.** Open the 编辑任务 dialog in light (route
above), then in one batch send `nativeRecord {prefix:"tmp/ui-acceptance/calendar/r043-enter", duration:1000,
interval:12}` and **0.6s later the three `pointerObject detailsEdit` move/press/release commands** that open it.
The enter is declared **220ms OutCubic** (`KosDialog.qml:18-24`), four times longer than the exit, so it is the
clean control: probe the Save pill's opacity with `(255−v)/(255−48)` at (400,531) and its x-extent per frame.
- If the enter also measures ≈2× long (~440ms), the burst loop is the cause ⇒ 仍差 #2 is an artifact, delete it,
  and the exit's 120ms stands (modulo the dim snap, 仍差 #1, which is *not* confounded — it is a one-frame step
  and no clock error can manufacture that).
- If the enter measures ~220ms, the burst is honest ⇒ the exit really is ~2× its declared duration; then read
  `KosWorkspaceDialog.qml` for a second transition on the same property and file it as a real D10 deviation.
Report which, with numbers, before touching any code.
