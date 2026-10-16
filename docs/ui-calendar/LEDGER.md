# R064 — **T01 修复：小时高度 54 → 40（PASS）**。`CalendarScheduleView.qml` 新增唯一常量 `hourHeight: 40`，
滚偏移 / 小时格高度 / 事件条高度全部由它派生；实测 gutter 标签中心 **连续 10 段差值恰为 40.0**，
harness 自身日志 `contentHeight 960`(=24×40) 与 `contentY 280`(=7×40) 独立佐证。参考图 27 ref-px ≈ 我们窗口 36，
合同写 ≈40，**取 40**。附带发现 **harness 命令格式缺陷**（`review-command.py` 写的是嵌套形式，harness 只认
扁平 `command.action` ⇒ 截图静默失效），本轮已绕过并记录。代码改动（1 文件 4 处）。 (2026-10-17)

## 本轮 (R064)
Atomic step = `T01`（"Hour pitch about 40 with half-hour at 20"），**代码改动**。
`apps/calendar/qml/CalendarScheduleView.qml`：新增 `:49 readonly property int hourHeight: 40`；
`:124` 滚动偏移 `usefulStartHour() * 54` → `* root.hourHeight`；`:357` 小时格 `Layout.preferredHeight: 54` →
`root.hourHeight`；`:402` 事件条高度 `21` → `Math.round(root.hourHeight * 21 / 54)` = **16**
（格子内高 40−3×2 = 34，两条 16 + `spacing: 2` 恰好 34；仍是 21 会被 ColumnLayout **静默压缩**）。
未动：gutter 标签样式、`slice(0, 2)`、事件条 `radius: 5` 与内缩 3/5/4、当前时刻线（本就按比例）。

**判定 PASS。** 行带扫描（x 2..50，阈值 ≥3 非背景像素）得标签中心
244.5/284.5/324.5/364.5/404.5/444.5/484.5/524.5/564.5/604.5/644.5 ⇒ **连续 10 段 40.0**。
视觉复核 `_r064-grid2x.png`（06:00→12:00，2 倍下标签间距 80px）、`_r064-thu11-3x.png`：单行、无压缩、无重叠、内缩不变。

**工具缺陷（本轮发现，未修）：** `review-command.py` 原样写入命令字典，`{"captureClient":{...}}` 到达 harness 时
**没有 `action` 键**，只会落到 `Main.qml:249` 的 `[UIReview] manual undefined …` 分支 —— **截图静默无效**（无文件、
无日志、退出码 0）。绕过方式：原地写扁平形式 `{"action": k, **v, "sequence": prev+1}`。
**仍未 `DONE`。** 详见 `tmp/ui-acceptance/calendar/rounds.md` R064 与 `state.md`。

# R063 — **state.md 的"堵死"前提被推翻**：参考图 `.loop/refs/macos-calendar.png` 是**周视图**（不是月视图），
A/T/E/N/V 全族 ~30 条 spec ID 从未审过；**T01 判定 FAIL —— 小时高度硬编码 54，合同写 ≈40，参考图实测 27**
（814x522、1:1，换算到 1100x692 约 36）。纠正两处 state.md 事实错误，把循环重新开在有参考锚点的 T/A/E/N 族上。
测量轮，无代码改动。 (2026-10-17)

## 本轮 (R063)
Atomic step = `T01`（"Hour pitch about 40 with half-hour at 20"）。**无代码改动。** 复核：`rounds.md` 对
`A01–A04/T01–T03/E01–E06/N01/N02/V01–V05/S01/S04/C05/M04/X01/X02/X04–X06` 的提及数**均为 0**，而 `spec.md`
里它们全是 PENDING ⇒ R062 的 "no unblocked visual work left" 只对 `D`/`O` 族成立。参考图重读为 **Sun 29–Sat 4
（2026年4月）周视图 + 全天事件带 + 8 AM–7 PM 小时网格 + 红色 `9:41` 当前时刻线**，文字锐利、红绿灯圆点 12px ⇒ **1:1**。
**小时间距实测 27px**（时间槽标签 193/220/247/274/301/…；红色 `9:41` 胶囊顶掉了 10 AM 标签），即我们窗口下 ≈36。
**我们实测 53.5px**，源头 `apps/calendar/qml/CalendarScheduleView.qml:120` 的硬编码 `54` ⇒ **FAIL，超 35%**。
**仍未 `DONE`。** 详见 `tmp/ui-acceptance/calendar/rounds.md` R063 与 `state.md`。

