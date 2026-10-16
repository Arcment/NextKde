# R050 — **P01 narrow-window leg: the popover does NOT compress; material is size-invariant** (2026-10-16)

Atomic step: R049's Next-round #1 = P01's last un-re-judged corner — the detail popover at the **760x540**
minimum window (the condition that breaks the *task dialog's* form, 仍差 #3). Measurement + judgment only,
**no product code touched, no build**.

Route, light, one instance: `date 2026-04-02` → `view week` → `resize 760x540` → `openItem titleContains
"Long review"` → `nativeRecord r050-narrow` (16 frames, all 760x540). Then `escape` → `resize 1100x692` →
`openItem` the **same fixture** → `nativeRecord r050-wide` (13 frames). Same-fixture A/B, so the comparison
is not confounded by content.

### Measured — card fill bbox (flood-fill on the neutral (245,245,245) fill)

| | fill bbox | w | h |
|---|---|---|---|
| 760x540 | x 211–548, y 227–412 | **338** | **186** |
| 1100x692 | x 381–718, y 253–438 | **338** | **186** |

Content bands, in **card-relative** coordinates (rel x = ink left − fill left, rel y = ink top − fill top):

| band | rel x | rel y | ink run (narrow) | ink run (wide) |
|---|---|---|---|---|
| title (2 lines, h38) | 13 | 18 | 224–528 | 394–698 |
| date · time range | 13 | 69 | 224–424 (200) | 394–594 (200) |
| location | 14 | 95 | 225–331 (106) | 395–501 (106) |
| notes | 14 | 121 | 225–497 (272) | 395–667 (272) |
| 编辑 label | 277 | 151 | 488–511 (23) | 658–681 (23) |

**Every band sits at the identical card-relative offset and every ink run has the identical length** ⇒ nothing
reflows, nothing shrinks, nothing is clipped. The card is fully inside the window at 760x540 (210px of backdrop
either side, 128px below).

Material at the card's **top edge is byte-identical** in both captures: border/shadow profile at −4/−3/−2/−1
= **(236,236,236) (210,210,210) (204,204,204) (175,175,175)**, then fill (245,245,245). (The left/right edge
profiles differ only because the popover sits over a blue grid chip at narrow and over white at wide — backdrop,
not material.)

### Judgment

**P01 narrow leg = PASS.** The popover is the *counter-example* to 仍差 #3: the task dialog's form collapses at
760x540 because it is a layout-driven flex region; the popover's card is `width: 340 + 2*shadowInset`
(`EventDetailsPopover.qml:57`) with content-driven height and a `Layout.maximumHeight: 120` notes ScrollView, so
the window size never reaches it. 仍差 #3 stays open for the *dialogs* only; it does **not** generalise to overlays.

Recorded as still-unverified: the **dark** narrow leg (P01's dark leg is PASS at 1100x692, R047; the dark
760x540 case was not re-shot this round).

# R049 — E03 clause 3 ("tall blocks top align"): **BLOCKED on a ruling — no tall block exists in any view** (2026-10-16)

Atomic step: R048's Next-round #1 = judge E03 clause 3 in a view that has tall blocks. Measurement + judgment
only, **no product code touched, no build**.

Route, light, one restart: `start-review-vm.sh light` (from **repo root** ⇒ `captureClient` landed at repo root,
moved in after) → `date 2026-04-02` → `view month` → `captureClient r049-month.png` (1100x692).

### What was measured

**Month grid (`CalendarMonthView.qml`), 1100x692 light:**
- Row pitch **60.7px** — day-number ink tops at **y 165 / 226 / 287 / 348 / 408** (diffs 61/61/60/61).
- Day-number ink top → chip fill top = **+18px**.
- Every populated day cell shows **exactly one** chip; its fill band is **y 183 → 200, h = 18px** in *all six*
  populated columns. Chip x-runs **(6,148) (164,305) (321,463) (636,778) (794,935)** ⇒ column pitch **157.5**,
  chip width **143**, inter-cell gap **16**. 周四 2's run (473,626) w154 is the **selected-day rect**, 5px proud
  each side — not a wider chip.
- Overflow is rendered as a `+N` counter (**+8 +8 +11 +9 +7**), never as extra chips.
- Chip fill is **per-list tinted**, not the week view's uniform colour: **(241,247,251)** for 周一30's
  "Multi-day review", **(222,236,246)** for 周四2's "Morning planning".

**Only two grid components exist** (`apps/calendar/qml/`): `CalendarMonthView.qml` and
`CalendarScheduleView.qml`. The latter serves **both** week and day — `Main.qml:2502` `dayCount: 7`,
`Main.qml:2532` `dayCount: 1`. R048 measured it: timed chip fixed `Layout.preferredHeight: 21`, hour row fixed
`54` (`:353`), all-day chip fixed `18` (`:277`). A duration / startTime / endTime / span grep across all five
calendar QML files returns **nothing height-related**.

Line-number drift note: R048 cited the timed chip at `:388`/`:389`; by content it is now `:394`/`:395`.

### Verdict

Clause 3's precondition — a tall block — **never occurs in any of the three views**: month 18px fixed, week and
day 21px fixed, and no code path maps a duration to a height. So the clause **cannot be verified as PASS**, and it
is **not a text-alignment bug** either: there is no tall block whose text could be mis-aligned.

Against the ref this is a **structural divergence, not a vacuous clause**. `.loop/refs/macos-calendar.png` is the
**Week** view (`Day|Week|Month|Year`, Week active) and its timed blocks are unmistakably duration-proportional and
**top-aligned**: "Stretchin… 11AM–1PM" spans ~2 hour rows with its label at the top, "Writing s…" ~3–6PM,
"Drop off… 5:30–7PM", "Hike with… 10AM–12…" and "Plant gar…" are tall blocks, each with a top-anchored title and
its time caption **below** it.

⇒ Owner's call, same class as 仍差 #1/#2/#3 (declared criterion the build does not satisfy):
- **(a)** clause 3 presumes a proportional-block model the app replaced with fixed 21px agenda chips ⇒ **reword or
  drop clause 3**; or
- **(b)** the week/day view should gain duration-proportional, top-aligned blocks ⇒ a feature, not a tweak.

**E03 stays PENDING; clauses 1+2 remain PASS (R048). Do not mark E03 PASS, and do not "fix" this silently.**

### Negative finding recorded, to stop a future false defect
`ui-review-multiday` (`profile/pim/calendar.ics:570-575`, `DTSTART;VALUE=DATE:20260330`,
`DTEND;VALUE=DATE:20260403`) renders as **three separate 143px chips with a 16px gap** on 周一30 / 周二31 / 周三1,
not one bar spanning the row. **This is NOT a defect.** A 2x crop of the ref's all-day row
(`_r049-ref-allday2x.png`, ref x205–815 y125–180) shows the ref also uses **per-day-column chips**, stacked up to
**3** per column, with **no** spanning bar. "Multi-day events should be one continuous bar" is not a finding.

### New 仍差 #8 (measured, needs a ruling)
**Month day cell holds 1 chip + `+N`; the ref holds 3 stacked chips.** Ref columns show 3 chips each
("Antonio…"×2 + "Palm Sun…"; "April Fool…" + "Passover" + "Take out t…"), ours show 1 (`+8/+8/+11/+9/+7`). Same
family as 仍差 #7 (schedule view `slice(0,2)`): both are silent per-cell caps with no affordance.

### Instrument notes added this round
- **`captureClient` has no `file` field — the key is `path`**: `{"action":"captureClient","path":"x.png"}`;
  `view` is `{"action":"view","view":"month"}`; `date` is `{"action":"date","date":"2026-04-02"}`
  (`harness/Main.qml:122/217/221`).
- **Do not locate a month chip by fill colour.** Month chips are list-tinted ((241,247,251) and (222,236,246)
  measured for two different lists) and one of them sits inside the selected-day rect. Use row/column geometry.
- **The month grid draws no cell borders at all** — a column scan at x=1010 over y 140–500 returns pure white
  through every row boundary. Cell geometry must be inferred from day-number ink and chip runs, never from rules.
- Sampling a chip's mid row hits text ink: at x=60 the 18px chip reads (241,247,251) at y184-188 but (187,187,195)
  at y190. Sample y = chip_top+2, not chip_mid.

---

# R048 — **E03 row elision, week view: clauses 1+2 PASS measured; clause 3 ("tall blocks top align") not judgeable here** (2026-10-16)

## 本轮 (R048)
Atomic step: Next round #1 of R047 = **E03, the long title's *row* elision, week view first**. Measurement +
judgment only, **no product code touched, no build**.

Route, light, one restart: `start-review-vm.sh light` (from **repo root** ⇒ `captureClient` landed at repo root,
moved in after) → `date 2026-04-02` → `view week` → `captureClient r048-week.png` (1100x692).

**Declared criterion first** (`apps/calendar/qml/CalendarScheduleView.qml`): both the all-day chip (`:292`) and the
timed chip (`:413`) are a `Label` with `anchors.fill: parent`, **`anchors.leftMargin: 5` / `anchors.rightMargin: 4`**,
`font.pixelSize: 9`, `verticalAlignment: VCenter`, **`elide: Text.ElideRight`**. Chips are fixed
**`Layout.preferredHeight: 21`** (`:389`); timed cell shows **`hourCell.cellItems.slice(0, 2)`** (`:388`, all-day
`:270`); a trailing `Item { Layout.fillHeight: true }` (`:428`) top-packs each cell.

**Week-grid geometry measured** (vertical rules at y 165..470): **x = 52, 201.5, 351.5, 501.5, 651.5, 801.5,
951.5** ⇒ column pitch **149.5**, chip inset **3px** each side ⇒ chip width **144**. Chip fill light
**(216,234,245)**.

### E03 clause-by-clause

| # | clause | verdict | evidence |
|---|---|---|---|
| 1 | short blocks show **one readable priority line** | **PASS** | every chip is one line, VCentered, no wrap, colour-coded by list ("Morning planning" / "Short appointment" / "Design review", 6 columns) |
| 2 | long titles **elide inside bounds** | **PASS (2 measurements)** | see table below |
| 3 | **tall blocks top align** | **NOT JUDGEABLE HERE** | no tall block exists to test — `:389` forces every timed chip to 21px, so the week view has **no duration-proportional block**. Cells *are* top-packed (`:428`), but that is not the clause. Needs a view whose blocks vary with duration (month view / day column) — carried below. |

**Latin, 周一 30 · 11:00 cell** — chip x **55→198** (144), ink **61→192**:

| property | declared | measured |
|---|---|---|
| text-box left | chip+5 = 60 | first ink **61** (1px left bearing) ✓ |
| text-box right | chip−4 = 194 | last ink **192** ⇒ **2px inside the declared box, 6px clear of the chip edge** ✓ |
| tail glyph | `…` from `ElideRight` | three dark dots at **x 186 / 189 / 192** (pitch **3px**, min-lum 77) = a literal `…`, **not** a fade or a hard clip ✓ |
| row bounds | chip 55→198 | ellipsis **inside**, no ink at 194–198 (fill 213–222), 199–200 white gutter ✓ |

**CJK, 周四 2 · 11:00 second chip** ([R019 LONG TASK] …) — chip x **505→648**, ink **511→641**:
`…` dots at **634 / 637 / 640**; declared box right = 644 ⇒ **inside**. The glyph **immediately before** the dots
is a **complete** CJK box (**x 625–632**, 8px, clean fill gap at 633) ⇒ **no mid-glyph clip, no ellipsis-over-glyph
overlap** — the failure mode CJK elision usually has. ✓

**Verdict: E03 = clauses 1 & 2 PASS by measurement; clause 3 deferred (not failed) — the week view cannot exhibit
it.** E03 stays PENDING until clause 3 is judged in a view that has tall blocks.

**New observation, NOT filed as an E03 defect (new 仍差 #10):** `slice(0, 2)` (`:388`) silently caps a cell at two
chips with no `+N` affordance. On **2026-04-02 11:00** the fixtures hold **three** items — the event "Long review
with a deliberately lengthy title", the VTODO at `profile/pim/calendar.ics:91` "A deliberately long task title to
inspect elision" (**DUE 20260402T110000**), and the VTODO at `:287` "[R019 LONG TASK] …" — and the 周四 11:00 cell
renders exactly **two** (the event + the `:287` VTODO). The `:91` VTODO is **dropped silently**. E03's text covers
elision, not overflow, so this is an observation needing a ruling (show `+1`, or scroll the cell), not a claim on
E03.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **Measured on four transitions (R043/R044-c60/R044-c12/R045)**: enter = page steps 255→204 in one
   frame with the card still at α=0.00; exit = page steps 204→255 in one frame with the card still at α=1.00.
   App-wide (every workspace dialog). Needs a ruling — fix = bind the `Overlay.modal` rectangle's opacity to
   `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **Form compresses instead of scrolling at 760x540**: notes viewport **96 → 39px**, card 555 → 471.
   `CalendarTaskEditorDialog.qml:32-33` claims "only the form above it scrolls". App-wide sibling: the event editor.
   Same class as #1 (comment says one thing, layout another).
4. D02's literal-criterion deviation: radius 16 (`smallRadius + 4`) vs spec's named `largeRadius` 24 /
   `windowCornerRadius` 32. 2-file change if the owner insists. Recommendation: keep 16.
5. Card centre sits **+7px right** of window centre at both window sizes, both themes (R041). Cosmetic.
6. **E03 clause 3 open** ("tall blocks top align") — week view has only fixed 21px chips (`:389`); judge in a view
   where block height tracks duration (month view / day view). Clauses 1+2 **PASS (R048)**. Then O01–O03 tooltip,
   O08/X07 four-overlay coordination.
7. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never checked
   vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered. Also open from R045: the
   disabled footer button's accent→disabled blend animates (~0.69 → 0.63 over 52ms) — a pill-based α probe is fooled.
8. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it. **(#9 dark-button-border Δ4/255 folded
   into rounds.md — cosmetic, no ID.)**
9. NEW (R048): **`slice(0, 2)` per cell hides items with no `+N`** — 周四 2 · 11:00 shows 2 of 3 fixtures; the
   `calendar.ics:91` VTODO (due 11:00) is dropped silently. Needs a ruling.

## 最近已改 (most recent 8)
1. R048 — measurement + judgment only, **no code change**; **E03 clauses 1+2 PASS** (elide literal `…` measured at
   pitch 3px, ink 192 vs box limit 194 / chip edge 198 for Latin; ink 641 vs limit 644 with a **complete** CJK glyph
   before the dots); clause 3 **not judgeable in the week view** (fixed 21px chips) ⇒ E03 stays PENDING; new 仍差 #9.
2. R047 — measurement + judgment only, **no code change**; **P01 long-text dark leg PASS** ⇒ **P01 CLOSED both
   themes** (dark: fill (38,38,38), border (42,42,42) 1px at x 380/719, title (242,242,242) 2 lines 412→636/413→517
   vs limit 705, secondary (164,164,164), dot 10×10 (57,196,135)); `closeButton` 22×22 identified as the ✕ at
   691–698.
3. R046 — measurement + judgment only, no code change; **P01 long-text light PASS** (card 340×136 at 380,278, fill
   (245,245,245), title 2 lines x 412→635 vs limit 705, `#1A1A1A` exact, dot 10×10 (57,196,135), pill 44×24); ref
   confirmed to contain **no popover**; `openAt(null)` centring identified as a harness artifact.
4. R045 — measurement only; exit re-measured at honest sampling ⇒ **≈125ms = declared `motionFast` 120**; D10 full
   pass; probe moved to uniform-bar underlay (α resolution 0.125 → 0.032).
5. R044 — measurement only; enter = **220ms at both interval 60 and 12** (declared `motionNormal`); R043's 440ms
   does not reproduce; five-point calibrated α probe introduced.
6. R043 — measurement only; dim snap structurally confirmed; `args`→flat command schema trap documented.
7. R042 — measurement only; D10 exit **scale** → PASS (0.971 vs 0.9728 declared), 仍差 #5 closed.
8. R041 — measurement only; dark task-dialog footer → PASS, 仍差 #6 closed; light≡dark layout established;
   R040's narrow notes number corrected 73 → 39px.

## 外推待确认 (do NOT assume)
- **`tmp/` is gitignored — nothing under it is tracked.** `git add tmp/ui-acceptance/calendar/state.md` fails with
  "paths are ignored"; `git ls-files tmp` is empty. The round's *committable* artifact is a mirror under
  **`docs/ui-calendar/`**: copy the screenshot in (`round-48-e03-week-elision.png`) and **prepend** the round
  summary to `docs/ui-calendar/LEDGER.md` (newest first — R046 sits at line 1 of it, R047 did not prepend).
  `state.md` / `rounds.md` themselves can never be committed; that is expected, not a failure.
- **The week view has NO duration-proportional blocks.** Every timed chip is `Layout.preferredHeight: 21`
  (`CalendarScheduleView.qml:389`); an event's length never changes its rendered height. E03's "tall blocks top
  align" therefore **cannot** be judged in the week view — do not read the uniform chips as a pass or a fail.
- **Week-grid geometry: vertical rules at x = 52, 201.5, 351.5, 501.5, 651.5, 801.5, 951.5** (pitch 149.5) at
  1100x692. Chips inset 3px ⇒ 144 wide. Chip fill light **(216,234,245)**. Hour-row pitch ≈ 54px.
- **`ElideRight` here emits a literal `…`, not a fade** — three dots at pitch 3px, min-lum ~77 on a 216 fill.
  Do not judge "elided?" by eye alone at 1x; the dots read as faint grey. **Confirm by column min-lum profile.**
- **A cell renders at most 2 chips** (`slice(0, 2)`, `:388` timed / `:270` all-day). Three long fixtures collide on
  2026-04-02 11:00; the `calendar.ics:91` VTODO is silently dropped. Fixture set: `:91`, `:287`, and the
  "Long review with a deliberately lengthy title" event (`:371/:407/:621/…`) all land on 04-02.
- **`openItem` centres the popover; it does NOT anchor it.** `Main.qml:1314` → `openAt(null)`;
  `EventDetailsPopover.qml:258-277`'s `null` branch sets x = (host.w − root.w)/2 clamped, same for y. Measured
  x 380 / y 278 = that arithmetic exactly, **in both themes** (R046 light, R047 dark). **Never judge popover
  position from a harness-driven open** — only its material, content and hierarchy. A real click passes a point.
- **P01 is judged against HIG convention, not against the ref.** `.loop/refs/macos-calendar.png` (814x522) is a
  month view + sidebar with **no popover**. Same class as D01/D02/D03/D06/D07/D10. The ref *does* show row elision
  with a trailing `…` ("Antonio…", "April Fool…", "Status…") — that is the convention R048 measured.
- **The popover header is dot → title → `closeButton` (22×22, `objectName:"detailsClose"`), `:96-125`.** The ✕ sits
  at x 691–698 / y 310–317 and its right edge is the content limit 705. Do not mistake it for overflow ink.
- **The `EventDetailsPopover` qsTr source is English (`"Edit"`, `:224`) but the VM renders `编辑`.** Translations are
  live in the review profile. Do not report a source/render label mismatch as a bug.
- **The secondary line left-aligns to the status dot (x = fill+14), not to the title (x = fill+32).** Measured x 394
  in dark, 395 in light. Expected (second `RowLayout` child), not a defect.
- **`openItem` alone raises the *popover*, not the Dialog** — no dim, page stays 255. The Dialog (and its dim, and
  `revealProgress`) requires `pointerObject detailsEdit` **move, press, release** (three commands) after it.
- **A fresh enter needs an app restart.** After `escape` the day-view selection is gone; the route does NOT restore
  it. Restart via `start-review-vm.sh light|dark`; `kill` the pid in `live-app.pid` **by content — never
  `pkill -f 'kos-calendar'`: that pattern matches the driving shell itself** and kills the tool call (exit 144).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — it must be backgrounded** (harness `run_in_background`, or
  `&`). Wrapping it in `timeout 180` kills the app with it. Give it ~15s before driving.
- **`captureClient` paths resolve against the launcher's CWD.** Launching from repo root writes the PNG to the repo
  root, **not** to `tmp/ui-acceptance/calendar/`. Either launch from the calendar dir (but then `nativeRecord`
  prefixes break — see below) or move the files in afterwards. `nativeRecord` prefixes assume repo root.
- **`captureClient` returns a fresh frame pre-resize** (R046: two calls 6s apart over DIFFERENT states gave different
  md5s at identical byte size 3050463 — **equal file size is NOT evidence of a stale buffer; compare md5**). It still
  returns a stale 1100x692 buffer *after* a resize, reproduced 5×. **Frames track `resize`, `captureClient` does
  not** — burst first, resize second, read frame 3+.
- **The α probe is the instrument of record.** Backdrop measured per point from the last *undimmed* frame, scaled
  ×0.8; α = (m − backdrop)/(247 − backdrop). Self-checks: α=1.00 while expected, α=0.00 at the end. The pill left
  edge is only a ±0.14-in-p resolution cross-check, never the primary read.
- **Frame pacing degrades under capture load, reported timing does not.** Prefer a *discrete* event (the dim
  204↔255 step) as the t0 anchor — it brackets t0 to one frame regardless of pacing.
- **Harness command fields are FLAT** (`Main.qml:217/221/225`): `command.date`, `command.view`, `command.kind`,
  `command.titleContains`. **`args` nesting is a silent no-op that still advances `sequence`.**
- **The recorder is wall-clock** (`Main.qml:24`) behind a QML `Timer` (`:19-22`) whose blocking `capture()` (`:36`)
  starves the loop. Poll timer for `command.json` is `interval:100` (`:98-100`) ⇒ command latency 0–100ms;
  **in-place write only** (an atomic replace trips the QML dir watcher).
- **`nativeRecord` frame paths resolve against the app's CWD.** Launching `start-review-vm.sh` from
  `tmp/ui-acceptance/calendar/` produced **94 frames with `"saved":false`** and no error — the only tell is
  `"saved":false`. Prefixes assume repo root: start from there.
- **The dim gone ⇒ page 255, present ⇒ 204** at (1040,400) in light (0.20). A genuine discontinuity no clock error
  can manufacture; the most reliable **t0 anchor** for a dialog transition, in *both* directions.
- **`pointerObject` needs THREE commands, one per event: `kind` ∈ {`move`,`press`,`release`}.** No `events` array.
  A single call with an unknown/absent kind silently sends one `MouseMove` (`.cpp:73`) and closes nothing.
- **`capture` is NOT a harness action** — it falls through to the manual branch (`harness/Main.qml:249`) and saves
  nothing. Use `captureClient` or `nativeRecord`.
- **`nativeRecord` is the burst mechanism** (`harness/Main.qml:112-121`): `{action:"nativeRecord", prefix,
  duration, interval}` → `<prefix>-NNNN.png`. Real spacing ≈ interval + ~21ms idle, up to ~62ms under animation load.
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark** — not KosDialog, not the calendar app.
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)). Locate a light
  field box by its **border** (222,224,226) only; fill-based probes over-reach (this is how R040 got 73px).
