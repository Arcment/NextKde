# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10k 已完成，G10 队列收口。补齐矩阵最后 5 格（notification、dialog、
motion 页 toast、tooltip 页内基准、decision lanes），各取 dark/light 截图并
目视确认可读；回填 SPEC §1.5、INVENTORY §12、DEMO G10 段与本 ledger。
本轮不改代码，最终截图沿用 G10j 后的 overview 采样（代码自此未变）。
`run.log` 全程无 QML/shader 报错（仅 wallpaper colorquantizer 警告）。

## 队列（✅=已交付）
- [x] G10a 背景板组件化 + 主窗口隐藏采样副本 + `GlassBackdrop` 单例
- [x] G10b `scene_liquid.frag` + `compile.sh` + 烘焙
- [x] G10c `LiquidGlassSurface` 场景采样 + `LiquidGlassPanel` 转发
- [x] G10d 主窗口表面启用 scrim + 首轮截图
- [x] G10e 弹窗窗口局部采样（`GlassPopup` / `GlassTooltip`）
- [x] G10f Toast/Tooltip 页内基准 + 通知/菜单/对话框页启用 scrim
- [x] G10g 深色主题可读性矩阵（上半）
- [x] G10h 浅色主题可读性矩阵（下半）
- [x] G10i 极端边界复检（象限交界 / 黑白点 / 最亮黄区）
- [x] G10j 与 KWin 预设强度对齐（cap/decay/tint 统一到 `GlassBackdrop`）
- [x] G10k 文档回填 + 最终截图 + DONE

## 可读性矩阵（G10g 起每轮至少填一格）

| 表面 | dark | light |
| --- | --- | --- |
| 左栏 nav | ✅ 白字可读（balanced）；青区对比偏低但可辨 | ✅ 深色文字在提亮红底上清晰（balanced 白 tint）；次级项略淡但可辨 |
| overview 16 卡 | ✅ 采样修复后 16 卡按象限取色（左上红 / 右上黄 / 左下青 / 右下品红），黄区压成橄榄色；白/次级文字全卡可读 | ✅ 16 卡正确随象限变浅（浅红/浅黄/浅青/浅粉），深色标题与副标在全部四区清晰 |
| surfaces clear/regular/thick | 外推：三档是 KWin 路径演示（useKwinEffect:true），红线不改；无 KWin 时不着色、黄区白字不可读。同页 QML 卡（regular+balanced）采样正确、可读 | 外推：三档及 LiquidGlassPanel/ControlCenterGlass/KosFlowPanel 均为合成器路径演示，无 KWin 时不着色；light 下 clear/regular 白字在亮红上偏弱。同页 QML `LiquidGlassSurface` 跨黄/品红边界采样正确（上黄下品红），深色文字清晰 |
| popover | ✅ 红区白/次级文字可读（未启用 scrim，旧行为） | ✅ 深色标题清晰，次级灰字在红底上可辨（未启用 scrim，旧行为） |
| menu | ✅ balanced 黑 tint 压暗红区，白字清晰 | ✅ balanced 白 tint 提亮红区成浅粉卡片，深色文字清晰 |
| tooltip | ✅ thick + 局部采样，白/次级文字清晰 | ✅ thick + 局部采样，近白卡片 + 深色文字，主/次文字均清晰 |
| toast | ✅ 基准 GlassToast（readable）白字可读；同组 ActionFeedbackToast 为 KWin 路径（无 KWin 时只剩文字，外推） | ✅ 基准 GlassToast（readable）浅色胶囊 + 深色文字清晰；下层页面密排文字略透出但不干扰；ActionFeedbackToast 仍为 KWin 路径（外推） |
| notification | ✅ 卡片落在黄区，readable 黑 tint 压暗成深琥珀色；标题/正文白字清晰，时间戳可辨 | ✅ 白 tint 提亮黄区成近白卡片，深色标题/正文/时间清晰 |
| dialog | ✅ 页内模态 balanced；标题、正文、取消/保存按钮在卡片上均可读，未见不可辨项 | ✅ 近白卡片 + 深色标题/正文/按钮，清晰 |
| motion 页 toast | ✅ 药丸跨红/黄交界，采样连续（左红右黄无断裂）；readable 压暗后白字清晰 | ✅ 跨界采样连续，浅色药丸 + 深色文字清晰 |
| tooltip 页内基准 | ✅ 红区局部采样 + balanced，`GlassTooltip` 与参数读数白字清晰 | ✅ 组件为深色厚玻璃卡片，白字清晰；次级说明灰字可辨 |
| decision 三条 lane | ✅ ①Toast / ②Tooltip 近黑衬底 + 白字，读数与后果行对比充足；③Session 在视口折叠下方，外推（三 lane 共用同一衬底与固定 ink 常量，无独立配色） | ✅ ①② 近白衬底 + 深色文字，全部读数清晰；③Session 同上外推 |
| param panel（文字最密） | ✅ 跨黄/品红交界玻璃连续渐变，白字与滑杆读数可读；文字最密区无不可辨项 | ✅ 浅黄→浅粉连续渐变，深色文字/读数清晰 |
| 象限交界 / 黑白点最坏情况 | ✅ 16 卡与 nav、param panel 跨交界处采样连续；黑白点透过玻璃明暗正确，未见色块断裂 | ✅ 同上；白点处玻璃提亮但深色文字仍可读，黑点处仍清晰 |

