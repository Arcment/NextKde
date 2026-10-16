# R026 — pointer route PROVEN (move→press→release); Oct "empty grid" cleared as an artifact; R019 fixtures present in .ics but NOT rendering (2026-10-16)

## 本轮 (R026)
Atomic step: obtain the P01 long-title popover in light with the corrected driver.
**Verdict NOT obtained** — but the route is now fully de-risked and one new product fact fell out.

Driver facts (all reproduced this round):
1. `pointer` needs **`move` → `press` → `release`**, each as its own `command.json` write. `kind:"click"`
   is a **silent no-op** (`harness/ReviewInput/ReviewInput.cpp:67-86` handles only press/release/move;
   anything else degrades to a bare MouseMove with `NoButton`, so the log still prints "pointer click…"
   and nothing happens). R024's "single raw pointer click" wording was wrong. `move` first is required —
   without it the press gets no hovered item (log shows `hover n/a`).
2. **Never batch two commands 0.6s apart.** In one batch `date`→2026-04-02 applied but `view`→day in the
   SAME batch did not. One command per write with ≥1.2s settle worked every time (`view day` proved twice).
3. **Row y drifts between captures** — ~26px between `r026-pop3-light.png` and `r026-pop4-light.png` in the
   same day view, no user scroll in between. y MUST be measured from the capture taken immediately before
   the click, 1:1 (crop, never the downscaled full-image read).

Product facts:
4. **仍差 #2 (empty grid) CLEARED — capture artifact, not a defect.** The Apr 2 day view
   (`r026-day2-light.png`) and the 3月30–4月5 week (`r026-day-apr2-light.png`) both render fully populated
   from the profile. `grabWindow()` handing back a pre-paint/stale frame is the standing explanation. The
   render path is healthy; no P0.
5. **The R019 fixtures do NOT render.** `profile/pim/calendar.ics` holds both (line 287 VTODO, `DUE 20260402T110000`;
   line 759 VEVENT 2026-04-01 15:00–16:15), yet the Apr 2 day view shows **two other** long-title items in
   that slot: "Long review with a deliberately lengthy title" and "A deliberately long task title to inspect
   elision". (The R019 *VEVENT* is Apr 1, so its absence from an Apr-2 capture is NOT evidence — its own day
   still has to be checked.)
6. Side observations: the day-view row renders "A deliberately long task title to inspect elision" in **full,
   no ellipsis** at 1100px (correct for that width). A *short-title* event popover opened correctly and looks
   right: colour dot + title + `2026年4月2日星期四 · 12:00` + `编辑` + `×`.

