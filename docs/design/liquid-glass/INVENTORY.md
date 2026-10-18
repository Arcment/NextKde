# 液态玻璃组件盘点（第 0 批 R1）

> 来源分支（只读盘点，未 checkout）：
> - `origin/codex/calendar-ui-iter-20261016`（下称 **cal**）
> - `origin/claude/weather-app`（下称 **wx**）
> - `origin/codex/liquid-animation-experiment`（下称 **liq**）
> - 当前工作树 `codex/liquid-glass-foundation`（下称 **WT**）
>
> 四个来源是同一仓库的不同分支；`apps/listenfree`、`apps/lockscreen`、`apps/sddm`
> 在四个来源中内容一致（GlassSurface.qml 逐行比对一致），差异集中在
> `shell/`（仅 WT 全面展开）、`apps/calendar`（cal）、`apps/weather`（wx）、
> `apps/settings`（liq 的动效实验）。未逐项 diff 的部分在文中标注。

## 1. 总矩阵表

| 组件 | 来源 | 实现方式 | 关键参数 | 主题适配 | 已知不一致 |
|---|---|---|---|---|---|
| **LiquidGlassPanel** | WT `shell/desktop/modules/common/LiquidGlassPanel.qml:33-131` | Item(不画) + SDF 蒙版子项；默认走 KWin Glass 合成器模糊，QML fallback | `radius:0` + `cornerExponent:2.0`(可连续圆角)、`useKwinEffect:true`、`frostOnly:false`、`blurOverrideEnabled:false`、`compositorRevealDuration:320`、`baseColor:rgba(0,0,0,0.1)`、`material:"clear/regular/thick"` | `fallbackEnabled: AppearanceTokens.surface.paintInQml`（:111） | 与 LiquidGlassSurface 职责相邻但方向相反（见 §2 冲突①） |
| **LiquidGlassSurface** | WT `shell/desktop/modules/common/LiquidGlassSurface.qml:14-62,182` | 纯 QML 收尾层（tint+反射+环境光），叠在合成器模糊之上 | `baseColor:rgba(0,0,0,0.1)`、`material` 三档（clear 的 `materialOpacityScale:0.58`、`materialReflectionScale:0.62`）、`ambientTransitionDuration:2600`、`blurStrength:AppearanceConfigService.effectiveDockBlur` | `AppearanceTokens.surface.usesTonalRoles`（:20） | 只服务「已有合成器模糊」的宿主，半径为 0 时依赖蒙版 |
| **GlassSurface**（listenfree） | 四源一致：`apps/listenfree/music_player_desktop/components/GlassSurface.qml:8-30` | 纯 QML Rectangle + `layer.effect: MultiEffect` 阴影 + 可选 backdrop 模糊 | `cornerRadius:24`、`tint:AppTheme.cardStrong`、`tintStrength:.16`、`exclusionStrength:.04`、`noiseStrength:.01`、`backdropBlur:32`、`shadowOpacity:0.16`、`shadowOffset:5/7`、MultiEffect `blurMax:16, blur:.6` | AppTheme（单例色板），无 wallpaper 桥 | 同名组件在 cal `apps/calendar/qml/Main.qml:672` 被重新实现为局部 `component GlassSurface: Rectangle`，参数体系完全不同（冲突②） |
| **KosSurface** | WT `shell/Kos/Ui/foundation/KosSurface.qml:6-16,29,45` | 纯 Rectangle 三层：外阴影(r+3)、描边(r+1)、内填充(r) | `radius:AppTheme.mediumRadius`、`strokeWidth:1`、`elevation:0.5`、`showInnerHighlight:true`、modernDesign 时 elevation×0.38 | AppTheme.cardSurface/border | 与 Liquid* 家族零共享：无蒙版、无合成器协作（冲突③） |
| **KosFloatPanel** | WT `shell/desktop/modules/common/KosFloatPanel.qml:45-76` | layer-shell 面板，内部包 LiquidGlassPanel；modal 背板 | `radius:32`、`cornerExponent:AppearanceTokens.shape.cornerExponent`、`shadowOffsetX/Y:12/16`、`shadowSoftness:18`、`shadowColor:rgba(.5,.5,.5,.30)`、`materialDepth:1`、`blurStrength:0.3`、`fixedScrimOpacity:0.8`、`contentPadding:20` | AppearanceTokens.surface.pick(surfaceContainer, black/white)（:76） | radius 32 与 GlassSurface 24、MaterialCardSurface 16 三种面板圆角并存（冲突④） |
| **MaterialCardSurface** | WT `shell/desktop/modules/common/MaterialCardSurface.qml:24-47` | Rectangle 填充 + Region 模糊（矩形或花形） | `radius:16`、`fillColor:"transparent"`、`flowerLobes:12`、`flowerAmplitude:0.075` | 上色交给宿主 | 仅供时钟等少数场景；与 ControlCenterGlass 不同配方 |
| **ControlCenterGlass** | WT `shell/desktop/modules/bar/ControlCenterGlass.qml:9-21` | LiquidGlassPanel 的「一份配方」封装 | `material:"regular"`、`materialDepth:0`、`blurOverrideEnabled:true`、`blurStrength:0`(→KWin level 1)、`scrimLevel:"balanced"`、`ambientStrength:0.35×ambientMultiplier` | ThemeService.backgroundColor + WallpaperColorSource.primary/secondary | 是正确的收敛样板；其余 bar 面板是否全部走它未逐个核对（标注：未逐项核对） |
| **KWin glass-effect** | WT `kwin/glass-effect/src/blur.cpp`（2612 行）、`settings.h:19,69-83` | KWin effect：模糊 + 折射 + SurfaceShape 协议 v4 | `blurStrength`(全局 1..15)、`RefractionSettings{refractionStrength, refractionNormalPow, refractionRGBFringing, refractionOffsetStrength}`；**具体默认值未找到**（settings.h 只声明字段） | 深浅由 QML 侧 scrim 参数下发 | C 层折射已存在但 QML 侧默认 `useKwinEffect` 才启用 |
| **RoundedBlurRegion** | WT `shell/desktop/modules/common/RoundedBlurRegion.qml:7-58` | Quickshell `Region`：2 矩形 + 4 椭圆拼圆角 | `radius` 默认 `min(w,h)/2`，整数化取整 | 无 | 与 KosRoundedBlurRegion 是父子关系，非冲突 |
| **KosRoundedBlurRegion** | WT `shell/desktop/modules/common/KosRoundedBlurRegion.qml:12-97` | RoundedBlurRegion + `SurfaceShape`(radius/exponent) + scrim + per-shape blur | `exponent:2.0`、`scrimTint 0/1`、`scrimCap`、`scrimDecay`、`blurLevel 1..15`(协议 v4)、`revealDuration:320`、`materialOpacity` | scrim 黑/白由调用方定 | — |
| **FlowerBlurRegion** | WT `shell/desktop/modules/common/FlowerBlurRegion.qml:31-52` | Region 花形轮廓（多行带状矩形拼合） | `lobes:12`、`amplitude:0.075`、`sliceCount:32`、`inset:18` | 无 | — |
| **Weather 表面** | wx `apps/weather/qml/Main.qml:39-48,454,1330,1362` | Rectangle（圆角圆片/tileRadius）+ MultiEffect | 多处内联 radius、两处 MultiEffect；具体 tint 公式未逐段抄录（**抽查级**） | 局部配色 | 与 GlassSurface 并存，未走统一组件 |
| **Calendar 内联 GlassSurface** | cal `apps/calendar/qml/Main.qml:672,776,891-958` | 局部 `component GlassSurface: Rectangle` + MultiEffect（lensBlur blurMax 48，:243） | `lensBlur` 为 MultiEffect 归一化柔化量 blurMax 48（:243） | 局部 neutral 调色板（「无蓝灰 tint」，EventDetailsPopover.qml:11） | 与 listenfree GlassSurface 同名不同物（冲突②） |
| **EventDetailsPopover** | cal `apps/calendar/qml/EventDetailsPopover.qml:15-69` | `Popup` + 应用内自绘阴影（画进 `shadowInset` 边距） | `shadowInset:14`、`width:340+2×14`、`padding:14+14`、`CloseOnPressOutside|Escape` | `AppTheme.popoverBorder`（:23） | 自绘阴影 vs shell 侧 KosCardShadow/合成器阴影（冲突⑤） |

