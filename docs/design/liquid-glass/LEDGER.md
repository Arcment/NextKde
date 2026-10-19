# 液态玻璃组件规范 — R5

## 本轮
R5 完成：
1. `INVENTORY.md` 追加 §12 —— Slider（LiquidSlider/KosSlider/ColorRampSlider）、
   Switch（LiquidGlassSwitch，实名更正：无 "LiquidSwitch" / KosSwitch）、
   NavBar（LiquidNavBar，判定为导航容器）三表 + controls 目录终查
   （ControlForm/SelectionHighlight/VectorIcon）+ 两项工程项关闭
   （weather tint/模糊公式、LiquidGlassPanel scrim 逐跳链路）；§11 结算。
2. `SPEC.md` 升 v1.1 —— API 13→16（+GlassSlider/GlassSwitch/GlassNavBar 容器
   契约）；weather/scrim 结论回填 §1.1/§1.4；§2.7 动效表补 slider/switch 时长；
   §7 收敛到 3 项（Toast 1600ms / Tooltip -6 / SessionMenu 比例字号）并重编号；
   §5/§6 交叉引用同步。
3. `DEMO.md` 同步 —— 组件数 16、控件页清单 +Slider/Switch/NavBar（NavBar 演示
   归表面页）、状态矩阵裁剪规则、G4 轮次内容、§7 3 项 A/B 并排。

## 队列（✅=已交付）
- [x] R5 补 Slider/Switch/NavBar 盘点与 API；关闭 weather tint 与 scrim 链路两项；
      SPEC v1.1 + DEMO 同步

## 上一批已交付
- [x] R1 `INVENTORY.md` 初版
- [x] R2 `SPEC.md` v0
- [x] R3 `INVENTORY.md` §4-§11 补全
- [x] R4 `SPEC.md` v1 + `DEMO.md`

## Next round
无 —— 队列已清空。

## 注意
- 只写文档，不改源码、不构建、不启动、不截图。
- 禁止 checkout 其他分支；用 `git show <branch>:<file>` 读取。
- 完成后在下面单独一行写 `DONE`。

DONE