# R062 — **P01 popover title leading tightened 22px → 20px** (1.47em → 1.33em at font 15), dark leg. `detailsTitle`
(`EventDetailsPopover.qml:115-118`) gained `lineHeightMode: Text.FixedHeight` + `lineHeight: 20`. Measured: 3-line title
cap-tops **307/329/351 → 320/340/360**; card **284h → 280h** = exactly the predicted −4. **仍差 #6 CLOSED — this was the
last *unblocked* item; the loop is now blocked pending rulings A–E.** (2026-10-16)

## 本轮 (R062)
Atomic step: R061's Next #1 fallback = "仍差 #6, line pitch — do that instead of a ruling if the loop must keep moving"
(the unattended loop must keep moving; no ruling channel exists in `.loop/`). **1 code change (2 properties, one Label),
1 build→screenshot loop, ~3 image reads, 23 Bash calls ≈ 11 min.**
*(Full write-up archived to `rounds.md` R062 and `docs/ui-calendar/LEDGER.md`.)*

**Before** (dark, 1100x692, R019 todo `[R019 LONG TASK] 任务长标题与编辑表单检查`): the repeated long string wraps to
the full **3-line cap** and elides at line 3. Card x381..718 (338w) × y290..573 (284h); cap-tops 307/329/351 ⇒ pitch 22.
**After:** cap-tops 320/340/360 ⇒ **pitch 20**; card 280h; 4–6 clean pixel rows between lines (no ink collision), line-3
ellipsis intact, dot/`×` centred, time + notes lines untouched.

**Why 20 and not R046's "~1.2" (18):** **no ref anchor exists** — the ref is a month view + sidebar, all text
single-line/elided, and it has **no popover at all**. Target = the macOS body ratio **1.33** (20px at 15px).
**`FixedHeight` is load-bearing:** Qt's `ProportionalHeight` multiplies the *font's own* line box — here the 1.47em bug
itself — so `lineHeight: 1.33` proportionally would give 29px. (Corollary: `KosEmptyState.qml:49 lineHeight: 1.22` renders
*looser* than default.) **Not** app-wide: the `controlHeight` 31-vs-34 family is untouched.

## 仍差 (top 8, visual-impact order)
1. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated
   `Rectangle`. **R058 re-confirmed in both directions** (enter = dim full while card α≈0.5; exit = dim full-off while
   card α≈0.95). App-wide. **Needs ruling A**; fix = bind that rectangle's opacity to `revealProgress`.
2. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. Touching
   `KosSurface.effectiveElevation` / the `0.38` factor is **app-wide**. **Needs ruling B.**
3. **`EventDetailsPopover.qml:60`'s `CloseOnEscape` is dead code** (R059; **NOT a spec failure**, the clause is
   弹框-scoped and PASSES — D01 defines 弹框 by a scrim the popover lacks). A lone popover ignores Esc (2 tries / 9s /
   zero pixel change) because `modal:false` + no `focus:`. **Needs ruling C** (A = window `Shortcut`, `Main.qml:1876-1878`).
4. **E03 clause 3 blocked on a ruling, not failed (R049)** — no view produces a tall block (month 18px, week/day 21px,
   all fixed, no duration→height path), while the ref's week view shows proportional blocks ⇒ ruling E: reword-the-clause
   vs build-proportional-blocks. Clauses 1+2 PASS (R048).
5. **Two neutral-button idioms diverge, and one has no ref** (R061). `secondary` hover = neutral grey 79, no edge;
   `flat` hover = accent tint (35,60,81) **with** a 1px edge. The ref toolbar's buttons read neutral, but the ref has
   **no text button and no hover frame** ⇒ **note, not a defect**; only worth a ruling if macOS parity is a goal.
6. ~~**Line pitch 22px at font 15 = 1.47**~~ — **CLOSED in R062** (popover title now pitch 20; the app-wide
   `controlHeight` 31-vs-34 half of this family is *not* fixed and would be app-wide).
7. **`slice(0, 2)` per cell hides items with no `+N`** (R048): 周四 2 · 11:00 shows 2 of 3; the `calendar.ics:91` VTODO
   (due 11:00) is dropped silently. **Needs ruling D.**
8. **Month day cell holds 1 chip + `N`; the ref stacks 3** (R049). `CalendarMonthView` cap is 1 (`+8/+8/+11/+9/+7`).
   Same family as #7 ⇒ **ruling D.**
