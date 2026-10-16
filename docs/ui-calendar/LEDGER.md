# R040 — D11 narrow 760x540 footer → **PASS** (2026-10-16, light)

## 本轮 (R040)
Atomic step: Next-round #1 — D11, "narrow 760x540: the footer must not clip or wrap".
No product code touched (verification round, like R037–R039).

**The blocker is closed first.** `captureClient` after `resize` really is useless (reproduced again — `r040-taskdialog.png`
is 1100x692 *after* the dialog opened). But **`nativeRecord` frames are NOT stale**: `{action:"nativeRecord",
prefix:"r040-narrow",duration:1800,interval:80}` issued ~600ms *before* `{action:"resize",width:760,height:540}` →
frame 0007 (722ms) is still 1100x692, frame 0008 (801ms) is **760x540**. The resize lands inside one 80ms frame;
22 frames, all saved+visible. **Recipe for any future resize round: burst first, resize second, read frame 3+.**

Route: light → `date 2026-04-02` → `view day` → `openItem {kind:"todo",titleContains:"Green planning"}` →
`pointerObject detailsEdit` move/press/release (edit pill measured at **(682,372)**; R039 logged 376) → task dialog
open → burst + resize. Probed on the settled frame `r040-narrow-0021.png` (1763ms), strict `#F7F7F7`:

| | measured | declared |
|---|---|---|
| card | x **200..574** (375 w), y **44..514** (471 h) in 760x540 | `min(380, w−48)` = 380, `min(560, h−64)` = 476 |
| Save | y 396..427, **32px** | 34 control height |
| Cancel | y 433..464, **32px** | |
| Delete | y 470..501, **32px** | |
| row gaps | **5px** | `spacing: 6` (`CalendarTaskEditorDialog.qml:78`) |
| side insets | buttons x 213..561 → **13px** from each card edge | `16 + col.implicitHeight + 16` (`:62`) |
| clearance | card bottom 514 vs window 540 → **26px** spare | |

The ~3px shortfall on every declared number is the button's soft edge eating antialiased pixels — it appears
identically at 1100x692, so it is measurement bleed, not compression. All three labels (保存 / 取消 / 删除任务)
render **single-line, centred, no ellipsis, no wrap**. Card width is 375 at **both** window sizes ⇒ the 380 clamp is
never horizontally binding. **D11 PASS** — no clip, no wrap, footer intact at the narrowest supported window.

**New observation, ESCALATED not fixed — the form compresses instead of scrolling.** `CalendarTaskEditorDialog.qml:32-33`
asserts "only the form above it scrolls". At 760x540 it does not scroll, it *squeezes*: card 555 → 471 (−84px) and the
**notes viewport shrinks 96 → 73px** (wide: field box y 359..455 = 97px; narrow: y 323..395 = 73px; vs
`Layout.preferredHeight: 96` at `:314`). Nothing is hidden — the notes box is the last form element and sits fully
above the footer — which is exactly why D11 still passes. But a 23px collapse of a `Flickable`-backed viewport at the
minimum window diverges from the stated design, and a shorter window would keep collapsing it. Recorded, not fixed.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (R039, `KosWorkspaceDialog.qml:24-27`): full 0.20 dim at card-opacity 0 on
   enter; dim gone ~70–100ms before the card finishes on exit. App-wide (every workspace dialog). Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to the dialog's `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **Form compresses instead of scrolling at 760x540** (R040): notes viewport 96 → 73px, card 555 → 471.
   `CalendarTaskEditorDialog.qml:32-33` comment claims otherwise. App-wide sibling: the event editor shares the shape.
   Needs a ruling — and it is the same class of divergence as #1/#2 (comment says one thing, layout does another).
4. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16.
5. D10 exit half: fade present but only one intermediate sample observable; **exit scale-down unverified**.
6. Task-dialog footer never captured in **dark** (shape shared with the dark-PASS event dialog ⇒ extrapolation only).
   Both dialogs now measured in light at wide **and** narrow.
7. P01 long-text (fixtures restored R025, never re-judged); O01–O03 tooltip; O08/X07 four-overlay coordination.
8. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never checked
   vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered.

