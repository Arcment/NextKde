# macOS 26 (Tahoe) 弹框 / 浮层 / 按钮 — 验收参考资料

来源：Apple Human Interface Guidelines（2026 版，`developer.apple.com/design/human-interface-guidelines/`
的 JSON 原文），抓取日期 2026-10-16。图片为 HIG 官方配图（2x）。
本目录是**弹框类验收的唯一外部判据**；日历主界面仍以 `macos-calendar.png` 为准。

## 目录里的图

| 文件 | 是什么 |
|---|---|
| `alert-macos.png` | **macOS 26 警报框实物图**（最权威的一张） |
| `sheets-macos-notes.png` | macOS 工作表压在变暗的父窗口上（Notes 的 What's New） |
| `offering-help-macos-tooltip-help-tag.png` | macOS Finder 工具栏按钮的 **tooltip 实物图** |
| `attached-popover.png` / `detached-popover.png` | 日历日程的浮层：附着态 / 可拖出的分离态 |
| `components-context-menu-intro.png` | 右键菜单 |
| `components-menus-intro.png` | 菜单（含子菜单、选中项） |
| `components-popover-intro.png` / `components-sheet-intro.png` | 浮层 / 工作表的风格化示意 |

## 从 `alert-macos.png` 实测到的硬数据

- 父窗口整体**变暗**（scrim），窗口内容仍是可辨认的灰，不是纯黑遮罩。
- 弹框是**独立圆角卡片**浮在中央，圆角明显大于普通控件。
- 标题**左对齐加粗**，正文在其下，字号小一档、常规字重。
- **按钮竖排、通栏、等宽**（不是横排右对齐！），上下两个按钮间距很小。
  - 主按钮：**实心强调色填充 + 胶囊圆角**，文字居中、白色。
  - 次按钮：**浅灰填充 + 同样胶囊圆角**，文字居中、深色。
- 两个按钮**尺寸完全一致**，只有填充色区分层级。

> 这条与 KOS 现有 `DialogButtonBox`（横排、右对齐、保存/取消）**不同**。
> 若按参考图直译，弹框底部应是竖排通栏按钮。

## HIG 文字规定（原文要点）

### 警报 / Alerts
- 每个警报只给**必要信息 + 有用的动作**；纯告知不打断。
- 结构：标题 + 可选说明文字 + **最多三个按钮**。
- 标题不要写成 "Error" 或 "Error 329347"；完整句用句末标点，片段用标题式大小写、不加句末标点。
- 说明文字尽量短，完整句子、句子式大小写。
- 如果标题和按钮文字已经够清楚，**不要再解释按钮是干什么的**。
- macOS 警报可以带图标、附件视图、抑制开关、Help 按钮。

### 工作表 / Sheets（macOS 的模态弹框）
- macOS 的 sheet 是**圆角卡片**，浮在父窗口之上；父窗口**变暗**表示暂时不可交互，
  但**应用的其他窗口仍可交互**。
- 用户一般不期望拉伸 sheet，所以尺寸要贴合内容；但支持拉伸是加分项。
- 按钮语义：`取消/关闭` = 不保存直接退出；`完成/Done` = 保存后退出；
  `返回/Back` = 回上一层，**不是**用来关闭 sheet 的。
- **给了 Done 就必须配一个 Cancel**（或 Back），否则用户没有"不保存退出"的出口。
- 不要 sheet 套 sheet：要弹第二个就先把第一个关掉。
- 模态任务如果层级太深，用户会忘记自己从哪来；必须只有一条路径。

### 按钮 / Buttons
- 按钮要靠**尺寸、颜色、形状** + 图标/文字 + **系统语义角色**三件事说清功能。
- 按钮周围必须留够空间，命中区至少 **44x44 pt**。
- **没有按下态**的按钮会让人觉得没反应。
- 强调按钮用来吸引注意，**每个视图最多一两个**；太多强调按钮反而增加认知负担。
- 一组并列选项要用**同样尺寸**的按钮；不同尺寸并排会显得混乱不一致。
- 要突出首选，就用更强调的样式，其余用较弱样式——而不是改尺寸。
- 内容区已经很花哨时，按钮文字优先用**单色**默认外观。
- macOS 上鼠标悬停一会儿后系统会显示 **tooltip**，用一句短语说明按钮做什么。
- 标题里带**省略号**表示"还会打开下一层"（例：Safari 设置里的 Edit…）。
- macOS 特有按钮：push button（标准）、square button（图标、贴着它影响的视图）、
  help button（圆形问号）。

### 提供帮助 / Tooltips
- macOS 在指针悬停片刻后显示 tooltip；tooltip 是一句**简短短语**说明控件做什么。
- 不要描述"按钮长什么样"，要描述**这个动作在你的应用里干什么**。
- 文案要贴合当前上下文，用词和平台一致（别让 Mac 用户"点击 iPhone 上的按钮"）。

### 右键菜单 / Context menus
- 只列**当前上下文相关**的动作，不是功能全集。
- 太长会难扫难滚；分组用分隔线，**一般不超过三组**。
- 子菜单最多一层，且标题要能让人预判内容。
- 破坏性项（Delete / Remove）**排在最后**。
- 菜单里**不要重复显示快捷键**——右键菜单本身就是快捷方式。
- 菜单可能在内容上方或下方展开；必要时项目顺序要跟着翻转。
- macOS 的例外：剪切/复制/粘贴即使当前不可用也可能出现在菜单里。

### 浮层 / Popovers
- macOS 上 popover 可以**拖出来变成独立面板**，原浮层的内容和外观保持一致以维持上下文。
- 日历日程的浮层有附着态（attached，指着日程）和分离态（detached）两种。

### 模态 / Modality
- 只有"帮助聚焦"或"让用户确认/修改刚做的操作"时才用模态。
- 关闭模态若可能丢失用户输入，必须**说清后果并给出解决路径**。
- macOS / tvOS 用户预期关闭按钮在**主内容视图**里（不是顶部工具栏）。

## 与本仓库既有标准的对齐（KOS `shared/qml/foundation`）

弹框类控件必须复用这些既有 token，不要另起一套：

- 圆角：`AppTheme.smallRadius` 12 / `mediumRadius` 20 / `largeRadius` 24
- 控件高度：`AppTheme.controlHeight` = 34（modernDesign）
- 表面：`AppTheme.cardSurface` / `fieldSurface` / `windowSurface`
- 描边：`AppTheme.border` / `borderHover` / `innerHighlight`
- 阴影：`AppTheme.shadowAmbient` + `AppTheme.shadowKey`（双层，非纯黑）
- 焦点环：`AppTheme.focusRing`
- 破坏色：`AppTheme.destructive`
- 动效：`KosDialog` 已提供 reveal（scale 0.96→1，OutCubic 220ms 进 / InCubic 120ms 出），
  `AppTheme.reduceMotion` 时不动
- 现有 tooltip 写法：`ToolTip.visible: hovered` + `ToolTip.text: Accessible.name`

## 外推声明

弹框/浮层**没有用户提供的位图参考**，只有上表的 HIG 官方配图。
除 `alert-macos.png`、`sheets-macos-notes.png`、`offering-help-macos-tooltip-help-tag.png`
三张是真实截图外，其余是风格化示意。凡是这几张覆盖不到的格子，
一律按"外推待确认"记录，不要当成已对齐。
