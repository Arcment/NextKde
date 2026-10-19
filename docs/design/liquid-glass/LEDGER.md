# 液态玻璃组件规范 — 第 0 批续（R3/R4）

## 本轮
R3 完成：INVENTORY.md 追加 §4-§11 —— tooltip/toast/notification、menu、
dialog 全量（11 个）、控件补全（checkbox/combobox/scrollbar/segmented）、
字阶与间距实测、深浅 tint 对照表、4 项工程可查项全部关闭
（KWin 折射默认 0；PageMotion=KosPageMotion 薄包装；bar 面板未统一走
ControlCenterGlass；liq 是 KWin 侧 dock 动画）。人工项仅剩 weather tint
公式、scrim 下发链路、3 个纯视觉项。

## 队列（一轮一份文档；✅=已交付）
- [x] R3 更新 `INVENTORY.md` — 补全 tooltip/toast/notification/menu/dialog/控件、
      字阶/间距、深色 tint；关闭 4 项工程可查项
- [ ] R4 重写 `SPEC.md` v1（Apple HIG 基线 + 完整 token + 组件 API + ≤5 项裁定）
      + 新增 `DEMO.md`（gallery 页面结构与状态矩阵）

## 上一批已交付
- [x] R1 `INVENTORY.md`（初版，15 行矩阵）
- [x] R2 `SPEC.md`（草案 v0，三层材质模型）

## Next round
R4 — 先读 `.loop/TASK.md` 的 SPEC v1 / DEMO.md 要求，再读本仓库
`docs/design/liquid-glass/INVENTORY.md`（含新 §4-§11）与现有 `SPEC.md`；
重写 SPEC.md 为 v1（HIG 数值硬约束 + token 带「依据」列 + 13 个组件 API +
≤5 项待人工裁定），新增 DEMO.md（gallery 设计，只写设计不写代码）。
数据源：INVENTORY §4-§11 已有 `文件:行`，可直接引用，不必重扫源码。

## 注意
- 只写文档，不改源码、不构建、不启动、不截图。
- 禁止 checkout 其他分支；用 `git show <branch>:<file>` 读取。
- HIG 字阶不允许自创档位；每个 token 值必须标注依据
  （HIG / `文件:行` / 「v1 提案」）。
- 完成后单独一行写 `DONE`。
