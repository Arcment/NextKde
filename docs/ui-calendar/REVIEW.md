# 日历 app 代码 review + HIG 优化点

第二轮全量代码 review（分支 `codex/calendar-ui-iter-20261016`）。
finding 格式：`- [P0|P1|P2] file:line — 事实（含实测数值）。影响。建议：…`
区域划分与轮次记录见 `tmp/ui-acceptance/calendar/state.md`（不入库）。

## R1 — `Main.qml:1-1400`（tokens、日期/文案 helper、基础组件）

### 已复核的既有线索
- 线索 3（`Main.qml:1315` formatClock12 硬编码 AM/PM）：**成立**，见 F1。
- 线索 13（动画是否有 `AppTheme.reduceMotion` 守卫）：**部分成立**。`AppTheme`
  本身有降级通道（`shared/qml/foundation/AppTheme.qml:26,179-182`：
  `motionFast/motionNormal` 在 reduceMotion 下为 0，`hoverScale/pressScale` 为 1），
  凡走 `AppTheme.motionFast` 的动画自动守卫（如 `Main.qml:392` 的开关滑块）。
  但 R1 区间内 GlassSurface 的三处 Behavior 用**硬编码** `pressDuration: 150`
  （`Main.qml:248, 675-677, 802-803`），不经过任何守卫。1955/2104 行留待 R2。

### Findings
- [P1] `Main.qml:120-123` — 浅色腿 `labelSecondary`（`#3C3C43 @60%`）实测对比度：
  白色内容面上合成色 (138,138,142) → **3.44:1**；侧栏 `#E4E4E4` 上 → **3.14:1**；
  搜索框 `#D2D2D2` 底上 → **2.91:1**（python 按 WCAG 合成+公式算）。全部低于
  ≤17pt 文本要求的 4.5:1，而这些 secondary 标签的字号是 13–15px。深色腿单独验
  过：`#F2F2F2 @58%` 在 `#1E1E1E`/`#282828` 上为 5.85/5.44:1，达标——**只有浅色
  腿不达标**。影响：占位符、行尾 detail、分组标题等浅色模式下可读性不足。
  建议：浅色腿把 alpha 提到 ~0.78（合成后 ≈4.6:1）或提供 Increase Contrast 变体。
- [P1] `Main.qml:1309-1319` — `formatClock12` 无条件 12 小时制且 `suffix = "PM" : "AM"`
  硬编码英文（1336 行同理判 `"AM"/"PM"`），完全不走 `Qt.locale()`，也不看系统
  12/24 偏好。影响：24 小时制 locale（含中文环境）的 chip 副标题全部显示英文
  AM/PM；与 app 内 24 小时制的其它文案冲突（见 R4 线索 2、R2 线索 16）。
  建议：按 locale 12/24 偏好分流，meridiem 用 `Qt.locale().pmText/amText`。
- [P1] `Main.qml:421-423` — `CategoryRow` 设了 `Accessible.role: Accessible.CheckBox`
  却**从未设 `Accessible.checked`**（全仓 grep `Accessible.checked` 0 处命中）。
  选中态只靠 12px 方块填色表达。影响：VoiceOver 用户听到"复选框"但永远听不到
  勾选状态；也违反"不许只靠颜色传达信息"（这里连形状都变了但无障碍层不知道）。
  建议：`Accessible.checked: row.checked`。
- [P1] `Main.qml:281-407` — `SidebarRow`（含 `showSwitch` 的开关行）没有任何
  `Accessible.role` 覆盖：AbstractButton 默认 role 是按钮，开关视觉（42x26 track
  + 滑块）对辅助技术不可见，`checked` 状态也不暴露（无 `Accessible.checked`）。
  影响：日历/任务列表开关的开关状态对 VoiceOver 完全不可知。建议：
  showSwitch 行改 `Accessible.role: Accessible.CheckBox` + `Accessible.checked`。
- [P1] `Main.qml:527-560` — `SidebarSearch` 的 `TextInput` 无 `Accessible.name`
  也无 role；唯一能读到的信息是旁边的占位符 Label。影响：VoiceOver 聚焦该输入
  框时无可读名称，搜索入口被阻断。建议：`Accessible.name: qsTr("Search")`、
  `Accessible.role: Accessible.EditableText`（同类的 1968 行 R2 复核）。
- [P2] `Main.qml:1126` — `handleActivation` 的 `--view` 只接受
  `["month", "week", "day"]`，而 `activeView`（:256）支持 4 个视图。`--view year`
  被静默忽略。影响：与线索 8（Year 无快捷键）同源——第四视图既无键盘路径也无
  激活路径。建议：数组补 `"year"`。
- [P2] `Main.qml:675-677, 802-803` — GlassSurface hover/press 的 Behavior 用硬编码
  `pressDuration: 150`（:248），且 pressScale 0.97 是缩放动画；不经过
  `AppTheme.reduceMotion`。HIG Reduce Motion：缩放/位移动画应退化为淡入淡出。
  建议：时长改绑 `AppTheme.motionNormal` 类 token，或按下缩放直接乘
  `reduceMotion ? 1 : pressScale`。
- [P2] `Main.qml:1393-1404` — `itemDetailsRange` 对当日计时事件返回
  `dateLine · itemTime(item)`，而 `itemTime`（:1353）返回 24 小时制 `HH:MM` 原串；
  同一 app 的 chip 副标题（itemSecondary）是 12 小时制。影响：详情浮层与 chip
  两套时间制式并存。建议：浮层时间统一走 locale 格式化（与 F1 一并修）。
- [P2] `Main.qml:531, 533, 544` — `SidebarSearch` 内部边距硬编码 47，而
  `searchInsetLeading/Trailing`（:124-127）token 已存在却未被引用。影响：token
  改值时该字段不跟（漂移风险，纯维护性）。建议：由 icon 宽 + gap 推导。
- [P2] `Main.qml:565-583` — 搜索框右端的"听写"图标是纯手绘装饰件，不可交互、
  无任何行为，视觉上却伪装成 macOS 原生的功能性听写按钮。影响：虚假可供性。
  建议：删除，或 `需人工判定` 是否按参考实现保留为装饰。

### 本轮已排除
- 线索 20（`CalendarMonthView.qml:97`）、线索 14/15（MonthView 字号与 opacity）：
  属 R5 区域，本轮未读该文件，不做判定。
- `Main.qml:1-1400` 内未发现 <10pt 字号（rowFontSize 15 / categoryFontSize 13 /
  dateNavTextSize 13 / GlassButton 16 / glyph 12px 为图形非文本）。
- `buildItemsByDate`（:246, 1160+）的全量重建是注释写明的意图（一次失效一次
  扫描，格子只查 key），不判为性能问题；年视图 504 次 `itemsForDate`（线索 19）
  留待 R3 按实际调用形态判定。
