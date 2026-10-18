# 液态玻璃组件规范 — 第 0 批

## 本轮
R2 完成：`docs/design/liquid-glass/SPEC.md`（草案 v0）已交付并提交。
内容：三层材质模型（A 纯 QML / B 每窗口一次 backdrop blur / C 白名单折射）、
token 表 v0（材质三档、圆角三档 32/24/16 + exponent 2.0、阴影收敛为 MultiEffect
唯一实现、动效 token 含 expansion 与 ambient 2600 入 token、reduceMotion=0），
组件 API 草案（GlassSurface/GlassDialog/GlassPopover/GlassMenu/GlassTooltip/
SegmentedControl/玻璃按钮/玻璃输入框），性能规则 5 条；文末 10 项待人工裁定。

DONE

## 队列（一轮一份文档；✅=已交付）
- [x] R1 `docs/design/liquid-glass/INVENTORY.md` — 三来源组件矩阵 + 重复/冲突结论
- [x] R2 `docs/design/liquid-glass/SPEC.md` — 三层材质模型、token 表、组件 API 草案、性能规则

## Next round
（无——第 0 批全部完成。）

## 注意
- 只写文档，不改源码、不构建、不启动、不截图。
- 禁止 checkout 其他分支；用 `git show <branch>:<file>` 读取。
- 读不到的标注「未找到」，不要猜。
