# LEDGER — 天气 app 复刻 Apple 天气

参考集：`.loop/refs/ref-macos-weather.png`(主) / `ref-ipad-weather.png`(补)
参考实测色（814×498 主图采样）：天空 `#2961a7→#1469bc→#538ec9`（上→下，含云照片）；Conditions 卡 `#0057b2`；hero 文本 `#ffffff`；10天条渐变 青→黄→橙。

## 已改
- **阶段三动效 B.6：逐小时卡列表入场交错（本轮，前端）**：`apps/weather/qml/Main.qml:1007` delegate 加 `required property int index`；:1011-1012 入场初态 `opacity: 0` + `transform: Translate { id: entranceShift; y: 14 }`；:1013-1021 `Component.onCompleted`（reduceMotion 时直接置终态不动画，否则 `entranceAnim.restart()`）；:1023-1029 `SequentialAnimation`：`PauseAnimation 40ms×index` 交错 + `NumberAnimation` opacity 0→1 / Translate y 14→0，各 260ms OutCubic（单卡落在 HIG 120–300ms 内）。数据异步到达时 Repeater 才建 delegate，故入场恰在数据到达时播一次；每小时刷新重建 delegate 会重放，频率符合 HIG"避免高频交互动效"。
  **帧差证据**（活实例 + spectacle 连拍；数据即时到达使首轮动画早于 spectacle 首帧，故按 round 15 先例加 TEMP Timer（每卡随机 1800-3400ms 间隔复位初态重触发）取证后已删）：动效区（逐小时条带 y525-665）相邻帧 MAE **14.06 / 7.96 / 1.88 / 14.80**，对照静止区（"7 天"标签带 y688-716）**全部 0.0000**；逐卡分块 MAE（f0→f1）card2=11.6 / card3=28.1 / card5=38.9 / card6=38.9、其余 0——不同卡处于不同相位即交错生效；裁片目视：右端卡半透明+下移中、左端已定。**终态二进制**（TEMP 已删）：4 次重启×5 对相邻帧逐小时区 MAE 全 0.0000（动画收尾干净、无残留运动）；`--screenshot` 650ms 帧恰好抓到动画中段（左卡已定、最右 06:00 卡半透明下移中，截图 1792163552），与 TEMP 证据互证。测试 6/6 绿、go test ok。
- **阶段三风格 A：侧栏滚动边缘效果（scroll edge effect，本轮，前端）**：`apps/weather/qml/Main.qml:6` 加 `import QtQuick.Effects`；:484-672 `savedLocations` ListView 包进 wrapper `savedLocationsWrapper`（4 个 Layout attached 属性移到 wrapper，ListView `anchors.fill: parent`，其余不动）；:643-671 新增 `scrollEdgeTop` 条带（列表顶 26px、`visible: savedLocations.contentY > 0.5`、clip）= **兄弟节点** MultiEffect（source: savedLocations，`blurEnabled` blurMax 32 / blur 1.0 / saturation 0.2，整列表模糊图与实列表对齐后被 clip 到顶条带）+ 顶部渐隐 Rectangle（`AppTheme.sidebar` α0.9→透明 渐变，即 HIG "降不透明度"）。不滚动时完全不渲染。
  **实测**（截图 1792162746 为 TEMP 脚手架 `visible:true` 强制显示条带时的渲染；截图 1792162785 为最终二进制静止态）：条带区卡片顶部被模糊+渐隐——y96 `#c2c9d3`（顶缘侧栏色）→ y112 `#465775`（过渡）→ y120 以下清晰卡面 `#102547`，过渡平滑无硬边；最终二进制静止态同区域 y96 起即清晰卡面 `#0c1a33`，证明 `contentY` 门控生效、静止时零渲染。测试 6/6 绿、go test ok。
  **验证方式说明**：contentY 无法在截图模式强制（TEMP `Component.onCompleted: contentY=60` 被启动时序重置，卡片仍在列表顶 y=95），故分两步取证——a) TEMP 强制 visible 验证条带渲染本身（模糊+渐隐+位置正确）；b) 移除 TEMP 后静止态验证门控。滚动态实拍未见（见外推待确认）。
