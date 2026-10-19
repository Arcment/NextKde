# 液态玻璃 Gallery — G4（控件矩阵）

## 本轮
G4d 代码已落地但**未验收**（2026-10-19）：GlassSlider + GlassSwitch 双组件、
各自 3×6 矩阵、交互契约演示行均已写入，`qmllint` 无语法错误；但本轮所有
gallery 启动都在 EGL 上下文创建处崩溃（vmwgfx / libgallium），拿不到任何
控件页截图，因此 G4d **不勾选**。

## 队列（✅=已交付）
- [x] G4a 控件页骨架 + ControlStateCard + GlassButton + 双形态切换
- [x] G4b GlassTextField + GlassCheckbox
- [x] G4c GlassComboBox + GlassSegmentedControl
- [ ] G4d GlassSlider + GlassSwitch（代码已写，截图/目检受阻）
- [ ] G4e GlassScrollBar + 字阶对照区
- [ ] G4f 全部截图补齐 + ledger 收口

## 本轮已改
- `shell/gallery/components/controls/ControlTokens.qml`：新增 slider 时长
  （press 270 / release 460 / x 200）、switch 时长（thumbX 200、press 120 /
  release 200）与 `accentColor` token（slider/switch 不再在调用点写
  `#0a84ff`）。既有 `sliderCommitDebounce 180`、`sliderSuppressX 400` 等沿用。
- `shell/gallery/components/controls/GlassSlider.qml`：value 0..1、高 44、
  track 6、thumb 32×16；iOS 玻璃 thumb（磨砂底/折射/高光/内沿/accent 溢染）
  与 M3 形态（`m3Scale=min(1,h/44)`、inactive 4 / active 16 / handle 4×44）。
  hover expansion 0.3、pressed 1.0；`previewChanged / commitRequested /
  canceled`；松手提交当前显示值，提交后 400ms 屏蔽 thumb x 动画；Ctrl+滚轮
  `wheelStep 0.01` / `wheelPixelStep 10`，180ms 去抖提交。为读数行额外暴露
  `wheelValue` / `wheelSteps`（仅 gallery 展示，不是契约）。
- `shell/gallery/components/controls/GlassSwitch.qml`：74×32、thumb 44×26、
  `travel = width-44-6`；`checked` 归宿主，`toggle()` 只发 `toggled(!checked)`，
  组件不本地赋值；thumbX 200 OutCubic、press expansion 120 / 释放 200；
  M3 track + handle 16 off / 24 on、`m3Scale=min(1,h/32)`；focusVisible =
  2px accent 环 + ink 发丝；Space/Enter 可切换。**偏差**：生产件用 pill
  OpacityMask 裁剪放大后的透镜，gallery 基线改为把展开高度夹到
  `height-2`（宽度仍 1.4×，61.6px，仍在 74px track 内），避免每卡一个离屏层。
- `shell/gallery/ControlsPage.qml`：新增 Slider 段（6 卡：
  idle/hovered/pressed/disabled + `value 0%` / `value 100%` 两个取值样张）
  与 Switch 段（off/on/hovered/pressed/disabled/focusVisible 正好 6 态）；
  两段下方各有 live 行与只读读数：slider `preview / commit / wheel（档数）/
  canceled`，switch `requested / confirmed`（350ms 模拟宿主异步确认）。
  `GALLERY_CONTROLS_FILTER` 增加 slider / switch。

## 仍差
- **G4d 四张验收截图全部缺失**：`g4-dark-slider`、`g4-dark-switch`、
  `g4-light-slider`、`g4-light-switch`（环境阻塞，见下）。
- G4d 未做目检：矩阵卡内约 88px 宽下滑块的可读性、thumb 在 0/1 端点与卡边
  距、Switch 三档材质上的 track 对比、M3 形态比例、live 读数行是否溢出。
- 静态图不能判 preview/commit 动效、180ms 去抖、400ms 屏蔽 x 动画、
  thumbX OutCubic、宿主确认窗口。
- G4c 遗留：ComboBox `open` 卡高 196 导致整段高于视口，待 G4f 整页图核对；
  clear 档仍会透出背景板 36px 圆点；Segmented 矩阵为 compact 40×26。