- *Cosmetic, no ID, folded out:* **button fill/edge tokens don't match their own formulas** (R056): light
  `buttonNeutral` base reads ≈(251,252,254), not the rendered card (247,247,247) — small code fix, **unblocked but
  unresolved-token** (the "right" value is itself a coin flip). D02's radius is **16** vs the spec's `largeRadius` 24 /
  `windowCornerRadius` 32 — recommendation stands: **keep 16**. Hover is a flat fill, **no** `borderHover` edge (R057,
  re-confirmed on the primary in R060) — **but a *flat* button does get a `border` edge on hover (R061); no conflict.**

## 最近已改 (most recent 8)
1. R062 — **popover title leading 22→20px** via `lineHeightMode: FixedHeight` + `lineHeight: 20` on `detailsTitle`;
   **仍差 #6 CLOSED**. Code change (2 properties).
2. R061 — measurement only; **D08 toolbar flat `KosButton` captured and PASSES** (transparent rest → (35,60,81) hover →
   (36,67,92) press; ring (43,115,160) persists). R060's `buttonNeutral` expectation retracted. No code change.
3. R060 — measurement only; **D08 task-editor footer dark leg PASSES** (height 31 / pitch 37 / gap 6 / x 384..730).
   Corrected the popover 编辑 y for todos to **375**. No code change.
4. R059 — analysis only; **popover-Esc re-ruled: not a spec failure** (D08 is 弹框-scoped; 浮层 = `O01–O09`, no Esc
   clause); `CloseOnEscape` is dead code ⇒ **ruling C**. No code change.
5. R058 — measurement only; **D08 clause 3 `Esc 可关闭` PASSES (2 legs)**; the lone-popover Esc issue raised. No code change.
6. R057 — measurement only; **dark footer re-measured**, #A + #B closed; R055's dark table retracted. No code change.
7. R056 — measurement only; **D08 light leg captured**; #A/#B raised (closed by R057). No code change.
8. R055 — measurement only; **D08 dark leg captured** (hover/pressed/focus) with a 13px-high footer table (corrected by
   R057). No code change.

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive.)*
- **`lineHeight`: Qt's `ProportionalHeight` is a multiple of the *font's own* line box, not of `pixelSize` (R062).** With
  the app's CJK-capable stack that box is **1.47em** (22px at 15px), so `lineHeight: 1.2` *loosens*, and the in-repo
  `KosEmptyState.qml:49 lineHeight: 1.22` is looser than default. To hit a **pixel** target use
  `lineHeightMode: Text.FixedHeight` + `lineHeight: <px>`. Measured valid pair: **FixedHeight 20 at font 15** in
  `EventDetailsPopover.qml:115-118`. `Label` (QtQuick.Controls, Text-derived) supports both properties.
- **The ref has NO popover and NO wrapped text** (814x522 month view + sidebar, all chips single-line/elided) ⇒ **there is
  no ref-derivable line pitch, and no ref-derivable popover geometry at all.** P01 is a HIG-convention match. Same for
  the ref's *hover* states — the ref has no hover frame anywhere (R061) — so any "expected fill" must come from the code's
  own tokens, never from the ref.
- **`pointer{target:"<label>"}` is a free geometry + live-state probe for `KosButton`s (R061)** — it goes through
  `controlNamed`, which matches `item.text === label`, so it needs the **rendered/translated** label (`"添加"`, not
  `"Add"`; a miss logs `NaN NaN` and the capture is a silent no-op). The log line carries the resolved centre **and**
  `hover`/`down`: `pointer move 添加 1047 554.5 hover true down false`. `scrollInfo` cannot see buttons; this can.
  It needs the item `visible`, so drive to the owning view first (the 添加 button lives in **monthPage**).
- **`flat:` and `secondary:` are different branch groups in `KosButton.qml:53-65`.** `flat` rest = `"transparent"`,
  then hover/press = `buttonHover`/`buttonPressed` (accent tint). `secondary` = `buttonNeutral*` (neutral grey) and
  never gets an edge. A flat button **does** gain a 1px `border` rim + inner highlight on hover (`:69`, `:80`; inner
  highlight = `!flat || hovered`). `AppTheme.qml:97-99` owns all three tokens.
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green planning"
  ⇒ **(673,375)**. The popover is centred in the window but its card height is content-driven, so a *reused* y lands
  inside the card below the button and is a **silent no-op**. Read 编辑's centre off a frame before clicking.
  **R062 caveat:** the R019-todo popover's **y also differs 11px between binaries** (centre 431.5 → 442.5 at an unchanged
  692 host, h 284→280) ⇒ popover position is only comparable **within one run**; never diff a y against another binary.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. `pointerObject` needs THREE commands.
