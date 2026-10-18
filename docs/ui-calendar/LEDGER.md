# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-13 ⚠️ 状态条 positive/warning 浅色对比度（C2）
`Main.qml` tahoe 块（:147 后）新增 `statusPositive`/`statusWarning`；
状态条文本（:2518 附近）从 `AppTheme.warning/positive` 改用这两个 token。
- 发现：REVIEW 写的 `#34C759`/`#FF8D28`（2.22/2.31:1）是 tahoe token，
  但状态条实际用的 `AppTheme.positive/warning`（AppTheme.qml:189-190，
  浅色 `#16875f`/`#b96800`）实测 **4.50 / 4.16:1**——positive 压线过、
  warning 不达标。两者色相都偏离 tahoe 参考族。
- 修复：浅色腿取 tahoe 同色相最小加深（python3 逐级乘系数找 ≥4.5 的
  最小乘数）：positive `#34C759`×0.686=**#24883D = 4.50:1**（Apple 可及
  绿 #248A3D 只有 4.40，故再深一档）；warning `#FF8D28`×0.699=
  **#B2621C = 4.51:1**（Apple 可及橙 #C93400 5.28 但色相偏红，取同色相）。
  深色腿保持参考原色（#1E1E1E 上 7.51/7.22:1 不变）。
- **与参考的偏差**：浅色模式状态条文字比参考深；深色不变。boxColor
  （:2202/:2212）等非文本用途未动。
- 构建 ✓；light 启动 ✓，resize 1100x692 + sidebar 展开（用 harness 的
  `{"action":"sidebar","expanded":true}`，比 pointer 点击可靠）+ capture
  冒烟，日志 0 条 QML error/warning，kill -TERM 干净退出。
- **视觉实证未完成**：触发状态消息两次尝试失败——openItem(event) 无匹配
  chip（fixture 事件都在 2026-03，当前周 10-12..10-18 网格为空）；
  状态条颜色为代码层修复 + WCAG 数值验证，无实拍对照图（详见仍差）。

## 上一轮 (2026-10-18) — P1-12 ✅ labelSecondary 浅色对比度（C1）
浅色腿 `#3C3C43` alpha 0.60→**0.79**：侧栏平面 #E4E4E4 = 4.56:1、
白平面 = 5.80:1（0.78 只有 4.43 不达标，0.79 为两平面同时过的最小值）。
与参考偏差：Apple token 60% 实测 3.44/2.70:1，保色相提 alpha 最小偏离。
实拍 shot-p12-light3.png 验证合成一致。

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
- [ ] P1-14 nowPill DemiBold
- [ ] P1-15 月视图 today 字色 → accentText

## 仍差
- **P1-13 状态条无实拍**：需驱动一条状态消息（事件创建/更新/删除），
  截状态条验证浅色文字为新色。可行路径：先 `{"action":"date","date":
  "2026-03-29"}` 跳到 fixture 事件所在周（事件 8:00/10:15/11:00/14:30/
  18:00 每日），openItem 打开 chip → 弹窗 Save（press+release）→
  "Event updated" 状态出现 3.5s，期间 captureClient。
- P1-7/P1-8 键盘路径均代码层补齐、未实机逐键驱动（typeText 无功能键）。
- P1-5 弹窗内校验分支未实拍（toolbarMore 原生 popup 坐标点不进）。
- P1-4 仅实机证到"空标题"分支；其余非法分支同一代码路径。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行 12h 形态未实机驱到（继承）。
- **驱动陷阱（重要）**：`pointer kind:"click"` 未处理（fallthrough 成
  MouseMove）；必须 `press` + `release`。`pointerObject` 只悬停不点击，
  键是 `target`。`view` 命令键名是 `view`；只认 month/week/day。
  **已打开的弹窗不热载**——改 QML 后必须重启实例再驱弹窗。
- **新发现**：harness 有 `{"action":"sidebar","expanded":bool}`，展开侧栏
  用它，不要用 pointer 点 38,42（本轮未生效）。captureClient 的 path 落在
  **repo 根目录**（app cwd = /home/amao/nextkde），要 mv 进任务目录。
  原生菜单（toolbarMore popup）坐标点击无效。多条命令一次传入只处理第
  1 条，逐条发；一行 Bash 链多个 review-command.py 可行。
- fixture 事件在 2026-03-29 起（每日循环？），本周（2026-10）周视图为空。

## Next round
P1-14 — C3 nowPill 文字加 `Font.DemiBold`：`CalendarScheduleView.qml`
（grep "nowPill"，REVIEW 记 :792-797 可能偏移）。改动小、视觉类：
构建 → light 启动 → resize → 定位 nowPill（本周视图 12:xx 红色 pill，
在周视图可见）→ 前后截图对照字重。顺手（同一条 finding 内）若驱动便宜，
可补 P1-13 状态条实拍（见仍差第一条路径）——但只算 P1-14 一轮。

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
- 截图存任务目录平铺（本轮 _p13-*.png 为过程图）。
- 全部完成后在下面单独一行写 `DONE`。
