# 液态玻璃 Gallery — G6（G5 收尾修补 + SPEC §7 三项 A/B）

## 本轮
G6d 已交付：在 `DecisionsPage.qml` 补齐 SPEC §7-② Tooltip 与 §7-③
SessionMenu 两段 A/B，替换原「G6d 交付」占位。新增
`DecisionTooltipLane.qml`（屏幕边缘 hairline + 贴边锚点 chip + tooltip；
A `gap -6px` 压进锚点 6px，B `gap +4px` 正间隙；读数 gap / anchorB ·
tipTop / state；悬停 chip 显示、离开隐藏，chip 点击与按钮切换）与
`DecisionSessionLane.qml`（同一三行动作菜单，两列极端 itemHeight 并排，
label 固定 Footnote 10；A raw 24 / 72 并注拥挤 / 空旷，B clamp 44–56
并注 req → clamp；读数 itemHeight 与实际字号；hover 高亮 / 点击选中）。
浅色主题下 danger 墨改为深红，保证「关机」可读。四张截图
`g6-{dark,light}-decision-{tooltip,session}` 已出，run.log 无 QML 报错；
三项均只呈现，无推荐、无裁定。

## 队列（✅=已交付）
- [x] G6a 修补 params reduceMotion 标签（on/off 分支）+ 重拍 params
- [x] G6b reduceMotion 其余四段截图（press / ambient / tooltip / toast）
- [x] G6c 裁定页骨架 + Toast A/B（页序 6、钩子、两栏交互、读数、后果行）
- [x] G6d Tooltip A/B + SessionMenu A/B（两段各两栏、可交互、读数、后果行）
- [ ] G6e 12 张截图补齐 + ledger 收口

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
- 已改：`DecisionsPage.qml` ②③ 段；新增 `DecisionTooltipLane.qml`、
  `DecisionSessionLane.qml`；`DEMO.md` 增 G6d 段。
- 仍差：见下「仍差」两小节。
- 外推：三项均为人工裁定项；本页只提供并排交互与读数，不预设结论。
- ① Toast 存留 1600ms：A/B 已呈现，待人工裁定。
- ② Tooltip 贴边 -6px：A/B 已呈现，待人工裁定。
- ③ SessionMenu 极端高度：A/B 已呈现，待人工裁定。

## 仍差
- dark 主题 Toast B lane 落在黄色象限时，10px 读数白字对比度约 3:1，
  仍偏弱；若后续调整 lane 衬底需连带重拍 `g6-dark-decision-toast`。
- Session B 栏两列 clamp 后高度 44 / 56 不同，两列注释行不在同一 y
  （相差约 33px）；读数仍逐列可对应。
- Tooltip stage 的「屏幕边缘」标签为 8px，仅作位置提示；数值以读数为准。

## Next round
G6e — 按 TASK 第五节清单补齐/重拍 12 张截图并逐张核对；ledger 三项保持
「A/B 已呈现，待人工裁定」；`git add shell docs && git commit` 后在本文件
队列全部勾选处写 `DONE`。

## 上一批（G5 已交付，勿重做）
- 动效页五段 + ParamPanel 完备已交付；本次只修补 reduceMotion 标签行，
  其余 G5 内容不要重做。
- G4 控件、G3 弹层不要改。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
