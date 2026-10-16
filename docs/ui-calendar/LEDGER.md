# R064 — **T01 FIXED: hour pitch 54 → 40.** One source of truth `hourHeight`; measured 10 consecutive 40.0px diffs.
Plus a **harness tooling defect found**: `review-command.py` writes the *nested* command form, the harness wants
*flat* `action` ⇒ captures silently no-op. Worked around this round. (2026-10-17)

## 本轮 (R064)
Atomic step: **T01 — "Hour pitch about 40 with half-hour at 20"**. **Code change**, one file, 4 edits. 1 build,
1 kill+relaunch (light), 1 drive, 1 app screenshot read, 2 crops read, ~19 Bash calls ≈ 15 min.

Change — `apps/calendar/qml/CalendarScheduleView.qml`:
- **new line 49**: `readonly property int hourHeight: 40` — the single source of truth.
- **line 124** `positionTimeline()`: `usefulStartHour() * 54` → `usefulStartHour() * root.hourHeight`.
- **line 357** hour-cell delegate: `Layout.preferredHeight: 54` → `root.hourHeight`.
- **line 402** timed-chip delegate: `Layout.preferredHeight: 21` → `Math.round(root.hourHeight * 21 / 54)` (= **16**).
  Rationale: cell 40 − `anchors.margins: 3`×2 = **34px** inner; two chips + `spacing: 2` must fit. A fixed 21 would
  have been **silently squeezed** by the ColumnLayout (Rectangle's implicit min-height is 0) — 16×2+2 = 34 exactly.
- Untouched, as instructed: gutter `Label` (font 9, topMargin −7, `"0"+h+":00"`), `slice(0, 2)`, chip `radius: 5` and
  insets (3 / 5 / 4), the now-line `y: parent.height * …` (already proportional), the `fillHeight` spacer.

**Measured PASS.** Gutter-label row-band scan (x 2..50, threshold ≥3 non-bg px, bg = white) gives band centres
244.5 / 284.5 / 324.5 / 364.5 / 404.5 / 444.5 / 484.5 / 524.5 / 564.5 / 604.5 / 644.5 ⇒ **10 consecutive diffs of
exactly 40.0**. Independently corroborated by the harness's own log line: `contentHeight 960` = 24×40 and
`contentY 280` = 7×40. Ref measures 27 ref-px ⇒ ≈36 for our window; **the contract says ≈40, so 40 was taken**.
Visual: `_r064-grid2x.png` (06:00→12:00 at 2x — labels land 80px = 40px apart, chips single-line, no squeeze, no
overlap, insets unchanged) and `_r064-thu11-3x.png` (one chip in the 11:00 cell, ~15px tall, clean). Both mirrored
to `docs/ui-calendar/`.

**TOOLING DEFECT (found this round, NOT fixed — see Next round).** `review-command.py` dumps the command dict
**verbatim**, so `{"captureClient":{"path":"x.png"}}` reaches the harness as a nested object with **no `action` key**;
`harness/Main.qml` dispatches exclusively on the **flat** `command.action` (`:122 :208 :217 :221 :230`), so every
nested command fell through to the `[UIReview] manual undefined …` fallback (`:249`) — **the capture silently
no-opped: no file on disk, no log line, exit 0.** First drive this round produced nothing and cost 4 calls to
diagnose. **Workaround (used):** write each command flattened, in place —
`{"action": <k>, **<v>, "sequence": <prev+1>}`. R063's captures landed, so this file's behaviour is not what those
rounds relied on; treat the flattening as required until the helper is repaired.

**Side observations (recorded, not defects):** the window came up light (`start-review-vm.sh light`) at 1100x692;
the harness's `contentY` log prints `undefined` for `action` — that is the same defect above, not a view bug.
The 06:00…12:00 range is what `usefulStartHour()` = 7 shows with the fixture week; unchanged by this round.

## 仍差 (top 8, visual-impact order)
1. **T02/T03 — grid-line weight + gutter label form.** Our `Label` prints `06:00…15:00` (24h, zero-padded),
   the ref prints `8 AM` / `Noon` and its **day-column 1px separators are (237,237,237)** while the **all-day band
   bottom separator is 2px (217,217,217)** — a deliberate weight hierarchy we may not reproduce. Also the right-edge
   inset. Ref-anchored, unblocked, **within reach now that the pitch is right (labels must be re-measured at 40)**.
2. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed both directions**. App-wide. **Needs ruling A** (bind opacity to `revealProgress`).
3. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
4. **`EventDetailsPopover.qml:60` `CloseOnEscape` is dead code** (R059; **NOT a spec failure**, D01 defines 弹框 by a
   scrim the popover lacks). **Needs ruling C** (fix = window `Shortcut`, `Main.qml:1876-1878`).
5. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (all heights fixed, no
   duration→height path), while the ref's week view shows **proportional 30-min vs 60-min chips** ⇒ **ruling E**.
   Clauses 1+2 PASS (R048). **R063 strengthened E:** the ref *does* show a 30-min chip beside 60-min chips.
6. **`slice(0, 2)` per cell hides items with no `+N`** (R048, still at `CalendarScheduleView.qml` — **now line ~392**,
   shifted +3 by this round's edits): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO (due 11:00) is dropped
   silently. **Needs ruling D.**
7. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1. Same family as #6
   ⇒ **ruling D.**
8. **Two neutral-button idioms diverge, and one has no ref** (R061): `secondary` hover = neutral grey 79, no edge;
   `flat` hover = accent tint (35,60,81) **with** a 1px edge. Ref has no text button and no hover frame ⇒ **note**.
- *Cosmetic, no ID, folded out:* light `buttonNeutral` base reads ≈(251,252,254) vs the rendered card (247,247,247)
  (R056) — **unblocked but unresolved-token**. D02's radius is **16** vs the spec's 24/32 — **keep 16**. Hover is a
  flat fill, no `borderHover` edge (R057/R060) — a *flat* button does get a `border` edge on hover (R061); no conflict.

## 最近已改 (most recent 8)
1. R064 — **T01 FIXED**: `hourHeight: 40` single constant; scroll offset + cell height + chip height all derive from
   it. Measured 10× 40.0. Code change (4 edits, 1 file). Harness nested-vs-flat command defect documented.
2. R063 — **measurement only**; state.md's "blocked" premise falsified (D/O-only); ref re-read as a **week** view;
   **T01 measured FAIL (54 vs ≈40)**.
3. R062 — popover title leading 22→20px (`lineHeightMode: FixedHeight` + `lineHeight: 20`); 仍差 #6 **CLOSED**.
4. R061 — measurement only; **D08 toolbar flat `KosButton` PASSES**; R060's `buttonNeutral` expectation retracted.
5. R060 — measurement only; **D08 task-editor footer dark leg PASSES**; popover 编辑 y for todos = 375.
6. R059 — analysis only; popover-Esc re-ruled **not a spec failure**; `CloseOnEscape` is dead code ⇒ **ruling C**.
7. R058 — measurement only; **D08 clause 3 `Esc 可关闭` PASSES** (2 legs).
8. R057 — measurement only; dark footer re-measured, #A/#B closed; R055's dark table retracted.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **HARNESS COMMAND FORM IS FLAT (R064, hard-won).** `harness/Main.qml` matches `command.action` only
  (`:122 captureClient{path}`, `:204 escape`, `:208 resize{width,height}`, `:217 sidebar{expanded}`,
  `:221 view{view}`, `:225 date{date}`, `:230 openItem{kind,titleContains}`); a command with no `action` **silently
  hits the `:249` fallback** (`[UIReview] manual undefined …`) and does nothing. `review-command.py` does **not**
  flatten — write `{"action": k, **v, "sequence": prev+1}` in place yourself. `captureClient` writes via
  `QImageWriter(path)` with a **relative** path ⇒ resolves against the **app's CWD**, which is the task dir (verified
  via `/proc/<pid>/cwd`).
- **`hourHeight` is now THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used at `:124` (scroll offset) and
  `:357` (cell height); chip height `:402` = `Math.round(root.hourHeight * 21 / 54)`. **Anything that hardcodes 40 or
  16 again will drift**; anything that must track the pitch should read `root.hourHeight`. The now-line is already
  proportional and needs no constant.
- **REF FACT SHEET (R063).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, Sun 29–Sat 4)
  + 243px sidebar + mini calendar. Main region: day headers → **all-day band** (3 rows) → hour grid 8 AM–8 PM.
  **Gutter hour labels 193/220/247/274/301/… = pitch 27**; the red `9:41` pill **replaces** the 10 AM label.
  **Now-line y=238** = 9 AM line (220) + 0.683×27 ✓ (proportional, not snapped). **All-day band bottom separator =
  2px (217,217,217) at y=183-184** (stronger than the 1px hour lines, ≈237). **7 equal day columns, 1px separators
  at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots **12px** ⇒ **1:1**.
  **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** for us (contract says 40 — 40 was chosen).