- **阶段三风格 A：功能层单位/动作按钮启用 Liquid Glass（本轮，前端）**：`apps/weather/qml/Main.qml:26-54` 新增 inline component `GlassCircleBg`（正圆 `radius:width/2`、选中 fill 白@0.27 / hover 白@0.14 / 常态 transparent、fill 时 1px 白@0.22~0.30 细描边 + 内嵌圆形 sheen 白0.28@0→0@0.22，同 KosSidebarToggle 一族）；⚙(650)/↻(671) 常亮玻璃盘（白@0.14+描边+sheen）、°C(700)/°F(726) 采用参考实测的"仅选中段玻璃圆盘"分段形态（未选中无盘纯白字），实例覆盖 background/contentItem（白字），补 `leftPadding/rightPadding:0`（:699-700/:727-728，否则 34px 圆内 Label 被 16px padding 裁成 2px 文字不可见——第一版截图实测踩中）。**实测**（截图 1792162252，DPR1）：侧栏面 `#6c83a1` → °C 盘 `#94a5bb` Δ(+40,+34,+26)=白@0.27（与参考 knob 白@0.27 精确一致）；⚙/↻ 盘 `#8095ad` Δ(+20,+18,+12)=白@0.14；°C 盘顶缘 rim `#afbdcc` Δ(+67,+58,+43) specular 可见、无硬边。参考依据：ref-main Conditions 卡头圆钮 fill `#5f86c0`/卡底 `#1b5aa9` = 白@0.27，仅选中段有盘。注：这 4 颗按钮实际位于**侧栏底栏**（非主区顶栏），从"仍差 1"移出。
- **阶段三风格 A：侧栏右上开关钮启用 Liquid Glass specular 顶缘+细描边（本轮，前端）**：`apps/weather/qml/Main.qml:1136-1152` KosSidebarToggle 实例的 `background`——fill 保持白 0.14、`border.color` 0.20→0.22（与搜索胶囊描边一族）、内嵌圆形自裁顶部 sheen（`anchors.margins:1`、`radius:width/2`、Gradient 白 0.28@0 → 0@0.22），只改天气这一个实例。**第一版 specular 用全宽 1px 直线在圆外两端溢出**（截图 1792161513 实测 y13 行 x197-214 越出圆弧），改为圆形 sheen 后消除。
  **实测**（截图 1792161631，本轮二进制）：侧栏面 `#5d687b`(93,104,123) → 填充 `#747c8d`(116,124,141)（Δ≈+23，参考 fill−bg≈+25 吻合）→ 顶缘 `#8c92a0`(140,146,160)（Δ(+24,+22,+19)，参考 rim Δ(+19~23) 同量级）；填充上下平（Δ≈0，参考 Δ≈2 平填充）；目视放大 `/tmp/my-toggle2.png`：玻璃圆钮、亮顶缘、无溢出、无硬边。开关钮部分从"仍差 1"移出。
- **阶段三风格 A：侧栏搜索胶囊启用 Liquid Glass specular 高光+细描边（本轮，前端）**：`apps/weather/qml/Main.qml:381-383` locationField 实例加 `materialForm: false` + `liquidFinish: true` + `liquidStrength: 0.2`（LiquidTextField `shared/qml/controls/LiquidTextField.qml` 自带 glass 词汇：上缘 specular 细亮线/内部 sheen/四周白描边/下缘暗边，仅在 `liquidFinish && !materialForm` 绘制；只改天气这一个实例，KosTextField 默认值不动，todo/settings 不受影响）。强度经两轮实测校准：0.45 时 rim 峰值 Δ+51、填充上亮下暗 Δ23（参考为平填充 Δ3）过强 → 降到 0.2。**终态实测**（截图 1792161254，DPR1）：侧栏面 `#5d687b` → 填充 `#808a99`(顶)~`#808998`(底，近平) → rim 峰值 y=55 `#c5c9d0`、1px 白 0.19 描边环绕；ref-main 胶囊实测（降采样 2x）：外底 `#2b4469`/填充 `#3e5e8c`(平)/上缘 `#5174a7`/下缘 `#486898`——形态对齐（平填充+亮上缘+细描边）；rim 绝对峰值我的更锐（DPR1 vs 参考降采样抹平），属已记录差异。截图 `/tmp/my-capsule2.png` 目视：玻璃胶囊、亮顶缘、无脏阴影、无硬边。
- **阶段三动效 B.1（第 1 条）：夜间晴天星星闪烁（本轮，前端）**：`apps/weather/qml/Main.qml:24-27` 新增 `nightClearSky`（夜间+code 0/1）；:43-67 `mulberry32(20261016)` 种子 PRNG 生成 48 星 `starField`（**坐标确定性**：xRatio 均匀、yRatio=pow(r,1.3)*0.75 偏上部、直径 1.2-2.8px、baseOpacity 0.35-0.95、twinkle 2440-7170ms，落在 HIG 环境循环 2-12s 内）；:310-352 `starFieldLayer`（天空渐变之后、RowLayout 之前，visible 跟随 nightClearSky，clip），delegate 白色圆形 Rectangle + `SequentialAnimation on opacity`：随机相位 PauseAnimation（Math.random()*twinkleMs，**每次启动不同**）→ base→base*0.35→base 两段 NumberAnimation（各 twinkleMs/2，InOutSine，Infinite），`running: nightClearSky && !AppTheme.reduceMotion`（reduce-motion 停）。
  **帧差证据**（活实例 spectacle 连拍，flatten alpha 后）：400ms 间隔 MAE——星区 starL `0.0114/0.0151/0.0094`、starR `0.0176/0.0164/0.0112`，对照 2s 间隔变化像素：星区 48-54 个（maxdiff 122-128）、静止逐小时卡行 **0**（完全静止）、侧栏噪声底 21-24 个稀疏点（maxdiff ≤49）。星区信号 ≈ 噪声底 2 倍计数 / 2.5 倍峰值，判定动效生效。
  **已知限制**：`--screenshot` 模式 t=650ms 帧差≈0——数据到达→动画起步晚于抓帧（已知限制，见外推待确认）。
