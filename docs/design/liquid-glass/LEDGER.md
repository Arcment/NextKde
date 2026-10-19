# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10a 已完成：背景板抽成 `GalleryBackdropBoard`，可见窗口与主窗口隐藏副本共用；
`GlassBackdrop` 单例（common qmldir）声明 `sourceItem`，gallery 在
`Component.onCompleted` 与 `showBackgroundBoardChanged` 时切换。
截图 `tmp/glass/g10-dark-board.png`：四象限与 40 个圆点无回归，`run.log`
仅有 wallpaper colorquantizer 警告，无 QML 报错。

## 队列（✅=已交付）
- [x] G10a 背景板组件化 + 主窗口隐藏采样副本 + `GlassBackdrop` 单例
- [ ] G10b `scene_liquid.frag` + `compile.sh` + 烘焙
- [ ] G10c `LiquidGlassSurface` 场景采样 + `LiquidGlassPanel` 转发
- [ ] G10d 主窗口表面启用 scrim + 首轮截图
- [ ] G10e 弹窗窗口局部采样（`GlassPopup` / `GlassTooltip`）
- [ ] G10f Toast/Tooltip 页内基准 + 通知/菜单/对话框页启用 scrim
- [ ] G10g 深色主题可读性矩阵（上半）
- [ ] G10h 浅色主题可读性矩阵（下半）
- [ ] G10i 极端边界复检（象限交界 / 黑白点 / 最亮黄区）
- [ ] G10j 与 KWin 预设强度对齐
- [ ] G10k 文档回填 + 最终截图 + DONE

## 可读性矩阵（G10g 起每轮至少填一格）

| 表面 | dark | light |
| --- | --- | --- |
| 左栏 nav | | |
| overview 16 卡 | | |
| surfaces clear/regular/thick | | |
| popover | | |
| menu | | |
| tooltip | | |
| toast | | |
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

G10b — 逐字写入 `shell/desktop/shaders/scene_liquid.frag`，改 `compile.sh`
并运行烘焙，确认 `scene_liquid.frag.qsb` 生成。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
