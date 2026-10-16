# R036 — `CalendarTaskEditorDialog` footer → flat stacked pattern (D05 parity). Built clean, **in-app verification BLOCKED** (2026-10-16)

## 本轮 (R036)
Atomic step: **the last dialog in the family — `CalendarTaskEditorDialog`'s action row** (was 仍差 #1).
One file: `apps/calendar/qml/CalendarTaskEditorDialog.qml` (314 → 385 lines). No other file touched.

Why it was still wrong: the dialog declared `standardButtons` and inherited `KosWorkspaceDialog`'s footer
(`shared/qml/foundation/KosWorkspaceDialog.qml`) = a right-aligned `DialogButtonBox` row of *outlined*
buttons, and its `Delete task` lived as the **last row of the scrolling form** — so the actions were a row
(not stacked), not full-width, and Delete could scroll out of reach.

Change (mirrors `EventEditorDialog.qml:178-250` byte-for-byte in shape):
- `:28-38` `property string saveLabel` / `cancelLabel` + `Component.onCompleted` copying the platform-localized
  texts from the never-rendered `DialogButtonBox { id: labelSource }` (null-guarded). `standardButtons` (`:24`)
  and `onAccepted` (`:174`) untouched.
- `:61-109` new `footer: Item { implicitHeight: 16 + footerCol.implicitHeight + 16 }` → hidden `labelSource`
  (`:67`) + `ColumnLayout { id: footerCol; anchors.fill: parent; anchors.margins: 16; spacing: 6 }` (`:75`) with
  three full-width rows: **Save** `highlighted/flatPrimary/lightLabel` → `root.accept()` (`:81`),
  **Cancel** `secondary` → `root.reject()` (`:91`),
  **Delete task** `visible: root.editingId.length > 0`, `destructive`+`secondary` → `deleteRequested`+`close()` (`:98`).
- Removed the in-form `KosButton { text: "Delete task" }` (old `:303-311`); the form `ColumnLayout` now ends at `:383`.
- Untouched: `background` KosSurface, `width`/`height` formulas, `contentItem` Flickable, notes wheel/scroll,
  `payload()`/`value`/`datePart`, every field row.
Build: `ninja -C .build/calendar-review kos-calendar kos-pim-service` → **7/7 clean**, qmlcache regenerated,
relinked (so the QML at least parses; the footer's *runtime* behaviour was never rendered — see below).
Theme-neutral by construction: it reuses the same opt-ins that passed in light (R033) and dark (R034).

**BLOCKED — no in-app capture of the task dialog. This round delivers code + build only, nothing judged.**
- Route reached the popover fine: `{"action":"date","date":"2026-04-02"}` → **(separate batch)** `{"action":"view","view":"day"}`
  → `{"action":"openItem","kind":"todo","titleContains":"Green planning"}` → the task popover renders
  (`r036-task-popover-light.png`): green kind dot, `[UI] Green planning 2026-04-02`, `2026年4月2日星期四 · 09:00`, ✕, 编辑.
- The popover's 编辑 is `EventDetailsPopover.qml:201` `objectName: "detailsEdit"`; measured on-screen
  x643..687 / y360..385 (week view) — click point (682,376).
- **5 press/release attempts in 2 launches (raw `pointer`, and `pointerObject` move + raw press/release) produced
  no dialog.** C++ log for every press: `pointer press undefined 682 376 hover n/a down n/a` ⇒ the synthesized
  pointer resolves **no item at any point**; `pointerObject` *move* does resolve (`{"found":true,"x":682,"y":363}`).
  R034/R035 used this same route successfully earlier today, and the very first raw click this round at (200,551)
  also did nothing (it was `openItem`, not the click, that opened the popover) ⇒ **session regression in pointer
  delivery, not product code**. Stopped after 2 launches per the small-step rule; no further attempts.
- Also lost to the blocker: the requested **before/after footer table** for this dialog. Its "before" is now
  documented from source (inherited outlined right-aligned footer + in-form Delete), not measured.

**Driver lessons (recorded, reproduced this round):**
1. `date` and `view` must be sent in **separate batches with a ≥1.5s settle**. In one batch the deferred
   activation (`handleActivation`) wins and the app lands in **week** view — reproduced twice (first batch, and
   again after the restart). With the settle, `view day` sticks.
2. `openItem` **does** work for todos: `{"kind":"todo","titleContains":"Green planning"}` opened the popover
   first try, twice. R024's "openItem todo matched nothing" was the R025 `date`-key bug, not a kind problem.
3. Command-batch writes can be **skipped** by the app's 100ms poll (only the first of a 3-command batch logged
   in time). Send one logical command per batch when the result matters.

## 仍差 (top 8, visual-impact order)
1. **R036's task-dialog footer is UNVERIFIED** — needs one in-app capture (any theme) showing 3 stacked
   full-width rows, 6px gaps, Delete red + last, and *not* the old outlined row. Blocked by pointer delivery.
