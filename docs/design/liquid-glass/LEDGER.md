# 液态玻璃 Gallery — G1

## 本轮（G1c 复核 · 第 2 次环境检查：仍冻结，停手）
- 12:05 环境检查：`shot.sh light g1c-envcheck` → 1280×800，alpha=0 像素
  **1,024,000 / 1,024,000**，RGBA extrema 全 0（r/g/b/a 均 (0,0)）；
  合成器输出冻结状态延续，与 QML 无关。未 relogin、未重启会话、未做无头渲染、
  未做第 3 次尝试。
- 启动无 QML 报错（`run.log` 仅 wallpaper 采样 WARN）。
- 本轮无有效视觉证据；G1c 的 tint 差异 / 参数面板间距 / 字重仍未经截图核对。
- 结论不变：G1c 代码完成，截图与视觉核对待环境恢复后补。

## 队列（✅=已交付）
- [x] G1a 骨架：能起、能截图
- [x] G1b 表面页：Panel(B 宿主) / Surface(A) / ControlCenterGlass / KosFloatPanel
- [ ] G1c 三档材质 + 参数面板 + 总览页（代码完成 + 行高修正；截图与视觉核对待补）
- [ ] G1d 收口：DEMO.md §1 改成实际定案 + 仍差清单

## 仍差（top 6）
1. **G1c 截图未产出**：合成器输出仍冻结（单帧 alpha 全 0）。恢复后补
   `tmp/gallery/shot.sh light g1c-light`（总览）与
   `GALLERY_PAGE=surfaces tmp/gallery/shot.sh dark g1c-dark`（表面页）。
   仍冻结则继续停手记录，不 relogin。
2. 三档材质条与参数面板的间距 / 字重未经截图核对；SPEC 值已写入代码，
   「tint 0.10/0.16/0.24 差异一眼可辨」尚无法确认。
3. `MaterialTrio` 三卡共用同一 `blurOverrideEnabled` + 全局 blurStrength
   （默认 0.63 → KWin L8），因此三档在模糊维度上相同，只差 tint；
   SPEC §2.1 的每档默认模糊 3/8/12 未在 gallery 中呈现。
4. 现役 `KosFloatPanel` 默认 `cornerExponent = AppearanceTokens.shape.cornerExponent = 3.0`，
   与 SPEC §2.2「玻璃系 2.0」不符；G1 不改现役组件，仅 caption 如实标注 3.0，
   待 G2 收口时统一。
5. A 层 `LiquidGlassSurface` 在隔离进程中 ambient 为 transparent，
   深色下 tint 很弱（既有环境限制）。
6. `KosFloatPanel` 打开路径仍未实际点击验证（静态截图无法交互）；
   `ControlCenterGlass` 的 blur 覆盖效果同未在截图确认。

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