## 2. 分类结论

### 玻璃表面

**重复实现**
1. 同名 `GlassSurface` 有两份互不相干的实现：listenfree 版（四源一致，`GlassSurface.qml:8-30`）与 calendar 版局部组件（`apps/calendar/qml/Main.qml:672`）。
2. 「圆角模糊区域」两层实现：几何 Region（`RoundedBlurRegion.qml`）与其增强版（`KosRoundedBlurRegion.qml`，加 SurfaceShape/scrim/blurLevel）——后者是有意封装，前者仍是独立入口，宿主可能直接用底层版漏掉形状声明。
3. QML 端玻璃收尾有两套：`LiquidGlassSurface.qml`（叠合成器模糊）与 listenfree `GlassSurface.qml`（MultiEffect + backdropBlur 32），参数词汇完全不同（material 档位 vs tintStrength/exclusionStrength/noiseStrength）。

**互相冲突**
- ① `LiquidGlassPanel`（宿主不画、蒙版切割、默认走 KWin）与 `LiquidGlassSurface`（纯 QML 收尾）对 radius 的约定相反：前者 radius 必须 0（`LiquidGlassPanel.qml:33`），后者要求 radius 跟随或显式 `cornerInset`（`LiquidGlassSurface.qml:9-14`）。
- ② 面板圆角三标并存：32（KosFloatPanel:45）/ 24（GlassSurface:10）/ 16（MaterialCardSurface:25）。
- ③ 阴影三套：listenfree GlassSurface 用 MultiEffect blurMax 16（:30）；KosFloatPanel 用 KosCardShadow 自绘外阴影（:47-54）；calendar EventDetailsPopover 用 padding 内自绘（:64-69）。
- ④ KWin C 层折射参数已具备（`settings.h:69-72`），但 QML 组件层没有「何时开折射」的契约，仅 `useKwinEffect` 布尔。

