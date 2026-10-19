# 液态玻璃 Gallery — G5（动效 + 参数面板）

## 本轮
G5d 已交付（2026-10-19 19:20）：参数面板完备 + reduceMotion 联动。
参数面板新增 tintStrength（0–0.40，刻度 0.10/0.16/0.24）、blurLevel
（1–15 整数 + clear 1..5 / regular 6..10 / thick 11..15 三段色带 + 当前档
标记）、radius pill 开关（三档 32/24/16 + 0–32 自由滑杆保留）。
tint / radius / blur 已从 ParamPanel 经 GalleryRoot 实时下发到 表面、
控件、动效三页：表面页 MaterialTrio 与各 LiquidGlassPanel/Surface 用
主题色 baseColor（深色黑 / 浅色白，α = tintStrength），控件页 8 组
ControlStateCard 全部接 previewRadius/tint/previewBlur/previewOpacity，
动效页 6 张 MotionCard（含新增 params 卡）同样接收。
`GALLERY_MOTION_DEMO=params` 新增一张只读参数卡（与右侧面板同源），
单独出图时其余卡片隐藏。动效页五段均读 reduceMotionOn。
另修 `shell/gallery.qml` 的主题播种竞态：themeSettle 由单次 800ms 改为
10 次 × 800ms 重放（避免异步持久化加载把浅色运行翻回深色）。

截图：`g5-dark-params.png`、`g5-light-params.png`、
`g5-dark-reduce.png`、`g5-light-reduce.png`（`tmp/glass/`，并复制到
`docs/design/liquid-glass/`）。`run.log` 无 QML 报错；仅 wallpaper
colorquantizer WARN 与既有的 ProxyFloatingWindow 弃用 WARN。

静态读数（本次四张截图）：
- dark params：tintStrength 0.16 · 刻度 0.10/0.16/0.24 可见；
  blurLevel L8 · band regular；radius 24（预设 32/24/16 中 24 选中）；
  pill off · eff 24；reduceMotion off。参数卡同步读出同一组值。
- light params：同一组值；浅色墨色（页标题与读数均为深字），
  面板底色随浅色 tint 变浅；参数卡与右侧面板读数一致。
- dark reduce：popup 双 lane effective 均为 0ms（reduceMotion），
  开 progress 1.000 settled / 关 progress 0.000 settled，
  startScale 0.96 · anchorOffset 20px 标注保留；顶栏 reduceMotion=on。
- light reduce：同读数（0ms / 1.000 / 0.000），浅色墨色。

## 队列（✅=已交付）
- [x] G5a 动效页骨架 + Popup 开合对比（OutCubic / InCubic）
- [x] G5b 液态按压 expansion + 环境光过渡 2600ms
- [x] G5c tooltip 70ms + toast 1600ms
- [x] G5d 参数面板完备 + reduceMotion 联动
- [ ] G5e 10 张截图补齐 + ledger 收口

## G5a 验收
- `MotionPage.qml` 为 Flickable + Column，每个演示位一张 `MotionCard`
  （LiquidGlassPanel，QML 回退，radius 24）；截图钩子
  `GALLERY_MOTION_DEMO` 已生效，未知值显示可用演示位清单。
- Popup 段：两 lane 并排，各自带 OutCubic/InCubic 标签、150/140ms 徽标、
  progress/effective/state 读数、重播按钮与 t/ease/progress 五行采样表。
- progress 语义复用 `PopupMotion`：开/关时长按剩余进度等比缩放，
  开 OutCubic、关 InCubic、startScale 0.96。
- reduceMotion：lane 的 effective 时长派生为 0（开进度直接 1、关直接 0），
  由面板开关与 `GALLERY_MOTION_REDUCE=1` 驱动。
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

## G5c 验收
- tooltip 段（`TooltipDemo.qml`）：页内镜像 GlassTooltip 面板（thick /
  radius 10 / Callout 12 + Footnote 10），锚点侧重叠 6px；open OutCubic /
  close InCubic，时长按剩余 progress 等比缩放，startScale 0.96；显示 / 隐藏
  两键重播 70ms。读数行含 progress / scale / effective open+close / state。
- toast 段（`ToastDemo.qml`）：镜像 G2d GlassToast 表面（regular / scrim
  readable / 36px / pill / Callout 12）；show 150 / hide 180ms OutCubic；
  发一条启动 1600ms 存留倒计时（remaining 读数），关闭立即收起；
  caption 与读数均注明 SPEC §7-① 存留裁定项待定。
- reduceMotion 已接入两段：tooltip effective 0、progress 直接落到目标；
  toast show / hide / 存留 effective 全 0（发一条当帧消失）。
- `GALLERY_MOTION_DEMO=tooltip|toast` 单独出图时其余卡片与占位均隐藏。

