# 液态玻璃 Gallery Demo 设计（第 0 批续 R4）

> 只写设计，不写代码、不含实现。Demo 的唯一用途是**人工肉眼比对**，
> 不作为任何自动判据；验收基准以 `SPEC.md` v1 的 token 表为准。
> 事实依据沿用 `INVENTORY.md`（R1+R3），出处不重复展开。

## 1. 身份与位置

- **位置（实测定案）**：`shell/gallery.qml`（入口）+ `shell/gallery/`（页面），
  **不是** `apps/gallery/` 的普通 QML 应用。启动方式为
  `qs -p shell/gallery.qml`。
- **原因**：gallery 必须直接实例化现役玻璃组件——`LiquidGlassPanel` 依赖
  `AppearanceConfigService`（`import Quickshell`）、`KosFloatPanel` 依赖
  `Quickshell.Wayland`、`ControlCenterGlass` 依赖 `qs.desktop.modules.dock`，
  普通 `QGuiApplication` 加载不了 `Quickshell`，这些真实组件一个都用不上；
  而 Quickshell 的 `qs.*` 导入前缀固定映射到配置根目录，只有配置根为 `shell/`
  时 `import qs.desktop.modules.common` 才能原样解析。
- **构建关系**：不注册 CMake、不加构建开关、不进安装产物、不改任何构建文件
  （原「`add_subdirectory(apps/gallery)` + `-DKOS_BUILD_GALLERY=ON`」方案
  已被上述实测证伪，作废）。
- **复用**：直接引用 `shell/Kos/Ui/`、`shell/desktop/modules/common/` 的真实组件
  （GlassSurface / LiquidGlassPanel / PopupMotion 等），**不复制副本**——
  gallery 的意义就是让规范组件在受控环境下显示。
- **颜色入口**：gallery 自身接 AppearanceTokens（SPEC §2 定案的玻璃色值出口），
  主题切换走 `AppearanceConfigService.updateThemeMode("light"|"dark")`，
  不引入第二套色板。

## 2. 页面结构

左侧固定导航（自身用 GlassSurface 普通 A 层壳，展示「无 B 层时也成立」）：

1. **总览页**
   - 16 个组件各一个缩略卡，浅/深主题并排两列；
   - 顶部一排「材质三档」并排演示块（clear/regular/thick 各一块同内容卡片），
     让三档 tintStrength / opacity / reflection 差异一眼可辨；
   - 角落常驻当前全局参数面板入口（见 §4）。
2. **表面页**：GlassSurface、LiquidGlassPanel（B 层宿主）、
   KosFloatPanel（layer-shell 路线）、ControlCenterGlass 配方四块，
   每块标注其 radius / exponent / 阴影档（对照 SPEC §2.2-§2.3）。
3. **弹层页**：GlassDialog（G3；含 scrim 单一来源演示：开关 compositor scrim
   与 QML 背板，展示「双开 = 违规双重变暗」）、GlassPopover、GlassMenu、
   GlassTooltip、GlassToast、GlassNotification。每个弹层可从锚点按钮唤起。
4. **控件页**：GlassButton / GlassTextField / GlassCheckbox / GlassComboBox /
   SegmentedControl / GlassSlider / GlassSwitch / GlassScrollBar，每控件一整行
   状态矩阵（§3）；每控件提供 liquid / Material 双形态切换
   （ControlForm.materialForm，INVENTORY §12.1-§12.2）。
   GlassNavBar（容器契约，SPEC §3.16）在表面页演示——它是导航容器，
   不进表单控件区。
5. **动效页**：PopupMotion 开合（OutCubic/InCubic 对比）、液态按压 expansion、
   环境光过渡 2600ms、tooltip 70ms、toast 1600ms 各一个演示位；
   reduceMotion 开关联动（§4）。

## 3. 组件状态矩阵（每控件的呈现方式）

每个组件在页面中以**小卡片阵列**呈现完整矩阵，卡片右上角标注当前
档位组合（如「浅 · regular · pressed」）：

- **维度**：主题（浅 / 深）× 材质（clear / regular / thick）× 交互状态
  （idle / hover / focus / pressed / disabled / error）。
- **按组件裁剪**：
  - 表面/弹层类（GlassSurface、Popover、Menu、Notification）无 focus/error
    维度 → 6 状态中只呈现 idle/hover/pressed/disabled；
  - 表单类（Button、TextField、Checkbox、ComboBox、Segmented、Slider、Switch）
    呈现全 6 态，focus 态必须展示键盘焦点环（SPEC §2.6：不得只靠颜色）；
    Slider 额外演示 preview/commit 两段提交与 Ctrl+滚轮步进
    （SPEC §3.14 定案行为）；Switch 额外演示宿主确认式 toggled（不本地翻转，
    SPEC §3.15）；
  - 容器类（GlassNavBar）呈现 idle/selected/disabled 三态 + 5 档 size preset
    并排（SPEC §3.16）；
  - Tooltip/Toast/Dialog 无持续交互态，只演示开合动画与终态。
- **布局约定**：每行 = 一种材质（3 行），每行内 6 个状态卡并排；
  浅/深用页面顶部的主题开关切换后重看同一矩阵（不做 2×3×6 全铺，
  避免单页 36 卡过载）。