### 弹层

**重复实现**
1. 弹层运动：`PopupMotion.qml`（WT，进度驱动的 mapped/interactive 契约，:5-71）是收敛实现；但 `AnimatedPopupWindow.qml`、`KosFloatPanel.qml` 各自的显隐路径是否都走它，未逐个核对（标注：未逐项核对）。
2. 弹层宿主三种：Quickshell PopupWindow 系（bar 面板）、`KosFloatPanel`（layer-shell 单表面）、QML `Popup`（calendar）。
3. 阴影/边距方案重复：EventDetailsPopover 的 shadowInset 自绘与 KosFloatPanel 的 KosCardShadow 语义重叠。

**互相冲突**
- ① 显隐模型：PopupMotion 要求「保持 mapped + interactive 门控」（`PopupMotion.qml:6-8`）；QML Popup 用 closePolicy 原生开关——两套生命周期无统一契约。
- ② 弹层持续时间：`AppearanceTokens.motion.popupOpenDuration:150 / popupCloseDuration:140`（`AppearanceTokens.qml:568-569`）对 shell 生效；calendar/weather 弹层无动画参数（未找到）。
- ③ 背板 scrim：shell 侧有 compositor scrim（`KosRoundedBlurRegion.qml:78-81`，tint/cap/decay）+ `popupScrimLevel:"balanced"`（`AppearanceTokens.qml:453`）；KosFloatPanel 另有 QML 背板 `backdropTint:black`+`backdropOpacity`（:27-38）。同一弹层可能双重变暗。

### 控件

