# 液态玻璃 Gallery — G3（Dialog + scrim）

## 本轮
G3c 已交付：6 张验收截图（dark/light × compositor/qml/both）全部拍完并逐张核对，
G3 队列收口。

- 截图按 `.loop/TASK.md` 第五节执行，`GALLERY_PAGE` / `GALLERY_POPUP` /
  `GALLERY_SCRIM` 均与 `shot.sh` 同行前置；6 次启动各自独立。
- 截图：`tmp/glass/g3-{dark,light}-{compositor,qml,both}.png`；
  副本入库 `docs/design/liquid-glass/g3-*.png`。
- `tmp/gallery/run.log` 6 次启动均只有 wallpaper colorquantizer WARN，
  无 QML 报错。

## 逐张核对
- **compositor（dark/light）**：整窗不变暗（与 G3b 结论一致：本 gallery
  页内窗口里 compositor scrim 不作用于整窗）；卡片为厚玻璃；
  三模式按钮 compositor 选中，说明行「compositor scrim 单一来源…QML 无背板」。
- **qml（dark/light）**：整窗黑 0.32 背板清晰可见（参数面板亮度明显下降）；
  卡片走 QML 液态回退，无红边；qml 按钮选中。
- **both（dark/light）**：整窗变暗 + 卡片 2px 红边 +
  「违规：compositor scrim × QML 背板双重变暗」；卡面亮度低于周围背板
  （双重变暗肉眼可辨）；both 按钮选中。
- **token（六张一致）**：标题 22/26 SemiBold、正文 13/16、按钮高 28、
  卡片 padding 20、surface radius 24、按钮右对齐 gap 8、宽 360（外推）。
- 静态截图不能判动效；150/140ms 与 scale 0.96→1 仍以代码与动效页为准。

## 环境
- 上一轮浮在背景板中央的 KWin「调试控制台」已关闭：本轮用 KWin DBus
  脚本对匹配标题的窗口调用 `closeWindow()`，只做窗口管理，未改 KWin
  配置/源码。六张截图无遮挡。

## 队列（✅=已交付）
- [x] G3a GlassDialog 基准组件（四态 + SPEC §3.2 token）
- [x] G3b scrim 三模式（compositor / qml / both）
- [x] G3c 6 张验收截图 + ledger 收口

DONE

## 仍差
- compositor scrim 在 gallery 页内窗口**不可见**：`useKwinEffect` 下 scrim
  只加深卡片自身表面，不调暗整窗；两次尝试（balanced / readable）结论一致。
  正确实现应为独立 scrim 表面或 KWin 侧 dialog scrim，属组件/KWin 变更，
  不在 gallery 轮范围。按纪律未改 KWin、未用 QML 背板伪造。
- 静态截图不能判开合动效，动效验收仍差一次 live 观察。

## 外推（SPEC 未定，记 ledger）
- 对话框宽 360；按钮水平内边距 14、按钮 radius 8、内容 spacing 12、
  标题→正文 12；点击背板关闭。
- scrim 按钮行：高 30、radius 9、gap 8、标签 12 / 说明 11 —— gallery 自定。
- compositor 全窗变暗需独立 scrim 表面（或 KWin 侧 dialog scrim），
  不在 gallery 轮范围。

## 已定案（不要再论证）
- gallery 页内模态覆盖层，不新开窗口；不改现役组件、不碰 KWin。
- compositor scrim 走 `LiquidGlassPanel.useKwinEffect + scrimEnabled`；
  QML 背板 = 全窗 Rectangle 黑 0.32。
- 环境变量：`GALLERY_PAGE=popups`、`GALLERY_POPUP=dialog`、
  `GALLERY_SCRIM=compositor|qml|both`，必须与 shot.sh 同行前置。
- 截图名：`g3-{dark,light}-{compositor,qml,both}`。
- 上一批 S3（scene/tonal ink）已交付，勿重做。
