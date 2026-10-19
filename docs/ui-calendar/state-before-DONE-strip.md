DONE

# R309 — 最终回归 leg 全过 (light year/month/week/day + dark month/week). 全部 spec ID 通过 → **DONE**.

## 本轮 (R309)
Atomic step: **最终回归 leg + 顺带 dark spot-checks, 无代码改动. 全过 → DONE.**
- Light: 重启 light → resize 1280×800 → date 2026-04-02 → pointer 进 year → r309a.png; view 切 month/week/day → r309b/c/d.png. R-YEAR (disc/dots/today/无泄漏) + R-DIM/R-H/R-OVERFLOW/R-TOOLTIP 已改点全部复查通过.
- Dark 顺带 (第 2 次启动回路): r309e-dark-month (R-DIM ✓) + r309f-dark-week (R-H ✓ / R-OVERFLOW ✓).
- 判同帧必须 md5 (r309a/b/d 文件大小相同但 md5 各异 — 大 PNG 同尺寸巧合).
- Bash ~13/25.

## 仍差
*(无 — 全部 spec ID 闭环, 最终回归完成.)*

## 最近已改 (most recent 8)
0. R309 — no code; **最终回归 leg 全过 → DONE** (light y/m/w/d + dark m/w).
0. R308 — no code; R-YEAR dark spot-check PASS.
0. R307 — R-YEAR disc 泄漏 PASS: yearDayCell.isSelected 加 inMonth 守卫.
0. R306 — R-YEAR dots PASS: updateEventRange 补 year 分支 (Main.qml:1473).
0. R305 — no code; R-YEAR dots 根因诊断.
0. R304 — R-YEAR step 2: day-cell 选中双态 + MouseArea + event dots + ‹› year 导航.
0. R302 — R-YEAR step 1: 4th Year segment + yearPage 3×4 skeleton; viewIndex 3=year.
0. R301 — no code; R-TOOLTIP-Y closed.
*(older: R300/R298/R297/R296/… archived in rounds.md tail)*

## 外推待确认 (live only)
- **DRIVE ACTIONS (R308, load-bearing): 只有 `pointer` (kind press/release/move) / `resize` / `date` / `view` / `sidebar` / `captureClient` 等; `action:"press"` 不存在, 静默 no-op. 选中 segment 用 `{"action":"pointer","kind":"press","x":724,"y":50}` + release.**
- **CAPTURE PATH (R307, load-bearing): captureClient path 相对 app cwd (=/home/amao/nextkde); 写 `tmp/ui-acceptance/calendar/xxx.png` 才落对地方. 判同帧用 md5, 文件大小会巧合相同 (R309).**
- **PGREP TRAP (R306): 找 app 用 `pgrep -x kos-calendar`; `pgrep -f` 会匹配 loop 监督进程自身.**
- **RELAUNCH WINDOW SIZE (R306): 启动后 1100×692; 依赖 collapsed 坐标的驱动先发 `{"action":"resize","width":1280,"height":800}`.**
- **STALE INSTANCE (R304): 重启后核对 live-runtime-vm.log 无旧 capture 行; 旧实例静默顶替新启动=旧代码行为.**
- **YEAR SEGMENT MAPPING (R302): viewIndex 0=month/1=week/2=day/3=year; Harness `view` action 不含 year — 进 year 用 pointer press→release Year slot (1280×800 collapsed: ≈556/612/668/724, y≈50).**
- **YEAR NAV (R304): `pointer target:"dateNavPrevious"/"dateNavNext"` 可用, press→release 各一条.**
- **REVIEW-COMMAND ARGV (R301): 整批命令一个 JSON 数组传 argv[1]; capture 动作名 = `captureClient`.**
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

## Next round
*(无 — DONE. 如外层循环继续派活: 仅剩可选收尾 — R-YEAR step 3 dot 样式微调建议接受现状; mirror LEDGER.md 同步.)*