## G5d 验收
- ParamPanel 四项齐备：
  - tintStrength 0–0.40 连续滑杆 + `ParamSlider.ticks` 画刻度与数值
    0.10 / 0.16 / 0.24（默认 0.16 = regular tier）。
  - blurLevel 1–15 整数（滑杆取整），`blurAmount` 由
    `((L-1)/14)^(2/3)` 反算保持预览页接口不变；下方三段色带
    clear 1..5 / regular 6..10 / thick 11..15，白色标记线随档位移动，
    并打印 `band clear|regular|thick`。
  - radius 32/24/16 三按钮（pill 开启时取消选中）、0–32 自由滑杆、
    pill 开关；pill 时 effectiveRadius = 999（矩形 radius 自动收敛为胶囊），
    读数显示 `pill`，动滑杆会关闭 pill。
  - reduceMotion 开关保留，另加一段说明：参数实时作用于三页，
    开启后 effective 0 / expansion 0 / 环境光跳过。
- 实时联动：GalleryRoot 增加 tintStrength / radiusPill / effectiveRadius
  只读转发；表面页（MaterialTrio + 4 个 SurfaceBlock）、控件页（8 个
  ControlStateCard delegate）、动效页（6 张 MotionCard）全部接收。
  tint 以 `baseColor` α = tintStrength 实现（深色黑 / 浅色白），
  radius 统一走 effectiveRadius。
- `GALLERY_MOTION_DEMO=params` 新增参数卡：tintStrength / blurLevel
  区间与色带 / radius 预设与 pill / reduceMotion 生效值 / 三页 apply
  一行一读，值来自 MotionPage 的同一组属性。
- reduceMotion 复检：PopupLane effective 0 且落到终态；PressDemo
  press/release effective 0、Behavior 禁用、expansion 读数 0；AmbientDemo
  effective 0、state skipped、直接到端色；TooltipDemo open/close effective 0；
  ToastDemo show/hide/hold effective 全 0。本次 reduce 截图只出 popup 段。
- 主题播种：`themeSettle` 改为 10 次 × 800ms 重放，避免
  AppearanceConfigService 的异步持久化加载在首帧后把 GALLERY_THEME
  覆盖掉（浅色截图曾复现）。

## 仍差
- 静态截图不能判动效：按压回弹（OutBack 过冲 / OutQuint 回落）、
  popup 150/140ms 曲线与环境光 2600ms 渐变的实际播放只核对了 token、
  终态读数与静态采样，未看动态。
- reduceMotion 的 press/ambient/tooltip/toast 分支只做了代码复检，
  本轮 reduce 截图按任务书只拍 popup；其余四段没有单独的 reduce 静帧。
- blur：blurLevel 真正改变的是 KWin blur override（
  `blurOverrideEnabled` + `blurStrength`）与所有读数/色带；动效页与
  控件页的 QML 回退玻璃由生产组件固定读
  `AppearanceTokens.glass.blurStrength`，滑杆不改变回退像素。这是
  生产组件的边界，未改现役组件。
- tintStrength 在 gallery 内以 baseColor α 近似（不再是 tier token 本身）；
  clear/regular/thick 的材质差异仍由 material 决定，参数只调统一 tint。
- pill 用 radius 999 依赖 Rectangle.radius 收敛；gallery 卡片
  cornerExponent 2.0，无 squircle 蒙版，故不会出现蒙版半径越界。
- 右侧参数面板本身是 chrome，不跟随 tint/radius。
- `GALLERY_MOTION_DEMO=params` 的截图为“面板 + 参数卡”双处同值，
  不是独立第七段动效。

## 必须做（来自 DEMO.md §4 / SPEC §2.7）
1. 动效页五段：popup 开合、按压 expansion、环境光 2600、tooltip 70、toast 1600。
2. reduceMotion 开启后所有 effective 时长 0、expansion 0、环境光跳过。
3. 参数面板：tintStrength 0–0.40 + 刻度 0.10/0.16/0.24；blurLevel 1–15 +
   三段色带；radius 32/24/16 + 0–32 + pill；reduceMotion 开关。
4. 参数实时作用于所有预览页。

（1–4 已在 G5a–G5d 实现；G5e 只做截图补齐与 ledger 收口。）

## 已定案（不要再论证）
- 页面 `shell/gallery/MotionPage.qml`，替换 PlaceholderPage。
- 截图钩子：`GALLERY_MOTION_DEMO=popup|press|ambient|tooltip|toast|params`、
  `GALLERY_MOTION_REDUCE=1`，与 shot.sh 同行前置。
- 静态截图不能判动效；只核对 token 标注、终态与读数。

## 上一批（G4 已交付，勿重做）
- 控件页 8 控件 3×6 矩阵、双形态、字阶十档已完成。
- 不要再改 ControlsPage / components/controls 的控件实现；G5d 只加了
  preview 参数转发，未改任何控件行为。

## Next round
G5e — 收口：按 TASK 第五节 10 张清单补齐/重拍（popup dark/light、
press、ambient、tooltip、toast、reduce dark/light、params dark/light），
逐张核对 token 标注与静态读数；确认 run.log 无 QML 报错；更新
DEMO/LEDGER（如需要）；提交后在本文件写 `DONE`。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
