# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-15 ✅ 月视图 today 字色 accentText（C4）
`CalendarMonthView.qml:122` today 分支 `"white"` → `AppTheme.accentText`。
- C4：白 on accent 3.53-4.23:1；accentText 自动选黑白中对比高的一侧。
  accent `#3478f6`：vs black **5.16:1** ✓（vs white 4.07）。两腿同 token。
- 构建 ✓。light 启动 → resize 1100x692 → view month → captureClient
  `_p15-month.png`：今天格 "18" 黑字 on accent 蓝（像素采样 RGB(15,9,4)≈blackSeed）。
- dark 启动重拍 `_p15-month-dark.png`：同样黑字 on accent ✓（第 2 次回路用完）。
- 与参考偏差：参考（macOS）today 圆点为白字；按 REVIEW 建议改 accentText，
  取 4.5:1 达标侧（黑），属 finding 指定动作非自由发挥。
- 驱动词典补充：截图命令 action 是 **captureClient**（`"screenshot"` 不存在，
  静默无输出）；`stop-live.py` 未杀掉实例时用 `kill -TERM $(cat live-app.pid)`。

## 上一轮 (2026-10-18) — P1-14 ✅ nowPill DemiBold（C3）
`CalendarScheduleView.qml` nowPillLabel 加 `font.weight: Font.DemiBold`。
实拍对照 ref 胶囊笔画粗细一致。WCAG 说明：11px DemiBold 严格不算 large text，
按 REVIEW 建议执行（同日头 12px DemiBold 待遇），数值 3.91:1 未变。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 全天条 "+N" 差一
- [x] P1-1 时间 helper（locale 12/24h）+ formatClock12 + gutter
- [x] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
- [x] P1-3 任务编辑器 New/Edit 标题
- [x] P1-4 事件编辑器保存校验
- [x] P1-5 任务编辑器保存校验
- [x] P1-6 删除二次确认（代码+确认层实拍三分支 ✓）
- [x] P1-7 ScheduleView 四处裸 handler 无障碍/键盘
- [x] P1-8 MonthView chip 无障碍 + "+" focus/hover
- [x] P1-9 年视图日格（高度≥20/字号≥10/Accessible/键盘）
- [x] P1-10 Accessible.checked（CategoryRow / SidebarRow）
- [x] P1-11 搜索框 + 任务编辑器 Accessible.name
- [x] P1-12 labelSecondary 浅色对比度
- [x] P1-13 状态条 positive/warning 浅色对比度（⚠️ 无实拍，见仍差）
- [x] P1-14 nowPill DemiBold（实拍对照 ✓）
- [x] P1-15 月视图 today 字色 → accentText（实拍 light+dark ✓）
- [ ] P1-16 取消关联警告浅色加深或 DemiBold（EventEditorDialog.qml:433-444）

## 仍差
- **P1-13 状态条无实拍**：需驱动一条状态消息。可行路径：
  `{"action":"date","date":"2026-03-29"}` 跳 fixture 周 → 截图定位 chip →
  `pointer press+release` 选中 chip（openItem 依赖 selectedItems）→
  harness `openItem` 开编辑器 → 弹窗截图定位 Save → press+release →
  "Event updated" 3.5s 内 captureClient 状态条区域。
- P1-7/P1-8 键盘路径均代码层补齐、未实机逐键驱动（typeText 无功能键）。
- P1-5 弹窗内校验分支未实拍（toolbarMore 原生 popup 坐标点不进）。
- P1-4 仅实机证到"空标题"分支；其余非法分支同一代码路径。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行 12h 形态未实机驱到（继承）。
- **驱动陷阱（重要）**：`pointer kind:"click"` 未处理（fallthrough 成
  MouseMove）；必须 `press` + `release`。`pointerObject` 只悬停不点击，
  键是 `target`。`view` 命令键名是 `view`；只认 month/week/day。
  **已打开的弹窗不热载**——改 QML 后必须重启实例再驱弹窗。
  `review-command.py` 命令走 **argv[1]**，stdin/heredoc 静默无效。
- **新发现**：harness 有 `{"action":"sidebar","expanded":bool}`，展开侧栏
  用它，不要用 pointer 点 38,42。captureClient 的 path 落在
  **repo 根目录**（app cwd = /home/amao/nextkde），要 mv 进任务目录。
  原生菜单（toolbarMore popup）坐标点击无效。多条命令一次传入只处理第
  1 条，逐条发；一行 Bash 链多个 review-command.py 可行。
- fixture 事件在 2026-03-29 起（每日循环？），本周（2026-10）周视图为空。

## Next round
P1-16 — C5 `EventEditorDialog.qml:433-444` 取消关联警告浅色 3.89:1 →
加深或 DemiBold（建议先 python3 复算目标色，取最小偏离）。视觉类：
构建 → light 启动 → 驱动弹窗（注意"已打开弹窗不热载"，先重启再驱）→
实拍对照。P1-13 状态条实拍也可搭本轮弹窗链路顺带（如预算允许）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 杀残留进程：用 `pgrep -x kos-calendar` + /proc/<pid>/cmdline 验身份
  （`pgrep -f` 会匹配外层 loop 和自己 bash）。
- `start-review-vm.sh` 前台脚本：后台起、按 `live-app.pid` 管理；kill -TERM
  正常退出会完整写 ics。fixture：tmp/ui-acceptance/calendar/profile/pim/calendar.ics。
- 启动脚本把 `harness/command.json` 重置为 sequence 0；重起后先 resize
  1100x692。启动默认 `--view week --date 2026-10-15`。
- Wayland 嵌套会话偶发 "connection broke" 崩溃：重启一次即可，不无限重试。
- 截图存任务目录平铺（本轮 _p15-*.png 为过程图）。
- 全部完成后在下面单独一行写 `DONE`。
