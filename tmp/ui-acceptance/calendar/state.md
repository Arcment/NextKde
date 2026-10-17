# R304 — R-YEAR step 2: ①③ PASS (day-click select 双态 / ‹ 导航), ② event dots 未渲染. Next: 查 dots.

## 本轮 (R304)
Atomic step: **R-YEAR step 2 — day-cell 选中双态 + event dots + year 导航 (state.md Next #1).**
- **Code (`apps/calendar/qml/Main.qml` yearPage ~2749-2866, via code-writer):** yearDayCell 增 `isSelected`(`root.sameDay`) + `eventCount`(`root.itemsForDate`); disc 三态 `isToday ? AppTheme.todayRed(#E5484D) : (isSelected ? selectionDisc : transparent)`; label 白字/DemiBold 同步; 3×3 accent dot (anchors.bottom, **外推**, 无参考); 末位 MouseArea (inMonth-gated, onClicked=selectedDate, 不路由). month-cell ItemDelegate onClicked(→month view) 未动.
- **⚠️ STALE-INSTANCE 陷阱 (load-bearing):** 本轮第一次截图全部作废 — `start-review-vm.sh` 启动时旧实例仍在跑, live-runtime-vm.log 里还留着 R302 的 capture 行; 旧二进制表现出「today disc 灰 / 点 day 跳 month view」全与旧代码一致. **规则: rebuild 后重启, 必须先 `grep -a capture live-runtime-vm.log` 确认无旧轮记录再驱动.** kill 旧 pid (live-app.pid / `pgrep -f watch-qml`) 后重启即好.
- **Live verify (light 1280×800 collapsed, fresh instance):**
  - ① 点 (219,710)=十月15 → **留在 year view**; p15 disc=(142,142,147)=selectionDisc, p18=(229,72,77)=todayRed #E5484D. today 红优先、selected 灰次之, 双态 ✓ (`r304c-year.png`/`r304d-select15.png`).
  - ③ `pointer target:"dateNavPrevious"` press→release (1163,94) → 标题 **2025**, 12 个月网格换 2025 布局 (1/1=周四), 灰 disc 随 shiftView year 分支落到 2025-10-15. **shiftView year 分支 live 验证 ✓** (`r304e-prev.png`). › 同一对称分支未单独点 (对称).
  - ② **event dots 未渲染**: 四月 1/2/3 (fixtures 0329–0403 应有事件) 无任何 dot 像素 (NEAREST 放大确认; 前次"蓝像素"是数字子像素彩边, 误报).
- **Loop budget: 2/2** (loop1 全耗在 stale instance 排查; loop2 fresh 验证). Bash 25/25, 到顶收工.

## 仍差 (top 8, visual-impact order)
1. **R-YEAR step 2 收尾 — event dots 不渲染, 先查数据再查绑定:** 先 `date`→2026-04-02 + view month 确认 fresh VM 里 pim 确有 4/1–4/3 fixtures (若 month view 也没 chip = VM 无数据/ICS 未播种, 与 dots 无关); 有数据则查 eventCount 绑定时机 (yearPage 懒实例化 vs pim.occurrences 到达顺序; `itemsForDate` 读 `itemsByDate` 属性, 理论上响应式, 但需 live 复查). 另: dot anchors.bottom 落在 18px cell 底缘, 与下行视觉间距需目测. ← NEXT #1
2. R-YEAR step 3 (可选): dot 样式/间距对齐 ref (ref 无 year 参考图 → 全部按 7.1 外推待确认).
3. R-YEAR dark spot-check (fold into regression leg).
4. R-DIM mid-EXIT frame — 120ms InCubic vs 100ms poll. LOW value: consider accepting, mark R-DIM PASS.
5. R-H dark spot-check (fold into regression leg).
6. R-OVERFLOW dark spot-check (fold into regression leg).
7. R-DIM dark spot-check (fold into regression leg).
8. *(reserved)*

## 最近已改 (most recent 8)
0. R304 — **R-YEAR step 2: day-cell 选中 (todayRed/selectionDisc 双态) + MouseArea 留 year view + event dots (未渲染, 见仍差#1) + ‹› year 导航验证.**
0. R302 — **R-YEAR step 1: 4th Year segment (segmentWidth 228, pitch 56) + yearPage 3×4 skeleton; viewIndex 3=year.**
0. R301 — no code; R-TOOLTIP-Y closed. driver: argv[1]-only gotcha.
0. R300 — no code; R-DIM mid-enter CONFIRMED. pointer "click"=no-op; fast-command gap ≥0.12.
0. R299 — no code; blocked; openItem flat-schema finding.
0. R298 — **R-DIM: scrim alpha × revealProgress (220 OutCubic / 120 InCubic).**
0. R297 — **R-OVERFLOW: timed same-hour max 3 cols + `+N`. PASS light.**
0. R296 — **R-H ring icon on all-day band chips. PASS light.**
*(older: R295/R294/R293/R292/R291/R290/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **STALE INSTANCE (R304, load-bearing): 重启后必须核对 live-runtime-vm.log 无旧 capture 行; 旧实例会静默顶替新启动, 表现=旧代码行为.**
- **YEAR SEGMENT MAPPING (R302, load-bearing): viewIndex 0=month/1=week/2=day/3=year; segment i→`2-i` (i≤2) else 3. Harness `view` action 只映射 month/week/day — 进 year 须 pointer press→release Year slot (light 1280×800 collapsed: slot centres ≈556/612/668/724, y≈50).**
- **YEAR NAV (R304): `pointer target:"dateNavPrevious"/"dateNavNext"` 可用, 无需坐标; press→release 各一条.**
- **REVIEW-COMMAND ARGV (R301): 整批命令作为一个 JSON 数组传 argv[1]; review-command.py 每条 sleep 0.6 已满足 ≥0.12 gap.**
- **POINTER KINDS (R300): 只有 press/release/move; "click"=静默 no-op.**
- **DIALOG COORDS (R300, 1280×800 collapsed): popover 编辑 pill (763,491); 取消 (647,650); escape 不关 dialog.**
- **DRIVE KEYS: `date` key `date`; `sidebar` key `expanded`; `view` key `view`. QT6 delegates: `required property int index`. motionNormal=220, motionFast=120.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` if clobbered. Launcher resets command.json ⇒ relaunch 后重发 resize/sidebar/view/date. Theme fixed at launch. start-review-vm.sh never exits — background it, seed AFTER pid. Restart after rebuild: kill `kos-calendar --watch-qml` pid (pkill -f kos-calendar 会误杀 claude loop 自身).**
- **ICS EDITING GOTCHA (R297): 新 VEVENT 插在完整 `END:VEVENT` 之后; `replaceExisting=true` 会清 todos.**
- **THIS RUN'S GRID (collapsed, day view): week MONDAY. App starts `--view week --date 2026-10-15` collapsed; fixtures 2026-04-02 — drive `date` 过去.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine #EDEDED/white@0.13, minor #F4F4F4/0.06, allDaySep #D9D9D9/0.24, sectionRule #F2F2F2/0.04. Sidebar plane (228,228,228). AppTheme.todayRed=#E5484D (`shared/qml/foundation/AppTheme.qml:87`).**
- **`hourHeight` THE pitch (`:53`). Chip 38, half-hour 20. Ref timed chip: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2. Ref gutter two-tone. Ref all-day: pitch 19; radius ≈6 alpha ≈0.16.**
- **Fixtures (R297): 0329–0403 Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO Overflow one/two/three @08:00. Todos: Review checklist 04-01 09:30, Prepare notes 04-01 14:30, long-task-title 04-02 11:00. itemColor env-derived.**
- **Crops: 1:1+zoom ONE read; NEAREST 结构/LANCZOS 平滑. 子像素彩边会伪造"蓝色像素" — 判色前 NEAREST 放大. tmp/ gitignored; mirror `docs/ui-calendar/` `LEDGER.md`=byte copy of state.md. Heredoc for python3. 静态截图不能判动效.**

## Next round (pick ONLY #1)
**#1 — R-YEAR step 2 收尾: event dots 不渲染的根因. 顺序: ① `date`→2026-04-02 + `view`→month, 截图确认 fresh VM 有 4/1–4/3 事件 chip (没有 = ICS 播种问题, 转查 pim-vm.log/fixture 路径); ② 有数据则回 year view 看 4/1–4/3 是否出 dot; ③ 仍无 → 派 code-writer 查 eventCount 绑定 (`itemsForDate` 在 yearDayCell 上的依赖收集; yearPage 懒加载时机), 或把 dot 改绑 `root.itemsByDate[dateKey(...)]` 直读. 目测确认 dot 3px 在数字下方、不与下行相撞.**
**Then (later): R-YEAR dark spot-check → dark spot-checks of R-H + R-OVERFLOW + R-DIM folded into next regression leg. Optional: R-DIM mid-exit else mark PASS.**
**Not `DONE`.**
