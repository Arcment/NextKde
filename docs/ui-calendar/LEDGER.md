# R051 — **P01 dark narrow leg PASS ⇒ P01 CLOSED (2 themes × 2 window sizes)** (2026-10-16)

## 本轮 (R051)
Atomic step: R050's Next round #1 = **P01's narrow-window (760x540) popover, dark**. Measurement + judgment
only — **no product code touched, no build**.

The live instance was **light** (`/proc/95488/environ` → `KOS_APPEARANCE=light`), so it was killed and
`./start-review-vm.sh dark` cold-started (pid 98047, dark confirmed from `/proc`). Method copied from R050
exactly: `date 2026-04-02` → `view week` → `resize 760x540` → `openItem titleContains "Long review"` →
`nativeRecord r051-narrow-dark` (15 frames); then `escape` → `resize 1100x692` → `openItem` the **same
fixture** → `nativeRecord r051-wide-dark` (14 frames). Same-fixture A/B ⇒ content cannot confound it.

**Steadiness:** every follow-up frame is **byte-identical** to frame 0000 in both series
(`ImageChops.difference` bbox `None`, 14/14 and 13/13) ⇒ the popover is fully static over 1.5 s — no reflow, no
shake, no animation.

**Card fill bbox** (flood-fill over the dark (38,38,38) fill):

| window | fill bbox | w | h |
|---|---|---|---|
| 760x540 | x 210–549, y 226–413 | **340** | **188** |
| 1100x692 | x 380–719, y 252–438 | **340** | **187** |

(The 1px height delta is a flood-fill edge artifact, not content.) Horizontally the card is **exactly centred**
in both windows (gaps 210/210 and 380/380).

**Content bands, card-relative** — identical offsets *and* identical ink lengths in both legs:

| band | rel x | rel y | ink run narrow | ink run wide |
|---|---|---|---|---|
| title, 2 lines h38 | 14 | 19 | 14–318 (305) | 14–318 (305) |
| date · 11:00 – 13:00 | 14 | 70 | 14–214 (201) | 14–214 (201) |
| location | 15 | 96 | 15–121 (107) | 15–121 (107) |
| notes | 15 | 122 | 15–288 (274) | 15–288 (274) |
| 编辑 label | 278 | 148 | 278–325 (48) | 278–325 (48) |

Top-edge material **byte-identical** in both: y0−1 border (43,43,43), y0−2/−3 shadow ramp (16,16,16)/(17,17,17),
y0 fill (38,38,38). Dark baseline re-confirmed against R047: fill (38,38,38) ✓, border 43≈42 ✓, title ink
(242,242,242) ✓, secondary ink (164,164,164) ✓.

**The one apparent narrow/wide difference was an artifact.** The wide frame's extra band at rel y 179–185 exists
at **only rel x 1,2,5,6 and 333–338** — the card's own rounded corners + border over a blue-tinted backdrop
(that row is pure fill at card centre-x in *both* frames). Backdrop, not material.

**Status dot:** 10×10 at card-relative **x 14–23, y 31–40**, peak **(48,140,198)** accent blue, identical in
narrow dark, wide dark and narrow light. **R047's recorded "(57,196,135) green dot" does NOT reproduce** — 0
pixels within ±30 of it anywhere in either dark frame.

⇒ **P01 dark narrow leg = PASS**, and with it **P01 is CLOSED**: PASS at 1100x692 light (R046), 1100x692 dark
(R047), 760x540 light (R050), 760x540 dark (R051). The popover does not compress in either theme at either size;
it is the standing **counter-example to 仍差 #3**, which stays a *dialog-only* finding.

Evidence: `round-51-popover-dark-narrow-vs-wide.png` (2x side-by-side, aligned on the fill bbox),
`round-51-popover-dark-760x540.png`, `round-51-popover-dark-1100x692.png`.

**Next round #1:** fix **仍差 #3** — the editor dialogs compress instead of scrolling at 760x540
(`CalendarTaskEditorDialog.qml:32-33` plus the event-editor sibling); the top-ranked 仍差 item that needs no
ruling.

# R050 — **P01 narrow leg PASS: the popover does not compress; card is size-invariant** (2026-10-16)

## 本轮 (R050)
Atomic step: R049's Next round #1 = **P01's narrow-window (760x540) popover**. Measurement + judgment only,
**no product code touched, no build**.

Route, light, one instance (reused the live R049 pid — it was still up): `date 2026-04-02` → `view week` →
`resize 760x540` → `openItem titleContains "Long review"` → `nativeRecord r050-narrow` (16 frames, **all
760x540** ⇒ the resize did land). Then `escape` → `resize 1100x692` → `openItem` the **same fixture** →
`nativeRecord r050-wide` (13 frames). **Same-fixture A/B**, so content cannot confound the comparison.

