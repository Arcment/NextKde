# 液态玻璃 Gallery — G1

## 本轮（G1c 代码交付；截图被环境阻塞，未做视觉判定）
- 新增：`ParamSlider.qml`、`ParamPanel.qml`（右侧常驻可折叠）、
  `MaterialTrio.qml`（clear/regular/thick 同内容三卡）、`OverviewPage.qml`
  （顶部三档 + SPEC §3 的 16 个组件族缩略卡，按 G1/G2/G3/G4 标注）。
- `SurfacesPage.qml`：顶部加入三档材质条（y 58，高 118），四块预览下移到
  y 192；radius / surfaceOpacity / blurStrength 全部绑定参数面板；
  radius 由三档按钮 + 0–32 滑杆实时驱动；caption 显示当前 radius。
- `GalleryRoot.qml`：参数状态转发到两页；主题运行时切换
  （`updateThemeMode` + `updateGlassFollowsAppearanceMode`）；
  默认页改为总览；`GALLERY_PAGE=surfaces` 可让截图流程直接落在表面页；
  内容区宽度随参数面板折叠/展开。
- 应用能起：`run.log` 无 `ERROR` / `TypeError` / `Non-existent`
  （仅 wallpaper 采样 WARN 与 ProxyFloatingWindow 旧告警）。
- **截图失败，阻塞**：`spectacle -b -n -f` 连续两次输出 1280×800
  **全透明**（RGBA alpha 全 0，4142 B）。无 gallery 运行时截当前桌面同样
  全透明，故与本次 QML 无关。11:58 的 G1b 截图正常；12:01 起复现。
  实测活动会话 seat0/tty1、`kscreen-doctor` 输出 enabled 1280x800@60、
  KWin 与 ksmserver 均存活。符合 state 既有的「合成器输出冻结」记录。
  **未做 relogin / 未重启会话**（任务硬约束）。本轮无有效视觉证据。

## 队列（✅=已交付）
- [x] G1a 骨架：能起、能截图
- [x] G1b 表面页：Panel(B 宿主) / Surface(A) / ControlCenterGlass / KosFloatPanel
- [ ] G1c 三档材质 + 参数面板 + 总览页（代码完成，截图与视觉核对待补）
- [ ] G1d 收口：DEMO.md §1 改成实际定案 + 仍差清单

## 仍差（top 6）
1. **G1c 截图未产出**：需先确认合成器输出恢复（单帧 alpha 不再全 0），
   再补 `tmp/gallery/shot.sh light g1c-light`（总览）与
   `GALLERY_PAGE=surfaces tmp/gallery/shot.sh dark g1c-dark`（表面页）。
   环境仍冻结则继续停手记录，不 relogin。
2. 三档材质条与参数面板的间距/字重未经截图核对；SPEC 值已写入代码，
   但「tint 0.10/0.16/0.24 差异一眼可辨」尚无法确认。
3. 主题运行时切换未经截图：`updateGlassFollowsAppearanceMode` 只在启动
   （gallery.qml）验证过；G1c 的按钮走同一函数。
4. `blurStrength` 覆盖依赖 `KosRoundedBlurRegion` 的 blur override 支持，
   未在截图里确认 KWin 档位实际变化；参数面板只保证显示换算值
   `round(1 + v^1.5 * 14)`。
5. A 层 `LiquidGlassSurface` 在隔离进程中 ambient 为 transparent，
   深色下 tint 很弱（既有环境限制）。
6. `KosFloatPanel` 打开路径仍未实际点击验证（静态截图无法交互）。

## 已定案（不要再论证）
- gallery 是 Quickshell 配置：入口 `shell/gallery.qml`，页面 `shell/gallery/`。
- 两个 `PanelWindow`：背景板 `WlrLayer.Top`，主体 `WlrLayer.Overlay`。
- 主题应用必须晚于 `AppearanceConfigService._load()` 异步回调。
- 截图脚本：`pkill` 必须 `^qs -p shell/gallery.qml` 锚定；本机无
  ImageMagick，裁图用 PIL。截图全透明 = 合成器输出冻结，不是 QML 报错。

## Next round
先做环境检查（1 次截图，PIL 看 alpha）：
- 若仍全透明：停手，重复记录「合成器输出冻结」，不做 relogin。
- 若恢复：补 G1c light（总览）+ dark（`GALLERY_PAGE=surfaces`）两张截图，
  对照 SPEC 逐项核对三档 tint / 参数面板 / 圆角数值，然后才进 G1d。
