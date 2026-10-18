# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-14 ✅ nowPill DemiBold（C3）
`CalendarScheduleView.qml` nowPillLabel 加 `font.weight: Font.DemiBold`。
- REVIEW C3：白 on todayRed #E5484D = 3.91:1 常规体；finding 给 DemiBold
  或加深底色两案，取 DemiBold（贴 ref 加粗胶囊字，不动 todayRed token）。
- 构建 ✓；light 启动 ✓ → resize 1100x692 → sidebar action 展开 →
  captureClient `_p14-light-full.png`（1100x720），nowPill "12:20" 可见。
- 实拍对照：2× NEAREST 裁块 `_p14-pill-zoom.png` vs 参考
  `_p14-ref-pill-zoom.png`（ref 9:41 胶囊）：笔画粗细一致，加粗成立。
- WCAG 说明：11px DemiBold 严格 WCAG 不算 large text（需 ≥18.66px
  bold）；按 REVIEW 建议执行，与日头 12px DemiBold 同待遇，数值 3.91:1
  未变，形式贴参考。
- 新坑：`review-command.py` 只收 **argv[1]** JSON（stdin/heredoc 静默
  无效，sequence 不动）。
- P1-13 状态条顺带实拍放弃（预算线）：openItem 依赖 selectedItems，
  需先 pointer 选中 chip（press+release），链路长，路径记仍差。

## 上一轮 (2026-10-18) — P1-13 ⚠️ 状态条 positive/warning 浅色对比度（C2）
`Main.qml` tahoe 块新增 `statusPositive`/`statusWarning`；状态条文本
改用这两个 token。浅色腿取 tahoe 同色相最小加深（python3 逐级乘系数）：
positive `#34C759`×0.686=**#24883D = 4.50:1**；warning `#FF8D28`×0.699=
**#B2621C = 4.51:1**。深色腿保持参考原色（#1E1E1E 上 7.51/7.22:1）。
与参考偏差：浅色状态条文字比参考深，色相不变。构建+冒烟 ✓。
**视觉实证未完成**（触发状态消息两次失败，见仍差）。

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
- [ ] P1-15 月视图 today 字色 → accentText

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
P1-15 — C4 `CalendarMonthView.qml:122` 白字 → `AppTheme.accentText`。
改动小、视觉类：构建 → light 启动 → view month → capture → 裁今天格
对照（今天数字色变 accentText）。注意行号可能偏移，先 grep 确认。

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
- 截图存任务目录平铺（本轮 _p14-*.png 为过程图）。
- 全部完成后在下面单独一行写 `DONE`。
