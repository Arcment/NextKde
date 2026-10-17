# R300 — R-DIM mid-enter CONFIRMED (fresh instance; scrim 211 mid vs 204 settled). Exit completes (255) but mid-exit frame missed (120ms < poll). Next: R-TOOLTIP-Y ref-measure.

## 本轮 (R300)
Atomic step: **R-DIM mid-anim via FRESH instance (state.md Next #1) — mid-ENTER achieved, mid-exit missed.**
- Relaunched light (`start-review-vm.sh light` bg, pid 2428209). Drove resize 1280×800 / sidebar collapsed / view day / date 2026-04-02 → flat openItem opened popover (fresh instance works fine — R299's instance was NOT the problem).
- **ROOT CAUSE of R298/R299 "dead dialog" found: `pointer` kind "click" is a NO-OP.** `ReviewInput.cpp:67-83` supports only press/release/move; any other kind (incl. "click") sends a bare MouseMove. The log line `pointer click undefined 763 491` = kind,target echo of a move. ALL dialog opens must use press→release.
- **Enter mid-frame: r300-mid2.png** — press(763,491)→0.12→release→0.12→capture. Dialog 编辑日程 opening, scrim(950,120)=**211** strictly between 255 (pre) and 204 (settled); background day view visibly dimmed through the reveal. **R-DIM mid-enter PASS.**
- Settled scrim at (950,120) = **204** over white (end frame r300-end2.png).
- **Exit: 取消 at (647,650)** — attempt 1 (gap 0.05) FAILED: press+release written <100ms apart ⇒ release SKIPPED (command.json holds one command, 100ms poll) — button got focus ring but never clicked. Attempt 2 (gap 0.12): dialog closed cleanly, scrim back to 255 (r300-exit2.png) — exit completes fully, but capture landed after the 120ms anim ⇒ **mid-exit pixel not caught.** Stopped at 2 attempts per discipline.
- **Second load-bearing finding: fast-command gap MUST be ≥0.12** (>100ms poll) or intermediate commands are silently skipped.

## 仍差 (top 8, visual-impact order)
1. **R-DIM mid-EXIT frame — 120ms InCubic too fast for 100ms poll + ~100ms capture latency. Needs either nativeRecord (but scrim layer invisible in native frames — known) or a way to shrink capture latency. LOW value: enter confirmed + exit-completes verified; consider accepting as-is and marking R-DIM PASS.**
2. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view from mini-month. No dead segments. Big — several rounds.**
3. R-TOOLTIP-Y: measure ref tooltip y, match, record measurement in LEDGER (self-resolved, no ruling needed). **← NEXT #1**
4. R-H dark-theme spot-check (fold into next regression leg).
5. R-OVERFLOW dark spot-check (fold into next regression leg).
6. R-DIM dark spot-check (fold into next regression leg).
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R300 — **no code change; R-DIM mid-enter CONFIRMED (scrim 211 mid / 204 settled / 255 pre). pointer "click" is a no-op — press→release required; fast-command gap ≥0.12.**
0. R299 — no code change; attempt blocked; openItem flat-schema finding.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic, reduceMotion instant).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`. PASS light.**
0. R296 — **R-H ring icon on all-day band chips. PASS light.**
0. R295 — plain hold. 0. R294 — plain hold. 0. R293 — plain hold.
*(older: R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **POINTER KINDS (R300, load-bearing): only `press` / `release` / `move` exist (ReviewInput.cpp:74-83). `"click"` = bare MouseMove, SILENT NO-OP. Any button activation = press cmd then release cmd at same coords.**
- **FAST-COMMAND GAP (R300, load-bearing): ≥0.12 strictly. Commands written <100ms apart get skipped (single command.json + 100ms poll). R299's gap-0.05-style recipes were doomed by this too.**
- **DIALOG COORDS (current 1280×800 collapsed layout, R300): popover 编辑 pill center (763,491); 编辑日程 取消 (647,650); popover opened via flat openItem. 取消 closes BOTH dialog and popover → plain day view. escape does NOT close dialog.**
- **R-DIM MEASURED (R300): scrim at (950,120) over white — pre 255, mid-enter 211, settled 204, after exit 255. Enter 220 OutCubic confirmed live; exit completes but 120ms mid-frame uncapturable with current poll+latency.**
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (DONE R297), R-DIM (implemented R298, mid-enter CONFIRMED R300), R-TOOLTIP-Y (self-resolved: ref-measure → ledger). 人工裁决事项清零.**
- **第一批裁决 (2026-10-17 22:55, load-bearing): R-CHIP 38 (DONE R240/R241); T01 halves (DONE R242); R-GUTTER two-tone (DONE R243/R244); R-MONTH stack 3 + +N (DONE R245); R-SCALE ref-measured beats spec.**
- **OPENITEM SCHEMA (R299, load-bearing): `{"action":"openItem","kind":"event","titleContains":"Morning"}` — FLAT keys (harness/Main.qml:225). Nested {"item":…} no-ops.**
- **DRIVE KEYS (load-bearing): `date` key `date`; `sidebar` key `expanded`; `view` key `view`. Wrong key silently no-ops. Shared `AppTheme` has `text`/`mutedText`, NO labelPrimary/Secondary. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120, 0 under reduceMotion.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Capture = `captureClient` + ABSOLUTE path. Launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid.**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT`; re-add `BEGIN:VEVENT\nUID:` yourself. `replaceExisting=true` wipes todos — re-create the trio.**
- **THIS RUN'S GRID GEOMETRY (collapsed sidebar, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures on 2026-04-02 — drive `date` there.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): days 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). itemColor env-derived — never pin chip colours.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` structure / `LANCZOS` smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with `LEDGER.md` = byte copy of `state.md`. Heredoc for `python3 -c` payloads. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-TOOLTIP-Y: measure the ref image's tooltip y-position (crop the relevant region of `.loop/refs/macos-calendar.png`, get pixel values), compare with our live tooltip placement (hover a timed chip via pointer `move`, capture), record the measurement in docs/ui-calendar/LEDGER.md per the self-resolved ruling. Adjust only if measurably off.**
**Then (later rounds): R-YEAR (multi-round, big) → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into the next regression leg. Optional: R-DIM mid-exit via reduced capture latency, else mark R-DIM fully PASS.**
**Not `DONE`.**
