# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-6 ✅ 实拍收尾（三分支全验证）
重启实例（新二进制/新 QML）后整流程实拍，**无代码改动**：
- light 起 ✓ → resize 1100x692 → date 2026-04-03 → openItem(event,…) →
  详情弹层 → `pointerObject{"target":"detailsEdit","kind":"press/release"}`
  → 编辑日程弹窗 ✓（shot-p16-editor3.png）。
- 点「删除日程」(550,637) press+release → **确认层出现**：粗体
  "Delete this event?" + muted 说明（"…cannot be undone."）+ 取消（高亮
  默认）+ 删除日程（destructive），形态对照 alert-macos.png 一致（粗体标题+
  说明+纵向按钮，默认在上）（shot-p16-confirm.png）。
- **点穿保护实证**：第一次 press+release 未误删（Qt 隐式 grab，release 归
  原 Delete 按钮）；点穿只在第二次显式点击发生。
- Cancel 分支 ✓：点取消 (550,599) → footer 回三键态，不删
  （shot-p16-cancel.png）。
- Delete 分支 ✓：再点删除日程 → 确认层 → 再点 (550,637) → 弹窗关、
  状态条「日程已删除」、事件移除（shot-p16-deleted.png）。
- 收尾：kill 实例（正常退出，ics 完整 38 条）→ fixture 从备份恢复
  （39 条，END:VCALENDAR 完好）。本轮无代码 diff，commit 为 docs。
- 驱动陷阱（新）：`pointerObject` 的参数键是 **`target`** 不是 `object`
  （harness 读 command.target）；发 object 键静默不动（found:false）。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 全天条 "+N" 差一
- [x] P1-1 时间 helper（locale 12/24h）+ formatClock12 + gutter
- [x] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
- [x] P1-3 任务编辑器 New/Edit 标题
- [x] P1-4 事件编辑器保存校验
- [x] P1-5 任务编辑器保存校验
- [x] P1-6 删除二次确认（代码+确认层实拍三分支 ✓）
- [ ] P1-7 ScheduleView 四处裸 handler 无障碍/键盘
- [ ] P1-8 MonthView chip 无障碍 + "+" focus/hover
- [ ] P1-9 年视图日格（命中区/字号/Accessible/键盘）
- [ ] P1-10 Accessible.checked（CategoryRow / SidebarRow）
- [ ] P1-11 搜索框 + 任务编辑器 Accessible.name
- [ ] P1-12 labelSecondary 浅色对比度
- [ ] P1-13 状态条 positive/warning 浅色对比度
- [ ] P1-14 nowPill DemiBold
- [ ] P1-15 月视图 today 字色 → accentText
- [ ] P1-16 取消关联警告对比度
- [ ] P1-17 状态条播报 + 不静默消失
- [ ] P1-18 编辑器默认按钮/Return（先实机确认）
- [ ] P2-1 9 处 8–9px 字号
- [ ] P2-2 非本月 opacity
- [ ] P2-3 今天色统一 todayRed
- [ ] P2-4 硬编码中性灰收敛
- [ ] P2-5 headerTitle locale
- [ ] P2-6 DialogButtonBox 偷文案
- [ ] P2-7 占位符 locale
- [ ] P2-8 pressDuration reduceMotion
- [ ] P2-9 单点清理（窗口圆点顺序**不动**）

## 仍差
- P1-5 弹窗内校验分支未实拍（toolbarMore 原生 popup 坐标点不进）；行内错误
  UI 与 P1-4 已实证模式同构。
- P1-4 仅实机证到"空标题"分支；其余非法分支同一代码路径，未逐个实拍。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行（Main.qml:2646 dayAgenda 行）12h 形态未实机驱到（继承）。
- openItem(event,"Evening") 实际开的是当日首个 chip（Morning planning）——
  openItem 按 kind 打开首个匹配，不按标题；后续要指定事件需注意。
- **驱动陷阱（重要）**：`pointer kind:"click"` 未处理（fallthrough 成
  MouseMove）；必须 `press` + `release`。`pointerObject` 键是 `target`。
  命令协议 `action`：resize/date/openItem/pointerObject/pointer/typeText/
  captureClient/view…，`view` 只认 month/week/day。**已打开的弹窗不热载**
  （--watch-qml 只影响新开组件）——改 QML 后必须重启实例再驱弹窗。
- 原生菜单（toolbarMore 的 actionsMenu）坐标点击无效——主窗口合成事件到不了
  popup 窗口（P1-5 实证）。弹窗内容按坐标点。
- 多条命令一次 review-command.py 传入会丢命令（只处理第 1 条），逐条发；
  一行 Bash 里链多个 `python3 review-command.py '{...}'` 可行。

## Next round
P1-7 — ScheduleView 四处裸 handler（`CalendarScheduleView.qml:414,625,838,1024`）：
chip 加 `Accessible.role` + name（标题+时间），日头/小时格补键盘路径。
非视觉/无障碍类：构建 + 启动冒烟，写明"无视觉变化"。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 杀残留进程：**`pgrep -f "kos-calendar"` 会匹配外层 loop 和自己 bash**；用
  `pgrep -x kos-calendar` + `/proc/<pid>/cmdline` 验身份。
- `start-review-vm.sh` 前台脚本：后台起、按 `live-app.pid` 管理；杀之前正在
  写 ics 会截断 fixture。本轮已验：kill -TERM 正常退出会完整写 ics，杀后
  从备份恢复 calendar.ics（本轮备份在 /tmp/p16-calendar-backup.ics）。
- 启动脚本把 `harness/command.json` 重置为 sequence 0；重起后先 resize
  1100x692。
- Wayland 嵌套会话偶发 "connection broke" 崩溃：重启一次即可，不无限重试。
- 截图存任务目录平铺（本轮 shot-p16-editor3/confirm/cancel/deleted.png）。
- 全部完成后在下面单独一行写 `DONE`。
