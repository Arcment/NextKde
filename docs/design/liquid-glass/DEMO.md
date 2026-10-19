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
   环境光过渡 2600ms、tooltip 70ms、toast 2600ms（悬停暂停）各一个演示位；
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
- SPEC §7 的 3 项裁定项（Toast 存留 / Tooltip 贴边 / SessionMenu 字号）
  已在 gallery 中以「A/B 并排」形式呈现并完成人工裁定；A/B 两栏保留为
  记录并标注「已裁定」，不删未选项、不写推荐（结果见 SPEC §7 与文末 G7 段）。
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

G4b 已交付：TextField 与 Checkbox 的 3 材质 × 6 状态矩阵，同为双形态。

- `GlassTextField.qml`：高 28、regular、Body 13/16；liquid = pill 玻璃体，
  material = M3 filled、radius 10。focus 同时改变三样东西：2px accent 描边、
  外移 3px 的 2px 外环（外侧另加 1px ink 发丝保证亮底可见）、tint 加深，
  因此不靠颜色单独表达。error = 2px 红色描边 + 右端圆形「!」徽标（形状 + 字形）。
- `GlassCheckbox.qml`：框 20×20、radius 5、label Body 13/16；勾选态由
  `QtQuick.Shapes` 画两段折线成 √（不是换色）；focusVisible = 外环 + ink 发丝。
  hover/pressed 为状态层（liquid 玻璃增益 / material 8%·12%），pressed 另有
  0.90 缩放。
- TextField 矩阵六卡：normal / hovered / focused / error / filled / disabled。
  SPEC §3.10 定义前四者，hover 与 filled（带值外观）为补充展示，不是新状态。
- Checkbox 矩阵六卡与 SPEC §3.11 一一对应：
  unchecked / checked / hovered / pressed / focusVisible / disabled。
- 验收截图：`g4-dark-textfield.png`、`g4-dark-checkbox.png`
  （`GALLERY_CONTROLS_FILTER=textfield|checkbox`，形态 liquid，offset 0）。

G4c 已交付：ComboBox 与 SegmentedControl 的 3 材质 × 6 状态矩阵，同为双形态。

- `GlassComboBox.qml`：高 36、radius pill、Body 13/16。liquid 描边按 §3.12
  （深色 white α0.16 / 浅色 black α0.12）；material 为 M3 filled + outline。
  弹层用 sheetColor 深 `#262b31` / 浅 `#f6f8fb`、radius 16、字段下偏移 5、
  padding 8、高 `min(360, 内容+12)`；弹层在组件内绘制且不裁剪，矩阵的
  `open` 卡直接呈现展开终态（含选中 √ 与行高亮）。
- `GlassSegmentedControl.qml`：统一比例制 pill `height/2`、
  card `height×0.38`；cell 72×40、outerPadding 2、Body 13/16。
  gallery 映射为 liquid → pill、material → card；选中段为抬升玻璃胶囊
  （material 为 accent 填充），focusVisible 为 2px 环 + ink 发丝（形状，不只颜色）。
- ComboBox 矩阵六卡：idle / hovered / pressed / focusVisible / open / disabled。
  `open` 即 §3.12 弹层终态。卡片高 196，容下字段 + 偏移 + 118px 弹层。
- Segmented 矩阵六卡：idle / hovered / pressed / focusVisible / selected /
  disabled；`selected` 卡把选中移到第二格。因状态卡宽约 88px，矩阵内用
  compact 样本 `cellWidth 40 × cellHeight 26`（两格），矩阵下方另有
  全尺寸 live 样本 `3 × 72×40 + outerPadding 2`，尺寸 token 未改。
- `ControlStateCard` 右上角标注改为限宽 + 右对齐 + elide，长状态名
  （focusVisible）不再越出卡边。
- `GlassCheckbox` 的两个 focus 环移入 box 内部锚定（此前锚到非兄弟节点，
  run.log 会产生 QML 警告）；形状与尺寸不变。
