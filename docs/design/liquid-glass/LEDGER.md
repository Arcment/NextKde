# 液态玻璃 Gallery — G11（修正 panel 采样缺口 + 矩阵复核）

## 用户裁定（不变）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. 按局部背景的颜色/暗度着色，对齐 KWin 液态玻璃插件。
3. 极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G11c — 复核 toast / tooltip / menu / notification / dialog（dark/light）。

截图（`tmp/glass/`）：`g11c-toast-{dark,light}`、`g11c-tooltip-{dark,light}`、
`g11c-menu-{dark,light}`、`g11c-notification-{dark,light}`、
`g11c-dialog-{dark,light}`；局部放大图在 `tmp/gallery/g11c-*zoom.png`。

- toast ✅：dark 玻璃压成暗酒红/暗青、白字可读；light 提亮为浅粉/浅青、
  深字可读。ActionFeedbackToast 与基准 GlassToast 两枚都出现采样压缩；
  跨青/品红边界的内部颜色为连续渐变，无硬边。
- tooltip ✅：dark 暗红玻璃 + 白字；light 浅粉玻璃 + 深字，均与玻璃外
  亮红明显不同，主/次行可读。
- menu ✅：dark 暗酒红玻璃、白字与禁用灰字可读；light 浅粉玻璃、深字与
  禁用灰字可读；均无旧兜底平涂。
- notification ✅：dark 暗红→暗橄榄跨红/黄边界连续，白字与灰字可读；
  light 浅粉→浅黄连续，深字可读。底部 “+2 条” 分组 pill 跨象限仍连续。
- dialog **仍差**：卡片内部确有采样（dark 暗暖、light 浅暖，均与亮背景
  明显不同），但 balanced scrim 压不住背后的页内文字：dark 下页内白字
  透过玻璃与次级正文（浅灰）连成一片；light 下页内深字与次级正文混在
  一起。主标题可读，次级正文读起来浑浊，不满足硬标准 2。留待 G11f
  按允许范围把该表面 preset 升到 readable 或加深 tint 后重拍。

运行：10 次起应用均成功，run.log 仅有与玻璃无关的 wallpaper 采样 WARN。

## 上一轮（G11b）
✅ — 复核左栏 nav 与右栏 param panel（dark/light），按新硬标准重判。

- dark `tmp/glass/g11b-overview-dark.png`：nav 红区压成暗红、青区压成暗青，
  与玻璃外的亮红/亮青明显不同；param panel 黄区压成暗橄榄、品红区压成
  暗酒红，与玻璃外的亮黄/品红明显不同。白字与次级灰字均可读。
- light `tmp/glass/g11b-overview-light.png`：nav 红区提亮为浅粉、青区提亮为
  浅青；param panel 黄区提亮为浅黄、品红区提亮为浅粉。深色主字与次级字
  均可读，无深字压暗红。
- 象限交界：nav、param panel 内部红/青、黄/品红过渡均为约 12px 的单调渐变
  （逐行取样中间色连续），无 1px 硬边或色块断裂。
- 两轮起应用 run.log 均无 QML 报错（仅 wallpaper 采样 WARN，与玻璃无关）。

结论：nav 与 param panel 的采样与 scrim 均真生效，两格判 ✅。

## 上一轮（G11a）

`LiquidGlassPanel.backdropItem` 默认值改为 `GlassBackdrop.sourceItem`
（原为 `null`），G10e 注释替换为 G10e/G11 注释；未改 `GlassPopup` /
`GlassTooltip` 的显式传值。起应用确认 nav / param panel / toast / dialog
出现采样压缩，G10「未采样」根因已修复。

## 已确认的根因

- `LiquidGlassPanel.qml:66` 的 `backdropItem` 默认 `null`。
- 只有 `GlassPopup` / `GlassTooltip` 显式传了采样源。
- 所以 nav、param panel、toast、dialog、notification、menu、decision 卡片
  都没有走采样；G10 矩阵对这些格的 ✅ 是误判。

## 队列（✅=已交付）
- [x] G11a `LiquidGlassPanel.backdropItem` 默认接 `GlassBackdrop.sourceItem`
- [x] G11b 复核 nav + param panel（dark/light）
- [x] G11c 复核 toast + tooltip + dialog + notification + menu（dark/light）
- [ ] G11d 复核 decision 三条 lane + motion 页 + tooltip 页内基准（dark/light）
- [ ] G11e 极端边界：象限交界、黑白点、最亮黄区
- [ ] G11f 修正仍差项（只调 preset / tint / ink）
- [ ] G11g 文档回填 + 最终截图 + DONE

## 可读性矩阵（复核时重填；旧结论作废）

| 表面 | dark | light |
| --- | --- | --- |
| 左栏 nav | ✅ 暗红/暗青，主次字可读 | ✅ 浅粉/浅青，深字可读 |
| overview 16 卡 | | |
| surfaces clear/regular/thick | | |
| popover | | |
| menu | ✅ 暗酒红，白字/禁用灰字可读 | ✅ 浅粉，深字/禁用灰字可读 |
| tooltip | ✅ 暗红，白字可读 | ✅ 浅粉，深字可读 |
| toast | ✅ 暗酒红/暗青，白字可读（两枚均采样） | ✅ 浅粉/浅青，深字可读 |
| notification | ✅ 暗红→暗橄榄，白/灰字可读 | ✅ 浅粉→浅黄，深字可读 |
| dialog | 仍差：balanced scrim 压不住页内白字，次级正文浑浊 | 仍差：页内深字与次级正文混在一起 |
| motion 页 toast | | |
| tooltip 页内基准 | | |
| decision 三条 lane | | |
| param panel（文字最密） | ✅ 暗橄榄/暗酒红，密文可读 | ✅ 浅黄/浅粉，密文可读 |
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

G11d — 复核 decision 三条 lane + motion 页 + tooltip 页内基准（dark/light），
逐格按新硬标准重判。

## 注意

- `GALLERY_POPUP` 的值必须小写（`popover|menu|tooltip|toast|notification|dialog`）；
  PopupsPage 的 demo timer 用全小写比较，传 `Tooltip`/`Toast` 等大写值不会弹层
  （本轮首次截图因此是空页，已重拍）。
- G11c 遗留：dialog 两主题均判「仍差」，G11f 修（允许 preset 升 readable /
  调 tint，不许改曲线）。
- 只改任务书第六节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
