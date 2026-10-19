# 液态玻璃 Gallery — G2（弹层页）

## 本轮
G2a 已交付：弹层页骨架 + GlassPopover。

## 队列（✅=已交付）
- [x] G2a 弹层页骨架 + GlassPopover（宿主 / 阴影 / 自动演示开关）
- [ ] G2b GlassMenu（项高 28 / radius 8 / padding 8 / 键盘导航）
- [ ] G2c GlassTooltip（thick / radius 10 / 70ms / 贴边 -6）
- [ ] G2d GlassToast（regular / readable / pill / 1600ms，与现役并排）
- [ ] G2e GlassNotification 卡片族（卡片 24 / entry 16 / 字阶 17-13-11-10）
- [ ] G2f 收口：五类 light/dark 截图 + 仍差清单

## 已改（G2a）
- 新增 `shell/gallery/PopupsPage.qml`：5 个锚点按钮行 + token 摘要区；
  `GALLERY_POPUP=popover` 加载后 300ms 自动打开；Esc 关闭。
- 新增 `shell/gallery/components/GlassPopover.qml`：AnimatedPopupWindow +
  PopupAnchorBinding；LiquidGlassPanel radius 16 / regular / 内边距 12 /
  cornerExponent 2.0；KosCardShadow 0.30 / 12,16 / 18；1px 描边。
  窗口 = 卡片 + 阴影余量；锚点边距按 `shadowMargin - 8` 补偿，
  实测卡片与按钮底边间距 8–9px（token 8）。
- `GalleryRoot.qml`：`GALLERY_PAGE=popups` → index 2；弹层页接入；
  导航注记改为 弹层 G2/G3、控件 G4、动效 G5。
- 截图：`tmp/glass/g2a-popover-dark.png`、`g2a-popover-light.png`。

## 仍差 top 6（G2a 遗留）
1. 截图时首屏若为纯白（4142B），是显示器 DPMS 关闭所致，与代码无关；
   截图前先 `kscreen-doctor --dpms on`。
2. 弹层页说明区固定 y=300，后续 G2b–G2e 按钮/演示变多时需重排。
3. Popover 打开时覆盖左侧导航（锚定在首按钮）；属浮层正常行为，未改。
4. 阴影在浅色下偏灰，未与 SPEC 逐像素比对。
5. `GALLERY_POPUP=menu|tooltip|toast|notification` 目前无动作，待后续轮次。
6. 弹层窗口的透明阴影余量也计入输入区域（未做 mask），交互待验证。

## 环境检查点
- 本 VM 屏幕 1280×800；qs 日志中 `ext-background-effect-v1 is not supported`
  为预期噪声；wallpaper colorquantizer 警告无关。
- `magick` / `convert` 不存在，裁图用 PIL：`python3 -c "from PIL import ..."`。

## Next round
G2b — 读 `.loop/TASK.md` G2b 条目，复用 G2a 宿主与运动，做 GlassMenu
（5 项 / 1 disabled / 1 分隔线 / 项高 28 / radius 8 / Body 13 / padding 8 /
项间距 4 / Up-Down-Enter-Esc / focus 环），截图 `GALLERY_POPUP=menu`。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake。
- 每轮结束前：截图 + state.md + commit。
- 队列全部完成后，在下面单独一行写 `DONE`。
