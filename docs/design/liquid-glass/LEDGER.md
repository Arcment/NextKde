# 液态玻璃 Gallery — G4（控件矩阵）

## 本轮
G4b 已交付（2026-10-19）：GlassTextField + GlassCheckbox，
各自 3 材质 × 6 状态矩阵，随 `ControlForm.materialForm` 双形态切换。

## 队列（✅=已交付）
- [x] G4a 控件页骨架 + ControlStateCard + GlassButton + 双形态切换
- [x] G4b GlassTextField + GlassCheckbox
- [ ] G4c GlassComboBox + GlassSegmentedControl
- [ ] G4d GlassSlider + GlassSwitch（行为契约演示）
- [ ] G4e GlassScrollBar + 字阶对照区
- [ ] G4f 全部截图补齐 + ledger 收口

## 本轮已改
- `shell/gallery/components/controls/GlassTextField.qml`：高 28、Body 13/16。
  liquid = pill 玻璃体；material = M3 filled、radius 10。focus = 2px accent
  描边 + 外移 3px 的 2px 外环 + 1px ink 发丝 + tint 加深；error = 2px 红描边
  + 右侧圆形「!」徽标。live 模式是真实 TextInput（可输入、可 Tab 聚焦）。
- `shell/gallery/components/controls/GlassCheckbox.qml`：框 20×20、radius 5、
  label Body 13/16；勾选为 QtQuick.Shapes 两段折线 √；focusVisible = 外环 +
  ink 发丝；hover/pressed 状态层 + pressed 0.90 缩放；点击切换并 `toggled`。
- `shell/gallery/ControlsPage.qml`：新增 TextField / Checkbox 两段 3×6 矩阵；
  `GALLERY_CONTROLS_FILTER` 接受 textfield / checkbox；unknownFilter 列表更新。
- `docs/design/liquid-glass/g4-{dark-textfield,dark-checkbox}.png`；
  DEMO.md 追加 G4b 进度。

## 仍差
- Checkbox 的 focusVisible 外环与 checked 的 accent 填充同色，20px 框上环距
  仅 1px（外环 -3px / ink 发丝 -1px），远看近似一圈；形状仍在、非纯色，
  但若要求更醒目需加大环距（本轮未再改，按小步纪律停手）。
- 背景板 36px 黑白圆点仍会透过 clear 档卡片（既有问题，未为本轮改动）。
- 静态图不能判 hover/pressed 动效，也不能判 TextInput 光标闪烁。
- 字段在窄卡（约 95px 内容宽）内 placeholder 与值都被裁剪；矩阵用途只看
  形态与状态，live 演示需等整页截图轮（G4f）再核对宽度。

## 外推（已写进代码注释）
- SPEC §3.10 只列 normal/focused/error/disabled；矩阵补 hovered 与 filled
  （带值外观）两卡，均非新增状态。
- SPEC 未给 TextField 圆角：liquid 取 pill（height/2），material 取 Button
  同款 small 10。
- Checkbox 的 material 勾选框保留 SPEC 的 radius 5（不改成 M3 的 2）。
- focus 卡统一采用「描边 + 外环」双形状，满足 HIG §2.6 不只靠颜色。

## 环境
- 两次截图 `run.log` 均只有 wallpaper colorquantizer WARN，无 QML 报错。
- 截图均与 `shot.sh` 同行前置 `GALLERY_PAGE` / `GALLERY_CONTROLS_FILTER` /
  `GALLERY_CONTROLS_OFFSET` / `GALLERY_CONTROL_FORM`。
- 桌面未再停留在 KWin Overview；无需 DBus 干预。

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

## 上一批（G4a / G3 已交付，勿重做）
- G4a：ControlsPage 骨架 + ControlStateCard + GlassButton 3×6 矩阵 +
  顶部 liquid/material 切换；gallery 本地 ControlTokens。
- G3：GlassDialog + scrim 三模式；compositor 全窗变暗不可见已记「仍差」。

## Next round
G4c — GlassComboBox + GlassSegmentedControl：弹层按 §3.12（radius 16、
高 min(360, 内容+12)、偏移 5、padding 8、sheetColor 深 #262b31 / 浅 #f6f8fb）；
Segmented pill 形态 height/2、card 形态 height×0.38、cell 72×40、outerPadding 2。
截图 `g4-dark-combobox`、`g4-dark-segmented`。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
