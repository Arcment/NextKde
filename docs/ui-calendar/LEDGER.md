# R023 — P01 details popover had NO soft shadow; fixed after pixel measurement, light+dark re-verified (2026-10-16 ~20:27)

P01 re-judged on the long-title EVENT with the known-good route (day view 2026-04-01, raw pointer click
at (200,488) → popover opens; reconfirmed light AND dark). Neutral surface, 1px hairline border and the
title/time/location/notes hierarchy were already correct. One real defect, pixel-proved in BOTH themes:
**the "soft shadow" did not exist at all.**

Cause (apps/calendar/qml/EventDetailsPopover.qml, pre-fix): the shadow `Rectangle` was placed INSET
inside the popup bounds (`x: 2; y: 5; width: parent.width - 4; height: parent.height - 4`), so the
opaque surface rect (`anchors.fill: parent`) covered every pixel of it, and its `MultiEffect` had
`autoPaddingEnabled: false`, so the blur could not escape its own layer texture either.
Measurement, light, row y=400: pure background (218,244,233) at x=368..379 and the surface starting at
381 — a 1px edge, zero gradient; dark identical, (40,90,68) at x=368..379. Only artefact: 1px of hard
shadow leaked below the bottom edge (light y=490 = (141,152,159)).

Fix (one file, sha256 e7d040aaa209524d):
- `readonly property real shadowInset: 14`; popup `width: 340 + 2 * shadowInset`, `padding: 14 + shadowInset`;
  the visible surface rect is now inset by `shadowInset` (radius 12, 1px border, #F5F5F5 / #262626 and the
  whole contentItem untouched); the shadow rect bleeds 2px past the surface (4px at the bottom) with
  `blurMax: 24, blur: 0.4, autoPaddingEnabled: true`, colour rgba(0,0,0,0.25) light / rgba(0,0,0,0.60) dark.
  Painting it into the reserved inset means it can never be swallowed by the surface NOR clipped by the Popup.
- Regression introduced by that padding change, caught by measurement and corrected in the same round:
  the notes Label width was bound to `root.availableWidth - root.padding * 2`, so the notes text wrapped
  one line earlier, the popup grew 186→204 tall and 编辑 moved 454→472 (live-measured). It is now
  `root.availableWidth - 2 * 14` (fixed content inset, independent of shadowInset).

Verified after the fix, light AND dark, 1100x692: the visible surface box is byte-identical to pre-fix
(y 303..488 h=186, x 381..718 w=338), all text segments sit on the pre-fix rows (title 2 lines, date·time,
location, notes on ONE line, 编辑 454-464), and a soft ramp now exists on all four edges (light left
217,243,232 → 173,194,185 over x=372..379 before the border; dark left 40,89,67 → 20,46,35). Zero QML
errors/warnings in live-runtime-vm.log. Captures r023-popover3-light.png / r023-popover3-dark.png; the
pre-fix pair kept as r023-popover-light.png / r023-popover-dark.png; montage docs/ui-calendar/round-3.png.

Verdict: P01 — surface / border / shadow / hierarchy all PASS in light+dark at 1100x692 on the long-title
EVENT. NOT re-closed: the long TASK fixture, the all-day range and narrow-window popover containment were
still not exercised this round.

Prior rounds: R022 (editor chrome + Delete-in-footer, in rounds.md) killed the duplicate command.json
driver and fixed the editor's destructive action into a fixed footer; R021 aborted on those duplicate
writes; the earlier USER PAUSE was superseded by `.loop/TASK.md`. Branch codex/calendar-ui-iter-20261016.
The entry route above is known-good — do not re-derive it.

# Calendar UI acceptance checkpoint

## Authority / spending
Current chat 01a14338-add3-79f0-8f96-2615069eff72 only. Old chat archived/goal PAUSED. Heartbeat ui PAUSED by explicit user stop request. User wants ongoing iteration; no unchanged chatter or repeated full-history/log loading. Project launch/GUI validation/tests VM ONLY per current chat AGENTS. No host app/build/tests, assertions/headless rendering, real-calendar changes, KWin changes, commits/publish, unrelated sessions/subagents. Private bus/PIM. Codex independently captures/views; dedicated Claude implements.2–3 spec IDs per round. No code/self-report PASS. Entire spec/matrix/final-version regressions required.

## Current round / next step
R023 — P01 popover shadow defect found by measurement, fixed, and re-verified in light+dark.
Environment note unchanged: this loop runs ON the VM itself (hostname amao-vmwarevirtualplatform,
/home/amao/nextkde, local .build/calendar-review). No kos-vm SSH host — use local
tmp/ui-acceptance/calendar/review-command.py, which writes harness/command.json in place.

已改 (this round, one file):
- apps/calendar/qml/EventDetailsPopover.qml — shadow now painted into a reserved `shadowInset: 14` margin
  (popup grew, surface inset, `autoPaddingEnabled: true`, colors 0.25/0.60), and the notes Label width
  unbound from `root.padding` (line ~185, now `root.availableWidth - 2 * 14`). sha256 e7d040aaa209524d;
  binary a6a73aca684dbf5a; build clean, zero QML errors/warnings in live-runtime-vm.log; committed as
  d9be5ef (not pushed). Both review instances stopped; the only writer left in this round was this
  session (the R022 orphan was already dead — verified, nothing else touched command.json).