- 字阶对照区尚未实现（G4e）。

## 环境（本轮阻塞）
- 连续 5 次启动均在 EGL 上下文创建处崩溃：
  `QtWaylandClient::QWaylandGLContext::QWaylandGLContext` →
  `QSGRhiSupport::maybeCreateOffscreenSurface`，崩溃帧全在
  `libgallium-26.0.8`（vmwgfx 2.21.0）。`run.log` 均以
  `Configuration Loaded` 结束，**无 QML / TypeError / 加载失败**；截图始终是
  普通桌面（PNG 字节数完全相同）。
- 已排除的措施：间隔 6s / 15s 重启；移除 Switch 的 OpacityMask 离屏层
  （该简化已保留）；`QT_QUICK_BACKEND=software`；`LIBGL_ALWAYS_SOFTWARE=1`。
  均在同一栈崩溃。
- 18:11 遗留的 quickshell crash-handler 曾把崩溃弹窗盖在桌面上，已结束该
  孤儿进程后再试，仍复现。
- 按纪律停止重试，未做无上限重启。

## 外推（已写进代码注释）
- Switch 用高度夹取代替生产件的 pill mask（见上），是 gallery 渲染折衷，
  不改变 token / 状态集。
- Slider 的 `wheelValue` / `wheelSteps` 只为 live 读数，不进入契约。
- Slider 矩阵的 `value 0%` / `value 100%` 是取值样张，不是新增状态；
  SPEC §3.14 的状态集仍是 idle/hovered/pressed/disabled。
- 静态读数区初始显示 `commit — / wheel —（0 档）`，由交互后填充。

## 必须做（来自 DEMO.md / SPEC §3.8–§3.15）
1. 每控件 3 材质 × 6 状态矩阵；卡片标注「材质 · 状态」。
2. 双形态读 `ControlForm.materialForm`；顶部可切 liquid / material。
3. focus 环、error 图标、checkbox √ 均不得只靠颜色。
4. Slider：preview/commit/canceled、Ctrl+滚轮 0.01、180ms 去抖、
   400ms 屏蔽 x 动画；Switch：toggled 宿主确认，不本地翻转。
5. 字阶十档：26/22/17/15/13/13/12/11/10/10（行高 32/26/22/20/16/16/15/14/13/13）。

## 已定案（不要再论证）
- 控件基线放 `shell/gallery/components/controls/`，不改生产组件。
- 页面是 Flickable；截图钩子：`GALLERY_CONTROLS_OFFSET`、
  `GALLERY_CONTROLS_FILTER`、`GALLERY_CONTROL_FORM`，与 shot.sh 同行前置。
- 静态截图不能判动效；只核对终态与读数。

## 上一批（G4a / G4b / G4c / G3 已交付，勿重做）
- G4a：ControlsPage 骨架 + ControlStateCard + GlassButton 3×6 矩阵 +
  顶部 liquid/material 切换；gallery 本地 ControlTokens。
- G4b：GlassTextField + GlassCheckbox 3×6 矩阵；focus 双形状、error 图标、
  checkbox √ 路径。
- G4c：GlassComboBox（含 open 弹层终态）+ SegmentedControl 3×6 矩阵；
  ComboBox 弹层按 §3.12，Segmented 双比例制。
- G3：GlassDialog + scrim 三模式；compositor 全窗变暗不可见已记「仍差」。

## Next round
先恢复环境再验收 G4d（不要重写组件）：
1. 启动一次并检查 `run.log` 是否越过 `Configuration Loaded`；若仍在
   libgallium EGL 崩，继续按环境阻塞记录，不无限重试。
2. 能起后依次截图并目检：
   - `GALLERY_CONTROLS_FILTER=slider`，dark / light，liquid / material；
   - `GALLERY_CONTROLS_FILTER=switch`，dark / light，liquid / material；
   - 重点看：滑块 thumb 端点、读数行溢出、Switch 三档材质、M3 形态、
     focusVisible 环。
3. 修正问题（≤2 次迭代）后勾选 G4d，再进入 G4e
   （GlassScrollBar + 字阶对照区）。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
