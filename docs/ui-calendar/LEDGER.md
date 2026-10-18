# R2 — 第二轮：全量代码 review + HIG 优化点（进行中）

## 本轮
R3 已完成（2026-10-18）。`Main.qml:2500-2884` 通读完毕：状态条渲染端、
KosPageCache 装配、月页议程卡、周/日页装配、年视图。产出见
`docs/ui-calendar/REVIEW.md` §R3（11 条：3×P1、7×P2、1 条需人工判定）。
线索 14(2673,2859)/16(2646)/19(2821-2824)/7(2864) 成立；19 降级
（itemsForDate 是字典查找，成本=itemsByDate 变更触发 ~504 绑定重算）；
线索 20 不在本段留给 R5。新发现重点：**状态条 positive/warning 在浅色
contentPlane 上 2.22:1 / 2.31:1（python3 实测，深色腿达标）**；年视图日格
MouseArea 18px 高无键盘无 Accessible（键盘用户无法在年视图选具体某天）；
白 on todayRed 3.91:1、白 on selectionDisc 3.26:1 均过粗体阈值——已排除。

## 已覆盖区域
- R1 `Main.qml:1-1400` ✅
- R2 `Main.qml:1400-2500` ✅
- R3 `Main.qml:2500-2884` ✅

## 剩余区域
- R4 `CalendarScheduleView.qml` 全文（线索 1/2/3 的 855/880/982、173、757-771；
  线索 14 的 457/620/647/1042）
- R5 `CalendarMonthView.qml` + `EventDetailsPopover.qml`（线索 4/5/6/14/15/20）
- R6 `EventEditorDialog.qml` + `CalendarTaskEditorDialog.qml`（线索 11/12）
- R7 横切汇总 + 建议修复顺序（注意 R2 修正：reduceMotion 守卫经 motion token
  隐式生效，横切 grep 时以"是否走 motionFast/motionNormal"为判据，不是找
  显式 reduceMotion 引用。另：R3 确认 itemTime 1353-1358 恒 24h 是"两套时间
  格式"问题的源头之一，R7 汇总 i18n 时与线索 2/3/16 合并）

## Next round
R4 — `apps/calendar/qml/CalendarScheduleView.qml` 全文。先复核线索 1
（855-857 margins 3 → 内高 34 vs chip 高 38 溢出、880-881、982 恒真）、
线索 2（173 nowLabel 24h vs 757-771 侧栏刻度 12h）、线索 3（757 AM/PM
硬编码英文）、线索 14（457/620/647/1042 <10pt）；再通读全文找新问题
（today 高亮条、全天条、chip 无障碍、性能）。
产出追加到 `docs/ui-calendar/REVIEW.md`。

## 注意
- 只 review，不改源码、不构建、不启动应用。
- REVIEW.md 会入库，禁止出现 VM 的 IP/密码/绝对路径。
- 全部完成后在下面单独一行写 `REVIEW-DONE`。

## 上一轮结论（UI 复刻，已收尾）
R309 最终回归全过，spec ID 全部闭环。参考数据仍在 `tmp/ui-acceptance/calendar/state-archive.md`
（如不存在可忽略）。本轮的 HIG 数值以 `.loop/TASK.md` 为准。