**Card fill bbox** (flood-fill over the neutral (245,245,245) fill; card = fill ±1px border):

| window | fill bbox | w | h |
|---|---|---|---|
| 760x540 | x 211–548, y 227–412 | **338** | **186** |
| 1100x692 | x 381–718, y 253–438 | **338** | **186** |

**Content bands in card-relative coords** (rel x = ink left − fill left, rel y = ink top − fill top):

| band | rel x | rel y | ink run narrow | ink run wide |
|---|---|---|---|---|
| title, 2 lines h38 | 13 | 18 | 224–528 | 394–698 |
| date · 11:00 – 13:00 | 13 | 69 | 224–424 (200) | 394–594 (200) |
| location | 14 | 95 | 225–331 (106) | 395–501 (106) |
| notes | 14 | 121 | 225–497 (272) | 395–667 (272) |
| 编辑 label | 277 | 151 | 488–511 (23) | 658–681 (23) |

**Identical offsets, identical ink-run lengths** ⇒ no reflow, no shrink, no clip. Card fully inside 760x540
(210px backdrop each side, 128px below). Top-edge **material is byte-identical** in both captures:
−4/−3/−2/−1 = **(236,236,236) (210,210,210) (204,204,204) (175,175,175)** then fill (245,245,245).

⇒ **P01 narrow leg = PASS.** The popover is the **counter-example to 仍差 #3**: `EventDetailsPopover.qml:57`
`width: 340 + 2*shadowInset` (window-size-independent) + content-driven height + notes
`Layout.maximumHeight: 120` ScrollView (`:171-174`). #3 stays open for the **dialogs only**; do not
generalise it to overlays.

**Not verified this round (do not assume):** the **dark** 760x540 leg. P01's dark leg is PASS at 1100x692 (R047).

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. Measured over four transitions (R043–R045): enter = page steps 255→204 in one frame with the card
   still at α=0.00; exit = 204→255 in one frame with the card still at α=1.00. App-wide. Needs a ruling —
   fix = bind the `Overlay.modal` rectangle's opacity to `revealProgress`. Do not "fix" silently.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. Needs a ruling.
3. **Form compresses instead of scrolling at 760x540** — *dialogs only* (R050 shows the popover is immune):
   notes viewport **96 → 39px**, card 555 → 471. `CalendarTaskEditorDialog.qml:32-33` claims "only the form above
   it scrolls". Sibling: the event editor. Same class as #1 (comment says one thing, layout another).
4. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px,
   week/day 21px, all fixed, no duration→height code path), while the ref's week view *does* show proportional
   top-aligned blocks ⇒ decide reword-the-clause vs build-proportional-blocks. Clauses 1+2 PASS (R048).
5. `KosButton.qml:67-68` — secondary regains a 1px `AppTheme.border` rim on **hover or activeFocus**; never
   checked vs ref. `buttonNeutralHover`/`Pressed` never captured; no button has ever been hovered. Also open from
   R045: the disabled footer button's accent→disabled blend animates (~0.69 → 0.63 over 52ms).
6. **Line pitch 22px at font 15 = 1.47** (R046/R047, both themes) — CJK font-stack leading; same root cause as the
   recorded `controlHeight` 31-vs-34. App-wide. Cosmetic, no ID covers it.
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3 fixtures; the
   `calendar.ics:91` VTODO (due 11:00) is dropped silently. Needs a ruling.
