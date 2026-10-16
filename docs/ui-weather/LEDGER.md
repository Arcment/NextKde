# LEDGER — 天气 app 复刻 Apple 天气

参考集：`.loop/refs/ref-macos-weather.png`(主) / `ref-ipad-weather.png`(补)
参考实测色（814×498 主图采样）：天空 `#2961a7→#1469bc→#538ec9`（上→下，含云照片）；Conditions 卡 `#0057b2`；hero 文本 `#ffffff`；10天条渐变 青→黄→橙。

## 已改
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
1. 顶部工具栏（更新时间/设置/刷新位置形态）与参考布局不符（参考主区顶部无工具栏；Apple 的侧栏开关在侧栏右上角，见 tile-sidebar 顶部）。
2. 天空是纯渐变，参考为带云照片质感 —— 渐变近似已接受，若要求更高需程序化云纹理。
3. Conditions 卡无温度走势曲线。
4. WeatherIcon code 1/2 夜间也画太阳+云（drawSun 不分昼夜），夜间应画月+云。
5. 缺卡片：空气质量 / 风罗盘 / 月相 / 日落 / UV —— 受后端字段限制，见"外推待确认"。
6. 侧栏只有 1 个城市时卡下方大片空白（参考有多城填满）；无数据可解，仅记录。

## 外推待确认
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
（无——WeatherIcon.qml 已接入并记录于"已改"。）
