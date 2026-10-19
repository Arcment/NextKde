# 液态玻璃 Gallery — G4（控件矩阵）

## 本轮
G4f 已交付（2026-10-19 18:48）：G4 收口。重拍并逐张目检第五节全部 15 张截图
（dark/light 整页顶部、button 三态含 material、textfield、checkbox、
combobox、segmented、slider 双主题、switch 双主题、scrollbar、type），
核对 G4c 遗留与整页结构，ledger 写入 DEMO.md 与本文件。`run.log` 无 QML 报错，
收尾无残留进程。截图工具链（`tmp/gallery/`，不提交）未改动。

## 队列（✅=已交付）
- [x] G4a 控件页骨架 + ControlStateCard + GlassButton + 双形态切换
- [x] G4b GlassTextField + GlassCheckbox
- [x] G4c GlassComboBox + GlassSegmentedControl
- [x] G4d GlassSlider + GlassSwitch（截图与目检完成）
- [x] G4e GlassScrollBar + 字阶对照区
- [x] G4f 全部截图补齐 + ledger 收口

## 本轮已改
- `docs/design/liquid-glass/DEMO.md`：新增 G4f 收口段（截图清单、逐张核对、
  G4c 遗留结论、整页高度说明）。
- 本轮无 shell 代码改动；15 张截图全部按第五节要求重拍（light/material
  钩子与 shot.sh 同行前置）。
- 环境：light 首次两轮 shot 曾抓到桌面旧帧（18:44 两张只有桌面，时钟正常
  走动），重跑后正常；同一类旧帧问题在 G4e 休眠时也出现过，未改工具链。

## G4f 验收
截图（`tmp/glass/`，均 liquid 除注明）：
- `g4-dark-top.png`、`g4-light-top.png`（offset 0）
- `g4-dark-button.png`、`g4-light-button.png`、`g4-light-material-button.png`
- `g4-dark-textfield.png`、`g4-dark-checkbox.png`、`g4-dark-combobox.png`
- `g4-dark-segmented.png`、`g4-dark-slider.png`、`g4-light-slider.png`
- `g4-dark-switch.png`、`g4-light-switch.png`
- `g4-dark-scrollbar.png`、`g4-dark-type.png`

目检结论：
- 8 个控件矩阵均完整 3 材质行 × 6 状态卡，右上角「材质 · 状态」标注无截断。
- focus 全部为描边 + 外环双形状；error 红描边 + 圆形图标；checkbox 勾选为
  √ 路径；均不靠颜色。Slider/Switch 读数区在矩阵下方静态可见。
- ComboBox `open` 卡弹层完整落在卡内，与下一材质行约 20px 间距，不遮挡
  后续 section（G4c 遗留已核）；Segmented 矩阵仍是 compact 样本，72×40
  实尺寸见演示行；clear 档白点为测试背板透出，非控件缺陷。
- 整页含 9 个 section，offset 0 只露出 Button 与 TextField 标题；内容高度
  远高于任务书草图的约 2000px，Flickable 可滚通，逐段 filter 可达。
- light 组标题/正文 ink 与 dark 组不同，确认 `GALLERY_THEME` 生效。

运行状态：最后批次 `run.log` 无 QML 报错（仅 wallpaper colorquantizer WARN）；
`pgrep -f '^qs -p shell/gallery.qml'` 无残留。

## G4e 验收（历史）
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

## Ledger（G4f 收口）
已改：
- `docs/design/liquid-glass/DEMO.md` G4f 段；本文件状态与验收记录。
- 无 shell 代码改动（G4a–G4e 的组件与页面已在前几轮提交）。

仍差：
- 静态截图不能判定动效：滑块动画、180ms 提交去抖、400ms 屏蔽、Slider
  expansion 0.3、Switch thumbX 200 OutCubic / press 120 / 释放 200、
  ScrollBar 260ms 淡出与 6→8px 120ms，均只核对了终态。
- ScrollBar 的 position/size/拖动信号契约与最小 thumb 24px 为 gallery 外推。
- 字阶区样张为单行；静态图只核对字号、行高数值与来源列。
- 段首 token 摘要仍是单行 elide；clear 档卡片透出背景板白色圆点（测试背板，
  非控件问题）。
- ComboBox `open` 卡高 196，整段仍高于一屏，需滚动；Segmented 矩阵为
  compact 样本（72×40 实尺寸在演示行）。
- light 组截图首次两轮抓到桌面旧帧，重拍后正常；属截图工具链的偶发旧帧，
  未改工具链。

外推：
- Switch 用高度夹取代替生产件 pill mask；Slider 的 wheelValue/wheelSteps
  仅作读数；Slider 矩阵 value 0%/100% 是取值样张；页面轮换用
  `ControlForm.materialForm`，gallery 不复制生产组件。

## 环境
- G4f：截图前用 spectacle 拍桌面探针，屏幕时钟 18:40 与系统时间一致，未休眠。
- light 组首两轮 `g4-light-top` / `g4-light-button` 只拍到桌面（时钟正常走动），
  重跑后 15 张全部为 gallery；属 spectacle 偶发旧帧，与 G4e 的休眠旧帧同类。
- `tmp/gallery/shot.sh` 保持 12s 等待，未再改动。
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

## 上一批（G4a–G4e / G3 已交付，勿重做）
- G4a：ControlsPage 骨架 + ControlStateCard + GlassButton 3×6 矩阵 +
  顶部 liquid/material 切换；gallery 本地 ControlTokens。
- G4b：GlassTextField + GlassCheckbox 3×6 矩阵；focus 双形状、error 图标、
  checkbox √ 路径。
- G4c：GlassComboBox（含 open 弹层终态）+ SegmentedControl 3×6 矩阵；
  ComboBox 弹层按 §3.12，Segmented 双比例制。
- G4d：GlassSlider + GlassSwitch 3×6 矩阵 + live 契约读数行。
- G4e：GlassScrollBar + ScrollListSample + 十档字阶对照区。
- G3：GlassDialog + scrim 三模式；compositor 全窗变暗不可见已记「仍差」。

## Next round
无。G4 队列已全部交付，等下一批任务（G5 或后续）。
截图工具链注意：截图前先跑 `tmp/gallery/stop.sh`，确认屏幕时钟与系统时间
一致；spectacle 偶发返回旧帧，发现内容与预期 filter 不符时重拍一次。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。

DONE
