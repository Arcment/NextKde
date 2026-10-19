# 液态玻璃 Gallery — G10（无 KWin 场景采样 + 极端背景可读性）

## 用户裁定（已定，不再论证）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. QML 兜底要按局部背景的颜色/暗度着色，做法对齐 KWin 液态玻璃插件。
3. 在四色高饱和背景板上做到极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G10c 已完成：`LiquidGlassSurface` 增加 `backdropItem`（默认指向
`GlassBackdrop.sourceItem`）、`scrimEnabled/scrimCap/scrimDecay/scrimTint/
scrimOpacity`、`sceneSampling` / `sceneSourceRect` 与 1/6 捕获 +
`scene_liquid.frag.qsb` 的 `ShaderEffect`；场景采样时根 Rectangle 变
transparent、旧的自适应 scrim 关闭；`backdropItem == null` 时所有新分支
不生效，保持旧行为。`LiquidGlassPanel` 把 preset 解析后的 cap/decay 与
tint 转发给 bodySurface（仅 `!useKwinEffect` 时开 scrim）。起应用后
`run.log` 只有 wallpaper colorquantizer 警告与 ProxyFloatingWindow 旧警告，
无 QML/shader 报错；nav 等 QML 兜底表面已走采样路径。

## 队列（✅=已交付）
- [x] G10a 背景板组件化 + 主窗口隐藏采样副本 + `GlassBackdrop` 单例
- [x] G10b `scene_liquid.frag` + `compile.sh` + 烘焙
- [x] G10c `LiquidGlassSurface` 场景采样 + `LiquidGlassPanel` 转发
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

G10d — 主窗口表面启用 scrim：`GalleryRoot.qml` nav（balanced）、
`OverviewPage.qml` 16 张占位卡与 `SurfacesPage.qml` 直接使用的
`LiquidGlassSurface`（cap 0.47 / decay 0.75 / tint 跟随主题）、
`ParamPanel.qml`（readable）、`ToastDemo.qml` / `TooltipDemo.qml` 页内面板；
截图 `g10-dark-sampled.png`、`g10-light-sampled.png` 并目视。

## 注意

- 只改任务书第十一节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