- 验收截图：`g4-dark-combobox.png`、`g4-dark-segmented.png`
  （`GALLERY_CONTROLS_FILTER=combobox|segmented`，形态 liquid，offset 0）。

G4d 已交付：GlassSlider 与 GlassSwitch 的 3 材质 × 6 状态矩阵，同为双形态。

- `GlassSlider.qml`：value 0..1、高 44、track 6、thumb 32×16、accent 读
  `ControlTokens.accentColor`。liquid = iOS 玻璃 thumb（磨砂底 + 折射/高光 +
  内沿 + accent 溢染，hover expansion 0.3 / pressed 1.0）；material = M3
  （`m3Scale=min(1,h/44)`、inactive 4 / active 16 / handle 4×44）。
  契约：拖拽发 `previewChanged`，松手发 `commitRequested` 并把 thumb x 动画
  屏蔽 400ms；Ctrl+滚轮按 0.01/档（像素累积 10）步进、180ms 去抖提交；
  disabled/hidden 发 `canceled`。矩阵六卡为 idle / hovered / pressed /
  disabled + 两个取值样张（0% / 100%，forcedState idle，不是新状态）。
- `GlassSwitch.qml`：74×32、thumb 44×26、`travel = width-44-6`；liquid thumb
  展开高度夹到 `height-2`（gallery 以高度夹取代替生产件的 pill mask，宽度
  仍 1.4×），material = M3 track + handle 16 off / 24 on、
  `m3Scale=min(1,h/32)`。`checked` 归宿主，`toggle()` 只发
  `toggled(!checked)`，组件不本地翻转；thumbX 200 OutCubic、press 120 /
  释放 200。focusVisible = 2px accent 环 + 1px ink 发丝（形状 + 对比，不只颜色）。
- 两段矩阵下方各有一行 live 控件与只读读数：slider `preview / commit / wheel
  （档数）/ canceled`；switch `requested / confirmed`（350ms 模拟宿主异步确认）。
- `ControlStateCard` 右上角标注由 G4c 的 elide 改为最多两行换行，
  `clear · focusVisible` 不再截断成 `focusVisi…`；两行仍右对齐、10px。
- 验收截图：`g4-dark-slider.png`、`g4-dark-switch.png`、
  `g4-light-slider.png`、`g4-light-switch.png`
  （`GALLERY_CONTROLS_FILTER=slider|switch`，形态 liquid，offset 0）。
  另拍 material 形态 `g4-dark-material-slider/switch.png` 核对 M3 比例。

G4e 已交付：GlassScrollBar 的 3 材质 × 6 状态矩阵与十档字阶对照区。

- `GlassScrollBar.qml`：SPEC §3.13 v1 提案——overlay 式，宽 6（hover 8）、
  radius pill、滚动/悬停显示、静止淡出；thumb 浅 `#22000000` / 深
  `#30ffffff`。显示随 `active / hover / drag`，淡出与宽度跟随复用 shell 的
  `motion.slowDuration`（260ms）与 `motion.fastDuration`（120ms），不新增时长档位。
  组件为宿主驱动：`position` / `size` 归滚动宿主，拖动只发
  `dragStarted / dragMoved / dragEnded`，由宿主写回 `position`（与 Switch 的
  `checked` 契约同构）。最小 thumb 长 24px 为 gallery 外推（SPEC 未给）。
- `ScrollListSample.qml`：6px 的条单独截图不可读，矩阵卡与演示行都把它放在
  一个小型线列表面右侧；列表只是 mock，不是控件。
- ScrollBar 矩阵六卡：idle / scrolling / hovered / dragging / top / bottom。
  §3.13 只定义行为、未定义状态集：前四者为交互态，top / bottom 为位置样张。
  卡内 10px 提示依次为 `→ opacity 0`、`thumb 6 px`、`thumb 8 px`、
  `position 0.62`、`position 0`、`position 1`；idle 卡 thumb 完全透明即
  「静止淡出」终态，属预期而非空卡。
