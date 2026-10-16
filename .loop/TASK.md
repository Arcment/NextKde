# 任务：把 KOS 日历 app 复刻成 macOS 日历的观感

## 判据
- **原子验收条目**：`tmp/ui-acceptance/calendar/spec.md`（85 个 ID：C 窗口 chrome / L 布局 / S 侧栏 / …）。
  每个 ID 是**一个**原子细节；每轮只做 2–3 个。
- **参考图**：`.loop/refs/macos-calendar.png`（唯一视觉判据），主窗口 1100x720、窄窗 760x540。
- **当前进度**：`tmp/ui-acceptance/calendar/state.md` 的 "Current round / next step" 说了从哪继续。
- 历史轮次只在 `rounds.md` 尾部看，不要全文加载。

## 这轮要接的地方
上一轮（R019 fix16）被打断在半成品状态：`EventEditorDialog.qml:182` 给不存在的
`ScrollView.interactive` 赋值，**Qt6.10.2 下应用直接起不来**。必须先把它修好，
之后才能继续 R019 的详情/编辑弹窗验收（P01/P02/P03），最后是 specs 里其余 ID 与
全量回归（含玻璃动效的前/中/后连续帧）。

## 允许不同（开题清单）
- 字体：机器上没有 SF Pro，允许现有字体近似（字宽/字重节奏必然有差）。
- 图标：没有 Apple 图标字体，允许手绘近似。
- 动画/过渡：静态截图采不到，**不许声称做过**；动效必须给连续帧证据。
- 数据模型撑不起的配色/分组允许不同。

## 硬约束
- 只在虚拟机上构建/运行/截图，禁止在本机跑项目。
- 用隔离 profile（`tmp/ui-acceptance/calendar/profile/`）与私有 D-Bus；**不许动真实日历数据**。
- 禁止 `kosctl install`；禁止重启/注销桌面会话；禁止改 KWin/合成器。
- 禁止把 `.loop/`、参考图、截图提交进 git（截图只进 `docs/ui-calendar/`）。


## 新增参考集（2026-10-16）
`.loop/refs/macos26/` — 弹框 / 浮层 / 按钮的 macOS 26 判据（HIG 官方配图 + 实测数据）。
入口先读该目录的 `README.md`。spec.md 末尾新增 D01–D13 / O01–O09 / X07。
