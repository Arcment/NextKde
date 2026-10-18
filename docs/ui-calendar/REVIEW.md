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

## R2 — `Main.qml:1400-2500`：工具栏、搜索、侧栏、迷你月（2026-10-18）

### Findings
- [P1] `Main.qml:1724-1751` — 自绘窗口圆点 delegate 是 14×14px `Rectangle` +
  裸 `MouseArea`：命中区 14×14 < HIG 最小 20×20；无 `Accessible.name`/role，
  `MouseArea` 不可键盘聚焦。影响：VoiceOver 与 Full Keyboard Access 均无法关闭/
  最小化窗口。建议：包一层 ≥20×20 的 `AbstractButton`，补 Accessible.name
  （"Close"/"Minimize"/"Zoom"），给 hover 提亮反馈。
- [P1] `Main.qml:1582-1586` + `:1570-1591` — 状态条由 `statusTimer` 3500ms 定时
  清空（HIG：尽量少用定时自动消失的界面元素），且 `showStatus` 无任何
  Accessible 播报（无 `Accessible.announcement`/live region）。影响："Event
  removed" 等破坏性操作的确认信息 3.5s 后无声消失，屏幕阅读器用户既听不到也
  看不到结果。建议：至少对状态文本挂 `Accessible.announcement`（或 role=Alert）；
  消失时长可配或 hover 时暂停。
- [P1] `Main.qml:1995-2013`（toolbarSearch 内 `TextInput`）— 搜索输入框无
  `Accessible.name`；占位符是独立 `Label`，VoiceOver 聚焦时读不出"Search"用途。
  影响：线索 18 成立。建议：`Accessible.name: qsTr("Search")`，或把占位符文本
  也设为 input 的 name。
- [P2] `Main.qml:1724-1751` — 圆点排列左→右为 green(max)/yellow(min)/red(close)，
  与 macOS 红黄绿惯例（close 在左）相反，close 落在最右。需人工判定：是否刻意
  按 Linux 摆位；作为 macOS 复刻与肌肉记忆冲突。建议：若保持右侧摆位，至少
  恢复 红/黄/绿 顺序。
- [P2] `Main.qml:2350` — 迷你月非本月日期整格 `opacity: 0.42`。实测合成
  （alpha 0.42 over 平面色）后数字对比度：浅色 `#000`→rgb(132) on `#E4E4E4` =
  **2.93:1**，深色 `#F2F2F2`→rgb(125) on `#282828` = 3.57:1；11px 文本 <4.5，
  浅色腿连 3:1 都不到。相邻月变暗是日历惯例，但建议浅色腿 alpha ≥0.5 或改用
  显式 `labelSecondary` 色而非透明度。
- [P2] `Main.qml:2374-2383` — 迷你月 todayRed `#E5484D` 圆盘上的 11px DemiBold
  白字对比 3.91:1，selectionDisc `#8E8E93` 白字 3.26:1，均 < 4.5（小号文本）。
  形状通道（实心圆盘）已传达状态，故降为打磨：加深盘色或提高字重/字号。
- [P2] `Main.qml:2127` vs `:2374` — "今天"色不一致（线索 4 的 R2 部分）：侧栏
  Today 行 marker 用 `tahoe.accent`，迷你月 today 圆盘用 `AppTheme.todayRed`，
  年视图/月视图还有第三套（R3/R5 复核）。同一语义三种颜色，违反"别用同一个
  颜色表达两件事"的对称律。建议：统一收敛到 todayRed。
- [P2] `Main.qml:1524-1538` — `headerTitle()` 周区间拼装 `"MMM d" + " – " +
  "d, yyyy"` 的**元素顺序与分隔符硬编码**（线索 17 成立，但比线索更细）：
  `AppTheme.formatDate` 本身走 `uiLocale`（AppTheme.qml:10-13），但 zh 等语序
  不同的 locale 会得到 "10月12 – 18, 2026" 这类非本地结构。建议：周区间整体
  走 locale 模板（如 `I18n.trPattern`），或至少对 zh 腿给出专案格式。
- [P2] `Main.qml:1668-1670` — 快捷键只有 Ctrl+1..3（线索 8 成立）；第 4 段
  Year（viewIndex=3，:1830 注释自认）无快捷键。建议：补 Ctrl+4，并在菜单/
  tooltip 中可见。
- [P2] `Main.qml:675-677, 802` + `:248` — GlassSurface hover/press/镜片提亮动画
  时长来自 `tahoe.pressDuration = 150`（硬编码常量），不在
  `AppTheme.motionFast/motionNormal`（AppTheme.qml:179-181，reduceMotion 时归 0）
  守卫链内。影响：Reduce Motion 开启时这三处仍做 150ms 动画（opacity 类，HIG
  允许淡入淡出，故降为 P2）。建议：`pressDuration` 也随 reduceMotion 归 0。
- [P2] `Main.qml:1424-1432` — `listColor()` 内 `Qt.darker(color, 1.0)` 是恒等
  变换（factor 1.0 = 原色），疑似残留的死操作；且 id 未命中时回落 `accent`，
  未知列表会与强调色同色。建议：删掉 darker 包装；回落色改为按 id 哈希的
  稳定色板。

### 本轮已排除
- 线索 13 的 1955/2104 两处（搜索框、侧栏宽度动画）：**不成立为违规** —
  时长走 `AppTheme.motionFast/motionNormal`，`AppTheme.qml:179-181` 在
  reduceMotion 时将两 token 归 0，动画被隐式禁用。守卫缺口只在上表
  `pressDuration` 一条。
- 迷你月单元命中区 21×21 ≥ 20 最小值，达标不写 finding；月标题/箭头 28×28 达标。
- `SidebarRow`/`CategoryRow` 内部（:280-340）本轮已看过 Accessible 结构，
  CategoryRow 可勾选态、nested 的 "Show completed" 有显式 Accessible.name，
  不重复 R1 的 finding。