8. **Month day cell holds 1 chip + `+N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1
   (`+8/+8/+11/+9/+7` measured). Same family as #7. Needs a ruling.
- *Cosmetic, no ID, folded out of the top-8 (in rounds.md):* card centre sits **+7px right** of window centre at
  both window sizes, both themes (R041); D02's radius is **16** vs the spec's named `largeRadius` 24 /
  `windowCornerRadius` 32 — recommendation stands: **keep 16**.

## 最近已改 (most recent 8)
1. R050 — measurement + judgment only, **no code change**; **P01 narrow leg PASS** — same-fixture A/B at
   760x540 vs 1100x692: card fill bbox 338×186 **both**, all five content bands at identical card-relative
   offsets with identical ink-run lengths, top-edge material byte-identical ⇒ no compression. Popover is the
   counter-example to 仍差 #3 (dialogs only). Dark narrow leg left un-shot.
2. R049 — measurement + judgment only, no code change; E03 clause 3 **BLOCKED on a ruling** (no tall block
   exists in any view); new 仍差 #8 (month cell cap 1 vs ref 3); negative finding: per-day multi-day chips are
   *correct* (ref does the same).
3. R048 — measurement + judgment only, no code change; **E03 clauses 1+2 PASS** (elide literal `…` at pitch 3px).
4. R047 — measurement + judgment only, no code change; **P01 long-text dark leg PASS** ⇒ P01 CLOSED both themes.
5. R046 — measurement only; **P01 long-text light PASS**; ref confirmed to contain **no popover**.
6. R045 — measurement only; exit re-measured ⇒ **≈125ms = declared `motionFast` 120**; D10 full pass.
7. R044 — measurement only; enter = **220ms at both interval 60 and 12** (declared `motionNormal`).
8. R043 — measurement only; dim snap structurally confirmed; `args`→flat command schema trap documented.

## 外推待确认 (do NOT assume)
- **The popover's card geometry is window-size-invariant and content-driven** (R050). At 760x540 and 1100x692 the
  fill bbox is 338×186 for the *same* fixture, and every content band keeps its card-relative offset. Consequence:
  **never explain a popover geometry change by window size** — it is set by `EventDetailsPopover.qml:57`
  (`340 + 2*shadowInset`) and by content. A *different* card height means a *different fixture*: the event
  "Long review…" (date+location+notes) is **h186**, the task "A deliberately long task title…" (time only) is
  **h134** (`p01-long-popover.png`) — a 52px difference that is content, not compression.
- **The popover is the counter-example to 仍差 #3.** #3 is a *dialog* finding; do not carry it to overlays.
- **Harness `openItem(NULL)` vertical centring does not reproduce at 760x540** (card top 227 with a 186-tall card
  ⇒ 320 centre vs the 270 window centre), while at 1100x692 it lands centred (253 + 93 = 346 = 692/2). Recorded,
  **not a defect** — R046 already ruled harness-driven popover *position* unjudgeable; judge material/content only.
- **`resize` does land** — all 16 narrow frames are genuinely 760x540. But `captureClient` still returns the stale
  pre-resize buffer, so **after any `resize`, capture with `nativeRecord`, not `captureClient`**.
- **A live instance is reusable across rounds.** `start-review-vm.sh` prints "Owned review instance still
  running: <pid>" and returns without launching; the pid in `live-app.pid` answers harness commands fine. Kill it
  by the pid **read from `live-app.pid`** — never `pkill -f 'kos-calendar'` (that pattern matches the driving
  shell and kills the tool call, exit 144).
- **`nativeRecord` frames land in the app's CWD = repo root**, not in `tmp/ui-acceptance/calendar/`. Move them in.
- **Month-view geometry (R049, 1100x692 light).** Row pitch **60.7px**; day-number ink tops **y 165 / 226 / 287 /
  348 / 408**; chip fill band **y 183 → 200 (h 18)**; chip x-runs **(6,148) (164,305) (321,463) (636,778)
  (794,935)** ⇒ pitch **157.5**, chip w **143**, gap **16**. Selected-day rect **x 473 → 626** (w 154 = chip ±5).
- **Month chip fill is per-list tinted, NOT the week chip's uniform (216,234,245)**: measured **(241,247,251)**
  and **(222,236,246)**. Locate a month chip by *shape/position*, not fill. The month grid draws **no cell
  borders at all** — infer geometry from day-number ink and chip runs, never from rules.
- **`CalendarScheduleView.qml` line numbers drift** (~+6 since R048). Timed chip now **`:394`/`:395`**, all-day
  chip `:277`, hour row `:353`. **Re-anchor by content, never by an earlier round's line number.**
- **There is no third "agenda" view.** Week and day are the *same* `CalendarScheduleView` with `dayCount` 7 vs 1
  (`Main.qml:2502` / `:2532`).
- **The ref is the Week view** (`Day|Week|Month|Year`, Week active): all-day row stacks up to **3** chips per day
  column; timed blocks are **duration-proportional and top-aligned**; red `9:41` now-line.
- **Per-day segmentation of a multi-day event is correct, not a defect** (ref does the same; no spanning bar).
- **`tmp/` is gitignored.** The committable artifact is a mirror under **`docs/ui-calendar/`**: copy the
  screenshot in and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md` /
  `rounds.md` can never be committed — expected, not a failure.
- **The week view has NO duration-proportional blocks.** Every timed chip is `Layout.preferredHeight: 21`.
- **Week-grid geometry: vertical rules at x = 52, 201.5, 351.5, 501.5, 651.5, 801.5, 951.5** (pitch 149.5) at
  1100x692. Chips inset 3px ⇒ 144 wide. Chip fill light **(216,234,245)**. Hour-row pitch ≈ 54px.
