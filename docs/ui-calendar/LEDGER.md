# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-11 ✅ 搜索框 + 任务编辑器 Accessible.name（A3+A4）
5 处补 `Accessible.name`（非视觉）：
- Main.qml SidebarSearch 组件内 TextInput（:531）：`Accessible.name: field.placeholder`
  （跟随组件 placeholder，qsTr("Search")）。
- Main.qml 工具栏搜索 TextInput（:1968，objectName toolbarSearchInput）：
  `Accessible.name: qsTr("Search")`。
- CalendarTaskEditorDialog.qml：listBox → `qsTr("Task list")`、
  priorityBox → `qsTr("Task priority")`、notesField（TextArea.flickable 内
  KosTextArea）→ `qsTr("Task notes")`，措辞对齐本文件已有
  "Task title"/"Task due date" 风格。
构建 ✓；dark 启动 ✓，resize 1100x692 + captureClient 冒烟
（shot-p111-smoke.png，周视图渲染正常），日志 0 条 QML error/warning，
kill -TERM 干净退出。
**本轮无视觉变化，故无对照图。**
注：REVIEW.md 原行号 :527-560/:1995-2013 偏移（现 :530/:1967），
grep "TextInput\|searchField" 定位；无独立 searchField id，搜索框是
SidebarSearch 组件内 TextInput + 工具栏匿名 TextInput。

## 上一轮 (2026-10-18) — P1-10 ✅ Accessible.checked（CategoryRow / SidebarRow）
Main.qml 组件声明处补两行（非视觉）：SidebarRow 补 role(Switch/ListItem)+checked；
CategoryRow 补 checked。构建 ✓ 冒烟 ✓ 无视觉变化。
captureClient 的 path 必须绝对路径。


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
- [ ] P1-12 labelSecondary 浅色对比度
- [ ] P1-13 状态条 positive/warning 浅色对比度
- [ ] P1-14 nowPill DemiBold
- [ ] P1-15 月视图 today 字色 → accentText

## 仍差
- P1-7/P1-8 键盘路径均代码层补齐、未实机逐键驱动（typeText 无功能键；
  焦点移动依赖 Tab 序/children 顺序，未实机验证）。
- P1-5 弹窗内校验分支未实拍（toolbarMore 原生 popup 坐标点不进）；行内错误
  UI 与 P1-4 已实证模式同构。
- P1-4 仅实机证到"空标题"分支；其余非法分支同一代码路径，未逐个实拍。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行（Main.qml:2646 dayAgenda 行）12h 形态未实机驱到（继承）。
- openItem(event,"Evening") 实际开的是当日首个 chip（Morning planning）——
  openItem 按 kind 打开首个匹配，不按标题；后续要指定事件需注意。
- **驱动陷阱（重要）**：`pointer kind:"click"` 未处理（fallthrough 成
  MouseMove）；必须 `press` + `release`。`pointerObject` 键是 `target`。
  `view` 命令键名是 `view` 不是 `value`（`{"action":"view","view":"month"}`）；
  命令协议 `action`：resize/date/openItem/pointerObject/pointer/typeText/
  captureClient/view…，`view` 只认 month/week/day。**已打开的弹窗不热载**
  （--watch-qml 只影响新开组件）——改 QML 后必须重启实例再驱弹窗。
- 原生菜单（toolbarMore 的 actionsMenu）坐标点击无效——主窗口合成事件到不了
  popup 窗口（P1-5 实证）。弹窗内容按坐标点。多条命令一次传入会丢命令
  （只处理第 1 条），逐条发；一行 Bash 链多个 review-command.py 可行。

## Next round
P1-12 — C1 浅色对比度：`Main.qml:120-123`（行号以现文件为准，grep
"labelSecondary" 的浅色腿 readonly property）alpha 0.60 → ≈0.78，
需按 WCAG 公式 python3 复算 ≥4.5:1 并把数值写进 state.md；若与参考
实测色冲突，取满足 4.5:1 的最小偏离并记「与参考的偏差」。视觉类：
light 启动 + 截图对照（侧栏次级文字区域）。



## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 杀残留进程：**`pgrep -f "kos-calendar"` 会匹配外层 loop 和自己 bash**；用
  `pgrep -x kos-calendar` + `/proc/<pid>/cmdline` 验身份。
- `start-review-vm.sh` 前台脚本：后台起、按 `live-app.pid` 管理；kill -TERM
  正常退出会完整写 ics。本轮备份在 /tmp/p16-calendar-backup.ics（P1-9 轮
  重启后可直接复用比对）。fixture 路径：tmp/ui-acceptance/calendar/profile/pim/calendar.ics。
- 启动脚本把 `harness/command.json` 重置为 sequence 0；重起后先 resize
  1100x692。
- Wayland 嵌套会话偶发 "connection broke" 崩溃：重启一次即可，不无限重试。
- 截图存任务目录平铺（本轮 shot-p18-month.png）。
- 全部完成后在下面单独一行写 `DONE`。