- **REF EVENT CHIPS (R063, this is E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text
  + a 2–3px solid same-hue LEFT STRIPE** + small radius (≈3). Confirmed on `Portfolio…`/`Leadersh…`/`Presenta…`
  (red family), `Choir…` (olive/yellow), `Morning…` (blue), `Palm Sun…` (pink/magenta stripe). **This contradicts our
  dark theme's solid-saturated-fill + white-text** ⇒ the E family's first question is whether our dark translation is
  legitimate. Not yet judged. *(Our timed chip is `radius: 5`, a 1px border, no left stripe — visible in
  `_r064-grid2x.png`.)*
- **THE REF HAS NO POPOVER, NO MENU, NO TOOLTIP, NO HOVER FRAME.** The 弹框/浮层 section (`D`/`O`) is therefore
  HIG+token-anchored only, never pixel-anchored. Unchanged from R061/R062.
- **`lineHeight`: Qt's `ProportionalHeight` is a multiple of the *font's own* line box, not of `pixelSize` (R062).**
  With the app's CJK-capable stack that box is **1.47em** (22px at 15px), so `lineHeight: 1.2` *loosens*. To hit a
  **pixel** target use `lineHeightMode: Text.FixedHeight` + `lineHeight: <px>`. Measured valid pair:
  **FixedHeight 20 at font 15** in `EventDetailsPopover.qml:115-118`.
- **`pointer{target:"<label>"}` is a free geometry + live-state probe for `KosButton`s (R061)** — matches
  `item.text === label`, so it needs the **rendered/translated** label (`"添加"`; a miss logs `NaN NaN` and the capture
  is a silent no-op). Log carries the resolved centre **and** `hover`/`down`. Needs the item `visible` (drive to
  **monthPage** for 添加). `scrollInfo` cannot see buttons; this can.
- **`flat:` and `secondary:` are different branch groups in `KosButton.qml:53-65`.** `flat` rest = `"transparent"`,
  hover/press = `buttonHover`/`buttonPressed` (accent tint) **and it gains a 1px `border` rim** (`:69`, `:80`; inner
  highlight = `!flat || hovered`). `secondary` = `buttonNeutral*` (neutral grey), never gets an edge.
  `AppTheme.qml:97-99` owns all three tokens.
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green planning"
  ⇒ **(673,375)**. Card height is content-driven, so a *reused* y is a **silent no-op**. Read 编辑's centre off a frame
  first. **R062 caveat:** the popover y also differs 11px **between binaries** ⇒ never diff a y against another binary.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. `pointerObject` needs THREE
  commands.
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING**, drawn 1px inside the
  perimeter, exact `(43,115,160)`/`(45,115,159)` = `accent`@0.76 dark. `pressScale` 0.968 is ≤1px at height 31 —
  **never read "no animation" from a 31px band.**
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204) /
  `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69)/(79,79,79)/(89,89,89); destructive
  **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge token.
  **Dark card fill = (31,36,43)**; **popover** dark = **(38,38,38)**; window = (30,30,30); flat-button hover/press =
  **(35,60,81)/(36,67,92)**; `border` dark rim ≈**(71,78,87)**. `windowRaised` is **not** a neutral grey.
- **Esc semantics (R059): `escape` is a key event addressed to whoever holds `activeFocusItem`.** It closes a
  **focused** popup and does **nothing** to a `modal:false` popup that never takes focus. Ask *who has focus* first.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** P01's popover is a
  **浮层** (`spec.md:120` O08). A requirement written in a `D` row does **not** automatically bind the popover.
- **Dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**,
  x 384..730, centre x ≈ 557, pitch 37, gap 6 (light ≤1px the same). The **task** editor is the same shape **32px
  higher** (516/553/590) — always say *which* editor a footer number belongs to.
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056). Keep `interval ≤ duration/4`; frames land
  at 0, interval, 2·interval…; the recorder is non-blocking so keep `duration` under the 0.6s command spacing.
- **Diff bounding boxes FIRST, sample pixels second** (R058): `ImageChops.difference(...).getbbox()` separates
  "nothing happened" (`None`) from "a view switch" (≈whole window) at no cost. **R061 caveat:** a *neighbouring*
  widget's hover state can inflate the bbox.
- **Row-band measurement idiom that has now worked four times (R046/R062/R063/R064):** scan the target column for
  pixels that are **not** the background, threshold a per-row count (≥3–4), group into bands, read the band **centre**
  (text rows) or **start** (cap-tops). R064's whole T01 verdict came from this. **Caveat learned in R064:** keep the
  scan window strictly inside the intended region (x 0..60 spilled into the first day column and produced junk bands);
  x 2..50 was clean.
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open; press a button and the ring appears
  1–2px inset and **persists after release-outside**. On hover the ring is **covered by the hover fill**.
- **The reference macOS alert at rest shows NO focus ring** ⇒ "no ring at open" is the target, not a bug.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159)/(43,115,160).**
  `accent`(48,140,198) / `accentHover`(69,152,204) / `accentPressed`(85,161,208) are **identical in both themes**.
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse as
  JSON, filter `parent` + `visible:true`, and **take the last matching line**. It lists **Flickables/ScrollViews only
  — not `KosButton`s**.
- **The 4-step open chain and the 3-step click CAN go in ONE list**; the recording may be the **first** item.
  **`press` → `move` off the button → `release` outside** captures *pressed* without firing the click.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`). A rebuilt binary requires
  a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~12–14s before the new pid appears.
  Include `resize 1100x692` in the drive list. **`Bash` CWD drift is real** — the harness reset CWD to the task dir
  mid-round this time, and an earlier round saw the reverse; always `cd` explicitly or verify with `pwd`.
