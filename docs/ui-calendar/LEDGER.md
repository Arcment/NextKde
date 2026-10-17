# R305 — R-YEAR dots 根因已锁定: updateEventRange 无 year 分支, pim range=selectedDate 单日. Next: 派 code-writer 补 year 分支 + rebuild 验证.

## 本轮 (R305)
Atomic step: **R-YEAR step 2 收尾 — event dots 不渲染根因 (state.md Next #1). 全程未改代码, 未 rebuild — 纯诊断轮.**
- 复用 R304 实例 (log 尾= r304e capture, 无 stale). 复盘要点: capture 动作名是 **`captureClient`** (`capture` 会落进 timeline 分支报 "No visible timeline").
- **①月视图验证数据在**: `date`→2026-04-02 + `view`→month → r305a-month-apr.png: 4/1–4/4 各有 "Morning planning" chip (+7/+8/+4/+4), 底栏 4/2 "9 项". fixtures 在 VM 里没问题.
- **②year view 实况 (r305b-year.png, 2026)**: 灰 disc 在 4/2 ✓; **蓝点 (0,136,255) 3×3 实点只出现在 3/30、3/31、4/1、4/2** — 即 Multi-day review (DTSTART;VALUE=DATE:20260330, DTEND:20260403 exclusive) 的覆盖日. 4/3、4/4 (各 5 个 timed 事件, ICS DTSTART 确认) 无点; 像素级扫描 (纯 accent 色 + NEAREST) 排除子像素误报 — R304 的"1/2/3 无点"部分误判: 4/1/2 其实有点 (当时 range=10-15, 点来自…见③, R304 判读时位置没错但结论对了一半).
- **③根因 (Main.qml:1473 `updateEventRange`)**: 分支只有 month/week/`else`(=selectedDate 单日). **year view 落 else → `pim.setEventRange(selectedDate, selectedDate)` 单日窗口**. 服务端只回该日 occurrences; buildItemsByDate 对 4/2 收到的 Multi-day review 做 addDayRange(0330→0402) 展开 → 恰好 = 观察到的 4 个点日; timed 事件日 (4/3/4) 不在窗口 → eventCount=0 → 无点. R304 (selectedDate=10-15) 全年无点同理. 触发器齐全 (onViewIndexChanged/onSelectedDateChanged 均调 updateEventRange), **唯一缺口就是 year 分支**.
- **修法 (留给下轮)**: Main.qml:1486 `} else {` 前插 `} else if (activeView === "year") { first = new Date(selectedDate.getFullYear(), 0, 1); last = new Date(selectedDate.getFullYear(), 11, 31)`. year view 下 selectedDate 年份即显示年份 (shiftView year 分支/点击同步), 不需额外依赖 visibleMonth.
- Loop 0/2 (未 rebuild). Bash 25/25 到顶收工.

## 仍差 (top 8, visual-impact order)
1. **R-YEAR dots 修复**: 派 code-writer 按↑修法改 Main.qml:1473-1487 → rebuild → **重启 (kill kos-calendar pid, pgrep -f 'kos-calendar --watch-qml' 拿 pid, 勿 pkill -f kos-calendar)** → 核对 log 无旧 capture → 驱动: date→2026-04-02, pointer Year slot (724,50) press+release, captureClient → 目测 4/1–4/4 都有点, 点色 (0,136,255) 3px, 位于数字下方不压下一行. ← NEXT #1
2. R-YEAR step 3 (可选): dot 样式/间距对齐 (ref 无 year 参考图, 外推待确认).
3. R-YEAR dark spot-check (fold into regression leg).
4. R-DIM mid-EXIT frame — LOW value: consider accepting, mark R-DIM PASS.
5. R-H dark spot-check (fold into regression leg).
6. R-OVERFLOW dark spot-check (fold into regression leg).
7. R-DIM dark spot-check (fold into regression leg).
8. *(reserved)*

## 最近已改 (most recent 8)
0. R305 — no code; **R-YEAR dots 根因诊断: updateEventRange 缺 year 分支 (Main.qml:1473), pim range 塌缩为 selectedDate 单日.**
0. R304 — **R-YEAR step 2: day-cell 选中双态 + MouseArea 留 year view + event dots + ‹› year 导航验证.**
0. R302 — **R-YEAR step 1: 4th Year segment (segmentWidth 228, pitch 56) + yearPage 3×4 skeleton; viewIndex 3=year.**
0. R301 — no code; R-TOOLTIP-Y closed. driver: argv[1]-only gotcha.
0. R300 — no code; R-DIM mid-enter CONFIRMED. pointer "click"=no-op; fast-command gap ≥0.12.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 cols + `+N`. PASS light.**
0. R296 — **R-H ring icon on all-day band chips. PASS light.**
*(older: R295/R294/R293/R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **R-YEAR DOTS ROOT CAUSE (R305, load-bearing): year view 的 pim 窗口=selectedDate 单日; Multi-day 事件以"展开日"形式出现在 itemsByDate — 诊断 Multi-day 相关现象时先想 addDayRange 展开.**
- **STALE INSTANCE (R304, load-bearing): 重启后必须核对 live-runtime-vm.log 无旧 capture 行; 旧实例会静默顶替新启动, 表现=旧代码行为.**
- **YEAR SEGMENT MAPPING (R302, load-bearing): viewIndex 0=month/1=week/2=day/3=year; segment i→`2-i` (i≤2) else 3. Harness `view` action 只映射 month/week/day — 进 year 须 pointer press→release Year slot (light 1280×800 collapsed: slot centres ≈556/612/668/724, y≈50).**
- **YEAR NAV (R304): `pointer target:"dateNavPrevious"/"dateNavNext"` 可用, 无需坐标; press→release 各一条.**
- **REVIEW-COMMAND ARGV (R301): 整批命令作为一个 JSON 数组传 argv[1]; review-command.py 每条 sleep 0.6 已满足 ≥0.12 gap. capture 动作名 = `captureClient` (R305).**
- **POINTER KINDS (R300): 只有 press/release/move; "click"=静默 no-op.**
- **DIALOG COORDS (R300, 1280×800 collapsed): popover 编辑 pill (763,491); 取消 (647,650); escape 不关 dialog.**
- **DRIVE KEYS: `date` key `date`; `sidebar` key `expanded`; `view` key `view`. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Launcher resets command.json ⇒ relaunch 后重发 resize/sidebar/view/date. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid. Restart after rebuild: kill `kos-calendar --watch-qml` pid (pkill -f kos-calendar 会误杀 claude loop 自身).**
- **ICS EDITING GOTCHA (R297): 新 VEVENT 插在完整 `END:VEVENT` 之后; `replaceExisting=true` 会清 todos.**
- **THIS RUN'S GRID (collapsed, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures 2026-03/04 — drive `date` 过去.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine #EDEDED/white@0.13, minor #F4F4F4/0.06, allDaySep #D9D9D9/0.24, sectionRule #F2F2F2/0.04. Sidebar plane (228,228,228). AppTheme.todayRed=#E5484D (`shared/qml/foundation/AppTheme.qml:87`).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Multi-day review VALUE=DATE 0330→DTEND 0403 (exclusive). Todos: Review checklist 04-01 09:30, Prepare notes 04-01 14:30, long-task-title 04-02 11:00. itemColor env-derived.**
- **Crops: 1:1+zoom ONE read; NEAREST 结构/LANCZOS 平滑. 子像素彩边会伪造"蓝色像素" — 判色前 NEAREST 放大 + 纯色扫描 (R305: 数字 fringe (64,138,213)≠纯 accent (0,136,255)). tmp/ gitignored; mirror `docs/ui-calendar/` `LEDGER.md`=byte copy of state.md. Heredoc for python3. 静态截图不能判动效.**

## Next round (pick ONLY #1)
**#1 — R-YEAR dots 修复+验证 (一轮闭环): 派 code-writer 在 `apps/calendar/qml/Main.qml` `updateEventRange()` (1473-1487) 的 `else if (activeView === "week")` 块后插入 year 分支: `first = new Date(selectedDate.getFullYear(), 0, 1)`, `last = new Date(selectedDate.getFullYear(), 11, 31)` (保持 else=day 不动). rebuild (`ninja -C .build/calendar-review kos-calendar kos-pim-service 2>&1 | tail -25`) → kill 旧实例 → start-review-vm.sh light → 核对 log 无旧 capture → 驱动 `[{"action":"date","date":"2026-04-02"},{"action":"pointer","target":"segmentButton3","x":724,"y":50,"kind":"press"},{"action":"pointer","target":"segmentButton3","x":724,"y":50,"kind":"release"},{"action":"captureClient","path":"r306a-year.png"}]` → 目测 4/1/2/3/4 全有点 (3px accent, 数字下方), 其余月无假点; 顺手确认 2025 (dateNavPrevious) 无点 = 窗口随年份.**
**Then (later): R-YEAR dark spot-check → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into next regression leg. Optional: R-DIM mid-exit else mark PASS.**
**Not `DONE`.**
