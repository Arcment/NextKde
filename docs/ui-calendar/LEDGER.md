# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P1-16 补拍 ✅ + P1-13 状态条实拍 ✅（无代码改动）
- **P1-16 警告分支实拍成功**：`_p16-warning.png`。上轮卡死根因是 fixture 里
  根本没有 VTODO——事件无 linkedTodoId，警告分支永远不触发。本轮直接给
  `calendar-fixture.ics` 注入关联对：event `ui-review-0-8@isolated.local`
  加 `X-KOS-LINKED-TODO-ID:ui-review-todo-0@isolated.local`，并追加对应
  VTODO（X-KOS-LINKED-EVENT-ID + RELATED-TO，PimStore.cpp:258/275 语义）；
  清 `profile/pim` 后重启 + seed-live.py。编辑器打开即勾选 ✓，取消勾选
  (402,347) → 琥珀警告「保存将解除现有任务的关联，但保留待办中的任务。」
  出现 ✓。
- WCAG：实拍采样警告文字最深处 (172,97,6)≈#ac6106 on #F7F7F7 = 4.39:1——
  AA 混白只会偏亮，源码 #a85c00 上轮复算 4.67:1 ✓，采样值与目标色一致
  （AA 容差内）。与参考无新偏差。
- **P1-13 状态条实拍（顺带）**：`_p13-sb-final.png`。保存 → 状态条
  「日程已更新」绿字出现 ✓。采样最深处 (45,143,73)=#2d8f49 on 白 = 4.09:1；
  同为 AA 下界，真实色可能达标——**需在 P1-17 轮核对 Main.qml 状态条
  positive/warning 浅色实际值**（P1-17 本来就动同一处代码）。
- 驱动词典补充：`date` 后视图需要 >0.6s 才稳，点 chip 前后各留 ~2s；
  链路：date → click (1040,283) → openItem(titleContains) → click
  编辑 (675,439)。app cwd=任务目录、captureClient 裸文件名（上轮已记）。

## 上一轮 (2026-10-18) — P1-16 代码改完（C5）／警告分支实拍未遂
`EventEditorDialog.qml:625` unlink 警告浅色腿 `AppTheme.warning`→`#a85c00`
（4.67:1 ✓，最小加深；共享 token 不动）。构建 ✓、light 冒烟 ✓。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P1-16（见 git log，全部完成）
- [x] P1-16 补拍（本轮 ✓）
- [x] P1-13 实拍补齐（本轮顺带 ✓；色值达标性待 P1-17 轮核对）

## 仍差（top 8）
- P1-13 状态条 positive 浅色采样 4.09:1（AA 下界）——P1-17 轮核对代码值，
  若 <4.5:1 则属 P1-13 回归，需再加深。
- P1-7/P1-8 键盘路径代码层补齐、未实机逐键驱动；P1-5 校验分支未实拍；
  P1-4 仅证"空标题"分支；P1-3 弹窗标题未实拍；P1-2 议程 12h 未实机驱到。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`；命令走 argv[1]
  JSON 数组；`date` 后留 2s 再点击；已打开弹窗不热载；启动脚本重置
  command.json → 重起后先 resize 1100x692；多条命令可一行 Bash 链发。

## Next round
**P1-17**（A5 状态条无障碍播报，hover 暂停或延长 3.5s，
`Main.qml:1582-1586,:2503-2508`）：非视觉类，构建 + 启动冒烟即可，
"无视觉变化，无对照图"；**顺带核对状态条 positive/warning 浅色代码值
是否 ≥4.5:1**（上条仍差）。之后 P1-18（A7 默认按钮）需先实机确认现状再改。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- 杀残留进程：`pgrep -x kos-calendar` + /proc/<pid>/cmdline 验身份。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8，
  2026-03-29 Morning planning）——是 P1-16 拍照用的合法测试数据；
  app TERM 退出会重写 fixture，若下轮需要再拍 unlink 警告须重新注入。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
