# Glass v8：连续模糊与透明着色

目标：可以独立调出中等背景模糊、低着色、完整背景滤波的玻璃。背景模糊不是整层透明度；降低着色不得重新引入清晰背景。

## 第一阶段：统一几何

- 声明表面拥有自己的几何、显示状态与采样范围。采样及 damage 从声明派生。
- 取消声明集合与窗口 blur region 的尺寸相等判定、容差及猜测平移。
- v8 窗口即使全部表面隐藏也保持声明所有权，空集合不回退成整窗玻璃。
- 普通窗口及旧的无声明特殊轮廓保留标准 blur 入口。

## 第二阶段：协议 v8 与连续滤波

- 保留同一 manager、shape 接口和旧 opcode。v1–v7 保持即时语义；v8 setter 写 pending，manager commit 按窗口提交，在下一次 wl_surface commit 生效。
- 服务端只渲染 committed 表面状态；同一事务发布几何、材质、模糊、着色和显示状态。
- 显式区分 Liquid/Frosted、Clear/Regular/Thick、着色模式、可读性补偿；旧 decay 特殊值只在协议适配边界解码。
- 新增 blurSigma，单位为表面逻辑像素，0 为不滤波。使用可分离 Gaussian，保留旧 Kawase 档位供旧客户端使用。
- tintOpacity 只混合颜色，effectOpacity 淡化完整效果。readability 独立，不隐式随 sigma 改变。
- KWin 绘制签名及 region API 维持现有编译适配，不承诺跨版本二进制 ABI。

## 第三阶段：直接收敛现有 QML 组件

- 直接在 LiquidGlassPanel 内实现 blurSigma、tintColor/tintOpacity、effectOpacity、effectType、material 和 readability，不增加面板包装组件。
- LiquidGlassPanel 自身拥有声明、材质、后端策略和生命周期。旧属性只作参数兼容；materialOpacity 是 effectOpacity 的别名。默认继承全局强度，新协议使用连续 sigma。
- v8 表面自动发布声明，无需窗口手写 blur union；旧服务端继续使用兼容 region。
- 壁纸预览直接使用 LiquidGlassPanel，去掉固定满档与重复 QML 填充。Dock、通知等现有调用直接使用更新后的内部实现，无需改名。
- 不支持新协议时显式降为旧模糊档位，不发送未知请求。

## 验证与完成条件

在工程现有虚拟机工作流中执行源码同步、构建、安装、注销重登、截图和日志检查。机器信息及凭据不入库。

1. 。同一背景下观察 sigma 0/4/8/12/16/24/32，半径可连续调节，无整层清晰背景混入
2. 固定 sigma=12，只改变 tintOpacity 0/0.1/0.3，观察颜色变化与细节模糊保持独立。
3. 单独改变 effectOpacity，确认其含义确为完整效果淡出。
4. 隐藏 toast、展开收起、缩放、固定 capture、窗口销毁重建不导致其他面板降级。
5. 检查旧客户端协议、旧服务端回退、同窗事务与零 sigma。
6. VM 当前 KWin 路径的结果不能代表未运行的其他 KWin API 路径；分别记录构建和视觉证据，不以截图替代交互结论。

验收：业务组件无需同步两个几何集合；单个表面异常不改变其他表面；新路径无法表达 region/shape 失配；Gaussian、着色、可读性与整层淡出各有独立语义。

## 已实现的 API

```qml
LiquidGlassPanel {
    width: 360
    height: 180
    radius: 24
    blurSigma: 12
    material: "regular"
    readability: "none"
    tintColor: "#102030"
    tintOpacity: 0.08
    effectOpacity: 1
}
```

- `blurSigma`：0..32 表面逻辑像素的 Gaussian 标准差，协议精度 1/256 px；默认是全局归一化模糊值乘 32。
- `tintColor/tintOpacity`：过滤完成后独立混色，不混入原始清晰背景。
- `effectOpacity`：完整效果淡出，降低它会重新显露原始背景，不用于调整磨砂的着色。
- `readability`：`none/subtle/transparent/balanced/readable`；`none` 关闭额外对比补偿。`material` 是 `clear/regular/thick`，只影响光学预设，不自动增加着色或 sigma。
- `effectType`：`SurfaceShape.Liquid` 或 `SurfaceShape.Frosted`，后者保留相同几何、Gaussian、着色及可读性策略，跳过液态光学效果。
- `radius/cornerExponent`：轮廓参数。当前位置与缩放从 Item 映射，普通组件无需传锚点或比例。

