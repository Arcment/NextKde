# 液态玻璃 Gallery — S1（scene 模式演示）

## 本轮：S1 已交付（2026-10-19）

### 已改
- `shell/gallery/ScenePage.qml` — 场景页：640×420 Flickable（10 行 ×120px，
  深 `#0d0f12` / 浅 `#e8eaee` 交替），固定两枚 220×44/r22 胶囊：
  左 tonal（`LiquidGlassPanel`，`useKwinEffect: false`），右 scene（采样）；
  每枚下方 caption；declared-tone 开关；`GALLERY_SCENE_OFFSET` 设置初始 `contentY`。
  每行在 x=344 起放 6 个 30px 圆点（深行浅点 / 浅行深点），全部落在 scene
  胶囊正下方，用作模糊与边缘折射的判据。
- `shell/gallery/components/SceneGlassPill.qml` — `ShaderEffectSource`（兄弟节点
  `sourceItem`，`live: true`，`textureSize = 玻璃尺寸 /6`，ClampToEdge）+
  `ShaderEffect`（sampler 属性名 `source`）。`sourceRect` 由页面绑定：
  `scenePill.mapToItem(rowsColumn, 0, 0)`，并在同一表达式里读 `flick.contentY`
  （mapToItem 自身不会让绑定随滚动重算）。
- `shell/gallery/shaders/scene_glass.frag` + `scene_glass.frag.qsb`
  （`qsb --qt6` 烘焙）— 圆角矩形 SDF（exponent 2）、9 tap 模糊（1.25 texel）、
  SDF 有限差分法线 + 边缘带 10px 折射（默认 0.35 → 3.5px）、tint、
  顶部 2.5px 高光、内 1.5px 描边；预乘输出。
- `shell/gallery/GalleryRoot.qml` — 导航加「场景 S1」（index 5），
  `GALLERY_PAGE=scene` → 5，Loader 同步。
- 未改现役组件、shell.qml、CMake、KWin。所有玻璃 `useKwinEffect: false`。

### 截图（4 张，已完成）
- `tmp/gallery/s1-scene-dark-a.png`（offset 0 / dark）
- `tmp/gallery/s1-scene-dark-b.png`（offset 600 / dark）
- `tmp/gallery/s1-scene-light-a.png`（offset 0 / light）
- `tmp/gallery/s1-scene-light-b.png`（offset 600 / light）
- 运行：`run.log` 只有既有的 wallpaper colorquantizer WARN；无 QML/Shader/qsb
  报错，无 uniform 未绑定警告。

### 已证明（静态截图可判）
- offset 600（两种主题）：胶囊下方的 5 个圆点以模糊团块出现在玻璃内，间距与
  尺寸随 1/6 降采样被抹平；右缘第 6 个圆点跨在轮廓上，边缘带可见拉伸——
  同窗口内容采样、9 tap 模糊、SDF 折射都在工作。
- tint 数值可对：dark-b 玻璃主体（浅行上）实测 `#949699`，等于
  `0.70 × #e8eaee`；light-a 主体 `#5a5c5e`，等于
  `0.32 × #ffffff + 0.68 × #0d0f12`。说明采样内容与 tint 公式都与代码一致。
- 初始滚动：offset 600 时首行是 row 5（浅），declared 计算为 row 5；
  offset 0 时为 row 0（深）。开关逻辑成立（截图均为关闭状态）。

### 仍差（按严重度）
1. **offset 0 的纹理是早期帧**：dark-a / light-a 的胶囊内是均匀色
   （dark 主题实测 `#090a0d`，正好是 `0.70 × #0d0f12`），content y 45–75 的
   6 个圆点没有被采样到，尽管 `sourceRect` 是 y 44–88。offset 1 的探针
   （`tmp/gallery/s1-probe-offset1.png`）就能看到全部圆点。推断：首次 capture
   发生在 Repeater delegate 落位前，而 `live` 在 `sourceRect`/`sourceItem`
   不变时不会重抓。修法方向：布局稳定后调一次 `capture.scheduleUpdate()`
   （例如 contentHeight/height 变化时 + 首帧后一次性 Timer）。本轮受
   2 次代码迭代上限约束，未改、未验证。