- 矩阵下方演示行并排 idle / hovered / dragging 三个小列表，右侧读数写明
  overlay 行为、颜色与 `size 0.34`。
- 字阶对照区：`ControlTokens.typeScale` 十档逐行「名称 · 字号/行高 · 样张 ·
  归并来源」，字号 26/22/17/15/13/13/12/11/10/10、行高
  32/26/22/20/16/16/15/14/13/13；样张按 `Text.FixedHeight` 使用该行行高，
  Headline 为 Bold，正文用 Body 13/16、最小 10。
- 截图钩子新增 `GALLERY_CONTROLS_FILTER=scrollbar|type`。
- 验收截图：`g4-dark-scrollbar.png`、`g4-dark-type.png`
  （形态 liquid，offset 0）。

G4f 收口：全量截图重拍与逐张目检。

- 截图（`tmp/glass/`，除注明外 form=liquid、offset 0）：
  `g4-dark-top` / `g4-light-top`（整页顶部）、`g4-dark-button` /
  `g4-light-button` / `g4-light-material-button`、`g4-dark-textfield`、
  `g4-dark-checkbox`、`g4-dark-combobox`、`g4-dark-segmented`、
  `g4-dark-slider` / `g4-light-slider`、`g4-dark-switch` / `g4-light-switch`、
  `g4-dark-scrollbar`、`g4-dark-type`。light 组同图可见标题与正文 ink
  切换，确认 `GALLERY_THEME` 生效。
- 逐张核对：八个控件矩阵均完整 3 材质 × 6 卡；focus 用「描边 + 外环」双形状，
  error 为红描边 + 圆形图标，checkbox 勾选为 √ 路径，均不靠颜色；
  slider / switch 的 live 读数区在矩阵下方静态可见。
- G4c 遗留核对：ComboBox `open` 卡的弹层完整落在卡内，与下一材质行留约
  20px 间距，不遮挡后续 section；Segmented 矩阵仍为 compact 样本（72×40
  实尺寸见演示行）；clear 档卡片透出的白点是测试背板，不是控件缺陷。
- 整页高度：Flickable 含 9 个 section，offset 0 实拍只露出 Button 与
  TextField 标题，内容远高于早期草图估计的约 2000px；各段用 filter 截图
  均可从顶部到达，滚动可达。
- `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；截图结束无
  残留 gallery 进程。

G5e 收口：动效页 10 张截图全量重拍与逐张目检。

- 截图（`tmp/glass/`，同名同步到 `docs/design/liquid-glass/`）：
  `g5-dark-popup` / `g5-light-popup`、`g5-dark-press`、`g5-dark-ambient`、
  `g5-dark-tooltip`、`g5-dark-toast`、`g5-dark-reduce` / `g5-light-reduce`、
  `g5-dark-params` / `g5-light-params`。
- dark popup：OutCubic 开 lane progress 1.000 · effective 150ms · settled；
  InCubic 关 lane progress 0.578 · effective 140ms · sampled；两 lane 均带
  t=0/0.25/0.50/0.75/1.00 的 ease/progress 采样列
  （开 0.000/0.578/0.875/0.984/1.000；关 1.000/0.984/0.875/0.578/0.000），
  并保留 startScale 0.96 · anchorOffset 20px 标注。
- light popup：同读数；页标题、lane 标签与读数均为深色墨，浅色主题生效。
- dark press：idle 0.000 / hovered 0.300 / pressed 1.000 三态并排；
  live 行读 expansion 0.000、press 200ms OutBack / release 360ms OutQuint、
  state idle。
- dark ambient：A/B 起止色样 + 2600ms InOutSine 徽标；mix 50%、
  progress 0.500、state sampled · target A。
- dark tooltip：progress 1.000、scale 1.000、effective open 70ms OutCubic /
  close 70ms InCubic、state shown、锚点侧重叠 6px 标注保留。
- dark toast：hold 1600ms（effective 1600ms，SPEC §7-① 待裁定）、
  effective show 150ms / hide 180ms、state shown · remaining 1600ms。
- dark reduce：顶栏 reduceMotion=on；两 lane effective 0ms（reduceMotion）、
  开 progress 1.000 settled / 关 progress 0.000 settled，startScale 0.96 与
  anchorOffset 20px 标注保留。
- light reduce：同读数，深色墨；`GALLERY_MOTION_REDUCE` 与浅色主题可叠加。
- params dark/light：tintStrength 0.16 + 三刻度 0.10/0.16/0.24；blurLevel L8
  + clear 1..5 / regular 6..10 / thick 11..15 三段色带（标记 regular）；
  radius 24（32/24/16 中 24 选中）、free 滑杆 24、pill off · eff 24；
  reduceMotion off。参数卡与右侧面板逐项同值；light 组为深色墨。
- `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；每轮截图后
  pkill 锚定 `^qs -p shell/gallery.qml`，无残留 gallery 进程。

