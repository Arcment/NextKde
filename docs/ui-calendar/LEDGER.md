# R2 — 第二轮：全量代码 review + HIG 优化点（进行中）

## 本轮
R5 已完成（2026-10-18）。`CalendarMonthView.qml`（212 行）+ `EventDetailsPopover.qml`
（301 行）通读完毕。产出见 `docs/ui-calendar/REVIEW.md` §R5。线索 4/5/6/14/15/20
全部成立；新 5 条 finding（1×P1、4×P2）+ 2 条需人工判定 + 3 条已排除。重点：
**P1 月格 today 圆片硬编码白字 on accent（蓝 4.07:1/橙 3.53:1 不达标，
AppTheme.accentText 现成却没用）**；线索 15 实测 0.42 透明度 → 2.57:1（浅）/
3.63:1（深）双双不达标，且 out-month chip 底 alpha 0.16×0.42≈0.067 近乎不可见；
hover-only "+" 按钮对键盘用户不可见不可达；chip 18px 命中区 + 裸 TapHandler
双阻断。popover 次要文本 4.66/6.06、chip 墨色 13.11/9.35 实测达标已排除。

## 已覆盖区域
- R1 `Main.qml:1-1400` ✅
- R2 `Main.qml:1400-2500` ✅
- R3 `Main.qml:2500-2884` ✅
- R4 `CalendarScheduleView.qml` 全文 ✅
- R5 `CalendarMonthView.qml` + `EventDetailsPopover.qml` ✅

## 剩余区域
- R6 `EventEditorDialog.qml` + `CalendarTaskEditorDialog.qml`（线索 11/12）
- R7 横切汇总 + 建议修复顺序（注意 R2 修正：reduceMotion 守卫经 motion token
  隐式生效，横切 grep 时以"是否走 motionFast/motionNormal"为判据，不是找
  显式 reduceMotion 引用。另：R3 确认 itemTime 1353-1358 恒 24h 是"两套时间
  格式"问题的源头之一，R4 确认 ScheduleView nowLabel 173 也恒 24h、
  gutter 757-769 恒 12h——R7 汇总 i18n 时与线索 2/3/16 合并处理）。
  R4 留给 R7 的横切项：ScheduleView 四类裸 TapHandler/MouseArea 的键盘/
  Accessible 与 R3 年视图日格同类，汇总时合并成一条全局 finding。
  R5 留给 R7 的横切项：①MonthView chip 裸 TapHandler 加入该全局 finding；
  ②today 色分裂（MonthView:117 accent vs Main:2374/2834 todayRed vs
  AppTheme M04 注释自述 todayRed）单列一条；③硬编码 "white" on accent
  （MonthView:122、与 R4 nowPill 同类）——R7 可与 accentText 语义合并。

## Next round
R6 — `apps/calendar/qml/EventEditorDialog.qml` + `CalendarTaskEditorDialog.qml`。
先复核线索 11（删除按钮无确认无撤销）与线索 12（隐藏 DialogButtonBox 偷
标准按钮文案的脆弱写法）；再通读两文件找新问题（重点看 HIG 弹框规则：
Save 必配 Cancel、丢输入提示、键盘可达、字号/对比度、Accessible）。
产出追加到 `docs/ui-calendar/REVIEW.md`。

## 注意
- 只 review，不改源码、不构建、不启动应用。
- REVIEW.md 会入库，禁止出现 VM 的 IP/密码/绝对路径。
- 全部完成后在下面单独一行写 `REVIEW-DONE`。

## 上一轮结论（UI 复刻，已收尾）
R309 最终回归全过，spec ID 全部闭环。参考数据仍在 `tmp/ui-acceptance/calendar/state-archive.md`
（如不存在可忽略）。本轮的 HIG 数值以 `.loop/TASK.md` 为准。
