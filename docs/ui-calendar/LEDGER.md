# R296 — R-H landed (第二批裁决 2026-10-18 01:18): all-day band ring icon IMPLEMENTED + PASS (light). R-OVERFLOW/R-DIM/R-TOOLTIP-Y also unblocked; R-YEAR unblocked (big). Next: R-OVERFLOW.

## 本轮 (R296)
Atomic step: **R-H — all-day band chip ring icon.** `CalendarScheduleView.qml:599` new Rectangle: 12×12, radius 6, border 3, transparent fill, colour `allDayChip.inkColor` (= chipInk), x = 3 (+ jointOverlap when continuesLeft), vertically centred. Label leftMargin 5 → 19 (+ jointOverlap) at `:612`. Built OK; relaunched light, drove date 2026-04-02, captured `r296-light.png`.
- Verdict: **PASS (light).** Every band chip (start-day Mon, continuing Tue–Fri) shows the ring; `+N` overflow row correctly has NO icon (it is not a chip). Geometry vs ref crop: outer/stroke/hole 12/3/6 match, centred, ink-coloured.
- 虚惊记录: first band crop (x221..) appeared to show an iconless Monday chip — actually the collapsed-sidebar grid starts at x≈62, so x221 cut through Tue's icon. Re-crop x60.. confirmed icons on all columns.
- Not yet verified on dark (chipInk is theme-aware; leave to next regression leg).

## 仍差 (top 8, visual-impact order)
1. **R-OVERFLOW (T01 补全): same-hour timed items max 3 columns, then `+N`; remove the silent `slice(0, 2)` cap (`CalendarScheduleView.qml:840`).** NEXT.
2. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view assembled from mini-month. No dead segments. Big — budget several rounds.**
3. **R-DIM: dialog scrim animates with the card (220ms OutCubic in / 120ms InCubic out, `KosWorkspaceDialog.qml:24-27`; shadowAmbient/shadowKey two-layer, no pure-black).**
4. **R-TOOLTIP-Y: measure ref tooltip y and match it; record measurement in LEDGER (self-resolved, no ruling needed).**
5. R-H dark-theme spot-check (fold into next regression leg).
6. *(reserved)*
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R296 — **R-H ring icon on all-day band chips (12×12/stroke 3/hole 6/inset 3, chipInk; text margin 19). PASS light.**
0. R295 — plain hold (no ruling yet).
0. R294 — plain hold. 0. R293 — plain hold. 0. R292 — plain hold. 0. R291 — plain hold. 0. R290 — plain hold. 0. R289 — plain hold.
*(older: R277 closed the 10/10 regression sweep; R246 timed-chip glyph + 12h secondary; R245 R-MONTH; R244 gutter ink-centre; R243 gutter two-tone; R242 chipHost lanes; R241 itemSecondary; R240 chip 0.96 — archived in rounds.md tail)*

## 外推待确认 (live only)
- **R-H proportional note: ref ring is 12 ref-px in an 18 ref-px row (2/3 of row); ours is 12 logical px in a 24 px row (1/2). The ruling's literal numbers win (7.5 直译优先); optical difference acknowledged in ledger ("承认够不到"). Icon also appears on EVERY column of a continuing multi-day bar (ref has only single-day chips — no anchor; x offset uses the column rule, not the bar's visual edge, when continuesLeft).**
- **MONTH-CELL HOVER ARTIFACT (R275, load-bearing):** full-cell light-blue fill + bare `+` top-right on a chipless month cell = hover highlight + quick-add following the pointer at launch. Not data. Move pointer via `{"action":"pointer","kind":"move","x":…,"y":…}`; `position` is REJECTED in month view.
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (all-day ring icon — DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (same-hour ≤3 columns then +N, same rules as R-MONTH, no silent slice(0,2)), R-DIM (scrim follows KosDialog reveal 220ms OutCubic / 120ms InCubic, reduceMotion exempt, shadowAmbient/shadowKey), R-TOOLTIP-Y (self-resolved: ref-measured y, record in ledger). 人工裁决事项清零.**
- **第一批裁决 (2026-10-17 22:55, load-bearing): R-CHIP chip height round(hourHeight*0.96)=38 (DONE R240/R241); T01 side-by-side halves (DONE R242); R-GUTTER 12h two-tone (DONE R243/R244); R-MONTH stack 3 + +N (DONE R245); R-SCALE ref-measured beats spec estimates (stripe ≈3).**
- **DRIVE KEYS (load-bearing): `date` action key is `date`; `sidebar` key is `expanded` (bool); `view` key is `view`. Wrong key silently no-ops.**
- **Shared `AppTheme` has `text` (:153) / `mutedText` (:154) — NO labelPrimary/labelSecondary (Main.qml `tahoe`-only). QT6 delegates: declare `required property int index`.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` and drive via `python3 review-command.py '<JSON list of objects>'` if clobbered. One command per write, 0.6 s sleep, in place. Capture = `captureClient` + ABSOLUTE path. `kill -0 $(cat live-app.pid)` FIRST; launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch (KOS_APPEARANCE).**
- **THIS RUN'S GRID GEOMETRY (R296, collapsed sidebar): timeline starts x≈62, pitch ≈146 — the old "rules span x221..1099" map is for the WIDE layout only. Band y-map (R106/R107/R128/R142/R150/R158): sectionRule y=155; interior 156..231; 0-row interior 26. Week starts MONDAY. App starts `--view week --date 2026-10-15` sidebar COLLAPSED; fixtures live on 2026-04-02 — drive `date` there.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` is THE pitch constant (`:53`). Chip height 38, half-hour line 20. Ref timed chip 1:1: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2; 1-hour title only; secondary on 2-hour; 12h "11AM – 1PM" / "12 – 2PM". Ref gutter: digit+AM/PM two-tone same baseline, red 9:41 pill replaces 10 AM. Ref all-day band: rows y126-143/145-162/164-181 pitch 19; chip radius ≈6 alpha ≈0.16.**
- **Fixtures evolved (R246 note): live profile shows "Morning planning" 08:00–08:45, "Short appointme…" 10:15–10:30, "Long review with…" 11:00–13:00, gold 12:00, "Design review" 14:30–15:30, red 16:00; Wed-only 09:30/14:30; Multi-day review now ends ~0401 (Thu col showed 2 chips + "+2", not 3). An event's itemColor is env-derived — never pin chip colour literals.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` for structure, `LANCZOS` for smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with **`LEDGER.md` = byte copy of `state.md`**. `python3 -c` payload with backticks is mangled — use a heredoc. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-OVERFLOW (T01 补全): timed same-hour items — max 3 side-by-side columns, `+N` remainder thereafter, per the R-MONTH overflow rules; REMOVE the pre-existing silent `slice(0, 2)` cap at `CalendarScheduleView.qml:840` (grep the exact line first — line may have drifted). Verify Thu 2026-04-02 week light: hour columns with >2 same-hour items show 3 chips + `+N`, nothing silently dropped. One atomic step: overflow form only, no other cleanup.**
**Then (later rounds): R-DIM scrim animation → R-TOOLTIP-Y ref-measure → R-YEAR (multi-round) → dark spot-check of R-H folded into the next regression leg.**
**Not `DONE`.**
