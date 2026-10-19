# 液态玻璃组件规范 — 第 0 批续（R3/R4）

## 本轮
R4 完成：SPEC.md 重写为 v1（三层材质模型定案 + KWin 默认值/深浅 tint 实测
入表 + HIG 字阶硬约束与现值归并表 + 间距四档 + 动效 token 含 reduceMotion=0
贯通方案 + 13 个组件 API + 机械迁移清单 §6 + 待人工裁定收敛到 5 项）；
新增 DEMO.md（apps/gallery 设计：构建挂载方式、五页结构、
浅/深×三材质×六状态矩阵、现场可调参数、G1-G5 迭代计划、只看不判边界）。
工程决策项（控件双家族、颜色入口、reduceMotion 贯通、scrim 单一来源等）
全部在 v1 内定案，未留给人工。

## 队列（一轮一份文档；✅=已交付）
- [x] R3 更新 `INVENTORY.md` — 补全 tooltip/toast/notification/menu/dialog/控件、
      字阶/间距、深色 tint；关闭 4 项工程可查项
- [x] R4 重写 `SPEC.md` v1（Apple HIG 基线 + 完整 token + 组件 API + ≤5 项裁定）
      + 新增 `DEMO.md`（gallery 页面结构与状态矩阵）

## 上一批已交付
- [x] R1 `INVENTORY.md`（初版，15 行矩阵）
- [x] R2 `SPEC.md`（草案 v0，三层材质模型）

## Next round
无 —— 队列已清空。

## 注意
- 只写文档，不改源码、不构建、不启动、不截图。
- 禁止 checkout 其他分支；用 `git show <branch>:<file>` 读取。
- HIG 字阶不允许自创档位；每个 token 值必须标注依据
  （HIG / `文件:行` / 「v1 提案」）。
- 完成后单独一行写 `DONE`。

DONE
