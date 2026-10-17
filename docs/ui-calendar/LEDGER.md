# R302 — R-YEAR step 1 DONE: 4th Year segment (width 228 → slot pitch 56 = ref), non-dead year skeleton. Next: R-YEAR step 2.

## 本轮 (R302)
Atomic step: **R-YEAR step 1 — segmented control gains 4th `Year` segment wired to a minimal year view skeleton (state.md Next #1).**
- **Code (all `apps/calendar/qml/Main.qml`, via code-writer):** `segmentWidth` 196→224→**228** (final; 224 gave pitch 55 vs ref 56.0 — fixed in 2nd loop); comment 228x28; `activeView` adds "year" (viewIndex 3, mapping 0=month/1=week/2=day/3=year, segment mirror `i<=2 ? 2-i : 3`); `headerTitle` year branch → `String(visibleMonth.getFullYear())`; `shiftView` year branch (±1 year, visibleMonth → Jan 1, early return); `labels` + `qsTr("Year")`; KosPageCache `pages` + yearPage.
- **yearPage skeleton (~:2735-2848):** 3×4 GridLayout, 12 ItemDelegate month cells (MMMM label + 7×6 mini-grid of 42 day cells, offset via `localeFirstDayOfWeek`, today disc `selectionDisc` + white DemiBold, day font 9 / month label 12 DemiBold). `onClicked` → selectedDate=monthStart, visibleMonth=monthStart, **viewIndex=0** (routes to month view ⇒ segment+cells non-dead). No event dots / day-cell selection yet (step 2).
- **Live verify (light 1280×800, collapsed):** track 528..751 = 内容区 224 ⇒ **slot pitch 56 = ref 56.0**; capsule centre ≈639.5 = window centre (重新居中 ✓); pill W 52 / h 24 = ref 51–52.4 / 24; r ≈11.5 目测 ✓. Click (724,50) press→release → pill on Year, title "2026", 12-month grid renders, today (10-18) disc in 十月. `r302b-year.png` / `r302b-capsule-4x.png`.
- **Focus ring note:** after click the pill shows a 2px blue focus ring — Qt focus visualization, ref static image has no click state; not a defect (existing 3-segment behavior, unchanged).
- **Loop budget used: 2/2** (loop 1 = 224 build, pitch 55 found; loop 2 = 228, pitch 56 ✓). Stop per discipline.

## 仍差 (top 8, visual-impact order)
1. **R-YEAR step 2: year view = 12 个月网格 from mini-month 组件 — day-cell click selects, event dots per day, year nav (‹ › shift ±1 year 已有 shiftView 分支，未 live 验证).** ← NEXT #1
2. R-YEAR dark spot-check (fold into regression leg after step 2).
3. R-DIM mid-EXIT frame — 120ms InCubic vs 100ms poll + ~100ms capture latency. LOW value: consider accepting and marking R-DIM PASS.
4. R-H dark-theme spot-check (fold into next regression leg).
5. R-OVERFLOW dark spot-check (fold into next regression leg).
6. R-DIM dark spot-check (fold into next regression leg).
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R302 — **R-YEAR step 1: 4th Year segment (segmentWidth 228, pitch 56) + non-dead yearPage 3×4 skeleton; viewIndex 3=year.**
0. R301 — no code change; R-TOOLTIP-Y closed (ref 无 tooltip; live below+4 byte-equal R135). driver: argv[1]-only gotcha.
0. R300 — no code change; R-DIM mid-enter CONFIRMED (scrim 211 mid / 204 settled / 255 pre). pointer "click" is a no-op — press→release required; fast-command gap ≥0.12.
0. R299 — no code change; attempt blocked; openItem flat-schema finding.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic, reduceMotion instant).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`. PASS light.**
0. R296 — **R-H ring icon on all-day band chips. PASS light.**
0. R295 — plain hold. 0. R294 — plain hold.
*(older: R293/R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **YEAR SEGMENT MAPPING (R302, load-bearing): viewIndex 0=month/1=week/2=day/3=year; segment i→`2-i` (i≤2) else 3. Harness `view` action (`harness/Main.qml:217-219`) still maps ONLY month/week/day — driving to year requires pointer press→release on the Year slot (light 1280×800 collapsed: slot centres ≈556/612/668/724, y≈50).** Ctrl+4 not wired (deliberate, step-2 scope).
- **REVIEW-COMMAND ARGV (R301, load-bearing): `review-command.py` parses ONLY `sys.argv[1]`. Pass the whole batch as ONE JSON array argument; separate argv objects are silently ignored.**
- **POINTER KINDS (R300, load-bearing): only `press` / `release` / `move` exist (ReviewInput.cpp:74-83). `"click"` = bare MouseMove, SILENT NO-OP. Any button activation = press cmd then release cmd at same coords.**
- **FAST-COMMAND GAP (R300, load-bearing): ≥0.12 strictly. Commands written <100ms apart get skipped (single command.json + 100ms poll).**
- **DIALOG COORDS (current 1280×800 collapsed layout, R300): popover 编辑 pill center (763,491); 编辑日程 取消 (647,650); popover opened via flat openItem. 取消 closes BOTH dialog and popover → plain day view. escape does NOT close dialog.**
- **R-DIM MEASURED (R300): scrim at (950,120) over white — pre 255, mid-enter 211, settled 204, after exit 255. Enter 220 OutCubic confirmed live; exit completes but 120ms mid-frame uncapturable with current poll+latency.**
- **OPENITEM SCHEMA (R299, load-bearing): `{"action":"openItem","kind":"event","titleContains":"Morning"}` — FLAT keys (harness/Main.qml:225). Nested {"item":…} no-ops.**
- **DRIVE KEYS (load-bearing): `date` key `date`; `sidebar` key `expanded`; `view` key `view`. Shared `AppTheme` has `text`/`mutedText`, NO labelPrimary/Secondary. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120, 0 under reduceMotion.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Capture = `captureClient` + ABSOLUTE path. Launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid. Restart after rebuild: kill the `kos-calendar --watch-qml` pid (pkill -f kos-calendar REFUSES — matches the claude loop process itself).**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT`; re-add `BEGIN:VEVENT\nUID:` yourself. `replaceExisting=true` wipes todos — re-create the trio.**
- **THIS RUN'S GRID GEOMETRY (collapsed sidebar, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures on 2026-04-02 — drive `date` there.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): days 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). itemColor env-derived — never pin chip colours.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` structure / `LANCZOS` smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with `LEDGER.md` = byte copy of `state.md`. Heredoc for `python3 -c` payloads. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-YEAR step 2: 把 yearPage 骨架升级为 mini-month 级网格（spec R-YEAR：用现有 mini-month 组件拼 12 个月网格；无参考图部分按 7.1 标「外推待确认」）。最小闭环：① day-cell 点击 → selectedDate（并留在 year view，日期 disc 落在所选日，today 与 selected 双态区分）；② 月格内事件 dot（复用 mini-month 的点样式）；③ ‹/› 导航在 year 视图 ±1 年（live 验证 shiftView year 分支）。**
**Then (later rounds): R-YEAR dark spot-check → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into the next regression leg. Optional: R-DIM mid-exit, else mark R-DIM fully PASS.**
**Not `DONE`.**
