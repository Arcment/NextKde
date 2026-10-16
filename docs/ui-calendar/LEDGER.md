# R059 — **popover-Esc RULED: NOT a spec failure.** The harness `escape` **is** a real key event (`ReviewInput.cpp:97-105`: `QKeyEvent(Key_Escape)` → `sendEvent(focusWindow)`, the normal QQuickWindow→`activeFocusItem` route), so R058's null *behaviour* stands — but `spec.md:109` `D08 … Esc 可关闭` belongs to the **弹框** block (D01–D13), `D01` defines 弹框 **by having a scrim** and the popover has none, and the 浮层 family (`O01–O09`, `spec.md:120` O08 names the P01 详情浮层) **never mentions Esc**. ⇒ **D08 Esc stays PASS; no clause fails.** The real defect is internal: `EventDetailsPopover.qml:60` advertises `Popup.CloseOnEscape` that **can never fire**, and the repo already documents this exact failure mode *and* its working fix at `Main.qml:1873-1878`. Needs a 1-line ruling, not a fix. (2026-10-16)

## 本轮 (R059)
Atomic step: R058's Next #1 = "decide the popover-Esc finding by reading the harness's `escape` implementation". Done.
**No code change, 0 screenshots, 0 image reads, 8 Bash calls (~4 min).**

**Step 1 — the instrument is real.** `harness/Main.qml:204-205` → `pointerDriver.escape(window)` →
`harness/ReviewInput/ReviewInput.cpp:97-105` builds `QKeyEvent(KeyPress/Release, Qt::Key_Escape)` and
`QCoreApplication::sendEvent`s it to `QGuiApplication::focusWindow()`. That is a genuine key event on the normal
QQuickWindow → `activeFocusItem` route — **not** a "call `close()` on a dialog" shim. R058 corroborates empirically: the
same mechanism closed the **focused** dialog and was inert against the **unfocused** popover. ⇒ **R058's null result is
trustworthy; the instrument is exonerated.**

**Step 2 — no spec clause requires the popover to close on Esc.** The section (`spec.md:89`) covers 弹框、tooltip、
右键菜单、浮层, but its IDs are **two families**: `D01–D13` = 弹框, `O01–O09` = 浮层/tooltip/菜单. `D08` (`spec.md:109`) is
a **D-row, i.e. 弹框-scoped**. `D01` (`spec.md:102`) defines 弹框 as *"独立圆角卡片浮在父窗口之上；**父窗口整体变暗
（scrim）**"* — the popover renders **no dim** (R058), so by the spec's own definition it is **not** a 弹框. `O08`
(`spec.md:120`) names the **P01 详情浮层** as the 浮层 family, and `O01–O09` contain **no Esc clause at all** (O03's
"移开即消失" is mouse-out). ⇒ **Spec gap, not a failed clause. D08's Esc clause is unaffected and remains PASS (R058,
2 legs).** No spec.md edit — inventing a clause is the user's call, not the loop's.

**Step 3 — so what *is* wrong: a dead flag, and the repo already has the fix.** `EventDetailsPopover.qml:15 Popup`,
`:59 modal: false`, `:60 closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape`, and per R058 no
`focus:`/`Keys`/`activeFocus` anywhere in the file. Non-modal + never takes focus ⇒ `activeFocusItem` stays in the day
view ⇒ the popup item's key handler never runs ⇒ **`CloseOnEscape` is unreachable**. The repo is not ignorant of this —
`Main.qml:1873-1875` says verbatim: *"L05: Escape always reaches the open search, whichever item in this window holds
focus — **the input's own key handler is not enough once it has lost focus**"* — and fixes it with a window-level
`Shortcut { sequence: "Escape"; enabled: … }` (`Main.qml:1876-1878`), the same idiom as
`apps/lockscreen/…/SessionMenu.qml:246-251`. `apps/calendar` has exactly **two** Escape mechanisms and the popover uses
neither.

**⇒ Ruling item, two mutually exclusive 1-line options — A recommended.**
- **A** add `Shortcut { sequence: "Escape"; enabled: root.visible; onActivated: root.close() }` to
  `EventDetailsPopover.qml`. Matches `Main.qml:1876-1878`; matches macOS (Escape dismisses a focused popover); keeps
  `modal:false`.