已验 (this round):
- P01 popover on the long-title EVENT, light+dark at 1100x692: geometry identical to pre-fix, hierarchy
  intact, soft shadow real on all four edges. Evidence r023-popover3-{light,dark}.png, docs/ui-calendar/round-3.png.
- The details route is still: day view 2026-04-01 + raw pointer click at (200,488).

仍差 (visual impact order):
1) P01 scope — the long TASK fixture and the all-day range were never put through the details route, and
   the narrow (760x540) popover containment was not captured this round. Next round.
2) P03 residual — in the narrow window the editor still slices the 备注 box at the form viewport edge, with
   the overlay scrollbar as the only affordance. NOTE: the reference image is main-window only and has no
   editor, so editor geometry is extrapolation. Before touching code, measure whether the notes box is fully
   reachable at max scroll (R020's wheel test says 重复/提醒/备注 do become reachable once scrolled) — decide
   fix vs. downgrade-to-non-defect; a blind "shrink the notes box" change risks diverging from macOS, which
   also scrolls a clipped form.
3) Dark editor of the *task* dialog (CalendarTaskEditorDialog) still not captured.

外推待确认 (do NOT assume):
- `captureClient` returns a STALE buffer after a `resize`: runtimeInfo reports 760x540 but the capture comes
  back 1100x692 (reproduced 3x). Narrow evidence must come from a spectacle full-desktop capture cropped to
  the window (`XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 spectacle -b -n -f -o /tmp/desk.png`,
  screen is 1280x800).
- The Breeze titlebar buttons (green/yellow/red circles, top-right) are the window manager's, not the app's
  chrome — do not file them as a C-series defect.
- macOS popovers carry a callout arrow pointing at the source event; ours does not. The spec does not require
  it — do not file it as a defect without a reference that shows one.
- Save is still deliberately NOT exercised in-app (isolated-profile discipline keeps the fixture untouched).

Next round: (1) P01 scope — long TASK + all-day range + narrow popover containment in both themes;
(2) the P03 residual decision above; (3) then the remaining spec IDs and the full state-matrix /
final-version regression (motion needs before/during/after frames — static shots cannot pass it).

## Resume safely
Read this + programmer.json; inspect matching /proc cmdline (not stat file size), terminal JSONL event/result, do not duplicate/restart a live worker. Don't reread full stream. When terminal, save short round-NNN-result.md if the observer has not; inspect changed files, rebuild on the VM, verify fresh actual light/dark, normal/narrow, details+editors/long text, then record the verdict. New code invalidates affected PASS.

## VM environment (superseded for transport; topology still valid)
SUPERSEDED: there is NO `kos-vm` SSH host and no host-side build — this loop runs ON the VM itself
(hostname amao-vmwarevirtualplatform, /home/amao/nextkde, build .build/calendar-review, captures land
locally in tmp/ui-acceptance/calendar/). The old SSH/scp wording below is historical only.
Isolated repo /home/amao/kos-calendar-review; task tmp/ui-acceptance/calendar. Source-only mirror has
CMakeLists/cmake/shared(qml,pim,i18n)/apps(common,calendar)/pim-service plus review harness/profile. VM
build .build/calendar-review successful (build-review-resume.log); ReviewInput built .build/review-input.
No installed KOS/system/compositor changes. Both owned review instances stopped after captures; do not
trust stale live-app.pid. Run start-review-vm.sh light|dark detached, only after build + PID ownership
check. It uses actual Wayland, isolated private D-Bus/PIM, profile fixture; harness/Main.qml actual
CalendarApp.Main. Command.json must be written IN PLACE: atomic replace triggers QML directory-watch
reload and invalidates state. Runtime DPR1, Sans Serif 12, main client 1100x692, narrow target 760x540.
Fingerprints r018-vm-evidence.json; rehash source+binary after each change. Preserve originals.

## Completion
Dialogs now priority, then remaining spec IDs/full state matrix and final-version regressions including
glass dynamic before/during/after slow/rapid/reversed scroll+hover/press/release. No motion PASS from
static images. Final report only after all valid evidence, then stop heartbeat ui. On repeated
environment/request failures save a checkpoint and pause instead of burning retries.

Long-fixture notes: the isolated VM PIM holds R019 LONG EVENT (Apr 1, 15:00–16:15) and R019 LONG TASK
(Apr 2, 11:00), each with a long title / 18-line notes, and a long event location; a SECOND long-title
event "Long review with a deliberately lengthy title" (Apr 1 11:00–13:00) is the one at y≈488 in day
view and is the R022/R023 popover + editor fixture. IDs and payload results in r019-long-fixture.json;
reuse, NEVER reseed/duplicate. The VM harness has a reviewer-only windowWheel{x,y,angleY} branch
(manual real Qt wheel; not product source) for popup/editor scroll.

VM reviewer-only diagnostics: the ignored harness PointerDriver exposes scrollInfo(QObject*) returning
read-only QObject/Flickable/TextArea geometry (the `scrollInfo` action logs a snapshot), plus
pointerObject{target:"detailsEdit",kind:"press"|"release"} whose C++ QObject lookup resolves popup
overlays and emits real pointer events (found=true + coords logged). Escape via direct Qt key closes a
dialog (not proof of the global Shortcut). These helpers are built only in .build/review-input and must
not be replaced by an older plugin; no product changes come from them.