- **`ElideRight` here emits a literal `…`, not a fade** — three dots at pitch 3px. Confirm by column min-lum
  profile, not by eye at 1x.
- **A cell renders at most 2 chips in the schedule view** (`slice(0, 2)`) and **at most 1 in the month view**.
  Three long fixtures collide on 2026-04-02 11:00; the `calendar.ics:91` VTODO is silently dropped.
- **`openItem` centres the popover; it does NOT anchor it.** `Main.qml:1314` → `openAt(null)`;
  `EventDetailsPopover.qml:258-277` null branch. **Never judge popover position from a harness-driven open.**
- **P01/E03 are judged against HIG convention, not the ref** where the ref has no such surface. The ref has **no
  popover**; it *does* show row elision with a trailing `…`.
- **The popover header is dot → title → `closeButton` (22×22, `objectName:"detailsClose"`), `:96-125`.** The ✕ sits
  20px inside the card's right edge (measured at both window sizes in R050).
- **The `EventDetailsPopover` qsTr source is English (`"Edit"`, `:224`) but the VM renders `编辑`.** Not a bug.
- **The secondary line left-aligns to the status dot (x = fill+14), not to the title (fill+32).** Expected.
  R050 measured date/location/notes all at fill+13/+14 and the title's *dot* at fill+13.
- **`openItem` alone raises the *popover*, not the Dialog** — no dim, page stays 255. The Dialog requires
  `pointerObject detailsEdit` **move, press, release** (three commands).
- **A fresh enter needs an app restart** after `escape` (the day-view selection is not restored).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it.** Wrapping it in `timeout 180` kills the app.
- **`captureClient` key is `path`**, not `file`; `view` is `{"action":"view","view":"month"}`; `date` is
  `{"action":"date","date":"2026-04-02"}`.
- **The α probe is the instrument of record.** Backdrop per point from the last *undimmed* frame, ×0.8;
  α = (m − backdrop)/(247 − backdrop). Pill left edge is only a ±0.14 cross-check.
- **Frame pacing degrades under capture load, reported timing does not.** Use the *discrete* dim step
  (204↔255 at (1040,400) light) as the t0 anchor.
- **Harness command fields are FLAT** (`Main.qml:217/221/225`). **`args` nesting is a silent no-op.**
- **In-place write only** to `command.json` (atomic replace trips the QML dir watcher). Poll is `interval:100`.
- **`nativeRecord` is the burst mechanism**: `{action,prefix,duration,interval}` → `<prefix>-NNNN.png`.
- **`capture` is NOT a harness action.**
- **The dim is `KosWorkspaceDialog`'s `Overlay.modal`, 0.20 light / 0.42 dark.**
- **In light, the notes field is indistinguishable from the card fill** (#F7F7F7 vs (248,248,249)) — locate a light
  field box by its **border** (222,224,226) only.
- **The popover's fill is `#F5F5F5` light / `#262626` dark — NOT the editor dialogs' `#F7F7F7`.**
- **D02's radius is 16**, not 24. **D03's fill is `#F7F7F7`**, not `cardSurface`.
- `motionFast` = **120**, `motionNormal` = **220** (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
- The task dialog's footer buttons are **full-width stacked** — not macOS's content-sized right-aligned row.
- Accent measured (48,140,198) in **both** themes; `defaultAccentSeed` is #3478f6.
- `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
  outlined secondary. Not a regression.
- **`controlHeight` renders as 31px here, not the spec's 34.**
- **Raw `pointer` needs x/y; for a named target always use `pointerObject`.** `{"action":"pointer","kind":"click"}`
  is a **no-op**. `pointerObject` needs THREE commands: `move`, `press`, `release`.
- Fixtures live on **2026-03-29..04-04** in `profile/pim/calendar.ics`; always send `date` first, in its own batch.
  `long-label.py` is the *sidebar list* fixture (S05), currently "Inbox".
- Save is deliberately NOT exercised (isolated-profile discipline).

## Next round (pick ONLY #1)
**#1 — P01 dark narrow leg** (760x540, dark): the one corner R050 deliberately left un-shot. Reuse the R050
method exactly — `nativeRecord` for both legs, same fixture, compare *card-relative* band offsets. Re-establish
the dark baseline numbers first (R047, 1100x692 dark): fill (38,38,38), border (42,42,42), title (242,242,242)
2 lines, secondary (164,164,164), dot 10×10 (57,196,135).

**#2 — 仍差 #7 / #8 (silent per-cell caps)** need a ruling before anyone "fixes" them: schedule view `slice(0,2)`,
month view 1-chip cap vs the ref's 3.

**#3 (deferred) — E03 clause 3 ruling**: reword the clause, or build duration-proportional top-aligned blocks.