- **B** drop `| Popup.CloseOnEscape` from `:60` so the code stops advertising behaviour it cannot deliver.
- **`focus: true` is the WRONG fix** — it would make the popover steal keyboard focus from the day view and contradict
  its `modal:false` contract. Suggested clause if the user wants it specced:
  `O10 | 浮层在可见时 Esc 可关闭（浮层不夺焦，用窗口级 Shortcut 实现）`.

**Discipline: 8 Bash calls (budget 25), 0 image reads, 0 screenshots, ~4 min.** This round produced **no screenshot**, so
it claims **no visual PASS of anything**; its deliverable is retiring a candidate defect and re-scoping it as a ruling —
which stops the loop from "fixing" behaviour the spec never asked for.

Next round #1 → the **task-editor footer D08 leg** (`CalendarTaskEditorDialog.qml:81-98`, dark), promoted because
R058's #1 is now blocked on a ruling rather than on work; pair every `scrollInfo` footer reading with its `contentY`.

# R058 — **D08 clause 3 `Esc 可关闭` PASSES on the event editor (2 legs): one `escape` closes it from a clean open (≤250ms) and one `escape` also clears the editor-over-popover stack (a 2nd escape is a no-op). NEW: a LONE popover ignores `escape` — 2 tries over 9s, zero pixel change, and `EventDetailsPopover.qml:15/59/60` is `Popup` + `modal: false` + `CloseOnEscape` with NO `focus:` anywhere** (2026-10-16)

## 本轮 (R058)
Atomic step: R057's Next #1 = "verify D08 clause 3 `Esc 可关闭` on the dark event editor". Done. No code change,
**0 build→screenshot loops**. Dark 1100x692, pid **109482** (still the R057 process, "Design review" open on entry).

**Leg 1 — clean editor, no popover.** List = `nativeRecord r058-esc 6000/250` + `escape` → **24 frames**.
Frames 0000–0001 (t 0–0.25s) = editor up (dim (55,55,55), save hovered (69,152,204)); **0002 (t 0.5s) = editor gone**;
0002–0023 byte-stable for 5.5s = day view, **no dim, no card, no popover**. ⇒ **PASS, and it is instant: the whole
teardown fits inside one 250ms sample (no exit animation is observable).**

**Leg 2 — editor opened ON TOP of the popover.** List = `nativeRecord r058-raw 10000/250` + raw `pointer` (672,401)
move/press/release + `escape` + `escape` → **39 frames**. Popover up at 0000–0006 (fill (38,38,38), **no dim**);
**0007 (t≈1.7s) = dialog**: dim (55,55,55) already at full while the card is still fading in
((34,39,47) at 450,300), settled 0008; **`escape` at t≈2.4s → 0009** = dim already back to 94,94,94 (full off)
while the card is ~95% faded ((31,32,32)); **0010+ = fully clean day view** (Gold-review chip (96,79,35) at y548),
with the **2nd `escape` (t≈3.0s) changing nothing** (0010→0038 identical).
⇒ **One `escape` clears the whole stack; there is no "second escape" case.** Caveat: the popover box
378..722 × 262..430 sits **entirely inside** the card 387.6..727.6 × 131.4..511.4, so pixels cannot say whether the
编辑 click had already dismissed the popover before the escape.
Bonus confirmation of the R057 canonical footer: in leg 2's crop 保存 spans screen y **545..577.5** (canonical 548..577, AA).

**Both legs re-confirm 仍差 #1 from both directions**: on ENTER the dim reaches full while the card is still
mid-fade; on EXIT the dim reaches full-off while the card is still ~95% opaque. The dim is un-animated, the card is not.

**NEW FINDING (P01 family, not D08) — a lone popover does not close on `escape`.** Leg-1's sibling run: popover up
with **no dialog**; `escape` at t≈4.8s and again at t≈5.4s → **frames 0010→0046 identical for 9s**, the popover
survived both. Source: `EventDetailsPopover.qml:15 Popup`, `:59 modal: false`,
`:60 closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape`, and the file contains **no `focus:` / `Keys` /
`activeFocus` at all**. Non-modal + never takes focus ⇒ Escape lands on the day view's focus item, so Qt's
`CloseOnEscape` cannot fire. That is exactly the pattern observed: the same escape mechanism closed the **focused**
dialog (legs 1+2) and was inert against the **unfocused** popover. **Candidate defect; see Next #1.**

**HARNESS FINDING — `pointerObject detailsEdit` does NOT open the editor.** Popover up, move/press/release at
t 3.0/3.6/4.2s ⇒ **zero** frame change over the next 8s. A **raw `pointer` click at the same button's centre
(672,401 @1100x692)** opened the editor first try. R057's "detailsEdit resolves even with no popover open" is now
explained. `detailsEdit` = `EventDetailsPopover.qml:202`. **Use raw coordinates for popover buttons from now on.**

