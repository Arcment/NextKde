# R030 — D05 dark half: measured, dark numbers are directionally right (2026-10-16)

## 本轮 (R030)
Atomic step: **measure the same editor in dark** and settle `buttonNeutral`'s dark branch + whether
`lightLabel` white still reads on the dark accent. **Measurement round — no code changed** (the state.md
brief said: change nothing unless the dark numbers are plainly wrong; they are not).

Method: app was *not* running (the earlier `ps|grep -c` hit count of 2 was the loop's own cmdline, not the
app) → `start-review-vm.sh dark` (blocks; run with `nohup … &`), waited for the harness load line, then the
same `view week` → pointer move/press/release `target:"toolbarAdd"` (writes 1.5s apart) → `captureClient`
to `r030-editor-dark.png`. `runtimeInfo` confirms `{"width":1100,"height":692,"dpr":1,"appearance":"dark","dark":true}`.

Measured 1:1 (Pillow) from `r030-editor-dark.png`:
- Dialog sits x≈360..745, y≈?..667; **card = (38,38,38)**, scrim outside = (17,17,17), field = (34,39,47).
- Save bbox (385,586)-(729,613) = **345x28**, fill **(48,140,198)** — *identical to light* (accent does not
  theme-shift). Lightest glyph pixel **(255,255,250)**, 81 near-white px in the x559-566 label band.
  Darkest pixels in the box are (29,29,29) at (385,606)/(724,612)/(392,613) — i.e. **capsule edge/corner
  pixels**, not glyphs (in dark the surround is dark, so "darkest" flips sides vs R029). No dark glyph.
  ⇒ **`lightLabel` white reads correctly in dark too.**
- Cancel bbox (384,622)-(730,651) = **347x30**, fill **(61,70,82)**, label lightest **(232,246,248)**.
  (61,70,82) is **lighter than the card (38,38,38)** ⇒ the dark *direction* of `buttonNeutral`
  (`mix(card, white, 0.13)`) is confirmed right. Cancel label is lighter than its fill ⇒ readable.
- Direction confirmed; **exact value is off-hue**: (61,70,82) is blue-tinted (+21 B over R) although the
  surface it sits on is neutral (38,38,38). `mix((38,38,38), white, 0.13)` would be (66,66,66); solving
  (61,70,82) back through the 0.13 mix gives card ≈ (32,42,56) — i.e. `buttonNeutral` is mixed from the
  *opaque, accent-tinted* `card` token while the rendered surface (translucent `cardSurface` over
  `windowSurface`) reads neutral. Visible to the eye as a mildly slate-blue capsule. **Not plainly wrong**
  ⇒ no change; recorded as a refinement candidate, not a defect.
- Geometry identical to light (Δ≤1px, AA) ⇒ R027/R028/R029 intact, no regression.

## 仍差 (top 8, visual-impact order)
1. **Emphasized capsule's shadow + light rim** (was #2): `elevation 0.68` makes the 6px gap dirty —
   dark: y615-620 read 32..36 vs card **38**, and a 2-3px dark halo hugs the capsule sides (x382-383 →
   32-35 at y600; light: 236..241 vs card 247). Plus a 1px *lighter* edge on the capsule
   (x386,y600 = (56,144,200), y613 = (55,144,200) vs fill (48,140,198); = inner highlight /
   `strokeColor accentText@0.16`). macOS primary is a flat fill, no rim. **Confirmed in BOTH themes now.**
2. D05 light + editing-state (3-row) capture not yet done (dark half now done).
3. D07 destructive weight: Delete is still a filled red pill, co-equal with Save.
4. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow, all unmeasured.
5. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
6. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
7. P01 long-text (blocked by the R019 fixtures not rendering, see rounds.md R026); O01–O03 tooltip;
   O08/X07 four-overlay coordination.
8. `CalendarTaskEditorDialog` footer not yet translated to the stacked/filled style — still the old outlined
   secondary, and **`lightLabel` is not set there** (its Save label uses the old rule).

## 最近已改 (most recent 8)
1. R030 — verification/measurement round only, **no code change**.
2. R029 `KosButton.qml` +L11-15 (`lightLabel`) + contentItem color, `EventEditorDialog.qml:226`.
3. R028 `AppTheme.qml` +L101-110 (`buttonNeutral`), `KosButton.qml` (`secondary` + flat fill), `EventEditorDialog.qml:234`.
4. R027 `EventEditorDialog.qml:175-248` — footer → vertical full-width `ColumnLayout`, ref order Save/Cancel/Delete.
5. R026 — verification/driver round only. 6. R025 — R019 fixtures re-seeded; `date`/`view` key names. 32d60c0.
7. R024 — P01 TASK details popover verified in light, bd0070f. 8. R023 `EventDetailsPopover.qml` shadow. d9be5ef.

## 外推待确认 (do NOT assume)
- **D06's white primary is a HIG-convention match, not a reference-pixel match** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all** (0 accent-blue pixels). Dark D06 is
  likewise convention-judged. Do not re-derive this.
- `buttonNeutral` dark **value** (61,70,82) is blue-tinted vs its neutral (38,38,38) surround; direction is
  right, hue is unresolved (the mix uses the opaque tinted `card`, not the rendered surface tone).
- `lightLabel` and `secondary` are both opt-in, default false ⇒ no other caller changed; the rest of the app
  shows the old outlined secondary and the old `accentText` primary. Not a regression.
- The accent measured here is (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6, so this
  profile's value comes from the system palette. Which one D06 should be judged against is unresolved.
- macOS alert has no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- The review app is **not** left running between rounds; `ps|grep -c kos-calendar` counts the loop's own
  cmdline, so always check `/proc/<pid>/cmdline` or just relaunch (`start-review-vm.sh` refuses if the
  owned instance is genuinely alive).

## Next round (pick ONLY #1)
**Kill the emphasized capsule's drop shadow and its 1px light rim** (仍差 #1, both themes confirmed).
Target: with Save hovered-never-but-normal, the 6px gap rows between Save and Cancel must read the **card**
value exactly (light 247,248,249 / dark 38,38,38) and the 2-3px halo beside the capsule must vanish; the
capsule's outermost row/column must equal the fill, not +7 lighter.
Look at `shared/qml/foundation/KosButton.qml` — find the `elevation`/`level` assigned when `emphasized` is
true (dark y613 = (55,144,200), light gap 236..241 vs 247) and the `strokeColor accentText@0.16` / inner
highlight in the `background`. Keep the shadow on *non*-emphasized/hoverable paths if it is shared, and do
NOT touch the flat fill colours (R028/R029) or the vertical stack (R027).
Verify by relaunching **both** `light` and `dark`, same toolbarAdd pointer route, and measuring the gap rows.
