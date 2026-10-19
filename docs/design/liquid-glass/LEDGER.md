# 液态玻璃 Gallery — G7（SPEC §7 三项裁定落地 + 裁定页收口）

## 本轮
G7e 已交付（ledger 收口 + DONE）：
- 生产侧核对：
  - `ActionFeedbackToast.qml`：`timeout` 默认 2600ms（line 10）；
    `show()` 重置 `dismissAt = now + timeout` 与 `hold.interval`；
    `HoverHandler` 进入时 `hold.stop()`，离开时 `left = max(1, dismissAt - now)`、
    把 interval 设为 left 后重启，按剩余时间继续（不重置 2600ms）；
    `enabled: shown`，仅 HoverHandler 被动观察，无点击处理器、无 focus 抢占。
  - `StatusTooltip.qml`：4 处贴边 -6 → +4（commit 567c7be1）；其余 0 分支未动。
  - `DockAppNameTooltip.qml`：3 处 -6 → +4（同 commit）；其余 0 分支未动。
  - SessionMenu：裁定 A，生产代码未动；G7 全部提交（de00ba56 / 567c7be1 /
    c70ea780 / b77cae10）均未触碰任何生产 session 文件；仅 gallery
    `DecisionSessionLane.qml` 在 G7d 更新。
- 截图：6 张 `g7-{dark,light}-decision-{toast,tooltip,session}.png` 同时在
  `tmp/gallery/` 与 `tmp/glass/`，逐对 `cmp` 一致，1280×800 RGBA。
- 起应用回归：`tmp/gallery/run.sh dark` 启动 13s，`run.log` 无
  ERROR / TypeError / Non-existent；仅既有 wallpaper colorquantizer 加载 WARN
  与 ProxyFloatingWindow 两条 deprecation WARN。`pkill` 锚定
  `^qs -p shell/gallery.qml`，无残留 gallery 进程。
- **生产侧人工验证项（gallery 无法覆盖，需真机确认）**：
  1. Toast：真实桌面触发一条 action toast；悬停 ≥1s 不消失，离开后按剩余
     时间消失（不是重新 2600ms）；悬停期间在 36px 药丸内点击不触发该区域
     下方内容（悬停暂停的已知代价），toast 不抢焦点。
  2. Tooltip：真实 bar（bottom/left/right 三种 dockEdge）与 dock 图标悬停，
     确认 +4px 正间隙、不重叠、不脱离锚点。
- 已知残留（非 G7 队列项）：G5 演示页 `ToastDemo.qml` / `MotionPage.qml`
  仍以 1600ms 标注历史 token 并写「待裁定」；G7c 只回填 SPEC / INVENTORY /
  DEMO，未纳入改动清单，现行统一口径以裁定页与 SPEC §7 为准。

## 队列（✅=已交付）
- [x] G7a Toast 2600ms + 悬停暂停（生产）+ gallery 文案同步
- [x] G7b Tooltip +4px（StatusTooltip + DockAppNameTooltip）
- [x] G7c SPEC / INVENTORY / DEMO 三项裁定回填
- [x] G7d 裁定页「已裁定」标记 + 两主题对比度修复 + 6 张截图
- [x] G7e ledger 收口（含生产侧人工验证项）+ `DONE`

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

## Ledger（G7 已收口）
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
- G7e 收口：生产三文件按裁定复核通过（2600 / 悬停续计 / +4×7 / 0 分支不动）；
  SessionMenu 生产代码未动；6 张截图两目录逐对一致；应用启动 run.log 无
  QML 报错（仅既有 wallpaper WARN 与 ProxyFloatingWindow deprecation WARN）；
  生产侧人工验证项已写入「本轮」。G7 队列全部勾完。

## 上一批（G6 已交付，勿重做）
- 裁定页三段 A/B 已交付；本次只加标记、修对比度、重拍。
- G5 动效页、G4 控件、G3 弹层不要改。

## Next round
无 — G7 队列全部交付。后续如继续：仅剩 G5 演示页 `ToastDemo.qml` /
`MotionPage.qml` 的 1600ms 历史标注可选同步，以及上面两项真机人工验证。

## 注意
- 不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。

DONE