2. D01/D02/D03 — scrim opacity, dialog radius vs `largeRadius`, double-layer shadow; still unmeasured.
   (R035 #6: 1px bottom edge highlight on the dialog card at y667.)
3. D10 reveal animation 0.96→1 (KosDialog) — needs consecutive frames, never a static shot.
4. D11 narrow 760x540: footer must not clip or wrap (`captureClient` after `resize` returns a stale buffer).
5. P01 long-text (fixtures restored in R025, never re-judged); O01–O03 tooltip; O08/X07 four-overlay coordination.
6. `KosButton.qml:67-68` — secondary buttons regain a 1px `AppTheme.border` rim on **hover or activeFocus**.
   Never checked against the ref. Low priority, recorded not fixed.
7. Light-theme `buttonNeutral` (227,229,230) on card (247,247,247) = 1.19:1 — accepted as correct (R033 #6).
8. `buttonNeutralHover`/`Pressed` never captured; a hover frame would confirm the step still reads.

## 最近已改 (most recent 8)
1. R036 `CalendarTaskEditorDialog.qml` — footer override + labelSource/footerCol (Save/Cancel/Delete), in-form Delete removed. **Unverified.**
2. R035 `AppTheme.qml:107` — dark `buttonNeutral` mixes from neutral #262626 ⇒ (69,69,69). Verified.
3. R034 — measurement only, no code change; D05 → PASS (event footer, dark).
4. R033 `EventEditorDialog.qml:245` `+secondary: true` — D07 landed.
5. R032 — verification/measurement only, no code change; D07 premise corrected.
6. R031 `KosButton.qml` `+flatPrimary` + `EventEditorDialog.qml:227`.
7. R030 — verification only, no code change.
8. R029 `KosButton.qml` `+lightLabel` (`:11-15`), `EventEditorDialog.qml:226`.

## 外推待确认 (do NOT assume)
- **R036 is code-identical in shape to the event dialog's footer, so the event footer's measured geometry is the
  expected result — but that is an extrapolation, not a measurement of this dialog.** Do not mark D05's task
  variant PASS until it is seen.
- `CalendarTaskEditorDialog`'s dialog surface is a *hardcoded* `AppTheme.dark ? "#262626" : "#F7F7F7"`
  (`:56-57`), unlike the event dialog's token-driven surface. Not a defect found this round, just not the same.
- **`controlHeight` renders as 31px here, not the spec's 34.** `AppTheme.qml:168` scales by `densityScale`
  (`:166-167` = font.pixelSize/13 clamped [0.88,1.28]); this profile sets no font override ⇒ ≈0.912 ⇒ 31.
  D05's "=34" is the densityScale=1.0 value; do not "fix" 31 → 34.
- **The neutral #262626 in `buttonNeutral`'s dark branch is this profile's *rendered* surface, asserted by
  measurement, not a token.** The dark `card` token stays slate-tinted (≈(32,42,56)) and is used by every other
  dark surface. If the drawn dialog surface moves, the button must follow it again.
- **D06's white primary and dark D06 are HIG-convention matches, not reference-pixel matches** — the ref image
  (`.loop/refs/macos-calendar.png`, 814x522) has **no alert at all**. Do not re-derive.
- **D07's red-on-neutral flat fill is a CONVENTION judgment** (no alert in the ref), judged in both themes. PASS.
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary and the old `accentText` primary with its shadow+rim. Not a regression.
- The accent measured is (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6. Which one D06 should be
  judged against is unresolved.
- macOS alert has no third action; our Delete row extrapolates "destructive goes last" (D07/O06).
- Breeze titlebar circles (top-right) are the WM's, not app chrome — never a C-series defect.
- Save is deliberately NOT exercised in-app (isolated-profile discipline).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- **Capture path: the harness `captureClient` action** (`harness/Main.qml:122`, `ReviewInput.cpp:60`
  `window->grabWindow()`), not `capture-owned.py` — the latter needs X11 and this profile is Wayland
  (`start-review-vm.sh:13-14`). Wait for the png *and* the `native app client capture <path> true` line.
- `{"action":"pointer","kind":"click"}` is a **no-op** (`ReviewInput.cpp:67-92` maps only `press`/`release`).
- **Synthesized pointer delivery is unreliable in this session: every press logs `hover n/a down n/a` and
  resolves no item.** `pointerObject … "kind":"move"` still resolves by objectName. Prefer
  `{"action":"pointerObject","target":"<objectName>","kind":…}` where an objectName exists.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send the `date` command first.
- The review app is **not** left running between rounds (`kill "$(cat live-app.pid)"`; `pkill -f` kills the
  driving shell too, exit 144). `start-review-vm.sh` blocks — run it backgrounded.
- `openItem` (`harness/Main.qml:225`) needs `selectedItems` = `itemsForDate(selectedDate)` non-empty
  (`Main.qml:213`); `kind` is `"todo"`/`"event"`.

## Next round (pick ONLY #1)
**Unblock the pointer, then verify R036's task-dialog footer in one capture (light is enough).**
Order: (a) in a *fresh* launch, first action = `{"action":"pointer","kind":"move","x":200,"y":526}` and check the
C++ log for a real `hover … down …` (not `n/a`) before driving anything — if it is still `n/a`, stop and record
that the harness pointer is dead in this profile; (b) if the pointer lives, `date` → settle → `view day` →
`openItem {kind:"todo", titleContains:"Green planning"}` → press/release on `detailsEdit` (682,376) → capture.
Measure the same columns as R035 (fill / x-extent / ink rows / gaps / AA / label colour) plus the row count, and
confirm Delete is present, last, red, and `destructive` — the task fixture `[UI] Green planning 2026-04-02` is an
existing todo, so `editingId` is non-empty and Delete must be visible. Do not touch any file unless the capture
proves a defect.
