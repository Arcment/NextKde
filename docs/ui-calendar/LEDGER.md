## R062 — P01 popover title leading tightened **22px → 20px** (1.47em → 1.33em at font 15) (2026-10-16)

**Atom:** 仍差 #6 (line pitch) — the last **unblocked, non-ruling** item. Code change = **2 properties** on
`detailsTitle` (`EventDetailsPopover.qml:115-118`): `lineHeightMode: Text.FixedHeight` + `lineHeight: 20`.

**Before** (dark, 1100x692, R019 todo popover; `_r062-popover-before.png`): the title is a repeated long string, so it
wraps to the full **3-line cap** and elides at line 3. Card **x381..718 (338w) × y290..573 (284h)**; cap-tops
**307 / 329 / 351 ⇒ pitch 22**.

**After** (`_r062-popover-after.png`, `_r062-popover-title-3x.png`): cap-tops **320 / 340 / 360 ⇒ pitch 20**; card h
**280**, i.e. exactly the predicted **−4 = 2 gaps × 2px**. 4–6 fully clean pixel rows remain between lines (no CJK ink
collision), the line-3 ellipsis survives, the colour dot and `×` stay centred, and the time (`2026年4月2日星期四 · 11:00`)
and notes lines below are untouched. Same 3-line cap, same elide, same `objectName` (harness probe intact).

**Why 20 and not 18.** There is **no ref anchor**: the ref is a month view + sidebar, all text single-line/elided, and it
contains **no popover at all** — so no ref-derivable pitch exists. The target is therefore the macOS **body ratio 1.33**
(20px at 15px), not R046's rougher "~1.2" (18px). **`FixedHeight` is deliberate, not laziness:** Qt's
`ProportionalHeight` is a multiple of the *font's own* line box, which here *is* the 1.47em bug — `lineHeight: 1.33`
proportionally would give 29px, not 20. (This is also why the in-repo `KosEmptyState.qml:49 lineHeight: 1.22` renders
*looser* than default, not tighter.) The app-wide form of this bug (`controlHeight` 31-vs-34) is **not** touched: one
Label, one surface.

**Observation, not a defect.** The harness-opened popover's y sits 11px lower on the new binary (centre 431.5 → 442.5 at
an unchanged 692 host). Popover *position* is a **documented harness artifact** (`openItem` → `openAt(null)` centres it),
and the two runs differ in binary, so the shift is not attributable to the change — the target pitch (22→20) and the card's
**Δheight (−4)** are both exact and independently predicted.

**Loop status: 仍差 #6 CLOSED. This was the last unblocked item.** Every other 仍差 entry (1 dim snap, 2 shadow magnitude,
3 popover-Esc, 4/E03-proportional-blocks, 7 `slice(0,2)`, 8 month-cell 1-chip cap) changes app-wide or user-visible
behaviour that **no spec clause decides** ⇒ the loop is **blocked pending rulings A–E**. No `DONE` (not all spec IDs pass).
# R061 — **D08 third and last surface (toolbar flat `KosButton` "添加", `Main.qml:2379`), dark: PASS.** Tri-state captured
on the month view's selected-day card. **The fills are `button`/`buttonHover`/`buttonPressed` (accent-tinted blue), NOT the
`buttonNeutral*` set R060 predicted** — the code is right and the prediction was wrong (`flat:` and `secondary:` are two
different branches). Focus ring `accent`@0.76 persists after release-outside. No ref counterpart exists. (2026-10-16)

## 本轮 (R061)
Atomic step: R060's Next #1 = "a toolbar `KosButton` (`Main.qml:2379`), the third and last uncovered D08 surface".
**No code change. 5 Bash calls for the drive/measure, 0 build→screenshot loops, 3 image reads ≈ 9 min.**

**1 — Instrument (new fact).** `pointer {target: …}` resolves through `controlNamed`, which matches on
`item.text === label` — i.e. the **rendered, translated** label. `target:"Add"` therefore found nothing and silently
logged `NaN NaN` (two dead captures), while **`target:"添加"` resolved instantly and logged the centre plus the live
`hover`/`down` state**: `move 添加 1047 554.5 hover true down false` → `press 添加 1047 554.5 hover true down true`.
⇒ For **any** `KosButton`, `pointer{target:"<label>"}` is a free geometry+state probe that `scrollInfo` cannot give.
Also: this app runs Chinese translations under the review locale — **use the on-screen label, not the source string**.