## G6b — reduceMotion 四段截图（dark）

- 截图（`tmp/glass/`）：`g6-dark-reduce-press` / `g6-dark-reduce-ambient` /
  `g6-dark-reduce-tooltip` / `g6-dark-reduce-toast`。
- press：三态 token 保留 idle 0.000 / hovered 0.300 / pressed 1.000；
  live expansion 0.000；effective press 0ms OutBack · release 0ms OutQuint
  （reduceMotion）；state idle。
- ambient：2600ms InOutSine 徽标保留；progress 0.000、mix 0%、
  effective 0ms（reduceMotion · 跳过）、state skipped · target A。
- tooltip：progress 1.000、scale 1.000；effective open 0ms OutCubic /
  close 0ms InCubic（reduceMotion）；state shown · last seed；6px 重叠标注保留。
- toast：hold 1600ms → effective 0ms（§7-① 待裁定）；effective show / hide
  0ms OutCubic；state shown · remaining 0ms · last reduceMotion · 时长 0。
  `ToastDemo.onReduceMotionChanged` 改为直接读开关值写 remaining，
  避免 `holdEffective` 绑定尚未重算时残留 1600ms。
- 四张顶栏均读 reduceMotion=on；`run.log` 无 QML 报错（仅 wallpaper
  colorquantizer WARN）。首次重拍 toast 时 quickshell 崩溃一次，重拍成功。

## G6c — 裁定页骨架 + Toast A/B（SPEC §7-①）

- 新增 `shell/gallery/DecisionsPage.qml`，页序 6、导航「裁定 G6」；钩子
  `GALLERY_PAGE=decisions`、`GALLERY_DECISION=toast|tooltip|session`。
  页面只呈现 A/B 的交互、读数与后果行，不写推荐；顶部标注「待人工裁定」。
- `DecisionLane.qml` 为单侧 lane 框架（标题 / 交互体 / 后果行）；
  `DecisionToastLane.qml` 实现 toast 存留演示：A hold 1600ms 自动消失，
  B hold 2600ms + hover 暂停（离开继续）；读数并列 total / elapsed /
  remaining / paused。
- 截图（`tmp/glass/`）：`g6-dark-decision-toast` / `g6-light-decision-toast`。
- dark toast：A 栏 total 1600ms · elapsed 0ms · remaining 1600ms ·
  paused no；B 栏 total 2600ms · remaining 2600ms · paused no；两栏
  state shown · last seed（截图为演示常显，时钟未启动），发一条 / 关闭可交互。
- light toast：同读数，深色墨，两栏衬底改为浅色以便在饱和背景板上读清。
- 后果行：A 写 1600ms 与「立即确认」一致、不可暂停与 HIG「少用定时消失」
  有距离；B 写 2600ms + 悬停暂停更贴近 HIG、代价是占用更久；无推荐。
- 仍差：dark 主题 B lane 处于黄色象限时，10px 读数对比度约 3:1，后续可
  加大 lane 衬底；light 主题两栏黑字可读。
