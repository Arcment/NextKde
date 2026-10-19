# 液态玻璃 Gallery — S3（ink 判定收口）

## 本轮
- `shell/gallery/ScenePage.qml:60-99` — ink 判定改为
  `effectiveLum = mix(rowLum, tintLum, tintStrength)`（深 0.18 / 浅 0.32），
  阈值实测取 0.34；scene 与 tonal 共用 `inkFor()`。
- `shell/gallery/ScenePage.qml:292` — tonal 胶囊文字直接设 `page.tonalInk`，
  不再依赖 `tonalPill.foregroundColor`。
- `shell/gallery/ScenePage.qml:425-437` — 只读读数
  `rowLum / effectiveLum / ink`，scene 与 tonal 各一组。
- `docs/design/liquid-glass/DEMO.md` — 记录公式、阈值依据与外推。

## 验证（4 张，tmp/glass/）
- s3-light-a（offset 0）：scene 0.058→0.359，tonal 0.917→0.944，两枚均 `#16181c` 深字。
- s3-light-b（offset 600）：scene 0.917→0.944，tonal 0.058→0.359，两枚均深字。
- s3-dark-a（offset 0）：scene 0.058→0.048 浅字，tonal 0.917→0.752 深字。
- s3-dark-b（offset 600）：scene 0.917→0.752 深字，tonal 0.058→0.048 浅字。
- `run.log` 无 QML 报错；仅 wallpaper colorquantizer WARN。

## 仍差
- 4 张截图内容区背后残留一块 KWin 调试控制台窗口（本轮排查环境时打开；
  KWin 内部窗口，Alt+F4 / KWin 脚本 / 快捷键均无法关闭）。它位于 gallery
  内容之下、背景板之上，未遮挡两枚胶囊与读数，不是 QML 渲染问题。
  下轮若需要干净底图，需重启 KWin 或注销；本轮按纪律不碰 KWin。
- 阈值 0.34 依赖当前行色与 tintStrength；任一改动后需重测。
  0.45 不可用：浅色 + 深行的 0.359 会被误判为浅字。

## 外推
- 真正的修法是组件 API 增加「背景 tone」输入（组件变更，不在 gallery 轮范围），
  让面板接收下层亮度而不是 gallery 侧代算。
- 反例已关闭：浅色主题 + 深色行不再出现浅字，且两枚胶囊用同一规则。

## 队列（✅=已交付）
- [x] S3 ink 判定统一到材质实际亮度 + 4 张验收截图

## Next round
待定 — 队列已清空，等下一批任务书。

DONE
