# 液态玻璃 Gallery — G1

## 本轮
*（未开始 — 等 G1a）*

## 队列（✅=已交付）
- [ ] G1a 骨架：`shell/gallery.qml` + 导航 + 背景板，能起能截图
- [ ] G1b 表面页：LiquidGlassPanel(B 宿主) / LiquidGlassSurface(A) /
      ControlCenterGlass / KosFloatPanel
- [ ] G1c 三档材质并排 + 参数面板 + 总览页占位
- [ ] G1d 收口：DEMO.md §1 改成实际定案 + 仍差清单

## 已定案（不要再论证）
- gallery 是 Quickshell 配置：入口 `shell/gallery.qml`，页面 `shell/gallery/`。
  原因：真实玻璃组件依赖 Quickshell；`qs.*` 导入根固定为 `shell/`。
  原 `apps/gallery/` + CMake 开关方案已证伪，G1d 回写 DEMO.md。
- 窗口：`PanelWindow` 全屏（`ExclusionMode.Ignore` / `WlrLayer.Top`）。
  `FloatingWindow` 会被加装饰并整窗模糊，禁用。
- `ext-background-effect-v1` 警告是预期噪声，KWin 走 SurfaceShape。
- 受控背景：Background 层全屏 PanelWindow（高饱和色块），保证截图可比。

## 上一批已交付（R 系列）
- [x] R1 INVENTORY / R2 SPEC v0 / R3 INVENTORY §4-§11 / R4 SPEC v1 + DEMO
- [x] R5 INVENTORY §12 + SPEC v1.1（16 组件 API，人工项收敛到 3）

## Next round
G1a — 先读 `.loop/TASK.md` 第一节与 G1a 条目，按第三节的脚本启动截图。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake。
- 每轮结束前：截图 + state.md + commit。
- 队列全部完成后，在下面单独一行写 `DONE`。
