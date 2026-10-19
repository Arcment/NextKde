# 液态玻璃 Gallery — G7（SPEC §7 三项裁定落地 + 裁定页收口）

## 本轮
G7b 已交付：
- `StatusTooltip.qml`：`margins` 四处 -6 → +4。具体：
  `top`（dockHosted && edge==bottom）→ 4；`bottom`（!dockHosted）→ 4；
  `left`（dockHosted && edge==right）→ 4；`right`（dockHosted && edge==left）→ 4。
  其余 0 分支未动。
- `DockAppNameTooltip.qml`：`margins.top/left/right` 三处 -6 → +4，
  命中条件（bottom/right/left）不变，其余 0 未动。
- 验证：两文件 `grep -n -- '-6'` 无命中；`qmllint` 仅报环境导入解析
  警告（Quickshell/qs 模块路径），无语法错误。`qs -p shell/gallery.qml`
  启动正常，`run.log` 无 QML 报错（仅既有 wallpaper colorquantizer 警告）。
- 本轮无截图要求（G7b 的 6 张裁定图归 G7d）；两组件 gallery 不加载，
  已做代码级核对。

## 队列（✅=已交付）
- [x] G7a Toast 2600ms + 悬停暂停（生产）+ gallery 文案同步
- [x] G7b Tooltip +4px（StatusTooltip + DockAppNameTooltip）
- [ ] G7c SPEC / INVENTORY / DEMO 三项裁定回填
- [ ] G7d 裁定页「已裁定」标记 + 两主题对比度修复 + 6 张截图
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
- 待办（G7e 收口）：StatusTooltip / DockAppNameTooltip 改 +4px 后
  需人工在真实 bar/dock 上悬停验证手感（gallery 不加载两者）。

## 上一批（G6 已交付，勿重做）
- 裁定页三段 A/B 已交付；本次只加标记、修对比度、重拍。
- G5 动效页、G4 控件、G3 弹层不要改。

## Next round
G7c — 读 `.loop/TASK.md` 第四节，回填 SPEC / INVENTORY / DEMO：
toast 存留 2600ms（悬停暂停）、tooltip -6px 全改 +4px 正间隙、
§7 三项标已裁定，并 grep 清掉冲突旧值。

## 注意
- 不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。
- 全部队列项勾完，在下面单独一行写 `DONE`。
