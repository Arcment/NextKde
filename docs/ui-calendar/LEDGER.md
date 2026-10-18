# R0 — 第三轮：按 REVIEW.md 修复

## 本轮 (2026-10-18) — P2-6 ✅（I6：DialogButtonBox 偷文案改绑定）
- **两个编辑器同改**（`EventEditorDialog.qml` / `CalendarTaskEditorDialog.qml`）：
  删 `Component.onCompleted` 一次性拷贝，`saveLabel`/`cancelLabel` 改
  **readonly 绑定**：`count > 0 ? standardButton(Dialog.Save).text : qsTr(...)`——
  读 `count`（0→2 触发）解决标准按钮晚于根绑定求值的实例化顺序脆弱；
  读按钮 `.text` 属性让 locale 热切换可传播。qsTr 串仅作实例化前回落。
- 顶部契约注释同步改写（原注释明言 "copied in onCompleted rather than bound"）。
- **实机证据绑定生效**（zh 环境，zh 词典含 "Save"→"保存"、"Cancel"→"取消"）：
  打开事件编辑器截图 `_p26-editor.png`，footer 显示英文 "Save/Cancel"
  （= 平台标准按钮原文）——若是回落串会显示"保存/取消"，故走的是绑定而非回落。
  与改前一致（旧代码拷贝的就是同一 `.text`），**无视觉变化**。
- runtime log 0 error（无 binding TypeError）；qmlcachegen 编译两文件通过。
- 驱动：`openItem` 只开详情浮层，需再 `pointerObject detailsEdit` press+release
  才进编辑器（本轮实证）。

## 上一轮 (2026-10-18) — P2-5 ✅（I5：headerTitle 周区间走 locale 模板）
- AppTheme 新增 `formatWeekRange`（模板走 I18n.tr + 链式 .arg）；Main.qml
  headerTitle 周分支改一行调用；ZhCatalog 增 3 键。同月 "2026年10月12日 – 18日"、
  跨月 "3月30日 – 2026年4月5日" 实拍通过（`_p25-light/_p25-cross.png`）。

## 上一轮 (2026-10-18) — P2-4 ✅（C7：硬编码中性灰收敛进 AppTheme，M05 组）
- 消费点：ScheduleView scheduleField/allDayBackdrop、EventDetailsPopover 四 token、
  Main.qml:59 tahoe.contentPlane（同字面量一并收敛，超出清单 1 行已记录）。
- 同值收敛无视觉变化；light/dark 双冒烟 0 error（`_p24-dark/_p24-light.png`）。

## 修复队列（按序，一轮一条；✅=已改）
- [x] P0-1 … [x] P2-5（P0/P1 批次 + P2-1…P2-5 完成，见 git log）

## 仍差（top 8）
- P2-7 日期/时间占位符 locale 化。
- P2-8 pressDuration 纳入 reduceMotion 守卫（`Main.qml:248,675-677,802-803`）。
- P2-9 单点清理一批（见 TASK.md #29；窗口圆点顺序不动）。
- 可选：P2-2 浅色若裁定要 4.5:1 → opacity ≈0.62 或 labelSecondary；
  P2-3 today 圆标文字是否改 #FFFFFF（参考为白、现 accentText=黑，5.37:1）；
  议程徽标 10px 实拍补证。
- **驱动陷阱**：`pointer click` 无效，必须 `press`+`release`（但切视图用
  `{"action":"view","view":"month|week|day"}` 更可靠）；`date` 动作
  `{"sequence":N,"action":"date","date":"2026-03-31"}` 可跳周（P2-5 实证）；
  review-command.py 接受单对象或数组，文件必须带 `sequence`——整文件手写
  数组会卡死队列（reset 用 `printf '{"sequence":1,"action":"noop"}'`）；
  命令原地写，不原子替换；`date` 后留 2s；启动脚本重置 command.json →
  重起后先 resize 1100x692；captureClient path 相对落盘随实例 cwd 变
  （repo 根或 tmp/…/calendar/），截完用 find 找。日视图 `wheel`/`position`
  只滚时间格，议程面板未滚到。**`openItem` 只开详情浮层**，编辑器要再
  `pointerObject detailsEdit` press+release（P2-6 实证）。

## Next round
**P2-7**（I7：日期/时间占位符 locale 化，`EventEditorDialog.qml:359-394`、
`CalendarTaskEditorDialog.qml:296,304`；只做占位符这一条）。

## 注意
- 只改 finding 涉及的文件/行，不顺手重构。每轮必须构建通过 + 应用能起。
- `start-review-vm.sh` 前台脚本会被 harness 转后台；按 live-app.pid 管理，
  kill -TERM 正常退出会完整写 ics。旧实例还挂着时启动会 exit 1，先 kill。
- fixture 已含 1 个关联 VTODO（ui-review-todo-0 ↔ ui-review-0-8）。
- 启动默认 `--view week --date 2026-10-15`；fixture 在 2026-03-29…04-04。
- Wayland 嵌套会话偶发 "connection broke"：重启一次即可，不无限重试。
- 全部完成后在下面单独一行写 `DONE`。
