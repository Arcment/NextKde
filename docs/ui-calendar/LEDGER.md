# R0 — 收尾轮：人工裁定后执行

## 本轮
- P1-A6b 完成：`Main.qml` 窗口圆点 delegate — MouseArea 14×14 fill → **22×22 居中**（中心距 28 不重叠，Row/视觉几何一律未动）；`Accessible.role: Button` + name Minimize/Zoom/Close（qsTr）；`activeFocusOnTab` + Return/Enter/Space 触发同一 `activate()`；焦点反馈 = opacity 0.85→1.0 + 1px `AppTheme.text` 边，仅键盘聚焦时出现。
- 截图核验：`shots/p1a6b-light-full.png` + 4x 裁块 `shots/p1a6b-dots-4x.png`。数值：圆心 1022/1050/1078、间距 28、disc 14（核心 13+AA）、上缘 10.5、无焦点边框 —— 与 R126 改前记录**逐项一致**，常态外观零变化。
- 构建✅ light 启动✅ runtime log 无 error。

## 队列（一轮一条；✅=已改）
- [x] P2-3a 月视图 today 文字 → `"white"`
- [x] P1-A6b 窗口圆点：命中区 22×22、Accessible.role/name、键盘可达（视觉几何不动）
- [ ] VERIFY-1 议程徽标 10px 补拍
- [ ] VERIFY-2 新建任务编辑器空占位符补拍

## 仍差
*(无)*

## Next round
VERIFY-1 — 补拍议程面板徽标 10px（P2-1 遗留）：启动 light，打开议程/日程面板，
截含徽标的整图，Pillow 裁徽标小块（绝对路径），确认 10px 呈现。拍不到写欠账，最多 2 次回路。
之后 VERIFY-2 — 新建任务编辑器空字段占位符补拍（打开"新建任务"弹窗截图）。
两条都完成 → state.md 单独一行 `DONE`。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。
- 每轮必须构建通过 + 应用能起。
- 全部完成后在下面单独一行写 `DONE`。