## 最近已改 (most recent 8)
1. R040 — measurement only, **no code change**; D11 → PASS; `nativeRecord`-across-resize recipe established;
   form-compression escalated as 仍差 #3.
2. R039 — measurement only, no code change; D10 `KosDialog` half → PASS, dim-snap escalated.
3. R038 — measurement only, no code change; D01/D02/D03 → PASS.
4. R037 — verification only, no code change; D05 task variant → PASS.
5. R036 `CalendarTaskEditorDialog.qml` — footer override + labelSource/footerCol (Save/Cancel/Delete).
6. R035 `AppTheme.qml:107` — dark `buttonNeutral` mixes from neutral #262626 ⇒ (69,69,69).
7. R034 — measurement only; D05 event footer → PASS (dark).
8. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.

## 外推待确认 (do NOT assume)
- **`nativeRecord` is the burst mechanism** (`harness/Main.qml:112-121`): `{action:"nativeRecord", prefix, duration,
  interval}` → `<prefix>-NNNN.png` every `interval` ms. **Its completion log DOES print every frame's `elapsedMs`**
  (cumulative requested: 80/162/246/322/…), plus `saved`/`visible` — plus one `[UIReview] native recording` line.
  Real spacing ≈ requested + ~13ms (33ms at interval 20; ~80ms at interval 80). Frame mtime is a second timing source.
- **`nativeRecord` frames track `resize`; `captureClient` does not** (R040). captureClient returns a stale 1100x692
  buffer after a resize (now reproduced 4x).
- **`capture`/`nativeRecord` prefixes are relative to the app's CWD = repo root**, not `tmp/ui-acceptance/calendar/`.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark** — not KosDialog, not the calendar app.
  `CalendarTaskEditorDialog.qml:8` extends `KosWorkspaceDialog`.
- **D02's radius is 16, not 24.** `smallRadius + 4`, in both dialogs. See 仍差 #4.
- **D03's fill is `#F7F7F7`, not `cardSurface`.** Deliberate P02 override, identical in both dialogs.
- **D06/D07 are HIG-convention matches, not reference-pixel matches** — `.loop/refs/macos-calendar.png` (814x522) has
  **no alert/dialog at all**. Same for D01/D02/D03/D10.
- Accent measured (48,140,198) in both themes; `defaultAccentSeed` is #3478f6. Unresolved which one D06 is judged against.
- macOS alerts have no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old outlined
  secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:168` × densityScale ≈0.912 ⇒ 31).
  Task-dialog footer buttons measure **32px** (pill + soft edge), consistent.
- **Dark `buttonNeutral`'s neutral #262626 is this profile's *rendered* surface, asserted by measurement, not a token.**
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `pointerObject` passes `kind` straight
  through (`move`/`press`/`release` all work); a targetless `pointer`'s `hover n/a down n/a` line means nothing.
  `{"action":"pointer","kind":"click"}` is a **no-op** (`ReviewInput.cpp:67-92` maps only `press`/`release`).
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `openItem` (`harness/Main.qml:225`) needs `selectedItems` non-empty; `kind` = `"todo"`/`"event"`; it logs nothing.
- The review app is **not** left running between rounds (`kill "$(cat live-app.pid)"`; `pkill -f` kills the driving shell too).
- Save is deliberately NOT exercised in-app (isolated-profile discipline).

## Next round (pick ONLY #1)
**Dark task-dialog footer** — 仍差 #6, the last un-captured member of the shared footer shape (both dialogs are now
measured in light at wide *and* narrow; the dark pass exists only for the event editor).
Plan: relaunch with `start-review-vm.sh dark`, same route as R040 (`date 2026-04-02` → `view day` → `openItem
{kind:"todo",titleContains:"Green planning"}` → `pointerObject detailsEdit` move/press/release, pill at ≈(682,372)).
Probe the footer at the two corners the light pass used — Save/Cancel/Delete each **32px**, gaps **5px**, side insets
**13px**, against the dark card fill **#262626** (`:57`). Then repeat once at 760x540 using the R040 recipe
(**burst first via `nativeRecord` with `duration:1800, interval:80`, then `resize {width:760,height:540}`, read
frame 3+**) to confirm the dark footer also survives the narrow window. Do not trust `captureClient` after `resize`.
