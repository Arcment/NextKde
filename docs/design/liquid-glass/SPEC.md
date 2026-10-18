# 液态玻璃规范草案 v0（第 0 批 R2）

> 本草案以同目录 `INVENTORY.md`（R1 四源盘点）为事实基础，所有 `文件:行`
> 出处沿用 R1 已核对的引用；R1 标注「未找到 / 待人工核对」的条目在本草案中
> 相应位置再次标注，不补猜。本文档为草案 v0，只定契约与 token 口径，
> 不含实现代码；最终数值以「待人工裁定项」裁定后回填。

## 1. 三层材质模型

玻璃表面分三层，逐层叠加，上层依赖下层：

| 层 | 内容 | 依赖 | 适用范围 |
|---|---|---|---|
| **A 纯 QML** | tint + 高光 + 描边 + 阴影，自绘完成 | 无（不依赖合成器） | **默认**，所有组件必须至少具备 A 层 |
| **B 窗口级 backdrop blur** | 合成器模糊（KWin blur / SurfaceShape 协议）或 QML fallback | 一个窗口/面板宿主 | **每个表面（窗口/面板）至多一次**，禁止每组件一次 |
| **C 折射** | KWin glass-effect 折射（`RefractionSettings`，`kwin/glass-effect/src/settings.h:69-72`） | B 层 + KWin effect 在跑 | **可选**，仅少量关键表面（见 §1.3 白名单） |

### 1.1 A 层契约

- A 层 = listenfree `GlassSurface.qml:8-30` 的配方词汇收敛：tint（`AppTheme.cardStrong`
  类色板色）+ `tintStrength` + 高光/反射 + 描边 + 阴影。
- 阴影统一走 MultiEffect（合并渲染，见 §4），废弃三套并存的阴影方案：
  listenfree MultiEffect（`GlassSurface.qml:30`）、KosFloatPanel 的 KosCardShadow
  自绘（`KosFloatPanel.qml:47-54`）、calendar 的 shadowInset 内绘
  （`EventDetailsPopover.qml:64-69`）。
- A 层必须在合成器模糊缺失、`fallbackEnabled` 关闭、以及 reduceMotion 场景下
  独立成立——即「无 B/C 也不破相」。

### 1.2 B 层契约

- B 层入口收敛为单一路径：shell 侧一律经 `LiquidGlassPanel`（蒙版切割，
  `LiquidGlassPanel.qml:33-131`）或其配方封装（如 `ControlCenterGlass.qml:9-21`）；
  禁止宿主直接使用底层 `RoundedBlurRegion.qml` 拼形状（R1 冲突：几何 Region
  与 `KosRoundedBlurRegion.qml` 双入口，后者才有 SurfaceShape/scrim/blurLevel）。
- `LiquidGlassPanel`（radius 必须为 0，:33）与 `LiquidGlassSurface`（radius 跟随
  或显式 cornerInset，`LiquidGlassSurface.qml:9-14`）的 radius 约定相反是历史
  包袱；草案定案：**宿主表面（窗口级）用 Panel 型（radius 0 + 蒙版），表面
  内部的收尾子层用 Surface 型（radius 跟随）**，两类不混用。
- QML fallback（`AppearanceTokens.surface.paintInQml`，`LiquidGlassPanel.qml:111`）
  时用 A 层配方替代，不引入第二个 blur region。

### 1.3 C 层契约

- C 层已具备能力（kwin glass-effect 折射参数，`settings.h:69-72`），但 QML 侧
  只有 `useKwinEffect` 布尔（`LiquidGlassPanel.qml`），无「何时开折射」契约
  （R1 冲突④）。
- 草案契约：折射由 **material 档位 + 表面白名单** 共同决定，白名单 v0：
  - 允许：中央控制面板（ControlCenter）、通知中心、锁屏时间卡片。
  - 其余表面一律 `refraction off`。白名单外的宿主即使传折射参数也忽略。
- kwin 折射参数的具体默认值 R1 未读到（`settings.h` 只有字段声明）→
  **默认值待人工裁定**，见 §5。

## 2. Token 表（v0 口径）

Token 宿主沿用 `AppearanceTokens`（`AppearanceTokens.qml`，SystemPalette +
wallpaper 桥）；`AppTheme`（KosSurface 一系，`KosSurface.qml:6-7`）作为第二套
颜色入口的现状为已知冲突（R1 控件冲突②），收敛方向见 §5 裁定项。

