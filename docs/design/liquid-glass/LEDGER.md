# 液态玻璃 Gallery — G11（修正 panel 采样缺口 + 矩阵复核）

## 用户裁定（不变）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. 按局部背景的颜色/暗度着色，对齐 KWin 液态玻璃插件。
3. 极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G11d — 复核 decision 三条 lane + motion 页 toast + tooltip 页内基准（dark/light）。

截图（`tmp/glass/`）：`g11d-decision-toast-{dark,light}`、
`g11d-decision-tooltip-{dark,light}`、`g11d-decision-session-{dark,light}`、
`g11d-motion-toast-{dark,light}`、`g11d-tooltip-baseline-{dark,light}`；
局部放大图在 `tmp/gallery/g11d-toast-{dark,light}-zoom.png`。

- decision ① toast lane ✅：dark 药丸压成暗酒红、白字可读；light 提亮为
  浅粉、深字可读，A/B 两栏一致。卡片玻璃表头跨红/黄为连续暗红→暗橄榄
  （dark）/ 浅粉→浅黄（light）渐变，无硬边。total / elapsed / remaining /
  paused 读数与 consequence 行落在近不透明 lane 上，可读。
- decision ② tooltip lane ✅：dark 药丸暗红 + 白字；light 浅粉 + 深字；
  均与近黑 / 近白 stage 明显不同。anchor chip、gap / anchorB / tipTop /
  state 读数可读，A/B 的 -6 / +4 间隙与读数一致。
- decision ③ session lane ✅：dark 菜单近黑底白字、关机浅红可读；light
  近白底深字、关机深红可读；raw 24/72 与 clamp 44–56 读数均可读，卡片
  玻璃表头跨红/黄连续。
- motion 页 toast ✅：dark 暗红→暗橄榄 stage、药丸暗酒红白字；light
  浅粉→浅黄、药丸浅粉深字；跨红/黄边界连续，hold / effective / state
  读数可读。
- tooltip 页内基准 ✅：dark 暗酒红药丸、白字与浅灰次级可读；light 浅粉
  药丸、深字可读；progress / scale / effective 读数可读，跨象限连续。

运行：10 次起应用均成功，run.log 仅有与玻璃无关的 wallpaper 采样 WARN。

## 上一轮（G11c）

- toast ✅：dark 暗酒红/暗青、白字可读；light 浅粉/浅青、深字可读；
  跨青/品红边界连续。
- tooltip ✅：dark 暗红 + 白字；light 浅粉 + 深字。
- menu ✅：dark 暗酒红、light 浅粉，主字与禁用灰字均可读。
- notification ✅：dark 暗红→暗橄榄、light 浅粉→浅黄，跨象限连续。
- dialog **仍差**：balanced scrim 压不住页内文字，次级正文浑浊；G11f 修。

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
- [x] G11d 复核 decision 三条 lane + motion 页 + tooltip 页内基准（dark/light）
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
| motion 页 toast | ✅ 暗红→暗橄榄，药丸暗酒红白字可读 | ✅ 浅粉→浅黄，浅粉药丸深字可读 |
| tooltip 页内基准 | ✅ 暗酒红药丸，白/灰次级字可读 | ✅ 浅粉药丸，深字可读 |
| decision 三条 lane | ✅ 三 lane 均采样：①暗酒红药丸白字，②暗红药丸白字，③近黑菜单白字；读数可读 | ✅ ①浅粉药丸，②浅粉药丸，③近白菜单深字；读数可读 |
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

G11e — 极端边界：象限交界、黑白点、最亮黄区，逐格重判。

## 注意

- `GALLERY_POPUP` 的值必须小写（`popover|menu|tooltip|toast|notification|dialog`）；
  PopupsPage 的 demo timer 用全小写比较，传 `Tooltip`/`Toast` 等大写值不会弹层
  （本轮首次截图因此是空页，已重拍）。
- G11c 遗留：dialog 两主题均判「仍差」，G11f 修（允许 preset 升 readable /
  调 tint，不许改曲线）。
- 只改任务书第六节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
