# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P2-4 ✅（C7：硬编码中性灰收敛进 AppTheme）
- **AppTheme.qml 新增 M05 组**（紧跟 todayRed）：`neutralPlane`（#1E1E1E/#FFFFFF）、
  `popoverSurface`（#262626/#F5F5F5）、`popoverBorder`（rgba 0.12 白/黑）、
  `popoverInk`（#F2F2F2/#1A1A1A）、`popoverInkSecondary`（rgba 0.58/0.55）。
- **消费点 4 处**：`CalendarScheduleView.qml` scheduleField→`AppTheme.neutralPlane`、
  allDayBackdrop 的 "#FFFFFF" mix→`AppTheme.whiteSeed`；`EventDetailsPopover.qml`
  四个局部 token 全部改读 M05（属性名不变，下游零改动）；
  `Main.qml:59` tahoe.contentPlane→`AppTheme.neutralPlane`（同一字面量对，
  scheduleField 注释明确要求与其相等，一并收敛否则会漂移——超出 finding
  文件清单的 1 行，见「与 finding 的偏差」）。
- 构建 ✓；light/dark 双冒烟 ✓、runtime log 0 error；dark 周视图截图
  `_p24-dark.png`：内容面仍为中性炭底、周末列淡分层、无 slate 色偏（同值收敛，
  无视觉变化；light 亦起过并截图 `_p24-light.png`）。
- **与 finding 的偏差**：finding 文件清单只有 ScheduleView/Popover 两个文件，
  但 R7 原文判「色值散落多文件，改主题时必漏」，故把 Main.qml:59 的同字面量
  一并收敛到 token（值不变，纯读侧替换）。Main.qml:43 注释「值是 Sketch 导出
  原值、不走 theme roles」仍然成立——neutralPlane 是中性 token，不是 theme role。

## 上一轮 (2026-10-18) — P2-3 ✅（C8：月视图今天圆标 accent → AppTheme.todayRed）
- **实改 1 处**：`CalendarMonthView.qml:117` 今天圆标 `AppTheme.accent` →
  `AppTheme.todayRed`（#E5484D），与周头/now-pill/迷你月统一为同一 M04 字面量。
- 构建 ✓；light/dark 各启动 ✓、无 QML error。
- 视觉对照（月视图 2026-10，今天=18）：浅/深圆标均实测 RGB(229,68,60)≈#E5484D，
  与迷你月同色（`_p2-3-month-light.png` / `_p2-3-month-dark.png`，repo 根 + 裁块）。
- WCAG：圆标文字仍为 P1-15 的 accentText（当前 accent 下=黑），
  黑 on #E5484D = **5.37:1**（白 = 3.91:1），均 ≥3:1。
- **与参考的偏差**：参考图 today 圆标文字为白，本实现解析为黑 —— 对比度达标，
  是否随 C8 一并改 #FFFFFF 留人工裁定。

## 上一轮 (2026-10-18) — P2-2 ✅（C6：非本月 opacity 0.42→0.5，浅色两处未到 4.5:1，留裁定）
议程徽标 Main.qml:2708 10px 未实拍（议程面板滚动未及），待顺带核对。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P2-4（P0/P1 批次 + P2-1/P2-2/P2-3/P2-4 完成，见 git log）

## 仍差（top 8）
- P2-5 headerTitle 周区间 locale 模板（`Main.qml:1524-1538`）。
- P2-6 隐藏 DialogButtonBox 偷文案改绑定/契约注释（两个编辑器）。
- P2-7 日期/时间占位符 locale 化。
- P2-8 pressDuration 纳入 reduceMotion 守卫（`Main.qml:248,675-677,802-803`）。
- P2-9 单点清理一批（见 TASK.md #29；窗口圆点顺序不动）。
- 可选：P2-2 浅色若裁定要 4.5:1 → opacity ≈0.62 或 labelSecondary；
  P2-3 today 圆标文字是否改 #FFFFFF（参考为白、现 accentText=黑，5.37:1）；
  议程徽标 10px 实拍补证。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`（但切视图用
  `{"action":"view","view":"month|week|day"}` 更可靠）；review-command.py 接受
  单对象或数组，文件必须是带 `sequence` 的对象——整文件手写数组会卡死队列
  （reset 用 `printf '{"sequence":1,"action":"noop"}'`）；命令原地写，不原子替换；
  `date` 后留 2s；启动脚本重置 command.json → 重起后先 resize 1100x692；
  captureClient path 相对落盘随实例 cwd 变（repo 根或 tmp/…/calendar/），截完
  用 find 找。日视图 `wheel`/`position` 只滚时间格，议程面板未滚到。

## Next round
**P2-5**（I5：`Main.qml:1524-1538` headerTitle 周区间走 locale 模板；
非视觉/低视觉风险，启动冒烟即可）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。旧实例还挂着时启动会 exit 1，先 kill。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
