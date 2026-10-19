# 液态玻璃 Gallery — G2（弹层页）

## 本轮
G2f 收口完成：五类弹层 light/dark 共 10 张截图全部用最终代码重拍
（g2a-popover / g2b-menu / g2c-tooltip / g2d-toast / g2e-notification），
run.log 仅有 colorquantizer wallpaper 警告，无 ERROR / TypeError / Non-existent。
核对 `DEMO.md`：§5 轮次表与实际一致；§2 弹层页给 GlassDialog 标注 G3。
G2 队列全部完成。

## 已改（G2f）
- 重拍 `tmp/gallery/g2{a,b,c,d,e}-*{light,dark}.png`（副本同步 `tmp/glass/`）。
- `GalleryRoot.qml` 占位页 note：控件 G3→G4、动效 G4→G5（与导航 model 一致）。
- `DEMO.md` §2-3 行首改为「GlassDialog（G3；…」；§5 无需改动。
- 截图实测：popover/menu/tooltip/toast/notification 五类均正常唤起；
  popover radius 16 / 阴影偏移可见；menu 项距 28、分隔线 1px、disabled 灰显；
  tooltip thick / radius 10 / 字号 12 SemiBold + 10 Medium；
  toast 双丸并排、高 36、caption 常显说明；notification 卡宽 360、
  容器 24 / entry 与 pill 16、字阶 17/13/11/10。

## 仍差 top 6
1. Toast 存留 1600ms（SPEC §7-① 待裁定）与显 150 / 隐 180、0.96→1 动效
   只按代码落地，静态截图不能判。
2. dark 下 glass fallback 近白文字：通知卡白字落在黄色背景区可读性弱
   （fallback-vs-fallback），与 KWin 效果下的表现不等价。
3. Tooltip 贴边未达 -6：实测按钮底 y≈145、tooltip 顶 y≈151，仍有约 6px
   间隙（目标为重叠 6px，差异约 12px）→ SPEC §7-② 待裁定。
4. 菜单打开后键盘焦点归属未验证；Up/Down/Return 挂在主窗口 Shortcut。
5. Notification hover（填充 0.05→0.11、描边 0.10→0.36）只按代码落地，
   静态截图无法验证。
6. 弹层窗口阴影余量计入输入区域（popover/menu 未做 mask）；notification
   演示时隐藏 token 汇总列（版面取舍，Esc 后恢复）。

## 外推待确认
- Tooltip 悬停 700ms 显示（TASK G2c 标注外推，SPEC 未定）。
- Popover 锚点间距 8（SPEC 未定，外推）。
- Tooltip 贴边 margin -6（SPEC §7-② 待裁定，见仍差 3）。
- Toast 存留 1600ms（SPEC §7-① 待裁定）。
- Menu 项高 28 为 HIG 下界外推（聚焦环渲染约 26–28px，取 28）。

## Next round
无 — G2 队列完成。

DONE
