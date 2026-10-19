# 液态玻璃 Gallery — G11（修正 panel 采样缺口 + 矩阵复核）

## 用户裁定（不变）

1. 不需要 KWin 仍是首要原则；QML 兜底必须自己成立。
2. 按局部背景的颜色/暗度着色，对齐 KWin 液态玻璃插件。
3. 极端场景可读，scrim 强度对齐 KWin preset。

## 本轮
G11f — 修正仍差项：dialog 升 readable，popover 开 scrim + readable（只调 preset，不改曲线）。

改动（仅 gallery 组件）：
- `shell/gallery/components/GlassDialog.qml`：`scrimLevel` balanced → readable。
- `shell/gallery/components/GlassPopover.qml`：新增 `scrimEnabled: true`、
  `scrimLevel: "readable"`。

截图（`tmp/glass/`）：`g11f-dialog-{dark,light}`、`g11f-popover-{dark,light}`；
局部放大图 `tmp/gallery/g11f-{dialog,popover}-{dark,light}-zoom.png`。
四张均以 `GALLERY_SCRIM=qml`（QML 兜底路径）拍摄。

- dialog dark ✅：卡内上半为暗红→暗橄榄、下半为暗青/暗酒红，与卡外亮红
  /亮黄明显不同；标题白字与次级灰字均可读，G11c 的页内文字透叠不再出现。
  红/黄、红/青、黄/品红交界为连续渐变，无硬边。
- dialog light ✅：卡内为浅粉/浅黄/浅青/浅粉，与卡外亮红/亮黄明显不同；
  深色标题与次级字均可读，无页内深字混叠；交界连续。
- popover dark ✅：卡内压成暗酒红，与卡外亮红/板红明显不同；白标题与
  灰色次级行可读。
- popover light ✅：卡内提亮为浅粉，与卡外亮红明显不同；深色标题与
  次级行可读。
- 起应用 4 次均成功（`QT_FORCE_STDERR_LOGGING=1`），run.log 仅有与玻璃
  无关的 wallpaper 采样 WARN。

dialog 与 popover 两格改判 ✅，矩阵已无「仍差」。surfaces
clear/regular/thick 仍为 KWin 路径外推（无 KWin 时 dark 亮黄区不可读），
如实保留。

## 上一轮（G11e）
G11e — 极端边界：象限交界、黑白点、最亮黄区，逐格重判（dark/light）。

截图（`tmp/glass/`）：`g11e-overview-{dark,light}`、`g11e-popover-{dark,light}`；
局部放大图 `tmp/gallery/g11e-{dark,light}-{junction,nav,param,yellow,trio,paramtop,navtop}-zoom.png`。

- nav ✅：红/青象限交界在玻璃内为 y 390→406 的 16px 单调渐变（逐行取样），
  无 1px 硬边；40 个黑白点被采样成连续软斑，白点落在 “G1 骨架” 行下方时
  次级字仍可辨认。dark 暗红/暗青、light 浅粉/浅青，均与板色明显不同。
- param panel ✅：黄/品红交界同样为 16px 渐变。最亮黄区 dark 压成暗橄榄
  (90,80,33)、light 提为浅黄 (244,222,126)，与板面 #fdd835 (253,216,53)
  明显不同；密文主次行可读。黑白点落在 slider 行时，文字仍可读。
- overview 16 卡 ✅：四象限内分别压成暗红/暗青/暗橄榄/暗酒红（light 为
  浅粉/浅青/浅黄/浅粉）；位于 (640,400) 四色交界的 GlassNotification 卡
  内部从上到下连续过渡，无硬边；主次字可读。
- surfaces clear/regular/thick **外推**：三档是 `useKwinEffect: true` 的
  KWin 路径演示，QML 不采样。dark 下 thick 卡与说明行在亮黄区为白字压
  亮黄，**无 KWin 时不可读**；light 下深字可读，但玻璃内外颜色几乎一致，
  没有 QML scrim 压缩。该格只作 KWin 演示外推，不算 QML 兜底 ✅。
- popover **仍差**：卡片只采样、未启 scrim（`GlassPopup.scrimEnabled`
  默认 false，`GlassPopover` 未 opt in）。dark/light 卡内均约
  (228,63,60)，与板红 (229,57,53) 几乎一致，不满足硬标准 1；标题/正文
  可读（dark 白字压亮红对比偏低，light 深字可读）。留待 G11f 开 scrim
  （readable preset）或加深 tint 后重拍。
- 运行：6 次起应用均成功，run.log 仅有与玻璃无关的 wallpaper 采样 WARN。

## 上一轮（G11d）
G11d — 复核 decision 三条 lane + motion 页 toast + tooltip 页内基准（dark/light）。

截图（`tmp/glass/`）：`g11d-decision-{toast,tooltip,session}-{dark,light}`、
`g11d-motion-toast-{dark,light}`、`g11d-tooltip-baseline-{dark,light}`；
局部放大图 `tmp/gallery/g11d-toast-{dark,light}-zoom.png`。