**重复实现**
1. 控件双家族并行：`shell/Kos/Ui/controls/Liquid*.qml`（LiquidGlassButton/LiquidSegmentedControl/LiquidTextField/LiquidSelect/LiquidSlider/LiquidSwitch）与 `shell/Kos/Ui/foundation/Kos*.qml`（KosButton/KosToolButton/KosTextField/KosComboBox/KosCheckBox/KosDialog…共 30 文件，见 `shell/Kos/Ui/foundation/`）。liquid 版自带玻璃高光，foundation 版走 KosSurface。
2. Segmented 两份：`LiquidSegmentedControl.qml`（:87 materialForm 半径 `height/2`，否则 `height*0.38`）与 listenfree `SegmentedTabBar.qml`（`apps/listenfree/music_player_desktop/components/SegmentedTabBar.qml`，参数未逐项抄录——抽查级）。
3. TextField 两份：`LiquidTextField.qml` 与 `KosTextField.qml`；ComboBox：`LiquidSelect.qml` vs `KosComboBox.qml` vs `apps/music/qml/MusicComboBox.qml`（三份）。
4. 按钮内按压/悬停液态参数各自硬编码：`LiquidGlassButton.qml:25` `_expansion = pressed?1.0:(hovered?0.3:0)`，无共享 motion token。

**互相冲突**
- ① 圆角体系：LiquidSegmentedControl 用比例（0.38/0.42/0.34，:87,121,218）；KosToolButton 用 `Math.min(AppTheme.smallRadius, height/2)`（:33）；AppearanceTokens.shape 用 ratio（`tokens.isWindows12 ? 0.20 : 0.50`，:414）。三种口径。
- ② KosSurface（AppTheme 纯色板）与 AppearanceTokens（SystemPalette + wallpaper 桥 + Material/Monet）是两套颜色入口（`KosSurface.qml:6-7` vs `AppearanceTokens.qml:17-94`）。

### 动效

**现状**
1. 集中 token：`AppearanceTokens.motion`（WT `AppearanceTokens.qml:552-571`）：`fastDuration 120/normalDuration 180/slowDuration 260`（windows12 分支，:553-557）、`popupOpenDuration:150`、`popupCloseDuration:140`、`popupStartScale:0.96`、`popupAnchorOffset:20`、`popupAnimatesOnShow:true`。
2. `PopupMotion`（:9-11）open=OutCubic / close=InCubic，时长按剩余进度等比缩放（`animateTo`，:46-57）。
3. `PageMotion.qml` 存在于 WT `shell/desktop/modules/common/PageMotion.qml`，但 grep `property|duration|easing` 无命中——内容未能读取结论，**待人工核对**。
4. `reduceMotion`：仅 `apps/common/src/ApplicationPreferences.cpp:15,105-108,172,219`（键 `Appearance/reduceMotion`，默认 false，导出为 env "1"/"0"）及测试消费；**shell QML 侧未找到任何读取点**（`git grep reduceMotion HEAD -- shell` 无命中）→ 玻璃动效目前不受 reduceMotion 约束。
5. 环境光过渡 `ambientTransitionDuration:2600` 硬编码于 `LiquidGlassSurface.qml:45` 与 `LiquidGlassPanel.qml:119`，不进 motion token。

## 3. 未找到 / 待人工核对清单

- kwin glass-effect 各参数的**默认值**（settings.h 只有字段声明；blur.cpp 2612 行未逐段读）。
- `shell/desktop/modules/common/PageMotion.qml` 的内容（grep 无命中，异常）。
- bar 各面板（NetworkPanel/BatteryPanel/BluetoothPanel 等）是否统一走 ControlCenterGlass 配方——只确认了 ControlCenterGlass 本身。
- liq 分支相对其他分支的动效实验差异（集中在 `apps/settings/src/WindowSettings.cpp`、`main.qml`、`tests/widgets/tst_widgets.qml`，未逐项核对）。
- weather `apps/weather/qml/Main.qml` 的具体 tint/模糊配方（仅抽查 MultiEffect 出现位置 :1330,:1362）。
- `shell/desktop/modules/common/LiquidGlassPanel.qml` 的 scrim 实现细节（`scrimEnabled/scrimLevel` 在 :86 一带声明，下发路径未读到）。
