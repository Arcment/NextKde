# R298 — R-DIM scrim landed (alpha × revealProgress), static full-open verified; mid-anim frame NOT yet captured. Next: R-DIM mid-frame confirm.

## 本轮 (R298)
Atomic step: **R-DIM (第二批裁决).** code-writer edit to `shared/qml/foundation/KosWorkspaceDialog.qml:26` — scrim color now `AppTheme.withAlpha(AppTheme.blackSeed, (AppTheme.dark ? 0.42 : 0.2) * root.revealProgress)`. revealProgress is animated by KosDialog enter/exit (motionNormal 220ms OutCubic in / motionFast 120ms InCubic out; both 0ms under reduceMotion ⇒ instant, ruling's exemption satisfied by construction). Shadow part: verification-only — card shadow is the two-layer shadowAmbient/shadowKey KosSurface system (KosSurface.qml:30,46, elevation 0.5), no hardcoded pure black; left untouched. Build OK.
- Drive recipe that finally opened the editor dialog: `date 2026-04-02` → `view day` → `openItem {kind:"event", titleContains:"Morning"}` opens the **detail popover** (NOT the dialog) → pointer click 编辑 at **(670,388)** (NOT 667,437 — that misses 50px low) → 编辑日程 dialog. 取消 button at (550,596). `escape` does NOT close this dialog.
- Static verdict: settled-open frame scrim measured **(204,204,204)** on white bg = white × (1−0.2) ⇒ full-alpha scrim correct; light theme.
- **Animation NOT fully settled visually**: captureClient came ≥300ms after the click (0.35s gaps) — missed the 220ms window. **nativeRecord frames LACK the Overlay.modal scrim layer** (grabs contentItem only: card visible, scrim absent in fr-*.png) ⇒ cannot verify scrim via nativeRecord; and the recorder proves card exit anim (closed by fr-24) + popover re-open, but my 编辑 re-click missed so no enter-anim frames either.
- Next round plan: `fast-command.py 0.03` press/release(670,388) + captureClient in the SAME call (gap 0.03 ⇒ capture lands ~160ms after press = mid-220ms-enter); scrim alpha must read strictly between 255 and 204. Then same trick on 取消 (550,596) for mid-exit.

## 仍差 (top 8, visual-impact order)
1. **R-DIM mid-anim confirmation (enter ~160ms frame alpha 0<α<0.2 via captureClient tight timing; then mid-exit). Recipe in 本轮.** NEXT.
2. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view from mini-month. No dead segments. Big — several rounds.**
3. R-TOOLTIP-Y: measure ref tooltip y, match, record measurement in LEDGER (self-resolved, no ruling needed).
4. R-H dark-theme spot-check (fold into next regression leg).
5. R-OVERFLOW dark spot-check (fold into next regression leg).
6. *(reserved)*
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic, reduceMotion instant). Static verified; mid-frame pending.**
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`; silent slice(0,2) cap removed. PASS light.**
0. R296 — **R-H ring icon on all-day band chips (12×12/stroke 3/hole 6/inset 3, chipInk; text margin 19). PASS light.**
0. R295 — plain hold. 0. R294 — plain hold. 0. R293 — plain hold. 0. R292 — plain hold. 0. R291 — plain hold.
*(older: R290/R289/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (all-day ring icon — DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (same-hour ≤3 columns then +N — DONE R297), R-DIM (scrim follows KosDialog reveal 220ms OutCubic / 120ms InCubic, reduceMotion exempt, shadowAmbient/shadowKey — implemented R298, mid-frame confirm pending), R-TOOLTIP-Y (self-resolved: ref-measured y, record in ledger). 人工裁决事项清零.**
- **第一批裁决 (2026-10-17 22:55, load-bearing): R-CHIP chip height round(hourHeight*0.96)=38 (DONE R240/R241); T01 side-by-side halves (DONE R242); R-GUTTER 12h two-tone (DONE R243/R244); R-MONTH stack 3 + +N (DONE R245); R-SCALE ref-measured beats spec estimates (stripe ≈3).**
- **R-H proportional note: ref ring is 12 ref-px in an 18 ref-px row (2/3); ours 12 logical px in a 24 px row (1/2). Ruling's literal numbers win (7.5 直译优先); optical difference acknowledged in ledger. Icon appears on EVERY column of a continuing multi-day bar.**
- **DIALOG DRIVE (R298, load-bearing): `openItem {kind:"event",titleContains:…}` opens the detail POPOVER, not the editor dialog; 编辑 at (670,388) opens 编辑日程; 取消 at (550,596); `escape` does NOT close it. **nativeRecord captures contentItem only — Overlay.modal scrim is INVISIBLE in its frames**; scrim verification must use captureClient. `fast-command.py` (tmp/) = review-command.py without the 0.6s tail sleep; pass gap then commands, e.g. `python3 fast-command.py 0.03 '<c1>' '<c2>'`; harness polls every 100ms ⇒ press→capture at gap 0.03 lands ~160ms after press (mid-220ms-anim). review-command.py's per-list seq writes RACED this round (a date cmd was silently skipped) — prefer ONE command per invocation, or fast-command.py.**
- **MONTH-CELL HOVER ARTIFACT (R275, load-bearing):** full-cell light-blue fill + bare `+` top-right on a chipless month cell = hover highlight + quick-add. Move pointer via `{"action":"pointer","kind":"move","x":…,"y":…}`; `position` is REJECTED in month view.
- **DRIVE KEYS (load-bearing): `date` action key is `date`; `sidebar` key is `expanded` (bool); `view` key is `view`. Wrong key silently no-ops.**
- **Shared `AppTheme` has `text` (:153) / `mutedText` (:154) — NO labelPrimary/labelSecondary (Main.qml `tahoe`-only). QT6 delegates: declare `required property int index`. AppTheme motion tokens: motionNormal=220, motionFast=120, both 0 under reduceMotion (:179-180).**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` and drive via review-command.py/fast-command.py if clobbered. Capture = `captureClient` + ABSOLUTE path. `kill -0 $(cat live-app.pid)` FIRST; launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch (KOS_APPEARANCE). start-review-vm.sh never exits (exec+wait) — background it or it eats the 60 s tool timeout; seed AFTER it prints pid.**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT` and re-add `BEGIN:VEVENT\nUID:…` yourself — replacing a `UID:` anchor line orphans the next event's BEGIN and the parser silently drops blocks (imported count < file count is the tell). `replaceExisting=true` ALSO wipes todos — re-create the todo trio after any replace-import.**
- **THIS RUN'S GRID GEOMETRY (R298, collapsed sidebar, day view): week starts MONDAY. App starts `--view week --date 2026-10-15` sidebar COLLAPSED; fixtures live on 2026-04-02 — drive `date` there. Light instance currently ALIVE (pid in live-app.pid), sitting on day view 2026-04-02 with the detail popover open.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` is THE pitch constant (`:53`). Chip height 38, half-hour line 20. Ref timed chip 1:1: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter: digit+AM/PM two-tone same baseline, red 9:41 pill replaces 10 AM. Ref all-day band: rows pitch 19; chip radius ≈6 alpha ≈0.16.**
- **Fixtures (R297 state): each day 0329–0403 has Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO has Overflow one/two/three all starting 08:00. Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). An event's itemColor is env-derived — never pin chip colour literals.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` for structure, `LANCZOS` for smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with **`LEDGER.md` = byte copy of `state.md`**. `python3 -c` payload with backticks is mangled — use a heredoc. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-DIM mid-anim confirmation: relaunch not needed (light instance alive, day view 2026-04-02, popover open). In ONE fast-command call: press/release 编辑(670,388) + captureClient with gap 0.03 ⇒ ~160ms frame; scrim must read strictly between 255 and 204 at (950,120) AND card must be mid-fade. Then same for 取消(550,596) mid-exit (120ms — harder; accept catching either side). Record both alphas in LEDGER. If both land, R-DIM = PASS.**
**Then (later rounds): R-TOOLTIP-Y ref-measure → R-YEAR (multi-round) → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into the next regression leg.**
**Not `DONE`.**
