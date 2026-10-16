# LEDGER — 天气 app 复刻 Apple 天气

参考集：`.loop/refs/ref-macos-weather.png`(主) / `ref-ipad-weather.png`(补)
参考实测色（814×498 主图采样）：天空 `#2961a7→#1469bc→#538ec9`（上→下，含云照片）；Conditions 卡 `#0057b2`；hero 文本 `#ffffff`；10天条渐变 青→黄→橙。

## 已改
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
1. 天气/小时图标仍是文本字符（☀︎☁︎🌙）—— 参考是彩色绘制图标（黄日/白云/蓝雨），日间符号偏黄 `#ffd257` 系。
2. hero 温度占屏比仍小于参考（参考约屏高 1/5；现在 92px ≈ 1/8）。
3. 侧栏卡细节：参考卡里城市名字重更粗、卡间距/圆角接近但卡内字号可再压一档；"● 地点"小标题与搜索框形态和参考不符（参考是圆角胶囊搜索框、无小标题）。
4. 天空是纯渐变，参考为带云照片质感 —— 渐变近似已接受，若要求更高需程序化云纹理。
5. 顶部工具栏（更新时间/设置/刷新位置形态）与参考右上搜索框布局不符。
6. Conditions 卡无温度走势曲线。
7. 缺卡片：空气质量 / 风罗盘 / 月相 / 日落 / UV —— 受后端字段限制，见"外推待确认"。

## 外推待确认
- summary 字段形态（tempHigh/tempLow 命名、无 summary 时卡的 `—` 回退）为本轮外推，无参考约束；如要改字段名需同步 Go/schema/QML 三处。
- 卡高 96px 系按 4 行文字内容反推（参考 210px 侧栏里约 67px 高、四行同样结构），比例略偏高但文字不重叠。
- ~~8px/20px 组合~~ **已由用户裁定**：窗口圆角本身 = 8px（`KosApplicationWindow.qml:20` 32→8，本轮已改），内容区留 20px 作为未来 KWin 裁剪的保险。
- 深色全窗 / hover / 按下 / 选中 / 空状态 / 窄窗 / 右键菜单 / 晴雨雷雪全窗背景：**无额外参考图**
  （搜索引擎不可达、Apple 手册页 JS 渲染）。按 HIG 规格 + 现有参考图外推，见 `.loop/refs/NOTES.md`。
- 深色模式的天空背景取值（参考图只有浅色）：现用深夜蓝 `#0c1a33→#274d79`。
- 夜间玻璃卡 fill 0.16 是否太透（实测 21:00 夜空下卡片略发灰蓝）。
- hover / 选中 / 按下的具体取值（参考图都是静态态）。
