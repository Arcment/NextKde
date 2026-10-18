# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-9 ✅ 年视图日格 高度/字号/无障碍/键盘
Main.qml yearDayCell（:2806 起）：
- `Layout.preferredHeight` 18 → **20**（≥20 达标）。
- 日号 Label `font.pixelSize` 9 → **10**（≥10 达标）。
- 键盘：`activeFocusOnTab: inMonth`；Return/Space = `activate()`
  （inMonth 时 selectedDate = cellDate，同 MouseArea 点击语义）。
- 无障碍：role=ListItem（inMonth 才有，非本月 NoRole）、
  name=qsTr("%1; %2 items")（LongFormat 日期+事件数，复用月视图
  ":134" 措辞）、focusable、onPressAction=activate()。
- 焦点环：accent 1px 仅 activeFocus（静止态不变）。
构建 ✓；light 起 ✓，点分段切 Year：年视图正常渲染、日号清晰、
today/selected 圆盘不变、事件点可见、无 QML 报错
（shot-p19-year.png + crop shot-p19-crop-oct.png）。
年视图无参考图（原注释即"Extrapolated"），无对照图可较；
高度+2/字号+1 使月块略增高，12 个月 3×4 网格仍完整容纳（十月块实拍核过）。
本轮日志确认无 QML error/warning。

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
- [ ] P1-10 Accessible.checked（CategoryRow / SidebarRow）
- [ ] P1-11 搜索框 + 任务编辑器 Accessible.name
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
P1-10 — Accessible.checked（A2）：`Main.qml:421-423`（CategoryRow）与
`:281-407`（SidebarRow）补 `Accessible.checked` / role。非视觉类：构建 +
启动冒烟（日志无 QML 报错），写明"无视觉变化，无对照图"。行号以现文件
为准，先 grep 定位。注意 :421-423 附近是 swatchOnly 分支（ListItem/CheckBox
role 已有），checked 只对 CheckBox 形态有意义。

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
