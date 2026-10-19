# 液态玻璃 Gallery — G5（动效 + 参数面板）

## 本轮
G5b 已交付（2026-10-19 19:05）：液态按压 expansion 三态 + 环境光 2600ms。
新增 `shell/gallery/PressDemo.qml`、`shell/gallery/AmbientDemo.qml`，
`MotionPage.qml` 追加两张 `MotionCard` 并扩展 `GALLERY_MOTION_DEMO` 过滤
（press / ambient），占位文案改为 G5c–G5d。
截图：`g5-dark-press.png`、`g5-dark-ambient.png`（`tmp/glass/`，并复制到
`docs/design/liquid-glass/`）。`run.log` 无 QML 报错；仅 wallpaper
colorquantizer WARN 与既有的 ProxyFloatingWindow width/height 弃用 WARN。

静态读数（本次两张截图）：
- 按压：三态并排 idle 0.000 / hovered 0.300 / pressed 1.000，代理体
  scale 0.88+0.12×expansion；live 回弹读数 expansion 0.000、state idle；
  effective press 200ms OutBack / release 360ms OutQuint（沿用 G4
  GlassButton 的 ControlTokens 映射：normalDuration / slowDuration）。
- 环境光：A #c08a5a / B #5a8fb0 起止色样，token 2600ms InOutSine；
  静态停在 t=0.5 采样（mix 50%，progress 0.500，state sampled），
  effective 2600ms，按钮「切换到 B」。
- 两段卡片的 caption 均标注 reduceMotion 下 effective 0 / expansion 关闭 /
  环境光跳过；代码路径已接 `reduceMotion`，截图留待 G5d。

## 队列（✅=已交付）
- [x] G5a 动效页骨架 + Popup 开合对比（OutCubic / InCubic）
- [x] G5b 液态按压 expansion + 环境光过渡 2600ms
- [ ] G5c tooltip 70ms + toast 1600ms
- [ ] G5d 参数面板完备 + reduceMotion 联动
- [ ] G5e 10 张截图补齐 + ledger 收口

## G5a 验收
- `MotionPage.qml` 为 Flickable + Column，每个演示位一张 `MotionCard`
  （LiquidGlassPanel，QML 回退，radius 24）；截图钩子
  `GALLERY_MOTION_DEMO` 已生效，非 popup 值显示「G5b–G5d 补齐」占位。
- Popup 段：两 lane 并排，各自带 OutCubic/InCubic 标签、150/140ms 徽标、
  progress/effective/state 读数、重播按钮与 t/ease/progress 五行采样表。
- progress 语义复用 `PopupMotion`：开/关时长按剩余进度等比缩放，
  开 OutCubic、关 InCubic、startScale 0.96。
- reduceMotion：lane 的 effective 时长派生为 0（开进度直接 1、关直接 0），
  由面板开关与 `GALLERY_MOTION_REDUCE=1` 驱动；本页其余段在 G5b–G5d 接入。
- G5a 静态读数留档：开 OutCubic 150ms / progress 1.000 settled；关 InCubic
  140ms / t=0.75 采样 progress 0.578 sampled；采样点列见提交 bcc44f0f。

## G5b 验收
- 按压段（`PressDemo.qml`）：三态并排，expansion 取 token 0 / 0.3 / 1.0，
  代理体 scale = 0.88 + 0.12×expansion；live 药丸按下→1.0（200ms OutBack）、
  松开→0（360ms OutQuint），Behavior 在 reduceMotion 下禁用，读数直接归 0。
  读数行含 expansion / effective press+release / state idle|pressed|released。
- 环境光段（`AmbientDemo.qml`）：A/B 起止色样 + 2600ms InOutSine 标注 +
  mix 板与 progress 读数；点击在 A/B 间切换，按生产语义每次重启完整 2600ms；
  reduceMotion 下 effective 0、state skipped、直接落到目标端色。
- `GALLERY_MOTION_DEMO=press|ambient` 单独出图时其余卡片与占位均隐藏。

## 仍差
- 静态截图不能判动效：按压回弹（OutBack 过冲 / OutQuint 回落）与环境光
  2600ms 渐变的实际播放只核对了 token、终态读数与静态采样，未看动态。
- 环境光静态默认停 t=0.5 采样、按压 live 读数为 0，均为截图可读性刻意
  保持的非终态；点击后的真实过渡静止截图无法证明。
- reduceMotion 在 press/ambient 的 effective 0 与 skipped 分支已写，但本轮
  未单独截图验证，随 G5d 一并核。
- tooltip、toast、参数面板三项尚未落地（G5c/G5d）。
- 动效页顶部 `DEMO=… · reduceMotion=…` 为自检辅助行，非产品内容。

## 必须做（来自 DEMO.md §4 / SPEC §2.7）
1. 动效页五段：popup 开合、按压 expansion、环境光 2600、tooltip 70、toast 1600。
2. reduceMotion 开启后所有 effective 时长 0、expansion 0、环境光跳过。
3. 参数面板：tintStrength 0–0.40 + 刻度 0.10/0.16/0.24；blurLevel 1–15 +
   三段色带；radius 32/24/16 + 0–32 + pill；reduceMotion 开关。
4. 参数实时作用于所有预览页。

## 已定案（不要再论证）
- 页面 `shell/gallery/MotionPage.qml`，替换 PlaceholderPage。
- 截图钩子：`GALLERY_MOTION_DEMO=popup|press|ambient|tooltip|toast|params`、
  `GALLERY_MOTION_REDUCE=1`，与 shot.sh 同行前置。
- 静态截图不能判动效；只核对 token 标注、终态与读数。

## 上一批（G4 已交付，勿重做）
- 控件页 8 控件 3×6 矩阵、双形态、字阶十档已完成。
- 不要再改 ControlsPage / components/controls。

## Next round
G5c — tooltip 70ms 显隐 + toast 1600ms 存留。在 MotionPage 的 Column 里
继续追加两张 MotionCard（可参考 `PressDemo.qml` 的写法，独立小组件），
扩展 `GALLERY_MOTION_DEMO` 的 tooltip / toast；各带触发按钮与状态读数，
toast 注明存留裁定项仍挂 SPEC §7-①。截图：`g5-dark-tooltip`、
`g5-dark-toast`。不要重复本轮 press/ambient 的核对。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