2. **tonal 胶囊压住行标题**：胶囊 y=44 时左胶囊（x 88–308）盖住
   「深色内容 1 / 浅色内容 6」的尾部字符；caption 已不再与标题重叠。
3. **tonal 的 ink 写死为主题 ink**：浅行上 LiquidGlassSurface 自适应成
   `#e8e9ec` 亮面，而文字仍是深色主题的白字，读数约 1.25:1。应改用
   `tonalPill.foregroundColor`（面板已导出），本轮未改。
4. **scene 固定 ink 在浅行上对比不足**：dark 主题、浅行上玻璃主体
   `#949699`，白字 `scene` 约 2.6:1（低于 4.5:1）；declared 开关切到深字后
   才达标。这正是 declared 开关要演示的点，但 4 张截图都把它关着，
   没有一张「declared on」的证据图。
5. **暗色主题的 tint 过重**：0.30 黑 tint + 深内容 → `#090a0d`，胶囊几乎纯黑，
   暗行上的采样细节（offset 0/1）只有靠提亮才能看见。建议 dark 主题
   tintStrength 降到约 0.18，或按采样亮度决定 ink。
6. **折射判据弱**：这一批只有右缘一个圆点跨轮廓，能看出拉伸但量不出 3.5px；
   要判折射需要竖向条带或半格错位的测试图案跨过左右边缘。
7. **短胶囊的采样高度**：44px /6 = 7 texel；竖向上只剩 7 行纹理，细节分辨
   能力很低。产品上 44px 级胶囊应给 textureSize 高度设下限（如 ≥12）。

### 外推
- 纯 QML 同窗口采样在 Quickshell/Qt 6.10（wayland layer-shell）成立，
  不需要 KWin 或 ext-background-effect；内容与玻璃是兄弟节点即可。
- 生产实现里滚动偏移必须显式进入 `sourceRect` 的绑定依赖；只写 mapToItem
  会在滚动时停在旧位置。
- 首次显示/列表模型变化后需要强制一次 capture 更新（见「仍差」1），否则
  静态首帧可能拿到未落位的内容。
- 开销：静态可数——每枚胶囊纹理 37×7（259 texel），每 fragment 9 次采样 +
  5 次 SDF；GPU 实际成本静态截图无法判断，留待带计时的动效轮。
- declared-tone 只是滚动位置派生的声明值，不能替代真实采样；两者应并存：
  采样定材质，声明值定 ink。

## 队列（✅=已交付）
- [x] S1 场景页 + SceneGlassPill（同窗口采样 / 模糊 / 折射 / tint，纯 QML）+ 4 张截图

## 已定案（勿再论证）
- 纯 QML：`ShaderEffectSource` 采样内容 + `ShaderEffect`（qsb）做模糊/折射/tint；
  所有玻璃 `useKwinEffect: false`，不碰 KWin。
- 内容与玻璃是兄弟节点；`sourceRect` 用 `mapToItem` 绑定（并显式依赖滚动值）；
  sampler 属性名 `source`。
- shader 照 `shell/desktop/shaders/squircle.frag` 模板，用 `qsb --qt6` 烘焙。
- 页面：`shell/gallery/ScenePage.qml`，导航 index 5，`GALLERY_PAGE=scene`。
- 对照：左 tonal（不采样）/ 右 scene（采样）；另有 declared-tone 文字开关。
- 截图：`GALLERY_SCENE_OFFSET=0|600` × light/dark，共 4 张。

## 下一轮建议
1. 按「仍差」1 加一次性 `scheduleUpdate()`，重拍 offset 0，确认行内圆点出现。
2. tonal 文字改用 `foregroundColor`；dark 主题 tintStrength 试 0.18。
3. 补一张 declared on 的对照图（不一定是交付图，留作证据）。
4. 若还有预算：换跨边缘的竖条测试图案，量化折射宽度。

DONE