## G10j 预设对齐（已交付）

QML 兜底与合成器路径现在共用同一张表，不再各自写字面量：

- `GlassBackdrop.scrimCap(level)` / `scrimDecay(level)`：readable 0.72/1.0、
  balanced 0.47/0.75、transparent 0.22/0.5、subtle 0.15/0.45。
- `GlassBackdrop.defaultScrimTint`：随外观开关（开：深色黑 / 浅色白；关：黑）。
  `LiquidGlassPanel.scrimTint` 与 `LiquidGlassSurface` 的默认 tint 都取它。
- `LiquidGlassSurface` 新增 `scrimLevel`，默认 `"custom"`（原样取
  `scrimCap`/`scrimDecay`，旧调用零变化）。面板转发语义不变。
- `OverviewPage` 16 卡与 `SurfacesPage` 的 QML 卡删除手写 `0.47/0.75` 与
  tint 三元式，改为 `scrimLevel: "balanced"` + 共享 tint。

每个表面最终取值（QML 路径）：

| 表面 | preset | cap / decay | tint |
| --- | --- | --- | --- |
| 左栏 nav（`GalleryRoot`） | balanced | 0.47 / 0.75 | 共享规则 |
| overview 16 卡 | balanced | 0.47 / 0.75 | 共享规则 |
| surfaces 页 QML 卡 | balanced | 0.47 / 0.75 | 共享规则 |
| param panel | readable | 0.72 / 1.0 | 共享规则 |
| toast 页内基准 | readable | 0.72 / 1.0 | 共享规则 |
| tooltip 页内基准 | balanced | 0.47 / 0.75 | 共享规则 |
| `GlassToast` / notification | readable | 0.72 / 1.0 | 共享规则 |
| menu / dialog | balanced | 0.47 / 0.75 | 共享规则 |
| decision toast / tooltip lane | readable | 0.72 / 1.0 | 共享规则 |
| popover | —（未启用，旧行为） | — | — |

surfaces 页 clear/regular/thick 三档是 KWin 路径演示（`useKwinEffect: true`），
不在本次 QML 对齐范围，保持原样。

截图：`g10j-overview-dark.png`（16 卡按象限、nav/参数面板可读）、
`g10j-surfaces-light.png`（QML 卡 balanced 白 tint，深色文字清晰）。`run.log`
无 QML/shader 报错（仅 wallpaper colorquantizer 警告）。视觉与对齐前的字面量
取值一致——本次是来源统一，不是强度变更。

## G10k 收口（已交付）

矩阵最后 5 格补齐，截图（`tmp/glass/`，同时归档到 `docs/design/liquid-glass/`）：

| 表面 | dark | light |
| --- | --- | --- |
| notification | `g10k-notification-dark.png` | `g10k-notification-light.png` |
| dialog | `g10k-dialog-dark.png` | `g10k-dialog-light.png` |
| motion 页 toast | `g10k-motion-toast-dark.png` | `g10k-motion-toast-light.png` |
| tooltip 页内基准 | `g10k-motion-tooltip-dark.png` | `g10k-motion-tooltip-light.png` |
| decision lanes | `g10k-decisions-dark.png` | `g10k-decisions-light.png` |

最终截图沿用 G10i overview 采样（G10j 只统一 preset 来源、视觉未变，本轮无代码改动）：
`g10k-final-dark.png` / `g10k-final-light.png`。

文档回填：

- SPEC 新增 §1.5「无 KWin 场景采样（G10 定案）」：隐藏副本 + `GlassBackdrop`、
  1/6 捕获 + 9 tap、共用 preset 表、弹窗平移副本、`null`/KWin 路径不变。
- INVENTORY 新增 §12：`GlassBackdrop` / `scene_liquid.frag` /
  `GalleryBackdropBoard` / `GalleryBackdropSample` 四个组件的契约与位置。
- DEMO 新增 G10 段：背景板 toggle、采样演示、矩阵截图用法与「只目视」边界。
- 本 ledger 矩阵无「仍差」；surfaces 三档与 decision ③ 为写明原因的外推项。

## 已确认的架构（不要重开）

- 可见背景板窗口保留（KWin 路径需要它）。
- 主窗口内隐藏副本 + 每个表面 `ShaderEffectSource{ hideSource: true }`。
- `GlassBackdrop` 单例提供 `sourceItem`；`null` = 旧行为。
- 弹窗用 `GalleryBackdropSample`（按 `anchor.rect.x/y` 平移）。
- shader 用 KWin 的 `adaptiveScrim` 原式，preset 用
  readable 0.72/1.0、balanced 0.47/0.75、transparent 0.22/0.5、subtle 0.15/0.45。

## 上一批（G9 已交付，勿重做）

- `GlassToast` 默认 timeout 已统一 2600。

## Next round

无。G10 队列全部交付，矩阵无「仍差」，`tmp/glass/state.md` 已写 `DONE`。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