**Discipline: 11 Bash calls (budget 25), 4 image reads, ~10 min.** Two dead ends, both now in 外推: (a) run 2's
`pointerObject` click was a silent no-op, which cost the whole run's two escapes their meaning — a *null* frame
diff on a click must be treated as a suspect instrument, not as evidence; (b) I read two frames at 3 sample pixels
before diffing bounding boxes, which could not tell week from day — **diff bboxes first, sample pixels second.**

Evidence (mirrored to `docs/ui-calendar/`): `_r058-esc-leg1-2x.png` (editor → gone),
`_r058-esc-leg2-2x.png` (editor over popover → clean day view).

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed in both directions**: enter = dim full while card α≈0.5; exit = dim full-off while
   card α≈0.95. App-wide. **Needs a ruling**; fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs a ruling.**
3. **A lone `EventDetailsPopover` ignores `escape`** (R058): 2 attempts, 9s, zero change; source has `modal:false`,
   `CloseOnEscape`, no `focus:`. Confirm with a non-injected key event (Next #1) before calling it a defect; fix =
   `focus: true` or `Keys.onEscapePressed: close()`. **No ID yet** — probably P01-family, not D08.
4. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view shows proportional blocks ⇒ decide
   reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
5. **D08 coverage, not failure:** event-editor footer PASSES both themes (R055/R056/R057) and **`Esc 可关闭` now PASSES
   (R058)**. Still uncovered: the **task-editor footer** (`CalendarTaskEditorDialog.qml:81-98`) and a **toolbar
   `KosButton`** (`Main.qml:2379`). No ruling needed for the captures.
6. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID.
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91`
   VTODO (due 11:00) is dropped silently. **Needs a ruling.**
8. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #7. **Needs a ruling.**
- *Cosmetic, no ID, folded out:* **button fill/edge tokens don't match their own formulas** (R056): light
  `buttonNeutral` base reads ≈(251,252,254), not the rendered card (247,247,247) — small code fix, unblocked. D02's
  radius is **16** vs the spec's `largeRadius` 24 / `windowCornerRadius` 32 — recommendation stands: **keep 16**.
  Hover is a flat fill, **no** `borderHover` edge (R057 #4).

## 最近已改 (most recent 8)
1. R058 — measurement only; **D08 clause 3 `Esc 可关闭` PASSES (2 legs)**; a **lone popover ignores escape** raised as
   a candidate defect; `pointerObject detailsEdit` retired in favour of raw coordinates. No code change.
2. R057 — measurement only; **dark footer re-measured**, #A + #B both closed; R055's dark table retracted. No code change.
3. R056 — measurement only; **D08 light leg captured**; #A/#B raised (now closed by R057). No code change.
4. R055 — measurement only; **D08 dark leg captured** (hover/pressed/focus) with a 13px-high footer table (corrected by R057).
5. R054 — measurement only; event Flickable 418/380 → the old "compressed box" still-difference RETIRED as a phantom;
   added `scrollInfo` to the toolbox. No code change.
6. R053 — **ported P03 into the task editor and gated its policy on real scrollability**; narrow + wide PASS.
7. R052 — attempted P03 port, measured, reverted; retired the old #3 as a phantom (clip line ≠ compressed box).
8. R051 — measurement only; P01 dark narrow leg PASS ⇒ P01 CLOSED (4 legs). Corrected R047's dot colour.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **Opening the editor: `date 2026-04-02` → `view day` → `openItem "Design review"` → a RAW `pointer` click at
  (672,401) @1100x692** = the centre of the popover's 编辑 button (`EventDetailsPopover.qml:202`, the ONLY
  `objectName: "detailsEdit"` in the app). **`pointerObject detailsEdit` silently does nothing (R058) — never use it
  for this.** The popover is centred in the window (378..722 × 262..430), **not** anchored to the clicked chip.
- **`escape` is a real key event and is delivered to the ACTIVE FOCUS item, nothing else** (R058): it closes a focused
  modal dialog, and does nothing at all to a `modal:false` popover that never takes focus. Before reading any Esc
  result, ask *who has focus*.
- **A footer y-scan is only comparable if you also record the dialog Flickable's `contentY`.** R055 and R057 reported
  *identical* `sceneX 387.6 / sceneY 131.4 / w 340 / h 380 / contentHeight 418` yet their footers sat 13px apart;
  the range is 0..38, so `contentY ≈ 13` is the live suspect. **From now on: pair every `scrollInfo` footer reading with
  its `contentY`, and re-read `contentY` in the same breath as the screenshot.**
- **The dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**, x 384..730,
  centre x ≈ 557, pitch 37, gap 6. Light is ≤1px the same (547..578 / 584..615 / 621..650). Treat the 548 set as canonical;
  **R055's 535/572/609 set is superseded** — do not cite it. (Re-confirmed in R058 leg 2.)
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056): a 500/500 request produced `frames:[]`.
  Keep `interval ≤ duration/4`. The log's `native recording` line carries **per-frame `elapsedMs`** — parse it to map
  state→frame instead of hand-arithmetic. A list item fires ≈0.6 s after its predecessor, so item *k* lands at ≈0.6k s.
- **Diff bounding boxes FIRST, sample pixels second** (R058): three sampled pixels could not distinguish the week view
  from the day view; `ImageChops.difference(...).getbbox()` immediately separates "nothing happened" (bbox `None`)
  from "a view switch happened" (bbox ≈ the whole window) at no cost.
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open (R056 light, R057 dark); press a
  button and the ring appears 2px inset at its top/bottom edges and **persists after release-outside and while another
  button is hovered**. On hover the ring is **covered by the flat hover fill** — there is no border-swap.
- **The reference macOS alert at rest shows NO focus ring** on either Primary or Secondary (`_ref-alert-crop.png`) ⇒
  "no ring at open" is the target behaviour, not a bug. Don't raise it again.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159).**
  `accent` (48,140,198) / `accentHover` (69,152,204) / `accentPressed` (85,161,208) are **identical in both themes**.
  `buttonNeutral` 69 normal / 79 hover / 89 pressed; light card renders (247,247,247) but the light button base ≈(251,252,254).
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse
  the line as JSON and filter on `parent` + `visible:true`. **`live-runtime-vm.log` accumulates across runs** — always
  take the last matching line, and check its `parent` type number matches the current process.
- **The 4-step open chain and the 3-step click CAN go in ONE list**, and the recording may be the **first** item (0.6 s
  spacing is enough). **The `press` → `move` off the button → `release` outside** idiom captures *pressed* without
  firing the click and leaves the button with `activeFocus`.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); `timeout 180` kills the app.
  A rebuilt binary requires a **kill+relaunch**. Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'`.
  It takes **~12 s** before the new pid appears; one `scrollInfo` settles readiness faster than reading logs.
- **`nativeRecord` frames land in the app's CWD** = the calendar task dir. `{action,prefix,duration,interval}` →
  `<prefix>-NNNN.png`; **frame counts vary — glob the prefix, never assume an index.** Timer-based and non-blocking.
- **Harness shapes:** `windowWheel` = `{action,x,y,angleY}`; `resize` = `{width,height}`; `openItem` =
  `{kind,titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`; `pointerObject` needs
  THREE commands (`move`,`press`,`release`); `pointer` = `{action,x,y,kind}`. Fields are FLAT.
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
**#1 — Decide the popover-Esc finding without another blind run: read the harness's `escape` implementation.**
Find the action handler (grep `escape` in `tmp/ui-acceptance/calendar/harness/*.qml` and in `review-command.py`).
If it posts a **real key event** to the window (`QQuickWindow`/`QGuiApplication::sendEvent`, `Keys`-based injection
into the focus item), then R058's null result is trustworthy and **a lone `EventDetailsPopover` ignoring Esc is a
CONFIRMED defect** — then either fix it in `EventDetailsPopover.qml` (add `focus: true`; keep `CloseOnEscape`) or
write it up as a spec gap if the spec's Esc clause is dialog-scoped only. If instead it **calls `close()` on a
specific dialog**, the popover result is an artefact — retire it. **Do not** also measure the task-editor footer this
round — that is #2.

**#2 — task-editor footer D08 leg** (`CalendarTaskEditorDialog.qml:81-98`, dark), same press→ring method; pair every
reading with `contentY`.
**#3 — a toolbar `KosButton`** (`Main.qml:2379`).
**#4+ — everything else in 仍差 needs a ruling** (#1 dim snap, #2 shadow, #4 E03 clause 3, #7/#8 per-cell caps);
**#6 (line pitch)** is cosmetic with no ID.