- `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；截图后无残留
  gallery 进程。

## G6d — Tooltip A/B + SessionMenu A/B（SPEC §7-② / §7-③）

- 新增 `DecisionTooltipLane.qml`：stage 内画「屏幕边缘」hairline、贴边锚点
  chip（10:42）与锚点下缘 hairline，tooltip 右缘同样贴边。
  A 栏 `gap -6px`（tooltip top 34 / anchor bottom 40，压进锚点 6px）；
  B 栏 `gap +4px`（tip top 44，留正间隙）。两栏读数并列 `gap` /
  `anchorB · tipTop` / `state`；悬停 chip 显示、离开隐藏，chip 点击与
  「显示/隐藏」按钮切换。静态截图 seed 为 shown。
- 新增 `DecisionSessionLane.qml`：同一三行动作菜单（锁屏 / 注销 / 关机），
  两列极端 itemHeight 并排，label 固定 Footnote 10。
  A 栏 `mode raw`：24 / 72 原值，24 注「拥挤」、72 注「空旷」；
  B 栏 `mode clamp`：请求 24 → 44、72 → 56，注 `req → clamp`。
  读数写 `itemHeight 24 · 72 / 44 · 56 ← req` 与 `font 10px`；
  行 hover 高亮、点击选中。浅色主题下 danger 墨改为深红
  （现役 SessionMenu 为锁屏深色专用，浅红在 gallery 浅底上不可读）。
- `DecisionsPage.qml` ②③ 两段替换占位，卡高 360 / 484；两栏等宽、
  后果行固定栏底，仍无推荐、无裁定。
- 截图（`tmp/glass/`）：`g6-dark-decision-tooltip` /
  `g6-light-decision-tooltip` / `g6-dark-decision-session` /
  `g6-light-decision-session`。
- dark tooltip：A `gap -6px · anchorB 40 · tipTop 34`，B `gap +4px ·
  anchorB 40 · tipTop 44`，两栏 state shown · last seed。
- dark session：A `itemHeight 24 · 72 · font 10px`；B `itemHeight 44 · 56
  ← req 24 · 72 · font 10px`；selected —（seed）。
- light 两张同读数；两个主题的读数与菜单文字均可读。
- 仍差：B 栏两列 clamp 后高度 44 / 56 不同，两列注释行不在同一 y
  （相差约 33px），读数仍逐列可对应；dark tooltip 的 `屏幕边缘` 标签为
  8px，仅作位置提示。
- `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；截图后无残留
  gallery 进程。三项均「A/B 已呈现，待人工裁定」。

## G6e — 收口（12 张截图 + ledger）

- 第四节 12 张截图全部就位：motion 侧 6 张（params 2 + reduce 4）、
  decision 侧 6 张（toast / tooltip / session 各 2）。motion 侧与 decision
  ②③ 的代码在 G6c/G6d 后未变，沿用当轮成片；Toast 2 张因 G6d 改过
  `DecisionsPage.qml`，本次按钩子重拍
  （`GALLERY_PAGE=decisions GALLERY_DECISION=toast`）。
- 逐张核对：
  - params dark/light：`reduceMotion off` → `effective 150/140 ·
    expansion on · ambient 2600ms`，与右侧参数卡一致。
  - reduce press：`effective press 0ms OutBack · release 0ms OutQuint`、
    `expansion 0.000`（idle / hovered / pressed）。
  - reduce ambient：`effective 0ms (reduceMotion · 跳过)`、`state skipped`、
    `mix 0%`、`progress 0.000`。
  - reduce tooltip：`effective open 0ms OutCubic · close 0ms InCubic`、
    `progress 1.000 · scale 1.000`。
  - reduce toast：`hold 1600ms → effective 0ms`、`state shown ·
    remaining 0ms`。
  - decision toast：A total / remaining 1600ms，B 2600ms；elapsed 0ms、
    paused no、state shown（seed）；两栏均列 consequence。
  - decision tooltip：A `gap -6px · anchorB 40 · tipTop 34`，B `gap +4px ·
    anchorB 40 · tipTop 44`，state shown；两栏均列 consequence。
  - decision session：A `itemHeight 24 · 72 · font 10px`，B `itemHeight
    44 · 56 ← req 24 · 72 · font 10px`；两栏均列 consequence。
