# 液态玻璃 Gallery — G2（弹层页）

## 本轮
G2c 已交付：GlassTooltip（thick / radius 10 / 70ms / 贴边 -6 / 悬停 700ms）。

## 队列（✅=已交付）
- [x] G2a 弹层页骨架 + GlassPopover（宿主 / 阴影 / 自动演示开关）
- [x] G2b GlassMenu（项高 28 / radius 8 / padding 8 / 键盘导航）
- [x] G2c GlassTooltip（thick / radius 10 / 70ms / 贴边 -6）
- [ ] G2d GlassToast（regular / readable / pill / 1600ms，与现役并排）
- [ ] G2e GlassNotification 卡片族（卡片 24 / entry 16 / 字阶 17-13-11-10）
- [ ] G2f 收口：五类 light/dark 截图 + 仍差清单

## 已改（G2c）
- 新增 `shell/gallery/components/GlassTooltip.qml`：独立 AnimatedPopupWindow
  宿主（不复用 GlassPopup：工具提示无浮层阴影、无卡片内边距，窗口 = 面板）；
  open/close 70ms；`PopupAnchorBinding` + `anchors edges/gravity Bottom`、
  `margins.bottom: -6`（照 StatusTooltip non-dock 写法，SPEC §7-② 待裁定）；
  `LiquidGlassPanel` material thick、radius 10、cornerExponent 2.0；
  primary Callout 12 DemiBold + secondary Footnote 10 Medium，间距 3，
  左右留白 9、上下留白 6。
- `PopupsPage.qml`：接入 tooltip；`GALLERY_POPUP=tooltip` 300ms 后直接显示；
  Tooltip 锚点按钮 HoverHandler/MouseArea hover → 700ms Timer 后显示，
  移出立即关（700ms 为外推）；Esc 关闭；token 摘要补 GlassTooltip 段。
- 截图：`tmp/gallery/g2c-tooltip-light.png`、`g2c-tooltip-dark.png`；
  run.log 无 ERROR / TypeError / Non-existent。
- 视觉核对：primary/secondary 两行、字号 12/10、radius 10、面板高约 44，
  水平居中于 Tooltip 按钮；thick 下 light/dark 均可读。

## 仍差 top 6
1. Tooltip 贴边 `-6` 实测视觉为**约 5–7px 间隙**（锚点按钮下缘 y≈148，
   面板上缘 y≈153，4x 裁块测量，玻璃高光有 ±1px 误差），并非重叠。
   本轮照 StatusTooltip non-dock 同写法实现；是否应改成重叠见 SPEC §7-②
   A/B 裁定，未擅改。
2. 悬停 700ms 阈值为外推（SPEC 未定），需真机手感确认；静态截图无法判。
3. 菜单打开后是否抢键盘焦点未验证；Up/Down/Return 挂在主窗口 Shortcut，
   弹层内按键行为待真机确认。
4. 说明区固定 y=300，G2d/G2e 内容继续增加时需重排（工具提示段已贴近底部，
   当前 y≈600 结束，仍有空间）。
5. 阴影浅色下偏灰，未与 SPEC 逐像素比对；`kscreen-doctor --dpms on`
   曾 core dump，但截图正常（约 200–213KB，非纯白）。
6. 弹层窗口的透明阴影余量计入输入区域（未做 mask）；tooltip 窗口=面板，
   无此问题，但 popover/menu 仍未处理。

## 环境检查点
- 本 VM 屏幕 1280×800；`ext-background-effect-v1 is not supported`
  为预期噪声；wallpaper colorquantizer 警告无关。
- `magick` / `convert` 不存在，裁图用 PIL：`python3 -c "from PIL import ..."`。

## Next round
G2d — 读 `.loop/TASK.md` G2d 条目，做 GlassToast：LiquidGlassPanel 子类、
material regular、`scrimLevel: "readable"`、radius = height/2、高 36、
Callout 12 Medium；显 150 / 隐 180ms + scale 0.96→1、`timeout: 1600`；
页面底部居中常驻宿主 + 「发一条」按钮；`GALLERY_POPUP=toast` 用 `timeout: 0`
常显并标「演示模式常显；实际存留 1600ms（SPEC §7-① 待裁定）」；
与现役 `ActionFeedbackToast` 并排同文案，caption 标「现役 / 基准」；
截图 toast light/dark。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake。
- 每轮结束前：截图 + state.md + commit。
- 队列全部完成后，在下面单独一行写 `DONE`。
