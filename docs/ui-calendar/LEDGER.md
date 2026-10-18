# R1 — 第二轮：全量代码 review + HIG 优化点（进行中）

## 本轮
R1 已完成（2026-10-18）。`Main.qml:1-1400` 通读完毕：tokens、SidebarRow/
CategoryRow/SidebarSearch/GlassSurface/GlassButton/GlassPill/ToolbarButton/
DateNavButton/MiniMonthChevron、activation + item helper 函数。产出见
`docs/ui-calendar/REVIEW.md` §R1（10 条 finding：5×P1、5×P2；复核线索 3 成立、
线索 13 部分成立）。重点：浅色腿 labelSecondary 对比度 3.44/3.14/2.91 < 4.5；
CategoryRow 无 Accessible.checked；formatClock12 硬编码英文 AM/PM；
`--view year` 被忽略。

## 已覆盖区域
- R1 `Main.qml:1-1400` ✅

## 剩余区域
- R2 `Main.qml:1400-2500` — 工具栏、搜索、侧栏、迷你月（注意：itemAllDay
  :1406 与 itemCompleted :1410 刚好落在 R2 起点，一并看）
- R3 `Main.qml:2500-2884` — 内容带、页面装配、年视图
- R4 `CalendarScheduleView.qml` 全文
- R5 `CalendarMonthView.qml` + `EventDetailsPopover.qml`
- R6 `EventEditorDialog.qml` + `CalendarTaskEditorDialog.qml`
- R7 横切汇总 + 建议修复顺序

## Next round
R2 — `Main.qml:1400-2500`。先复核线索 8/9/13(1955,2104 行)/14(2673 不在本段)/
16(2646 不在本段，先跳过)/17(headerTitle 1524-1538)/18(搜索输入 1968-1980)/
20(2673 不在本段) 中落在本段的部分；再通读该行段找新问题。
产出追加到 `docs/ui-calendar/REVIEW.md`。

## 注意
- 只 review，不改源码、不构建、不启动应用。
- REVIEW.md 会入库，禁止出现 VM 的 IP/密码/绝对路径。
- 全部完成后在下面单独一行写 `REVIEW-DONE`。

## 上一轮结论（UI 复刻，已收尾）
R309 最终回归全过，spec ID 全部闭环。参考数据仍在 `tmp/ui-acceptance/calendar/state-archive.md`
（如不存在可忽略）。本轮的 HIG 数值以 `.loop/TASK.md` 为准。
