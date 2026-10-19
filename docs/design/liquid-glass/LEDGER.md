# 液态玻璃 Gallery — G6（G5 收尾修补 + SPEC §7 三项 A/B）

## 本轮
G6e 已交付：12 张截图（motion 6 + decision 6）逐张核对完毕。motion 侧与
decision ②③ 的代码在 G6d 后未变，沿用成片；Toast 两张因 G6d 改过
`DecisionsPage.qml`，按钩子重拍 `g6-{dark,light}-decision-toast`。
params off 显示 `effective 150/140 · expansion on · ambient 2600ms`；
reduce 四段均 effective 0 / expansion 0 / ambient skipped / remaining 0ms；
裁定页三段 A/B 读数与后果行齐全、无推荐。ledger 三项写「A/B 已呈现，
待人工裁定」。实测 dark Toast B lane 读数对比度约 2.2:1、后果行约 2.1:1，
记入仍差。run.log 无 QML 报错，重拍后无残留 gallery 进程。队列全部勾选。

## 队列（✅=已交付）
- [x] G6a 修补 params reduceMotion 标签（on/off 分支）+ 重拍 params
- [x] G6b reduceMotion 其余四段截图（press / ambient / tooltip / toast）
- [x] G6c 裁定页骨架 + Toast A/B（页序 6、钩子、两栏交互、读数、后果行）
- [x] G6d Tooltip A/B + SessionMenu A/B（两段各两栏、可交互、读数、后果行）
- [x] G6e 12 张截图补齐 + ledger 收口

## 必须做
1. params 卡 reduceMotion 行：off 时显示 effective 150/140、expansion on、
   ambient 2600ms；on 时显示 effective 0、expansion 0、ambient skipped。
2. 四段 reduce 截图：每段 effective 0、expansion 0、环境光跳过、toast 存留 0。
3. 裁定页三段（Toast / Tooltip / SessionMenu）A/B 并排、可交互、有读数、
   有后果行；**不写推荐、不做裁定**。
4. ledger 三项写「A/B 已呈现，待人工裁定」。

## 已定案（不要再论证）
- 页面 `shell/gallery/DecisionsPage.qml`，页序 6，导航名「裁定 G6」。
- 截图钩子：`GALLERY_PAGE=decisions`、`GALLERY_DECISION=toast|tooltip|session`。
- 现有 motion 钩子照旧：`GALLERY_MOTION_DEMO`、`GALLERY_MOTION_REDUCE=1`。
- 静态截图不能判动效；只核对 token 标注、终态与读数。
- 裁定页统一用 `DecisionLane` 做 A/B 单栏；两栏等宽，后果行固定在栏底。
  两栏衬底：dark 黑 0.22 / light 白 0.34（G6c 实测加入）。
- Tooltip 两栏共用 `DecisionTooltipLane`，仅 gap 不同；SessionMenu 两栏
  共用 `DecisionSessionLane`，仅 mode 不同（G6d 定案）。

## Ledger（G6e 收口）
- 已改：params reduceMotion 标签 on/off 分支；reduce 四段截图；裁定页
  ①②③ 三段 A/B；`DecisionsPage.qml` 页序 6 与三个 `GALLERY_DECISION`
  钩子；G6d 新增 `DecisionTooltipLane.qml`、`DecisionSessionLane.qml`；
  G6e 重拍 Toast 两张、逐张核对 12 张；`DEMO.md` 增 G6c/G6d/G6e 段。
- 仍差：见下「仍差」小节。
- 外推：三项均为人工裁定项；本页只提供并排交互与读数，不预设结论。
- ① Toast 存留 1600ms：A/B 已呈现，待人工裁定。
- ② Tooltip 贴边 -6px：A/B 已呈现，待人工裁定。
- ③ SessionMenu 极端高度：A/B 已呈现，待人工裁定。

## 仍差
- dark 主题 Toast B lane 落在黄色象限时，9px 读数白字实测最大对比度约
  2.2:1、后果行约 2.1:1（衬底约 rgb 197,168,49，字约 255,251,229），
  低于 3:1；若后续加深 lane 衬底需连带重拍 3 张 dark decision 截图。
- Session B 栏两列 clamp 后高度 44 / 56 不同，两列注释行不在同一 y
  （相差约 33px）；读数仍逐列可对应。
- Tooltip stage 的「屏幕边缘」标签为 8px，仅作位置提示；数值以读数为准。

## Next round
无（G6 队列全部完成）。若继续：先由人工对 SPEC §7 三项做裁定，再另开
队列。可选的视觉修补是把 dark 裁定页 lane 衬底加深到白字 ≥4.5:1，需重拍
3 张 dark decision 截图；本轮未做，属裁定后的调整项。

## 上一批（G5 已交付，勿重做）
- 动效页五段 + ParamPanel 完备已交付；本次只修补 reduceMotion 标签行，
  其余 G5 内容不要重做。
- G4 控件、G3 弹层不要改。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。

DONE
