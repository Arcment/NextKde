# 液态玻璃 Gallery — G4（控件矩阵）

## 本轮
G4e 已交付（2026-10-19 18:38）：GlassScrollBar + 小列表演示 + 十档字阶对照区，
两张验收截图已目检。环境上遇到显示器休眠：抓到的是 17:24 的旧帧（桌面时钟不
走动、两次截图字节一致），唤醒后恢复；截图等待由 8s 提到 12s（未入库）。

## 队列（✅=已交付）
- [x] G4a 控件页骨架 + ControlStateCard + GlassButton + 双形态切换
- [x] G4b GlassTextField + GlassCheckbox
- [x] G4c GlassComboBox + GlassSegmentedControl
- [x] G4d GlassSlider + GlassSwitch（截图与目检完成）
- [x] G4e GlassScrollBar + 字阶对照区
- [ ] G4f 全部截图补齐 + ledger 收口

## 本轮已改
- `shell/gallery/components/controls/GlassScrollBar.qml`（新增）：宽 6（hover 8）、
  radius pill、滚动/悬停显示、静止淡出；thumb 浅 `#22000000` / 深 `#30ffffff`；
  淡出/跟随复用 `AppearanceTokens.motion.slowDuration`（260ms）/
  `fastDuration`（120ms）。宿主驱动：拖动只发 dragStarted/dragMoved/dragEnded，
  position/size 由宿主写回；最小 thumb 24px 为 gallery 外推。
- `shell/gallery/components/controls/ScrollListSample.qml`（新增）：小列表 mock +
  GlassScrollBar，用于矩阵卡与演示行。
- `shell/gallery/ControlsPage.qml`：新增 ScrollBar section（3×6 矩阵 + 卡内 10px
  状态提示 + idle/hovered/dragging 演示行与读数）；新增字阶对照区（十档逐行
  名称 / 字号·行高 / 样张 / 归并来源，样张 `Text.FixedHeight` 用该行行高）；
  `GALLERY_CONTROLS_FILTER` 增加 scrollbar / type。
- `docs/design/liquid-glass/DEMO.md`：新增 G4e 交付段。
- 截图工具（`tmp/gallery/`，不提交）：`shot.sh` 等待 8s → 12s；本轮显示器休眠时
  8s 与 12s 前两次都只拍到桌面旧帧，唤醒并延长后稳定。

## G4e 验收
截图（`tmp/glass/`）：
- `g4-dark-scrollbar.png`（filter=scrollbar，liquid，offset 0）
- `g4-dark-type.png`（filter=type，liquid，offset 0）

目检结论：
- ScrollBar 3 材质行 × 6 卡齐全，卡宽约 101、高 104；右上角标注完整换行。
- idle 卡仅见列表、无 thumb（`→ opacity 0` 提示在卡底）；scrolling 与 hovered
  分别是 6px / 8px 竖条，可辨；dragging 在 0.62、top / bottom 分别在两端，
  卡底 10px 提示逐卡对应；disabled 未定义故未造卡。
- 演示行三只小列表并排：idle 无 thumb、hovered 8px、dragging 0.62，下方
  caption 10px；右侧三行读数（overlay 描述、颜色、size 0.34）无溢出。
- 字阶十行全部可见：26/32、22/26、17/22、15/20、13/16、13/16、12/15、
  11/14、10/13、10/13；样张字号逐级可辨，Headline 为 Bold；来源右对齐可读。

## 仍差（本轮记录）
- 静态截图不能判定：淡出 260ms、6→8px 120ms、拖动跟随、真实滚动时的显隐。
  只核对了三态终态与位置。
- ScrollBar 的 position/size/拖动信号契约是 gallery 外推（SPEC §3.13 只给行为
  描述，未给 API）；最小 thumb 24px 同样为外推。
- 字阶区样张为单行，行高由 `Text.FixedHeight` 设定但静态图只能核对字号与
  数值列；多行换行时的行高未演示。
- 段首 token 摘要仍单行 elide；clear 档卡片会透出背景板白色圆点（G4c 遗留），
  ScrollBar 矩阵同样存在。
- G4c 遗留仍在：ComboBox `open` 卡高 196 使整段高于视口；Segmented 矩阵为
  compact 40×26。留待 G4f 整页核对。
- 全部实拍目前只有 dark；G4f 需补 light / top 与逐张核对。

## 环境
- 本轮首次 shot 只拍到桌面：显示器处于休眠/DPMS 关闭，spectacle 返回 17:24 的
  旧帧（系统时间 18:34），两次截图字节数相同且桌面时钟不走。唤醒后恢复，
  已记录：截图前确认屏幕时钟与系统时间一致。
- 唤醒后 8s 等待仍偶尔只拍到桌面；`tmp/gallery/shot.sh` 等待改为 12s 后稳定。
- 最终批次 `run.log` 无 QML 报错；仅 wallpaper colorquantizer 加载失败 WARN。
- 收尾后 `pgrep -f '^qs -p shell/gallery.qml'` 无残留。

## 外推（已写进代码注释）
- Switch 用高度夹取代替生产件的 pill mask（见上），是 gallery 渲染折衷，
  不改变 token / 状态集。
- Slider 的 `wheelValue` / `wheelSteps` 只为 live 读数，不进入契约。
- Slider 矩阵的 `value 0%` / `value 100%` 是取值样张，不是新增状态；
  SPEC §3.14 的状态集仍是 idle/hovered/pressed/disabled。
- 静态读数区初始显示 `commit — / wheel —（0 档）`，由交互后填充。
- 页面轮换用 `ControlForm.materialForm`（`shell/shared/qml/controls`），
  gallery 不复制生产组件。

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
G4f：收口（只做这一条）。
1. 整页截图 `g4-dark-top`、`g4-light-top`（offset 0）；补拍/重拍第五节全部
   截图：button dark/light/material、textfield、checkbox、combobox、segmented、
   slider dark/light、switch dark/light、scrollbar、type，逐张目检。
2. 核对整页高度与 G4c 遗留：ComboBox `open` 卡高 196 是否遮挡后续 section；
   Segmented compact 样本是否需要注明；clear 档背景点缀透出是否记录为已知。
3. ledger：已改 / 仍差 / 外推；`run.log` 无 QML 报错。state.md 写 DONE。
4. 截图前先跑 `tmp/gallery/stop.sh`；先确认屏幕时钟与系统时间一致（休眠会
   返回旧帧），shot 等待保持 12s。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
