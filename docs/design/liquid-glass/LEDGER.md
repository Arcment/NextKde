# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10f + G10g。G10f：`GlassPopup` 增加 `scrimEnabled` / `scrimLevel` 并转发到
卡片，`GlassMenu` 用 balanced，`GlassNotificationCard` 用 readable，
`GlassDialog` 在 qml 模式下 `scrimEnabled: true` 走 balanced 场景 scrim
（compositor 模式 `useKwinEffect` 仍为 true，KWin 路径不变）；ToastDemo /
TooltipDemo 页内基准复核已是 readable / balanced。

G10g（dark 上半）：截图 `g10g-overview-dark.png`、`g10g-surfaces-dark.png`、
`g10g-popover-dark.png`、`g10g-menu-dark.png`、`g10g-tooltip-dark.png`、
`g10g-toast-dark.png` 已逐格目视，结论见矩阵 dark 列；`run.log` 无
QML/shader 报错（仅 wallpaper colorquantizer 警告）。

G10g 发现一个采样缺陷（未修）：overview 的 16 个 Repeater/Grid 卡片无论
位于哪个象限都呈同一暗红色（约 `rgb(152,42,41)`，即顶左红区压暗值），像素
采样确认跨到黄区也不变色；同页直接实例化的 `LiquidGlassSurface` 采样正常，
问题只出现在 positioner 摆放的 delegate 上。按「定位后 sourceRect 未刷新」
假设加过 `Qt.callLater(_sceneRevision++)`，重截后像素不变，已回退；留待
G10i/G10x 定位。三档材质条是 `useKwinEffect: true` 的 KWin 路径演示，按红线
不改，无 KWin 运行时不着色属外推项。

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
| overview 16 卡 | ⚠ 文字可读，但 16 卡采样错位（均取顶左红区） | |
| surfaces clear/regular/thick | 外推：KWin 路径演示（useKwinEffect:true，红线不改）；无 KWin 时不着色。同页 QML regular 卡采样正确、可读 | |
| popover | ✅ 红区白/次级文字可读（未启用 scrim，旧行为） | |
| menu | ✅ balanced 黑 tint 压暗红区，白字清晰 | |
| tooltip | ✅ thick + 局部采样，白/次级文字清晰 | |
| toast | ✅ 基准 GlassToast（readable）白字可读；ActionFeedbackToast 为 KWin 路径（外推） | |
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

G10h — light 可读性矩阵（下半）：以 `shot.sh light` 按第九节表格填 light 列
（nav / overview / surfaces / popover / menu / tooltip / toast），逐格记录
preset 与结论；同时记录 16 卡采样错位在 light 下是否复现，G10i 一并定位。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