- **The popover's fill is `#F5F5F5` light / `#262626` dark — NOT the editor dialogs' `#F7F7F7`.** Two different
  neutrals; do not carry a measurement from one to the other.
- **D02's radius is 16**, not 24 (`smallRadius + 4`, both dialogs). **D03's fill is `#F7F7F7`**, not `cardSurface` —
  deliberate P02 override, identical in both dialogs.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion` (`:26`,
  false here). **No duration scale exists in AppTheme.** `KosDialog.qml:10-11` — the *only* animated properties are
  `opacity`/`scale` via `revealProgress`; exit = `AppTheme.motionFast` + **InCubic** (`:24-32`).
- The task dialog's footer buttons are **full-width stacked** (保存 accent pill spans x 384–730, centre 557; 取消
  below it) — not macOS's content-sized right-aligned row. Already recorded as a HIG-convention match.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6. Unresolved which D06 is judged
  against. macOS alerts have no third action; our Delete row extrapolates "destructive goes last".
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary and old `accentText` primary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34** (`AppTheme.qml:171` × densityScale ≈0.912 ⇒ 31).
  Same CJK-leading mechanism as 仍差 #8.
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `long-label.py` is the *sidebar list* fixture (S05) and is currently restored to "Inbox".
- Save is deliberately NOT exercised (isolated-profile discipline).

## Next round (pick ONLY #1)
**E03 clauses 1+2 are measured PASS and must not be re-opened. What is left is clause 3, plus the popover corner
R047 deferred.**

**#1 — E03 clause 3: "tall blocks top align", in a view that *has* tall blocks.** The week view cannot show it
(`:389` fixes every chip at 21px). Go to the **month view** (`view month`, `date 2026-04-02`,
`captureClient r049-month.png`) — that is also where the ref's own `…` convention lives. Then, for each day cell
with 3+ items / a taller block, measure:
- the **first** block's `y` vs the cell's content-top (`y_cell_top + margins`) — "top align" means the first block
  starts at the inset, not centred/vertically-distributed;
- whether the **last** block's `…` again lands inside the block (R048's method: column min-lum profile, 3 dots at
  pitch 3px) at **long titles** in a taller row.
- If the month view also has fixed-height rows, say so plainly in state.md and judge clause 3 on whatever the
  all-day / multi-day "Multi-day review" chip does — **do not invent a tall block**.

**#2 (after #1) — P01's narrow-window popover**, the last un-re-judged P01 corner: resize to 760x540 and check the
card doesn't compress the way the task dialog's form does (仍差 #3). Burst first, resize second, read frame 3+
(`captureClient` returns a stale buffer post-resize).

**#3 (deferred) — 仍差 #9 `slice(0,2)` silent drop** needs a ruling before anyone "fixes" it.
