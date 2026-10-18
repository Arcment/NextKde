# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-18 ✅（A7 编辑器 Return 提交；实机验证）
- **实机确认现状**（改前）：harness `ReviewInput` 新增 `key(window, keyCode)`
  invokable（测试装置，非产品码），`Main.qml` 加 `key` action，发
  Qt::Key_Return。打开编辑器 → title 聚焦 → Return：弹窗仍开着（基线
  `_p18-before-editor.png` / `_p18-after-return.png`），**Return 确实不能提交**。
- **第一次改（失败）**：给 Dialog 设 `defaultButton`——构建通过但 QQC2 Dialog
  无此属性，运行时 "无法分配给不存在的属性 defaultButton"，应用起不来。
  已回退。
- **第二次改（成功）**：两个编辑器的 `contentItem: Flickable { id: editorScroll }`
  上加 `Keys.onReturnPressed`/`Keys.onEnterPressed` → `root.accept()`；
  `confirmingDelete` 时跳过（Cancel 已聚焦为默认）；多行备注 TextArea 会吃掉
  Return 换行不会误提交。文件：`EventEditorDialog.qml`、
  `CalendarTaskEditorDialog.qml`。
- 复拍（改后）：同样路径打开编辑器 → Return → 弹窗关闭、事件保存、回到周视图
  （`_p18-fixed-editor.png` / `_p18-fixed-after-return.png`）。✓ 无 QML error。
- harness 改动（ReviewInput.cpp/加 key、harness Main.qml）是测试装置，不 commit。

## 上一轮 (2026-10-18) — P1-17 ✅（A5 状态条播报 + hover 暂停；无视觉）
P1-13 收口：浅色 statusPositive #24883D=4.50:1、statusWarning #B2621C=4.51:1
（代码值 WCAG 复算达标）。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P1-18（P1 批次全部完成，见 git log）

## 仍差（top 8）
- P1-7/P1-8 键盘路径未实机逐键驱动；P1-5 校验分支未实拍；P1-4 仅证"空标题"
  分支；P1-3 弹窗标题未实拍；P1-2 议程 12h 未实机驱到。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`；命令走 argv[1]
  JSON 数组，动作名是 `captureClient`（path 相对 repo 根落盘）/`resize`/
  `date`/`openItem`/`key`（code=16777220 是 Return）；`date` 后留 2s 再点击；
  启动脚本重置 command.json → 重起后先 resize 1100x692；多条命令可一行发。
- harness `ReviewInput` 独立 cmake 构建在 harness/ReviewInput/build。
- Dialog 上不能设 `defaultButton`（QQC2 此版本无此属性，运行时 QML 报错）。

## Next round
**P2-1**（S1：9 处 8–9px 字号提到 ≥10，清单见 REVIEW.md R7 横切；横切改动
一批做完再 commit，但仍按一轮一条节奏）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
