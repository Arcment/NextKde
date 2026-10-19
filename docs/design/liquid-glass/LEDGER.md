# 液态玻璃 Gallery — G11（修正 panel 采样缺口 + 矩阵复核）

## 用户裁定（不变）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. 按局部背景的颜色/暗度着色，对齐 KWin 液态玻璃插件。
3. 极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G11a ✅ — `LiquidGlassPanel.backdropItem` 默认值改为
`GlassBackdrop.sourceItem`（原为 `null`），G10e 注释替换为 G10e/G11 注释。
未改 `GlassPopup` / `GlassTooltip` 的显式传值。

起应用（dark，`QT_FORCE_STDERR_LOGGING=1`，run.log 无 QML 报错）确认采样已出现：

- `tmp/glass/g11a-overview-dark.png`：左栏 nav 在红/青象限分别压成暗红/暗青，
  右参数面板在黄/品红象限分别为暗橄榄/暗酒红；白字与次级字均可读。
- `tmp/glass/g11a-toast-dark.png`：toast 在品红上压成暗酒红，白字可读。
- `tmp/glass/g11a-dialog-dark.png`：dialog 跨红/黄/品红三块色带连续过渡，
  无硬边，白字与次级字均可读。

结论：G10 的「未采样」根因已修复；G11b 起按新硬标准重判矩阵。

## 已确认的根因

- `LiquidGlassPanel.qml:66` 的 `backdropItem` 默认 `null`。
- 只有 `GlassPopup` / `GlassTooltip` 显式传了采样源。
- 所以 nav、param panel、toast、dialog、notification、menu、decision 卡片
  都没有走采样；G10 矩阵对这些格的 ✅ 是误判。

## 队列（✅=已交付）
- [x] G11a `LiquidGlassPanel.backdropItem` 默认接 `GlassBackdrop.sourceItem`
- [ ] G11b 复核 nav + param panel（dark/light）
- [ ] G11c 复核 toast + tooltip + dialog + notification + menu（dark/light）
- [ ] G11d 复核 decision 三条 lane + motion 页 + tooltip 页内基准（dark/light）
- [ ] G11e 极端边界：象限交界、黑白点、最亮黄区
- [ ] G11f 修正仍差项（只调 preset / tint / ink）
- [ ] G11g 文档回填 + 最终截图 + DONE

## 可读性矩阵（复核时重填；旧结论作废）

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

## 判 ✅ 的硬标准

1. 玻璃内部颜色与玻璃外同一背景明显不同（scrim 真生效）。
2. 主/次文字都能读。
3. 跨象限颜色连续。

不满足写「仍差」。KWin 路径演示可标外推，但要写明无 KWin 时不可读。

## 已确认的架构（不要重开）

- 可见背景板窗口保留；主窗口内隐藏副本 + `hideSource` 捕获。
- `GlassBackdrop.sourceItem` 为 `null` 时所有路径回到旧行为。
- 弹窗用 `GalleryBackdropSample`（按 `anchor.rect.x/y` 平移）。
- shader 用 KWin 的 `adaptiveScrim` 原式；preset
  readable 0.72/1.0、balanced 0.47/0.75、transparent 0.22/0.5、subtle 0.15/0.45。

## Next round

G11b — 复核 nav + param panel（dark/light），按新硬标准逐格重判。

## 注意

- 只改任务书第六节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
