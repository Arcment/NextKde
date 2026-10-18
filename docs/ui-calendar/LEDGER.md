# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P2-9 ✅（单点清理一批，8 项）
- `Ctrl+4` 快捷键补上（viewIndex=3，Year）；`--view` 数组补 `"year"`（Main.qml handleActivation）。
  菜单/tooltip：现有 UI 无任何地方列出 Ctrl+1..3（segment 无 tooltip、菜单无视图项），
  故无可更新处，只在 Shortcut 处加注释。
- 迷你月圆盘对比度（视觉改动，已截图验证）：白字 11px DemiBold on todayRed #E5484D = 3.91:1、
  on selectionDisc #8E8E93 = 3.26:1（python3 WCAG 复算）。取满足 4.5:1 的**最小偏离**：
  `Qt.darker(todayRed, 1.09)` → #D24247 = 4.56:1；`Qt.darker(selectionDisc, 1.20)` → #76767A =
  4.52:1。共享 token 不动（today 标记/年视图依赖）。**与参考的偏差**：迷你月今日/选中圆盘
  比参考略深（浅色腿肉眼几乎不可辨），实拍确认两盘白字清晰。
- 议程勾选钮 24→28（macOS 默认命中区），内部 17px 圆不变。
- `CalendarMonthView.qml` 魔数提常量：monthGrid 上新增 `headerHeight:30 / dayDiscSize:24 /
  chipHeight:18`，dayHeight 公式、表头三处 30、visibleItemCount 的 26/20（=disc+2 / chip+2）、
  日期圆片 24、chip 高 18 全部改引常量。
- `CalendarScheduleView.qml` 死守卫：`timedChip.height >= 34`（height 恒 38）→
  `>= root.hourHeight - 8`（=32，当前行为不变，意图对将来尺寸变化成立）。
- `Main.qml` 过期注释："Retaining all three" → "all four"（pages 实为 4）。
- `listColor`：删恒等 `Qt.darker(color, 1.0)`；未知 id 回落由 accent 改为按 id 哈希的
  6 色稳定色板（REVIEW 建议原文）。**窗口圆点顺序未动**（人工判定项）。
- 构建 ✅；light 启动 ✅，runtime log 0 error 0 warning；month 视图截图验证圆盘。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P2-9（**P0/P1/P2 全部完成，见 git log**）

## 仍差（可选打磨，均为非必做项）
- P2-2 浅色若裁定要 4.5:1 → opacity ≈0.62 或 labelSecondary；
- P2-3 today 圆标文字是否改 #FFFFFF（参考为白、现 accentText=黑，5.37:1）；
- 议程徽标 10px 实拍补证；新任务编辑器空字段占位符实拍；
- 窗口圆点顺序（REVIEW 明示需人工判定，勿自动改）。

## Next round
队列已空。若裁定上面可选项需要做则逐条开新轮；否则在 state.md 写 `DONE`。

DONE

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。旧实例还挂着时启动会 exit 1，先 kill。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`（但切视图用
  `{"action":"view","view":"month|week|day"}` 更可靠）；`date` 动作
  `{"sequence":N,"action":"date","date":"2026-03-31"}` 可跳周；
  review-command.py 接受单对象或数组（数组一次入队即可），文件必须带
  `sequence`；命令原地写，不原子替换，否则触发 QML 重载；`date` 后留 2s；
  启动脚本重置 command.json → 重起后先 resize 1100x692；captureClient path
  相对落盘随实例 cwd 变，截完用 find 找（本轮落在 repo 根 p2-9-light.png）。
  **`openItem` 只开详情浮层**，编辑器要再 `pointerObject detailsEdit` press+release。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
