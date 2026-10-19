# 液态玻璃 Gallery — G1

## 本轮（G1d 收口 · 通过）
- `docs/design/liquid-glass/DEMO.md` §1 已改为实测定案：入口
  `shell/gallery.qml` + 页面 `shell/gallery/`，启动 `qs -p shell/gallery.qml`；
  写明原因（真实组件依赖 Quickshell；`qs.*` 根必须是 `shell/`）；
  原 `apps/gallery/` + `KOS_BUILD_GALLERY` 方案标注作废。§2 及其后未动。
- 本轮无代码改动、无截图（收口轮）。

## 已改（G1 全程）
- 新增 `shell/gallery.qml`（背景板 + gallery 两个 PanelWindow，主题按
  `GALLERY_THEME` 应用）。
- 新增 `shell/gallery/`：`GalleryRoot.qml`（220 宽导航）、`SurfacesPage.qml`、
  `OverviewPage.qml`、`ParamPanel.qml`、占位页。
- 更新 `docs/design/liquid-glass/DEMO.md` §1（本轮）。
- state.md 滚动记录。

## 仍差（top 6）
1. 三档卡片横跨背景板四象限（x=640 竖缝穿过 regular 卡），
   clear/regular/thick 的 tint 对比被底色差异干扰；G2 润色时可在三卡后加
   一条统一底色预览条。
2. 三档共用参数面板的 blur 覆盖（G1c 要求实时作用于全部预览），
   SPEC §2.1 每档默认模糊 3/8/12 未呈现；caption 如实标同一 L8。
3. 现役 `KosFloatPanel` cornerExponent = 3.0 ≠ SPEC §2.2 玻璃系 2.0，
   G1 不改现役组件，caption 如实标 3.0，待 G2 统一。
4. `KosFloatPanel` 打开按钮与 `ControlCenterGlass` blur 覆盖未经交互/截图确认
   （静态截图无法验证点击路径）。
5. A 层 `LiquidGlassSurface` 在隔离进程中 ambient 为 transparent，
   深色下 tint 偏弱（既有环境限制）。
6. 参数面板下方「动效」区压到背景板象限分界（y=400），
   黄/品红交界穿过面板，观感偏花；非功能问题，G2 可调整背景板分区。

## 外推待确认
- 受控背景板只证明「有壁纸内容时」的透光差异；真实桌面壁纸（明暗不均、
  高频细节）下三档材质的可辨识度未验证，需在 G2/G5 实机桌面复核。
- 本次均在隔离配置进程中截图；隔离进程的 ambient 与现役桌面外壳不同，
  A 层表现可能偏弱（见仍差 5），迁移结论以实机外壳为准。
- 交互路径（按钮点击、Esc 关闭、参数实时联动）仅有代码依据，静态截图未覆盖，
  需 G2 人工交互确认。

## 已定案（不要再论证）
- gallery 是 Quickshell 配置：入口 `shell/gallery.qml`，页面 `shell/gallery/`。
- 两个 `PanelWindow`：背景板 `WlrLayer.Top`，主体 `WlrLayer.Overlay`。
- 主题应用必须晚于 `AppearanceConfigService._load()` 异步回调。
- 截图全透明 = DPMS 黑屏；先 `ydotool mousemove --absolute` 唤醒。
- 截图脚本 `pkill` 必须 `^qs -p shell/gallery.qml` 锚定；裁图用 PIL。

## Next round
G2（待任务书下发）。

DONE