- **The task editor's `editorScroll` is `387.6 / 160.2 / 340×320`, `contentHeight 295` ⇒ NOT scrollable**, so its
  footer readings carry **no `contentY` ambiguity** — unlike the event editor, where every footer y MUST be paired with
  `contentY` (R055 vs R057 differed 13px at an identical scrollInfo).
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING.** The ring is drawn 1px inside
  the perimeter and occupies the outer rows of the fill; measured as exact `(45,115,159)` = `accent`@0.76 dark (R061
  re-measured `(43,115,160)` on the flat button — same token, ±2 rounding). `pressScale` 0.968 exists but is ≤1px at
  height 31, so it cannot be separated from the ring — **never read "no animation" from a 31px band.**
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204) /
  `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69) / (79,79,79) / (89,89,89);
  destructive **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge token.
  **Dark card fill = (31,36,43)**; the **popover** card dark = **(38,38,38)** (R062, measured) and the window = (30,30,30);
  flat-button hover/press = **(35,60,81) / (36,67,92)** (R061); `border` dark rim ≈**(71,78,87)**. `windowRaised` is
  **not** a neutral grey — do not solve the `mix()` formulas algebraically.
- **Esc semantics in this app (R059): `escape` is a real key event addressed to whoever holds `activeFocusItem`.** It
  closes a **focused** popup (the modal `KosDialog`/`KosWorkspaceDialog` chain) and does **nothing** to a `modal:false`
  popup that never takes focus. Before reading any Esc result, ask *who has focus*. The app's own working idiom for a
  non-focused overlay is a window-level `Shortcut { sequence: "Escape" }` (`Main.qml:1876-1878`,
  `lockscreen/SessionMenu.qml:246-251`). `apps/calendar` contains **only two** `Escape` mechanisms (`Main.qml:1877`,
  `EventDetailsPopover.qml:60`) — if you grep for a third, you will not find one.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** The P01 detail popover is
  a **浮层** (`spec.md:120` O08 names it). A requirement written in a `D` row does **not** automatically bind the
  popover — check which family before calling anything a defect.
- **The dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**, x 384..730,
  centre x ≈ 557, pitch 37, gap 6. Light is ≤1px the same (547..578 / 584..615 / 621..650). Treat the 548 set as canonical;
  **R055's 535/572/609 set is superseded** — do not cite it. (Re-confirmed in R058 leg 2.) The **task** editor is the same
  shape **32px higher** (516/553/590) for a different record — always say *which* editor a footer number belongs to.
  **R062 moved the P01 popover y by −11 (284h→280h) — the editor footers above are for the *editor dialogs*, not the
  popover, and were unaffected.**
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056): a 500/500 request produced `frames:[]`.
  Keep `interval ≤ duration/4`. Frames land at **0, interval, 2·interval…** from the command's arrival; the recorder is
  **non-blocking**, so keep `duration` under the 0.6 s command spacing or the next command's state leaks into it.
- **Diff bounding boxes FIRST, sample pixels second** (R058): three sampled pixels could not distinguish the week view
  from the day view; `ImageChops.difference(...).getbbox()` immediately separates "nothing happened" (bbox `None`)
  from "a view switch happened" (bbox ≈ the whole window) at no cost. **R061 caveat:** a *neighbouring* widget's hover
  state can inflate the bbox — always re-scan the target's own column/row before believing a bbox edge is the target's.
- **Row-band measurement idiom that worked twice (R046/R062):** scan the card's interior column-by-column for pixels
  that are **not** the card fill, threshold a per-row count (≥4), group into bands ≥6 rows tall, and read **cap-top =
  band start**. It gave **22** before and **20** after on the same record with no image inspection at all — use it for
  any wrapped-text or stacked-text pitch question, and confirm once visually at 3x (`Image.NEAREST`).
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open (R056 light, R057 dark, R060/R061 dark);
  press a button and the ring appears 1–2px inset at its top/bottom edges and **persists after release-outside and
  while another button is hovered**. On hover the ring is **covered by the hover fill**.
- **The reference macOS alert at rest shows NO focus ring** on either Primary or Secondary (`_ref-alert-crop.png`) ⇒
  "no ring at open" is the target behaviour, not a bug. Don't raise it again.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159)/(43,115,160).**
  `accent` (48,140,198) / `accentHover` (69,152,204) / `accentPressed` (85,161,208) are **identical in both themes**.
  `buttonNeutral` 69 normal / 79 hover / 89 pressed; light card renders (247,247,247) but the light button base ≈(251,252,254).
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse
  the line as JSON and filter on `parent` + `visible:true`. **`live-runtime-vm.log` accumulates across runs** — always
  take the last matching line, and check its `parent` type number matches the current process. It lists **Flickables and
  ScrollViews only — not `KosButton`s**, so button y's must come from pixels *or from `pointer{target:"<label>"}`* (R061).
- **The 4-step open chain and the 3-step click CAN go in ONE list**, and the recording may be the **first** item (0.6 s
  spacing is enough). **The `press` → `move` off the button → `release` outside** idiom captures *pressed* without
  firing the click and leaves the button with `activeFocus`.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); `timeout 180` kills the app.
  A rebuilt binary requires a **kill+relaunch**. Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'`.
  It takes **~12 s** before the new pid appears. **A prior round's instance is often still alive and is reusable** —
  check `ps -o etime -p $(cat live-app.pid)` and `runtimeInfo` before paying for a relaunch. **R062 rebuilt, so it paid
  the relaunch: kill → `nohup ./start-review-vm.sh dark & disown` → `sleep 15` → the new pid is alive.** Include
  `resize 1100x692` in the drive list — a fresh instance does not necessarily come up at the review size.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`**; it accepts a LIST of
  commands (0.6 s apart) and prints nothing on success. **In-place write only** to `command.json` (atomic replace trips
  the QML dir watcher). **`Bash` CWD drifts between calls — always `cd` to the task dir explicitly.** Actions seen
  working: `escape`, `date`, `view`, `resize`, `openItem`, `pointer`, `pointerObject`, `nativeRecord`, `windowWheel`,
  **`captureClient` (`{action,path}`, path relative to the task dir, ~3.05 MB PNG — takes ~2 s to land)**.
- **Fixtures on 2026-04-02** (live file = `profile/pim/calendar.ics`; the repo-root *`calendar-fixture.ics` is a stale
  copy with no VTODOs*): VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a deliberately
  lengthy title** 11:00 / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) = `[UI] Green planning`
  (09:00), `[UI] Gold review` (12:00, **not** a VEVENT), `[UI] Red review` (16:00), `A deliberately long task title to
  inspect elision` (11:00), **`[R019 LONG TASK] 任务长标题与编辑表单检查`** (11:00, `calendar.ics:287` — a *repeated*
  long string; its popover title fills all **3** lines and elides ⇒ **the record to use for any wrapping-title test**).
  **The month view's selected-day card is the 添加 button's home** (10 items on 2026-04-02).
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its **border**
  only. Popover fill `#F5F5F5` / `#262626` dark (**measured (38,38,38) in R062 for the popover, not `#262626`'s 38 —
  same value, the dark window is (30,30,30)**); editor dialogs `#F7F7F7` light / `#262626` dark; event-editor card at
  x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — that is why *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in and
  **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