`LiquidGlassPanel` 是唯一的公共玻璃面板组件，直接实现上述属性；`blurSigma: -1` 表示继承全局或旧的局部强度。所有现有调用直接接入同一 v8 状态，无需逐窗口换组件。高级固定采样及历史 reveal 仍由该组件提供；旋转/任意路径轮廓不属于本次圆角矩形 API 的保证范围。

旧插件不支持连续 Gaussian；内部适配器按既有曲线近似成旧档位，保留旧轮廓协议及 region。旧协议的固定着色在服务端适配器解码为显式 tint，渲染器不再判断 decay 的特殊区间。

## 渲染成本与边界

Gaussian 在逻辑分辨率的背景捕获上做水平、垂直两趟过滤，截断于 3σ，归一化权重并使用线性采样合并相邻 tap。σ=0 直接采样原始背景；新路径不叠加旧 Kawase 的 finetune 或饱和度补偿。不同 sigma 的结果在同窗口共享；只保留当前使用的结果，并复用连续调节时退休的目标纹理。

这保证了明确的滤波语义，不等于所有 GPU 上都有相同帧率。大窗口、多种不同 sigma 同时动画仍需分别测量 GPU 成本。KWin 6.8、分数缩放、多输出和完整旧发行版组合应继续分别验证；不能用一次 6.6.6 VM 运行替代。

## 本轮验证记录（2026-10-19）

环境：测试虚拟机的 KWin 6.6.6，源码在虚拟机编译，安装后通过干净注销重登生效；本机未启动 Shell 或执行测试。

| 项目 | 结果与证据 |
| --- | --- |
| 工程构建 | 全量 `kosctl build` 完成；修复了既有 StageAnim 在 6.6 下未定义的宏，默认值为 0，保留原来的条件分支行为 |
| shader 构建 | 生成物移到构建目录，源码同步后再次增量构建成功 |
| v8 Gaussian | 实际协议协商为 v8；0/4/8/12/16/24/32 对照可见，σ=12.5 正常传输，连续动画过程中无协议或 shader 错误 |
| 着色与淡出 | σ=12 下分别展示 7 种着色与 7 种完整效果透明度；着色保留滤波，完整淡出重新显露清晰背景 |
| 状态与生命周期 | 同窗 21 块表面销毁重建、全部隐藏、隐藏/显示 toast 已运行；全部隐藏时恢复清晰背景，不出现整窗玻璃 |
| 壁纸预览 | 真实界面加载；实际点击展开/收起及效果 toast，圆角和玻璃保留；去掉固定满档与重复填充 |
| 固定采样 | 运行现有 `tests/fixed-glass-capture`，加载完成并记录 `FIXED_CAPTURE_PASS` |
| 旧客户端 | 对 v8 服务端分别协商 v1–v7，观察期内保持连接，没有 v8 请求、未知 opcode 或协议错误 |
| 旧服务端 | 实际换回备份的 v7 插件并注销重登，新客户端和真实 Shell 正常加载并采用旧协议；随后恢复 v8 插件并再次重登，确认 v8 协商与 Shell 正常 |

图片、过程日志和对照页结果位于本地忽略目录 `tmp/glass-v8/`。临时改变的全局模糊值与壁纸过渡效果已恢复，比较实例已关闭。

尚未覆盖：KWin 6.8 的实际运行、分数缩放与多屏组合、GPU 性能基准。现有窗口统一使用 LiquidGlassPanel 的内部 v8 实现；清理仍有调用的旧参数可以单独进行，无需迁移组件名称。

## 移除面板包装后的复验（2026-10-19）

- 已删除新增面板包装及模块注册；壁纸预览四块面板直接使用 LiquidGlassPanel，并显式保留主题圆角与 transparent 可读性策略。
- effectOpacity 是组件自身的主属性，materialOpacity 仅为兼容别名。模糊、着色、生命周期和后端策略均在 LiquidGlassPanel 内解析；没有新的面板转发层。
- 安装流程清理旧包装文件，避免升级后残留。
- 测试虚拟机全量构建、定向安装和干净重登完成；真实 Shell 达到 Configuration Loaded。
- 对照页直接实例化 LiquidGlassPanel：σ=12.5、七种着色和七种整层淡出均可见，确认三者独立；表面重建与隐藏操作后未见新增绑定、协议或 shader 错误。
- 真实壁纸预览的收起、效果 toast 和退出已操作，圆角与玻璃保留。临时模糊和壁纸过渡设置已恢复，比较实例已关闭。
- 此轮图片和日志位于忽略目录 tmp/glass-panel-direct/。KWin 6.8、多屏和性能覆盖范围与前述限制相同。