- ledger：已改 = params 标签分支、reduce 四段、裁定页三段、Toast 两张重拍；
  仍差 = 下列三项；外推 = 三项均由人工裁定，页面只给并排交互与读数。
- ① Toast 存留 1600ms：A/B 已呈现，待人工裁定。
- ② Tooltip 贴边 -6px：A/B 已呈现，待人工裁定。
- ③ SessionMenu 极端高度：A/B 已呈现，待人工裁定。
- 三项已于 G7 人工裁定（① B / ② B / ③ A，见文末 G7 段）；
  上述 A/B 状态与读数是 G6e 当时记录，保留不改写。
- 仍差：dark 主题 Toast B lane 落在黄色象限，9px 读数白字实测最大对比度
  约 2.2:1、后果行约 2.1:1（衬底约 rgb 197,168,49，字约 255,251,229）；
  Session B 栏两列 clamp 后高 44 / 56，两列注释行 y 相差约 33px；
  tooltip「屏幕边缘」标签 8px 仅作位置提示。
- `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；重拍后无残留
  gallery 进程。

## G7 — 三项裁定落地 + 裁定页收口

人工裁定（SPEC §7 已回填为「已裁定」记录）：

- ① Toast → **B**：存留 2600ms（原 1600ms）+ 悬停暂停、离开按剩余继续。
- ② Tooltip → **B**：贴边 +4px 正间隙（原 -6px 负 margin）。
- ③ SessionMenu → **A**：接受固定 Footnote 10，不单独设 itemHeight 范围，
  生产代码不改。

生产改动（仅三个点名文件 + gallery 文案）：

- `shell/desktop/modules/common/ActionFeedbackToast.qml`：`timeout` 2600；
  `HoverHandler` 悬停暂停，`dismissAt` 记录 deadline，离开按剩余时间续计
  （不重置 2600ms）；`enabled: shown`，仍不响应点击、不抢焦点。
- `shell/desktop/modules/bar/StatusTooltip.qml`：`margins` 四处 -6 → +4
  （dockHosted / 对应边条件命中处），其余 0 分支不变。
- `shell/desktop/modules/dock/DockAppNameTooltip.qml`：`margins.top/left/right`
  三处 -6 → +4，其余 0 分支不变。
- `shell/gallery/PopupsPage.qml`：1600 文案与注释同步 2600
  （gallery 演示覆盖 600000 保留）。
- 固有代价：toast 可见期间其 36px 药丸区域接收悬停（点击不再穿透），
  以换取悬停暂停；区域小且短暂。

文档回填：SPEC §2.7 token 表 / §3.5 / §3.6 / §5 / §7 已改为 2600ms +
悬停暂停与 +4px 正间隙；INVENTORY §4 现值与 §8.2 margins 行同步，
§11 三项标为已关闭；本文件补 G7 段。

裁定页收口（G7d）：

- 三段卡各加「已裁定」标记：① B · 2600ms + 悬停暂停；② B · +4px；
  ③ A · 固定 Footnote 10。
- 保留 A/B 两栏作为记录，不删未选项、不写推荐。
- dark / light 两主题下读数行、后果行、注释行与 lane 衬底对比度 ≥ 4.5:1
  （实测十六进制记入 ledger）。
- 重拍 6 张：`g7-{dark,light}-decision-{toast,tooltip,session}`。
- 验证边界：StatusTooltip / DockAppNameTooltip 不被 gallery 加载，只做
  代码级核对；+4px 手感需人工在真实 bar/dock 上悬停验证。
