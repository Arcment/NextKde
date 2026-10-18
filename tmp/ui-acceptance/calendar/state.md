# R2 — 第二轮：全量代码 review + HIG 优化点（已完成）

## 本轮
R7 横切汇总已完成（2026-10-18），REVIEW-DONE。横切 grep 实测：裸
TapHandler/MouseArea 全量 8 处（ScheduleView 414/625/838/1024、MonthView 188、
Main 1728/2864）；`CalendarScheduleView.qml` 全文 0 处 Accessible 属性；
动效守卫唯一缺口 = `Main.qml:248` pressDuration:150（1955/2104 走 motion
token，已排除）；字号 <10pt 共 9 处；时间格式分裂两腿全量定位；"今天"色
分裂 5 处定位。R6 的跨 app 备注**排除**：`apps/todo/qml/TodoEditorDialog.qml`
无隐藏 DialogButtonBox（只有 standardButtons:26），且标题有 New/Edit 区分。
REVIEW.md 新增 R7 三组合并清单（无障碍 A1-A9 / i18n I1-I7 / 对比度·token
C1-C8+M1+S1+F1）与"建议修复顺序"（P0×1 → P1×15 → P2 分批）。

## 已覆盖区域（全部完成）
- R1 `Main.qml:1-1400` ✅
- R2 `Main.qml:1400-2500` ✅
- R3 `Main.qml:2500-2884` ✅
- R4 `CalendarScheduleView.qml` 全文 ✅
- R5 `CalendarMonthView.qml` + `EventDetailsPopover.qml` ✅
- R6 `EventEditorDialog.qml` + `CalendarTaskEditorDialog.qml` ✅
- R7 横切汇总 + 建议修复顺序 ✅

## 剩余区域
无。产出全部在 `docs/ui-calendar/REVIEW.md`（入库）。

## Next round
无 review 轮次。若外层要开修复轮，从 REVIEW.md "建议修复顺序" 的 P0 第 1 条
（ScheduleView 全天条 "+N" 差一）开始。

REVIEW-DONE

## 注意
- 只 review，不改源码、不构建、不启动应用。
- REVIEW.md 会入库，禁止出现 VM 的 IP/密码/绝对路径。
- 全部完成后在下面单独一行写 `REVIEW-DONE`。

## 上一轮结论（UI 复刻，已收尾）
R309 最终回归全过，spec ID 全部闭环。参考数据仍在 `tmp/ui-acceptance/calendar/state-archive.md`
（如不存在可忽略）。本轮的 HIG 数值以 `.loop/TASK.md` 为准。
