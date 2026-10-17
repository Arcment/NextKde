# R299 — R-DIM mid-anim attempt FAILED: 编辑 dialog stopped opening entirely (clicks delivered, no dialog). Checkpoint: relaunch needed. Next: R-DIM mid-frame via FRESH instance.

## 本轮 (R299)
Atomic step: **R-DIM mid-enter confirmation (state.md Next #1).** NOT achieved — blocked by environment, not by code.
- Light instance was alive (day view 2026-04-02, popover open per R298 relay). r299-pre.png confirmed popover open, 编辑 pill at x665–705 / y389–411, center ≈(685,400).
- **The 编辑日程 dialog stopped opening.** Every attempt delivered the pointer event (live-runtime-vm.log: `pointer click 670 396` etc.) but scrim stayed 255 and the popover persisted. Tried, in order: press/release gap 0.03 (capture too early — frame shows button still pressed, pre-dialog); press/release gap 0.06; single `click`; outside-click (950,120) reset; × close (695,289) + re-openItem; corrected openItem schema + R298's exact (670,388). All no dialog. R298 opened it with the identical recipe on this same build ⇒ instance stuck-state suspected (R298's nativeRecord session did dialog-close + popover-reopen interleaving), possibly an invisible revealProgress=0 dialog eating clicks (new R-DIM code makes scrim alpha 0 ⇒ invisible but Overlay may still grab input).
- **New load-bearing finding: `openItem` schema is FLAT** — `{"action":"openItem","kind":"event","titleContains":"Morning"}` (harness/Main.qml:225-235). Nested `{"item":{…}}` silently no-ops. R298's shorthand was misleading.
- Timing note for the recipe: harness polls 100ms; with gap 0.03 the capture can land BEFORE the click is processed (r299-enter.png = pre-click frame, button mid-press). Capture must be written ≥1 poll after the click ⇒ gap ≈0.08–0.12 between click and capture write.
- Bash budget exhausted (23) before relaunch — no fresh-instance attempt this round.