- decision ① toast ✅：dark 药丸压成暗酒红、白字可读；light 提亮为浅粉、
  深字可读；A/B 两栏一致。卡片玻璃表头跨红/黄连续（dark 暗红→暗橄榄、
  light 浅粉→浅黄），无硬边。total/elapsed/remaining/paused 与 consequence
  行落在近不透明 lane 上，可读。
- decision ② tooltip ✅：dark 暗红药丸 + 白字；light 浅粉药丸 + 深字，
  均与近黑/近白 stage 明显不同。anchor chip、gap/anchorB/tipTop/state
  读数可读；A/B 的 -6/+4 间隙与读数一致。
- decision ③ session ✅：dark 近黑菜单白字、关机浅红可读；light 近白菜单
  深字、关机深红可读；raw 24/72 与 clamp 44–56 读数可读；表头跨象限连续。
- motion 页 toast ✅：dark 暗红→暗橄榄 stage、暗酒红药丸白字；light
  浅粉→浅黄、浅粉药丸深字；hold/effective/state 读数可读，边界连续。
- tooltip 页内基准 ✅：dark 暗酒红药丸、白字与浅灰次级可读；light 浅粉
  药丸、深字可读；progress/scale/effective 读数可读，跨象限连续。

运行：10 次起应用均成功，run.log 仅有与玻璃无关的 wallpaper 采样 WARN。
decision 三条 lane、motion 页 toast、tooltip 页内基准六格全部判 ✅。

## 上一轮（G11c）
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
- [x] G11e 极端边界：象限交界、黑白点、最亮黄区
- [x] G11f 修正仍差项（只调 preset / tint / ink）
- [ ] G11g 文档回填 + 最终截图 + DONE

## 可读性矩阵（复核时重填；旧结论作废）

| 表面 | dark | light |
| --- | --- | --- |
| 左栏 nav | ✅ 暗红/暗青，主次字可读 | ✅ 浅粉/浅青，深字可读 |
| overview 16 卡 | ✅ 暗红/暗青/暗橄榄/暗酒红，交界卡连续；主次字可读 | ✅ 浅粉/浅青/浅黄/浅粉，交界连续；深字可读 |
| surfaces clear/regular/thick | 外推（KWin 路径）：thick 黄区白字压亮黄，无 KWin 时不可读 | 外推（KWin 路径）：深字可读，但玻璃内外一致，无 scrim 压缩 |
| popover | ✅ readable：卡内压成暗酒红，与卡外亮红明显不同；白/灰字可读 | ✅ readable：卡内提亮为浅粉，与卡外亮红明显不同；深字可读 |
| menu | ✅ 暗酒红，白字/禁用灰字可读 | ✅ 浅粉，深字/禁用灰字可读 |
| tooltip | ✅ 暗红，白字可读 | ✅ 浅粉，深字可读 |
| toast | ✅ 暗酒红/暗青，白字可读（两枚均采样） | ✅ 浅粉/浅青，深字可读 |
| notification | ✅ 暗红→暗橄榄，白/灰字可读 | ✅ 浅粉→浅黄，深字可读 |
| dialog | ✅ readable：暗红→暗橄榄/暗青，页内字不再透叠；主次字可读 | ✅ readable：浅粉→浅黄/浅青，深字主次均可读 |
| motion 页 toast | ✅ 暗红→暗橄榄，药丸暗酒红白字可读 | ✅ 浅粉→浅黄，浅粉药丸深字可读 |
| tooltip 页内基准 | ✅ 暗酒红药丸，白/灰次级字可读 | ✅ 浅粉药丸，深字可读 |
| decision 三条 lane | ✅ ①暗酒红药丸白字，②暗红药丸白字，③近黑菜单白字；读数可读 | ✅ ①浅粉药丸，②浅粉药丸，③近白菜单深字；读数可读 |
| param panel（文字最密） | ✅ 暗橄榄/暗酒红，密文可读 | ✅ 浅黄/浅粉，密文可读 |
| 象限交界 / 黑白点最坏情况 | ✅ 16px 单调渐变；黑白点采样为软斑；nav 次级行可辨认 | ✅ 16px 单调渐变；圆点软斑；主次字可读 |

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

G11g — 文档回填 + 最终截图（dark/light overview + param panel）+ DONE。

## 注意

- `GALLERY_POPUP` 的值必须小写（`popover|menu|tooltip|toast|notification|dialog`）；
  PopupsPage 的 demo timer 用全小写比较，传 `Tooltip`/`Toast` 等大写值不会弹层
  （本轮首次截图因此是空页，已重拍）。
- G11f 已修 G11c/G11e 遗留：dialog 升 readable（`GALLERY_SCRIM=qml` 下两主题
  重拍均 ✅），popover 开 scrim + readable（两主题 ✅）。
- surfaces clear/regular/thick 仍为 KWin 路径外推：无 KWin 时 dark 亮黄区
  白字不可读，light 玻璃内外几乎无压缩；不作 QML 兜底 ✅。
- 只改任务书第六节列出的路径。
- 全部队列项勾完、矩阵无「仍差」后，在下面单独一行写 `DONE`。