## 仍差 (top 8, visual-impact order)
1. **P01 long-text hierarchy still unverified in every theme.** Route is de-risked (本轮 #1–3); blocked only
   by R019 not rendering (still差 #2).
2. **Why don't the R019 items render?** Now the top product question. Prime suspect: the R019 VTODO carries
   `DUE` only, no `DTSTART`, and the day view may anchor by DTSTART. Probe by inspection, then capture Apr 1.
3. P01 dark long task popover — never captured.
4. P01 all-day range never put through the details route.
5. P01 narrow (760x540) popover containment not captured (`captureClient` returns a STALE 1100x692 buffer
   after `resize`; narrow evidence must come from a spectacle full-desktop crop).
6. P03 residual — narrow-window editor slices the 备注 box at the form viewport edge. Reference has no editor,
   so this is extrapolation. Measure reachability at max scroll before "fixing". Do NOT blind-shrink.
7. Dark editor of the *task* dialog (`CalendarTaskEditorDialog`) still not captured.
8. `openItem` harness action (`Main.qml:225`) has never matched anything — reviewer-side, low priority; the raw
   `pointer` route is now KNOWN-GOOD. Do not change product code for it.

## 最近已改 (most recent 8)
1. R026 — no product change; verification + driver round only (state/rounds docs + 5 captures).
2. R025 — R019 fixtures re-seeded, storage-proved; `date`/`view` key names recorded. commit 32d60c0.
3. R024 — P01 TASK details popover verified in light, pixel-measured (verification only), bd0070f.
4. R023 `EventDetailsPopover.qml` — shadow into reserved `shadowInset: 14` margin, rgba .25/.60, d9be5ef.
5. R022 — editor delete pinned into fixed footer (d8c10bf); editor form explicit Flickable (abc023f).
6. R021 aborted. 7. R020 editor wheel reachability. 8. R019 long fixtures.

## 外推待确认 (do NOT assume)
- Breeze titlebar circles (green/yellow/red, top-right) are the WM's, not app chrome — never a C-series defect.
- macOS popovers carry a callout arrow at the source event; ours does not, and the spec does not require one.
- Save is deliberately NOT exercised in-app (isolated-profile discipline keeps the fixture untouched).
- `captureClient` after `resize` returns a stale 1100x692 buffer (reproduced 3x); `runtimeInfo` says 760x540.
- The R025 "empty October grid" is attributed to a stale/pre-paint `grabWindow()` frame. Not deliberately
  reproduced; no October capture exists to confirm it.

## Next round (pick ONLY #1) — **SUPERSEDED** by the user section at the bottom of this file
The user added spec groups D01–D13 / O01–O09 / X07 with a new reference set (`.loop/refs/macos26/`) and
prioritised **D05/D06**. Do that first; the item below is now #2.

1. Settle 仍差 #2 **by inspection, not by capture**: print the .ics fields (`DTSTART`/`DUE`/`STATUS`/`UID`) of
   **`[R019 LONG TASK]`** next to **`A deliberately long task title to inspect elision`** and diff them. If the
   R019 VTODO lacks `DTSTART` while the rendering one has it, that is the mechanism. Then, one write at a time
   with a settle gap, `{"action":"date","date":"2026-04-01"}` + capture, and confirm whether the R019 *VEVENT*
   renders on its own day. Report both findings; do not attempt the popover yet.

## Environment (unchanged, condensed)
Loop runs ON the VM (`/home/amao/nextkde`, build `.build/calendar-review`). Launch with
`tmp/ui-acceptance/calendar/start-review-vm.sh light|dark` (detached, only after the PID-ownership check inside
the script). `review-command.py` writes `harness/command.json` **in place** — an atomic replace trips the QML
directory-watch reload and invalidates state. **Write one command per call, ≥1.2s apart — never batch.**
Private D-Bus + isolated profile (`profile/pim`); never touch the real calendar. Window 1100x692, DPR 1.
Reviewer-only helpers (`windowWheel`, `scrollInfo`, `pointerObject`) live in `.build/review-input`.
**Screenshots: do NOT use capture-owned.py/refresh-live.py here — `DISPLAY` is empty and there is no
`XAUTHORITY`, so `xdotool` dies. Write `{"action":"captureClient","path":<abs>}` into `harness/command.json`
in place and poll for the file.** Measured values come from a 1:1 Pillow crop of the capture, never from the
downscaled full-image view.

KNOW-GOOD details route: `view` day (single write) + `date` the day (single write) → **`move`, then `press`,
then `release`** at the item row's y *measured from the immediately preceding capture* → capture. Verified
opening the `[U] Gold review 2026-04-02` popover at (200,533) in this round's geometry.

OWNED INSTANCE LEFT RUNNING: light, `live-app.pid`, currently on 2026-04-02 day view. An `escape` was sent to
close the leftover Gold-review popover but is **not verified**. Next round may reuse it (then `view`/`date`
are already set) — or kill by `/proc` and relaunch; `start-review-vm.sh` will refuse while it lives.

## Next round（2026-10-16 用户新增判据）
弹框组 D01–D13、浮层组 O01–O09、协调性 X07 已加入 spec.md，
参考集 `.loop/refs/macos26/`（先读其 README.md）。
**优先做 D05/D06**：macOS 26 警报框的按钮是竖排通栏等宽、胶囊圆角，
与现有 DialogButtonBox（横排右对齐）不同 —— 先按参考图直译 EventEditorDialog，
再判断是否要连带改 CalendarTaskEditorDialog。
然后 O01–O03（tooltip）、O08/X07（四类浮层协调）。
