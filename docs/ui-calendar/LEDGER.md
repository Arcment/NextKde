# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P2-8 ✅（M1：pressDuration 纳入 reduceMotion 守卫）
- 一行修：`Main.qml:261` `tahoe.pressDuration: 150` →
  `AppTheme.reduceMotion ? 0 : 150`。三处使用（`:692/:694/:819` 的
  hoverAmount/pressAmount/hoverLift Behavior）全走该属性，定义处守卫即全覆盖，
  与 `AppTheme.qml:239-242` motion token 的 `reduceMotion ? 0 : X` 模式同规。
- **非视觉改动**：reduceMotion 默认 false → pressDuration 仍 150，默认观感零变化
  （无对照图）。reduceMotion=true 时按下/悬停插值动画归零（即时状态切换）。
- 冒烟：light 模式启动，进程存活，runtime log 0 error 0 warning。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P2-8（P0/P1 批次 + P2-1…P2-8 完成，见 git log）

## 仍差（top 8）
- P2-9 单点清理一批（见 TASK.md #29；窗口圆点顺序不动）。
- 可选：P2-2 浅色若裁定要 4.5:1 → opacity ≈0.62 或 labelSecondary；
  P2-3 today 圆标文字是否改 #FFFFFF（参考为白、现 accentText=黑，5.37:1）；
  议程徽标 10px 实拍补证；新任务编辑器空字段占位符实拍。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`（但切视图用
  `{"action":"view","view":"month|week|day"}` 更可靠）；`date` 动作
  `{"sequence":N,"action":"date","date":"2026-03-31"}` 可跳周；
  review-command.py 接受单对象或数组（数组一次入队即可），文件必须带
  `sequence`；命令原地写，不原子替换，否则触发 QML 重载；`date` 后留 2s；
  启动脚本重置 command.json → 重起后先 resize 1100x692；captureClient path
  相对落盘随实例 cwd 变，截完用 find 找。**`openItem` 只开详情浮层**，
  编辑器要再 `pointerObject detailsEdit` press+release。

## Next round
**P2-9**（单点清理：`Ctrl+4` 快捷键、`--view year`、迷你月 todayDisc 白字、
议程勾选钮 28px、`CalendarMonthView.qml:51,97` 魔数、`CalendarScheduleView.qml:982`
死守卫、`Main.qml:2515` 过期注释、`listColor` 恒等 `darker`；**窗口圆点顺序不动**）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。旧实例还挂着时启动会 exit 1，先 kill。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
