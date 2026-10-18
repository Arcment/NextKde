# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-6 ⚠️（代码完成，确认层未实拍）
P1-6 删除二次确认（EventEditorDialog + CalendarTaskEditorDialog，同构改动）：
- 新增 `property bool confirmingDelete`；两个 open 函数重置为 false。
- Delete 按钮 onClicked 改为 `confirmingDelete = true` +
  `confirmCancelButton.forceActiveFocus()`（默认焦点在 Cancel）。
- footer 双态：`footerCol`（原 Save/Cancel/Delete）在确认态隐藏；新增
  `confirmCol` = 粗体标题（"Delete this event/task?"）+ 一行说明
  （"…removed from every view. This cannot be undone."，mutedText 11px）+
  Cancel（highlighted 默认，沿用 cancelLabel 平台文案）+ Delete（destructive
  secondary，唯一 emit deleteRequested 的地方）。footer implicitHeight 按态切换。
  形态对照 `.loop/refs/macos26/alert-macos.png`（alert = 粗体标题+说明+纵向按钮，
  与 D05 既有堆叠按钮语言一致）。Main.qml 两个 onDeleteRequested 未动。
- 构建 ✓；light 实机起 ✓（旧实例复用）。
- **实拍失败（回路 1）**：openItem→detailsEdit 驱动到编辑日程弹窗 ✓，点
  「删除日程」(550,637) 后弹窗关闭、状态条「日程已删除」——**fixture 事件被
  真删一条**（已从 calendar-fixture.ics 恢复 profile/pim/calendar.ics，
  Evening session ×7、END:VCALENDAR 完好）。原因：实例 cmdline 带
  `--watch-qml`，但**已打开的弹窗不热载**——press 时弹窗仍是旧组件实例，
  走旧 onClicked 直接 emit。随后出现的 New task 弹窗疑为热载重建的副产物。
- 修正后实例已 kill；下一轮**重启实例**（加载新二进制/新 QML）再整流程实拍。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 全天条 "+N" 差一
- [x] P1-1 时间 helper（locale 12/24h）+ formatClock12 + gutter
- [x] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
- [x] P1-3 任务编辑器 New/Edit 标题
- [x] P1-4 事件编辑器保存校验
- [x] P1-5 任务编辑器保存校验
- [x] P1-6 删除二次确认（代码完成，确认层待实拍）
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
- **P1-6 确认层未实拍**。下一轮先 `start-review-vm.sh light`（旧实例已 kill，
  会加载新二进制），再走 resize→date 2026-04-03→openItem(event,"Evening")→
  pointerObject detailsEdit press+release→截图→点「删除日程」(约 550,637)→
  截图对照 alert-macos.png。**注意**：若 press 后 footer 切确认态、release 落
  在同坐标恰是确认 Delete → 点穿误删（理论上有 grab 取消保护，需实测）。
  验完 Cancel 分支（点 Cancel 应回三键态、不删）。
- P1-5 弹窗内校验分支未实拍（toolbarMore 原生 popup 坐标点不进）；行内错误
  UI 与 P1-4 已实证模式同构。
- P1-4 仅实机证到"空标题"分支；其余非法分支同一代码路径，未逐个实拍。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行（Main.qml:2646 dayAgenda 行）12h 形态未实机驱到（继承）。
- **驱动陷阱（重要）**：`pointer kind:"click"` 未处理（fallthrough 成
  MouseMove）；必须 `press` + `release`。命令协议是 `action`（resize/date/
  openItem/pointerObject/pointer/typeText/captureClient/view…），`view` 只认
  month/week/day。**已打开的弹窗不热载**（--watch-qml 只影响新开组件）——
  改 QML 后必须重启实例再驱弹窗。
- 原生菜单（toolbarMore 的 actionsMenu）坐标点击无效——主窗口合成事件到不了
  popup 窗口（P1-5 实证）。弹窗内容按坐标点。
- 多条命令一次 review-command.py 传入会丢命令（只处理第 1 条），逐条发；
  一行 Bash 里链多个 `python3 review-command.py '{...}'` 可行。

## Next round
P1-6 收尾实拍（见上），拍完把队列推进到 P1-7 — ScheduleView 四处裸 handler
（`CalendarScheduleView.qml:414,625,838,1024`）：chip 加 `Accessible.role` +
name（标题+时间），日头/小时格补键盘路径。非视觉/无障碍类：构建 + 启动冒烟，
写明"无视觉变化"。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 杀残留进程：**`pgrep -f "kos-calendar"` 会匹配外层 loop 和自己 bash**；用
  `pgrep -x kos-calendar` + `/proc/<pid>/cmdline` 验身份。
- `start-review-vm.sh` 前台脚本：后台起、按 `live-app.pid` 管理；杀之前正在
  写 ics 会截断 fixture（补 `END:VCALENDAR`）。fixture 已于本轮恢复。
- 启动脚本把 `harness/command.json` 重置为 sequence 0；重起后先 resize
  1100x692。
- Wayland 嵌套会话偶发 "connection broke" 崩溃：重启一次即可，不无限重试。
- 截图存任务目录平铺（本轮 shot-p16-editor.png / shot-p16-confirm.png）。
- 全部完成后在下面单独一行写 `DONE`。
