# R301 — R-TOOLTIP-Y CLOSED (ref has NO tooltip; live re-measure = below +4, matches platform convention). No code change. Next: R-YEAR step 1.

## 本轮 (R301)
Atomic step: **R-TOOLTIP-Y ref-measure + live re-measure (state.md Next #1) — CLOSED self-resolved, no code change.**
- **Ref re-check: `.loop/refs/macos-calendar.png` has NO tooltip.** Full-image pass + 2× toolbar crop — no tooltip anywhere (consistent with R063/R135's "the ref has no tooltip"). ⇒ 裁决的「测出来是多少就改成多少」**无参考目标**；7.5 直译 fallback = macOS 平台惯例（tooltip 出现在所指向控件**下方**）。
- Driver gotcha (cost 3 bash calls): `review-command.py` reads **argv[1] only** — 6 个独立 argv 只执行第 1 条（log 停在 park seq22）。**必须把整批命令作为一个 JSON 数组传入。**
- **Live re-measure (light 1280×800, reused instance 2428209, hover `toolbarAdd`, `r301-tooltip.png`):** button bottom rim y63; tooltip border top **y67** (53,54,55); fill top **y68** (242,242,242); ink band y79..87; bottom border y96; panel **y67..96 / fill y68..95 — BYTE-EQUAL to R135's record.** Gap = 3px 边框 / 4px 到填充 ⇒ **BELOW, +4**,与平台惯例一致，无可改目标。
- 记录已插入 `tmp/.../harness/LEDGER.md` (R-TOOLTIP-Y CLOSED 条目, R135 tooltip 行之后) + 证据图 `docs/ui-calendar/r301-tooltip-4x.png`。第二批裁决 R-TOOLTIP-Y 项至此闭环。

## 仍差 (top 8, visual-impact order)
1. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view from mini-month. No dead segments. Big — several rounds.** ← NEXT #1（第一步：分段控件加第 4 段 Year）
2. R-DIM mid-EXIT frame — 120ms InCubic vs 100ms poll + ~100ms capture latency. LOW value: enter confirmed + exit-completes verified; consider accepting and marking R-DIM PASS.
3. R-H dark-theme spot-check (fold into next regression leg).
4. R-OVERFLOW dark spot-check (fold into next regression leg).
5. R-DIM dark spot-check (fold into next regression leg).
6. *(reserved)*
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R301 — **no code change; R-TOOLTIP-Y closed (ref 无 tooltip; live below+4 byte-equal R135). driver: argv[1]-only gotcha.**
0. R300 — no code change; R-DIM mid-enter CONFIRMED (scrim 211 mid / 204 settled / 255 pre). pointer "click" is a no-op — press→release required; fast-command gap ≥0.12.
0. R299 — no code change; attempt blocked; openItem flat-schema finding.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic, reduceMotion instant).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`. PASS light.**
0. R296 — **R-H ring icon on all-day band chips. PASS light.**
0. R295 — plain hold. 0. R294 — plain hold.
*(older: R293/R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **REVIEW-COMMAND ARGV (R301, load-bearing): `review-command.py` parses ONLY `sys.argv[1]`. Pass the whole batch as ONE JSON array argument; separate argv objects are silently ignored.**
- **POINTER KINDS (R300, load-bearing): only `press` / `release` / `move` exist (ReviewInput.cpp:74-83). `"click"` = bare MouseMove, SILENT NO-OP. Any button activation = press cmd then release cmd at same coords.**
- **FAST-COMMAND GAP (R300, load-bearing): ≥0.12 strictly. Commands written <100ms apart get skipped (single command.json + 100ms poll).**
- **DIALOG COORDS (current 1280×800 collapsed layout, R300): popover 编辑 pill center (763,491); 编辑日程 取消 (647,650); popover opened via flat openItem. 取消 closes BOTH dialog and popover → plain day view. escape does NOT close dialog.**
- **R-DIM MEASURED (R300): scrim at (950,120) over white — pre 255, mid-enter 211, settled 204, after exit 255. Enter 220 OutCubic confirmed live; exit completes but 120ms mid-frame uncapturable with current poll+latency.**
- **R-TOOLTIP-Y MEASURED (R301, closing): ref has NO tooltip; ours = below the control, border top y67 / fill y68..95, +4 off button bottom, byte-equal R135. Item closed.**
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (DONE R297), R-DIM (implemented R298, mid-enter CONFIRMED R300), R-TOOLTIP-Y (CLOSED R301). 人工裁决事项清零.**
- **OPENITEM SCHEMA (R299, load-bearing): `{"action":"openItem","kind":"event","titleContains":"Morning"}` — FLAT keys (harness/Main.qml:225). Nested {"item":…} no-ops.**
- **DRIVE KEYS (load-bearing): `date` key `date`; `sidebar` key `expanded`; `view` key `view`. Shared `AppTheme` has `text`/`mutedText`, NO labelPrimary/Secondary. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120, 0 under reduceMotion.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Capture = `captureClient` + ABSOLUTE path. Launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid.**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT`; re-add `BEGIN:VEVENT\nUID:` yourself. `replaceExisting=true` wipes todos — re-create the trio.**
- **THIS RUN'S GRID GEOMETRY (collapsed sidebar, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures on 2026-04-02 — drive `date` there.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): days 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). itemColor env-derived — never pin chip colours.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` structure / `LANCZOS` smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with `LEDGER.md` = byte copy of `state.md`. Heredoc for `python3 -c` payloads. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-YEAR step 1: segmented control gains the 4th `Year` segment (spec.md R-YEAR: 控件加宽并重新居中、pill 落在当前视图上). Implement the segment; wire it to switch to a placeholder that is NOT dead — 即先让 Year 段显示现有 month 布局的 12 个月网格起点（或最小 year 视图骨架），下一步再填格。禁止死段。完成后 light 截图对照 ref toolbar capsule 度量 (ref slot 56.0, pill W 51-52.4, h 24, r 11.5, word centres 418/474/530/586 — 需按我们 toolbar 中心重排).**
**Then (later rounds): R-YEAR step 2 (12-month grid from mini-month 组件) → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into the next regression leg. Optional: R-DIM mid-exit, else mark R-DIM fully PASS.**
**Not `DONE`.**
