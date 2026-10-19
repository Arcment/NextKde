# 液态玻璃 Gallery — G7（SPEC §7 三项裁定落地 + 裁定页收口）

## 本轮
G7d 已交付（裁定页收口 + 6 张重拍）：
- `MotionCard.qml`：新增可选 `decision` 属性与右上「已裁定」药丸
  （`#1E7A4B` 底 + `#FFFFFF` 字，对比 5.3:1）；`decision` 为空时不渲染，
  MotionPage 的卡片不受影响。
- `DecisionsPage.qml`：三卡标记 ①B 2600ms+悬停暂停、②B +4px、
  ③A 固定 Footnote 10；A/B 两栏全部保留、未选项不删、不写推荐。
  页头改「裁定 G7 · 已裁定 G7」，标题/说明/卡文案同步现行值
  （A = 原 1600ms / 原 -6px，B = 现行）。页头下新增近不透明条带，
  修掉注释行横跨黄色饱和区时白字不可读的问题。
- 对比度（固定 ink，不再用 glassInk(0.62)）：
  dark ink `#FFFFFF`、dim `#FFFFFF @0.82`；light ink `#14161A`、
  dim `#14161A @0.86`。
- `DecisionLane.qml` 衬底由 0.22/0.34 透明度改为近不透明
  （dark `rgba(0.045,0.05,0.06,0.95)`、light `rgba(0.965,0.97,0.98,0.95)`）。
  截图实测 lane 复合色：dark 黄区 `#171613` / 红区 `#161013`，
  light 黄区 `#F7F6F0` / 红区 `#F6EFF0`。
  WCAG 对比（按最差样本）：dark ink 18.1:1、dim 12.3:1；
  light ink 16.7:1、dim 11.3:1，均 ≥ 4.5:1。
- 三个演示 lane 的浅色控件同步：按钮/chip/hover 由白色 over 近白改为
  深色 0.07/0.08/0.14（否则浅色主题下不可见）。
- 6 张重拍完成：`g7-{dark,light}-decision-{toast,tooltip,session}.png`，
  每张 `run.log` 仅既有 wallpaper colorquantizer WARN，无 QML 报错；
  pkill 锚定，无残留。静态图不判动效，只核对标记、终态与读数。

## 队列（✅=已交付）
- [x] G7a Toast 2600ms + 悬停暂停（生产）+ gallery 文案同步
- [x] G7b Tooltip +4px（StatusTooltip + DockAppNameTooltip）
- [x] G7c SPEC / INVENTORY / DEMO 三项裁定回填
- [x] G7d 裁定页「已裁定」标记 + 两主题对比度修复 + 6 张截图
- [ ] G7e ledger 收口（含生产侧人工验证项）+ `DONE`

## 必须做（人工已裁定，不要再论证）
1. Toast → B：`timeout` 默认 2600ms；悬停暂停、离开按剩余继续；
   不响应点击、不抢焦点。
2. Tooltip → B：两个组件的 -6 全部改 +4 正间隙，其余 0 不动。
3. SessionMenu → A：接受固定 Footnote 10，生产代码不动。
4. SPEC / INVENTORY / DEMO 回填三项裁定，清掉冲突旧值。
5. 裁定页保留 A/B 两栏，加「已裁定」标记；dark/light 读数与后果行
   对比度 ≥ 4.5:1；重拍 6 张。

## 已定案（不要再论证）
- 生产文件只允许改 `ActionFeedbackToast.qml`、`StatusTooltip.qml`、
  `DockAppNameTooltip.qml`。
- 截图钩子照旧：`GALLERY_PAGE=decisions`、`GALLERY_DECISION=toast|tooltip|session`。
- 静态截图不能判动效；只核对标注、终态与读数。
- StatusTooltip / DockAppNameTooltip 不被 gallery 加载：代码核对即可，
  ledger 写「需人工在真实 bar/dock 上悬停验证」。

## Ledger（G7 进行中）
- 已改：`shell/desktop/modules/common/ActionFeedbackToast.qml`
  （timeout 2600、dismissAt、HoverHandler 剩余时间续计、enabled: shown）；
  `shell/gallery/PopupsPage.qml` 的 1600 文案/非演示值同步 2600。
- ① Toast B 的固有代价：toast 可见期间其 36px 药丸区域会接收悬停
  （点击不再穿透），以换取悬停暂停；区域小且短暂。
- 悬停续计语义：暂停期间 deadline 不变，离开时按 `deadline - now`
  重启；若剩余为 0 则按 1ms 尽快收起。
- ② Tooltip +4px 已落地：`StatusTooltip.qml` 4 处、`DockAppNameTooltip.qml`
  3 处 -6 → +4，余 0 分支不动；③ SessionMenu A 无需改代码（接受固定
  Footnote 10），文档回填归 G7c。
- G7c 文档回填已落：SPEC §7 三项为「已裁定」记录，SPEC/INVENTORY 现行值
  统一 2600ms（悬停暂停）与 +4px，DEMO 增 G7 段；G6 历史读数保留并加注。
- G7d 已落：三卡「已裁定」标记（①B 2600ms+悬停暂停；②B +4px；
  ③A 固定 Footnote 10），A/B 两栏保留为记录。对比度修法：lane 衬底
  近不透明（dark `rgba(.045,.05,.06,.95)`、light `rgba(.965,.97,.98,.95)`）
  + 固定 ink（dark 白 / light `#14161A`，dim 0.82/0.86）；截图实测
  lane 复合色 dark `#171613`/`#161013`、light `#F7F6F0`/`#F6EFF0`，
  对比 dark 18.1:1 / 12.3:1、light 16.7:1 / 11.3:1。页头加同款条带
  修黄区白字；浅色 lane 的按钮/chip/hover 改深色填充。6 张
  `g7-{dark,light}-decision-{toast,tooltip,session}` 已重拍（tmp/gallery
  与 tmp/glass 各一份），run.log 无 QML 报错。
- 待办（G7e 收口）：StatusTooltip / DockAppNameTooltip 改 +4px 后
  需人工在真实 bar/dock 上悬停验证手感（gallery 不加载两者）。
- 待办（G7e 收口）：ActionFeedbackToast 悬停暂停需人工在真实桌面点一条
  通知后悬停验证「暂停 → 离开按剩余继续」；gallery 的 PopupsPage 只覆盖语法。

## 上一批（G6 已交付，勿重做）
- 裁定页三段 A/B 已交付；本次只加标记、修对比度、重拍。
- G5 动效页、G4 控件、G3 弹层不要改。

## Next round
G7e — ledger 收口：核对 `ActionFeedbackToast.qml`（2600ms 默认值、悬停暂停
按剩余续计、不抢焦点）、`StatusTooltip.qml` / `DockAppNameTooltip.qml`
（-6 已全改 +4、其余 0 未动）、SessionMenu 生产代码未动；确认 6 张
g7 截图在 `tmp/gallery` 与 `tmp/glass`；把生产侧人工验证项写清楚；
全部完成后在 state.md 单独一行写 `DONE` 并提交。

## 注意
- 不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
