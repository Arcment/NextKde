# 液态玻璃 Gallery — G9（GlassToast 默认 timeout 统一 2600）

## 本轮
G9a 已交付：`GlassToast.qml` 默认 `timeout` 1600 → 2600；`PopupsPage.qml`
显式传值（0 / 2600）未动；`DecisionToastLane.qml` 的 1600 是 A 方案对照演示，
保留。gallery grep 复核后仅余 A 方案演示与历史文案中的 1600。
`qs -p shell/gallery.qml` 起应用，`tmp/glass/run.log` 无 QML 报错（仅既有
ProxyFloatingWindow 弃用告警与壁纸取色告警）。

## 队列（✅=已交付）
- [x] G9a 改默认值 + grep 复核 + 起应用确认无 QML 报错 + ledger + DONE

## 必须做
1. `shell/gallery/components/GlassToast.qml`：`property int timeout: 1600`
   → 2600；注释同步。
2. `PopupsPage.qml` 的显式传值（0 / 2600）不动。
3. gallery grep `1600` 复核；起应用无 QML 报错；ledger 收口。

## 已定案（不要再论证）
- 裁定 B：2600ms + 悬停暂停（SPEC §7-①）。
- 只改 gallery；生产组件不动；本批无截图。

## 上一批（G8 已交付，勿重做）
- MotionPage / ToastDemo 标签与 token 已统一 2600 / 已裁定 B。
- 本批只收 GlassToast 默认值这一处。

## Next round
无（G9 队列已全部交付）。

## 注意
- 只改 `shell/gallery/**`。
- 全部队列项勾完，在下面单独一行写 `DONE`。

DONE
