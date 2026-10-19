# 液态玻璃 Gallery — G3（Dialog + scrim）

## 本轮
G3b 已交付（scrim 三模式接线 + `GALLERY_SCRIM` 透传）。
- `shell/gallery/GalleryRoot.qml:24-27` — 根层 `scrimMode` 由
  `GALLERY_SCRIM=qml|both` 初始化，其余（含未设）为 `compositor`。
- `shell/gallery/GalleryRoot.qml:214` — 下发给 `GlassDialog.scrimMode`。
- `shell/gallery/GalleryRoot.qml:240-241` — 下发给 `PopupsPage` 并接收切换信号，
  保证三模式全局互斥。
- `shell/gallery/PopupsPage.qml:25-33` — 页面 scrimMode / 三模式列表 /
  各模式说明文案 / `scrimModeSelected` 信号。
- `shell/gallery/PopupsPage.qml:204-261` — anchor 行下方新增互斥按钮行
  compositor · qml · both（选中态填充 + 提亮描边），下方一行说明当前来源。
- `GlassDialog.qml` 未改契约（G3a 已内建 compositor/qml/both 分支）。

## 验证（dark，tmp/glass/）
- g3b-dark-compositor：页面三按钮在、compositor 选中；卡片正常；**背景无变暗**。
- g3b-dark-qml：整窗明显变暗（黑 0.32），卡片为 QML 浅色回退 + 深色文字。
- g3b-dark-both：整窗变暗 + 卡片 2px 红边 +「违规：compositor scrim × QML
  背板双重变暗」文案，均可见。
- g3b-dark-compositor-readable：compositor 第 2 次尝试（scrimLevel 临时
  `readable`），背景仍无任何变暗，仅卡片自身略加深；已恢复 `balanced`。
- 4 次启动 `run.log` 均无 QML 报错，仅 wallpaper colorquantizer WARN。

## 队列（✅=已交付）
- [x] G3a GlassDialog 基准组件（四态 + SPEC §3.2 token）
- [x] G3b scrim 三模式（compositor / qml / both）
- [ ] G3c 6 张验收截图 + ledger 收口

## 仍差
- compositor scrim 在 gallery 层窗口内**不可见**：两次尝试（balanced / readable）
  下导航、参数面板、背景板亮度与无 scrim 时一致。KWin scrim 只作用于
  `LiquidGlassPanel` 自身表面区域（卡片自身会加深），不会调暗整窗；
  页内覆盖层无法得到「整窗变暗」。按纪律未改 KWin、未用 QML 背板伪造。
- 环境：KWin「调试控制台」窗口仍浮在背景板中央（非 gallery 窗口），
  污染全部截图；`showDebugConsole` DBus 只置顶不关闭，需人工关闭。
- G3c 的 3 张 light 截图尚未拍；本轮只验证 dark 三模式。

## 外推（SPEC 未定，记 ledger）
- scrim 按钮行：高 30、radius 9、gap 8、标签 12 / 说明 11 —— gallery 自定。
- compositor 全窗变暗的正确实现应为独立 scrim 表面（或 KWin 侧 dialog scrim），
  属组件/KWin 变更，不在 gallery 轮范围。
- 对话框宽 360；按钮水平内边距 14、按钮 radius 8、内容 spacing 12、
  标题→正文 12；点击背板关闭。

## 必须做（来自 DEMO.md / SPEC §3.2）
1. `GlassDialog`：radius 24、material thick、标题 22/26 SemiBold、
   正文 13/16、按钮高 28、padding 20、四态、150/140ms + scale 0.96→1。
2. 集成 `PopupsPage`：anchor 行加 Dialog；`GALLERY_POPUP=dialog` 自动打开。
3. scrim 三模式：compositor / qml / both；both 加红边与违规说明。
4. 6 张截图：dark/light × 三模式。

## 已定案（不要再论证）
- gallery 页内模态覆盖层，不新开窗口；不改现役组件、不碰 KWin。
- compositor scrim 走 `LiquidGlassPanel.useKwinEffect + scrimEnabled`；
  QML 背板 = 全窗 Rectangle 黑 0.32。
- 环境变量：`GALLERY_PAGE=popups`、`GALLERY_POPUP=dialog`、
  `GALLERY_SCRIM=compositor|qml|both`，必须与 shot.sh 同行前置。
- 截图名：`g3-{dark,light}-{compositor,qml,both}`。

## 上一批（S3 已交付，勿重做）
- scene/tonal ink 判定已统一到 `mix(rowLum, tintLum, tintStrength)`，阈值 0.34。
- 四张 s3-* 截图与 ledger 已推送；不要再改 ScenePage。

## Next round
G3c — 按 `.loop/TASK.md` 第五节拍 6 张（dark/light × 三模式），逐张读
token，写 ledger，勾选后写 `DONE`。截图前先确认调试控制台是否已人工关闭。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