## 仍差 (top 8, visual-impact order)
1. **R-DIM mid-anim confirmation — BLOCKED R299 by dead dialog. NEXT: relaunch light (`start-review-vm.sh light` in bg, seed AFTER pid), re-drive `date 2026-04-02` → `view day` → flat-schema openItem → click 编辑 (670,388) → capture in SAME fast-command call, gap 0.08–0.12 ⇒ capture ~1 poll after click = mid-220ms-enter; scrim must read strictly 204<val<255 at (950,120). Then 取消 (550,596) mid-exit (120ms; accept either side). If fresh instance ALSO refuses to open the dialog ⇒ suspect the R-DIM change itself (invisible no-alpha Overlay grabbing input) — read KosWorkspaceDialog.qml open/close logic and check `enabled`/`visible` of the Overlay during revealProgress=0.**
2. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view from mini-month. No dead segments. Big — several rounds.**
3. R-TOOLTIP-Y: measure ref tooltip y, match, record measurement in LEDGER (self-resolved, no ruling needed).
4. R-H dark-theme spot-check (fold into next regression leg).
5. R-OVERFLOW dark spot-check (fold into next regression leg).
6. *(reserved)*
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R299 — **no code change; mid-anim attempt blocked (dialog won't open); openItem flat-schema finding.**
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic, reduceMotion instant). Static verified; mid-frame pending.**
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`; silent slice(0,2) cap removed. PASS light.**
0. R296 — **R-H ring icon on all-day band chips (12×12/stroke 3/hole 6/inset 3, chipInk; text margin 19). PASS light.**
0. R295 — plain hold. 0. R294 — plain hold. 0. R293 — plain hold. 0. R292 — plain hold.
*(older: R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **R299 BLOCKER (load-bearing): current light instance will NOT open the 编辑日程 dialog — pointer clicks deliver but nothing opens. Do NOT trust this instance for dialog work; relaunch first. If a fresh instance still fails, suspect R-DIM's Overlay: at revealProgress=0 the scrim is invisible (alpha 0) but may still intercept input, making the dialog unopenable-looking after any close. Check KosWorkspaceDialog enabled/visible vs revealProgress.**
- **OPENITEM SCHEMA (R299, load-bearing): `{"action":"openItem","kind":"event","titleContains":"Morning"}` — keys FLAT on the command object (harness/Main.qml:225). Nested {"item":…} no-ops silently.**
- **CAPTURE TIMING (R299): harness polls 100ms ⇒ fast-command gap 0.03 capture can precede the click's effect. Put ≥0.08–0.12 between the click and the capture command.**
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (all-day ring icon — DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (same-hour ≤3 columns then +N — DONE R297), R-DIM (scrim follows KosDialog reveal 220ms OutCubic / 120ms InCubic, reduceMotion exempt, shadowAmbient/shadowKey — implemented R298, mid-frame confirm pending), R-TOOLTIP-Y (self-resolved: ref-measured y, record in ledger). 人工裁决事项清零.**
- **第一批裁决 (2026-10-17 22:55, load-bearing): R-CHIP chip height round(hourHeight*0.96)=38 (DONE R240/R241); T01 side-by-side halves (DONE R242); R-GUTTER 12h two-tone (DONE R243/R244); R-MONTH stack 3 + +N (DONE R245); R-SCALE ref-measured beats spec estimates (stripe ≈3).**
- **DIALOG DRIVE (R298, load-bearing): `openItem {kind:"event",titleContains:…}` (flat) opens the detail POPOVER, not the editor dialog; 编辑 at (670,388) opens 编辑日程; 取消 at (550,596); `escape` does NOT close it. nativeRecord captures contentItem only — Overlay.modal scrim INVISIBLE in its frames; scrim verification must use captureClient. `fast-command.py` = review-command.py without the 0.6s tail sleep; ONE command per invocation preferred, or fast-command.py with adequate gaps.**
- **DRIVE KEYS (load-bearing): `date` action key is `date`; `sidebar` key is `expanded` (bool); `view` key is `view`. Wrong key silently no-ops.**
- **Shared `AppTheme` has `text` (:153) / `mutedText` (:154) — NO labelPrimary/labelSecondary (Main.qml `tahoe`-only). QT6 delegates: declare `required property int index`. AppTheme motion tokens: motionNormal=220, motionFast=120, both 0 under reduceMotion (:179-180).**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` and drive via review-command.py/fast-command.py if clobbered. Capture = `captureClient` + ABSOLUTE path. `kill -0 $(cat live-app.pid)` FIRST; launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch (KOS_APPEARANCE). start-review-vm.sh never exits (exec+wait) — background it or it eats the 60s tool timeout; seed AFTER it prints pid.**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT` and re-add `BEGIN:VEVENT\nUID:…` yourself — replacing a `UID:` anchor line orphans the next event's BEGIN and the parser silently drops blocks. `replaceExisting=true` ALSO wipes todos — re-create the todo trio after any replace-import.**
- **MONTH-CELL HOVER ARTIFACT (R275):** full-cell light-blue fill + bare `+` top-right = hover highlight + quick-add. Move via `{"action":"pointer","kind":"move",…}`; `position` REJECTED in month view.
- **THIS RUN'S GRID GEOMETRY (collapsed sidebar, day view): week starts MONDAY. App starts `--view week --date 2026-10-15` sidebar COLLAPSED; fixtures live on 2026-04-02 — drive `date` there. Light instance STALE (dialog won't open) — relaunch before dialog work.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` is THE pitch constant (`:53`). Chip height 38, half-hour line 20. Ref timed chip 1:1: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter: digit+AM/PM two-tone same baseline, red 9:41 pill replaces 10 AM. Ref all-day band: rows pitch 19; chip radius ≈6 alpha ≈0.16.**
- **Fixtures (R297 state): each day 0329–0403 has Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO has Overflow one/two/three all starting 08:00. Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). An event's itemColor is env-derived — never pin chip colour literals.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` for structure, `LANCZOS` for smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with **`LEDGER.md` = byte copy of `state.md`**. `python3 -c` payload with backticks is mangled — use a heredoc. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-DIM mid-anim via FRESH instance: kill stale instance; `start-review-vm.sh light` in background, seed AFTER pid; re-drive `date 2026-04-02` → `view day` → flat openItem → click 编辑 (670,388) + captureClient in ONE fast-command call with click→capture gap 0.08–0.12 ⇒ mid-220ms-enter frame; scrim at (950,120) must read strictly between 204 and 255, card mid-fade. Then 取消 (550,596) mid-exit. Record alphas in LEDGER. If fresh instance also refuses ⇒ debug KosWorkspaceDialog Overlay input grab at revealProgress=0 (R-DIM change suspect) before retrying.**
**Then (later rounds): R-TOOLTIP-Y ref-measure → R-YEAR (multi-round) → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into the next regression leg.**
**Not `DONE`.**
