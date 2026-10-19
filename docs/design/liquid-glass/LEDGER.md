# 液态玻璃 Gallery — G3（Dialog + scrim）

## 本轮（G3b）
- `shell/gallery/GalleryRoot.qml:24-27` — 根层 `scrimMode`，由
  `GALLERY_SCRIM` 取 `qml` / `both`，缺省与其它值为 `compositor`（单一合法来源）。
- `shell/gallery/GalleryRoot.qml:214` — `GlassDialog.scrimMode: root.scrimMode`。
- `shell/gallery/GalleryRoot.qml:240-241` — `PopupsPage` 接收当前模式与
  `scrimModeSelected`，三模式全局互斥，页面与覆盖层同步。
- `shell/gallery/PopupsPage.qml:25-33` — 模式状态、列表、当前来源说明、切换信号。
- `shell/gallery/PopupsPage.qml:204-261` — anchor 行下新增
  compositor / qml / both 三个互斥按钮（选中填充 + 提亮描边）与说明行。
- `GlassDialog.qml` 的 scrimMode 契约沿用 G3a：compositor 走
  `useKwinEffect + scrimEnabled + balanced`，qml 为全窗黑 0.32，both 叠加
  2px 红边与违规文案。

## 验证（dark，tmp/glass/）
- `g3b-dark-compositor`：三按钮在、compositor 选中；卡片 token 正常；背景无变暗。
- `g3b-dark-qml`：整窗黑 0.32 可见；卡片为 QML 浅色回退、深色文字。
- `g3b-dark-both`：整窗变暗 + 卡片 2px 红边 + 违规文案，均可读。
- `g3b-dark-compositor-readable`：第 2 次 compositor 尝试（scrimLevel 临时
  `readable`），背景仍无变暗，仅卡片自身加深；代码已恢复 `balanced`。
- 4 次启动 `run.log` 无 QML 报错；仅 wallpaper colorquantizer WARN。

## 仍差
- compositor scrim 在 gallery 层窗口内不可见（balanced / readable 两次均如此）。
  KWin 的 scrim 只作用于 `LiquidGlassPanel` 自身表面区域，不调暗整窗；
  页内覆盖层无法实现「整窗变暗」。未改 KWin，也未用 QML 背板伪造该效果。
- KWin「调试控制台」窗口位于背景板中央（非 gallery 窗口），污染截图；
  `showDebugConsole` DBus 只置顶不关闭，需人工关闭。
- 3 张 light 截图留待 G3c。

## 外推
- scrim 按钮行高 30 / radius 9 / gap 8 / 标签 12 / 说明 11 为 gallery 自定。
- compositor 全窗变暗需独立 scrim 表面或 KWin 侧 dialog scrim（组件/KWin 变更，
  不在 gallery 轮范围）。
- Dialog 宽 360；按钮水平内边距 14、radius 8、内容 spacing 12、标题→正文 12；
  点背板关闭（SPEC 未定，均为外推）。

## 队列（✅=已交付）
- [x] G3a GlassDialog 基准组件
- [x] G3b scrim 三模式
- [ ] G3c 6 张验收截图 + ledger 收口

## Next round
G3c — 6 张截图（dark/light × compositor/qml/both）+ 逐张 token 核对 + 收口。
