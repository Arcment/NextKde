# R306 — R-YEAR dots 修复 PASS. Next: R-YEAR 选中 disc 泄漏到月外占位格 (新 bug, Next #1).

## 本轮 (R306)
Atomic step: **R-YEAR dots 修复+验证一轮闭环 (state.md Next #1). Loop 1/2, PASS.**
- code-writer: Main.qml `updateEventRange()` week 分支后插 `else if (activeView === "year")` → first=1/1, last=12/31 (else=day 不动). 3 insertions only, 确认无其他改动. rebuild OK (7 targets).
- **重启陷阱**: `pgrep -f 'kos-calendar --watch-qml'` 会匹配**外层 loop 监督进程自身** (其 prompt 文本含该串) — 之前 kill 的 pid 其实是旧 claude 会话. 判定要用 **`pgrep -x kos-calendar`**. 启动后核对 live-runtime-vm.log captureClient=0 ✓ 无 stale.
- **截图陷阱**: relaunch 后窗口回落 1100×692, (724,50) 点击落空 (capture 到的是 week view). 先发 `{"action":"resize","width":1280,"height":800}` 再驱动即中.
- **验证 (r306b-year.png, 2026, selectedDate=4/2)**: 蓝点 (纯 accent (0,136,255), 核心 ~3-4px, NEAREST 纯色扫描) 出现在 **3/29、3/30、3/31、4/1、4/2 (disc 下)、4/3、4/4** = fixtures 事件日; 4/5 及其余所有月无假点 ✓. **2025 (dateNavPrevious) 全年无点** = 窗口随年份 ✓. dot 位于数字下方、不压下一行 ✓. → **R-YEAR step 2 全部闭环**.
- **新发现 bug (留 Next #1)**: year view 选中 disc 泄漏到**月外占位格** — 三月尾行 26 下方的空格 (隐式日期=4/2, 即 26+7) 画了灰色选中 disc (无数字). 2025 截图同样出现 (selectedDate 仍是 2026-04-02). 根因推测: yearPage 日期 cell 的 disc 判定只比 date==selectedDate, 未检查"该日属于显示月"; dot 无此问题 (占位格无 eventCount). 修法方向: 占位格 (day.getMonth() !== 显示月) 跳过 disc 渲染.
- Loop 1/2. Bash 21/25.

## 仍差 (top 8, visual-impact order)
1. **R-YEAR disc 泄漏占位格**: year view 三月 (及任何月) 尾行空格在 implicit date==selectedDate 时画灰 disc. 派 code-writer 在 yearPage day delegate 的 disc/selection 渲染处加 `day.getMonth() === 显示月` 守卫 → rebuild → 驱动 (resize 1280×800 → date 2026-04-02 → Year slot) → 确认 4/2 disc 只在四月, 三月尾行干净, dots 不回归. ← NEXT #1
2. R-YEAR step 3 (可选): dot 样式/间距对齐 (ref 无 year 参考图, 外推待确认).
3. R-YEAR dark spot-check (fold into regression leg).
4. R-DIM mid-EXIT frame — LOW value: consider accepting, mark R-DIM PASS.
5. R-H dark spot-check (fold into regression leg).
6. R-OVERFLOW dark spot-check (fold into regression leg).
7. R-DIM dark spot-check (fold into regression leg).
8. *(reserved)*

## 最近已改 (most recent 8)
0. R306 — **R-YEAR dots PASS: updateEventRange 补 year 分支 (全年 pim 窗口); 2026 dots 正确 + 2025 无点.**
0. R305 — no code; **R-YEAR dots 根因诊断: updateEventRange 缺 year 分支 (Main.qml:1473), pim range 塌缩为 selectedDate 单日.**
0. R304 — **R-YEAR step 2: day-cell 选中双态 + MouseArea 留 year view + event dots + ‹› year 导航验证.**
0. R302 — **R-YEAR step 1: 4th Year segment (segmentWidth 228, pitch 56) + yearPage 3×4 skeleton; viewIndex 3=year.**
0. R301 — no code; R-TOOLTIP-Y closed. driver: argv[1]-only gotcha.
0. R300 — no code; R-DIM mid-enter CONFIRMED. pointer "click"=no-op; fast-command gap ≥0.12.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 cols + `+N`. PASS light.**
*(older: R296/R294/R293/R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **PGREP TRAP (R306, load-bearing): `pgrep -f 'kos-calendar --watch-qml'` 会匹配 loop 监督进程自身 (prompt 含该串); 找 app 用 `pgrep -x kos-calendar`. kill 旧实例前先 `pgrep -x` 确认真的 app pid.**
- **RELAUNCH WINDOW SIZE (R306): start-review-vm.sh 启动后窗口 1100×692 (非 1280×800); 依赖 collapsed 坐标的驱动必须先发 `{"action":"resize","width":1280,"height":800}`.**
- **R-YEAR DISC LEAK (R306): year view 选中 disc 会画进月尾占位格 (implicit date=selectedDate); yearPage 日期 delegate 的 disc 判定缺 `getMonth()===显示月` 守卫.**
- **R-YEAR DOTS ROOT CAUSE (R305): year view 的 pim 窗口曾=selectedDate 单日; Multi-day 事件以"展开日"形式出现在 itemsByDate — 诊断 Multi-day 相关现象先想 addDayRange 展开. 已修 (R306).**
- **STALE INSTANCE (R304, load-bearing): 重启后必须核对 live-runtime-vm.log 无旧 capture 行; 旧实例会静默顶替新启动, 表现=旧代码行为.**
- **YEAR SEGMENT MAPPING (R302, load-bearing): viewIndex 0=month/1=week/2=day/3=year; segment i→`2-i` (i≤2) else 3. Harness `view` action 只映射 month/week/day — 进 year 须 pointer press→release Year slot (1280×800 collapsed: slot centres ≈556/612/668/724, y≈50).**
- **YEAR NAV (R304): `pointer target:"dateNavPrevious"/"dateNavNext"` 可用, 无需坐标; press→release 各一条.**
- **REVIEW-COMMAND ARGV (R301): 整批命令作为一个 JSON 数组传 argv[1]; review-command.py 每条 sleep 0.6 已满足 ≥0.12 gap. capture 动作名 = `captureClient` (R305).**
- **POINTER KINDS (R300): 只有 press/release/move; "click"=静默 no-op.**
- **DIALOG COORDS (R300, 1280×800 collapsed): popover 编辑 pill (763,491); 取消 (647,650); escape 不关 dialog.**
- **DRIVE KEYS: `date` key `date`; `sidebar` key `expanded`; `view` key `view`; `resize` keys `width/height`. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Launcher resets command.json ⇒ relaunch 后重发 resize/sidebar/view/date. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid. Restart after rebuild: kill `pgrep -x kos-calendar` 的 pid.**
- **ICS EDITING GOTCHA (R297): 新 VEVENT 插在完整 `END:VEVENT` 之后; `replaceExisting=true` 会清 todos.**
- **THIS RUN'S GRID (collapsed, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures 2026-03/04 — drive `date` 过去.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine #EDEDED/white@0.13, minor #F4F4F4/0.06, allDaySep #D9D9D9/0.24, sectionRule #F2F2F2/0.04. Sidebar plane (228,228,228). AppTheme.todayRed=#E5484D (`shared/qml/foundation/AppTheme.qml:87`).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Multi-day review VALUE=DATE 0330→DTEND 0403 (exclusive). Todos: Review checklist 04-01 09:30, Prepare notes 04-01 14:30, long-task-title 04-02 11:00. itemColor env-derived.**
- **Crops: 1:1+zoom ONE read; NEAREST 结构/LANCZOS 平滑. 子像素彩边会伪造"蓝色像素" — 判色前 NEAREST 放大 + 纯色扫描. tmp/ gitignored; mirror `docs/ui-calendar/` `LEDGER.md`=byte copy of state.md. Heredoc for python3. 静态截图不能判动效.**

## Next round (pick ONLY #1)
**#1 — R-YEAR disc 泄漏修复+验证: 派 code-writer 找 yearPage 日期 cell delegate 里选中 disc 的渲染判定 (grep `apps/calendar/qml` yearPage / selectedDate disc 相关), 给 disc 加 `date.getMonth() === 显示月` (或 delegate 标记 isCurrentMonth / inMonth) 守卫 — 占位格不画 disc. 注意不破坏: 4/2 正常 disc+白字、today disc (十月 18 红)、month view 的选中态. rebuild → `pgrep -x kos-calendar` kill 旧实例 → start-review-vm.sh light → 核 log 无旧 capture → 驱动 `[{"action":"resize","width":1280,"height":800},{"action":"date","date":"2026-04-02"},{"action":"pointer","target":"segmentButton3","x":724,"y":50,"kind":"press"},{"action":"pointer","target":"segmentButton3","x":724,"y":50,"kind":"release"},{"action":"captureClient","path":"r307a.png"}]` → 目测: 三月尾行干净无 disc, 四月 2 disc+白字, dots 不回归.**
**Then (later): R-YEAR step 3 optional → R-YEAR dark spot-check → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into next regression leg. Optional: R-DIM mid-exit else mark PASS.**
**Not `DONE`.**