## Next round (pick ONLY #1)
**#1 — STOP. There is no unblocked visual work left; do not invent work.** R062 closed the last one (仍差 #6). Every
remaining 仍差 entry changes app-wide or user-visible behaviour that **no spec clause decides**, so implementing either
way is a coin flip the reviewer must not make alone. The loop is **blocked pending these rulings**:
- **A — the modal dim snap** (仍差 #1): bind `Overlay.modal`'s opacity to `revealProgress` (`KosWorkspaceDialog.qml:24-27`)
  or keep the hard on/off? App-wide, both themes.
- **B — shadow magnitude** (仍差 #2): touch `KosSurface.effectiveElevation`'s `0.38` factor (app-wide) or accept?
- **C — popover Esc** (仍差 #3): add the window-level `Shortcut` idiom (`Main.qml:1876-1878`) so a lone popover closes,
  or leave `CloseOnEscape` as dead code? (Not a spec failure either way.)
- **D — per-cell caps** (仍差 #7/#8): `slice(0, 2)` in week/day cells and the month cell's 1-chip cap silently drop items
  — raise the caps, add an always-visible `+N`, or reword?
- **E — E03 clause 3** (仍差 #4): reword the clause, or build duration→height proportional blocks?
Two smaller items are technically unblocked but each needs a *value* ruling first, so they are **not** safe coin flips
either: **(i)** the light `buttonNeutral` base token (reads ≈(251,252,254) vs the rendered card (247,247,247), R056);
**(ii)** the app-wide half of the line-pitch family (`controlHeight` 31 vs the spec's 34). **Do not start either without a
ruling** — R062's popover fix was safe precisely because the ref *and* the spec are silent and the change was one Label.
If a human answers A–E, resume from that ruling; otherwise leave this checkpoint standing.
