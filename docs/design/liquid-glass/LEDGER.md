# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10g 已完成（dark 上半 7 格）。截图：`g10g-overview-dark.png`（nav +
overview 16 卡）、`g10g-surfaces-dark.png`、`g10g-popover-dark.png`、
`g10g-menu-dark.png`、`g10g-tooltip-dark.png`、`g10g-toast-dark.png`。
逐格结论见下方矩阵 dark 列。`run.log` 无 QML/shader 报错（仅 wallpaper
colorquantizer 警告）。

**本轮发现的采样缺陷（未修，已回退尝试）**：overview 的 16 个 Repeater/Grid
卡片无论位于红/黄/青/品红哪个象限，玻璃面色都几乎相同（约 `rgb(152,42,41)`，
即顶左红区被压暗后的颜色）；像素采样证明 col3/col4 的卡片跨到黄区也不变色。
对照同页直接实例化的 `LiquidGlassSurface`（surface 页 regular 卡）能正确采到
黄区，说明问题只在 positioner 摆放的 delegate 上。曾按「mapToItem 非响应式、
定位后 sourceRect 未刷新」假设在 `Component.onCompleted` 里加
`Qt.callLater(_sceneRevision++)`，重截 `g10g-overview-dark2.png` 后像素完全相同，
已回退该改动。需在 G10i/G10x 继续定位（候选：delegate 定位后 mapToItem 仍返回
旧值；或同一 sourceItem 的多个 ShaderEffectSource 纹理复用错误）。

## 队列（✅=已交付）
- [x] G10a 背景板组件化 + 主窗口隐藏采样副本 + `GlassBackdrop` 单例
- [x] G10b `scene_liquid.frag` + `compile.sh` + 烘焙
- [x] G10c `LiquidGlassSurface` 场景采样 + `LiquidGlassPanel` 转发
- [x] G10d 主窗口表面启用 scrim + 首轮截图
- [x] G10e 弹窗窗口局部采样（`GlassPopup` / `GlassTooltip`）
- [x] G10f Toast/Tooltip 页内基准 + 通知/菜单/对话框页启用 scrim
- [x] G10g 深色主题可读性矩阵（上半）
- [ ] G10h 浅色主题可读性矩阵（下半）
- [ ] G10i 极端边界复检（象限交界 / 黑白点 / 最亮黄区）
- [ ] G10j 与 KWin 预设强度对齐
- [ ] G10k 文档回填 + 最终截图 + DONE

## 可读性矩阵（G10g 起每轮至少填一格）

| 表面 | dark | light |
| --- | --- | --- |
| 左栏 nav | ✅ 白字可读（balanced）；青区对比偏低但可辨 | |
| overview 16 卡 | ⚠ 文字可读，但 16 卡采样错位（均取顶左红区，见本轮缺陷记录） | |
| surfaces clear/regular/thick | 外推：三档是 KWin 路径演示（useKwinEffect:true），红线不改；无 KWin 时不着色、黄区白字不可读。同页 QML 卡（regular+balanced）采样正确、可读 | |
| popover | ✅ 红区白/次级文字可读（未启用 scrim，旧行为） | |
| menu | ✅ balanced 黑 tint 压暗红区，白字清晰 | |
| tooltip | ✅ thick + 局部采样，白/次级文字清晰 | |
| toast | ✅ 基准 GlassToast（readable）白字可读；同组 ActionFeedbackToast 为 KWin 路径（无 KWin 时只剩文字，外推） | |
| notification | | |
| dialog | | |
| motion 页 toast | | |
| tooltip 页内基准 | | |
| decision 三条 lane | | |
| param panel（文字最密） | | |
| 象限交界 / 黑白点最坏情况 | | |

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

G10h — 浅色主题可读性矩阵（下半）：`GALLERY_THEME` 走 shot.sh 的 light 参数，
按任务书第九节表格填 light 列，优先 nav / overview / surfaces / popover /
menu / tooltip / toast（与 G10g 对称）。注意 `GALLERY_POPUP` 用小写值。
同时留意 G10g 记录的 16 卡采样错位缺陷：若 light 下同样出现「跨象限不变色」，
在 ledger 对应格注明，并准备在 G10i 一并定位（不要在 G10h 里展开调试）。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
