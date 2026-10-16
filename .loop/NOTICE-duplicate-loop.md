# DUPLICATE LOOP SESSION — round aborted, no evidence produced

Detected 2026-10-16 ~19:56 local by loop session PID 40998 (launcher
`/home/amao/apps/agent-loop-calendar.sh /home/amao/nextkde 0 1800 2`, PID 40967,
started 19:54:16, owns `.loop/`).

## The conflict

A **second, orphaned** instance of the same loop is running at the same time:

| PID | cmdline | started | parent |
|---|---|---|---|
| 39798 | `timeout 1800 claude -p <loop prompt>` | 19:51:23 | init (launcher already exited) |
| 39799 | `claude -p <loop prompt>` (the actual agent) | 19:51:23 | 39798 |

Same role as this session ("最严厉的 UI 测试员" / dispatch `code-writer`), same
repo, same task dir. Its launcher is gone, so nothing will reap it; only the
1800 s `timeout` will, around 20:21.

## Why this round was stopped instead of run

Both sessions drive the single review app through
`tmp/ui-acceptance/calendar/harness/command.json`. Observed activity from the
orphan while this session was only reading:

- 19:55:04 `r021-start-light.log` created, 19:55:03 review app started
  (PID 41648, `live-app.pid`).
- 19:55:17 / 19:55:26 / 19:55:38 `r021-light-grid.png`, `r021-light-openitem.png`,
  `r021-light-scrolled.png`.
- `command.json` sequence 7 at 19:55:38 → sequence 16 at 19:56:32.

With two writers, each session's captures can show the other session's UI state,
and a verdict written into `state.md` would be unsound. The task's whole premise
is that the reviewer's own eyes on its own uncontaminated frames are the only
evidence. So this round produced **no captures, no `command.json` writes, no app
start/stop, no commit**.

## Warning for the orphan's own R021 evidence

`r021-light-grid.png` and `r021-light-openitem.png` are **byte-identical**
(md5 `4f05062f41398688b5c81ee10d09c43d`, both 3050463 bytes). Whatever the
openItem route did, that frame carries no observable change — do not read it as
either a pass or a fail for P01 without re-capturing.

## What must happen before the next round

Exactly one loop driver at a time. Either wait for PID 39798/39799 to exit
(≈20:21 at the latest) and confirm `ps -p 39799` is empty, or have the operator
kill the orphan. Also kill the app instance it leaves behind:

```
test -r tmp/ui-acceptance/calendar/live-app.pid && \
  kill "$(cat tmp/ui-acceptance/calendar/live-app.pid)" 2>/dev/null
```

Guard suggestion for `agent-loop-calendar.sh`: refuse to start if
`pgrep -f "claude -p 你在无人值守循环中工作"` already matches.

## Round status

No progress this round. The real next step is unchanged from `state.md`:
P03 on the R019 LONG EVENT/TASK fixtures opened in the editor (map click on the
grid chip, not `openItem`), the dark editor, then P02 label-column judgement.
Note the working tree already carries **uncommitted, unbuilt-since-verified**
P02/P03 changes (`apps/calendar/qml/EventEditorDialog.qml`: `labelColumnWidth: 56`
aligned label rows, overlay `ScrollBar`, `height: parent.height - 32`); they are
staged into `.build/calendar-review` (`ninja` reports no work) but have never
been visually reviewed.
