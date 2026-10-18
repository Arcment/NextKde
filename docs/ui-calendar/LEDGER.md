# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-2 ✅
接手 iter-355 半成品（该轮因模型错误中断：已提交 P1-2 源码 d32ec19，但未构建
验证、未更新 state）。本轮完成验证并修掉验证中发现的裁切缺陷：
- 既有 d32ec19 内容核对：`itemTime` 走 `AppTheme.formatClock` ✓、
  `itemDetailsRange` 同日 end 时钟同 helper ✓、议程行时间列
  `Math.max(58, implicitWidth)` 自适应 ✓、`nowLabel` 走 helper ✓、
  nowPill 宽度 `Math.max(42, implicitWidth+12)`（本轮回收，见下）✓。
- 构建 ✓（iter-355 后无待编，本轮 pill 修复后重编过）。
- **12h locale 实机验证**（LC_ALL=en_US.UTF-8 起 light）：week gutter
  "8 AM"–"7 PM" ✓；chips "8 – 8:45AM"/"11AM – 1PM" ✓；nowPill 实拍
  "11:08AM" ✓（r356-pill-fixed-zoom.png）。
- **发现并修复**：nowPill 12h 时宽 ~57px > 52px gutter，右锚+6margin 导致
  左侧越出窗口，"11:08AM" 被裁成 "1:06AM"（r356-12h-week-today.png 可复现）。
  修法（dea3aeb）：宽度 clamp 到 `gutterWidth-4`、rightMargin 6→2；11px 字的
  "11:08AM" ≈45px < 48px 可完整放下；24h "09:05" 仍走 42px 下限不变。
  复拍确认完整显示（r356-pill-fixed-zoom.png）。
- zh-CN 24h 路径：输出与改前逐字符相同（"HH:MM"），本轮改动在该 locale 下
  零视觉变化；24h gutter 冒烟 R351 已覆盖。
- 议程行（:2646）未实机驱到（day 视图下方 dayAgenda 面板滚动未达，预算尽）；
  其文本与已验证的 chip/gutter/pill 走同一 `formatClock`，宽度自适应下限 58px
  对 "8AM" 等 12h 短串无截断风险。记入「仍差」。

## 插曲（环境修复，非 finding）
- 首次启动用 `timeout 90` 包前台脚本误杀，且把 `profile/pim/calendar.ics`
  截断（缺 `END:VCALENDAR`，块 42/42 平衡）→ pim 报 "Unable to load the
  existing iCalendar file"、无事件。补一行 `END:VCALENDAR` 修复（一次性
  review fixture，非真实数据）。后续启动不再用 timeout 包前台脚本，用后台任务。
- fixture 内事件日期为 2026-03/04，与 `--date 2026-10-15` 视图不同月 → 本周
  无 chip 可看；与代码无关（pim 加载已无错误）。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 全天条 "+N" 差一（`CalendarScheduleView.qml:525-528,550`）
- [x] P1-1 时间 helper（locale 12/24h）+ formatClock12 + gutter
- [x] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
- [ ] P1-3 任务编辑器 New/Edit 标题
- [ ] P1-4 事件编辑器保存校验
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
- P1-2 议程行（Main.qml:2646 dayAgenda 行）12h 形态未实机驱到（面板在 day
  视图时间轴下方，本轮滚动未达）；文本走与已验证三处相同的 `formatClock`，
  风险低。
- P1-1/P1-2 12h 验证均依赖 `LC_ALL=en_US.UTF-8` 启动，非默认环境 locale。

## Next round
P1-3 — `CalendarTaskEditorDialog.qml:18` 新建任务标题也是 "Edit task"，
补 `editingId.length > 0` 分支。先读 `.loop/TASK.md` P1-3 与 REVIEW.md 对应
条目。非视觉/低风险改动：构建 + 启动冒烟即可，写明"无视觉变化"。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 驱动陷阱：`pgrep -f "calendar-review/apps/calendar/kos-calendar"` 会匹配本
  loop 的 bash 自身 → pkill 自杀。判进程用 `/proc/<pid>/cmdline` 验身份。
- `start-review-vm.sh` 是前台脚本：不要用 `timeout` 包它，用后台任务起、
  TaskStop 收；杀之前它正在写 ics 时会把 fixture 截断（见插曲，修法：补
  `END:VCALENDAR`）。
- 截图存任务目录平铺（`shots/` 不存在，capture 返回 false）。
- 全部完成后在下面单独一行写 `DONE`。
