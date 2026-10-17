# R297 — R-OVERFLOW landed (第二批裁决): timed same-hour 3-column cap + plain `+N`, slice(0,2) removed. PASS (light). Next: R-DIM.

## 本轮 (R297)
Atomic step: **R-OVERFLOW (T01 补全).** code-writer edits to `CalendarScheduleView.qml`: chipHost `slice(0, 2)`→`slice(0, 3)` (:858), new `hasOverflow`/`overflowCount`/`overflowReserve` (20px right reserve) (:859-862), chip width formula subtracts the reserve (:871-874), new plain-ink `+N` Label (:1030-1042: no fill, font 9, right-aligned v-centred, ink = `chipInk(cellItems[3])` = first hidden item — same form as the R089 all-day overflow row).
- Fixture: +3 events at 2026-04-02 08:00 ("Overflow one" 0800-0830, "Overflow two with a longer title for elision" 0800-0900, "Overflow three" 0800-0815) → Thu 8AM has 4 same-hour items. First import was MALFORMED (my insert ate 4-10's `BEGIN:VEVENT`; parser silently dropped 3 events, `imported:36` of 39) — repaired to 39 balanced, re-imported `replaceExisting=true` (revision 5).
- Verdict: **PASS (light).** Thu 2026-04-02 8AM = 3 narrow chips + plain `+1`, nothing silently dropped; every other row unchanged (1-item rows stay full-width; Wed 2:30PM & Thu 11AM single chips correct; all-day band untouched).
- 虚惊记录: `replaceExisting=true` import WIPED the 3 seed todos (Review checklist / Prepare notes / long-task-title) — recreated via createTodo post-capture. If todos vanish in a future round, re-run the createTodo trio (see fixtures note).

## 仍差 (top 8, visual-impact order)
1. **R-YEAR: segmented control → 4 segments Day/Week/Month/Year + 12-month year view assembled from mini-month. No dead segments. Big — budget several rounds.** NEXT.
2. **R-DIM: dialog scrim animates with the card (220ms OutCubic in / 120ms InCubic out, `KosWorkspaceDialog.qml:24-27`; shadowAmbient/shadowKey two-layer, no pure-black).**
3. **R-TOOLTIP-Y: measure ref tooltip y and match it; record measurement in LEDGER (self-resolved, no ruling needed).**
4. R-H dark-theme spot-check (fold into next regression leg).
5. R-OVERFLOW dark spot-check (fold into next regression leg).
6. *(reserved)*
7. *(reserved)*
8. *(reserved)*

## 最近已改 (most recent 8)
0. R297 — **R-OVERFLOW: timed same-hour max 3 columns + plain `+N`; silent slice(0,2) cap removed. PASS light.**
0. R296 — **R-H ring icon on all-day band chips (12×12/stroke 3/hole 6/inset 3, chipInk; text margin 19). PASS light.**
0. R295 — plain hold. 0. R294 — plain hold. 0. R293 — plain hold. 0. R292 — plain hold. 0. R291 — plain hold. 0. R290 — plain hold.
*(older: R289/R277… archived in rounds.md tail)*

## 外推待确认 (live only)
- **第二批裁决 (2026-10-18 01:18, load-bearing): R-H (all-day ring icon — DONE R296), R-YEAR (4-segment + mini-month year grid, no dead segments), R-OVERFLOW (same-hour ≤3 columns then +N, same rules as R-MONTH, no silent slice(0,2) — DONE R297), R-DIM (scrim follows KosDialog reveal 220ms OutCubic / 120ms InCubic, reduceMotion exempt, shadowAmbient/shadowKey), R-TOOLTIP-Y (self-resolved: ref-measured y, record in ledger). 人工裁决事项清零.**
- **第一批裁决 (2026-10-17 22:55, load-bearing): R-CHIP chip height round(hourHeight*0.96)=38 (DONE R240/R241); T01 side-by-side halves (DONE R242); R-GUTTER 12h two-tone (DONE R243/R244); R-MONTH stack 3 + +N (DONE R245); R-SCALE ref-measured beats spec estimates (stripe ≈3).**
- **R-H proportional note: ref ring is 12 ref-px in an 18 ref-px row (2/3 of row); ours is 12 logical px in a 24 px row (1/2). The ruling's literal numbers win (7.5 直译优先); optical difference acknowledged in ledger. Icon appears on EVERY column of a continuing multi-day bar (no ref anchor; x offset uses the column rule when continuesLeft).**
- **MONTH-CELL HOVER ARTIFACT (R275, load-bearing):** full-cell light-blue fill + bare `+` top-right on a chipless month cell = hover highlight + quick-add following the pointer at launch. Not data. Move pointer via `{"action":"pointer","kind":"move","x":…,"y":…}`; `position` is REJECTED in month view.
- **DRIVE KEYS (load-bearing): `date` action key is `date`; `sidebar` key is `expanded` (bool); `view` key is `view`. Wrong key silently no-ops.**
- **Shared `AppTheme` has `text` (:153) / `mutedText` (:154) — NO labelPrimary/labelSecondary (Main.qml `tahoe`-only). QT6 delegates: declare `required property int index`.**
- **NEVER hand-write `harness/command.json`; re-seed `{"sequence":0,"action":"none"}` and drive via `python3 review-command.py '<JSON list of objects>'` if clobbered. One command per write, 0.6 s sleep, in place. Capture = `captureClient` + ABSOLUTE path. `kill -0 $(cat live-app.pid)` FIRST; launcher resets command.json ⇒ re-issue resize/sidebar/view/date after relaunch. Theme fixed at launch (KOS_APPEARANCE). start-review-vm.sh never exits (exec+wait) — background it or it eats the 60 s tool timeout; seed AFTER it prints pid.**
- **ICS EDITING GOTCHA (R297): insert new VEVENTs AFTER a complete `END:VEVENT` and re-add `BEGIN:VEVENT\nUID:…` yourself — replacing a `UID:` anchor line orphans the next event's BEGIN and the parser silently drops blocks (imported count < file count is the tell). `replaceExisting=true` ALSO wipes todos — re-create the todo trio after any replace-import.**
- **THIS RUN'S GRID GEOMETRY (R297, collapsed sidebar): timeline starts x≈77, pitch ≈146 — the old "rules span x221..1099" map is for the WIDE layout only. Week starts MONDAY. App starts `--view week --date 2026-10-15` sidebar COLLAPSED; fixtures live on 2026-04-02 — drive `date` there.**
- **OUR TOKENS. `CalendarScheduleView.qml:95-112`: gridLine (#EDEDED / white@0.13), gridLineMinor (#F4F4F4 / white@0.06), allDaySeparator (#D9D9D9 / white@0.24), sectionRule (#F2F2F2 / white@0.04). Schedule field WHITE light / (30,30,30) dark. Weekend 249/37. Sidebar plane (228,228,228).**
- **`hourHeight` is THE pitch constant (`:53`). Chip height 38, half-hour line 20. Ref timed chip 1:1: pitch 27; fill (222,237,254); bar (59,134,247) 2.4px; ink (26,67,123); radius ≈2; 1-hour title only; secondary on 2-hour; 12h "11AM – 1PM" / "12 – 2PM". Ref gutter: digit+AM/PM two-tone same baseline, red 9:41 pill replaces 10 AM. Ref all-day band: rows y126-143/145-162/164-181 pitch 19; chip radius ≈6 alpha ≈0.16.**
- **Fixtures (R297 state): each day 0329–0403 has Morning planning 08:00–08:45, Short appointment 10:15–10:30, Long review 11:00–13:00, Design review 14:30–15:30, Evening session 18:00–19:30; Thu 04-02 ALSO has Overflow one/two/three all starting 08:00 (the R-OVERFLOW probe). Todos: Review checklist 04-01 09:30 (personal), Prepare notes 04-01 14:30 (inbox), long-task-title 04-02 11:00 (personal). An event's itemColor is env-derived — never pin chip colour literals.**
- **Crops: 1:1 + zoom in ONE read; `NEAREST` for structure, `LANCZOS` for smooth. No `numpy`. tmp/ gitignored; mirror `docs/ui-calendar/` with **`LEDGER.md` = byte copy of `state.md`**. `python3 -c` payload with backticks is mangled — use a heredoc. A static screenshot can never settle an animation.**

## Next round (pick ONLY #1)
**#1 — R-DIM: dialog scrim animates with the card — 220ms OutCubic in / 120ms InCubic out, reduceMotion exempt; shadow two-layer shadowAmbient/shadowKey, no pure-black. Start from `KosWorkspaceDialog.qml:24-27`; verify with open/close consecutive frames (a static screenshot can NEVER settle an animation — capture mid-open).**
**Then (later rounds): R-TOOLTIP-Y ref-measure → R-YEAR (multi-round) → dark spot-checks of R-H + R-OVERFLOW folded into the next regression leg.**
**Not `DONE`.**
