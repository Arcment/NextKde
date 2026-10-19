# 液态玻璃 Gallery — G2（弹层页）

## 本轮
G2e 已交付：GlassNotificationCard（容器 radius 24 · 3 条 entry radius 16 ·
「+2 条」分组 pill radius 16 · 字阶 17/13/11/10 · hover 描边+提亮），
卡片宽 360，居页面内容区；`GALLERY_POPUP=notification` 自动展示。

## 队列（✅=已交付）
- [x] G2a 弹层页骨架 + GlassPopover（宿主 / 阴影 / 自动演示开关）
- [x] G2b GlassMenu（项高 28 / radius 8 / padding 8 / 键盘导航）
- [x] G2c GlassTooltip（thick / radius 10 / 70ms / 贴边 -6）
- [x] G2d GlassToast（regular / readable / pill / 1600ms，与现役并排）
- [x] G2e GlassNotification 卡片族（卡片 24 / entry 16 / 字阶 17-13-11-10）
- [ ] G2f 收口：五类 light/dark 截图 + 仍差清单

## 已改（G2e）
- 新增 `shell/gallery/components/GlassNotificationCard.qml`：`LiquidGlassPanel`
  子类；material regular、radius 24、cornerExponent 2.0；宽 360，高 308
  （12 padding + 24 header + 10 + 3×68 entry + 2×6 + 8 + 26 pill + 12）。
  3 条 entry（高度 68、radius 16、内边距 10/7）：标题 13 Medium、正文 13、
  次要 11 Medium、时间戳 10；图标底座 26×26 radius 8。
  分组 pill 高 26、radius 16、文字 11 Medium「+2 条」。
  hover：entry/pill 填充不透明度 0.05→0.11，描边 0.10→0.36（描边+提亮）。
- `PopupsPage.qml`：`notificationShown` 状态；通知演示时隐藏 token 汇总列
  （360px 卡片与汇总列在 704×704 内容区无法并排），卡片居中 y=100，
  下方 caption 标注 token；Esc 关闭；演示 Timer 覆盖 notification。
- 截图：`tmp/glass/g2e-notification-light.png`、`g2e-notification-dark.png`；
  run.log 仅 wallpaper 警告，无 ERROR / TypeError / Non-existent。
- 视觉核对（截图实测）：卡片左缘约 x 452、宽 360；容器角明显大于 entry 角
  （24 vs 16）；entry 三条约 68–70 高、间距 6；pill 26；正文单行不截断
  （333px 宽度内），标题/正文/次要/时间戳分别为 13/13/11/10；无 9px。

## 仍差 top 6
1. Toast 存留 1600ms 与显 150 / 隐 180、0.96→1 动效只按代码落地，
   静态截图不能判；SPEC §7-① 仍待裁定。
2. dark 下 glass fallback 为近白文字：通知卡白字落在黄色背景区可读性弱，
   与现役在 KWin 效果下的表现不等价（fallback-vs-fallback）。
3. Tooltip 贴边 `-6` 实测仍约 5–7px 间隙（SPEC §7-② A/B 待裁定）。
4. 菜单打开后键盘焦点归属未验证；Up/Down/Return 挂在主窗口 Shortcut。
5. Notification hover（描边+提亮）无法用静态截图验证，只按代码落地。
6. 弹层窗口透明阴影余量计入输入区域（popover/menu 未做 mask）；tooltip 无此问题。
   附：notification 演示会隐藏 token 汇总列（版面取舍，Esc 后恢复）。

## 环境检查点
- 本 VM 屏幕 1280×800；`ext-background-effect-v1 is not supported`
  为预期噪声；wallpaper colorquantizer 警告无关。
- `magick` / `convert` 不存在，裁图用 PIL：`python3 -c "from PIL import ..."`。

## Next round
G2f 收口 — 读 `.loop/TASK.md` G2f：五类弹层 light/dark 截图补齐
（g2a/g2b/g2c/g2d/g2e 现有图核对，缺的补拍）；state.md 写「仍差 top 6」
与「外推待确认」（含 700ms hover、锚点间距 8、tooltip -6 / 1600ms 待裁定）；
核对 `docs/design/liquid-glass/DEMO.md` §2/§5 与实际的轮次/组件行，
只改这两节；完成后 state.md 单独一行写 `DONE`。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake。
- 每轮结束前：截图 + state.md + commit。
- 队列全部完成后，在下面单独一行写 `DONE`。