| Token | v0 值 | 依据 / 收敛逻辑 |
|---|---|---|
| **材质层级** `material` | `clear` / `regular` / `thick` | 沿用 `LiquidGlassPanel.qml:110` 已有词汇 |
| **圆角** | `panel: 32` / `surface: 24` / `card: 16`，均配 `cornerExponent: 2.0` | 把 R1 冲突②的三个并存值（KosFloatPanel:45 / GlassSurface:10 / MaterialCardSurface:25）收为三档显式 token，而非强行统一；exponent 沿用 `LiquidGlassPanel.qml:33` |
| **模糊半径（QML fallback）** | `backdropBlur: 32` | listenfree `GlassSurface.qml` 现值 |
| **模糊等级（KWin）** | `blurLevel 1..15`，clear→低段 / regular→中段 / thick→高段；具体映射表待裁定 | 协议 v4，`KosRoundedBlurRegion.qml`；ControlCenterGlass 现用 level 1（`ControlCenterGlass.qml`） |
| **tint（浅色主题）** | 中性基底 + `tintStrength` 档位（clear 0.10 / regular 0.16 / thick 0.24） | regular 0.16 沿用 listenfree `GlassSurface.qml:10` 现值；clear/thick 为 v0 提案值 |
| **tint（深色主题）** | 同档位结构，基底换深色；具体色值待裁定 | — |
| **高光 / 反射** | `materialOpacityScale` / `materialReflectionScale`，clear 档 0.58 / 0.62 | 沿用 `LiquidGlassSurface.qml` 现值 |
| **阴影** | 唯一实现 = MultiEffect 合并；`shadowOpacity 0.16`、`shadowOffset 5/7`、`blurMax 16` | listenfree `GlassSurface.qml:30` 现值；废 KosCardShadow 自绘与 shadowInset 内绘（R1 冲突③） |
| **描边** | `strokeWidth: 1`，颜色取主题 border 角色 | `KosSurface.qml` 现值 |
| **字阶 / 间距** | 未盘点（R1 范围外）→ **待补充盘点** | — |
| **动效-时长** | `fast 120 / normal 180 / slow 260`；popup `open 150 / close 140` | `AppearanceTokens.qml:553-557,568-569` 现值 |
| **动效-弹层姿态** | `popupStartScale 0.96`、`popupAnchorOffset 20`、`popupAnimatesOnShow true` | `AppearanceTokens.qml` 现值 |
| **动效-缓动** | open = OutCubic / close = InCubic，时长按剩余进度等比缩放 | `PopupMotion.qml:9-11,46-57` |
| **动效-液态按压** | `expansion: pressed 1.0 / hovered 0.3 / idle 0`，进 token，删除各控件硬编码 | 现 `LiquidGlassButton.qml:25` 硬编码（R1 控件重复④） |
| **环境光过渡** | `ambientTransitionDuration: 2600` 收进 motion token | 现硬编码于 `LiquidGlassSurface.qml:45`、`LiquidGlassPanel.qml:119`（R1 动效⑤） |
| **reduceMotion** | = 0：所有上述动效时长置 0、C 层折射动画关闭、环境光过渡跳过 | 现状：`apps/common/src/ApplicationPreferences.cpp:15,105-108` 已有键，shell QML 无消费点（R1 动效④）——贯通方式见 §5 |

## 3. 组件 API 草案（只写属性 / 状态 / 层级契约）

命名统一 `Glass*` 前缀，解决同名 `GlassSurface` 双实现问题（R1 冲突②）：
listenfree 版升格为全局 `GlassSurface`；calendar 局部组件（`Main.qml:672`）
废弃并迁移。所有组件均含：`material`（三档）、`reduceMotion` 行为（继承全局）。

### 3.1 GlassSurface（通用玻璃表面，A 层为主）
- 属性：`radius`（token 三档之一）、`tint`、`tintStrength`、`stroke`、`shadow`
  （MultiEffect 合并）、`backdropBlur`（仅声明，实际渲染归 B 层宿主）。
- 状态：`hovered`（高光 +0.02 提亮，走 liquid expansion token）。
- 层级契约：自身不创建 blur region；放在已挂 B 层的窗口内时自动降级为
  「tint + 高光 + 描边」薄壳。

### 3.2 GlassDialog（模态对话框）
- 属性：`radius: surface(24)`、`scrim`（单一背板变暗，见下）、`shadow`。
- 层级契约：宿主 = layer-shell 单表面（现 KosFloatPanel 路线，
  `KosFloatPanel.qml:45-76`）；背板 scrim **只允许一个来源**——R1 弹层冲突③
  （compositor scrim + QML backdropTint 双重变暗）定案为二选一，v0 选
  compositor scrim（`KosRoundedBlurRegion.qml:78-81`），QML 背板仅 fallback。

### 3.3 GlassPopover / GlassMenu（弹出层）
- 属性：`anchor`、`offset`、`radius: card(16)`、`shadowInset`（仅作布局余量，
  不再内绘阴影）。
