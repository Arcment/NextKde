# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-4 ✅
`EventEditorDialog.qml` 保存校验（I4）：
- 新增 `parseDateText`（严格 `YYYY-MM-DD` + Date 往返拒绝 2026-02-30 滚动）、
  `parseTimeText`（严格 `HH:MM`，0-23:0-59）。
- `validationProblem()`：空标题、起止日期/时间非法、end<start、
  同日计时 end<=start → 返回 {message, fields}。
- `accept()` 覆写：先校验，非法则设置 `errorText/errorFields` 并 **不关闭弹窗**
  （阻止 accept，不落坏数据）；合法走原 `onAccepted → saveRequested`。
- UI：表单顶部行内错误 Label（`errorColor`）+ 5 个字段
  （title/startDate/endDate/startTime/endTime）红描边（`outlineColor` →
  destructive），编辑该字段即清错误（`onTextChanged → clearError`）；
  openForDate/openForEvent 重置错误态。
- 对比度复算（WCAG，python3）：行内错误文字 11px 需 4.5:1。
  `AppTheme.destructive` 浅色 #d83b3b on #F7F7F7 = **4.25:1 不达标** →
  行内错误改用局部 `errorColor`：浅色 **#d23636 = 4.54:1**（最小偏离），
  深色 #ff6961 on #262626 = 5.37:1 保持 token。
  **与参考的偏差**：错误红比全局 destructive 深一档，仅用于该行内文案。
- 构建 ✓；light 实机驱动 ✓：点 保存（空标题）→ 弹窗不关、顶部红色
  "Title is required."、标题框红描边（`r-p14-editor-error3.png`）。
  日志无 QML error。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 全天条 "+N" 差一
- [x] P1-1 时间 helper（locale 12/24h）+ formatClock12 + gutter
- [x] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
- [x] P1-3 任务编辑器 New/Edit 标题
- [x] P1-4 事件编辑器保存校验
- [ ] P1-5 任务编辑器保存校验
- [ ] P1-6 删除二次确认
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
- P1-4 仅实机证到"空标题"分支；日期/时间非法、end<start 分支是同一代码路径
  （静态可证），未逐个实拍。
- P1-3 弹窗标题 "New task" 未实机截图确认（继承）。
- P1-2 议程行（Main.qml:2646 dayAgenda 行）12h 形态未实机驱到（继承）。
- **驱动陷阱（重要）**：`pointer kind:"click"` 在 ReviewInput.cpp 中**未处理**，
  会 fallthrough 成 MouseMove（只 hover 不点击）。必须 `press` + `release`
  两次命令。弹窗内容在 window overlay 里，`objectNamed/controlNamed` 搜不到，
  弹窗内按钮要按坐标点（本轮 保存 = 554,614 @1100x720）。
- 上一轮遗留实例占用：start 脚本会拒绝启动，先按 `/proc/<pid>/cmdline`
  验身份后 kill（本轮 3360485 即上一轮残留）。
- 多条命令一次 review-command.py 传入会丢命令（只处理第 1 条），
  逐条发更稳。

## Next round
P1-5 — `CalendarTaskEditorDialog.qml:157-172` 同类保存校验（due date/time
解析、空标题、区间），沿用本轮 EventEditorDialog 的
parseDateText/parseTimeText/validationProblem/accept 覆写/行内错误+红描边
模式。校验逻辑类：构建 + 启动冒烟；可顺带补拍 P1-3 的 "New task" 标题截图
（弹窗打开即拍，无需点按钮）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 驱动陷阱：`pgrep -f "calendar-review/apps/calendar/kos-calendar"` 会匹配
  外层 loop 进程与自身 bash → 判进程用 `/proc/<pid>/cmdline` 验身份。
- `start-review-vm.sh` 是前台脚本：不要用 `timeout` 包它，用后台任务起、
  TaskStop 收；杀之前它正在写 ics 时会把 fixture 截断（修法：补
  `END:VCALENDAR`）。
- 启动脚本会把 `harness/command.json` 重置为 sequence 0。
- 本轮 Wayland 嵌套会话出现过一次崩溃（"connection broke"），重启即好；
  再遇同样按重启一次处理，不无限重试。
- 截图存任务目录平铺。
- 全部完成后在下面单独一行写 `DONE`。