- **Fixtures on 2026-04-02** (live file = `profile/pim/calendar.ics`; the repo-root *`calendar-fixture.ics` is a stale
  copy with no VTODOs*): VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title** 11:00 / **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`**
  all-day strip spanning 3 days. VTODOs (kind `"todo"`): `[UI] Green planning` (09:00), `[UI] Gold review` (12:00),
  `[UI] Red review` (16:00), `A deliberately long task title to inspect elision` (11:00), **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (11:00 — a *repeated* long string; **the record for any wrapping-title test**).
  The month view's selected-day card is 添加's home. **R064:** in `view week` at `date 2026-04-02` the visible timed
  cells each held **one** chip (the two-chip cell was not in the visible band).
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its **border**
  only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark; event-editor card at
  x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in and
  **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — T02/T03: grid-line weight + gutter label form.** `apps/calendar/qml/CalendarScheduleView.qml` — the gutter
`Label` (now ~line 356) prints `06:00`-style 24h; the ref prints **`8 AM` / `Noon`**, and the ref's **all-day band
bottom separator is 2px (217,217,217)** vs its **1px (≈237) day-column separators** — a deliberate weight hierarchy.
Measure our line colours/widths first, then decide. **Read the ref crop before changing anything** (`.loop/refs/
macos-calendar.png`, crop x 243..812, y 150..200 and the gutter x 243..290, y 180..500). Do not touch `hourHeight`.
Re-measure label centres (**expect 40**) to confirm nothing regressed.

**Then (unlocked, ref-anchored, never reviewed — one per round):** A01 (all-day band: min 28, row 18, gap 2,
inset 2–3 — ref rows measure ≈15 ref-px ⇒ ≈20 scaled), **E01/E02** (chip language — the biggest unexamined mass; the
ref's light-fill + dark-same-hue-text + 2–3px left stripe + radius 3 vs our `radius: 5` 1px-border fill is the first
question), N02 (now-line + red badge — needs a capture of the **current** week), V01–V05 (month — **no ref anchor**,
use `spec.md` + HIG only).

**Optional QoL (only if a round has slack — NOT an atomic step of its own):** make `review-command.py` flatten the
nested form into `{"action": …}` so every later round stops paying the R064 diagnosis cost.

**Still blocked on rulings A–E** (unchanged, D/O family only): dim snap, shadow magnitude, popover Esc, `slice(0,2)` /
month 1-chip cap, E03 clause 3. **Not `DONE` — all spec IDs do not pass.**
