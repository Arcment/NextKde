# R025 — R019 long-text fixtures RESTORED and proven in the profile; light capture attempted but landed on an un-applied state (2026-10-16)

## 本轮 (R025)
Atomic step: **restore the R019 long-text fixtures** (next-round #1, first half).
No source change; no build. Reviewer-side seeding only.

DONE — storage-proved, both entries present in `profile/pim/calendar.ics` (mtime 20:33:53):
- line 287 VTODO `SUMMARY:[R019 LONG TASK] 任务长标题与编辑表单检查 …` + 18-line `DESCRIPTION` (`验收专用备注第1…18行`).
- line 759 VEVENT `SUMMARY:[R019 LONG EVENT] 长标题布局与窄窗口边界检查 …` + 18-line `DESCRIPTION` + long `LOCATION`
  (`仅用于视觉验收的虚拟会议室 很长的地点名称 ×8`), 2026-04-01 15:00–16:15.
- Method: new `seed-long.py` — reads the recorded payloads from `r019-long-fixture.json`, strips server fields,
  re-posts over `qdbus6` on the owned private bus (`createEvent` exit 0, `createTodo` exit 0). Raw output
  `seed-long-output.json`. Re-creation is legitimate: the originals do not exist (R024 note #1 stands).

**KEY UNBLOCK FOUND (harness action key names).** `harness/Main.qml:217-225` reads `command.view`
and `command.date` — NOT `command.value`. R024's prose ("`date 2026-04-02`") hid this. Every `date`/`view`
command sent in R025 with `value` was a silent no-op, which is exactly why `r025-day-light.png` shows the
*launch* state (月 view, 10月 12–18 2026) instead of Apr 2 day view. Correct form:
`{"action":"view","view":"day"}`, `{"action":"date","date":"2026-04-02"}`. `pointer` uses `command.x`/`command.y`.
So this round produced **no P01 visual verdict** — the capture is real but of the wrong state.

Two capture-path facts re-confirmed: (a) this shell has `DISPLAY` empty and no `XAUTHORITY`, so
`refresh-live.py`/`capture-owned.py` (both call `xdotool`) fail with "Can't open display"; `live-windows.json`
is stale from 13:44. (b) Writing `{"action":"captureClient","path":…}` into `harness/command.json` **in place**
works fine without xdotool — that is the capture route to use. Also: the Oct 12–18 week rendered a completely
empty grid even though the profile holds Oct events — unexplained, flagged below.

## 仍差 (top 8, visual-impact order)
1. **P01 long-text hierarchy still not visually verified in any theme.** Fixtures exist now; the driver
   (`date`/`view` key names) is understood. Nothing else blocks it.
2. Unexplained: the launch week (Oct 12–18 2026) shows an **entirely empty grid** in light although
   `calendar.ics` holds Oct events. Is the app's PIM connection dead, or is the week-view body not
   rendering rows at all (a P0, not a P01 detail)? Check `live-runtime-vm.log` / pim-vm.log first.
3. P01 dark long task popover — never captured (R024 blocked for a different, now-understood reason:
   the light-tuned y did not match dark's contentY).
4. P01 all-day range still never put through the details route.
5. P01 narrow (760x540) popover containment not captured (`captureClient` returns a STALE 1100x692 buffer
   after `resize`; narrow evidence must come from a spectacle full-desktop crop).
6. P03 residual — narrow window editor slices the 备注 box at the form viewport edge. Reference has no editor,
   so this is extrapolation. Measure reachability at max scroll before "fixing". Do NOT blind-shrink.
7. Dark editor of the *task* dialog (`CalendarTaskEditorDialog`) still not captured.
8. `openItem` harness action (`Main.qml:225`) matches on `selectedItems`/`kind`/`itemTitle` and has never
   matched anything — reviewer-side, low priority; the raw `pointer` route is KNOWN-GOOD. Do not change product code for it.

## 最近已改 (most recent 8)
1. R024 — P01 TASK details popover verified in light, pixel-measured (verification only, no code change), bd0070f.
2. R023 `EventDetailsPopover.qml` — shadow painted into a reserved `shadowInset: 14` margin, rgba .25/.60;
   notes Label width unbound from `root.padding`. commit d9be5ef.
3. R022 — event editor delete action pinned into the fixed footer (d8c10bf); editor form made an explicit
   Flickable (abc023f); duplicate `command.json` driver writer killed.
   4. R021 aborted. 5. R020 editor wheel reachability. 6. R019 long fixtures. 7. R018 fingerprints. 8. R017 month collapse motion.

## 外推待确认 (do NOT assume)
- Breeze titlebar buttons (green/yellow/red circles, top-right) are the WM's, not app chrome — never a C-series defect.
- macOS popovers carry a callout arrow at the source event; ours does not, and the spec does not require one.
- Save is deliberately NOT exercised in-app (isolated-profile discipline keeps the fixture untouched).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.

## Next round (pick ONLY #1)
1. With the instance still/already up, send the CORRECT key names — `{"action":"date","date":"2026-04-02"}` then
   `{"action":"view","view":"day"}` in one batch, settle, capture, measure the 11:00 gutter y **from that capture**,
   then a single raw `pointer` click on the R019 LONG TASK row, capture the popover, and judge the long-title +
   18-line-notes hierarchy in light. If the grid is empty (see 仍差 #2), stop and diagnose that instead of clicking blind.

## Environment (unchanged, condensed)
Loop runs ON the VM (`/home/amao/nextkde`, build `.build/calendar-review`). Launch with
`tmp/ui-acceptance/calendar/start-review-vm.sh light|dark` (detached, only after the PID-ownership check inside
the script). `review-command.py` writes `harness/command.json` **in place** — an atomic replace trips the QML
directory-watch reload and invalidates state. Private D-Bus + isolated profile (`profile/pim`); never touch the
real calendar. Window 1100x692, DPR 1. Reviewer-only helpers (`windowWheel`, `scrollInfo`, `pointerObject`)
live only in `.build/review-input`. **Screenshots: do NOT use capture-owned.py/refresh-live.py here — `DISPLAY`
is empty and there is no `XAUTHORITY`, so `xdotool` dies. Write `{"action":"captureClient","path":<abs>}` into
`harness/command.json` in place and poll for the file.** Stop owned review instances after captures; check
`/proc`, not the pid file.
KNOWN-GOOD details route: `view` day + `date` the day → single raw `pointer` click on the item row (in light's
scroll the Apr-1 11:00 event opened at (200,488); the Apr-2 11:00 todo at (200,551) — re-measure per capture).
