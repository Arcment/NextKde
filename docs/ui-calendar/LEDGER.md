# R035 — `buttonNeutral` dark hue fixed: (61,70,82) slate-blue → (69,69,69) neutral, measured in-app (2026-10-16)

## 本轮 (R035)
Atomic step: **fix `buttonNeutral`'s dark hue** (was 仍差 #1). One line of behaviour: `AppTheme.qml:107`.
Artifacts: `r035-editor-edit-dark.png` (1100x692), `_r035-footer3x.png` (3x footer crop, x375..740 y540..662).
Route (same as R034, first try): `date 2026-04-02` → `view day` → `openItem` → `pointer move` (682,441)
→ `press` → `release` → capture. **Capture was driven by the harness `captureClient` action
(`harness/Main.qml:122`), NOT `capture-owned.py`** — this profile runs `QT_QPA_PLATFORM=wayland`
(`start-review-vm.sh:13-14`), so `capture-owned.py`'s `xdotool` ownership check dies with
"Can't open display: (null)". Poll `live-window.png.app.log` for the `native app client capture … true`
line after the file appears.

Change: `dark ? mix(card, white, 0.13)` → `dark ? mix(Qt.rgba(0.149,0.149,0.149,1) /* #262626 */, white, 0.143)`
⇒ 38 + (255-38)×0.143 = **69.0**.

Measured (Pillow; card surface (38,38,38)):

| row | fill R035 | fill R034 | x-extent | ink rows | pitch |
|---|---|---|---|---|---|
| Save (保存) | (48,140,198) | same | 384..730 | y547..578 (31 core) | — |
| Cancel (取消) | **(69,69,69)** | (61,70,82) | 384..730 | y584..615 | 37 |
| Delete (删除日程) | **(69,69,69)** | (61,70,82) | 384..730 | y621..652 | 37 |

1. **The slate-blue is gone.** Cancel/Delete fill is (69,69,69) — R=G=B exactly. On the 3x crop the two
   capsules are neutral grey over the neutral card; nothing cool-tinted left. R034 #7 is closed.
2. **Separation barely moved:** fill/card WCAG = **1.578:1** (R034 (61,70,82) = 1.583:1) — Δ0.005, the
   luminance step is preserved as intended. (Y_fill 0.0595 vs 0.0599; Y_card 0.0194.) Not a dead slab.
3. **Geometry byte-identical to R034:** all three rows 31px core / x384..730 / pitch 37 / gaps 579..583 &
   615..620 = 6px = `EventEditorDialog.qml:220 spacing: 6`. No rim: Delete's AA is now a *neutral*
   1px blend — top y621 (57,57,57), bottom y652 (50,50,50), single pixel, no rim+shadow reintroduced.
4. **Red label survives:** Delete core **red (249,104,96)**, contrast vs (69,69,69) = **3.29:1**
   (R034 3.27:1 vs the bluish fill). Cancel label near-white (239,243,247). Still reads destructive at 3x.
5. **Light theme unchanged by construction, not re-captured.** The light branch
   `mix(card, Qt.rgba(0,0,0,1), 0.095)` is byte-for-byte identical to R033's (`AppTheme.qml:108`), and
   `buttonNeutralHover`/`buttonNeutralPressed` still mix *from* `buttonNeutral`. I spent the round's budget
   on the dark capture; the light claim is code-identity, flagged as such.
6. Side observation (not a defect, feeds 外推): the dialog card's bottom edge is y666 card / y667 (48,48,48)
   / y668+ scrim (15..17) — a 1px bottom edge highlight on the dialog card, D01/D02/D03 territory.
7. **Verdict: PASS for the step.** Hue fixed, luminance step and geometry intact.

## 仍差 (top 8, visual-impact order)
1. `CalendarTaskEditorDialog` footer still the old outlined secondary — **no `lightLabel`**, no
   `flatPrimary`, and its Delete (`:306`) still carries the rim+shadow removed from `EventEditorDialog`.
   Last rim+shadow Delete in the family. This is Next round #1.
2. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow; all still unmeasured.
   (R035 #6 found a 1px bottom edge highlight at the card's bottom, y667.)
3. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
4. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
5. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination.
6. `KosButton.qml:67-68` — secondary buttons regain a 1px `AppTheme.border` rim on **hover or
   activeFocus**. Cancel and Delete now share it. Never checked against the ref. Low priority, recorded
   not fixed.
7. Light-theme `buttonNeutral` (227,229,230) on card (247,247,247) = 1.19:1 — accepted as correct
   (R033 #6), listed only so nobody re-opens it.
8. `buttonNeutralHover`/`Pressed` were never captured (design intent, not a measured value) — they now
   follow the new base; a hover frame would confirm the step still reads.

## 最近已改 (most recent 8)
1. R035 `AppTheme.qml:107` — dark `buttonNeutral` now mixes from the neutral #262626; result (69,69,69).
2. R034 — verification/measurement round only, **no code change**; D05 → PASS (editing footer).
3. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.
4. R032 — verification/measurement round only, **no code change**; D07 premise corrected.
5. R031 `KosButton.qml` `+flatPrimary` (strokeWidth/elevation/showInnerHighlight) + `EventEditorDialog.qml:227`.
6. R030 — verification/measurement round only, **no code change**.
7. R029 `KosButton.qml` +L11-15 (`lightLabel`), `EventEditorDialog.qml:226`.
8. R028 `AppTheme.qml` `buttonNeutral`, `KosButton.qml` (`secondary` flat fill), `EventEditorDialog.qml:234`.

## 外推待确认 (do NOT assume)
- **`controlHeight` renders as 31px here, not the spec's 34.** `AppTheme.qml:168` is
  `Math.round((modernDesign ? 34 : 36) * densityScale)` and `densityScale` (`:166-167`) is
  `Application.font.pixelSize / 13` clamped to [0.88,1.28]. The harness sets **no** font override
  (`harness/Main.qml` only *reports* `reviewWindow.font.pixelSize`), so densityScale ≈ 0.912 ⇒ 31.
  **D05's "=34" is the densityScale=1.0 value**; do not "fix" 31 → 34.
- **The neutral #262626 in `buttonNeutral`'s dark branch is this profile's *rendered* surface, asserted by
  measurement, not a token.** The dark `card` token stays slate-tinted (≈(32,42,56)) and is still used by
  every other dark surface — R035 fixed the *button*'s base, not the palette. If the drawn dialog surface
  moves, the button must follow it again. A palette-level fix is a separate, larger round.
- **D06's white primary is a HIG-convention match, not a reference-pixel match** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all** (0 accent-blue pixels). Dark D06 is
  likewise convention-judged, as is "no shadow on an alert primary". Do not re-derive this.
- **D07's red-on-neutral flat fill is a CONVENTION judgment** (no alert in the ref). Judged in **both**
  themes (light R033 #6, dark R034 #4/#5) — PASS in both. Fallback (red-tinted flat fill) not warranted.
- `flatPrimary`/`lightLabel`/`secondary` are all opt-in, default false ⇒ the rest of the app still shows
  the old outlined secondary and the old `accentText` primary **with** its shadow+rim. Not a regression.
  (This is exactly what 仍差 #1 is about.)
- The accent measured is (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6, so this
  profile's value comes from the system palette. Which one D06 should be judged against is unresolved.
- macOS alert has no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- **Capture path: use the harness `captureClient` action** (`harness/Main.qml:122`,
  `ReviewInput.cpp:60` `window->grabWindow()`), not `capture-owned.py` — the latter needs an X11 display and
  this profile is Wayland (`start-review-vm.sh:13-14`). Wait for the png *and* the
  `native app client capture <path> true` line in `live-window.png.app.log`.
- `{"action":"pointer","kind":"click"}` is a **no-op** (`ReviewInput.cpp:67-92` maps only `press`/`release`).
  Use `move`/`press`/`release` with `x`/`y`; the 编辑 affordance in the details popover is at **(682,441)**.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send
  `{"action":"date","date":"2026-04-02"}` first.
- The review app is **not** left running between rounds (`kill "$(cat live-app.pid)"`; `pkill -f` kills the
  driving shell too, exit 144).
- `start-review-vm.sh` does not return (blocks) — run it backgrounded, then drive via `review-command.py`;
  "timed out" there is normal.
- `openItem` (`harness/Main.qml:225`) needs `selectedItems` to be non-empty; its optional `kind` /
  `titleContains` filters were unused.

## Next round (pick ONLY #1)
**`CalendarTaskEditorDialog` footer — drop the last rim+shadow Delete and adopt the same flat pattern.**
Scope: that dialog's action row only (the Delete at `:306`, plus `lightLabel`/`flatPrimary`/`secondary`
opt-ins paralleling `EventEditorDialog.qml:226/227/234/245`). Do **not** touch `AppTheme.qml`,
`KosButton.qml`, or `EventEditorDialog.qml`. Do measure its footer first (route: open a *task* rather
than an event, then its edit affordance) and record the same table (fill / x-extent / ink rows / gaps /
AA / label colour) before and after, so the two dialogs can be compared row-for-row. Watch for: task
fixtures on the same 2026-03-29..04-04 window, and whether the task dialog's footer is also 3 rows.
