# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-1 ✅
locale 感知 12/24h helper 落地：
- `shared/qml/foundation/AppTheme.qml`（singleton，两处调用方都已 import）：新增
  `localeUses24hClock()`（locale 短时间格式无小写 `h` ⇒ 24h）、
  `meridiemText(hour)`（`uiLocale.amText/pmText`，空则回退 AM/PM）、
  `formatClock(hhmm)`（24h ⇒ 原样 "HH:MM"；12h ⇒ 既有紧凑式，分钟非零才显示，
  meridiem 取自 locale）。
- `Main.qml`：删 `formatClock12`（硬编码 AM/PM），`itemSecondary` 改走
  `AppTheme.formatClock`；同周期合并的 suffix 判断改为按小时取 `meridiemText`
  （旧式 `slice(-2)` 在非 ASCII/空 meridiem 下会切错）；24h locale 输出
  "HH:MM – HH:MM"。R246 12h 紧凑契约保留在注释中。
- `CalendarScheduleView.qml` gutter：meridiem 标签仅 12h locale 可见，文字取
  `AppTheme.meridiemText`；24h 时数字改锚 `parent.right`（原锚不可见的
  meridiem 标签会留右空隙），无 padding 直显小时。
- 验证（light, week）：构建过（qmlcachegen 三文件无错）；启动日志无 QML 报错；
  pim 日志无 parse error。zh-CN（24h）locale 实测 gutter 为裸数字
  9/10/12/13…，**无 AM/PM**（旧代码必显示 "9 AM"）→
  r351-p11-smoke-week2.png、放大 r351-weektop2.png。
- **12h 分支未实机渲染**：环境 locale 为 zh-CN 24h；逻辑为纯委托 +
  数值推演（"11:00"→"11AM"、"13:30"→"1:30PM"、"12:00–14:00"→"12 – 2PM"
  与 E02 契约一致）。i18n 类按 TASK.md 只需启动冒烟，无对照图。
- 本轮无与参考图冲突项（24h locale 下参考图的 "9 AM" gutter 本就不适用，
  属 REVIEW 要求的 locale 分流）。

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
- [ ] P1-2 时间 helper 推广：itemTime/议程/详情/nowLabel（含 58px 列宽）
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
- P1-1 的 12h 分支未实机渲染（zh 环境）；若后续轮次恰好需要 12h 验证
  （如 P1-2 改 itemTime），可顺带截图复核。

## Next round
P1-2 — 同一 helper（`AppTheme.formatClock`/`localeUses24hClock`）推广到
`Main.qml:1353` 附近的 `itemTime`（现走正则取 ISO "HH:MM" 恒 24h）、
`:2646` 议程行时间、`:1393-1398` 详情串、`CalendarScheduleView.qml:173`
nowLabel；同步核 `Main.qml:2645` 时间列 `preferredWidth: 58` 在 locale 化后
的截断风险（REVIEW 建议改 implicitWidth 自适应）。先读 `.loop/TASK.md` P1-2
与 `docs/ui-calendar/REVIEW.md` 对应条目（"P2 2646/2645" 两条 + R4 线索 2）。

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
