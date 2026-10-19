# 液态玻璃 Gallery — S2（scene 收口）

## 本轮（S2 已交付）
### 已改
1. **首帧采样** — `shell/gallery/ScenePage.qml:204-211` 把 `sourceRect` 从
   `mapToItem` 改成纯算术 rect（`scenePill.x/y - viewport.x/y - flick.x/y +
   contentX/contentY`，并读 `rowsColumn.height`/`flick.contentHeight` 注册依赖）：
   原实现在构造期求值后，`contentY=0` 不再触发重算，胶囊一直采到自己上方的条带。
   另加 `ScenePage.qml:257-272` 首帧 260ms Timer + `contentHeight` 变化 +
   `moving` 变 false 三处 `refresh()`，`SceneGlassPill.qml:45` 调
   `ShaderEffectSource.scheduleUpdate()`。证据：`s2-dark-a` 胶囊内可见 6 个模糊
   圆点和两侧条带。
2. **tonal ink** — `ScenePage.qml:247` 改用 `tonalPill.foregroundColor`，不再写死主题 ink。
3. **declared tone** — `ScenePage.qml:45-57` 缺省 `declared`，`GALLERY_SCENE_INK=fixed`
   切回固定 ink；`pillRow`（`:50`）减去 `stage.y`，修正原先行号偏一行的问题。
   证据：`s2-light-b`（declared 深字）vs `s2-light-fixed`（fixed 白字），
   白字在浅色胶囊上明显发虚。
4. **dark tint** — `ScenePage.qml:213` 0.30 → 0.18（浅色保持 0.32）。
5. **纹理高度下限** — `SceneGlassPill.qml:40` 高度改为 `max(12, round(height/6))`。
6. **折射判据** — `ScenePage.qml:147-161` 每行两条 48px 宽、6px 亮/6px 暗的竖条带，
   分别跨过胶囊左右边缘；条带只压在边缘，不把胶囊中心的底色平均掉。
   `crop-s2-refract.png` 中左缘条带在玻璃内被压缩/错位，右缘圆点被抹开。
7. **版面** — `ScenePage.qml:193-233` 两枚胶囊移到 dot 列上方上下排列
   （x+330，row 0 / row 1），行标题不再被压；caption 收进 stage 下方图例（`:275+`）。

### 仍差
- tonal 胶囊（无采样）在浅行上仍是面板给的主题白字，对比度偏低：面板按自身材质
  给前景色，并不知道下面压着浅行。未改现役组件。
- 暗色胶囊已不接近纯黑，但采样 50/50 条带后的平均值仍是中灰，细节主要靠圆点/条带读。
- 折射是定性证据（边缘条带可见压缩/错位），静帧量不出 3.5px 位移。

### 外推
- 要让 tonal 也随背景行切 ink，需要面板暴露"背景 tone"输入或由页面按行覆写
  foregroundColor；属于组件 API 变更，不在本轮范围。

### 截图（`tmp/glass/`，逐张已读）
- `s2-dark-a.png` offset 0 dark declared：首帧胶囊内有圆点+条带。
- `s2-dark-b.png` offset 600 dark declared；`s2-light-a.png` offset 0 light declared。
- `s2-light-b.png` offset 600 light declared（浅行深字）vs
  `s2-light-fixed.png` 同位置 fixed（白字对比明显更低）。
- 辅助裁图在 `tmp/gallery/`：`crop-s2-dark-a.png`、`crop-s2-ink-compare.png`、
  `crop-s2-refract.png`。
- `run.log` 无 QML 报错，仅有 wallpaper colorquantizer 警告。

## 队列（✅=已交付）
- [x] S2 首帧采样 / ink 可读性 / dark tint / 纹理下限 / 折射判据 + 5 张截图

## 已定案（不要再论证）
- 纯 QML：`ShaderEffectSource` + `ShaderEffect`（qsb），`useKwinEffect: false`，不碰 KWin。
- sampler 属性名 `source`；shader 照 `squircle.frag` 模板，`qsb --qt6` 烘焙。
- 截图：offset 0/600 × light/dark + 一张 fixed，共 5 张。
- 环境变量：`GALLERY_PAGE=scene`、`GALLERY_SCENE_OFFSET`、`GALLERY_SCENE_INK`。

## 上一批（S1 已交付，勿重做）
- `ScenePage.qml` + `SceneGlassPill.qml` + `scene_glass.frag(.qsb)`；
  同窗口采样已在 offset 600 的截图里成立。

## 注意
- 只改 `shell/gallery.qml`、`shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 不改现役组件、不改 `shell/shell.qml`、不改 CMake、不改 KWin。
- 每轮结束前：截图 + state.md + commit。

DONE