- **字阶演示**：控件页底部固定一块「字阶对照」区，按 SPEC §2.4 的
  HIG 十档样式逐行展示（LargeTitle→Caption），旁边列出对应的
  现值归并来源（如「弹层标题 24/21/19 → Title1 22」），供迁移时肉眼核对。

## 4. 现场可调参数（肉眼比对的核心）

右上角常驻参数面板，调整**实时作用于所有预览区**：

| 参数 | 范围 | 对照 SPEC |
|---|---|---|
| tintStrength | 0 – 0.40 连续滑杆，带三档刻度线（0.10/0.16/0.24） | §2.1 |
| blurLevel | 1 – 15 整数，带三段色带（clear 1..5 / regular 6..10 / thick 11..15） | §2.1 |
| radius | 三档按钮（32/24/16）+ 自由滑杆 0–32 + pill 开关 | §2.2 |
| reduceMotion | 开关；开启后所有时长置 0、折射动画关、expansion 关 | §2.7 |

辅助演示开关（弹层页）：compositor scrim 单独开 / QML 背板单独开 /
双开（展示违规状态，卡片标红边说明）——用于验证 §1.1/§3.2 的
「scrim 单一来源」契约的视觉效果。

## 5. 迭代轮次计划（一轮一个组件族）

| 轮 | 组件族 | 内容 |
|---|---|---|
| G1 | 表面 | GlassSurface + LiquidGlassPanel + 三档材质块；先做基准实现 |
| G2 | 弹层 | Popover / Menu / Tooltip / Toast / Notification 唤起与运动 |
| G3 | Dialog | KosDialog 生命周期统一 + scrim 契约演示 |
| G4 | 控件 | Button / TextField / Checkbox / ComboBox / Segmented / Slider / Switch / ScrollBar 全状态矩阵（含双形态切换）；NavBar 容器演示放表面页 |
| G5 | 动效 | 动效页 + reduceMotion 联动 + 参数面板完备 |

每轮流程：**先在 gallery 里落基准实现（对齐 SPEC token）→ 再从清单 app
迁移既有组件到规范组件**（迁移对象见 SPEC §6 清单），迁移前后截图并排
放入当轮交付文档。轮次产物 = gallery 页面 + 迁移 diff + 前后对照记录。

## 6. 边界声明

- Demo **只用于看**：不写任何自动断言、不进 CI、不作为截图回归基准。
- 组件行为正确性的验收 = SPEC token 表 + HIG 硬约束（§2.6）；
  gallery 仅提供「同一参数下新旧实现并排」的比对环境。
- gallery 中的所有演示参数改动**不回写**真实组件默认值；若比对后确认
  需要改 token，走 SPEC 的变更流程（更新 SPEC §2 并在 INVENTORY 补出处），
  不在 gallery 里就地改。
- SPEC §7 的 3 项人工裁定项（Toast 存留 / Tooltip 贴边负 margin /
  SessionMenu 比例字号）在 gallery 中以「A/B 并排」形式呈现，
  供裁定人直接对比选择，裁定结论回填 SPEC 后删除并排演示。
  （原 5 项中 weather tint 与 scrim 链路两项已于 R5 由代码关闭，
  见 SPEC §1.1/§1.4。）

## 7. 场景页 ink 判定（S3）

场景页两枚胶囊的文字 ink 统一由材质亮度决定：

- `rowLuminance` 取胶囊中心所在行的底色（`#0d0f12` / `#e8eaee`）；
- `tintLuminance` 取 shader 实际 tint（深色黑 = 0，浅色白 = 1）；
- `effectiveLuminance = mix(rowLuminance, tintLuminance, tintStrength)`
  （深色 0.18 / 浅色 0.32）；
- `effectiveLuminance < 0.34` 选浅字 `#f2f4f7`，否则深字 `#16181c`。

阈值 0.34 是实测值：浅色主题下深行被白 tint 抬到 0.359，按验收必须判深字，
因此不能用 0.45。tonal 胶囊不再依赖 `foregroundColor`，直接用同一判定。
真正的修法是组件 API 增加「背景 tone」输入（组件变更，不在 gallery 轮范围）。

## 8. 控件页（G4）

G4a 已交付：Button 的 3 材质 × 6 状态矩阵 + liquid / material 双形态切换。

- 页面 `shell/gallery/ControlsPage.qml`，整页 Flickable；顶部切换写
  `ControlForm.materialForm`，所有控件基线随之换形态。
- 状态卡 `ControlStateCard.qml`：QML 玻璃壳（`useKwinEffect:false`，矩阵中
  不建 compositor blur region）+ 1px 发丝边，右上角标注「材质 · 状态」。
- 控件基线 `GlassButton.qml`：高 28、Body 13/16；liquid = pill，expansion
  0 / 0.3 / 1.0 读 gallery 本地 `ControlTokens`；material = M3 filled、
  radius small 10、状态层 8%/12%。focus 是双环形状，不只换颜色。
- SPEC §3.9 只定义 4 个状态；矩阵第 5/6 卡展示 icon 形态与 keyboard focus
  （HIG §2.6 可达性），不是新增状态。
- 截图钩子：`GALLERY_PAGE=controls`、`GALLERY_CONTROLS_FILTER=button|…`、
  `GALLERY_CONTROLS_OFFSET`、`GALLERY_CONTROL_FORM=liquid|material`，
  均与 `shot.sh` 同行前置。
- 验收截图：`g4-dark-button.png`、`g4-light-button.png`、
  `g4-light-material-button.png`。
