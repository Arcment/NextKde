# 液态玻璃 Gallery — G8（G5 toast 旧标签清理 + 2 张重拍）

## 本轮
G8b 已交付：重拍 `g8-dark-toast`、`g8-dark-reduce-toast` 并逐张目检；
DEMO.md 增 G8 段；ledger 收口。G8 队列全部完成。

## 队列（✅=已交付）
- [x] G8a MotionPage / ToastDemo 旧标签与 token（1600 → 2600，待裁定 → 已裁定 B）
- [x] G8b 重拍 2 张 + ledger 收口 + `DONE`

## G8a 记录（已改）

- `shell/gallery/MotionPage.qml`
  - 顶部注释：`toast 1600ms` → `toast 2600ms（悬停暂停）`。
  - 副标题（line 59）：同上口径。
  - toast 卡 `badge: "2600ms"`。
  - caption：`存留 2600ms + 悬停暂停（SPEC §7-① 已裁定 B）`。
- `shell/gallery/ToastDemo.qml`
  - `holdToken: 2600`。
  - 注释四处 1600 → 2600，并改写「裁定仍开放」为「§7-① 已裁定 B」。
  - 读数后缀 `§7-① 待裁定` → `§7-① 已裁定 B`。
  - 触发行注记：`发一条后按 2600ms 存留倒计时 · 悬停暂停见裁定页 B 栏；截图为演示常显`。
- grep 两文件：无残留 `1600` / `待裁定`。

## G8b 记录（已改 / 仍差 / 外推）

### 已改
- 重拍两张（dark，页面 motion / demo toast）：
  - `g8-dark-toast`：badge `2600ms`；读数 `hold 2600ms · effective 2600ms`、
    `state shown · remaining 2600ms · last seed`；caption
    `存留 2600ms + 悬停暂停（SPEC §7-① 已裁定 B）`。
  - `g8-dark-reduce-toast`：badge `2600ms`；读数 `effective 0ms`、
    `state shown · remaining 0ms · last reduceMotion`；caption 末段
    `reduceMotion 下 show/hide 与存留 effective 0` 与读数一致。
- `run.log` 无 QML 报错（仅既有 wallpaper colorquantizer WARN）。
- `docs/design/liquid-glass/DEMO.md` 增 G8 段（改点、两张读数、边界）。
- 复检 `grep -nE "1600|待裁定" shell/gallery/MotionPage.qml shell/gallery/ToastDemo.qml`
  无输出。

### 仍差
- 无（本批范围内完成）。

### 外推
- `shell/gallery/components/GlassToast.qml:14` 仍有 `timeout: 1600`，那是
  G2d 基准演示（PopupsPage 使用）的默认值，不在本批改动清单内；若后续要
  全库统一为新口径，另开一项处理。

## 已定案（不要再论证）
- 裁定 B：2600ms + 悬停暂停（SPEC §7-①）。
- 只改 gallery 标签与演示 token；生产组件不动。
- 不改 G5 其他段、G6/G7 裁定页内容。

## 上一批（G7 已交付，勿重做）
- 生产 Toast / Tooltip 已按裁定改完；裁定页标记与对比度已收口。
- 本批只清理 gallery 里遗留的 1600 / 待裁定文案。

## 注意
- 只改 `shell/gallery/**`、`docs/design/liquid-glass/DEMO.md`。
- 每轮结束前：截图 + state.md + commit。

DONE