- 状态：`opening / open / closing / closed`，运动一律走 `PopupMotion.qml:5-71`
  的 mapped/interactive 契约（R1 弹层冲突①定案：显隐统一保持 mapped +
  interactive 门控，不用 QML Popup 的 closePolicy 原生开关管理生命周期）。
- 层级契约：菜单复用 Popover 的运动与表面参数，仅内容布局不同。

### 3.4 GlassTooltip
- 属性：`radius: card(16)`、`material: thick`（小面积用最厚档）、无阴影
  （贴近期 surface）、延迟显隐走 motion token fast 档。
- 层级契约：复用 GlassPopover 的宿主与运动路径。

### 3.5 SegmentedControl
- 属性：`segments`、`currentIndex`、`radius`——定案为**统一比例制**：
  pill 形态 `height/2`、card 形态 `height*0.38`（沿用
  `LiquidSegmentedControl.qml:87` 词汇），废弃 `Math.min(AppTheme.smallRadius,
  height/2)`（`KosToolButton.qml:33`）与 `AppearanceTokens.shape` 的第三套
  ratio 口径（R1 控件冲突①）——三套收一套，具体保留哪套数值待裁定（§5）。
- 状态：`hovered / pressed / currentIndex`，滑动指示器动画走 normal 档。

### 3.6 玻璃按钮（GlassButton）
- 属性：`material`（默认 regular）、`radius`、`icon`、`text`。
- 状态：`idle / hovered / pressed / disabled`；按压液态参数读 §2 的
  expansion token，不得组件内硬编码。

### 3.7 玻璃输入框（GlassTextField）
- 属性：`placeholderText`、`text`、`material: regular`、`radius`、`error`。
- 状态：`normal / focused / error / disabled`；focus 态 = 描边强调 +
  轻微 tint 加深，不新增模糊。
- 层级契约：A 层组件，禁止自带 backdrop blur。

## 4. 性能规则

1. **禁止每个组件独立 `layer.enabled` + ShaderEffect**：玻璃收尾一律由
   GlassSurface 系组件承担；宿主如已挂 B 层，子组件不得再加效果层。
2. **阴影优先 MultiEffect 合并**：同窗口多个玻璃表面的阴影合并到一层
   MultiEffect（参照 listenfree `GlassSurface.qml:30` 现行做法），不再出现
   KosCardShadow / shadowInset 两种自绘路径（R1 冲突③）。
3. **B 层每窗口一次**：一个窗口/面板至多一个 blur region / SurfaceShape 声明；
   表面内的卡片只做 A 层薄壳。
4. **C 层仅限白名单表面**（§1.3），且 `useKwinEffect=false` 或 QML fallback 时
   自动静默降级为 B→A。
5. **圆角模糊区域统一从 `KosRoundedBlurRegion` 进**（带 SurfaceShape 声明），
   关闭 `RoundedBlurRegion` 直用入口（R1 玻璃表面重复②）。

## 5. 待人工裁定项

1. **kwin glass-effect 各参数默认值**：R1 未读到（`settings.h` 只有字段声明，
   blur.cpp 2612 行未逐段读）→ §1.3、§2 模糊等级映射表悬空。
2. **`PageMotion.qml` 内容**：grep `property|duration|easing` 无命中，异常，
   需人工查看（R1 动效③）。
3. **bar 各面板是否统一走 ControlCenterGlass 配方**：只确认了 ControlCenterGlass
   本身，NetworkPanel/BatteryPanel 等未逐个核对（R1 §3）。
4. **圆角三档（32/24/16）保留为三档 token 还是收敛为更少档位**；Segmented
   三套圆角口径保留哪套（§3.5）。
5. **reduceMotion 贯通方式**：env 变量（`ApplicationPreferences.cpp:172` 已导出）
   vs QML 单例直读——shell QML 侧现无任何消费点，需定方案并补消费点。
6. **控件双家族（`shell/Kos/Ui/controls/Liquid*.qml` vs `foundation/Kos*.qml`，
   共 30 文件）合并方向**：以 liquid 为玻璃态、foundation 为普通态并存，
   还是逐步收敛为单家族。
7. **颜色入口统一**：AppTheme（`KosSurface.qml:6-7`）与 AppearanceTokens
   （`AppearanceTokens.qml:17-94`）两套色板入口如何归一。
8. **liq 分支（`codex/liquid-animation-experiment`）动效实验结论**：集中在
   `apps/settings` 的 WindowSettings/main.qml/tests，未逐项核对，是否纳入
   token 表待评估。
9. **weather `Main.qml` 的 tint/模糊配方**（仅抽查 MultiEffect :1330,:1362）：
   是否迁入 GlassSurface，待细读后定。
10. **深色主题 tint 具体色值**与**字阶/间距 token**：R1 未盘点，需补一轮。
