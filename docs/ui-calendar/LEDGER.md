# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P2-2 ✅（C6：非本月 opacity 0.42 → 0.5；视觉验证）
- **实改 2 处**（清单口径「≥0.5 或 labelSecondary」，取最小偏离 0.5）：
  - `CalendarMonthView.qml:102`（月视图整格）0.42→0.5
  - `Main.qml:2363`（迷你月整格，REVIEW 写 2350 系行号漂移）0.42→0.5
- 构建 ✓（ninja kos-calendar kos-pim-service）；light/dark 各启动 ✓、无 QML error。
- 视觉对照（月视图 2026-03）：月视图 + 迷你月的非本月日期（23–28 / 1–5）明显
  更淡但仍清晰可读、层次保持。浅 `_p2-2-month-light.png`（repo 根 shots/）、
  深 `_p2-2-month-dark.png`（tmp/ui-acceptance/calendar/shots/ —— captureClient
  落盘目录随实例 cwd 不同，两处都要找）。
- WCAG 复算（0.5 合成，改前→改后）：深色 3.63→**4.49:1**；浅色月格 2.58→**3.22:1**；
  迷你月浅色 2.57→**3.78:1**（#000@0.5 over #E4E4E4）。
- **与 4.5:1 的偏差**：浅色两处 0.5 仍未到 4.5:1（深色 ≈达标）。REVIEW 对 C6 的
  建议线即 ≥0.5（非本月视为次要信息），按清单执行；严格 4.5:1 需 opacity ≈0.62+
  或改 labelSecondary，留「仍差」供裁定。

## 上一轮 (2026-10-18) — P2-1 ✅（S1：8–9px 字号提至 ≥10，8 处实改）
议程徽标 Main.qml:2708 未实拍（下轮议程面板可达时顺带核对）。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P2-2（P0/P1 批次 + P2-1/P2-2 完成，见 git log）

## 仍差（top 8）
- P2-3 今天色 → AppTheme.todayRed（`CalendarMonthView.qml:117`）。
- P2-4 硬编码中性灰收敛进 AppTheme（`CalendarScheduleView.qml:135,143`、
  `EventDetailsPopover.qml:20-25`）。
- P2-5 headerTitle 周区间 locale 模板（`Main.qml:1524-1538`）。
- P2-6 隐藏 DialogButtonBox 偷文案改绑定/契约注释（两个编辑器）。
- P2-7 日期/时间占位符 locale 化。
- P2-8 pressDuration 纳入 reduceMotion 守卫（`Main.qml:248,675-677,802-803`）。
- P2-9 单点清理一批（见 TASK.md #29；窗口圆点顺序不动）。
- 可选：P2-2 浅色若裁定要 4.5:1 → opacity ≈0.62 或 labelSecondary；
  议程徽标 10px 实拍补证。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`（但切视图用
  `{"action":"view","view":"month|week|day"}` 更可靠）；review-command.py 接受
  单对象或数组，文件必须是带 `sequence` 的对象——整文件手写数组会卡死队列
  （reset 用 `printf '{"sequence":1,"action":"noop"}'`）；命令原地写，不原子替换；
  `date` 后留 2s；启动脚本重置 command.json → 重起后先 resize 1100x692；
  captureClient path 相对落盘随实例 cwd 变（repo 根或 tmp/…/calendar/），截完
  用 find 找。日视图 `wheel`/`position` 只滚时间格，议程面板未滚到。

## Next round
**P2-3**（C8：`CalendarMonthView.qml:117` 今天色 → `AppTheme.todayRed`；视觉类，
浅/深各拍月视图核对今天圆标颜色）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。旧实例还挂着时启动会 exit 1，先 kill。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