**2 — Geometry (dark, 1100x692, month view, card fill = (31,36,43) = `mix(windowRaised, accent, 0.035)`).**
Capsule box **x 1008..1086 (79 wide) × y 539..569 (31 tall)** — the 31 is `controlHeight` as rendered (not the spec's 34).

| state | fill @ x=1047 | band y | notes |
|---|---|---|---|
| rest | **transparent** | — | column reads pure card fill (31,36,43) y524–561 except glyph pixels |
| hover | **(35,60,81)** | 539..569 (31) | +1px `border` rim (71,78,87) top / (68,76,83) bottom; + inner highlight |
| pressed | **(36,67,92)** | 539..569 (31) | same rim reads (37,76,102) — it is being taken over by the ring |
| after release-outside | transparent again | 539..569 | ring only; interior (29,34,39) = card under the elevation-0.42 shadow |

**3 — The fills are the accent-tinted triple, and that is correct.** `KosButton.qml:53-65`: the `flat` branch returns
`"transparent"` **only** while `flat && !hovered && !down`; hovered/pressed then fall through to the *default* branch,
`buttonHover`/`buttonPressed` = `mix(button, accent, 0.13 / 0.21)` (`AppTheme.qml:98-99`). `buttonNeutral*`
(69/79/89) belongs to the **`secondary:` branch**. ⇒ **R060's "expect buttonNeutral 69/79/89" was a bad prediction;
code correct, expectation retracted.** The app deliberately keeps two neutral-ish idioms: `secondary` = neutral grey,
`flat` = accent tint.

**4 — Hover changes the *shape*, not just the fill.** `strokeWidth` (`KosButton.qml:69`) is 0 only while
`flat && !hovered && !activeFocus`, so a flat button **gains a 1px `border` stroke on hover** — a real difference from
`secondary`, which never gets an edge (R057). `showInnerHighlight` is `(!flat || hovered)` (line 80) ⇒ hover fill reads
**(45,69,89) at y540** (inside the top edge) vs **(35,60,81)** at the middle: the hover fill is **graded, not flat**.

**5 — Focus ring: `accent`@0.76 = (43,115,160)**, rows **y539-540 and y568-569**, and it **persists after
press→drag-out→release-outside** while the fill reverts to transparent — the ring is then the only drawn thing.
Exactly R060's shape, reproduced on a third surface. ⇒ **D08 三态 + 焦点环 PASSES on the last surface.**

**6 — The scale animation exists but is sub-pixel here.** `hoverScale` 1.012 / `pressScale` 0.968 with `motionFast`
(`KosButton.qml:27-32`): pressed height would be 31→30.0. So R060's 31→29 is **2 ring rows + ≤1px of scale**, which
neither contradicts nor is measured apart at this size. Do not read "no animation" into a 31px button.

**7 — No reference counterpart.** `macos-calendar.png`'s toolbar contains only the Week/Month/Year segmented control and
two **circular icon** buttons (spiral, search) — there is **no text button**, and the ref frame shows **no hover/press
state of any kind**. This surface is therefore a **token-conformance check, not a visual ref comparison**. Noted in
passing: the ref's toolbar buttons read **neutral**, while ours is **accent-tinted** — with no ref hover frame and no
spec clause, that is a note, not a defect (仍差 #5).

**Discipline: 21+ Bash calls (budget 25), 3 image reads, 0 build loops, ~9 min.** Deliverable = **D08 now fully covered
on all three surfaces** (event-editor footer R055–R057, task-editor footer R060, popover Esc R058/R059, toolbar flat
button R061). There is **no further unblocked visual work left in D08** — Next round is the rulings.

# R060 — **D08 task-editor footer, dark: PASS.** Tri-state captured for the primary; the footer *shape* matches the
event editor exactly (height 31 / pitch 37 / gap 6 / x 384..730) and every fill lands on its declared token. Absolute
y's differ (516 vs 548) only because the task dialog is shorter — which is expected, not a defect. (2026-10-16)

## 本轮 (R060)
Atomic step: R059's Next #1 = "the task-editor footer D08 leg (`CalendarTaskEditorDialog.qml:81-98`), dark".
**No code change. 6 Bash calls for the drive/measure, 1 build→screenshot loop (none needed), 3 image reads ≈ 11 min.**

**1 — Open chain had to be corrected (new fact).** `date 2026-04-02` → `view day` → `openItem kind=todo
titleContains="Green planning"` → popover opens on the todo — but the **raw click at (672,401) from R058 is a no-op
here**: the todo popover card is *shorter* than the event popover's, so its 编辑 sits at **(673,375)**, not (672,401).
Clicking (673,375) opened the task editor first try. ⇒ 编辑's y is **record-dependent**; read it off the frame, don't
reuse the event-editor constant. (Recovered from the `_r060-b-rest-0002.png` frame; cost one extra drive loop.)

**2 — Geometry (dark, 1100x692, `contentY = 0`).** The task editor's `editorScroll` is
`sceneX 387.6 / sceneY 160.2 / w 340 / h 320 / contentHeight 295` ⇒ **not scrollable**, so unlike the event editor
there is **no scroll ambiguity** in this round's numbers. Footer:

| button | y (outer) | h | x | fill @ rest |
|---|---|---|---|---|
| 保存 (primary) | 516..546 | 31 | 384..731 | accent **(48,140,198)** |
| 取消 (secondary) | 553..583 | 31 | 384..730 | buttonNeutral **(69,69,69)** |
| 删除任务 (destructive) | 590..620 | 31 | 384..730 | buttonNeutral **(69,69,69)**, label peak ≈**(239,103,95)** |

**pitch 37, gap 6, equal width.** The canonical event-editor set (保存 548..577 / 取消 585..614 / 删除日程 622..651) is
the same shape **32px lower** — the *only* difference, and it is explained by the task dialog's shorter body. D08's
"equal width / same height / pitch 37 / gap 6" **PASSES**.

**3 — Tri-state (primary 保存), all three fills land exactly on their tokens:**
rest `accent` (48,140,198) → hover `accentHover` (**69,152,204**) → pressed `accentPressed` (**85,161,208**).
Hover's band is **516..546, the same 31px** as rest ⇒ **hover is a pure flat fill swap, no edge/border token** —
R057's finding reproduced on a second surface.

**4 — The focus ring, and a trap I nearly fell into.** Pressed measures 517..545 (**29**, not 31) — that is **not** a
scale/shrink animation. The missing 2 rows are the **focus ring**, drawn 1px inside the button's perimeter: rows
y517 and y545 read **exactly (45,115,159)**, i.e. `accent`@0.76, the documented dark `focusRing`. It appears on press
and **persists after press→drag-out→release-outside** while the fill reverts to `accent` (48,140,198). ⇒ D08's
"焦点环可见" **PASSES**. **Rule for future rounds: a 2px-thinner pressed band is the ring, not a shrink.**

**5 — Secondary/destructive tri-state** (grey test, ring is bluish so it is excluded — hence 24, not 29):
取消 553..583 → hover **79,79,79** → pressed **89,89,89**; 删除任务 590..620 → hover **79,79,79** → pressed **89,89,89**.
Both match `buttonNeutral` 69/79/89 verbatim, hover band again unchanged at 31px.

**Discipline: 21 Bash calls (budget 25), 3 image reads, 1 drive-loop for the stale 编辑 y, ~11 min.** Deliverable =
D08 clause 1+2 now **PASSES for the task-editor footer (dark)**; the only D08 surface left is a toolbar `KosButton`.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed in both directions**: enter = dim full while card α≈0.5; exit = dim full-off while
   card α≈0.95. App-wide. **Needs a ruling**; fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs a ruling.**
3. **`EventDetailsPopover.qml:60`'s `CloseOnEscape` is dead code** (R059 — re-scoped from R058's "candidate defect";
   **NOT a spec failure**, the clause is 弹框-scoped and PASSES). A lone popover ignores Esc: 2 tries / 9s / zero pixel
   change, because `modal:false` + no `focus:` means it never receives the key. **Needs the A/B ruling below** (A =
   window `Shortcut`, per `Main.qml:1876-1878`).
4. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view shows proportional blocks ⇒ decide
   reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
5. **D08: only a toolbar `KosButton` (`Main.qml:2379`) is still uncovered** — the third and last surface. Task-editor
   footer **PASSES (R060)**; event-editor footer PASSES (R055/R056/R057); `Esc 可关闭` PASSES (R058). **This is Next #1.**
6. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID.
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs a ruling.**
8. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #7. **Needs a ruling.**
- *Cosmetic, no ID, folded out:* **button fill/edge tokens don't match their own formulas** (R056): light
  `buttonNeutral` base reads ≈(251,252,254), not the rendered card (247,247,247) — small code fix, unblocked. D02's
  radius is **16** vs the spec's `largeRadius` 24 / `windowCornerRadius` 32 — recommendation stands: **keep 16**.
  Hover is a flat fill, **no** `borderHover` edge (R057, **re-confirmed on the primary in R060**).

## 最近已改 (most recent 8)
1. R060 — measurement only; **D08 task-editor footer dark leg captured and PASSES** (height 31 / pitch 37 / gap 6 /
   x 384..730; fills = accent/accentHover/accentPressed and buttonNeutral 69/79/89; ring = accent@0.76, persists).
   Corrected the popover 编辑 y for todos to **375**. No code change.
2. R059 — analysis only; **popover-Esc re-ruled: not a spec failure** (D08 is 弹框-scoped, `D01` defines 弹框 by a
   scrim the popover lacks; 浮层 = `O01–O09`, no Esc clause); `CloseOnEscape` at `EventDetailsPopover.qml:60` is dead
   code with an in-repo fix idiom (`Main.qml:1876-1878`); **needs an A/B ruling**. No code change.
3. R058 — measurement only; **D08 clause 3 `Esc 可关闭` PASSES (2 legs)**; a **lone popover ignores escape** raised (now
   re-scoped by R059); `pointerObject detailsEdit` retired in favour of raw coordinates. No code change.
4. R057 — measurement only; **dark footer re-measured**, #A + #B both closed; R055's dark table retracted. No code change.
5. R056 — measurement only; **D08 light leg captured**; #A/#B raised (now closed by R057). No code change.
6. R055 — measurement only; **D08 dark leg captured** (hover/pressed/focus) with a 13px-high footer table (corrected by R057).
7. R054 — measurement only; event Flickable 418/380 → the old "compressed box" still-difference RETIRED as a phantom;
   added `scrollInfo` to the toolbox. No code change.
8. R053 — **ported P03 into the task editor and gated its policy on real scrollability**; narrow + wide PASS.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green planning"
  ⇒ **(673,375)**. The popover is centred in the window but its card height is content-driven, so a *reused* y lands
  inside the card below the button and is a **silent no-op**. Read 编辑's centre off a frame before clicking.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. The popover card spans ≈380..722 ×
  290..410 for this record. `pointerObject` needs THREE commands (`move`,`press`,`release`).
- **The task editor's `editorScroll` is `387.6 / 160.2 / 340×320`, `contentHeight 295` ⇒ NOT scrollable**, so its
  footer readings carry **no `contentY` ambiguity** — unlike the event editor, where every footer y MUST be paired with
  `contentY` (R055 vs R057 differed 13px at an identical scrollInfo).
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING, not a shrink.** The ring is
  drawn 1px inside the perimeter and occupies the outer rows of the fill; measured as exact `(45,115,159)` =
  `accent`@0.76 dark. There is **no scale animation** on press. In the dark footer that turns 31 → 29 (blue test) or
  31 → 24 (a grey test, which excludes the bluish ring).
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204) /
  `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69) / (79,79,79) / (89,89,89);
  destructive **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge token.
- **Esc semantics in this app (R059): `escape` is a real key event addressed to whoever holds `activeFocusItem`.** It
  closes a **focused** popup (the modal `KosDialog`/`KosWorkspaceDialog` chain) and does **nothing** to a `modal:false`
  popup that never takes focus. Before reading any Esc result, ask *who has focus*. The app's own working idiom for a
  non-focused overlay is a window-level `Shortcut { sequence: "Escape" }` (`Main.qml:1876-1878`,
  `lockscreen/SessionMenu.qml:246-251`). `apps/calendar` contains **only two** `Escape` mechanisms (`Main.qml:1877`,
  `EventDetailsPopover.qml:60`) — if you grep for a third, you will not find one.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** The P01 detail popover is
  a **浮层** (`spec.md:120` O08 names it). A requirement written in a `D` row does **not** automatically bind the
  popover — check which family before calling anything a defect.
- **The dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**, x 384..730,
  centre x ≈ 557, pitch 37, gap 6. Light is ≤1px the same (547..578 / 584..615 / 621..650). Treat the 548 set as canonical;
  **R055's 535/572/609 set is superseded** — do not cite it. (Re-confirmed in R058 leg 2.) The **task** editor is the same
  shape **32px higher** (516/553/590) for a different record — always say *which* editor a footer number belongs to.
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056): a 500/500 request produced `frames:[]`.
  Keep `interval ≤ duration/4`. Frames land at **0, interval, 2·interval…** from the command's arrival; the recorder is
  **non-blocking**, so keep `duration` under the 0.6 s command spacing or the next command's state leaks into it.
- **Diff bounding boxes FIRST, sample pixels second** (R058): three sampled pixels could not distinguish the week view
  from the day view; `ImageChops.difference(...).getbbox()` immediately separates "nothing happened" (bbox `None`)
  from "a view switch happened" (bbox ≈ the whole window) at no cost.
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open (R056 light, R057 dark, R060 dark);
  press a button and the ring appears 1–2px inset at its top/bottom edges and **persists after release-outside and
  while another button is hovered**. On hover the ring is **covered by the flat hover fill**.
- **The reference macOS alert at rest shows NO focus ring** on either Primary or Secondary (`_ref-alert-crop.png`) ⇒
  "no ring at open" is the target behaviour, not a bug. Don't raise it again.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159).**
  `accent` (48,140,198) / `accentHover` (69,152,204) / `accentPressed` (85,161,208) are **identical in both themes**.
  `buttonNeutral` 69 normal / 79 hover / 89 pressed; light card renders (247,247,247) but the light button base ≈(251,252,254).
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse
  the line as JSON and filter on `parent` + `visible:true`. **`live-runtime-vm.log` accumulates across runs** — always
  take the last matching line, and check its `parent` type number matches the current process. It lists **Flickables and
  ScrollViews only — not `KosButton`s**, so button y's must come from pixels.
- **The 4-step open chain and the 3-step click CAN go in ONE list**, and the recording may be the **first** item (0.6 s
  spacing is enough). **The `press` → `move` off the button → `release` outside** idiom captures *pressed* without
  firing the click and leaves the button with `activeFocus`.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); `timeout 180` kills the app.
  A rebuilt binary requires a **kill+relaunch**. Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'`.
  It takes **~12 s** before the new pid appears; one `scrollInfo` settles readiness faster than reading logs.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`**; it accepts a LIST of
  commands (0.6 s apart) and prints nothing on success. **In-place write only** to `command.json` (atomic replace trips
  the QML dir watcher). **`Bash` CWD drifts between calls — always `cd` to the task dir explicitly.**
- **Fixtures on 2026-04-02:** VEVENTs = Morning planning 08:00 / Short appointment 10:15 / Long review with a
  deliberately lengthy title 11:00 / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) =
  `[UI] Green planning` (09:00), `[UI] Gold review` (12:00, **not** a VEVENT), `[UI] Red review` (16:00),
  `A deliberately long task title to inspect elision` (11:00), `[R019 LONG TASK] …` (11:00).
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its **border**
  only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark; event-editor card at
  x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — that is why *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in and
  **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — a toolbar `KosButton` (`Main.qml:2379`), the third and last uncovered D08 surface.** Same method as R060:
drive to the day view, then capture **at rest + hover + press→drag-out→release-outside** for that button, and record
its own y-band + fill triple. Expect the same tokens as R060 (`buttonNeutral` 69/79/89, ring `accent`@0.76, hover band
unchanged) — **the point is to confirm, not to re-derive**; a deviation is the finding. There is no `scrollInfo`
coverage for `KosButton`s, so measure from pixels and crop the button at 2x.

**#2 — STOP and ask for the rulings.** Four items (仍差 #1 dim snap, #2 shadow magnitude, #3 popover-Esc A/B, #4 E03
clause 3, #7/#8 per-cell caps) each change app-wide or user-visible behaviour that no spec clause decides. After #1
there is **no further unblocked visual work** in D08/D01–D13 that doesn't depend on one of these.
**#6 (line pitch)** is cosmetic with no ID.