- **侧栏内容溢出 bug 关闭（本轮实测复核，代码沿用 iter 8/9 的 `Layout.minimumWidth: 0`+`implicitWidth: 0`，本轮零改动）**：新截图 1792160140（本轮二进制）Pillow 实测 —— 侧栏右缘 x≈223（宽 224 顶天立地）、城市卡右缘 x≈205、搜索胶囊右缘 x≈205，均在内容列 18..206（224−2×18）内，**无任何裁切**；卡内"25°/H:28° L:20°"完整。此前 list.w=236 的根因确为 ListView 隐式最小宽，已被 iter 8 的 `implicitWidth: 0` 修复。
- **开关钮几何复核通过（关闭 LEDGER 条目 2）**：截图 1792160140 实测钮体 x 193–219 / y 9–35 → 直径 ~26、距顶 ~9-10、距侧栏右缘 ~4-5，与已改值 26/10/5 吻合。
- **WeatherIcon 夜间少云画月+云（本轮，前端）**：`apps/weather/qml/WeatherIcon.qml:33-38` code 1/2 分支按 `isDay` 分派（白日 `drawSun(9,9,4.5)` / 夜间 `drawMoon(ctx, 9, 9, 4.5)`），云仍在前不变；`drawMoon` 加 `cx/cy/r` 参数（默认 12/12/6.5，code 0 夜间行为不变），打孔月牙按 `r/6.5` 比例缩放。截图 1792160140 裁片核实 02:00–05:00（夜间少云）为奶油月牙+白云，不再出现太阳。
- **侧栏开关按钮几何贴参考**（本轮，前端）：`apps/weather/qml/Main.qml:1038` Item `height: 44→root.sidebarExpanded ? 46 : 44`、:1043 `rightMargin` 展开态 `4→5`、:1045-1047 去 `verticalCenter` 改 `anchors.top + topMargin: 展开 10 / 收缩 (44-AppTheme.controlHeight)/2`（收缩态数学等价原居中）、展开态直径 `40→26`。依据 Pillow 量 ref-main（814 宽，侧栏 207）：开关圆钮直径 ~23-24px、距顶 ~9px、距侧栏右缘 ~5-6px；按本项目侧栏 224/207≈1.08 折算 → 26/10/5。截图 1792157267（本轮新二进制）核实按钮位于侧栏右上角；但右侧几何被下述侧栏溢出 bug 干扰，**溢出修复后需复核一次**。
- **侧栏城市卡高度/间距/圆角贴参考**（本轮，前端）：`apps/weather/qml/Main.qml:396` 卡 `implicitHeight: 96→74`（tile-sidebar 实测卡高 ~148-152px/2.1x ≈ 74）、delegate `topPadding/bottomPadding 8→5`、savedLocations `spacing: 8→6`（参考卡间隙 ~12px/2.1x ≈ 6）、卡 `radius: 14→12`（参考角曲线跨度 ~22px/2.1x ≈ 11-12）。卡内挤压故 5 个 Label 加 `lineHeight: 0.85 / ProportionalHeight`、时间行 `topMargin 2→0`、顶部行显式 `height: 30`（截图 1792153411 核实：长沙/26°/7:30PM/晴+H:29° L:20° 四行无重叠，结构与参考一致）。
- **侧栏底栏清理**（本轮，前端）：删孤立 "°" Label（原 Main.qml:526-532），`Accessible.name: qsTr("Units")` 移到 units RowLayout（:516）；"● Open-Meteo" 状态 Label 加 `Layout.topMargin: 4`。截图 1792153411 核实按钮与状态行间隔 ~20px、无重叠、无杂点。
- **侧栏顶天立地**（本轮，前端，TASK.md 用户裁定）：`shared/qml/foundation/KosSidebar.qml:12` 新增 `property bool floating: true`，:27 `radius: root.floating ? AppTheme.largeRadius : 0`；`apps/weather/qml/Main.qml:286` RowLayout `anchors.margins: 12→0`（主列 :592 自己有 `Layout.margins: 20` 不变），:294 传 `floating: false` 并删除半透明 `surfaceColor` 覆盖（改用默认实色 `AppTheme.sidebarSurface` 一族，用户裁定不用半透明玻璃）。todo 不传 floating、默认 true，观感不变。截图核实：侧栏与窗口左/上/下齐平、四角直角、无边距。
- **侧栏头部改胶囊搜索框**（本轮，前端）：删 "KOS Weather" 大标题（原 Main.qml:302-308）与 "● Locations" 小标题（原 :370-386，参考图两者皆无）；locationField 加 `Layout.preferredHeight: 30` + `cornerRadius: 15`（全圆角胶囊，参考实测高 57px/2≈28-30）+ `glassColor: 白0.22`/`outlineColor: 白0.30`/`textColor: #ffffff`/`mutedTextColor: 白0.66` + 占位 `Search`。实测截图胶囊填充 `#818998` = 白0.22 叠侧栏面（Pillow 期望 130,140,157，吻合；参考胶囊同为白~0.22 半透明叠深蓝）。
- **彩色天气图标落地**（本轮，前端）：新建 `apps/weather/qml/WeatherIcon.qml`（24×24 逻辑坐标 Canvas：黄日 `#ffd257` 带 8 根光线、奶油月 `#f7f3dc` 月牙、白云、蓝雨线 `#6cb8ff`、雪点、闪电，按 weatherCode 分派）；`apps/weather/CMakeLists.txt:18` 加入 QML_FILES；`Main.qml` 逐小时卡图标 Label（font 25px 字符）→ 26×26 WeatherIcon，10 天行图标 Label（22px 字符）→ 24×24 WeatherIcon（isDay:true）；无引用的 `conditionSymbol()` 已删。实测：夜晴渲染奶油月牙、雷暴/雨渲染云+闪电/蓝雨滴，截图确认。
- **hero 温度占屏比**（本轮，前端）：`Main.qml:676` `font.pixelSize` 92→160。实测截图温度字高 114px / 窗高 727 = **15.7%**（Pillow 量参考图 80px/498 = **16.1%**），对齐。
- **阶段二后端：每城市 summary**（本轮，全链路）：`services/data-service/weather.go` —— `WeatherLocation.Summary *WeatherLocationSummary`（time/temperature/weatherCode/isDay/tempHigh/tempLow，:46-58）；`OpenMeteoProvider.Summaries`（:403-472，一次批量多坐标请求 current+daily[0]，数组/单对象双解析、按请求序匹配±0.1°校验、≤20 城）；`Summaries` 进 `WeatherProvider` 接口（:110，fixture 可替换）；`fetchWeather` 成功后才拉 summary，失败保留旧值，选中城市的 summary 直接取自 forecast（:676-700）。schema `weather-v1.schema.json` location 加 optional `summary`（未升版本）。Go 测试 ×3（批量解析/单对象/持久化往返）。
- `shared/qml/foundation/KosSidebar.qml:11,27`：新增 `surfaceColor` 属性（默认不变）。
- `apps/weather/qml/Main.qml`：侧栏城市卡重做 —— 每城一张 96px 圆角 14 卡：城市名 17px DemiBold + 右上 30px Light 大温度 + 次行当地时间 `7:30PM`（无 summary 回退地区名）+ 底行条件文字与 `H:..° L:..°`；卡背景按该城 summary 的 weatherCode+isDay 走 `skyStopsFor` 天空渐变（`skyPalette` 更名，:19-21）；选中白边 0.55/未选 0.18；文字白 + 微阴影；无 summary 时温度显示 `—`。侧栏面改深海军蓝玻璃 `#0e2340@62%`（透出天空）。
- 验证方法：`KOS_DATA_SOCKET=/tmp/kos-weather-dev.sock XDG_STATE_HOME=/tmp/kos-weather-test-state` 隔离跑（截图模式 650ms 即退，服务来不及取数，必须先让 dev service 取到 summary 再截图）；已确认卡上真实数据显示正确。
- `apps/weather/qml/Main.qml`（skyPalette/整窗渐变 Rectangle）：整窗按 weatherCode+isDay 的三段垂直天空渐变（白日晴 `#4a74ab→#1469bc→#5a90c9`，夜/雨/雪/雷暴各有取值）；主区边距改 20px。
- `apps/weather/qml/Main.qml`（skyText/skyTextMuted + KosSurface 覆盖）：主区全部文字改白 `#ffffff`/白 66%，KosCard 改白色玻璃（fill 0.16 / 描边 0.22 / radius 14），逐小时卡 0.20；WeatherMetric 瓦片同步改白玻璃，修掉"深色文字在蓝底上不可读"。
- `apps/weather/qml/Main.qml`（hero ColumnLayout）：hero 移到主区顶部居中 —— 小字地区上标（字距 1.4）+ 34px 城市名 + 92px Light 大温度（仅 `°`）+ 条件文字 + H·L；原工具栏标题与旧 hero 行删除。
- `apps/weather/qml/Main.qml`（tempColor + daily delegate）：10 天行改为 星期｜图标+降水%｜low｜**渐变区间条**（5px 圆角、白 0.28 轨道、按本周全局 min/max 定位、`#5ac8fa→#ffd60a→#ff9f0a` 按温度插值）｜high；截图（临时 contentY，已还原）验证定位与渐变正确。
- `shared/qml/foundation/KosApplicationWindow.qml:20`：按用户裁定，`windowCornerRadius` 32→8。注意这是共享组件，其他 modernDesign 应用窗口圆角同步变为 8px。

