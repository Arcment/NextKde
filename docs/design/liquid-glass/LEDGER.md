# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10j 已完成。**QML 兜底与合成器路径现在共用同一张 preset 表**：
`GlassBackdrop` 新增 `scrimCap(level)` / `scrimDecay(level)` /
`defaultScrimTint`（readable 0.72/1.0、balanced 0.47/0.75、transparent 0.22/0.5、
subtle 0.15/0.45；tint 随 `glassFollowsAppearanceMode`，关时黑）。
`LiquidGlassPanel` 的 `_presetCap/_presetDecay/scrimTint` 改从该表取值；
`LiquidGlassSurface` 新增 `scrimLevel`（默认 `"custom"`，旧调用零变化），
shader 用解析后的有效值；`OverviewPage` 16 卡与 `SurfacesPage` QML 卡删除手写
`0.47/0.75` 与 tint 三元式，改为 `scrimLevel: "balanced"`。
逐表面 preset 见下节。截图：`g10j-overview-dark.png`、
`g10j-surfaces-light.png`；`run.log` 无 QML/shader 报错（仅 wallpaper
colorquantizer 警告）。视觉与对齐前一致（本次只统一来源，不改强度）。

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
- [ ] G10k 文档回填 + 最终截图 + DONE

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
| notification | | |
| dialog | | |
| motion 页 toast | | |
| tooltip 页内基准 | | |
| decision 三条 lane | | |
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

G10k — 文档回填 + 最终截图 + DONE。先补齐矩阵中仍空着的格子（notification、
dialog、motion 页 toast、tooltip 页内基准、decision 三条 lane），各取 dark/light
截图并写结论；随后回填 SPEC / INVENTORY / DEMO / LEDGER，更新最终 dark/light
截图。矩阵无「仍差」后才在 `tmp/glass/state.md` 单独一行写 `DONE`。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
