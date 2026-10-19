# 液态玻璃 Gallery — G6（G5 收尾修补 + SPEC §7 三项 A/B）

## 本轮
G6b 已交付：用现有钩子重拍 reduceMotion 四段 dark 截图
`g6-dark-reduce-press/ambient/tooltip/toast`。逐张核对：press live
expansion 0.000 / effective 0ms；ambient progress 0.000 / skipped；
tooltip effective 0ms / shown；toast remaining 0ms。发现 toast 在
reduceMotion 下 remaining 残留 1600ms（绑定求值顺序问题），已改
`ToastDemo.onReduceMotionChanged` 直接按开关写 0，重拍后读数 0。
首次重拍 toast 时 quickshell 崩溃一次，重拍成功，run.log 仅 wallpaper WARN。

## 队列（✅=已交付）
- [x] G6a 修补 params reduceMotion 标签（on/off 分支）+ 重拍 params
- [x] G6b reduceMotion 其余四段截图（press / ambient / tooltip / toast）
- [ ] G6c 裁定页骨架 + Toast A/B
- [ ] G6d Tooltip A/B + SessionMenu A/B
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

## 上一批（G5 已交付，勿重做）
- 动效页五段 + ParamPanel 完备已交付；本次只修补 reduceMotion 标签行，
  其余 G5 内容不要重做。
- G4 控件、G3 弹层不要改。

## Next round
G6c — 新建 `shell/gallery/DecisionsPage.qml`（页序 6，导航「裁定 G6」），
接入 `GALLERY_PAGE=decisions` + `GALLERY_DECISION=toast`，完成 Toast
A/B 两栏（可交互、读数、后果行，不写推荐）；截图
`g6-dark-decision-toast` / `g6-light-decision-toast`。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