## 仍差（按视觉冲击排序）
1. **阶段三动效项（≥每 3 轮推进 1 条，必须带帧差 MAE）**：前两轮已完成"夜间晴天星星闪烁"与"逐小时卡列表入场交错"（均见已改，含帧差证据）。剩余：雨丝下落/雪花飘移/云层漂移/雷电闪白（按天气码）、图标 Bounce/Pulse/Replace、hero 温度视差、卡片 hover 玻璃高光+抬升、温度曲线 draw-on。
2. 天空是纯渐变，参考为带云照片质感 —— 渐变近似已接受，若要求更高需程序化云纹理。
3. Conditions 卡无温度走势曲线。
4. 缺卡片：空气质量 / 风罗盘 / 月相 / 日落 / UV —— 受后端字段限制，见"外推待确认"。
5. 侧栏只有 1 个城市时卡下方大片空白（参考有多城填满）；无数据可解，仅记录。
6. 滚动边缘效果目前只做了列表**顶边**；列表底边（卡片滚出底缘）未做渐隐（参考图 Mumbai 卡在底缘为硬切，是否需要待定）。

## 外推待确认
- **入场交错的参数（40ms 交错 / 260ms OutCubic / y 偏移 14px）无参考约束**：参考图为静态，Apple 实际入场节奏不可知；取值按 HIG 120–300ms 与常见交错量级外推。另：真机首启动（数据非即时到达）时的观感未实拍——本轮取证时 service 已有缓存数据、动画早于截图工具首帧，只能靠 TEMP 重触发间接验证；真机冷启动（网络取数后入场）的实际节奏待人工复核。
- **入口动画与刷新重放**：`upcomingHours` 每次刷新重建 delegate → 逐小时卡每小时重播一次入场（整组同时错开 40ms）；是否符合预期观感待复核（HIG 不禁止低频重放，但观感待定）。
- **滚动边缘效果滚动态未实拍**：参考静态图无滚动态（卡片未滚到边下），条带参数（26px 高、blurMax 32/blur 1.0、渐隐 α0.9→0）系按 HIG「模糊并降不透明度」+ 静止态/强制显示态两张截图折算；滚动态下条带盖在"被裁切卡片的顶缘"上的实拍未取得（contentY 在截图模式强制失败，被启动时序重置），滚动手感与强度需真机滚动复核。KosKineticScroll 与 TEMP contentY 赋值的相互作用未深查（本轮时间闸）。
- **⚙/↻ 常亮玻璃盘无直接参考**：参考图只出现"选中段才有玻璃圆盘"的分段形态；动作钮（⚙/↻）采用常亮白@0.14 盘系按已验收的侧栏开关钮同族外推（动作钮无"选中"概念，需常显可点），参考图中 Apple 天气的 ⚙/↻ 在菜单栏内不可见。若后续拿到原生参考需复核。
- **搜索胶囊 rim 峰值强度**：我的 DPR1 渲染 rim 峰值 Δ+53（197 vs 填充顶 144），参考图因 2x 降采样同一条 1px 亮线被抹平到 Δ+18——绝对值不可直接比，liquidStrength=0.2 是按「填充平、暗边消失、rim 可见」折算的近似；若后续拿到原生分辨率参考需重新校准（可能还需更低）。
- **星空外观无参考**：参考图只有白天，星点密度/大小/亮度（48 颗、1.2-2.8px、0.35-0.95 透明度、偏上部 75% 高度）按 HIG"环境动效"与常见夜空观感外推，待夜间视觉复核。
- **帧差噪声底非零**：侧栏（应全静止） spectacle 连拍有 21-24 个稀疏变化点（maxdiff ≤49），疑似合成器对半透明窗口重合成的伪差；星区信号(48-54/maxdiff 122-128)仍明显高于该底，但证据不如"静止区=0"干净。逐小时卡行区域实测=0，可作对照。
- **`--screenshot` 模式 t=650ms 抓帧时动画尚未推进**（数据到达→nightClearSky 翻转→动画起步晚于抓帧），该模式下帧差验证无效；动效帧差必须用活实例+外部截屏（spectacle）验证。
- 开关钮直径 26px/距顶 10px/右边距 5px 系按「本项目侧栏 224 ÷ 参考侧栏 207 ≈ 1.08」从 ref-main 实测（23-24/9/5-6）比例折算；参考原始逻辑像素（retina 倍率）不可直接得知，若有出入以观感复核为准。
- `AppTheme.qml:159` 启动早期 modernDesign 未生效导致 sidebar 246→224 跳变：溢出裁切已随最小宽修复而消除（见已改），但启动瞬间的宽度跳变本身仍存在（是否影响其他 modernDesign 尺寸值待确认；若多处存在启动跳变，应把 modernDesign 判定提前到 AppTheme 加载前）。
- `kos-language-test` 对环境敏感：需 `EXPECTED_LANGUAGE=zh`（本机 LANG=zh_CN.UTF-8）才绿，缺省跑会 1 failed——环境问题，非代码回归（本轮已核实，`EXPECTED_LANGUAGE=zh` 下 5/5 过）。
- 侧栏从半透明玻璃改为实色 `AppTheme.sidebarSurface`（用户裁定），透出天空的质感随之消失；参考图侧栏是透天空的，若后续要兼顾需另想实色偏移方案。
- summary 字段形态（tempHigh/tempLow 命名、无 summary 时卡的 `—` 回退）为本轮外推，无参考约束；如要改字段名需同步 Go/schema/QML 三处。
- 卡高 96px ~~系按 4 行文字内容反推~~ → **本轮已改 74px**（tile 实测 ~148-152px ÷ 2.1x）。注意 tile-sidebar 缩放系数取 ~2.1x（tile 440 宽 / 参考侧栏 ~207-215 宽），若系数取 2.0 则参考卡高 ~75-76，误差 ±2px 可接受。
- 截图前**必须**给 app 本身也设 `KOS_DATA_SOCKET=/tmp/kos-weather-dev.sock XDG_STATE_HOME=/tmp/kos-weather-test-state`（不止 service）；漏设会连到生产 socket 显示 "—" 回退卡（本轮踩过一次）。
- ~~8px/20px 组合~~ **已由用户裁定**：窗口圆角本身 = 8px（`KosApplicationWindow.qml:20` 32→8，本轮已改），内容区留 20px 作为未来 KWin 裁剪的保险。
- 深色全窗 / hover / 按下 / 选中 / 空状态 / 窄窗 / 右键菜单 / 晴雨雷雪全窗背景：**无额外参考图**
  （搜索引擎不可达、Apple 手册页 JS 渲染）。按 HIG 规格 + 现有参考图外推，见 `.loop/refs/NOTES.md`。
- 深色模式的天空背景取值（参考图只有浅色）：现用深夜蓝 `#0c1a33→#274d79`。
- 夜间玻璃卡 fill 0.16 是否太透（实测 21:00 夜空下卡片略发灰蓝）。
- hover / 选中 / 按下的具体取值（参考图都是静态态）。

## 遗留物
- 无（CARDGEO console.log 已确认不在当前代码中，上轮 LEDGER 记载过时）。
