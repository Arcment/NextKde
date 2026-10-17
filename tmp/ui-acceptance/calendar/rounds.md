# Review rounds

## R001 — awaiting programmer implementation

Scope: C01, C02, C03 only.

Expected: 14px dots; 14px edge gap; right/top offsets 14.5/10.5 matching apps/settings/main.qml. Dot group belongs to window upper-right, not nested inside padded main content toolbar. Remove prior calendar window controls duplication as needed. Do not redesign other UI this round.

Evidence: none. Verdict: NOT REVIEWED. A code change is not a visual pass.

Programmer R001 returned code changes in apps/calendar/qml/Main.qml; independent screenshot review pending. Latest user steering switches this task to LOCAL runtime and adds application-painted navbar glass/shadows under scrolling. No visual PASS yet.

## R001 initial visual review — REJECTED

Codex independently captured and inspected round-001-calendar.png and original-scale top-right crop, local Wayland 1180x760 logical / 2360x1520 physical / DPR2. C01/C02 match visually; C03 safe placement fails because green/yellow dots overlap toolbar settings/sidebar glass buttons. No full round pass. Sent correction preserving geometry and reserving chrome space. Source snapshot and fingerprint saved.

## R001 correction 1 — PASS in captured state

Codex independently launched and captured the local real Wayland window, then inspected original corner crop. C01 diameter14, C02 gap14, C03 right/top placement and no overlap confirmed. Evidence round-001-fixed-calendar.png / round-001-fixed-topright.png, metadata and source snapshot saved. Scope only these three items; future matrix regression remains.

## R002 — dispatched

Scope G03/G04/G08, shallow static application-owned button shadow foundation in light appearance. No motion claims; dynamic scrolling is a later 2–3 detail round.

## R002 initial visual review — REJECTED

Fresh real local Wayland app-owned screenshot inspected by Codex. G03/G04 fail: effect draws enlarged opaque white source silhouettes (~72px vs44 button), overlaps neighbors/segment, glass rim hidden, dark lower edge and clipping. G08 app-owned rendering established in grabWindow image but no overall round pass. Source/image hashes in round-002-evidence.json. Correction prompt dispatched with screenshot evidence; keep only same three details.

Verified wait 2026-10-15T12:56:42.849254+00:00: dedicated R002 correction process 452748 is live; no restart or second dispatch.

## R002 correction 1 — STARTUP FAILED

Codex attempted actual local Wayland launch twice; second launch forced Qt stderr to preserve full error. Root fails at Main.qml:437:13, nonexistent MultiEffect sourceVisible property. No screenshot was produced; no G03/G04 pass. Full log/source snapshot/fingerprint saved. Programmer correction 2 receives exact runtime error, must restore valid window and same shadow details. This is an implementation defect, not an external blocker.

## R002 correction 2 — REJECTED

Real local window now starts; Codex captured and viewed both original-scale toolbar corners. G03/G04 fail: oversized neutral-gray slabs obscure glass and join adjacent controls, with hard lower clipping. App-owned G08 path remains established. Exact evidence/source fingerprint in round-002-fix2-evidence.json. Correction3 requests shadow geometry equal to glass, explicit negative z, lighter neutral color and necessary header stacking fix. No overall pass.

## R002 correction 3 — PASS in light static state

Codex independently captured real local app and inspected original left/right toolbar corners. G03 neutral light shadow clean; G04 footprint/softness now correct with no visible hard clipping/overdraw; G08 shadow visible in app-owned grabWindow image. Metadata/source in round-002-fix3-evidence.json. Dark/size/motion regression still pending.

## R003 — independent baseline capture

Scope G01 glass readability over changing content, G02 rim/specular consistency, G05 material during scroll. First operate dedicated visible local session and capture sequence before sending implementation changes.

## R003 baseline — material gap confirmed, no round pass

Reviewer prepared disposable 36 events +3 todos in private profile. XTest input recordings produced no visible scroll and are invalid for motion. Reviewer then used a nonvisual temporary QML wrapper inheriting the actual CalendarApp.Main and invoked actual Flickable.flick. Real-window20fps recording confirms visible content motion (7→14h then reverse); sampled before/during/reverse/after and 18-frame navbar strip inspected. G02 rim stable on fixed background; G01/G05 not achieved because opaque header/fixed lens lack actual changing-content material. Independent evidence in round-003-real-scroll.mp4, frames, operation JSON, source fingerprint. Owned live app closed before dispatch. Programmer receives G01/G02/G05 application-only background-extension sampling scope, not a full layout redesign.

Verified wait 2026-10-15T13:18:29.514199+00:00: R003 dedicated programmer PID 463236 live, no duplicate dispatch.

## R003 implementation review — REJECTED G01/G05

Native real app starts. Recorder first inadvertently selected sidebar ListView after colored fixture expanded list count; that attempt is explicitly INVALID for timeline motion. Reviewer corrected nonvisual harness to use actual scheduleViewport.contentItem, then captured genuine timeline motion 324→755→reverse in round-003-implemented-timeline.mp4. Blue/green/gold/red actual task content moves while navbar stays gray-white. Runtime lens rects all y=-166 vs source824x541; source band -186..-102 lies wholly outside viewport. G01/G05 fail. G02 empty-texture rim stable but real-texture mask still unproven. Source/image hashes and immutable app log saved. Corrective prompt requests valid top-visible-band extension/clamping; no renderer rewrite. Owned app closed.

## R003 correction1 — PASS in captured light week motion

Codex independently restarted the actual native app, then the actual CalendarApp.Main nonvisual control wrapper, and recorded fresh real timeline flick. Valid sourceROI now inside viewport. Uncompressed during/reverse PNGs show subtle blue→green lens tint from real moving task/event content. Native corner masks/rims clean and text remains crisp. Before/middle/reverse/stop samples stay coherent, no static fallback reset. Full after frame and runtime timeline width824/height541/contentHeight1296 checked. Evidence round-003-fix1-timeline.mp4, four PNGs, navbar sequence, app log, operation JSON and source/evidence hashes. G01/G02/G05 PASS for this light-week state only. Rapid motion, other views/dark/size and final regression still due.

## R004 — independent motion/shadow review

Scope G06 rapid reversal/start-stop stability, G04 shadow boundaries during motion, G08 application-owned effect during motion. No programmer edits while capturing.

## R004 — PASS captured light-week rapid motion

Reviewer invoked six rapid alternating native Flickable velocities, explicit cancel/stop and restart; actual viewport logs confirm position changes. Captured five seconds30fps real app client video. Both75-frame corner contact sheets inspected (all150 recorded frame positions), plus stopped/after uncompressed screenshots. G06 navbar/icon geometry stable without visible ghosting, G04 soft shadow edges remain uncut, G08 dynamic lens exists in the app client buffer. Evidence round-004-rapid.mp4, frames-a/b.png, stopped/after.png, app log and operation/source hashes. Hover/pressed and dark/size/view regressions still due. No programmer changes needed for this round.

## R005 — baseline and implementation request

Scope C04 dot colors/order, C06 integrated top reserved band, L01 sidebar width/flat main canvas. C04 currently visually conforms; C06 distinct blue/gray strip and L01 320px sidebar/card canvas need correction.

Verified wait 2026-10-15T13:54:02.632306+00:00: R005 programmer PID 474365 live=True. No duplicate dispatch.

## R005 initial launch — STARTUP FAILED

Real local native launch fails: MonthView root Item has nonexistent contentItem property at line44; ScheduleView line108 has same defect. No screenshot/no visual pass. Full app log and three source snapshots/hashes preserved. Correction1 requests a flat padding0 Pane/Control retaining contentItem contract or correctly anchored child Item layout.

## R005 correction1 — PASS normal/collapsed light week

Codex restarted actual native app, captured2200x1440 at1100x720 logical, then independently opened real root via nonvisual wrapper and captured collapsed sidebar at1925x1260/DPR1.75. C04 dots color/order retained; C06 top band merges with planes with rounded outer corners intact; L01 sidebar220 and continuous flat canvas fill both expanded/collapsed states, without outer card gap. Evidence round-005-fix1-calendar.png, round-005-collapsed.png and source hashes. Existing sidebar label/switch collision observed after narrowing is queued for S03/S05, not accepted as a whole-sidebar pass.

## R006 — independent interactive baseline

Scope G07 hover/press/release transitions, G03 shadow hue through states, G04 shadow boundaries through states. Reviewer built a temporary nonvisual Qt mouse-event driver under harness/ReviewInput; no product source change or QtTest/assertions. It sends manual events to the owned actual window only, to exercise real controls rather than mock state properties.

## R006 baseline — REJECTED G07

Manual reviewer PointerDriver sent QMouseEvent to actual owned QQuickWindow/control. Runtime logs show Calendar actions hover=true/down=false, then hover=true/down=true, then down=false on release. No visual state override/mock. Native-size idle/hover/pressed crops inspected: glass and shadow remain visually identical, no hover/press feedback. G07 not achieved. G03/G04 baseline clean but must review after interactive styling. State PNGs, log, input sequence, source hashes preserved.

## R006 implementation — STARTUP FAILED

Actual root cannot load due Behavior on readonly pressAmount (Main.qml:463). No GUI screenshot. Full source/log/hash saved. Review tool ownership check then correctly refused a nonexistent window. Correction1 requests mutable hoverAmount/pressAmount only; no scope expansion.

## R006 correction1 — PASS light week interaction

Actual root starts after mutable animation-driver repair. Reviewer independently recorded actual Qt hover/press/release/move-out cancel for Calendar actions circle and New Event pill, 5s30fps each. Viewed both150-frame native button contact sheets and idle/pressed/recovered originals. G07 gentle lift/compression/restoration without rim jumps; G03 neutral shadow gets lighter/closer on press with no color halo; G04 clean unclipped soft boundaries. Popup opening/dimming itself is outside this round. Evidence round-006-fix1-actions/pill.mp4, six PNG states each, operation JSONs, app log and source hashes. Only captured light-week states pass; dark/scroll-during-press/final regression due.

## R007 — rejected sidebar baseline, implementation dispatched

Scope S02/S03/S05. Actual R006 recovered screenshot shows44px/15px rows and oversized switches colliding with label at220px sidebar, plus permanent green healthy-status card. Codex sent precise compact group/checkbox/elision requirements; mini month/calendar layout and toolbar remain outside this round.

## R007 initial — REJECTED S03

Actual native2200×1440 screenshot independently viewed. Compact group/row geometry removes switch collision and healthy card; however actual white check marks render as up-chevron ∧, and noninteractive list legends show empty unchecked-looking outlines. S03 rejected; correction1 requests true down-join rising check plus filled no-check legend mode. S05 long-name state remains pending. Original screenshot/detail/source hashes retained.

## R007 correction1 — PASS S02/S03/S05 light sidebar

Reviewer independently captured native2200×1440 and inspected original470px category crop: correct ✓, filled colored no-check list legends,30px rows/12px boxes/13px labels, compact neutral groups. Actual private-service Inbox temporarily renamed to long mixed Chinese/English title, captured1925×1260 real client: single-line elides inside right12px inset without collision. Name restored through same owned private service. No healthy card. Source hashes/evidence saved. Other sidebar/mini dimensions still pending.

## R008 — baseline rejected and implementation dispatched

Scope M01/M02/M03. Current actual screenshot puts mini above categories, month selected circle stretched into ellipse. Send mini below groups at stable bottom with equal7×6 cell geometry and fixed visual child to avoid Control stretching; preserve M04 colors for its own later round.

## R008 initial — REJECTED M01 at reduced height

Normal native2200×1440 screenshot: mini now below groups, coherent heading/equal7×6 date geometry and fixed circular selection. Actual owned root resized to760×540, independently captured1330×945: mini only shows first4 weeks, fifth/sixth fall outside client. M01 fails despite programmer's claimed fixed block. Evidence originals/source hashes preserved. Correction1 requests noncompressible complete mini block and scrollable upper categories within remaining height, not reduced font/row height or raised window minimum. Narrow main-toolbar collisions queued for later L02–L05/X01, no expanded review.

## R008 correction1 — REJECTED M01 access/layout

Actual normal/narrow windows recaptured. Mini complete six weeks now fits at540, but Task lists heading floats with zero rows: internal ListView assigned zero height, outer ColumnLayout cannot scroll. Screenshot contradicts claimed scrollability. M01 still fails; correction2 requests a true whole-category scroll viewport with natural content height and fixed mini outside, preserving all row geometry. No new review scope.

## R008 correction2 — PASS M01/M02/M03 normal and reduced height

Actual normal2200×1440 screenshot independently inspected: complete mini below all4lists, centered month heading and equal7×6 cells, fixed circular selection and aligned10–11px dates. Actual760×540 root captured1330×945 before/after QWheelEvent(-480) and reverse(+480) on real named category viewport. Native logs show contentY0→114→0, height172/contentHeight286. All4lists reachable, complete mini six-week block stays fixed and no longer compressed/cut. Source hashes/app log/operations/originals preserved. Main-toolbar narrow collisions remain outside round and pending.

## R009 — dark glass baseline

Scope G01/G03/G04 in dark mode. Reviewer launched actual native window with per-app KOS_APPEARANCE=dark; no OS/compositor setting change. Baseline image captured; inspect to derive correction.

## R009 baseline — REJECT X03, scope prerequisite update

Actual per-app dark-mode image shows light hardcoded Main planes while AppTheme dark labels turn white: date numbers/grid/labels effectively vanish. Dark glass remains white. Current3-item scope adjusted to X03/G03/G04 (actual dark-week neutral surface/readability and dark shadow hue/boundary). Dynamic dark G01/G02/G05 postponed to own round after valid dark canvas; not counted passed. Sent necessary local dark-token/material correction preserving all light values and geometry.

## R009 — PASS X03/G03/G04 current dark week

Codex independently captured native2200×1440 after local dark tokens, original510×200 corner crop and actual1925×1260 populated timeline atcontentY420. Dark neutral sidebar/canvas hierarchy now coherent; date/label/grid and blue/green/gold/red event titles readable without neon blocks. G03 neutral restrained dark shadow, G04 single soft uncut footprint and restrained rim in both app-owned native and client images. Actual runtime log:1100×720,DPR1.75,Noto Sans13,appearance dark=true. No KWin changes. Only current dark-week/static state coverage; dynamic/shadow interaction/final regression pending.

## R010 — independent dark motion review

Scope G01/G02/G05: glass readability over changing real colored content, rim consistency, material coherence before/during/reverse/after. Same immutable R009 source, actual dark owned window. Reviewer records and inspects; no programmer changes unless visual failure.

## R010 — PASS G01/G02/G05 current dark-week motion

Reviewer recorded actual owned dark client6s20fps with native Flickable forward/reverse/stop, logs contentY324→759→reverse. Independently inspected all120 right-nav positions in3×40 contact sheets,24leading-nav samples, during/after PNGs and individual tail100/110/119 original-size crops to disambiguate contact-sheet reading. G01 white icons legible over blue/green real-content tint, G02 rim centered/smooth/no corner leak, G05 material changes coherently through motion and stop without static fallback/reset. Geometry1925×1260,DPR1.75,Noto Sans13; source hash/app log/recording/operation preserved. Rapid/interaction dark checks next, final geometry changes still need regression.

## R011 — independent dark rapid/interaction review

Scope G06/G07/G08: rapid reversal geometry stability; hover/press/release/cancel preserving rim/shadow; app-owned material capture. No source edits while reviewer records.

## R011 — PASS G06/G07/G08 current dark week

Reviewer recorded150frames rapid6direction changes/cancel/restart and inspected3×50 corner sheets: stable geometry/crisp icons. Recorded real Qt hovered/down states for circle+pill, viewed150frame sequences and full pressed/recovered originals: gentle press/lift, smooth release/move-out cancellation; popup tooltip/menu/dimming outside glass scope. Repeated circle with initialcontentY420 (first100 started on empty hours) to include actual blue/green/gold source during press; full120px circle crop preserves whole rim. Material follows real motion while states recover. APP-native R009 grab and owned client R011 capture contain glass/shadows with no KWin changes. Source hashes, operations, all PNGs/videos/logs retained. Only current dark-week states, later geometry changes require regression.

## R012 — toolbar baseline rejected, implementation dispatched

Scope L02/L03/L04:40px toolbar under30 safe band,28px buttons/16–18icons; centered196×28 view segment in main region; sidebar/add left and search/more right with no prominent New Event/duplicate controls. Current actual screenshots show54px toolbar/44px circles, right-packed segment, repeated sidebar/settings and large sidebar controls. Sent necessary single-toolbar restructuring; date title/navigation styling remains L06/L07 next round; expansion L05 and affected glass regressions separate.

R012 implementation checkpoint: active source now changes toolbar/button geometry. G01–G08 historical captures retained, but checklist explicitly marked REGRESSION REQUIRED R012 so old44px control evidence cannot imply current28px controls passed. No current-source glass acceptance until fresh post-layout review.

## R012 initial — STARTUP FAILED

Actual native launch and actual imported-root launch both fail Main.qml881 VectorIcon is not a type, no GUI/no pass. Reviewer corrected original recommendation after checking static Kos.Ui CMake QML list (VectorIcon exists only unexported controls module). Also source LiquidSegmentedControl non-Layout instance uses invalid preferredWidth/Height. Correction1 requests local inline3path icon implementation + real width/height + filler contentItem for fixed16px icon/dots. Full source/log/hash retained. No runtime assertions/tests.

## R012 correction1 — REJECT L02/L04 sidebar/toolbar overlap

Real app starts. Native2200×1440 and actual760×540 screenshots show Today blue marker/text behind toolbar sidebar/+ icons. Geometry log proves sidebar bodyy30 while toolbar y30h40; main body correctlyy70. L03 centered196×28 segment looks coherent normal/narrow/collapsed. Correction2 requests sidebar body top70 while plane remains0, no scope expansion.

Capture-quality audit: X11 collapsed screenshot omitted right dots/search/nav while native QQuickWindow::grabWindow at same1330×945 renders them complete. This is a capture/damage-path artifact, not a product rendering failure. Reviewer added native grabWindow call to private input plugin (ignoredtmp, no product change/no QtTest) and independently disambiguated. From here use native Qt client grabs for state evidence; final dynamic regression must use native app frames, not rely on old X11 recordings alone. Historical originals retained with caveat; allG01–G08 already pending R012 new-geometry regression.

## R012 correction2 — PASS L02/L03/L04 light normal/narrow/collapsed

Actual Qt grabs after settled explicit sizing/sidebar commands:1925×1260 normal and1330×945 narrow/collapsed. Sidebar bodyy70 no longer overlaps toolbar y30h40;28px controls with16px icons/8px gap,196×28 segment centered within expanded main x220..width or collapsed x0..width; sidebar/add left search/more right with duplicates removed. Inspected whole frames plus original420×230 left and380×230 right crops. Runtime geometry confirms normal segment x562 and collapsed x282. No glass pass on new geometry yet. Earlier immediate startup image caught a page-cache fade and unapplied sidebar state; retained as TRANSIENT/INVALID for static acceptance, settled images authoritative.

Correction to capture-quality audit: direct original-size right crops show all controls present in BOTH earlier X11 and native collapsed files. The prior inference of missing controls/damage-path artifact was a reviewer full-frame reading error, not demonstrated recorder/product failure. No product correction was requested for it. Native grabs remain preferred for independent APP-owned evidence, and small crops must confirm suspected details before rejection. Historical motion evidence retained; allG entries still require R012 new-geometry regression for real source changes.

## R013 — native new-toolbar motion baseline

Scope G01/G02/G05: new28px navbar material over moving real content, rim continuity, coherent before/during/reverse/after tint. Prepare native actual-window frame recording (no visual replacements/assertions) and independently inspect before programming changes.

## R013 native baseline — REJECT G01/G02/G05 new toolbar

Actual visible native window36PNG frames over51..3935ms (requested50ms, observed cadence reported truthfully), no compositor/no render substitute. All36 original positions reviewed in3contact sheets and exact frame16 crop: date-row lenses coherently blue/green/gold while new toolbarSearch remains constant white, more has no consistent glass body/rim. Main source shows new instances never connect lensBackdrop, more plain Item background. Reject G01/G05 andG02; send scoped material binding/more reuse while preserving L02–L04 geometry. Static before/during/reverse/after, raw native frames/timestamps/video/source hashes/log retained.

## R013 implementation — REJECT G01/G05 Search remains static

Reviewer native51frames51..3944ms after capturePNG compression adjustment, all51 original-size140×100 Search/More positions inspected plus450×200 exact during crop. More now coherently blue/green/gold with smooth rim; Search stays white. Source confirms ToolbarButton bool lensActiveOverride defaultfalse unconditionally forwarded as0, disabling Search despite validbackdrop. Correction1 requests int tri-state default-1 plus nonnull guard before forced-on left lens. Geometry/other styles preserved, same3-item scope.

## R013 correction1 — PASS G01/G02/G05 new28px toolbar in light/dark normal/collapsed

Actual native visible-window frames:light expanded56 (50..3980ms),light collapsed50,dark expanded54,dark collapsed48. Observed cadence preserved in operations; never claimed requested20fps as actual. All Search/More original140×100 positions and left collapsed170×110 positions independently inspected; fresh before/during/reverse/after stills retained. Search now changes coherently alongside More with real blue/green/gold events; icons remain readable, rims continuous/centered, no white slab/static reset. Collapsed gutter-side controls naturally neutral but mask/shape readable. Source/log/hash/PNG/video/timestamps saved. Initial light capture attempt occurred while same live PID had only selection-owner window; no restart, re-polled same PID until main ready, transient no-evidence attempt excluded. Other views/narrow/new geometry still final-regression gate.

## R014 — independent current-size shadow review

Scope G03/G04/G08:light/dark28px shadow hue/opacity and soft uncut boundaries, plus application-native material proof. Same immutableR013fix1 source; no programmer edits while reviewing.

## R014 — PASS G03/G04/G08 new28px toolbar light/dark static

Fresh native actual-window captures dark collapsed, dark760×540 expanded and light1100×720 normal. Independently inspected full states and exact200×145 original left/right navbar crops. Neutral soft footprint, no blue/brown cast, hard clipping, duplicate slab or dirty halo; subtle black separation appropriate to both planes. Same shadow/body present in QQuickWindow.grabWindow output proves APP ownership without KWin configuration or effect contribution. Capture/source hashes/logs/originals preserved. Static-state coverage only; current-size interaction next, all final-source states still pending.

## R015 — independent current-size rapid/interaction review

Scope G06/G07 only. Use owned live-client30fps recordings for transition cadence, app-native stills supplement established app-owned material. No demonstrated X11 defect after original-crop audit; native slow/full-frame PNG observer cost is reported truthfully rather than called30fps. Temporary harness now locates standard objectName toolbarMore before text/hint to exercise actual More control without fake state.

## R015 — PASS G06/G07 new28px light/dark rapid and actual More/Add interaction

For each appearance reviewer recorded actual owned client30fps5s rapid6reversals/stop/restart, and5s each actual Qt More and Add hover/press/release/escape/move-out cancel. All150frame Search/More rapid positions and150frame target-control positions per interaction reviewed at original small crops;900 recorded frame positions across six movies. Runtime logs confirm hovered/down transition on actual controls; More exercised during colored native timeline motion. No geometry/icon ghosts, restrained press/lift and rim/shadow restoration; native recovered PNGs confirm ordinary full window after unsaved popup/editor closed. Underlying dialog dimming/tooltip borders are separate UI scope, not counted as material failure. Source/logs/operations/originals preserved. Other views/narrow/final-source regressions still due.

## R016 — search expansion/date-heading/navigation baseline

Scope L05/L06/L07 only:toolbar-contained search with no collision/extra row;48px date heading26–28px/inset20;subdued26px prev/Today/next right group. Prepare fresh native search normal/narrow captures before scoped implementation.

## R016 baseline — REJECT and dispatched

Fresh native dark1100×720 and760×540 captures show expanded search overlays Day/entire segment respectively; date15px title with54px band and44px navigation oversized. L05/L06/L07 only dispatched. Baseline originals/source hashes preserved. Changed date-row geometry will require affected material regression; no whole-UI pass.

## R016 implementation — REJECT L07 and L05 closure

Fresh native dark1100×720/760×540 actual keyboard query, resize, Escape and search-toggle operation. Search no longer overlays segment;27px date title/48band visually coherent with boundedday title. Exact270×100 original navigation crop proves leftPrevious points right/rightNext points left. Search toggle onlyopens; nonemptyfocuslost leaves field with no button close;Escape works onlyafter inputrefocused. Correction1 same3IDs; no passyet. ActualQtkeypress driver inignoredharness, noQtTest/assertions. Newband movesviewport soG01/G02/G05 affected-material regression dueafterR016.

## R016 correction1 — REJECT L05 actual click race remains

Fresh light1100×720 native states and9s30fps actual-input recording: L07 arrows nowcorrect, L06 coherent; Escapecloses/restores segment. But secondSearch click clears query then reopensemptyfield, segmentstayshidden; exact1100×160 toolbarcrop confirms. Blurclose occurs before clickedtoggle. Correction2 dispatched same3-item scope. Originals/operations/sourcefingerprint retained.

## R016 correction2 — REJECT L05 hidden filter after blur

Fresh native760×540 actual input states nowprove toggleclosed andEscapeclosed restoringsegment. More click withDesign review query collapsesfield; aftermenuEscape ordinaryUI hasnofilterindicator yetMorning planning8amgone. Actualpicture contradicts claimedvisiblequery. Correction3 explicitlyrequiresallclosepaths clearquery; no newbadge/backend/scope. Originalandhashesretained.

## R016 correction3 — REJECT L05 transition overlap

Actual dark760×540 andlight1100×720 input/native states nowshow button/Escapeclosure andMoreblurrestoreallfixtureevents. Darklongday elidesbeforenavigation, monthcollapsedheadingcoherent. Exact640×105 recordedframe3.95s showsclosingSearch overlayingWeeksegment text. z-orderonlyoccludes; visualmutualexclusionnotmet. Correction4 requestedsegmenthiddenwhileactiveorwidth>0,restoreaftercollapse. DarkfirstEscapeattemptwasoninactivewindow (reviewerroutingissue); activationofownedwindowandrepeatedactualsequenceclosesnormally. No productEscfailureclaimed. Originalsincludinginvalidattemptretained.

## R016 correction4 — REJECT L05 repeat-open focus stability

Fresh actualdark760×540 native states and9s30fps movie;153consecutive earlyframes viewed in3sheets prove strict search/segment mutualexclusion removesoverlap. But secondopen thenactualtyping reports emptytext/focusfalse, fieldgonebeforeEscape. Independentlyrepeated withownedwindowactivated andnativepointerparkedaway: sameunexpectedclosedfield inquerynativePNG. One slowmanualopenworked, so intermittentfocus/blur race; no pass. Fullruntimecopiedround-016-fix4-runtime.log, operations/recordings/native originals/sourcehashsaved. Correction5 onlysearchopeningfocus lifecycle, same3IDs.

## R016 correction5 — PASS L05/L06/L07 in captured states

Fresh native actualdark760×540 andlight1100×720 pluscollapsedmonth760 screenshots,9s30fps recordings perappearance and actual repeatedquery input. Open/reopen nowmaintainsfocus; toggleclose/Escapeclose restoresegmentandfullfixture; Moreblur clearsquery. Strictmutualexclusion preventssearch/segmentoverlay throughoutopening/collapse. Dark153consecutiveearlyframes plusnativeEscsequenceframes and lighttransitionframes independentlyviewed, originalsnativewindowPNG+moviespreserved. Dateheading48high/27type/inset20, longSeptemberdayelidesbeforeright26high subduednavigation; arrowscorrect. Source/binaryhashes,evidencefiles,perappearance runtimelogs retained. Scopeonly3IDs; monthgrid/agenda etc stillpending.

Reviewer input-route correction: directQCoreApplication::sendEvent Escape is insufficient evidence for Qt Shortcut; Xwindow also maynotremainactive between toolreturns. NativeEscape nowactivatesonlyPID-verifiedownedwindow andsendsXkeytoitswindow inoneshellcell,records native_focus_pid. Priorfix5dark-search Escapeattempt retainedasinvalidroute, notproductfailure; repeateddark-native-sequence/light-native-sequence authoritative. Noadditionalproductfixrequestedforit.

## R017 — G01/G02/G05 affected-material regression

ThreeIDs only: coherentlegibleactualcontenttint/rim/scrollmaterialafterR016datebandmovedscheduleviewport. Freshnativebefore/during/reverse/after sequences next, light/dark. No programmerchange unlessactualfailure. Ownedlightapp88093normalweekready, noactivequery; dedicatedClaude terminal.

## R017 — PASS G01/G02/G05 affected-motion regression

Actual nativeQQuickWindowframes light60(50..3987ms), lightcollapsed61(50..3965), dark56(51..3995), dark760×540collapsed73(50..4000). Requested50ms/observedcadence recordedtruthfully. All250right Search/More positions and134collapsedleft positions independentlyviewed atoriginalROI; before/afterexactcropsandfull during states alsoinspected. Consistentrealblue/green/goldtint, readableicons/smoothcenteredrims, coherentforward/reverse/stop withoutwhitefallback/flicker. App-ownedrawPNGs/timestamps/operations/logs/sourcehashsame009df973 retained. Onlythese3IDs/states; grids/month/dayandfinalmatrixpending.

## R018 — W01/W02/W03 week-header baseline

ThreeIDs only:52px timegutter/sevenalignedcolumns;36pxsinglelineweekday/dateheader;todayredcircle/weekendmuted/ordinaryselectiondistinct. Freshcurrenttodayweeknormal/narrow baseline next. No programmerdispatch yet.

## R018 baseline — REJECT W01/W02/W03 and dispatched

FreshactualtodayOct16dark1100×720 andOct15selecteddark760×540 screenshots:58gutter,48hstackedweekday/date,bluefulltodayheader withblue16,noredcircle;selected15notdistinguished. OriginaldateheaderROIviewed, provenancekept. Scopedprompt requests52sharedgutter/equalalignedcolumns,36hsinglelineheader,redtodaybadge/neutralordinaryselection/subduedweekends. MainonlyselectedDatebindings; mini/all-day/hour/eventstyles untouched. App92463stopped beforedispatch; subsequentheaderchange requiresaffectedglassregression.

## R018 initial implementation — STARTUP FAILED

Actual local app105913 exits beforewindow: CalendarScheduleView.qml45 overridesFINAL Control.availableWidth. NoGUI/noPASS. Log/sourcehasheskept; subsequentcaptureownershipguardrefusedstaleWID. Correction1 onlyrenamecustomgeometryproperty/itsreferences, no scopeexpansion.

## R018 correction1 — REJECT W01/W02 narrow layout overflow

Actual light1100normal startsandshows36singlelineheader/red16/gray15. Actualresize760expanded dense showsonlySun..Wedheaders,remainingdaysoutsideclient; timedcolumnslargegaps/misaligned. Collapsed760showsSun..FriwithSatoutside. Runtime gridwidth885whilevisiblemain540; headeritemwidthproperty69.714doesnotproveactualLayoutallocation. dayCount1screenshotnormal. Originals/sourcehashesretained; correction2 sharedgeometry/layoutconstraints only. Ownedprocess113187 subsequentlymissing, no unrelatedprocessoperation.

## R018 correction2 — scoped PASS on VM, final regressions due

Fresh real Wayland GUI at kos-vm, independent private D-Bus/PIM/profile, source fingerprint and VM-built binary in r018-vm-evidence.json. DPR1, Sans Serif12;1100x720 and760x540. Viewed r018-vm-light-normal-v2/narrow/collapsed/dense.png and dark-normal/narrow/collapsed/day.png:52 gutter and seven visible equal columns align with compact36 single-line headers; red16 today/gray15 ordinary selection and subdued weekends distinct. Dark day also stable. No final whole-UI/material/motion pass. r018-vm-desktop-day.png captures actual desktop; separate app-client images show app painting. Initial r018-vm-light-normal.png invalid because atomic command-file replacement triggered watch-QML reload; retained, not PASS evidence. Controller now writes existing command file in place. Source-only transfer initially omitted shared/i18n, fixed, VM build successful; no host execution/tests. Next R019 P01/P02/P03 dialogs, affected glass regression still pending.

## R019 baseline — REJECT P01/P02; P03 pending further interactions

Independent actual VM dark1100 and760 screenshots r019-vm-dark-event-baseline.png and -narrow-baseline.png viewed. Opening Morning planning immediately opens620-wide large blue-gray edit modal with scrim, no compact detail hierarchy. Stacked/inline labels and prominent blue task-link card do not match written neutral/compact contract. Narrow footer stays visible; scroll/long-content containment still requires review, no P03 pass. Scoped P01/P02/P03 prompt prepared for dedicated programmer.

## R019 initial implementation — REJECT runtime activation failure

VM build completed, actual light1100x720 DPR1 app launched. Opening Morning planning produces TypeError Property itemTitle of EventDetailsPopover is not a function; screenshot r019-vm-implemented-light-details.png independently viewed, no details surface visible. Main.showItem helper calls shadowed by same-named popover properties. Minimal root-qualified helper correction requested; no P01/P02/P03 pass.

## R019 fix1 — activation fixed; P01 REJECT information hierarchy

Fresh VM light/dark1100x720,760x540 DPR1 captures viewed: light-details/-narrow,light-editor-normal-v2/-narrow-v2,dark-details,dark-editor/-narrow. Popup now opens and raw actual pointer683,415 Edit opens correct editor; title/data retained. Neutral compact surfaces improved. P01 rejected because time row08:00 + location duplicates separate location; event date and08:45 end absent. Edit label English amid Chinese. Fix2 limited to details date/range/single location/localized action. P02/P03 no full pass until long-content/task/scroll review. Initial light-editor-normal/narrow (without-v2) were invalid named-popup lookup route: pointer loggedNaN, retained, no verdict. Use raw observed coords for popup controls until harness can locate overlay.

## R019 fix2 — date/range/location corrected; P01/P03 remaining

Fresh actual VM light1100/760 DPR1 screenshots independently viewed. Date/start–end and single location correct. Created isolated VM-only disposable R019 LONG EVENT/TASK fixtures with longtitle/location and18-line notes; IDs retained remote r019-long-fixture.json, never real calendar. Actual manual wheel reaches note18 and editor lower controls, footer stable. Event/task editors both independently viewed. Still REJECT: Edit English because added TS context Main mismatches EventDetailsPopover; long popup retains pre-resize position, bottom535 in540 viewport/shadow touches edge; detail notes tail scroll leaks when switching event→task. Fix3 requests only correct locale context, responsive clamp/shadow margin and per-item notes reset. P02 visually improved, P03 incomplete; no full pass.

## R019 fix3 — REJECT startup failure

VM incremental build succeeded but actual launch fails before any window: EventDetailsPopover.qml155 Cannot assign to non-existent property contentY (ScrollView Control). No GUI/screenshot/no PASS. Minimal fix4 requested: remove invalid binding, guarded deferred imperative reset of notesScroll.contentItem Flickable on new item/open; must preserve manual scroll. Translation/clamp not yet visually reverified. Runtime retained r019-fix3-startup-failure.log.

## R019 fix4 — REJECT duplicate signal handlers at VM compile

Actual VM qmlcachegen EventDetailsPopover.qml276/277 Property value set multiple times. Newly added top onAboutToShow/onOpenedChanged duplicate existing lower clamp handlers. No launch/GUI/PASS. Minimal fix5 requests merging each handler to retain both reset+clamp. Failed source r019-fix4-failed-source.qml retained, build log r019-fix4-build.log remote.

## R019 fix5 — locale/clamp/reset confirmed light; P03 notes editor REJECT

Actual light VM1100/760 DPR1 captures viewed. 编辑 correct, long popup re-clamps bottom528/540, detail notes wheel reaches18, new longtask opens at notes1. Task editor outer scroll reaches Delete with stable footer. Inner editable notes fails actual wheel both unfocused and focused (blue border correct hit): remains1–4 of18 at400,350 −2400; r019-fix5-light-task-focused-notes-scroll.png and before/after retained. P03 reject only this route; keyboard alternatives not evaluated. Correction6 local calendar notes scrolling only, shared/global control untouched. Dark/final evidence still due, no entire-round PASS.

## R019 fix6 — REJECT visual scroll despite correct runtime offsets

Actual task editor v2 screenshots viewed; notes1–4 remains after wheel. Temporary read-only VM QObject diagnostics: inner notes viewport340x96/contentHeight672 and Flickable contentY0→576; TextArea height672/contentHeight648/sceneY297.52→−278.48. Actual app-owned r019-fix6-scroll-diagnostic.png AND desktop r019-fix6-scroll-desktop.png independently show1–4. Thus valid scroll geometry/offset does NOT prove visual pass; request7 repair TextArea rendering/viewport integration. Initial task-notes-top/end images were wrong Edit-coordinate popover route, retained invalid for editor; v2 actual task editor valid. No round PASS.

## R019 fix7 — notes visual scrolling confirmed; P02 fixed outline pending

Actual light task and dark task/event editors independently viewed: notes1→18 visible, outer form lower controls and stable footer; normal/narrow variants retained. PointerObject helper now resolves actual QObject detailsEdit center and emits real Qt input (found=true), eliminating stale raw popup coords. Dark multi-day details displaysMar30–Apr1 inclusive correctly. P01 compact neutral details/locale/range/clamp/reset scoped pass. P02 remains rejected because tall notesField background scrolls with text: top outline/corners vanish at scrollend; fix8 limited to fixed calendar-local viewport surface, preserving working text scroll. P03 final current-version light event/full crossmatrix still due; no full UI completion.

## R019 fix8 — outline fixed, REJECT actual editable-notes focus

Fresh light/dark1100/760 event/task screenshots viewed: fixed frame corners/topoutline persist at line18; footer stable. But actual dark normal task notes rectangle388..728,374..470 clicked500,420; runtime activeFocus=false on KosTextArea, then typed marker appears in TITLE (r019-fix8-dark-task-notes-edit.png), not notes. Existing title retained focus. Trial cancelled Escape, never Save. Fix9 requested proper calendar-local click/focus/cursor editing after scroll, preserving successful surface/scroll. P01 scoped pass unchanged; P02/P03 not final passed.

## R019 fix9 — REJECT startup on invalid TapHandler signal

Actual VM build succeeds but launch fails EventEditorDialog.qml370 Cannot assign non-existent onTapStarted. No window/screenshot/PASS. Fix10 minimal supported signal/gesture policy repair plus original first-click correct-cursor requirement; two-click workaround not accepted. Runtime r019-fix9-startup-failure.log retained.

## R019 fix10 — firsttask focus works, follow-up editing REJECT

Actual dark760 task firstclick notes then typed marker works/title unchanged. Subsequent click on visible17 then typed secondmarker stays in18 beside oldcursor; drag no visible selection. Dark1100 event click visible notes550,550 then marker still enters title, visible in normal/narrow images. All trial inputs cancelled Escape. Official Qt TextArea docs fetched: attached TextArea.flickable property is distinct from ordinary child parenting; requested fix11 native integration rather than firstfocus TapHandler workaround. No overall PASS.

## R019 fix11 rejection / fix12 dispatch — 2026-10-16T10:16Z heartbeat
VM build succeeds; runtime rejects reversed attached-property assignment in both editors (r019-fix11-runtime.log). No screenshot or motion pass claimed. Owned VM app stopped after /proc ownership check. Dedicated prior worker terminal/absent; fix12 PID458240 dispatched with exact documented Flickable { TextArea.flickable: KosTextArea {} } structure. Pending implementation and real GUI verification.

## R019 fix12 VM review — 2026-10-16
Build/start succeeds without type warning. Viewed originalPNG: event1100 dark top notes two different-line clicks insert separately; scrolled task760 notes cursor remains18 and drag has no selection; scrolled event1100 notes clicks append title. Trial edits cancelled. P02/P03 reject; evidence r019-fix12-evidence.json with image/version hashes and dimensions/DPR1. Dedicated fix13 PID461681 dispatched, scoped scrolled pointer/nested-scroll issue. Owned VM app stopped.

## R019 fix13 VM review — 2026-10-16
Actual dark task760: top two-line clicks/type correct; drag blue selection visible. interactive:false disables inner wheel so notes remain1/2 after-2400; P02/P03 reject, scrolled interaction unproven. All trial edits cancelled. Evidence r019-fix13-evidence.json/originalPNG/version/runtime/build. Owned VM app stopped; fix14 PID466964 dispatched to restore wheel without cursor hack.

## R019 fix14 VM review — 2026-10-16
Dark760 task wheel now17/18, frame/footer stable; scrolled clicks type TITLE, drag no selection. Reject P02/P03; all cancelled. Evidence r019-fix14-evidence.json/originalPNG/version/runtime/build. Owned app stopped; fix15 PID470007 dispatched to inspect scrolled visual hierarchy/hit testing, no more assumed-cause claims.

## R019 fix15 VM startup failure — 2026-10-16
Build succeeds; actual root fails EventEditorDialog.qml182 nonexistent ScrollView.interactive. Runtime r019-fix15-runtime.log preserved, no GUI/no pass. fix16 dispatched to existing terminal/absent programmer; correct contentItem Flickable target and ensure layout.

## R020 fix17 VM review — 2026-10-16

Environment correction first: this loop runs ON the vm itself (amao-vmwarevirtualplatform, repo /home/amao/nextkde, local .build/calendar-review). kos-vm does not resolve and the old kos-vm skill path is gone; vm-command.py/dispatch.py are dead. Use local review-command.py, which writes harness/command.json in place.

Startup blocker cleared. apps/calendar/qml/EventEditorDialog.qml174 outer contentItem was still ScrollView with the invalid interactive assignment at182; rewritten as an explicit Flickable mirroring the already-working CalendarTaskEditorDialog.qml96-118 (plus id formLayout on the ColumnLayout, width editorScroll.width). Build 7/7 clean, qmlcachegen no warning. Actual light app started, zero QML errors in live-runtime-vm.log.

Images independently viewed. r020-plus-editor.png 1100x720: toolbar + opens the 380-wide editor; 标题/全天/开始-结束/地点/重复-提醒/备注 and a 保存/取消 footer all present, no scrim artefacts. r020-plus-editor-narrow.png 760x540: dialog clamps to roughly 480 tall and stays inside the client area. r020-plus-editor-narrow-wheel.png after three windowWheel -240 over the form: the form scrolls, 重复/提醒 and 备注 become reachable, footer does not move — confirms the new explicit-Flickable wheel handler works, which is exactly the code that changed.

Still not passed. P03: in narrow the form is cut mid-row (重复/提醒 sliced horizontally) and the outer form carries no scrollbar or edge fade, so 备注 reads as unreachable until the user happens to wheel. P02: labels are above-field for 标题/地点/备注 but inline for 开始/结束/重复/提醒 — not one aligned label column. Dark editor not captured. The R019 LONG EVENT/TASK long-title/long-notes fixture was not exercised in the editor this round.

Honest gap: openItem did not surface a detail popover this round and neither did a raw pointer click on a visible event chip; a week→day view command also did not visibly move the segmented control. Those three details captures are therefore marked invalid and say nothing about P01. Cause unknown — do not treat P01 as regressed, but re-verify the details route before relying on it. Owned instance PID35319 verified via /proc cmdline and stopped; evidence r020-fix17-evidence.json.


## R022 VM review — 2026-10-16

Blocker first: the orphan loop PID 39798/39799 from the R021 note was STILL ALIVE and still writing
harness/command.json at 20:00-20:01, replaying toolbarAdd + /tmp/big.png captures into my freshly
restarted app. It was terminated explicitly (both PIDs gone) instead of waiting for its 20:21 timeout,
then verified no writer remained (file byte-stable over 20 s). All captures below postdate that check.

Also corrected: R020's "details route unreachable" is wrong. In day view 2026-04-01 a raw pointer click
at (200,488) on the long-event chip opens the details popover in light AND dark; pointerObject
detailsEdit reports found:true at (682,463) and opens the editor. R020's three "invalid for P01" images
were a coordinate/method problem, not a product problem.

P02/P03 reviewed on the R019 LONG EVENT fixture in both themes, at 1100x692 and (via a spectacle
desktop capture, because captureClient goes stale after resize) at 760x540. P02 alignment is real now:
one left label column for 标题/开始/结束/地点/重复/提醒/备注, and a pixel scan shows all six field rows
share the same right edge (x≈624) in both themes. P03 containment holds: 664 tall inside the 692 client,
and inside the 760x540 client.

One genuine defect found and fixed. The 删除日程 button was the last child of formLayout, i.e. inside the
scrollable Flickable, so it scrolled away with the form: pre-fix, the light dialog was 565 tall with NO
delete button anywhere and the dark one showed it at the bottom of the form on a row above 保存/取消.
It now lives in a fixed footer row (left) beside 保存/取消 (right). The programmer found that a
DialogButtonBox nested inside a custom footer Item is not auto-wired to the Dialog and added explicit
accept/reject; I confirmed in the live app that 取消 closes the dialog. Build clean, zero QML warnings.
Save was deliberately not exercised — the isolated fixture must stay untouched.

Verdict: P02 PASS (light+dark), P03 PASS with residual (narrow still slices the 备注 box mid-height;
the overlay scrollbar is the only affordance). P01 not re-judged; its route is now known-good.
Next: narrow notes-shrink fix, then P01 re-verification on long EVENT/TASK + all-day, then the
remaining spec IDs and the full final-version regression including motion frames.


---

# 归档：R018 时代（kos-vm 远端流程）的段落，2026-10-16 从 state.md 移出
# 这些描述的是 /home/amao/kos-calendar-review + ssh kos-vm 的旧流程，已被
# /home/amao/nextkde 本机流程取代，保留仅供追溯。

## Resume safely
Read this + programmer.json; inspect matching /proc cmdline (not stat file size), terminal JSONL event/result, do not duplicate/restart a live worker. Don't reread full stream. When terminal, save short round-019-result.md if observer has not; inspect changed files and sync relevant SOURCE only to VM, rebuild there; verify fresh actual light/dark normal/narrow details+editors/long text, then record verdict. New code invalidates affected PASS.

## VM environment
See vm-review.json. SSH kos-vm; isolated repo /home/amao/kos-calendar-review; task tmp/ui-acceptance/calendar. Source-only mirror has CMakeLists/cmake/shared(qml,pim,i18n)/apps(common,calendar)/pim-service plus review harness/profile. VM build .build/calendar-review successful (build-review-resume.log); ReviewInput built .build/review-input. No installed KOS/system/compositor changes. Both owned review instances stopped after captures; do not trust stale live-app.pid.
Run remote start-review-vm.sh light|dark detached, only after source sync/build and PID ownership check. It uses actual Wayland, isolated private D-Bus/PIM, profile fixture; harness/Main.qml actual CalendarApp.Main. Host vm-command.py sends manual JSON actions over SSH only; view/date/resize/sidebar/runtimeInfo/openItem/captureClient/nativeRecord/pointer supported. Command.json must be written IN PLACE: atomic replace triggers QML directory-watch reload and invalidates state (initial r018-vm-light-normal.png retained INVALID). Capture paths are REMOTE; scp to task then view_image before verdict. Native capture QQuickWindow.grabWindow; VM spectacle desktop proves visible app. Runtime DPR1 Sans Serif12,1100x720/760x540. Fingerprints r018-vm-evidence.json; rehash source/build after each change. Preserve originals.

## Completion
Dialogs now priority, then remaining spec IDs/full state matrix and final-version regressions including glass dynamic before/during/after slow/rapid/reversed scroll+hover/press/release. No motion PASS from static images. Final report only after all valid evidence, then stop heartbeat ui. On repeated environment/request failures save checkpoint and pause heartbeat instead of burning retries.

Long-fixture notes: ONLY isolated VM PIM has R019 LONG EVENT (Apr1,15:00–16:15) and R019 LONG TASK (Apr2,11:00), each longtitle/18-line notes, event longlocation. IDs and payload results in r019-long-fixture.json; reuse, NEVER reseed/duplicate. VM harness now has windowWheel{x,y,angleY} manual actual Qt wheel branch (not product source), for popup/editor scroll.

VM reviewer-only diagnostics: ignored harness PointerDriver now exposes scrollInfo(QObject*) returning read-only QObject/Flickable/TextArea geometry; action scrollInfo logs snapshot. Built only VM .build/review-input, no product changes. Preserve this remote review helper on source sync; do not overwrite with host old plugin. Use new pointerObject{target:"detailsEdit",kind:"press"|"release"}: C++ QObject lookup correctly resolves popup overlays and emits actual pointer events, found=true/coords logged. Escape direct Qt key works for dialog cancel (not proof of global Shortcut). Reviewer helper source copied back to host ignored harness as reference; binaries compiled only VM.


## R023 VM review — 2026-10-16 ~20:27

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

# R024 — P01 TASK variant of the details popover: LIGHT PASS by measurement, DARK blocked, long fixture GONE

Atomic step this round: P01's first open sub-item — the **TASK** variant of the details popover (R023 only ever
re-judged the EVENT variant). No product code changed; this was verification of R023's EventDetailsPopover.qml.

Route: launch light → `{"action":"date","date":"2026-04-02"}` → `{"action":"view","view":"day"}` →
`{"action":"pointer","kind":"click","x":200,"y":551}`. The harness `openItem` action (kind "todo",
titleContains "deliberately long task") matched nothing and opened nothing, twice, for an item the raw pointer
route opens immediately — a reviewer-side harness bug, not product source; the pointer route is the reliable one.

LIGHT — PASS on `A deliberately long task title to inspect elision` (VTODO, DUE 2026-04-02T11:00, no
description, no location). Measured (r024-task2-light.png, 1100x692):
- surface box x 381..718 (w 338) / y 279..413 (h 135) — width identical to the R023 event popover's 338.
- fill (245,245,245) #F5F5F5; 1px border (172,172,172) on all four edges.
- soft shadow present and symmetric ≈13px on all four sides: left x368→380 = 254→173; right x720→732 = 203→254;
  top y266→278 = 254→173; bottom y414→419 = 195,197,204,210,236,242 (then the grid line).
- not clipped: the full-width timeline grid line (223,225,228) reads (216,218,221) *under* the popover, so the
  shadow really paints over the content beneath it.
- hierarchy: green kind dot (matches the row colour), 2-line title, `2026年4月2日星期四 · 11:00`, ✕, 编辑.
  No location/notes line, and correctly so — this fixture carries neither.
- live-runtime-vm.log: 0 QML errors/warnings.

DARK — NOT captured; stopped after 3 attempts per the small-step rule. Clicks at (200,551)×2 and (200,511)×1 in
the dark day view produced no popover (r024-task2-dark.png / r024-task3-dark.png are plain day views; the y=340
column is flat (30,30,30)). Measured cause: the dark day view scrolls to a **different contentY** — gutter label
11:00 sits at y≈484 in dark vs y≈511 in light (≈27px higher), so light's y does not land on the row. Aggravator:
the first dark batch carried `date`+`view`+`pointer` in one command batch (0.6s apart), so the pointer may have
hit-tested pre-switch geometry. Next round: separate batches with a settle, then click the row centre measured
from the current capture's own gutter.

BLOCKING FINDING — the R019 long fixtures no longer exist. `profile/pim/calendar.ics` contains **zero** `R019`
entries: no `[R019 LONG TASK]`, no `[R019 LONG EVENT]`, no 18-line notes, no long location. state.md's
"reuse, NEVER reseed/duplicate" instruction is stale — there is nothing left to reuse. The only long-title
fixtures remaining are the event `Long review with a deliberately lengthy title` (Apr 1, 11:00–13:00) and the
todo `A deliberately long task title to inspect elision` (due Apr 2 11:00), and both have empty
description/location. Consequence: the long-notes / long-location wrapping + end-reachability half of P01 cannot
be exercised until the fixtures are re-created (payloads recoverable from r019-long-fixture.json). Re-creation is
not the "duplication" the old note forbade, since the originals are absent. This is decision #1 for the next round.

Verdict: P01 TASK variant — surface / border / shadow / hierarchy PASS in light at 1100x692. Dark task variant,
all-day range and narrow containment remain open. Nothing committed this round (no source change; only the two
new captures and this record).

Prior: R023 (event popover shadow, one file, commit d9be5ef), R022 (editor footer + Flickable), R021 (aborted),
R020/(R019 onwards) in the entries above. Branch codex/calendar-ui-iter-20261016.

### R025 — long-text fixtures restored (2026-10-16)
Next-round #1, first half only. No source change, no build. New `seed-long.py` replays the recorded
`r019-long-fixture.json` payloads over `qdbus6` on the owned private bus; both calls exit 0 and
`profile/pim/calendar.ics` (20:33:53) now holds line 287 VTODO `[R019 LONG TASK] …` and line 759 VEVENT
`[R019 LONG EVENT] …`, each with the 18-line `验收专用备注` DESCRIPTION, the event also with the long
`LOCATION`. R024 note #1 (fixtures gone) is closed.
Blocked the visual half: the `date`/`view` commands were sent as `{"action":"date","value":…}` but
`harness/Main.qml:217-225` reads `command.date` / `command.view`, so both were silent no-ops —
`r025-day-light.png` is real but shows the launch state (月, 10月 12–18 2026). Driver key names recorded in
state.md. Two environment facts: this shell has no `DISPLAY`/`XAUTHORITY`, so `xdotool`-based
`capture-owned.py`/`refresh-live.py` fail and `live-windows.json` is stale — capture instead by writing
`{"action":"captureClient","path":…}` into `harness/command.json` in place, which worked.
Also noticed and left open: the launch week's grid is completely empty in light despite Oct events in the
profile — possibly a P0 rendered-body problem, flagged as 仍差 #2 and to be diagnosed before any further P01 clicking.

## R025 — R019 long-text fixtures RESTORED; driver key names recorded (2026-10-16)
Re-posted the recorded R019 payloads (`r019-long-fixture.json`) with the new `seed-long.py` over `qdbus6` on the
owned private bus (`createEvent`/`createTodo` exit 0). Storage-proved: `profile/pim/calendar.ics` line 287 VTODO
`[R019 LONG TASK] …` + 18-line DESCRIPTION; line 759 VEVENT `[R019 LONG EVENT] …` + 18-line DESCRIPTION + long
LOCATION, 2026-04-01 15:00–16:15. Re-creation is legitimate — the originals do not exist.
KEY UNBLOCK: `harness/Main.qml:215-225` reads `command.view` and `command.date`, NOT `command.value`; R024's
prose ("`date 2026-04-02`") hid this, so every R025 `date`/`view` write with `value` was a silent no-op and
`r025-day-light.png` shows the launch state. `pointer` uses `command.x`/`command.y`.
Capture path re-confirmed: `DISPLAY` empty and no `XAUTHORITY`, so `refresh-live.py`/`capture-owned.py` (both
call `xdotool`) fail; `live-windows.json` is stale. Writing `{"action":"captureClient","path":…}` in place works.
Produced NO P01 verdict — the frame captured was the wrong state.

## R026 — pointer route PROVEN; Oct "empty grid" cleared as an artifact; R019 items exist but do NOT render (2026-10-16)
Atomic step: obtain the P01 long-title popover in light with the corrected driver. Verdict NOT obtained, but the
route is de-risked and one new product fact surfaced. No product/source change, no build.
Driver (all reproduced): (1) `pointer` requires `move` → `press` → `release` as separate writes — `kind:"click"`
is a silent no-op (`harness/ReviewInput/ReviewInput.cpp:67-86` handles only press/release/move, else it degrades to
a bare MouseMove with NoButton while the log still prints "pointer click…"), and `move` must come first or the
press finds no hovered item (`hover n/a`). R024's "single raw pointer click" prose was wrong.
(2) Do not batch: `date`→2026-04-02 applied but `view`→day in the SAME batch did not; one write per call with a
≥1.2s settle worked twice. (3) Row y drifts ~26px between captures in the same day view with no user scroll, so y
must be measured from the capture immediately preceding the click, 1:1 via a Pillow crop.
Product: 仍差 #2 is CLEARED — the Apr 2 day view and the 3月30–4月5 week both render fully populated, so the R025
"empty October grid" was a stale/pre-paint `grabWindow()` frame, not a dead PIM connection or a P0 body defect.
NEW BLOCKER: the R019 fixtures do not render. `profile/pim/calendar.ics` holds both (line 287 VTODO `DUE
20260402T110000`; line 759 VEVENT 2026-04-01 15:00–16:15) yet the Apr 2 day view shows two OTHER long-title items
in that slot — "Long review with a deliberately lengthy title" and "A deliberately long task title to inspect
elision". The R019 VEVENT is Apr 1, so its absence from an Apr-2 frame is not evidence; its own day is unchecked.
Prime suspect for next round: the R019 VTODO carries `DUE` only (no `DTSTART`) while the rendering task may have
one — settle by diffing the .ics fields, not by more captures.
A short-title event popover DID open and looks correct (colour dot + title + `2026年4月2日星期四 · 12:00` + 编辑 + ×),
and the long task title renders in full at 1100px with no ellipsis. Owned light instance left running on the
Apr-2 day view (an unverified `escape` was sent to close the leftover popover).

## R027 — macOS26 D05 直译: EventEditorDialog footer 竖排通栏等宽同高 (2026-10-16)
Atomic step: translate `.loop/refs/macos26/alert-macos.png` onto the calendar event editor's action area.
Reference measured 1:1 at 2x: primary/secondary fills identical 306x37px (=153x18.5pt), gap 9px (=4.5pt), both flush
to the card's inner width, **primary ABOVE secondary**, primary fill #007AFF-ish (2,123,255), secondary fill
(214,214,214) on a (232,232,232) card — i.e. the secondary is *darker* than its surface, both same pill radius.
Change, one file only: `apps/calendar/qml/EventEditorDialog.qml:175-248`. The footer's
`RowLayout`{Delete | spacer | right-aligned DialogButtonBox} became `ColumnLayout{spacing:6, anchors.margins:16}`
holding three `Layout.fillWidth: true` `KosButton`s in reference order: Save (highlighted, on top) → Cancel →
Delete event (destructive, LAST, `visible: root.editing`). `standardButtons: Dialog.Save|Dialog.Cancel` at line 31
untouched; wiring by hand: Save→`root.accept()` (which drives `saveRequested`), Cancel→`root.reject()`, Esc still
closes, footer stays fixed and the dialog still fits 760x540. `shared/qml/foundation/KosWorkspaceDialog.qml` and
other apps NOT touched, so MusicDialog/other dialogs keep the old horizontal box.
Sub-finding: `root.standardButton(Dialog.Save)` returns null unless the DialogButtonBox *is* the dialog's own
footer (proved with qmltestrunner) — that is why the old code forwarded accept/reject by hand. A hidden+disabled
DialogButtonBox is therefore kept purely as the localized label source, copied once in `Component.onCompleted`
into `saveLabel`/`cancelLabel`; with the qsTr fallbacks deliberately corrupted the buttons still read the platform
labels, proving the lookup (not the fallback) is what renders. Labels: 保存 / 取消 / `qsTr("Delete event")`.
Build `ninja -C .build/calendar-review kos-calendar kos-pim-service` clean (7/7, qmlcachegen included).
VERDICT **D05 light PASS** (new-event state), measured 1:1 from `r027-editor-light.png` (1100x692, relaunched so
the new QML is live, driven `view week` → pointer move/press/release `target:"toolbarAdd"` at (62,50), three
separate writes with ≥1.2s settles): card inner x369..745; Save fill x386..729 = 344px; Cancel fill x386..728 =
343px (Δ1px antialias ⇒ 等宽); insets 17/16px symmetric ⇒ 通栏; heights 30/31px ⇒ 同高; gap 6-7px; primary on top.
Token check `AppTheme.qml:158` `controlHeight = round(34 * densityScale)` ⇒ the 30-31px render is densityScale
(~0.9), not a hard-coded height. No QML errors in the live log.
Honest gaps: dark theme and the editing state (third, Delete row) uncaptured; D06 is visibly still差 — the 取消
fill (246,250,252) is *lighter* than the card (247,247,247) and reads as an outline, where the reference's
secondary is ~8% darker than its surface. That, not geometry, is the next delta. D05 is NOT claimed for dark.

## R028 — D06: secondary becomes a flat gray filled capsule (half PASS; primary label found to be black)
Reference `macos26/alert-macos.png` re-measured at 1:1 (1480x942 retina): card (232,232,232), Primary fill
(0,122,255) y446..483, **Secondary fill (214,214,214)** y493..529, gap y484..492 = pure card colour (no shadow).
So the secondary is ~7.8% *darker* than the surface it sits on and is a flat fill with no border — which is
exactly what our 取消 was not (fill (246,250,252) on a (247,247,247) card = an outline).
Implementation: opt-in tokens `buttonNeutral`/`Hover`/`Pressed` in `AppTheme.qml` (L101-110, derived from
`card`; second arg to `mix()` must be a real colour object — `Qt.rgba(...)`, because `mix()` reads `second.r`),
`property bool secondary: false` in `KosButton.qml` plus a fillColor branch and `secondary ⇒ strokeWidth 0,
elevation 0, showInnerHighlight false`, and one line `secondary: true` at `EventEditorDialog.qml:234`. Default
false ⇒ no other caller changed; geometry untouched.
First attempt undershot and is worth remembering: a token-space `mix(card, black, 0.078)` rendered as only 6.1%
darker, because `AppTheme.card` is ≈ (251,253,254) while the dialog paints `cardSurface` at 54% alpha and renders
(247,247,247). Raising the light amount to **0.095** reproduced the reference's *rendered* ratio:
measured fill (227,229,230) on (247,247,247) = 0.919 vs reference 0.922.
VERDICT **D06 secondary PASS** (light, new-event state), measured 1:1 from `r028-editor-light.png` (1100x692,
relaunched so the new QML is live): Save x386..728 = 343px / y585..614 = 30px; Cancel x383..731 (Δ≤2px AA) /
y622..651 = 30px; gap y616..620 ≈ 5-6px; symmetric insets; fill flat with no stroke and no shadow below.
**D06 primary half FAILS and is the next delta**: the Save label renders near-black — at row y599 the darkest
glyph pixel is (11,9,31) and no pixel in the row is lighter than the fill (48,140,198); 4x zoom confirms black
保存 on blue, where the reference is white on #007AFF. Cause `AppTheme.qml:148-151`: `accentUsesDarkText` picks
max WCAG contrast, and black wins on this profile's accent (5.70 vs 3.68). Not fixed this round — the 2-cycle
build/capture budget was spent on the fill. Also newly noted: the Save's `elevation 0.68` shadow darkens the
6px inter-button gap to 236..241, where the reference's gap is clean card colour.

## R029 — D06 second half: white primary label (PASS)

Atomic step: the primary's label must be white, not near-black. Two lines, both opt-in.

- `shared/qml/foundation/KosButton.qml` +L11-15: `property bool lightLabel: false` (default false).
- `shared/qml/foundation/KosButton.qml` contentItem color: `emphasized ? (lightLabel ? AppTheme.whiteSeed : AppTheme.accentText) : …`.
- `apps/calendar/qml/EventEditorDialog.qml:226`: `lightLabel: true` on Save.
- The shared `AppTheme.accentText` / `accentUsesDarkText` rule (AppTheme.qml:148-151) is untouched: it picks
  black for this profile's accent (48,140,198) because contrastRatio(accent,black)=5.70 > (accent,white)=3.68,
  but Apple puts white on the tinted primary regardless. Containment chosen over an app-wide rule change.
- Build clean (`ninja -C .build/calendar-review kos-calendar kos-pim-service`, 13 steps, no QML warnings).

Capture `r029-editor-light.png` (1100x692) after relaunch: `view week` then pointer move/press/release on
`target:"toolbarAdd"`, writes ≥1.5s apart. Log confirms `hover true down false → down true → down false`,
then `native app client capture … true`.

Measurements: Save fill x386..729 = 344px, fill (48,140,198); **lightest label pixel (255,255,250)**,
**darkest pixel in the button box = the fill** ⇒ no dark glyph at all (199 near-white px). R028's failure
signature (darkest (11,9,31), nothing lighter than the fill) is gone. Cancel still flat (227,229,230),
no stroke, no shadow; card (247,248,249); 6px gap; Save on top ⇒ R027/R028 geometry intact.
4x footer crop read by eye: white 保存 on blue, dark 取消 on flat gray. **D06 PASS.**

New finding: `.loop/refs/macos-calendar.png` (814x522) is a calendar window only — a scan for accent-blue
pixels returns 0 hits, so there is **no alert in the reference**. D06's "white on the tinted primary" is
macOS HIG convention, not a pixel-measured target. Recorded in state.md 外推待确认 so no future round
re-derives it. Left for later: the emphasized button still carries a light rim (inner highlight plus
`strokeColor accentText@0.16`) and its `elevation 0.68` shadow bleeds into the 6px gap (y616-620 read
236..241 vs card 247) — 仍差 #2, untouched by this round.

## R030 — D05 dark half: measured, dark numbers directionally confirmed (no code change)
App was not actually running (the `ps | grep -c kos-calendar` count of 2 was the loop's own cmdline) →
`nohup ./start-review-vm.sh dark &`, waited for the harness load line, then `view week` → pointer
move/press/release on `target:"toolbarAdd"` (writes 1.5s apart) → `captureClient` → `r030-editor-dark.png`.
`runtimeInfo` confirms appearance dark.

1:1 Pillow measurements — dialog x≈360..745, card **(38,38,38)**, scrim (17,17,17), field (34,39,47).
- Save bbox (385,586)-(729,613) = 345x28, fill **(48,140,198)** — same as light; lightest glyph **(255,255,250)**,
  81 near-white px in the label band; the box's darkest pixels (29,29,29) sit at capsule *edges*
  (385,606)/(724,612)/(392,613), not on glyphs. ⇒ white `lightLabel` reads on the dark accent too.
- Cancel bbox (384,622)-(730,651) = 347x30, fill **(61,70,82)**, label lightest (232,246,248).
  (61,70,82) > card (38,38,38) ⇒ the dark **direction** of `mix(card, white, 0.13)` is right.
- Off-hue note: (61,70,82) is blue-tinted although its surround is neutral; solving the 0.13 mix back gives
  card ≈ (32,42,56) — the token is mixed from the opaque accent-tinted `card`, the rendered surface from the
  translucent `cardSurface` composite. Mildly slate-blue by eye; not plainly wrong ⇒ no code change.
- Geometry matches light within 1px ⇒ R027/R028/R029 intact.
- Re-confirmed in dark the R029 gap defect: gap rows y615-620 = 32..36 vs card 38, plus a 2-3px halo beside
  the capsule (x382-383 → 32-35 at y600), plus a 1px *lighter* capsule edge (x386,y600 = (56,144,200),
  y613 = (55,144,200) vs fill (48,140,198)). Now proven in **both** themes → promoted to 仍差 #1 and to
  R031's atomic step (kill the emphasized capsule's shadow + rim).

## R031 — emphasized capsule shadow + 1px rim killed (opt-in `flatPrimary`), light+dark measured
Step: 仍差 #1 — the D06 primary capsule's drop shadow (6px gap read 236..241 light / 32..36 dark instead
of card 247,248,249 / 38,38,38) and its 1px lighter rim (light x386 lighter than fill; dark x386,y600 =
(56,144,200) vs fill (48,140,198)).
Change (2 files, opt-in so the app-wide emphasis rule is untouched): `shared/qml/foundation/KosButton.qml`
gains `flatPrimary: false`; when `flatPrimary && emphasized` the KosSurface gets `strokeWidth 0`,
`elevation 0`, `showInnerHighlight false` — identical treatment to the existing flat `secondary` capsule.
Set `flatPrimary: true` at `apps/calendar/qml/EventEditorDialog.qml:227` (the `lightLabel` Save);
grep-verified the only opt-in site in the repo, so nav/settings/`checkable&&checked` emphasized buttons
keep `strokeWidth 1` + `elevation 0.68` + inner highlight byte-for-byte. Build 13/13, links clean.
Verified 1:1 (Pillow) on `r031-editor-light.png` / `r031-editor-dark.png`, same route as R030
(`view week` → pointer move/press/release `target:"toolbarAdd"` → `captureClient`):
- light: y616-620 (x420) = **247,247,247** card (was 236..241); x375-383 @y605 = card (was halo);
  outermost capsule px x384 = (48,140,198) = fill, x383 = card ⇒ **no rim** (was x386 lighter).
- dark: y616-620 = **38,38,38** card (was 32..36); x375-383 = (38,38,38) ⇒ halo gone;
  x384 = (48,140,198) exact fill ⇒ rim gone (was x386,y600 = (56,144,200)).
- full-width sweep of the two gap rows (x380..740) is a single value in each theme ⇒ zero shadow residue.
Non-regression, all numbers identical to R030/R029: Save fill (48,140,198) both themes, capsule x384..731;
Cancel light (227,229,230) / dark (61,70,82), x384..730; 6px `spacing: 6` rhythm (Save ends y615, Cancel
fill starts y622 with AA at 621); white Save label still there (R029 `lightLabel` untouched);
R027 stack untouched. Deliberately NOT touched: scrim, radius, D07 Delete pill, D10 animation, D11 narrow,
and `CalendarTaskEditorDialog` (which still uses the old rule and will be translated as its own step).
Driver gotcha recorded: `pkill -f "<binary path>"` also matches the driving shell's own cmdline and killed
the chain (exit 144) — kill via `live-app.pid` instead.

## R032 — editing-state 3-row footer, light (measurement round, no code change)
Goal: capture the footer as a *group* in `root.editing` (3 rows: Save/Cancel/Delete), never yet looked at.
New working route into `root.editing` (recorded): `date 2026-04-02` → `view day` → `openItem` (details
popover, `Main.qml:1309`) → **raw-coordinate** click (678,440) → `captureClient`. Driver gotcha:
`pointer` with `target:"detailsEdit"` logs `pointer move detailsEdit NaN NaN hover n/a` and drops the click
— targets resolve via `objectNamed(contentItem)` and the popover is a `Popup`, not a child of `contentItem`.
Artifacts `r032-popover-light.png`, `r032-editor-edit-light.png`, `_r032-footer3x.png`.
Verdicts (Pillow, light):
- R031's flat primary survives the editing state: Save (48,140,198) x384..730 (AA 383/731), y579 → card
  (247,247,247), no rim, no halo. Cancel (227,229,230) x384..730, likewise flat.
- Rhythm is even: three rows, identical width x384..731, ~31px tall each (Save y547.5..579, Cancel
  y584.4..615.4, Delete y621..652.5), gaps ≈5.4/5.6 ⇒ the `spacing: 6` reads evenly. Delete is last and
  exists only when editing — correct per D07/O06.
- **Recorded D07 premise was wrong.** Delete is not a filled red pill; it is the only row left in the OLD
  outlined language: 1px `AppTheme.border` rim (x383 (229,229,232), x731 (223,224,227), y621 (228,229,231),
  y651-652) + a ~7px soft drop shadow beneath (240→243→246→247 over y653..659), fill (246,250,252) =
  `AppTheme.button` = the card's own luminance. Label (219,75,75) ≈ `AppTheme.destructive` #d83b3b.
  Cause pinned to `KosButton.qml:67-80`: `destructive` alone keeps `strokeWidth 1` / `border` stroke /
  `elevation 0.42` / inner highlight; only `secondary` and `flatPrimary && emphasized` are flat.
  ⇒ two button languages in one 3-row stack, and the heaviest-consequence action is the lightest row.
- Target for R033 identified with zero QML plumbing needed: `secondary: true` at
  `EventEditorDialog.qml:244` — `KosButton.qml:41` picks the label color from `destructive` independently
  of `secondary`, so the red label survives. Only the event-editor call site changes; the other 10
  `destructive: true` sites are untouched.
Also recorded in state.md 外推: fixtures live on 2026-03-29..04-04, the launcher's `--date 2026-10-15` lands
on an empty day (so `date` must always be sent first). App killed via `live-app.pid`, not left running.

## R033 — D07 landed: editing footer Delete row flattened (light)
**Change:** `apps/calendar/qml/EventEditorDialog.qml:245` `+secondary: true` (after `destructive: true`, the
editing-only Delete `KosButton`). 1 added line, 1 file. `KosButton.qml` untouched; no other
`destructive: true` site touched; Save/Cancel untouched. Build clean (7/7), no reload warnings.
**Driver correction:** `kind:"click"` is a no-op — `ReviewInput.cpp:67-92` maps only `press`/`release`;
anything else falls through to `QEvent::MouseMove`/`NoButton`. It still emits the move, so the target shows
hover and the popover-vs-editor diff bbox collapses to just the button rect (659,429,705,453) — reads as a
near-miss, is actually a dropped click. Correct sequence: `move`,`press`,`release`. True 编辑 centre is
**(682,441)**, not (678,440).
**Measured (light, editing; x=563 column, y=637 row):**
- Delete fill (227,229,230) x384..730, y622..651 — byte-identical to Cancel. AA only x383 (240,240,241),
  x731 (236,237,237), y621 (235,236,237), y652 (239,240,240).
- R032's rim gone (was x383 (229,229,232), x731 (223,224,227), y621 (228,229,231), y651-652 (231,234,236)).
- R032's drop shadow gone: y653..659 is flat card (247,247,247); was a 240→243→246→247 gradient.
- Label red preserved: core (217,73,73) ≈ (219,75,75) ≈ `AppTheme.destructive`; AA (221,138,138)/(223,170,170).
- Save (48,140,198) y548..578 and Cancel (227,229,230) y585..605 byte-identical to R032 — no regression.
- Rows y548..578 / y585..614 / y622..651 (~31/30/30px), gaps ~6/~6, all x384..730, order Save/Cancel/Delete.
**Verdict:** PASS. Stack is now one language (three flat capsules; red text the only differentiator). The
R032 fear — that a neutral capsule would dilute "destructive" — did not materialize: (227,229,230) with red
lettering on a (247,247,247) card reads unmistakably as the destructive row (macOS/iOS sheet convention),
and the inversion (most consequential action = lightest, hollowest row) is fixed. Fallback to a red-tinted
fill explicitly NOT warranted. Dark unverified — that is next.

---

## R034 — D05 dark + editing state (2026-10-16). **No code change.**
**Atomic step:** capture the 3-row editing footer in dark and judge R033's fix there (was 仍差 #1).
**Artifacts:** `r034-editor-edit-dark.png` (1100x692), `_r034-footer3x.png` (3x crop, x375..740 y540..660).
**Route:** `date 2026-04-02` → `view day` → `openItem` → `pointer move` (682,441) → `press` → `release`
→ `captureClient`. Landed first try using the corrected `move/press/release`; no wasted cycle.
**Measured (dark, editing; card surface (38,38,38); dialog card bottom ≈ y668.4):**
- Save fill (48,140,198) — same accent as light — y547.4..578.4 = 31px, x384..730.
- Cancel fill (61,70,82) y584.4..615.4 = 31px, x384..730.
- Delete fill (61,70,82) y621.4..652.4 = 31px, x384..730 — **byte-identical to Cancel**.
- AA identical between Cancel and Delete: top y621 (52,57,64), bottom y652 (47,51,56), left x392 (55,62,71),
  right x722 (57,64,74). **No rim** (R032's 1px rim absent in dark too). **No shadow** — y653 is (38,38,38)
  immediately, no gradient.
- Gaps 579..584 / 615..621 = 6px = `EventEditorDialog.qml:220 spacing: 6`. Pitch 37. All rows 347px.
- Delete label core red **(249,104,97)** (plateaus (247,102,92)/(239,102,96)) = dark `destructive`;
  contrast vs (61,70,82) = 3.27:1 (Cancel's near-white = 8.3:1). Cancel label brightest (240,243,247).
**Answers to the round's two questions:**
- (a) Dark Delete is **not** distinguishable from Cancel by fill — identical fill/geometry/AA, label colour
  is the sole differentiator. Same as light (R033). Consistency, not a defect.
- (b) The dark red label **does** read destructive at 3x, no reservation.
- (c) The dead-slab worry is **closed in the opposite direction**: fill/card separation is Y≈1.60:1 in dark
  vs 1.19:1 in light — the capsule is more legible in dark. R033 confirmed in both themes.
**New finding:** the dark neutral capsules are visibly **slate-blue** over the warm-neutral (38,38,38) card.
Cause found: `AppTheme.qml:103-105` `dark ? mix(card, white, 0.13)`, and solving (61,70,82) backwards gives
`card` dark ≈ (32,42,56) — a tinted *token*, not the rendered surface. Promotes 仍差 #7 from a numeric note
to a seen defect. Target for the fix: mix from the drawn (38,38,38) ⇒ **≈ (69,69,69)**, hue-neutral, same
luminance (Y≈0.0599), separation ≈1.60:1 unchanged.
**Also resolved:** `controlHeight` renders 31px here, not the spec's 34 — `AppTheme.qml:168` scales by
`densityScale` (= font.pixelSize/13, `:166-167`), and the harness sets no font override, so this profile
lands at ≈0.912. Ink measurement confirms 31.0 exactly (AA blend fractions 0.598 / 0.402). D05's "=34" is
the densityScale=1.0 value; what D05 tests (竖排/通栏/等宽/同高/仅填充色区分) holds ⇒ **D05 → PASS** in
`spec.md:106`, qualified: the `CalendarTaskEditorDialog` footer is still outstanding.
**Verdict:** PASS for the step. No code change this round.

## R035 — `buttonNeutral` dark hue fixed (2026-10-16)
**Step:** fix the dark slate-blue capsule found in R034 #7. One behaviour line: `AppTheme.qml:107`.
`dark ? mix(card, white, 0.13)` → `dark ? mix(Qt.rgba(0.149,0.149,0.149,1) /* #262626 */, white, 0.143)`
⇒ 38 + (255-38)×0.143 = 69.0. Light branch, hover, pressed left byte-identical.
**Artifacts:** `r035-editor-edit-dark.png` (1100x692), `_r035-footer3x.png` (3x, x375..740 y540..662).
**Route:** R034's, first try — `date 2026-04-02` → `view day` → `openItem` → `pointer move` (682,441) →
`press` → `release` → **`captureClient`**. Note: the client capture is the harness action
(`harness/Main.qml:122`), not `capture-owned.py`; this profile is Wayland (`start-review-vm.sh:13-14`), so
`capture-owned.py`'s `xdotool` ownership check fails with "Can't open display: (null)". One wasted cycle
from that, then straight through.
**Measured (dark, editing; card (38,38,38)):**
- Save (48,140,198) x384..730; Cancel **(69,69,69)** x384..730 y584..615; Delete **(69,69,69)** x384..730
  y621..652. All 31px core, pitch 37, gaps 6px = `EventEditorDialog.qml:220 spacing: 6`.
- R=G=B on both neutral fills — the cool cast is gone (3x crop: neutral grey capsules on the neutral card).
- Fill/card WCAG **1.578:1** (was 1.583:1 for (61,70,82)) ⇒ the luminance step is preserved, separation
  unchanged, capsule still not a dead slab.
- Delete label core red (249,104,96), contrast **3.29:1** (was 3.27:1). Cancel label (239,243,247).
- AA now neutral: Delete top y621 (57,57,57), bottom y652 (50,50,50) — single pixel, **no rim**, and y653 is
  (38,38,38) immediately ⇒ **no shadow**. R032/R033 intact.
**Not re-captured:** the light theme. Its branch is byte-identical to R033 and hover/pressed still mix from
`buttonNeutral`, so the claim is code-identity — stated as such, not measured.
**Side observation:** the dialog card's bottom edge is y666 card / y667 (48,48,48) / y668+ scrim (15..17) —
a 1px bottom edge highlight. Fed to 仍差 #2 (D01/D02/D03), not judged.
**Verdict:** PASS for the step. Next: `CalendarTaskEditorDialog`'s footer (仍差 #1) — the last rim+shadow
Delete, still missing `lightLabel`/`flatPrimary`/`secondary`.

## R036 — `CalendarTaskEditorDialog` footer → flat stacked pattern (2026-10-16). **Code + build landed; in-app verification BLOCKED.**
**Atomic step:** the last dialog in the family (was 仍差 #1). One file: `apps/calendar/qml/CalendarTaskEditorDialog.qml`
(314 → 385 lines). It declared `standardButtons` and inherited `KosWorkspaceDialog`'s footer — a right-aligned
`DialogButtonBox` row of *outlined* buttons — while its `Delete task` sat as the last row of the scrolling form:
a row, not stacked, not full-width, and Delete could scroll out of reach.
**Change** (shape copied from `EventEditorDialog.qml:178-250`): `:28-38` `saveLabel`/`cancelLabel` + `Component.onCompleted`
copying the localized texts out of a hidden `DialogButtonBox { id: labelSource }`; `:61-109` new
`footer: Item { implicitHeight: 16 + footerCol.implicitHeight + 16 }` with `ColumnLayout { id: footerCol;
anchors.fill: parent; anchors.margins: 16; spacing: 6 }` holding Save (`highlighted/flatPrimary/lightLabel` →
`accept()`), Cancel (`secondary` → `reject()`), Delete task (`visible: editingId.length > 0`, `destructive`+`secondary`
→ `deleteRequested`+`close()`). The in-form Delete (old `:303-311`) removed. `standardButtons` (`:24`), `onAccepted`
(`:174`), background, sizes, Flickable/notes wheel, `payload()`/`value`/`datePart`, every field row: untouched.
**Build:** `ninja -C .build/calendar-review kos-calendar kos-pim-service` → 7/7 clean (qmlcache regenerated +
relinked ⇒ the QML parses). No other file modified (verified by the subagent's own `grep`/diff check and by reading
`sed -n '26,60p' / '60,110p' / '370,385p'` myself). Theme-neutral by construction: same opt-ins that pass in light
(R033) and dark (R034).
**Verification: BLOCKED — nothing judged this round.** Route to the popover works:
`date 2026-04-02` → *separate batch* → `view day` → `openItem {kind:"todo", titleContains:"Green planning"}`
→ popover renders (`r036-task-popover-light.png`: green dot, `[UI] Green planning 2026-04-02`,
`2026年4月2日星期四 · 09:00`, ✕, 编辑). 编辑 is `EventDetailsPopover.qml:201 objectName:"detailsEdit"`, on-screen
x643..687 / y360..385 ⇒ click (682,376). **Five press/release attempts over two launches opened no dialog.**
Every press logs `pointer press undefined 682 376 hover n/a down n/a`: the synthesized pointer resolves *no item*
(while `pointerObject … "kind":"move"` resolves fine: `{"found":true,"x":682,"y":363}`). The first raw click of the
round, (200,551), likewise did nothing — `openItem`, not the click, opened the popover. R034/R035 used the identical
route successfully earlier today ⇒ **session regression in pointer delivery, not product code.** Stopped after 2
launches per the small-step rule. Consequence: the requested before/after footer table for this dialog does not
exist; its "before" is documented from source only.
**Driver lessons (reproduced this round):** (1) `date` and `view` must be **separate batches** with a ≥1.5s settle —
batched, the deferred activation wins and the app lands in **week** view (twice); (2) `openItem` **does** work for
todos — R024's "matched nothing" was the R025 `date`-key bug, not a kind problem; (3) a 3-command batch can be
**skipped** by the app's 100ms poll (only the first logged in time) — one logical command per batch when it matters.
**Verdict:** code+build PASS as a step; **D05's task variant is NOT PASS** (unseen). Next round: revive the pointer
and capture this footer.

---

## R037 — unblock the pointer, verify R036's footer (2026-10-16)
**Atomic step:** the R036 gate (unblock pointer → capture the task footer). No product code touched.
**The blocker was a misdiagnosis.** `harness/Main.qml:185-194` logs `hover n/a down n/a` whenever `command.target`
is **absent** — `control` is only resolved when a `target` objectName is given, so a targetless `pointer` always
prints `n/a` regardless of delivery. R036 read that as "the synthesized pointer resolves no item"; it means nothing.
This round's first action (`pointer move 200 526`) printed that same line, and the app drove fine afterwards. Also
`pointer {"target":"detailsEdit"}` printed `NaN NaN` because Main.qml's `objectNamed`/`controlNamed` cannot see the
popover's button, while `ReviewInput.cpp:25` `namedPoint` can ⇒ use `pointerObject` for named targets.
**D05 task variant: PASS (light).** Route: `date 2026-04-02` / settle / `view day` / `openItem {kind:"todo",
titleContains:"Green planning"}` / `pointerObject detailsEdit` move+press+release @(682,376) / `captureClient`.
Measured on a 1100x692 shot (card x369..746 = 377 wide): 3 stacked full-width rows x384..731 (=348 = 377−2×16);
row height 31 = rendered `controlHeight`; gaps 6px; footer margins 16/16 (rows y517..621, card bottom y636);
Save fill (48,140,198) + white label, pill radius ≈15.5 = h/2; Cancel fill (227,229,230) + label (36,43,57);
Delete **last**, fill (227,229,230), label red (217,68,66), visible because `editingId` is non-empty; the old
right-aligned outlined footer and the in-form Delete are gone (form ends at the 备注 textarea).
Evidence: `r037-pop-light.png`, `r037-after-click-light.png`, `_r037-footer3x.png`.
**Verdict:** D05 task variant PASS in light; R036's code accepted. Dark not re-captured (shared code path, R035 PASS).
Next round: measure D01/D02/D03 (scrim, radius, shadow) on the existing capture — no relaunch needed.

## R038 — measure D01/D02/D03 on the existing capture (2026-10-16)
**Atomic step:** close out the three PENDING items that had been carrying since R01. **No product code touched, no
relaunch, no new screenshot** — subject `r037-after-click-light.png`, baseline `r037-pop-light.png` (popover open,
verified no scrim). Method: dialog-shot vs `0.8 × baseline`, which isolates shadow/border contributions to ~1 unit.
**Card geometry (first exact read):** outer surface x368..747 (**380 wide**), y77..636 (**560 tall**) = exactly
`min(380, pw−48)` × `min(560, ph−64)` at 1100x692. Not clipped.
**D01 scrim → PASS.** ratio = 0.798–0.800 at 11 points incl. all four corners and mid-edges ⇒ uniform black @ α 0.20
over the whole window, multiplicative (holds on white and on tinted pixels). Content stays legible.
**D02 radius → PASS, one deviation recorded.** Arc fit at 4 thresholds: R = 13.9–14.6; tangent/convergence read 15–16
⇒ rendered = `AppTheme.smallRadius + 4` = **16** (`CalendarTaskEditorDialog.qml:56`, same at
`EventEditorDialog.qml:35`). No right angles. Deviation: 16 ≠ `largeRadius` 24 and ≠ `windowCornerRadius` 32, the two
tokens the item names. Kept PASS — token-derived, the calendar app's 2/2 dialog convention (inner fields use
`smallRadius` 12, KosSurface default `mediumRadius` 20), and *closer* to macOS's ~10–12pt alert radius than 24 would
be. Escalated rather than silently accepted. Also noted: outer 1px `border` + inset 1px `innerHighlight`
(`KosSurface.qml:74-80`) = two concentric hairlines, but that is the app-wide card treatment, not dialog-specific.
**D03 → PASS.** fill flat (247,247,247) = `#F7F7F7`, a deliberate P02 neutral override, identical in both dialogs
(not `cardSurface`); 1px border Δ−17..−21, blue-tinted rgba(26,41,64,0.14); shadow **both layers present**
(ambient x−2/w+4/y+2/h+5/radius+3 @ elevation; key x−1/w+2/y+2/h+2/radius+1 @ elevation×0.72; elevation
0.5×0.38 = 0.19), offset +2px down, **0px above**, ~2px sideways, ~7–8px below, peak **Δ−10** (3.9%) ramping
−10,−7,−7,−4,−4,−3,−3,−1 — soft, no black halo; bottom inner highlight 1px at y635 (+4 vs fill).
Two chrome traps ruled out: a full-width 2px grey band at **y636–637** (present in *both* shots — an app separator)
and a day-view grid line at **y640**; neither is shadow.
**Verdict:** D01 PASS, D02 PASS (deviation escalated), D03 PASS. All three judged against the repo's own tokens and
platform convention — the reference image has no dialog. Remaining strict complaint is **magnitude** (3.9% peak reads
flat), which is app-wide and needs an explicit ruling; parked as 仍差 #1, not acted on.
Next round: D10 reveal animation, consecutive frames.

## R039 — D10 as consecutive frames (2026-10-16)
**Atomic step:** the one item that can never be judged from a static shot. **No product code touched.** Used the
harness's own `nativeRecord` action (`harness/Main.qml:20-43,112-121`) — a real burst that grabs a PNG every
`interval` ms — for 29 frames across the reveal and 28 across the exit. Route: `date 2026-04-02` / `view day` /
`openItem {kind:"todo",titleContains:"Green planning"}` / popover 编辑 at (682,376) / burst / `pointerObject
detailsEdit` move+press+release; exit burst = second `nativeRecord` + `escape`. Frame mtime deltas 33–35ms for a
requested 20ms ⇒ ~30ms resolution, enough for 220ms.
**Enter (220ms OutCubic) → PASS, genuinely ramps.** Card fill vs the scrimmed 204: f0008 (302ms) = 204 ⇒ **p 0**;
f0009 223 ⇒ 0.44; f0010 239 ⇒ 0.81; f0011 246 ⇒ 0.98; f0012 247 ⇒ 1. Geometry in lockstep — top edge 83→79→77,
left 373→368→367, right 743→746→747 ⇒ implied scale 0.977/0.991/~1.000, i.e. **opacity-p and scale-p agree at every
frame**, exactly what `scale: 0.96 + 0.04 * revealProgress` predicts. With the start at ≈330ms, OutCubic/220ms
predicts 0.36/0.82/0.98 at 360/426/490ms vs measured 0.42/0.81/0.98 — within one grab timestamp. Eye check
(`/tmp/r039-montage.png` row 1): f9 is a faint, visibly smaller ghost card; f10 firms to near-solid. Scale is real,
not just a fade.
**Exit (120ms InCubic, `motionFast` 120 at `AppTheme.qml:174`) → measurably present, only partially observable —
recorded as a verification gap, not a failure.** The fade spans only fill 247→255 (#F7F7F7 panel over undimmed
white ≈ 8 units), so 247 (p 1) → **249 (p 0.75)** → 255 (p 0) over 267/300/331ms proves the ramp exists but is
nearly invisible in this scene; the exit **scale-down is unverified**.
**New finding, escalated not fixed — the dim is decoupled from the transition.** The scrim is
`KosWorkspaceDialog.qml:24-27` `Overlay.modal` = `withAlpha(blackSeed, dark ? 0.42 : 0.2)`, a **sibling** of the
KosDialog content, so it is not inside `opacity: revealProgress`. Enter: f0008 corner (20,4) is **already 204** (full
0.20 dim, one-frame step from 255) while the card is at p 0 and absent. Exit: the dim is **gone at 199ms** (corner
255) while the card is still at **full opacity 247** — frames 0006–0008 hold a crisp card over an **undimmed** page
~70–100ms before the card goes; visible as the montage's row-2 dimmed tiles vs row-3 bright ones. One hard step in
an otherwise smooth transition, owned by a different file, shared by every workspace dialog.
**Verdict:** D10's `KosDialog` half PASS (220/120ms, OutCubic in / InCubic out, scale 0.96→1, measured across
consecutive frames). Dim-snap parked as 仍差 #1 pending a ruling. `reduceMotion` not exercised.
Next round: D11 narrow 760x540 footer (use `nativeRecord` frames, not `captureClient`, after `resize`).

---

## R040 — D11 narrow 760x540 footer: **PASS** (2026-10-16, light)

**Next-round #1 was D11.** No product code touched. Blocked method resolved first: `captureClient` after `resize`
really is useless (reproduced again — `r040-taskdialog.png` is 1100x692 after the dialog opened), but
**`nativeRecord` frames are not stale**: with `{action:"nativeRecord",prefix:"r040-narrow",duration:1800,interval:80}`
issued ~600ms *before* `{action:"resize",width:760,height:540}`, frame 0007 (722ms) is still 1100x692 and frame
0008 (801ms) is **760x540** — the resize lands inside one 80ms frame. 22 frames, all `saved:true, visible:true`.
So 仍差 #5's blocker is closed: **burst first, resize second, read frame 3+.** Also, the `nativeRecord` completion
log now prints the per-frame `elapsedMs` (80/162/246/322/401/…, i.e. requested cumulative) — that contradicts
state.md's standing claim that elapsedMs is "collected but not printed".

**Route:** light → `date 2026-04-02` → `view day` → `openItem {kind:"todo",titleContains:"Green planning"}` →
`pointerObject detailsEdit` move/press/release (edit pill measured at **(682,372)**, R039 said 376) → task dialog
open, then burst + resize.

**D11 verdict — PASS.** Measured on frame `r040-narrow-0021.png` (settled, 1763ms), probed on strict `#F7F7F7`:
| | |
|---|---|
| card | x **200..574** (375 wide), y **44..514** (471 tall) in a 760x540 window |
| vs declared cap | `min(380, 760−48)=380`, `min(560, 540−64)=476` — both respected (probe trims ~3px of edge antialias) |
| Save | y 396..427, 32px |
| Cancel | y 433..464, 32px |
| Delete | y 470..501, 32px |
| gaps | 5px measured vs `spacing: 6` declared (`CalendarTaskEditorDialog.qml:78`) |
| insets | buttons x 213..561 → 13px from each card edge vs `16 + col + 16` declared (`:62`); the ~3px delta is the button's soft edge |
| clearance | card bottom 514, window 540 → **26px** spare; nothing clipped, nothing escaping the window |

All three labels render on one line (保存 / 取消 / 删除任务), centred, no ellipsis, **no wrap** — the widest footer
in the app survives the narrowest supported window. The card width is 375 at 1100x692 *and* at 760x540, so the
380 clamp is never the binding constraint horizontally.

**New observation, escalated not fixed — the form compresses instead of scrolling.** The file asserts
(`CalendarTaskEditorDialog.qml:32-33`) "only the form above it scrolls". At 760x540 it does not: the card loses
84px (555 → 471) and the **notes viewport shrinks 96 → 73px** (wide: field box y 359..455 = 97px; narrow: y
323..395 = 73px; `Layout.preferredHeight: 96` at `:314`). Nothing is *hidden* — the notes box is the last form
element and sits fully above the footer — so the squeeze is a uniform compression, not a clip, which is why D11
still passes. But an unwrap-and-shrink of a `Flickable`-backed 96px viewport by 23px at the minimum window is a
real behaviour divergence from the comment, and at a shorter window it would keep collapsing. **Not fixed** —
same rule as R038/R039: record it, get a ruling.

**Verdict: D11 PASS.** Both D11 sub-claims (no clip, no wrap) measured, not eyeballed. Still open from D11's
neighbourhood: 仍差 #6 (task-dialog footer never captured in **dark**).
Next round: #2 — dark task-dialog footer, the last un-captured member of the shared footer shape.

---

## R041 — dark task-dialog footer → PASS, and a correction to R040's narrow notes number

**Route:** dark → `date 2026-04-02` → `view day` → `date 2026-04-02` → `openItem {kind:"todo",
titleContains:"Green planning"}` → `pointerObject detailsEdit` move/press/release (**found at (682,376)**) → 编辑任务
open → `captureClient` → wide probe. Then the R040 narrow recipe: `nativeRecord {prefix, duration:1800,
interval:80}` then, 0.6s later, `resize {760,540}`.

**The recipe reproduced exactly.** 22 frames, all `saved:true visible:true`; frame 0007 (640ms) is 1100x692,
frame 0008 (732ms) is 760x540 — the resize lands inside one 80ms frame, exactly as R040 reported. Settled frame
probed: `r041-narrow-0021.png` (1761ms). Also learned: the reported `duration` is requested + one interval
(1800 → 1840), and **`capture` is not a harness action at all** — it falls through to `Main.qml:249`'s manual
branch, prints `contentY/width/height/contentHeight`, and saves nothing (the first attempt produced no file).

**Measurements.** Wide = `r041-taskdialog-dark.png`, narrow = `r041-narrow-0021.png`.

| | wide 1100x692 | narrow 760x540 | declared |
|---|---|---|---|
| card | x 370..745, y 77..634 (381×558) | x 197..577, y 44..514 (381×471) | `min(380, w−48)`, `min(560, h−64)` |
| Save | y 516..547, 32px | y 396..427, 32px | |
| Cancel | y 553..583, 31px | y 433..464, 32px | 34 control height |
| Delete | y 590..620, 31px | y 470..501, 32px | |
| gaps | 5 / 6px | 5 / 5px | `spacing: 6` (`:78`) |
| button row | x 383..731 (349 w), insets 13–14px | same | `16 + col.implicitHeight + 16` (`:62`) |
| notes box | y 359..455 = 96px | y 323..361 = 39px | `Layout.preferredHeight: 96` (`:314`) |
| clearance | — | card bottom 514 vs 540 → 26px spare | |

Dark fills: card **#262626 (38,38,38)** ✓ as declared (`CalendarTaskEditorDialog.qml:57`); Save pill
**(48,140,198)** — the same accent light measures; Save label (249,251,250), Cancel label (233,237,245);
**Cancel and Delete both (69,69,69) = #454545, perfectly hue-neutral** ⇒ R035's `buttonNeutral` dark fix holds in
the task dialog; Delete label **(249,103,94)** red. Corner inset ≈7px over 16px of rise ⇒ radius 16 ✓. All three
labels single-line, centred, no ellipsis, no wrap.

**Headline: light and dark are pixel-identical in layout.** Every number in the narrow column is the number R040
measured in light (card 44..514, Save 396..427, Cancel 433..464, Delete 470..501, 5px gaps, 26px spare). Only the
fills differ. **Dark task-dialog footer PASS — 仍差 #6 closed.** The shared footer shape is now measured in both
themes at both supported extremes.

**Correction to R040: the narrow notes viewport is 39px, not 73px.** Re-probed `r040-narrow-0021.png` directly —
at x=350 the box's top border is at y=323 and the fill returns to card colour at y=361, in light *and* dark. R040's
73 counted the box *plus* the 34px of card fill down to the Save button. Why the bad number: in light the card fill
#F7F7F7 (247,247,247) and the notes fill (248,248,249) are within 2/255, so the box is only locatable by its border
row (222,224,226) — any fill-based scan over-reaches. The compression is therefore **worse** than recorded
(96 → 39px, −57px, not −23px). 仍差 #3 is amended, not weakened; still no clip (box bottom 361 ≪ Save top 396), so
D11's verdict stands.

**New observation, recorded not fixed — the card is never centred.** Card centre is **+7px right of window centre
at both sizes** (1100: 370..745 → 557 vs 550; 760: 197..577 → 387 vs 380), in both themes. Constant offset, cause
unknown. Cosmetic, below the spec's resolution — filed as 仍差 #6, not fixed.

**Verdict: dark task-dialog footer PASS; 仍差 #6 closed.** Next round: #1 — D10's exit scale-down, using the
burst-first recipe to finally catch the exit mid-animation.

## R042 — D10 exit half: the exit scale-down exists and matches its declaration (2026-10-16)

**Atomic step:** 仍差 #5 — the one D10 criterion never measured: does the dialog *scale down* on exit?
Verification round, no product code touched. Light theme.

**Route:** `date 2026-04-02` → `view day` → `date 2026-04-02` → `openItem {kind:"todo", titleContains:"Green
planning"}` → `pointerObject detailsEdit` **move / press / release as three separate commands** → 编辑任务 open →
`nativeRecord {prefix:…/r042-exit, duration:1000, interval:12}` immediately followed 0.6s later by `escape`.
30 frames, elapsed 13 → 975ms, spacing ~33ms. Escape landed between frame 0018 (615ms) and 0019 (649ms).

**First finding — a harness usage error that cost a cycle.** `pointerObject` takes a single `kind`
(`harness/Main.qml:131-135` → `ReviewInput.cpp:67`). Passing an `events` array instead sends one `MouseMove`
(`.cpp:73` initialises `type = MouseMove`) and opens nothing; the log line reads `pointerObject detailsEdit
undefined {"found":true,...}`. R039/R041's prose "move/press/release" means three commands. Logged.

**Probe choice.** The card fill alone cannot carry the opacity in light: 247 on a 255 page is 3%, so quantisation
swallows the entire fade. The **Save pill** (48,140,198 on 247) is the one high-contrast feature inside the card;
`p = (255 − v)/(255 − 48)` recovers opacity to ~1%. Pill row y=531, card top edge at x=557.

| frame | ms | pill x | p | note |
|---|---|---|---|---|
| 0017 | 579 | 383..731 | 1.00 | page 204 ⇒ dim present |
| 0018 | 615 | 383..731 | **1.00** | page 204 ⇒ dim present |
| 0019 | 649 | 383..731 | **0.70** | **page 255 ⇒ dim gone, in one frame** |
| 0020 | 682 | 383..731 | 0.70 | plateau |
| 0021 | 715 | 384..731 | 0.68 | |
| 0022 | 749 | 384..730 | 0.65 | |
| 0023 | 782 | 385..730 | 0.58 | card top 516 → 515 |
| 0024 | 815 | 386..728 | 0.47 | card top 514 |
| 0025 | 849 | **388..726** | 0.32 | card top 513 |
| 0026 | 882 | — | 0 | gone |

**Scale: PASS.** The pill contracts **symmetric about the card centre x=557** — left 383 → 388 (+5), right
731 → 726 (−5) — and the card's top edge at x=557 moves 516 → 513 (predicted 355.5 + 160.5·s). At frame 0025
p = 0.32, so the declared `0.96 + 0.04·p` = **0.9728**; measured off both pill edges = **0.971**. Two axes,
0.2% agreement. `KosDialog.qml:10`'s `scale` really is driven by `revealProgress` on the way out as well as on
the way in. **仍差 #5 closed** — D10 no longer has any unmeasured criterion.

**Two results that do not match the declaration.** (a) The fade runs 1.00 → 0 over **~230–250ms**, ≈2× the
declared `motionFast` **120** (`AppTheme.qml:174`). (b) The dim leaves in a **single 34ms frame at 649 — the first
frame of the exit**, while the card is still at full scale and full opacity; R039's "70–100ms early" is confirmed
and sharpened into "at the start, in one step".

**Why (a) is not yet a product verdict.** The mid-fade rate fits no single InCubic: 649 → 782 (p 0.70 → 0.58,
Δt 0.08) implies D ≈ 1660ms against 120, and D ≈ 660ms against 220. The shape — a 1–2 frame plateau at 0.70,
slow drift, fast finish — is exactly what you would get if the burst's own `grabWindow` loop perturbs the
animation clock. Filed as 仍差 #2 with an explicit confound, not as a defect. (b) cannot be manufactured by a
clock error — a one-frame step from 204 to 255 is a discontinuity — so 仍差 #1 stands on its own.

**Verdict: D10 exit scale-down PASS, 仍差 #5 closed.** Next round #1: run the *identical* burst over the **enter**
(declared 220ms OutCubic, 4× the exit) as the control — if it too measures ~2× long, 仍差 #2 is deleted as an
artifact; if it measures ~220ms, the exit really is twice its declared duration and the search moves to
`KosWorkspaceDialog.qml` for a second transition on the same property.

## R043 — burst de-confounding: the ENTER is 2× long too ⇒ 仍差 #2 retracted (2026-10-16, light)

Atomic step: Next round #1 of R042 — run the **identical** burst over the dialog **enter** as the control.
Measurement only, **no product code touched**.

**Route trap found first (cost one wasted burst).** The harness reads command fields **flat** —
`command.date` (`Main.qml:221`), `command.view` (`:217`), `command.kind`/`command.titleContains` (`:225`) — **not**
nested under `args`. A command sent as `{"action":"date","args":{"date":"2026-04-02"}}` still advances `sequence`
and logs nothing, so it looks like it ran; the app simply stayed in the launch default (week view / 10月 12–18,
2026) and the first `detailsEdit` click resolved to **(316,75)** instead of (682,376). Re-sending flat fixed it
and reproduced R042's (682,376) exactly.

**Enter burst.** 21 frames, elapsed **13 → 985ms**, `interval:12`. Frame deltas: 33ms through frame 0012 (428ms),
then **47 / 73 / 77 / 77 / 82 / 85 / 76** for 0013–0020. The record loop degrades ~2.4× *precisely while the
dialog animates* — the confound R042 suspected is visible in the sampling itself.

**The dim snaps on ENTER too — and it is now structurally explained, not merely measured.** Page at (1040,400)
is **255** through frame 0012 (428ms) and **204** at frame 0013 (468ms) — the full `0.20` dim (`255·0.8 = 204`) in
the **same single frame the dialog first becomes visible**. Cause is in the source: `KosWorkspaceDialog.qml:24-27`
`Overlay.modal` is a plain `Rectangle` with **no animation**, while `KosDialog.qml` animates only
`revealProgress`. The dim therefore *cannot* ramp — it can only be on or off. R042 saw the mirror image on the
exit. **仍差 #1 is upgraded from "measured once" to "structural + measured on both transitions".**

**The enter measures ≈440ms, twice its declared 220ms, on two independent axes.**

| frame | ms | page | pill left x | geomP = (s−0.96)/0.04 | pill minR | blendP (bg 247) |
|---|---|---|---|---|---|---|
| 0013 | 468 | 204 | — (invisible) | — | — | — |
| 0014 | 515 | 204 | 388 | 0.28 | 153 | 0.47 |
| 0015 | 588 | 204 | 386 | 0.57 | 110 | 0.69 |
| 0016 | 665 | 204 | 384 | 0.86 | 79 | 0.84 |
| 0017 | 742 | 204 | 383 | 1.00 | 60 | 0.94 |
| 0018 | 824 | 204 | 383 | 1.00 | 51 | 0.98 |
| 0019 | 909 | 204 | 383 | 1.00 | 48 | 1.00 |

`geomP` uses the pill's left edge against the card centre x=557 (`s = (557−left)/174`) — a *geometric* read, immune
to every blend assumption. Both axes track each other within 1px, confirming that `scale` and `opacity` are driven
by the same `revealProgress`. Against `Easing.OutCubic` with `t0 ≈ 468ms`, **D ≈ 440ms fits both** (e.g. at
τ=118.6 geomP 0.61 vs 0.57 measured; at τ=195.6, 0.83 vs 0.86); **no `t0` fits D = 220ms** (D=220 predicts 0.82
where 0.57 is measured).

**Verdict, per R042's pre-registered rule.** Enter ≈440ms = **2×** its declared `motionNormal` **220**
(`AppTheme.qml:175`), and the exit's R042 measurement was ≈240ms = **2×** its declared `motionFast` **120**. A
*uniform* 2× in both directions is the signature of a measuring instrument, not of two separate product defects.
`KosDialog.qml` has exactly **one** transition per direction, on one property (`:15-23` enter, `:24-32` exit), and
`AppTheme` contains **no duration scale** (`:174-176`, `reduceMotion` false at `:26`). ⇒ **仍差 #2 (exit timing) is
retracted as a burst artifact; the exit's 120ms stands.** The recorder is wall-clock (`Main.qml:24`,
`Date.now() − nativeRecordStarted`) behind a QML `Timer` (`:19-22`) whose blocking `capture()` call (`:36`) is what
starves the loop — which is why the *sampling* stretches, and why both directions stretch by the same factor.

**The control that would have settled the mechanism did NOT run.** The plan was to re-run the enter with
`interval:60` (5× less grabbing): if the measured duration shrinks, the burst stretches time; if it stays 440ms,
the product genuinely animates 2× long. Attempted twice, both failed: **after `escape` the day-view selection is
gone, and re-running `date`/`view`/`date`/`openItem` does not restore it** (`openItem` is a silent no-op on an
empty `selectedItems`). `detailsEdit` still resolves to (682,376) — `found:true` all three events — but the click
is inert and no dim ever appears (page stays 255 for all 19 frames of both attempts). The retraction above
therefore rests on the pre-registration, not on a completed control; the mechanism is unexplained to the extent
that a wall-clock-driven QML animation ought not to stretch under a starved GUI thread. **Recorded as an open
question, not papered over.**

**Verdict: retain the retraction, close 仍差 #2, escalate the dim snap.** Next round #1: finish the interval-60
control — the prerequisite is a *fresh* enter, which needs either an app restart or a genuine day-view item click
to repopulate `selectedItems`; document which of the two actually works.

---

## R044 — the interval-60 control ran, and it refuted *both* pre-registered outcomes (2026-10-16, light)

Three rounds of argument about a 2× timing deviation were settled by fixing the **probe**, not by more bursts.
R043's geometric read (pill left edge) had only 7px of travel for the whole 0.96→1.00 scale, so ±1px quantisation
= ±0.14 in `p`: it could never have separated a 220ms animation from a 440ms one. Replaced this round with a
**calibrated blend probe** — five points in the card's empty band, each calibrated against its own pre-dialog
backdrop (last undimmed frame × 0.8), α = (m − backdrop)/(247 − backdrop), ~49 grey levels of range instead of 7.
It self-checks twice: α = 0.00 exactly at the frame the dim appears, and α = 1.00 thereafter. All five points,
over three distinct backdrops, agree to ±0.01 at every frame.

With that probe the round ran the *same flat route* with *byte-identical trigger timing* on two freshly
restarted instances, differing only in the recorder interval:

- **interval 60** (19 frames, 61→1156ms, deltas flat at 60ms): α = 0.34 @547, 0.89 @635, 0.98 @685, 1.00 @752 →
  **D = 225ms**, t0 = 518ms. The frame at 685ms is predicted at 0.983 for that fit and measured 0.98.
- **interval 12** (30 frames, 13→1197ms, deltas 33ms idle → **62ms during the animation** → 33ms after):
  α = 0.49 @405, 0.84 @461, 0.98 @523, 1.00 @581 → **D = 219ms** and **228ms** from the two successive pairs,
  t0 = 361ms.

**Both legs return 220ms — the declared `motionNormal` (`AppTheme.qml:175`) — within 4%.** The geometric axis
corroborates on the c60 leg (pill left edge at its final 384 from 685ms on). Neither branch of the fork the round
pre-registered occurred: it neither shrank below 440 nor stayed at 440. It came back at 220, which means **R043's
440ms does not reproduce**, and the pre-registered reading — "the burst stretches animation timing ~2×" — is
**refuted by its own control**: c12 starved exactly as R043's instance did and still reported the animation
honestly.

Where the two runs part, with numbers: R043's early points match this round's (α = 0.47 at Δt≈47ms after the dim
vs 0.49 at Δt≈44ms); the split begins at Δt≈120ms (mine 0.84, theirs 0.69) and widens. Their capture deltas over
those frames grew 47→73→77→77→82→85 while mine grew 41→43→39→47→56→62→58→61. So their instance was under
heavier capture load *and* reported a slower animation, while a moderately starved instance does not. That
correlation is recorded as **the** open question — I have shown a moderate load does not delay a wall-clock
animation, not why a heavy one would.

The dim snap, measured for the third time, gained a sharper shape: the page steps 255→204 in a single frame while
the card sits at **α = 0.00 in that same frame** (c60 482→547ms, c12 319→358ms). The dim therefore leads the
card's first non-zero frame; it is the separate un-animated `Rectangle` that `KosWorkspaceDialog.qml:24-27`
implies. 仍差 #1 unchanged.

**Verdict: 仍差 #2's retraction stands, now on direct evidence rather than on a pre-registration; the exit half of
D10 is the only timing claim still unmeasured, and R042's 240ms for it is now suspect for the same reason.
Next round #1: re-measure the exit's decay with this probe, at both intervals, before touching any code.**

---

## R045 — D10 exit half: the exit reads ≈125ms, i.e. its declared `motionFast` (2026-10-16)

**Atomic step:** R044's next round #1 — measure the dialog **exit's** decay with the α probe at honest sampling.
Measurement only, **no product code touched**. Two freshly restarted instances, light theme, `interval:12`.

**Route** (flat fields), one restart per leg: `date 2026-04-02` → `view day` → `date 2026-04-02` →
`openItem {kind:"todo", titleContains:"Green planning"}` → `pointerObject detailsEdit` move/press/release
**— the press is what raises the Dialog; `openItem` alone leaves only the popover, page 255, no dim** →
`nativeRecord {duration:1200, interval:12}` → 0.30s later a single `escape`.

**The probe had to move, and that is the round's real content.** The exit `Dialog` fades *and* shrinks
(`KosDialog.qml:10-11`: `opacity: revealProgress`, `scale: 0.96 + 0.04·revealProgress`), so R044's point set is
invalid here: points near the card edge leave the card mid-flight and read page content — the first pass returned
α = 4.88, an impossible value, at the R044 coordinates. The five points are now **y = 480, x ∈ {400,470,556,640,
710}** — ≥100px inside the card (rect 369,79→744,634; 376×556) *and* over a day-view event bar, so the underlying
is **216 rather than 255**. That is the whole gain: α resolution **1/31 = 0.032 instead of 1/8 = 0.125**. The
underlying is read per point from the last post-exit frame (the day view does not reflow, so it is a valid
reference). On both legs all five points agree to ±0.032 at every frame — five independent samples of one
composite, not five chances to get the right answer.

| leg | t0 anchor | α(t) | InCubic fit |
|---|---|---|---|
| **ex2** | dim snaps 204→255 between 230 and 265ms | 1.000 @14…265 · **0.903 @318** · **0.032 @384** · 0.000 @452 | **D = 125ms**, t0 = **261ms** |
| **c12** | button goes disabled in the 302→354ms frame; dim snaps 204→255 in that same frame | 1.000 @302 (m=247) · 1.000 @406 (m=247) · 0.125 @470 (m=254) · 0.000 @539 | D = 120ms, t0 = 355ms ⇒ predicts **m = 254.0 @470**, measured **254** |

**Both legs return 120–125ms = the declared `AppTheme.motionFast` 120 (`AppTheme.qml:174`), within 4%.** The ex2
fit rests on two in-window samples (0.903 and 0.032, 66ms apart); because it is an InCubic, the *ratio* of those
two α values fixes `t/D` on its own and forces D = 124.6ms. What makes it trustworthy rather than circular is the
**independent anchor**: the dim's discrete 204→255 step brackets t0 in (230, 265] — a bracket that contains the
fitted 261ms to 4ms, from a signal that has nothing to do with the fit. Leg 1's single in-window sample lands on
254.0 predicted / 254 measured.

**The doubled hypothesis is excluded, not merely disfavoured.** R042's 240ms would put leg 1's 470ms frame at
α = 1 − (115/240)³ = 0.886 ⇒ **m = 248**. Measured **254**. Six grey levels against ±1 noise, at exactly the point
that fits 120ms to the level. So R042's 240ms was an artifact of R043's method — the same method R044 already
caught over-reporting the *enter* by 2×. **仍差 #8 closes permanently; D10 is a full pass on both halves.**

**The exit's sequence, measured.** The dim snaps 204→255 in **one frame**, and in that same frame the footer
button is *already* disabled — so `onAboutToHide` / `enabled: !closing` fire at one instant, and then the card
fades over 120ms. That is the exact mirror of 仍差 #1's enter shape (dim on one frame *before* the card's first
non-zero frame), and it is now measured on both directions of the transition.

**One observation, recorded rather than filed.** The disabled footer button's colour is itself animated: leg 1
shows the pill fill uniform (112,174,214) @354ms → (122,180,216) @406ms — an accent→disabled blend of 0.69 → 0.63
— while the card fill sits at exactly 247, i.e. the dialog's opacity is still 1.00. So it is a second animation on
a *different* property (KosButton's disabled colour), not dialog transparency. It is also what makes a pill-based
α probe read a bogus plateau; the probe moved off the pill because of it. No spec ID covers this; not a deviation.

**Verdict: exit = 120ms declared, 125ms measured; 仍差 #8 closed; D10 passes on both halves.**
Next round #1: re-judge **P01 (long-text)** — with the timing question finally settled, the loop's remaining
currency is unjudged spec IDs, and P01 has not been looked at since R025 restored the fixtures.

## R046 — 2026-10-16 — P01 long-text re-judged: PASS (light, measured)
- **Atomic step:** Next round #1 of R045 = re-judge P01 (long text). Measurement + judgment only, **no code change**.
- **Premise corrected:** P01 is the **detail popover** (`spec.md:54`), not a week-view row — row elision is **E03**.
  Fixture confirmed at `profile/pim/calendar.ics:91` (VTODO due 2026-04-02T11:00); `long-label.py` is the S05
  sidebar-list fixture and is currently restored to "Inbox".
- Route, light, one leg: `date 2026-04-02` → `view day` → `captureClient` → `openItem {kind:"todo",
  titleContains:"deliberately long"}` → `captureClient`. Diff bbox (368,266,732,428) = popover only.
- **Verdict PASS, by pixel:** card 340×136 at (380,278) — matches the declared 340 content width + 14 padding
  stack to 1px; fill (245,245,245) = `#F5F5F5` **exactly**; 1px border at x=380/719 reading (172,172,172) (the
  border composited on the shadow's own α≈0.23 edge); shadow gradient x 368→379 + below.
- **The long-text answer:** title wraps at a word boundary to **2 of its 3 allowed lines**; line 1 x 412→635,
  line 2 x 413→516 vs a content limit of **705** ⇒ **70px headroom, no ellipsis, no clipping, no overflow**.
  Cap-top rows 297–314 / 319–333 ⇒ pitch 22px; darkest title pixel (26,26,26) = `#1A1A1A` exactly. Secondary
  line darkest (116,113,114) ≈ `rgba(0,0,0,0.55)` over `#F5F5F5` (predicted 110). Status dot 10×10 at
  (394–403, 309–318), colour (57,196,135). Edit pill 44×24 at x 660–703 (content limit 705).
- **Observations, none filed as a defect:** (1) line pitch 22 at font 15 = 1.47 is looser than macOS's ~1.2 —
  CJK font-stack leading, the same mechanism behind the recorded `controlHeight` 31-vs-34 (仍差 #8). (2) The ref
  contains **no popover** (814x522 month view + sidebar, verified) ⇒ P01 is a HIG-convention match like
  D01/D02/D03/D06/D07/D10, with no ref-derived number to judge against; the ref *does* show row `…` elision
  (E03's target). (3) The popover's screen position is a **harness artifact**: `openItem` → `openAt(null)`
  (`EventDetailsPopover.qml:258-277`) **centres** it — measured x 380 / y 278 are exactly the centring
  arithmetic for root 368×164 in a 1100×692 host. Never judge popover position from a harness-driven open.
- **Dead end, recorded:** the long task's row is **not on screen** at the day view's default scroll (x 340–760,
  y 240–450 is empty grid), so E03 is **not** covered by this round's evidence → Next round #2.
- **Harness note:** two `captureClient` calls over different states gave different md5s at an *identical* byte
  size (3050463). **Equal file size is not evidence of a stale buffer — compare md5.**
- Still open inside P01: **dark** and **narrow-window** popover (Next round #1 = dark).

## R047 — P01 long-text, **dark** leg ⇒ **P01 CLOSED on both themes** (2026-10-16)
- Measurement + judgment only, **no product code touched.**
- Route, dark, one restart (`start-review-vm.sh dark`, launched from repo root — see harness note): `date
  2026-04-02` → `view day` → `captureClient p01-dark-row.png` → `openItem {kind:"todo", titleContains:"deliberately
  long"}` → `captureClient p01-dark-popover.png`. Diff bbox **(376,276,724,418)** = popover only.
- **Verdict PASS, by pixel, on all four declared dark values** (`EventDetailsPopover.qml:20-24`): surface box
  **340×136 at (380,278) — identical to light**; fill **(38,38,38) = `#262626` exactly**; border 1px at x=380/719 and
  y=278/413 reading **(42,42,42)/(43,43,43)**, i.e. `Qt.rgba(1,1,1,0.12)` composited on the shadow's own edge
  (neighbour outside = (15,15,15) ⇒ 0.12·255 + 0.88·15 = 43.8 ✓); title brightest **(242,242,242) = `#F2F2F2`
  exactly**; secondary brightest **(164,164,164) vs predicted 0.58·255 + 0.42·38 = 164.0** ✓. Status dot 10×10 at
  x 394–403 / y 309–318, colour **(57,196,135)** (same as light). Shadow ramp x 376→379 (30→15). Edit pill 1px rim
  **(63,63,63)** at x 658 & 705, y 374 & 399 (47×26 outer), transparent fill, right edge 705 = content limit.
- **The long-text answer, dark:** title ink rows 297–317 / 319–334 ⇒ **2 lines, pitch 22px** (same as light ⇒ same
  CJK font-stack mechanism as 仍差 #8). Line 1 x **412→636**, line 2 **413→517** vs content limit **705** ⇒
  **69px headroom, word-boundary wrap, no ellipsis, no clipping, no overflow.** Confirmed by eye on
  `r046-dark-pop-2x.png`. Hierarchy (title 15 DemiBold #F2F2F2 > secondary 12 @0.58 > outlined pill) holds.
- **Newly pinned from `:96-125`:** the header `RowLayout` has **three** children — dot(10) → title(fillWidth) →
  **`closeButton` 22×22 (`objectName:"detailsClose"`)**. The grey ✕ ink at x 691–698 / y 310–317 is that button, a
  **declared** element sharing the content limit 705 with the pill; title line 1 ends at 636 ⇒ 48px clear. Not
  overflow.
- **Observation, not a defect (new 仍差 #9):** in dark the border composites to only **Δ4/255 over the fill**
  (42 vs 38) — vs **Δ73** in light — because it is painted on the shadow's own dark edge; the card's edge is
  carried by fill-vs-backdrop instead (**38 on 30 = Δ8/255**). Declared tokens are correct; the effect is weak by
  construction. Cosmetic, no ID covers it.
- **Harness note (new):** `start-review-vm.sh` blocks on `wait "$app_pid"` ⇒ must be backgrounded; wrapping it in
  `timeout 180` kills the app with it. And `captureClient` paths resolve against the **launcher's** CWD, so a
  repo-root launch writes the PNGs to the repo root (moved in afterwards).
- **P01 long-text: CLOSED, light + dark. Still open inside P01: the narrow-window popover** → Next round #2.
  Next round #1 = **E03 row elision** (week view first), which R045's plan had wrongly filed under P01.

## R048 — E03 row elision, week view (2026-10-16, measurement + judgment only, no code change)

Route, light, one restart: `start-review-vm.sh light` (from **repo root** ⇒ the PNG landed at repo root and was moved
in) → `date 2026-04-02` → `view week` → `captureClient r048-week.png` (1100x692).

### Declared criterion (read first)
`apps/calendar/qml/CalendarScheduleView.qml` — all-day chip `:292` and timed chip `:413` are both a `Label` with
`anchors.fill: parent`, **`anchors.leftMargin: 5` / `anchors.rightMargin: 4`**, `font.pixelSize: 9`,
`verticalAlignment: VCenter`, **`elide: Text.ElideRight`**. Chips are fixed **`Layout.preferredHeight: 21`**
(`:389`); a timed cell renders **`hourCell.cellItems.slice(0, 2)`** (`:388`; all-day `:270`); a trailing
`Item { Layout.fillHeight: true }` (`:428`) top-packs the cell.

### Grid geometry (measured)
Vertical rules at y 165..470 sit at **x = 52, 201.5, 351.5, 501.5, 651.5, 801.5, 951.5** ⇒ **column pitch 149.5**.
Chips are inset **3px** per side ⇒ **144px wide**. Chip fill light **(216,234,245)**; hour-row pitch ≈ **54px**.

### Clause 1 — "short blocks show one readable priority line" → **PASS**
Every chip renders exactly one line, VCentered, no wrapping, colour-coded by list. Verified across six columns
("Morning planning", "Short appointment", "Design review", …).

### Clause 2 — "long titles elide inside bounds" → **PASS, measured twice**

**Latin — 周一 30 · 11:00 cell** (title "Long review with a deliberately lengthy title"). Chip x **55→198**
(144 wide; column 52→201). Ink span **61→192**:

| property | declared | measured |
|---|---|---|
| text-box left | chip+5 = **60** | first ink **61** (1px left bearing) ✓ |
| text-box right | chip−4 = **194** | last ink **192** ⇒ **2px inside the declared box, 6px clear of the chip edge** ✓ |
| tail glyph | `…` from `ElideRight` | three dark dots at **x 186 / 189 / 192**, **pitch 3px**, min-lum **77** ⇒ a literal `…`, **not** a fade, **not** a hard clip ✓ |
| row bounds | chip 55→198 | no ink at x 194–198 (fill 213–222); 199–200 white gutter ⇒ ellipsis **inside** ✓ |

**CJK — 周四 2 · 11:00 second chip** ("[R019 LONG TASK] 任务长标题…"). Chip x **505→648**, ink **511→641**;
`…` dots at **634 / 637 / 640**; declared box right = **644** ⇒ **inside**. Critically, the glyph **immediately
before** the dots is a **complete** CJK box — ink x **625–632** (8px) with a clean fill gap at **633** — so there is
**no mid-glyph clip and no ellipsis-over-glyph overlap**, which is the failure mode CJK elision usually has. ✓

### Clause 3 — "tall blocks top align" → **NOT JUDGEABLE in the week view**
`:389` forces **every** timed chip to `Layout.preferredHeight: 21`; an event's duration never changes its rendered
height, so the week view contains **no tall block** to test. Cells *are* top-packed (`:428`), but that is not the
clause. **Not a pass, not a fail — deferred** to a view whose block height tracks duration. **E03 therefore stays
PENDING.**

### Observation, not filed as an E03 defect (new 仍差 #9)
`slice(0, 2)` (`:388`) silently caps a cell at two chips with **no `+N` affordance**. On **2026-04-02 11:00** the
fixtures hold **three** items — the event "Long review with a deliberately lengthy title", the VTODO at
`profile/pim/calendar.ics:91` "A deliberately long task title to inspect elision" (**DUE 20260402T110000**), and the
VTODO at `:287` "[R019 LONG TASK] …" — and the 周四 11:00 cell renders exactly **two** (the event + the `:287`
VTODO). The `:91` VTODO is **dropped with no trace**. E03's text covers elision, not overflow ⇒ needs a ruling
(show `+1`, or let the cell scroll), not a silent fix.

### Instrument notes added this round
- **`ElideRight` emits a literal `…`, not a gradient fade.** At 9px the three dots read as *faint grey* to the eye
  even in a 4x NEAREST zoom — do **not** judge "elided?" by eye alone; confirm by **column min-lum profile**
  (dark minima at 3px pitch).
- **Week-view chips never exceed 21px** regardless of duration ⇒ any future "tall block" judgement must use the
  month view or a day column, not the week view.
- Sampling a chip's interior must avoid text rows: the 21px chip has ~5px of clean fill above/below the 9px glyphs.
  A row picked 1px off the chip's bottom edge reads as white and silently invalidates a scan (cost this round one
  wasted measurement at y=499).

---

## R049 — E03 clause 3 ("tall blocks top align"): **BLOCKED on a ruling — no tall block exists in any view** (2026-10-16)

Atomic step: R048's Next-round #1 = judge E03 clause 3 in a view that has tall blocks. Measurement + judgment
only, **no product code touched, no build**.

Route, light, one restart: `start-review-vm.sh light` (from **repo root** ⇒ `captureClient` landed at repo root,
moved in after) → `date 2026-04-02` → `view month` → `captureClient r049-month.png` (1100x692).

### What was measured

**Month grid (`CalendarMonthView.qml`), 1100x692 light:**
- Row pitch **60.7px** — day-number ink tops at **y 165 / 226 / 287 / 348 / 408** (diffs 61/61/60/61).
- Day-number ink top → chip fill top = **+18px**.
- Every populated day cell shows **exactly one** chip; its fill band is **y 183 → 200, h = 18px** in *all six*
  populated columns. Chip x-runs **(6,148) (164,305) (321,463) (636,778) (794,935)** ⇒ column pitch **157.5**,
  chip width **143**, inter-cell gap **16**. 周四 2's run (473,626) w154 is the **selected-day rect**, 5px proud
  each side — not a wider chip.
- Overflow is rendered as a `+N` counter (**+8 +8 +11 +9 +7**), never as extra chips.
- Chip fill is **per-list tinted**, not the week view's uniform colour: **(241,247,251)** for 周一30's
  "Multi-day review", **(222,236,246)** for 周四2's "Morning planning".

**Only two grid components exist** (`apps/calendar/qml/`): `CalendarMonthView.qml` and
`CalendarScheduleView.qml`. The latter serves **both** week and day — `Main.qml:2502` `dayCount: 7`,
`Main.qml:2532` `dayCount: 1`. R048 measured it: timed chip fixed `Layout.preferredHeight: 21`, hour row fixed
`54` (`:353`), all-day chip fixed `18` (`:277`). A duration / startTime / endTime / span grep across all five
calendar QML files returns **nothing height-related**.

Line-number drift note: R048 cited the timed chip at `:388`/`:389`; by content it is now `:394`/`:395`.

### Verdict

Clause 3's precondition — a tall block — **never occurs in any of the three views**: month 18px fixed, week and
day 21px fixed, and no code path maps a duration to a height. So the clause **cannot be verified as PASS**, and it
is **not a text-alignment bug** either: there is no tall block whose text could be mis-aligned.

Against the ref this is a **structural divergence, not a vacuous clause**. `.loop/refs/macos-calendar.png` is the
**Week** view (`Day|Week|Month|Year`, Week active) and its timed blocks are unmistakably duration-proportional and
**top-aligned**: "Stretchin… 11AM–1PM" spans ~2 hour rows with its label at the top, "Writing s…" ~3–6PM,
"Drop off… 5:30–7PM", "Hike with… 10AM–12…" and "Plant gar…" are tall blocks, each with a top-anchored title and
its time caption **below** it.

⇒ Owner's call, same class as 仍差 #1/#2/#3 (declared criterion the build does not satisfy):
- **(a)** clause 3 presumes a proportional-block model the app replaced with fixed 21px agenda chips ⇒ **reword or
  drop clause 3**; or
- **(b)** the week/day view should gain duration-proportional, top-aligned blocks ⇒ a feature, not a tweak.

**E03 stays PENDING; clauses 1+2 remain PASS (R048). Do not mark E03 PASS, and do not "fix" this silently.**

### Negative finding recorded, to stop a future false defect
`ui-review-multiday` (`profile/pim/calendar.ics:570-575`, `DTSTART;VALUE=DATE:20260330`,
`DTEND;VALUE=DATE:20260403`) renders as **three separate 143px chips with a 16px gap** on 周一30 / 周二31 / 周三1,
not one bar spanning the row. **This is NOT a defect.** A 2x crop of the ref's all-day row
(`_r049-ref-allday2x.png`, ref x205–815 y125–180) shows the ref also uses **per-day-column chips**, stacked up to
**3** per column, with **no** spanning bar. "Multi-day events should be one continuous bar" is not a finding.

### New 仍差 #8 (measured, needs a ruling)
**Month day cell holds 1 chip + `+N`; the ref holds 3 stacked chips.** Ref columns show 3 chips each
("Antonio…"×2 + "Palm Sun…"; "April Fool…" + "Passover" + "Take out t…"), ours show 1 (`+8/+8/+11/+9/+7`). Same
family as 仍差 #7 (schedule view `slice(0,2)`): both are silent per-cell caps with no affordance.

### Instrument notes added this round
- **`captureClient` has no `file` field — the key is `path`**: `{"action":"captureClient","path":"x.png"}`;
  `view` is `{"action":"view","view":"month"}`; `date` is `{"action":"date","date":"2026-04-02"}`
  (`harness/Main.qml:122/217/221`).
- **Do not locate a month chip by fill colour.** Month chips are list-tinted ((241,247,251) and (222,236,246)
  measured for two different lists) and one of them sits inside the selected-day rect. Use row/column geometry.
- **The month grid draws no cell borders at all** — a column scan at x=1010 over y 140–500 returns pure white
  through every row boundary. Cell geometry must be inferred from day-number ink and chip runs, never from rules.
- Sampling a chip's mid row hits text ink: at x=60 the 18px chip reads (241,247,251) at y184-188 but (187,187,195)
  at y190. Sample y = chip_top+2, not chip_mid.

---

# R050 — P01 narrow-window (760x540) popover: **PASS — no compression, material size-invariant** (2026-10-16)

Atomic step = R049's Next round #1. Measurement + judgment only, **no product code touched, no build**.

Route, light, one live instance (the R049 pid was still up — `start-review-vm.sh light` printed
"Owned review instance still running: 95488" and returned without launching):
`date 2026-04-02` → `view week` → `resize 760x540` → `openItem titleContains "Long review"` →
`nativeRecord r050-narrow` (16 frames, **all 760x540**). Then `escape` → `resize 1100x692` → `openItem` the
**same fixture** → `nativeRecord r050-wide` (13 frames). Same-fixture A/B, so content cannot confound it.

**Card fill bbox** (flood-fill over the neutral (245,245,245) fill): 760x540 → x 211–548, y 227–412
(**338×186**); 1100x692 → x 381–718, y 253–438 (**338×186**).

**Content bands, card-relative** (rel x = ink left − fill left; rel y = ink top − fill top):

| band | rel x | rel y | ink run narrow | ink run wide |
|---|---|---|---|---|
| title, 2 lines h38 | 13 | 18 | 224–528 | 394–698 |
| date · 11:00 – 13:00 | 13 | 69 | 224–424 (200) | 394–594 (200) |
| location | 14 | 95 | 225–331 (106) | 395–501 (106) |
| notes | 14 | 121 | 225–497 (272) | 395–667 (272) |
| 编辑 label | 277 | 151 | 488–511 (23) | 658–681 (23) |

Identical offsets and identical ink-run lengths ⇒ no reflow, no shrink, no clip. Card fully inside 760x540
(210px backdrop each side, 128px below). Top-edge material **byte-identical**: −4/−3/−2/−1 =
(236,236,236) (210,210,210) (204,204,204) (175,175,175), then fill (245,245,245). The left/right edge profiles
differ only because the popover sits over a blue grid chip at narrow and over white at wide — backdrop, not
material.

### Judgment
**P01 narrow leg = PASS.** The popover is the **counter-example to 仍差 #3**: the dialog form collapses at
760x540 because it is a layout-driven flex region, while the popover's card is
`EventDetailsPopover.qml:57 width: 340 + 2*shadowInset` (window-size-independent) with content-driven height
and a notes `Layout.maximumHeight: 120` ScrollView (`:171-174`). **#3 stays open for the dialogs only — do not
generalise it to overlays.**

### Cross-fixture false alarm, resolved
R046's baseline `p01-long-popover.png` is h**134** while today's event popover is h**186**. The 52px is
**content, not compression**: a 2x side-by-side (`_r050-cmp.png`) shows that asset is the *task* popover
"A deliberately long task title to inspect elision" — time only, **no location row, no notes row**. Do not read
that difference as a regression.

### Recorded side-observations
- **`resize` does land** (all 16 narrow frames genuinely 760x540) but **`captureClient` returns the stale
  pre-resize buffer** ⇒ after any `resize`, capture with `nativeRecord`.
- **Harness `openItem(null)` vertical centring does not reproduce at 760x540**: card top 227 with a 186-tall card
  ⇒ centre 320 vs window centre 270. At 1100x692 it is exact (253 + 93 = 346 = 692/2). R046 already ruled
  harness-driven popover *position* unjudgeable; recorded, **not a defect**.
- **The ✕ `closeButton` sits 20px inside the card's right edge at both window sizes** (528 vs fill right 548;
  698 vs 718) — a size-invariant invariant, usable as a locator.
- **A live review instance is reusable across rounds**; `live-app.pid` holds the pid and it answers harness
  commands. R050 used no restart at all.

### Not verified this round
The **dark** 760x540 leg (P01's dark leg is PASS at 1100x692, R047) — carried to R051 as Next round #1.


---

## R051 — P01 dark narrow leg PASS ⇒ P01 CLOSED (2 themes × 2 window sizes) (2026-10-16)

**Atomic step:** R050's Next round #1 — the 760x540 **dark** popover. Measurement + judgment only, **no product
code touched, no build**.

The live instance was **light** (`/proc/95488/environ` → `KOS_APPEARANCE=light`), so it was killed and
`./start-review-vm.sh dark` cold-started (pid 98047, dark confirmed from `/proc`). Method copied from R050
exactly: `date 2026-04-02` → `view week` → `resize 760x540` → `openItem titleContains "Long review"` →
`nativeRecord r051-narrow-dark` (15 frames); `escape` → `resize 1100x692` → `openItem` the **same fixture** →
`nativeRecord r051-wide-dark` (14 frames). Same-fixture A/B.

### Steadiness
Every follow-up frame is **byte-identical** to frame 0000 in both series (`ImageChops.difference` bbox `None`,
14/14 and 13/13) ⇒ the popover is fully static over 1.5 s: no reflow, no shake, no animation.

### Measurement

| window | dark fill bbox | w | h |
|---|---|---|---|
| 760x540 | x 210–549, y 226–413 | **340** | **188** |
| 1100x692 | x 380–719, y 252–438 | **340** | **187** |

Card-relative content bands — **identical offsets and identical ink lengths in both legs**:

| band | rel x | rel y | ink run narrow | ink run wide |
|---|---|---|---|---|
| title, 2 lines h38 | 14 | 19 | 14–318 (305) | 14–318 (305) |
| date · 11:00 – 13:00 | 14 | 70 | 14–214 (201) | 14–214 (201) |
| location | 15 | 96 | 15–121 (107) | 15–121 (107) |
| notes | 15 | 122 | 15–288 (274) | 15–288 (274) |
| 编辑 label | 278 | 148 | 278–325 (48) | 278–325 (48) |

Top-edge material **byte-identical**: y0−1 border (43,43,43) → y0−2/−3 shadow ramp (16,16,16)/(17,17,17) →
y0 fill (38,38,38). Dark baseline re-confirmed against R047: fill (38,38,38) ✓, border 43≈42 ✓, title ink
(242,242,242) ✓, secondary ink (164,164,164) ✓. Card is **exactly horizontally centred** in both windows
(gaps 210/210, 380/380).

### The apparent difference, resolved
The wide frame showed one extra ink band at rel y 179–185. Probed directly: it exists at **only rel x 1,2,5,6 and
333–338** — the card's own **rounded corners + border** over a **blue-tinted backdrop** (that row is pure fill at
card centre-x in *both* frames). Narrow's corner neighbourhood sits over neutral dimmed grid and stays under the
ink threshold. **Backdrop, not material.** Same class of false alarm R050 hit.

### Status dot — a size-invariant invariant (and a correction)
Measured by masking the region left of the title (rel x 10–30, y 19–57): the dot is **10×10 at rel x 14–23,
y 31–40** in narrow dark, wide dark **and** narrow light (light reads 13–22 / 30–39, the same place under R050's
±1px border convention). Peak colour **(48,140,198)** = the accent blue.
**R047's recorded "(57,196,135) 10×10 green dot" does NOT reproduce** — a scan of both full dark frames found
**0 pixels** within ±30 of (57,196,135). Geometry unchanged; the colour record was wrong, or came from a
different fixture. Logged in state.md 外推待确认 so no one reads a future green dot as a regression.

### Judgment
**P01 dark narrow leg = PASS**, therefore **P01 is CLOSED**: PASS at 1100x692 light (R046), 1100x692 dark (R047),
760x540 light (R050), 760x540 dark (R051). The popover does not compress in either theme at either window size;
it is the standing counter-example to 仍差 #3, which stays a **dialog-only** finding.

### Recorded side-observations
- **Check the live instance's theme before trusting it.** `start-review-vm.sh` only prints "Owned review instance
  still running" and `exit 1`s — it will silently leave a *light* instance in place for a *dark* round.
  `/proc/<pid>/environ` `KOS_APPEARANCE` is the ground truth.
- **`nativeRecord` frames land in the app's CWD**, which is wherever `start-review-vm.sh` was invoked from — the
  repo root when launched from there, `tmp/ui-acceptance/calendar/` when launched from there.
- **Harness `openItem(NULL)` vertical centring still does not reproduce at 760x540 in dark** (top 226 + h188 ⇒
  centre 320 vs 270); at 1100x692 it is exact in both themes. Harness-driven position remains unjudgeable.
- **R041's "+7px right of window centre" does not reproduce on the popover** in either theme or size.

### Next round #1
Fix **仍差 #3** — the editor dialogs compress instead of scrolling at 760x540 (`CalendarTaskEditorDialog.qml:32-33`
plus the event-editor sibling). It is the top-ranked 仍差 item that needs no ruling, and a real
comment-vs-behaviour defect.

---

# R052 — **仍差 #3 RETIRED: the editor dialogs do NOT compress — the "39px notes viewport" is a CLIP line** (2026-10-16)

## 本轮 (R052)
Atomic step: R051's Next round #1 = fix 仍差 #3 ("the editor dialogs compress instead of scrolling at 760x540").
Outcome: **the premise was false.** The dialogs never compress; the recorded "notes viewport 96 → 39px" is the
*visible* fraction of a 96px box that the scroll viewport clips. Retired with static + live evidence. One candidate
fix for the *real* defect it exposed was implemented, measured, found to regress the wide size, and **reverted** —
so this round ships **no net code change** (`git diff` empty).

### Method (dark, pid 101088; every frame below is from the *reverted* build)
`date 2026-04-02` → `view day` → `openItem {kind:"todo",titleContains:"Green planning"}` →
`pointerObject detailsEdit` move/press/release → `resize 760x540` → `nativeRecord r052-rev` (8 frames) → 2×
`windowWheel {x:350,y:300,angleY:-600}` → `nativeRecord r052-revscroll` (7 frames). All coordinates are 1:1
(760×540 frame, dpr 1).

### A. The static proof that nothing is compressed (pre-existing frames, no app needed)
`r041-narrow-0021.png` (760x540, dark, pre-change) at x=350, fill `(38,38,38)`:

- Notes box fill `(34,39,47)` runs **y 326 → 360 with NO bottom border**, then y=361 is card fill. The wide frame
  `r041-taskdialog-dark.png` ends the same box with a *rounded* bottom: the fill-run narrows
  335→334→333→332→331→329→325→321 px over y 444→452 and the border rows are 453–455.
- **A 38px-tall box would show that rounded bottom.** It doesn't, and the fill stays the **full 335px wide**
  (x 220–554, the same 335px as the wide frame's x 390–724) right down to the last drawn row. ⇒ the box is
  **clipped**, not resized.
- The boxes *above* are untouched: field bands h **31/31/31** at both sizes, at card-relative y
  107/147/188 (narrow) vs 110/150/194 (wide) — a uniform ~3px probe offset, not a squeeze.

### B. The live proof that the form scrolls, and by how much
| | narrow, unscrolled `r052-rev-0007` | after 2× wheel-down `r052-revscroll-0006` | wide `r041-taskdialog-dark` |
|---|---|---|---|
| field bands (x=350) | 151..181, 191..221, 232..262 | **132..162, 173..203** (title row gone above) | 187..217, 227..257, 271..294 |
| hint text | 276..284 | 217..225 | 311..320 |
| **notes box** | **323..360 (clipped)** | **264..360 = h97** | 359..455 = h97 |
| 保存 / 取消 / 删除任务 | 396..427 / 433..464 / 470..501 | **identical, unmoved** | 516..547 / 553..584 / 590..621 |

**The translation is rigid: every element moves by exactly −59px, field heights are unchanged (31/31), and the
footer does not move at all.** The notes box is **96px (97 with borders) in the narrow and wide windows alike**;
after scrolling it is drawn in full, rounded bottom border included, and its bottom lands on the viewport floor
because it is the last form element.

**The 59px scroll range equals the 59px that was hidden** (unscrolled box would end at 419 if drawn; the clip is at
360). One number, two independent derivations ⇒ self-consistent.

**So `CalendarTaskEditorDialog.qml:32-33` ("only the form above it scrolls") is TRUE of the layout.** 仍差 #3,
R040's "73px" and R041's "corrected 39px" are all readings of the *clip line* at y=360/361, never of the box.

### C. The one real defect the phantom pointed at — measured, fixed, and REVERTED
`CalendarTaskEditorDialog.qml:182-184` claims the form scrolls "by wheel … and the attached scrollbar". It does
not: the **event editor** attaches a P03 overlay bar (`EventEditorDialog.qml:268-281`, `AsNeeded`, 6px, no track,
`blackSeed` @ 0.40/0.30) whose own comment calls the symptom "a clipped form reads as scrollable instead of as a
rendering fault" — the **task** editor never got it. At 760x540 that leaves a 59px-scrollable form with zero
affordance.

I ported that block verbatim into `CalendarTaskEditorDialog.qml` (build clean, block at :189-203). Result:

- **Narrow: it works.** A `(23,23,23)` thumb = `blackSeed` @0.40 over the card appears at **x 553–555** and travels
  the track: y 126..311 at `contentY=0` → y 173..358 at max scroll. Track ≈ y 124..361 (237px), thumb ≈ 185px ⇒
  `size` ≈ 0.78 ⇒ contentHeight ≈ 303, scroll range ≈ 66 ≈ the 59 measured in B. **Renders 3px wide, not the
  declared 6.**
- **Wide: it REGRESSES.** `r052-wide-0006.png` (1100x692) carries a **permanent dark line at x 723–725
  = (23,23,23)** spanning y 162..477. The pre-change frame is uniform there: a cross-section of
  `r041-taskdialog-dark.png` at y=300 from x 718 to 736 is **constant `(38,38,38)`**, and its dark-column scan
  finds nothing inside the card (only x=748, the dimmed backdrop). `AsNeeded` does not hide it because the wide
  form is *also* scrollable — by a few px — so `size` < 1 and a near-full-length thumb is painted. That is an
  unrequested new mark on a **D11-PASS** surface.

**Reverted** (`git checkout -- apps/calendar/qml/CalendarTaskEditorDialog.qml`, `git diff` empty, rebuilt). Re-shot
the reverted build: the x=548..562 cross-section at y=300 is `(38,38,38)` again (no thumb), the unscrolled profile
reproduces the R041 numbers **exactly** (151/191/232/276/323..360/396/433/470), and the scroll test in B still
holds. Nothing of mine survives in the tree.

### Judgment
**仍差 #3 = RETIRED (not "fixed"): it described a phantom.** The dialogs' real 760x540 behaviour is *correct*
comment and correct layout — a 96px notes viewport, wheel-scrollable 59px. Replaced in the top-8 by the genuine
sibling-divergence this round uncovered (new #3), which **does** need care: the P03 bar is right for the narrow
case and wrong for the wide one, and the event editor carries the same latent mark.

### Evidence
`docs/ui-calendar/round-052-dialog-scroll.png` — 2× side-by-side, unscrolled (box clipped at y360) vs after 2×
wheel-down (box whole, 96px, 264..360). Frames: `r052-rev-0007.png`, `r052-revscroll-0006.png`,
`r052-narrow-0013.png` / `r052-scroll-0007.png` (with-bar build), `r052-wide-0006.png` (with-bar build),
`r041-narrow-0021.png` / `r041-taskdialog-dark.png` (pre-change).


## R053 (2026-10-16) — 仍差 #3 FIXED: task-editor overlay scrollbar, policy gated on real scrollability
- **Code** (commit `1b31367`): `apps/calendar/qml/CalendarTaskEditorDialog.qml` — ported the event editor's P03
  overlay `ScrollBar` into `contentItem` (`editorScroll`), with
  `policy: editorScroll.contentHeight > editorScroll.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff`,
  and `objectName: "editorScroll"` (probe hook; no visual/behavioural effect).
- **R052 Next#1(a) premise (wide form overflows) is FALSE**: `contentHeight` = 295 at *both* window sizes; the wide
  notes box is drawn complete (bottom border 453–455) ending ~45px above the footer (500) ⇒ nothing to remove.
- **A verbatim P03 port reproduces R052's wide regression** ⇒ `ScrollBar.AsNeeded` does not hide an attached bar
  whose Flickable fits. Gating the *policy* (not a `visible:` binding, which the engine's own setVisible breaks) fixes it.
- **Evidence (dark, pid 103791)**: narrow thumb `(23,23,23)` x 553–555, y 127..311 → 173..357 after 2× wheel
  (`x350 y300 angleY-600`) — it travels; wide x 716–732 @y300 all `(38,38,38)`, and exactly 1 `(23,23,23)` pixel in
  x 708–742 × y 90–650 (at 739,635 = the card's bottom-right AA corner). Form geometry = R041 baseline at both sizes
  (narrow 151/191/232/276..285/323..clip 361/footer 396·433·470; wide 187/227/268/359..455/516·553·590).
- **New mechanism notes** (see state.md 外推): the bar is centred on the Flickable's right edge and `clip: true` cuts
  its outer half ⇒ a **6px bar renders 3px**; a wheel probe is only evidence of "not scrollable" when its point is on
  a non-control item (Labels/spacing) — at wide y=300 lands on the due-date *field*, which eats the wheel; and a
  `nativeRecord` started within ~1s of a `resize` still carries the *old* window size in its frames (wait ~3s).
- **Archived out of state.md in R053** (still valid; no round owns them):
  - `captureClient` key is `path`, not `file`; **`capture` is NOT a harness action**.
  - The α probe is the instrument of record: backdrop per point from the last *undimmed* frame ×0.8;
    α = (m − backdrop)/(247 − backdrop). Pill left edge is only a ±0.14 cross-check.
  - Frame pacing degrades under capture load, reported timing does not. Use the discrete dim step
    (204↔255 at (1040,400) light) as the t0 anchor.
  - Month-view geometry (R049, 1100x692 light): row pitch 60.7; day-number ink tops y 165/226/287/348/408; chip fill
    band y 183→200 (h18); chip x-runs (6,148)(164,305)(321,463)(636,778)(794,935) ⇒ pitch 157.5, chip w 143, gap 16;
    selected-day rect x 473→626 (w154). Month chip fill is per-list tinted, NOT the week chip's uniform (216,234,245);
    the month grid draws no cell borders.
  - Week-grid geometry: vertical rules at x = 52, 201.5, 351.5, 501.5, 651.5, 801.5, 951.5 (pitch 149.5) at
    1100x692; chips inset 3px ⇒ 144 wide; chip fill light (216,234,245); hour-row pitch ≈ 54px.
  - `openItem` centres the popover, it does NOT anchor it (`Main.qml:1314` → `openAt(null)`); harness-driven popover
    *position* is unjudgeable — and R041's "+7px right of centre" does not reproduce (R050/R051: exact centring).
  - Harness `openItem(NULL)` vertical centring does not reproduce at 760x540 (card top 226 + h188 ⇒ centre 320 vs
    window centre 270); at 1100x692 it is exact in both themes.
  - `ElideRight` here emits a literal `…`, not a fade — three dots at pitch 3px. Confirm by column min-lum profile.
  - `flatPrimary`/`lightLabel`/`secondary` are opt-in, default false ⇒ the rest of the app still shows the old
    outlined secondary. Not a regression.

## R054 — 仍差 #3 RETIRED as a phantom: the event editor's bar is a REAL scrollbar (range 38px) — measurement only
**Step:** R053's Next#1 = "fix the event editor's twin defect: measure, then gate". No code written: the measurement
refuted the premise.

**Method (dark, pid 103791, 2 batches — resize alone + 3.5s settle, then open/probe):**
`escape` → `date 2026-04-02` → `view day` → `resize 1100x692` → `openItem {kind:"event", titleContains:"Design review"}`
(14:30) → `pointerObject detailsEdit` move/press/release → `scrollInfo` → `nativeRecord r054-wide 800/200` (3 frames).

**Result — the new instrument, `scrollInfo`** (dumps every Flickable with contentHeight/height + sceneX/sceneY, and it
reaches the dialog Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot, because the *event* editor's
Flickable has no `objectName`):
```
QQuickFlickable clip:true contentHeight:418 contentWidth:340 contentY:0 height:380 interactive:false
                 width:340 sceneX:387.6 sceneY:131.4 visible:true  parent EventEditorDialog
```
⇒ **range 38px — the event form does NOT fit at 1100x692.** Companion rows from the same dump: the task editor's
Flickable is `contentHeight 295, height 520, objectName "editorScroll", visible false` (closed) ⇒ R053's gate there is
correct; the notes viewport is `h96 @ sceneY 453.4`; the footer button ListView is `sceneY 531.4, h 40`.

**Pixel cross-check (r054-wide-0002.png, 1100x692, dpr 1):** dark column at **x 724–725** (values 20–29 over the
`(38,38,38)` card) = the inner half of a 6px bar centred on the Flickable's right edge 727.6. Thumb column at x=724
runs **y 133..475**, i.e. 342px of a 380px track = **0.90**, matching the expected `380/418 = 0.909`. R053's stray
mark had ratio 1.00 on range 0 — so this is a *proportional* scrollbar, not an artifact. (The column is broken into
1–2px runs where the form's field rows cross it; a partial column is still the bar.)
The same frame read by eye: the 备注 box is cut at the clip line (y 511) **without a bottom border** — the form is
genuinely clipped, exactly the state P03's overlay bar is meant to signal.

**Why the gate would be wrong here:** card height is capped at 620 ⇒ Flickable 380; `contentHeight` 418 is
width-independent (dialog width `min(380, w-48)`; at 760x540 the card is 508 ⇒ Flickable 268 ⇒ overflow 150). So
`contentHeight > height` is true at **every** window size — the gated policy would be a permanent no-op.
`EventEditorDialog.qml:271` stays a bare `policy: ScrollBar.AsNeeded`. **0 build→screenshot loops.**

**Wasted probe (recorded so it isn't repeated):** the first drive attempt used R053's literal title with
`kind:"event"` — `[UI] Gold review 2026-04-02` is a **VTODO** (DUE 12:00), not a VEVENT. The 2026-04-02 VEVENTs are
Morning planning 08:00 / Short appointment 10:15 / Long review… 11:00 / Design review 14:30 / Evening session 18:00.

**Evidence:** `r054-event-wide.png`, `r054-clip-bar2x.png`, `r054-bar3x.png` (mirrored in `docs/ui-calendar/`, LEDGER R054).

---

### Archived out of state.md in R054 (R053's 本轮 block — kept for the record)
R053 fixed 仍差 #3 by porting the event editor's P03 overlay `ScrollBar` into
`CalendarTaskEditorDialog.qml`'s `contentItem`/`editorScroll` (`commit 1b31367`) and **gating its policy**:
`policy: editorScroll.contentHeight > editorScroll.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff` — the verbatim
port reproduced R052's wide regression, because (claimed) a bare `AsNeeded` never hides an attached bar. It also added
`objectName: "editorScroll"` to that Flickable as a probe hook. Verified narrow (thumb travels) + wide (no bar) with
form geometry unchanged from R041. It then filed the event editor's *unmeasured* twin as new #3 — **which R054 has now
refuted**, and whose root-cause story `scrollInfo` leaves unverified (see state.md 外推).

---

### R054 archive — 外推待确认 block (superseded by R055, kept verbatim)

`captureClient` key, `ElideRight`, month chip tinting, `flatPrimary` opt-ins. Read them there, don't re-derive.)*
- **`scrollInfo` is THE instrument for dialog geometry — it settles what three other probes could not.**
  `{action:"scrollInfo"}` dumps every Flickable/ScrollView/TextArea with `contentHeight/height/contentY/width/
  clip/visible/interactive` plus `sceneX/sceneY`, and it reaches the dialog Flickables that `objectNamed`,
  `inspectGeometry` and `regionPosition` **cannot** (only the *task* editor has `objectName:"editorScroll"`).
  Output = one `[UIReview] scrollInfo [...]` line per call in `live-runtime-vm.log`. **Use it before any pixel probe
  on a dialog.** Do not conclude "the bar is stray" from pixels alone — check `contentHeight > height` first.
- **Event editor dialog geometry at 1100x692 (dark, measured R054):** card fill `(38,38,38)`; Flickable
  `sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418 (range 38)`, `interactive:false`, `clip:true`;
  bar renders at **x 724–725**, thumb **y 133..475**; notes viewport h 96 at sceneY 453.4; footer button ListView
  sceneY 531.4 h 40. The card reserves **~240px** of chrome (vs the task editor's ~100px) — that is why the event
  form overflows where the task form does not. `contentHeight 418` is width-independent (**dialog width =
  `min(380, w-48)`**; at 760x540 the card is 508 ⇒ Flickable 268 ⇒ overflow grows to 150).
- **R053's root-cause story is unverified by the new instrument.** Its gate is *correct by construction*, but the
  premise behind it ("a bare `AsNeeded` never hides an attached bar") rests on a pixel sighting on a form that
  `scrollInfo` now reports as **295 ≤ 520 at 1100x692**. Re-derive with `scrollInfo` before quoting the mechanism
  to justify anything else (the gate itself is safe — it is exactly the wheel handler's predicate).
- **The attached bar is centred on the Flickable's right edge and `clip: true` cuts its outer half ⇒ a 6px bar renders
  3px.** At 760x540 it sits at x 553–555; at 1100x692 at x 723–725. **A dark `(23,23,23)` column there is a bar, NOT a
  border** (field borders read *lighter* than the card: `(65,66,67)`). A **partial** column (broken by the field
  rows' edges) is still the bar.
- **Task-dialog form: `contentHeight` = 295 at 760x540 and 1100x692; the Flickable's visible bottom (the clip line) is
  y 360/361 at 760x540 ⇒ height 236 ⇒ range 59.** At 1100x692 the Flickable is 520 ⇒ not scrollable, so R053's gate
  correctly hides its bar. The 96px notes viewport, the 4 rows (h 31/31/31) and the stacked footer never change with
  window size.
- **Unscrolled baselines (dark, x=350 narrow / x=500 wide): narrow 151 / 191 / 232 / hint 276..285 / notes 323..clip 361
  / footer 396·433·470; wide 187 / 227 / 268 / notes 359..455 / footer 516·553·590.** Compare against these before
  calling anything a regression.
- **A wheel probe is only evidence of "not scrollable" if its point is on a non-control item.** Labels and layout
  spacing propagate the wheel to the Flickable's `NoButton` MouseArea and scroll it; a `KosTextField`/ComboBox under
  the point eats it. **Proven point: `windowWheel x350 y300 angleY:-600` at 760x540** (the "Notes" label row). At
  1100x692 that same y lands on the due-date **field** — use a Label row (e.g. y≈315, the hint) instead.
- **`resize` needs ~3s to settle, and its frames lag one resize**: a `nativeRecord` started inside ~1s of a `resize`
  still carries the **old** window size. **Resize in its own batch, `sleep 3`, then record.** (R054 did this — batch
  `a` = escape/date/view/resize+3.5s, batch `b` = open+click+probe.)
- **`regionPosition`/`inspectGeometry` cannot reach a dialog Flickable that has no `objectName`** — they returned
  `[UIReview] region unavailable` three times in R053. `scrollInfo` (class-based) is the workaround. `regionPosition`
  works on `scheduleViewport`-style names reachable from `window.contentItem`.
- **The dialog's Flickable** (task editor, measured): top ≈ dialogTop + 83.5; event editor top = sceneY 131.4 with the
  card top ≈ 36. At 760x540 the task card is ~9px lower than `anchors.centerIn` would put it — unexplained, don't
  build on centring.
- **A fresh enter needs an app restart** after `escape` (the day-view selection is not restored).
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`); wrapping it in
  `timeout 180` kills the app. A reverted/rebuilt binary requires a **kill+relaunch** (the running process keeps the
  old binary). Kill the pid **read from `live-app.pid`**, never `pkill -f 'kos-calendar'` (exit 144).
- **`nativeRecord` frames land in the app's CWD** = wherever `start-review-vm.sh` was invoked (here
  `tmp/ui-acceptance/calendar/`). `nativeRecord` = `{action,prefix,duration,interval}` → `<prefix>-NNNN.png`;
  **frame counts vary — glob the prefix, never assume an index.**
- **Harness shapes:** `windowWheel` = `{action,x,y,angleY}`; `resize` = `{width,height}`; `openItem` =
  `{kind,titleContains}`; `view` = `{view:"month"|"week"|"day"}`; `date` = `{date:"YYYY-MM-DD"}`; `pointerObject`
  needs THREE commands (`move`,`press`,`release`); `scrollInfo` takes no args. Fields are FLAT.
- **`review-command.py` is not executable here — call it as `python3 review-command.py '<json>'`, and it accepts a
  LIST of commands** (one call can drive a whole sequence, 0.6s apart). A drive script needs its own sleeps; the
  helper only guarantees 0.6s between commands.
- **In-place write only** to `command.json` (atomic replace trips the QML dir watcher). Poll is `interval:100`.
- **Fixtures on 2026-04-02:** VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title 11:00** / **Design review 14:30** / Evening session 18:00. VTODOs (kind `"todo"`) =
  `[UI] Green planning 2026-04-02` (09:00), `[UI] Gold review 2026-04-02` (12:00), `[UI] Red review 2026-04-02` (16:00),
  `A deliberately long task title to inspect elision` (11:00), `[R019 LONG TASK] …` (11:00). **"Gold review" is a
  TODO — do not pass it as `kind:"event"`.** Always send `date` first, own batch.
  `openItem` → popover; the **Dialog** needs `pointerObject detailsEdit` move/press/release.
- **The task dialog's footer is fixed** (only the form above it scrolls) — Delete can never scroll out of reach.
- **Light theme**: the notes field is indistinguishable from the card fill (#F7F7F7 vs (248,248,249)) — locate a light
  field box by its **border** (222,224,226) only. The popover's fill is `#F5F5F5` light / `#262626` dark — the editor
  dialogs use `#F7F7F7` light / `#262626` dark. Accent measured (48,140,198) in both themes; `defaultAccentSeed` is #3478f6.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders as **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline).
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in
  and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first). `state.md`/`rounds.md` can never be
  committed — expected, not a failure. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.**

---

## R056 (2026-10-16) — D08 light leg + two new anomalies

**Step:** R055's Next #1. Light leg only. No code change, 0 build→screenshot loops. 28 Bash calls (budget 25, over).

**Drive:** kill pid 103791 (from `live-app.pid`) → `nohup ./start-review-vm.sh light & disown` → new pid 107851 after ~12s.
Then ONE list: `escape`, `date 2026-04-02`, `view day`, `openItem {kind:"event",titleContains:"Design review"}`,
`pointerObject detailsEdit` move/press/release → then ONE list of 9: `nativeRecord r056-lit 9000/250`,
`pointer 557,587` move, press, `pointer 500,400` move (drag out), release, `pointer 557,550` move, press, drag out,
release. 36 frames.

**Frame→state (from the log's per-frame `elapsedMs`, x=450):**
| ms | 保存 (primary) | 取消 (secondary) | state |
|---|---|---|---|
| 251, 501 | 48,140,198 | 227,229,230 · **no ring** | at open |
| 739, 988 | 48,140,198 | **215,216,217** + 1px gray edge 209,211,215 | 取消 hover |
| 1225 | 48,140,198 | 210,211,212 (transition) | 取消 press landing |
| 1488, 1739 | 48,140,198 | **204,205,206** + ring 120,179,216 | 取消 pressed |
| 1988…2988 | 48,140,198 | 227,229,230 **+ ring** | 取消 normal, still focused |
| 3239, 3489 | **69,152,204** | 227,229,230, no ring | 保存 hover (focus left 取消) |
| 3736, 3986 | **85,161,208** + ring | 227,229,230, no ring | 保存 pressed |
| 4202 | 69,152,203 (transition) | 227,229,230 | drag-out |
| 4486…5236 | **48,140,198 + ring** | 227,229,230 | 保存 normal, focused |

Box edges (light): 保存 547..578, 取消 584..615, 删除日程 621..650; pitch 37, gap 6, x 384..730.
Ring rows: **585,586** (top) and **613,614** (bottom) = 2px inside the box, identical to dark's geometry.

**Findings:** (1) three distinct fills on both kinds ⇒ light leg PASS; (2) ring = #78b3d8 = (120,179,216) =
`accent`@0.64 = light `focusRing` ⇒ D08 `focusRing` clause PASSES in light; (3) `buttonNeutral` base is ≈(251,252,254),
not the rendered card (247,247,247) — `mix(card,black,0.095)` predicts (224,224,224), measured (227,229,230); (4) hover
drops the ring exactly as in dark; (5) **#A: no ring on any button at a clean open in light** (main frames 251/501 +
an independent re-open `r056-open`, 11 frames) while R055 saw the ring on 取消 at open in dark; (6) **#B: the light
footer is 12px lower than R055's dark footer while the dialog geometry is identical** — the visible event-editor
Flickable reads `sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418`, R055's dark numbers exactly. R054's
"Save 546..577", retired by R055 as post-`resize` layout lag, is within 1px of this light reading ⇒ **that retirement
is suspect; the offset is probably theme, not lag.** Both #A and #B → R057 (dark, same method).

**Wasted work (now 外推):** (a) `nativeRecord 500ms/interval 500` → `frames:[]`, zero captured — `interval == duration`
loses the race to the stop timer; keep `interval ≤ duration/4`. (b) I inferred "is the dialog open?" from log greps
twice; one frame answers it, and a 4-step chain in a single list is cheaper than chaining calls.

**Evidence:** `docs/ui-calendar/r056-lit-{footer-normal,cancel-hover,cancel-press,cancel-focusring,save-hover,save-press,save-focusring}.png`
(2x crops of x 384..736 × y 528..662).

---

## R057 (2026-10-16) — dark footer re-measured: #A and #B both closed; R055's dark table and its R054 "resize lag" retirement RETRACTED — measurement only

Atomic step: R056's Next #1. No code change, 0 loops. 18 Bash calls.

Drive (dark, 1100x692, pid 107851 → **109482**): `runtimeInfo` (= dark, dpr 1, 1100x692) + `nativeRecord r057-dark2`
11000/250 + the 6-step open chain **in one 9-item list**, then a 5-item pointer list (`pointer 557,599` move+press,
`pointer 557,500` move+release, `pointer 557,562` move) → **44 frames**, elapsedMs 251..10982.

1px column scan at x=450 (dark, card (38,38,38)): 保存 **548..577** (48,140,198) normal / (69,152,204) hover;
取消 **585..614** (69,69,69) / (79,79,79) / (89,89,89); 删除日程 **622..651** (69,69,69) + red label. Pitch 37, gap 6.

**#B closed — no theme offset.** R056 light measured 547..578 / 584..615 / 621..650 ⇒ the themes are ≤1px apart.
R055's dark table (535..565 / 572..602 / 609..639) is exactly **13px higher**; re-scanning R055's own 28 frames gives
535..565 in all 28 (stable, so R055 read its frames faithfully), while its Flickable geometry equals R057's
(`sceneX 387.6, sceneY 131.4, w 340, h 380, contentHeight 418`) and R057's `contentY` is 0 with range 0..38.
Leading explanation: **R055's Flickable was at `contentY ≈ 13`.** Not light-vs-dark, not resize lag ⇒ **R054's
"Save 546..577" was right and R055's retirement of it is retracted.**

**#A closed — and it is a MATCH, not a defect.** At the clean open (frame 4501 ms; 0016@4262 is mid-fade; frames
0017–0029 = 4.5–7.5 s byte-identical) 保存 is flat (48,140,198) over 548..577 and 取消 flat (69,69,69) over 585..614 — no
ring on either. The reference macOS alert at rest (`_ref-alert-crop.png`) shows no ring on Primary or Secondary either
⇒ no-ring-at-open is correct. **R055's "the ring sat on 取消 at open" does not reproduce and is retracted.**

**Ring (dark, pressed 取消):** 2px **#2d7397 = (45,115,159)** on rows 585 and 613, AA at 586 (52,111,147) / 614
(44,108,147) — box 585..614. Still present at 0040/0043 while 保存 is hovered ⇒ **ring follows the press and persists**,
same as light. **Hover 取消** = flat (79,79,79) over the full 585..614 (585 and 614 read (80,80,80)) ⇒ the ring is
covered by the hover fill, **no distinct 1px `borderHover` edge** — R055's "1px gray (81,81,81) borderHover" is a
1-unit AA read (substance holds, mechanism corrected).

**D08 verdict:** the event-editor footer **PASSES** its 三态 + `focusRing` clauses in both themes (fills exact; ring 2px
in the right colour, (120,179,216) light = accent@0.64, (45,115,159) dark = accent@0.76). What remains under D08 is
**coverage** (task-editor footer, a toolbar `KosButton`) and the never-exercised **`Esc 可关闭`** clause.

**Wasted work:** the first crop script fed a `glob` list into `Image.open` and died with
`IndexError: image index out of range`; the two column scans then disagreed 13px. Always assert `im.size` before
indexing, and prefer a single pass over all frames to a hand-picked one.

**Evidence:** `docs/ui-calendar/_r057-dark-{footer-open2x,cancel-press2x,cancel-ring-persist-save-hover2x}.png`.

---

## R055 (2026-10-16) — D08 dark leg (archived from state.md at R056)

Atomic step: R054's Next #1. Dark leg only. No code change, 0 loops. 24 Bash calls.

Drive (dark, 1100x692, pid 103791): `escape` → `date 2026-04-02` → `view day` → `openItem` (popover) →
`pointerObject detailsEdit` ×3 (dialog) → `nativeRecord r055-b3 7000/250` while `pointer {x:557,y:599}` move → press →
drag-out → release, then `pointer {x:557,y:562}` move. 28 frames.

1px column scan at x=450 (dark, card (38,38,38)): 保存 535..565 **(48,140,198)/(69,152,204)/(85,161,208)**;
取消 572..602 **(69,69,69)/(79,79,79)/(89,89,89)**; 删除日程 609..639 (69,69,69) + red label. Pitch 37, gap 6, x 384..730.
Ring = 2px (45,115,159) on rows 572,573 and 601,602 in the **normal and pressed** frames = `focusRing` dark
(accent@0.76 over the card). At open the ring sat on **取消**, not 保存. While hovered the ring is replaced by a 1px
gray `borderHover` (81,81,81) — a 1px gray edge on a hovered button proves `focused == false` while hovered.

Two wasted loops inside R055: drive1's press landed at ~6.1s inside a 6.2s recording (no pressed frame), and drive2
skipped `openItem` so no dialog opened. Both went to 外推.


---

# R058 — **D08 clause 3 `Esc 可关闭` PASSES on the event editor (2 legs): one `escape` closes it from a clean open (<= 250ms) and one `escape` also clears the editor-over-popover stack (a 2nd escape is a no-op). NEW: a LONE popover ignores `escape` — 2 tries over 9s, zero pixel change, and `EventDetailsPopover.qml:15/59/60` is `Popup` + `modal: false` + `CloseOnEscape` with NO `focus:` anywhere** (2026-10-16)

## 本轮 (R058)
Atomic step: R057's Next #1 = "verify D08 clause 3 `Esc 可关闭` on the dark event editor". Done. No code change,
**0 build->screenshot loops**. Dark 1100x692, pid **109482** (still the R057 process, "Design review" open on entry).

**Leg 1 - clean editor, no popover.** List = `nativeRecord r058-esc 6000/250` + `escape` -> **24 frames**.
Frames 0000-0001 (t 0-0.25s) = editor up (dim (55,55,55), save hovered (69,152,204)); **0002 (t 0.5s) = editor gone**;
0002-0023 byte-stable for 5.5s = day view, **no dim, no card, no popover**. => **PASS, and it is instant: the whole
teardown fits inside one 250ms sample (no exit animation is observable).**

**Leg 2 - editor opened ON TOP of the popover.** List = `nativeRecord r058-raw 10000/250` + raw `pointer` (672,401)
move/press/release + `escape` + `escape` -> **39 frames**. Popover up at 0000-0006 (fill (38,38,38), **no dim**);
**0007 (t~1.7s) = dialog**: dim (55,55,55) already at full while the card is still fading in ((34,39,47) at 450,300),
settled 0008; **`escape` at t~2.4s -> 0009** = dim already back to (94,94,94) (full off) while the card is ~95% faded
((31,32,32)); **0010+ = fully clean day view** (Gold-review chip (96,79,35) at y548), with the **2nd `escape`
(t~3.0s) changing nothing** (0010->0038 identical). => **One `escape` clears the whole stack; there is no "second
escape" case.** Caveat: the popover box 378..722 x 262..430 sits **entirely inside** the card
387.6..727.6 x 131.4..511.4, so pixels cannot say whether the 编辑 click had already dismissed the popover.
Bonus confirmation of the R057 canonical footer: in leg 2's crop 保存 spans screen y **545..577.5** (canonical 548..577, AA).

**Both legs re-confirm 仍差 #1 from both directions**: on ENTER the dim reaches full while the card is still mid-fade;
on EXIT the dim reaches full-off while the card is still ~95% opaque. The dim is un-animated, the card is not.

**NEW FINDING (P01 family, not D08) - a lone popover does not close on `escape`.** Leg-1's sibling run: popover up
with **no dialog**; `escape` at t~4.8s and again at t~5.4s -> **frames 0010->0046 identical for 9s**, the popover
survived both. Source: `EventDetailsPopover.qml:15 Popup`, `:59 modal: false`,
`:60 closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape`, and the file contains **no `focus:` / `Keys` /
`activeFocus` at all**. Non-modal + never takes focus => Escape lands on the day view's focus item, so Qt's
`CloseOnEscape` cannot fire. That is exactly the pattern observed: the same escape mechanism closed the **focused**
dialog (legs 1+2) and was inert against the **unfocused** popover. **Candidate defect; see Next #1.**

**HARNESS FINDING - `pointerObject detailsEdit` does NOT open the editor.** Popover up, move/press/release at
t 3.0/3.6/4.2s => **zero** frame change over the next 8s. A **raw `pointer` click at the same button's centre
(672,401 @1100x692)** opened the editor first try. R057's "detailsEdit resolves even with no popover open" is now
explained. `detailsEdit` = `EventDetailsPopover.qml:202`. **Use raw coordinates for popover buttons from now on.**

**Discipline: 11 Bash calls (budget 25), 4 image reads, ~10 min.** Two dead ends, both now in 外推: (a) run 2's
`pointerObject` click was a silent no-op, which cost that run's two escapes their meaning - a *null* frame diff on a
click must be treated as a suspect instrument, not as evidence; (b) reading frames at 3 sample pixels could not tell
week from day - **diff bboxes first, sample pixels second.**

Evidence (mirrored to `docs/ui-calendar/`): `_r058-esc-leg1-2x.png` (editor -> gone),
`_r058-esc-leg2-2x.png` (editor over popover -> clean day view).

---

# R059 (2026-10-16) — popover-Esc RULED: NOT a spec failure; `CloseOnEscape` is dead code

Atomic step: R058's Next #1 = "decide the popover-Esc finding by reading the harness's `escape` implementation".
**No code change, 0 build->screenshot loops, 0 image reads, 8 Bash calls (~4 min).**

**Step 1 - the instrument is real.** `harness/Main.qml:204-205` -> `pointerDriver.escape(window)` ->
`harness/ReviewInput/ReviewInput.cpp:97-105`: it builds `QKeyEvent(KeyPress/Release, Qt::Key_Escape, Qt::NoModifier)`
and `QCoreApplication::sendEvent(window, &press/&release)` to `QGuiApplication::focusWindow()`. That is a genuine key
event taking the normal QQuickWindow -> `activeFocusItem` route, **not** a "call `close()` on a specific dialog" shim.
Corroborated empirically in R058: the same mechanism closed the *focused* dialog (legs 1+2) and was inert against the
*unfocused* popover. => **R058's null result is trustworthy; the instrument is exonerated.**

**Step 2 - no spec clause requires the popover to close on Esc.**
- `spec.md:89` the section covers 弹框、tooltip、右键菜单、浮层, but the IDs are two separate families: `D01-D13` = 弹框,
  `O01-O09` = 浮层/tooltip/菜单.
- `spec.md:109` `D08 | ... Esc 可关闭` is a **D-row => 弹框-scoped**.
- `spec.md:102` `D01 | 弹框是独立圆角卡片浮在父窗口之上；父窗口整体变暗（scrim）` — the popover renders **no dim** (R058), so by
  the spec's own definition it is **not** a 弹框.
- `spec.md:120` `O08` names the **P01 详情浮层** as the 浮层 family; `O01-O09` contain **no Esc clause** (O03's "移开即消失"
  is mouse-out).
=> The observation is a **spec gap, not a failed clause**; **D08's Esc clause is unaffected and stays PASS (R058)**. No
spec.md edit — inventing a clause is the user's call.

**Step 3 - the actual defect is a dead flag with an in-repo fix idiom.** `EventDetailsPopover.qml:15 Popup`, `:59
modal: false`, `:60 closePolicy: ... | Popup.CloseOnEscape`, and no `focus:`/`Keys`/`activeFocus` in the file (R058).
Non-modal + never focused => `activeFocusItem` stays in the day view => the popup item's key handler never runs =>
`CloseOnEscape` is unreachable. The repo already documents exactly this: `Main.qml:1873-1875` — "L05: Escape always
reaches the open search, whichever item in this window holds focus — **the input's own key handler is not enough once
it has lost focus**" — and solves it with a window-level `Shortcut { sequence: "Escape"; enabled: ... }`
(`Main.qml:1876-1878`), same idiom as `apps/lockscreen/.../SessionMenu.qml:246-251`. `apps/calendar` has exactly **two**
Escape mechanisms and the popover uses neither.
=> **Ruling item, two 1-line options.** **A (recommended):** add
`Shortcut { sequence: "Escape"; enabled: root.visible; onActivated: root.close() }` to `EventDetailsPopover.qml` —
matches `Main.qml:1876-1878` and macOS. **B:** delete `| Popup.CloseOnEscape` from `:60` so the code stops advertising
behaviour it cannot deliver. **`focus: true` is the wrong fix** (steals focus from the day view, contradicts
`modal:false`). Suggested clause if the user wants it specced: `O10 | 浮层在可见时 Esc 可关闭（浮层不夺焦，用窗口级 Shortcut 实现）`.

**Discipline: 8 Bash calls (budget 25), 0 image reads, 0 build->screenshot loops, ~4 min.** This round has **no
screenshot**, so it claims **no visual PASS of anything** — its deliverable is retiring a candidate defect and
re-scoping it to a ruling, which prevents the loop from "fixing" behaviour the spec never asked for.

Next round #1 = the task-editor footer D08 leg (`CalendarTaskEditorDialog.qml:81-98`, dark), promoted because R058's #1
is now blocked on a ruling rather than on work.

---

# R060 (2026-10-16) — D08 task-editor footer, dark: PASS

Atomic step: R059's Next #1 = "the task-editor footer D08 leg (`CalendarTaskEditorDialog.qml:81-98`), dark".
**No code change, 3 image reads, ~11 min.**

**Open chain correction.** `date 2026-04-02` -> `view day` -> `openItem kind=todo titleContains="Green planning"`
opened the popover, but R058's raw click at (672,401) was a **silent no-op**: the todo popover card is shorter than
the event popover's, so 编辑 sits at **(673,375)**. Clicking there opened the task editor first try. => 编辑's y is
**record-dependent**; read it off the frame. (Diagnosed from `_r060-b-rest-0002.png`.)

**Geometry (dark, 1100x692, `contentY = 0`).** `editorScroll` = `387.6 / 160.2 / 340x320`, `contentHeight 295` =>
**not scrollable**, so this round's numbers carry no scroll ambiguity.

| button | y (outer) | h | x | fill @ rest |
|---|---|---|---|---|
| 保存 (primary) | 516..546 | 31 | 384..731 | accent (48,140,198) |
| 取消 (secondary) | 553..583 | 31 | 384..730 | buttonNeutral (69,69,69) |
| 删除任务 (destructive) | 590..620 | 31 | 384..730 | buttonNeutral (69,69,69), label peak ~(239,103,95) |

**pitch 37, gap 6, equal width.** The canonical event-editor set (548/585/622) is the same shape **32px lower**, the
only difference being the task dialog's shorter body => **D08 "equal width / same height / pitch 37 / gap 6" PASSES**.

**Tri-state, primary:** rest `accent` (48,140,198) -> hover `accentHover` (69,152,204) -> pressed `accentPressed`
(85,161,208). Hover band is **516..546, the same 31px** as rest => hover is a **pure flat fill swap, no edge token**
(R057 reproduced on a second surface).

**The focus ring, and a trap.** Pressed measures 517..545 (**29**, not 31) — **not** a scale animation. The missing
2 rows are the **ring**, drawn 1px inside the perimeter: y517 and y545 read **exactly (45,115,159)** = `accent`@0.76,
the documented dark `focusRing`. It appears on press and **persists after press -> drag-out -> release-outside** while
the fill reverts to `accent`. => D08 "焦点环可见" **PASSES**. **Rule: a 2px-thinner pressed band is the ring, not a shrink.**

**Secondary/destructive tri-state** (grey test excludes the bluish ring, hence 24 not 29): 取消 553..583 ->
hover (79,79,79) -> pressed (89,89,89); 删除任务 590..620 -> hover (79,79,79) -> pressed (89,89,89). Both match
`buttonNeutral` 69/79/89 verbatim; hover band again unchanged at 31px.

**Discipline: 21 Bash calls (budget 25), 3 image reads, ~11 min.** Only D08 surface left = a toolbar `KosButton`.

Evidence (mirrored to `docs/ui-calendar/`): `_r060-footer-strip-2x.png` (rest | hover | pressed | ring-after-dragout),
`_r060-task-editor-dark.png` (full task editor, dark).


---

# R061 — **D08 third and last surface (toolbar flat `KosButton` "添加", `Main.qml:2379`), dark: PASS.** Tri-state captured
on the month view's selected-day card. **The fills are `button`/`buttonHover`/`buttonPressed` (accent-tinted blue), NOT the
`buttonNeutral*` set R060 predicted** — the code is right and the prediction was wrong (`flat:` and `secondary:` are two
different branches). Focus ring `accent`@0.76 persists after release-outside. No ref counterpart exists. (2026-10-16)

## 本轮 (R061)
Atomic step: R060's Next #1 = "a toolbar `KosButton` (`Main.qml:2379`), the third and last uncovered D08 surface".
**No code change. 5 Bash calls for the drive/measure, 0 build→screenshot loops, 3 image reads ≈ 9 min.**

**1 — Instrument (new fact).** `pointer {target: …}` resolves through `controlNamed`, which matches on
`item.text === label` — i.e. the **rendered, translated** label. `target:"Add"` therefore found nothing and silently
logged `NaN NaN` (two dead captures), while **`target:"添加"` resolved instantly and logged the centre plus the live
`hover`/`down` state**: `move 添加 1047 554.5 hover true down false` → `press 添加 1047 554.5 hover true down true`.
⇒ For **any** `KosButton`, `pointer{target:"<label>"}` is a free geometry+state probe that `scrollInfo` cannot give.
Also: this app runs Chinese translations under the review locale — **use the on-screen label, not the source string**.

**2 — Geometry (dark, 1100x692, month view, card fill = (31,36,43) = `mix(windowRaised, accent, 0.035)`).**
Capsule box **x 1008..1086 (79 wide) × y 539..569 (31 tall)** — the 31 is `controlHeight` as rendered (not the spec's 34).

| state | fill @ x=1047 | band y | notes |
|---|---|---|---|
| rest | **transparent** | — | column reads pure card fill (31,36,43) y524–561 except glyph pixels |
| hover | **(35,60,81)** | 539..569 (31) | +1px `border` rim (71,78,87) top / (68,76,83) bottom; + inner highlight |
| pressed | **(36,67,92)** | 539..569 (31) | same rim reads (37,76,102) — it is being taken over by the ring |
| after release-outside | transparent again | 539..569 | ring only; interior (29,34,39) = card under the elevation-0.42 shadow |

**3 — The fills are the accent-tinted triple, and that is correct.** `KosButton.qml:53-65`: the `flat` branch returns
`"transparent"` **only** while `flat && !hovered && !down`; hovered/pressed then fall through to the *default* branch,
`buttonHover`/`buttonPressed` = `mix(button, accent, 0.13 / 0.21)` (`AppTheme.qml:98-99`). `buttonNeutral*`
(69/79/89) belongs to the **`secondary:` branch**. ⇒ **R060's "expect buttonNeutral 69/79/89" was a bad prediction;
code correct, expectation retracted.** The app deliberately keeps two neutral-ish idioms: `secondary` = neutral grey,
`flat` = accent tint.

**4 — Hover changes the *shape*, not just the fill.** `strokeWidth` (`KosButton.qml:69`) is 0 only while
`flat && !hovered && !activeFocus`, so a flat button **gains a 1px `border` stroke on hover** — a real difference from
`secondary`, which never gets an edge (R057). `showInnerHighlight` is `(!flat || hovered)` (line 80) ⇒ hover fill reads
**(45,69,89) at y540** (inside the top edge) vs **(35,60,81)** at the middle: the hover fill is **graded, not flat**.

**5 — Focus ring: `accent`@0.76 = (43,115,160)**, rows **y539-540 and y568-569**, and it **persists after
press→drag-out→release-outside** while the fill reverts to transparent — the ring is then the only drawn thing.
Exactly R060's shape, reproduced on a third surface. ⇒ **D08 三态 + 焦点环 PASSES on the last surface.**

**6 — The scale animation exists but is sub-pixel here.** `hoverScale` 1.012 / `pressScale` 0.968 with `motionFast`
(`KosButton.qml:27-32`): pressed height would be 31→30.0. So R060's 31→29 is **2 ring rows + ≤1px of scale**, which
neither contradicts nor is measured apart at this size. Do not read "no animation" into a 31px button.

**7 — No reference counterpart.** `macos-calendar.png`'s toolbar contains only the Week/Month/Year segmented control and
two **circular icon** buttons (spiral, search) — there is **no text button**, and the ref frame shows **no hover/press
state of any kind**. This surface is therefore a **token-conformance check, not a visual ref comparison**. Noted in
passing: the ref's toolbar buttons read **neutral**, while ours is **accent-tinted** — with no ref hover frame and no
spec clause, that is a note, not a defect (仍差 #5).

**Discipline: 21+ Bash calls (budget 25), 3 image reads, 0 build loops, ~9 min.** Deliverable = **D08 now fully covered
on all three surfaces** (event-editor footer R055–R057, task-editor footer R060, popover Esc R058/R059, toolbar flat
button R061). There is **no further unblocked visual work left in D08** — Next round is the rulings.
## R062 — P01 popover title leading tightened **22px → 20px** (1.47em → 1.33em at font 15) (2026-10-16)

**Atom:** 仍差 #6 (line pitch) — the last **unblocked, non-ruling** item. Code change = **2 properties** on
`detailsTitle` (`EventDetailsPopover.qml:115-118`): `lineHeightMode: Text.FixedHeight` + `lineHeight: 20`.

**Before** (dark, 1100x692, R019 todo popover; `_r062-popover-before.png`): the title is a repeated long string, so it
wraps to the full **3-line cap** and elides at line 3. Card **x381..718 (338w) × y290..573 (284h)**; cap-tops
**307 / 329 / 351 ⇒ pitch 22**.

**After** (`_r062-popover-after.png`, `_r062-popover-title-3x.png`): cap-tops **320 / 340 / 360 ⇒ pitch 20**; card h
**280**, i.e. exactly the predicted **−4 = 2 gaps × 2px**. 4–6 fully clean pixel rows remain between lines (no CJK ink
collision), the line-3 ellipsis survives, the colour dot and `×` stay centred, and the time (`2026年4月2日星期四 · 11:00`)
and notes lines below are untouched. Same 3-line cap, same elide, same `objectName` (harness probe intact).

**Why 20 and not 18.** There is **no ref anchor**: the ref is a month view + sidebar, all text single-line/elided, and it
contains **no popover at all** — so no ref-derivable pitch exists. The target is therefore the macOS **body ratio 1.33**
(20px at 15px), not R046's rougher "~1.2" (18px). **`FixedHeight` is deliberate, not laziness:** Qt's
`ProportionalHeight` is a multiple of the *font's own* line box, which here *is* the 1.47em bug — `lineHeight: 1.33`
proportionally would give 29px, not 20. (This is also why the in-repo `KosEmptyState.qml:49 lineHeight: 1.22` renders
*looser* than default, not tighter.) The app-wide form of this bug (`controlHeight` 31-vs-34) is **not** touched: one
Label, one surface.

**Observation, not a defect.** The harness-opened popover's y sits 11px lower on the new binary (centre 431.5 → 442.5 at
an unchanged 692 host). Popover *position* is a **documented harness artifact** (`openItem` → `openAt(null)` centres it),
and the two runs differ in binary, so the shift is not attributable to the change — the target pitch (22→20) and the card's
**Δheight (−4)** are both exact and independently predicted.

**Loop status: 仍差 #6 CLOSED. This was the last unblocked item.** Every other 仍差 entry (1 dim snap, 2 shadow magnitude,
3 popover-Esc, 4/E03-proportional-blocks, 7 `slice(0,2)`, 8 month-cell 1-chip cap) changes app-wide or user-visible
behaviour that **no spec clause decides** ⇒ the loop is **blocked pending rulings A–E**. No `DONE` (not all spec IDs pass).

## R063 — state.md 的"无事可做"前提被推翻：参考图是**周视图**，A/T/E/N/V 全族从未审过；**T01 判定 FAIL**（2026-10-17）

**Atom:** `T01 — "Hour pitch about 40 with half-hour at 20"`。纯测量/判定轮，**无代码改动**（与 R060/R061 同型）。
在**复用的**存活实例上驱动 1 次（resize+date+view+captureClient），读 1 张自截图、1 张参考图、1 张参考图裁剪，约
10 次 Bash ≈ 12 分钟。

**发现 1 — 循环其实没有堵死。** `rounds.md` 里对 `A01–A04 / T01–T03 / E01–E06 / N01/N02 / V01–V05 / S01 / S04 /
C05 / M04 / X01 / X02 / X04–X06` 的提及数为 **0**（逐 ID grep 验证），而 `spec.md` 里这 ~30 条全是 PENDING。
R062 那句 "no unblocked visual work left" 只对 `D`/`O` 族成立，被当成了整份合同的结论 —— 这是本轮纠正的主项。
审查这些条目**不需要任何 ruling**。

**发现 2 — `.loop/refs/macos-calendar.png` 是周视图，不是月视图。** state.md 的外推原文（"814x522 month view +
sidebar, all chips single-line/elided ... no popover"）**一半是错的**：侧栏对，主区其实是 **Sun 29 – Sat 4
（2026 年 4 月）的周视图**，含**全天事件带**、8 AM–7 PM 小时行、以及**红色 `9:41` 当前时刻线 + 时间槽红胶囊**。
它是 **1:1**（文字锐利；红绿灯圆点 12px = macOS 原生尺寸），所以像素对 814x522 窗口是**绝对值**，换算到我们的
1100x692 约乘 **1.35（宽）/1.33（高）**。**后果：**参考图**确实**锚定 `A01–A03`、`T01–T03`、`E01/E02`、`N01/N02`
（以及已 PASS 的 `W01–W03`）；它**不**锚定月视图（`V01–V05`）和任何浮层。此前所有"X 没有参考锚点"的结论都要拿
**这次**的读数重验。

**发现 3 — T01 FAIL。** 我们的小时高度实测 **53.5px**（时间槽标签中心 206/258/312/366/419/474/527/582/636/689，
差 52/54/54/53/52/53/52/54/53），来源是 **`apps/calendar/qml/CalendarScheduleView.qml:120`**：
`timelineScroll.contentItem.contentY = usefulStartHour() * 54` —— 一个**硬编码 54**，不是按高度推出来的。
- 合同 `spec.md:38` 写的是 **about 40 / half-hour 20** ⇒ 我们**超 35%**。
- 参考图实测：时间槽小时标签在 **193/220/247/274/301/328/355/382/409/436/463/490/517 ⇒ 间距 27**
  （红色 `9:41` 胶囊**顶掉了 10 AM 标签**，所以 10 AM 缺席 —— 这本身就是 N02 的一个参考证据）。
  27 × 1.33 ≈ **36**，27 × 1.35 ≈ **36.5** ⇒ 我们窗口下 **≈36–40**，与合同的 40 收敛。
- 半小时细分存在（27 = 54/2），两个主题一致 ⇒ 错的只是**单位**，不是结构。
- **未被 ruling 阻塞**：合同直接给了数字（≈40），不属于 A–E 那种"规格沉默的抛硬币"。

**证据：** `_r063-week.png`（暗色 1100x692，3月30–4月5，fixtures 在位）、`_r063-ref-wk-gutter3x.png`
（参考图时间槽/全天带/事件块 2x）。已复制进 `docs/ui-calendar/`。

**旁证（非缺陷，仅记录）：** 时间槽显示 `06:00…15:00`（本地化 24 小时制，右对齐）；`CalendarScheduleView.qml:427`
把当前时刻线按 `minutes/60` 比例放在小时格内、`:430` 限定只在"今天"那一列 ⇒ **N02 已实现但本轮测不到**
（今天是 10 月 17 日，不在 3月30–4月5 的 fixture 周内）。`:389` 仍是 `slice(0, 2)`（仍差 #7 未动）。
存活实例上 R019 浮层仍开着 —— R062 遗留的 harness 状态，无害。

**Loop status: 仍差 #6 之外新增仍差 #1（T01），且它是 UNBLOCKED 的。** 无 `DONE`（并非全部 spec ID 通过）。

## R064 — T01 hour pitch 54 -> 40 (PASS)

Atomic step: T01 "Hour pitch about 40 with half-hour at 20". Code change, one file, 4 edits.
1 build, 1 kill+relaunch (light), 1 drive, 1 full screenshot read, 2 crops, ~19 Bash calls, ~15 min.

Change, `apps/calendar/qml/CalendarScheduleView.qml`:
- new :49 `readonly property int hourHeight: 40` — the single source of truth.
- :124 `positionTimeline()` `usefulStartHour() * 54` -> `usefulStartHour() * root.hourHeight`.
- :357 hour-cell delegate `Layout.preferredHeight: 54` -> `root.hourHeight`.
- :402 timed-chip delegate `Layout.preferredHeight: 21` -> `Math.round(root.hourHeight * 21 / 54)` = 16.
  Cell inner height = 40 - (anchors.margins: 3)*2 = 34; two chips + spacing 2 must fit. A fixed 21 would
  have been silently squeezed by the ColumnLayout (Rectangle implicit min-height 0); 16*2+2 = 34 exactly.
- Untouched as instructed: gutter Label (font 9, topMargin -7, "0"+h+":00"), slice(0, 2), chip radius 5 and
  insets 3/5/4, the now-line `y: parent.height * ...` (already proportional), the fillHeight spacer.

Measured PASS. Gutter-label row-band scan (x 2..50, >=3 non-bg px, bg white):
centres 244.5/284.5/324.5/364.5/404.5/444.5/484.5/524.5/564.5/604.5/644.5 -> 10 consecutive diffs of exactly 40.0.
Corroborated independently by the harness log line: `contentHeight 960` = 24*40 and `contentY 280` = 7*40.
Ref measures 27 ref-px => ~36 for our window; the contract says ~40, so 40 was taken.
Visual: `_r064-grid2x.png` (06:00-12:00 at 2x, labels 80px apart = 40 actual, chips single-line, no squeeze,
no overlap) and `_r064-thu11-3x.png` (one chip in the 11:00 cell, ~15px tall, clean).
Scan caveat: x 0..60 spilled into the first day column and produced junk bands; x 2..50 was clean.

TOOLING DEFECT (found, NOT fixed). `review-command.py` writes the command dict verbatim, so
{"captureClient":{"path":"x.png"}} reaches the harness with no `action` key; `harness/Main.qml` dispatches
exclusively on the flat `command.action` (:122 :204 :208 :217 :221 :225 :230), so nested commands fall through
to the :249 `[UIReview] manual undefined ...` fallback and the capture silently no-ops (no file, no log line,
exit 0). Cost 4 calls to diagnose. Workaround used: write flattened {"action": k, **v, "sequence": prev+1} in
place. captureClient resolves a relative path against the app's CWD (task dir, verified via /proc/<pid>/cwd).

Still差 after this round (top): T02/T03 grid-line weight + 24h vs "8 AM"/"Noon" label form; A01 all-day band;
E01/E02 chip language; N02 now-line (needs the current week); V01-V05 month (no ref anchor).
Blocked on rulings A-E unchanged (D/O family only). Not DONE.

---

## R065 — T02 PASS: grid lines 1px + neutral, half-hour lines lighter (light & dark measured)
**Step:** T02 only (`CalendarScheduleView.qml`, 2 edits: new `gridLine`/`gridLineMinor` tokens at 51-58; the
hour-cell delegate's `border.width: 1` box at 383-415 replaced by four single-edge 1px `Rectangle`s).
**Defect:** the border box made neighbours stack ⇒ hour lines rendered **2px (223,225,228)**, interior
separators 2px, outer edges 1px, and there were **no half-hour lines at all**.
**Result:** light hour lines **(237,237,237)** 1px at y 205/245/285/325; half-hour **(244,244,244)** 1px at
225/265/305; separators 1px (237,237,237) at x 52/202/352/502. Dark hour **(59,59,59)** (identical to the old
`AppTheme.border` dark value — no regression), half **(43,43,43)**. Chips still paint above the lines; the
`MouseArea` click/double-click chain is intact (same Rectangle, lines declared after it).
**Scope guards:** `hourHeight` untouched; all-day band separator left on `AppTheme.border`; `AppTheme.qml`
untouched; T03 gutter label untouched.
**Ref caveat:** ref hour lines/separators are also 1px (237,237,237) but on a (249,249,249) field vs our
white 255 ⇒ our contrast 7.1% vs ref 4.8%. Ref half-hour lines are not measurable; "lighter" is T02-driven.
**Cost:** ~16 Bash calls, ~14 min, 1 build, 2 relaunch+capture circuits.

---

## R066 — T03 PASS (gutter hour label form)
**Atomic step:** T03 — "Time labels 10–11, right aligned 6–8 from grid, aligned with their actual hour tick".
**Code change**, one file (`apps/calendar/qml/CalendarScheduleView.qml`), Label moved 367-377 → 367-383, 3 edits
+ a 6-line comment. 1 build, 2 kill+relaunch+capture circuits (light, dark), ~16 Bash calls ≈ 12 min.

**Pre-round (measured off R065's `_r065-grid-light.png`, a free BEFORE baseline — no extra capture needed):**
font **9**, `anchors.horizontalCenter` in the 52px gutter ⇒ ink band x 15..36, right edge 36, grid line at x=52
⇒ **gap 16** (contract 6–8, so a real FAIL); cap band **7px**; band centres 245/285/325 already on the ticks.

**Ref read first** (`.loop/refs/macos-calendar.png`, crop x 190..252, y 180..340): the label is a **two-tone**
12-hour form — dark **(89,89,89)** digits with a **9 ref-px cap band centred exactly on the hour line**, plus a
**(176..193) light-grey `AM`/`PM` suffix 12 ref-px wide flush right**; the label is right-aligned on the *suffix's*
right edge, ink right edge 238 vs grid line 243 ⇒ **5 ref-px** gap. `Noon` carries no suffix and is 24 ref-px wide.

**The fix** (`CalendarScheduleView.qml:373-383`):
- `font.pixelSize: 9` → **11** (top of the 10–11 range; the ref's cap is 9 ref-px and our pitch is 40 vs the
  ref's 27, so we are already *under*-scaled — 11 is the closest the contract allows).
- `anchors.horizontalCenter: parent.horizontalCenter` → **`anchors.right: parent.right` + `rightMargin: 7`**.
  The gutter cell's `parent.right` **is** the gutter/day boundary = the grid's left edge line (the day columns
  draw their own left edge at that same x), so `rightMargin` reads directly against the grid line.
- `anchors.topMargin: -7` → **`-Math.round(implicitHeight / 2)`**. The CJK-capable font's line box is **~1.47em**,
  so a constant -7 only centres font 9. `implicitHeight` is text-derived ⇒ no binding loop with `topMargin`.
- The Label **stays anchored** (top + right), so it still cannot contribute to the cell's implicit height and the
  40px pitch is structurally safe. `text:` and `visible:` byte-identical.

**Measured PASS.** Light (scan x 3..49 — see the x=0-rim caveat below): ink bands **241..249 / 281..289 / 321..329**
(h **9**, was 7) at x **18..44**; centres **245.0 / 285.0 / 325.0** — *exactly* on the hour lines 245/285/325,
pitch **40** ⇒ T01 unregressed. Right ink edge 44 vs the grid line x=52 ⇒ **gap 8** (text box gap 7) — contract 6–8.
Dark: gutter field (30,30,30), **identical geometry** (241..249 / 281..289 / 321..329, centres 245/285/325,
x 17..44, gap 8) ⇒ no dark regression.
Crops: `r066-gutter-light-5x.png`, `r066-gutter-dark-5x.png`, `r066-ref-gutter-5x.png` (side-by-side
`_r066-cmp-5x.png` in tmp) — all copied to `docs/ui-calendar/`.

**Difference I can still see (recorded, NOT a T03 defect):** the ref's label is **12-hour and two-tone**
(hour + smaller lighter `AM`/`PM`); ours is single-size **24-hour `07:00`**. **No spec ID covers either** —
`sed -n '30,50p' spec.md` shows the T family is only T01 (pitch) / T02 (grid lines) / T03 (label form). Filed as
**ruling F** and as 仍差 #2. Also noted: at this scroll offset the topmost hour line lands **on** the grid
viewport's top edge so its label is half-clipped — a pre-existing scroll artifact, not a form defect.

**Two process notes.** (1) The window's leftmost column **x=0 is a 1px rim (224,224,224) light / (53,53,53) dark**;
a gutter scan starting at x<3 merges every text band into one — I burned one measurement on this. (2) Our text
renders with **subpixel (RGB) antialiasing**, so single-pixel glyph probes come back colour-fringed
((133,142,196) light / (141,142,118) dark) — never read a text colour off one pixel.

**Scope guards:** `hourHeight` (40) untouched; the `gridLine`/`gridLineMinor` Rectangles and the half-hour line
untouched; the all-day band separator left on `AppTheme.border` (that is 仍差 #1 / next round); chips untouched;
`AppTheme.qml` untouched.
**Cost:** ~16 Bash calls, ~12 min, 1 build, 2 relaunch+capture circuits.

---

## R067 — all-day band bottom separator 1px → **2px (217,217,217)**; T04 local token `allDaySeparator`.

**Atomic step:** standing 仍差 #1. **Code change**, one file, 2 edits. 1 build, 2 capture circuits (light, dark),
~22 Bash calls ≈ 13 min.

**Change — `apps/calendar/qml/CalendarScheduleView.qml`:**
- New local token at `:59-64` (after `gridLineMinor`): `allDaySeparator` = light **`#D9D9D9`** /
  dark **`Qt.rgba(1,1,1,0.24)`**. Local on purpose — `AppTheme.border` is app-wide, blue-tinted, and shared with
  cards/fields/buttons (the same argument R065 used for `gridLine`/`gridLineMinor`).
- The band's bottom separator Rectangle `:323-327` (was 316-320): `Layout.preferredHeight: 1` → **`2`**,
  `color: AppTheme.border` → **`color: root.allDaySeparator`**.
- The *other* 1px `AppTheme.border` Rectangle in the same `ColumnLayout` — the one **above** the all-day band
  (`:240-243`) — left **byte-identical**. Only the bottom boundary was in scope.

**Ref re-measured first (this was the round's gate).** `macos-calendar.png` y=**183 AND 184 both (217,217,217)**,
y=182 (234,234,234) a partial AA edge ⇒ **2px**. The run spans **x 192..812** = 621 px across a 620px main region:
it starts at the **gutter's own left edge** and runs to the right rim, crossing *under the gutter* rather than
stopping at the grid line x=243. The ref's hour lines are 1px ≈237 (R065) ⇒ **217 is a deliberate strength step**,
not a separate rule. Our `Layout.fillWidth: true` sibling reproduces the span exactly.

**Measured PASS.** Light (field pure white): **y=204 and y=205 both exactly (217,217,217)** = 2px, spanning
**x 0..1099** (whole main region incl. the gutter). The **first hour line is the *next* row, y=206 (237,237,237),
1px** — R065's adjacent-rows caveat respected, they did **not** merge into one band. Half-hour y=226 (244,244,244).
Dark (field (30,30,30)): y=204/205 **(84,84,84)**, y=206 **(59,59,59)**, y=226 **(43,43,43)**. **Identical geometry
in both themes (204/205/206)** ⇒ no layout shift; the separator is a `ColumnLayout` sibling of the `ScrollView`, so
+1px only shortened the grid viewport by 1px. **Pitch intact:** 206 → 226 = 20 = `hourHeight`/2 ⇒ T01 unregressed.
Crops `r067-alldaysep-light-2x.png` / `r067-alldaysep-dark-2x.png` → `docs/ui-calendar/`.

**Our full y-map for this view** (1100x692 light, `view week` + `date 2026-04-02`): title text 94-105 → 1px
(224,224,224) at **118** → day-header text 133-141 → 1px `AppTheme.border` (223,225,228) at **155** (the rect
*above* the band) → all-day chips 168-188 → **2px `allDaySeparator` at 204/205** → first hour line 206.

**Dark token derivation — the one unreferenced number.** Light sep `#D9D9D9` = black@0.149 over white; light hour
line `#EDEDED` = black@0.0706 ⇒ ratio **2.11×**. R065's dark hour line = white@0.13 ≈ 1.85× its own light 0.0706
(dark-theme visibility compensation). 0.149 × 1.85 ≈ 0.275 → I took the conservative **0.24**. Measured: 84 vs 59
= **Δ25 on the 30..255 field = 11.1% of range**, vs light's Δ20 = 7.8% — marginally stronger in dark but the same
ordering. **No dark reference exists**; if one ever appears, re-derive. (dark hour→half = 59→43.)

**One wasted scan window (record me).** My first light scan covered **y 90..200** and so only found the 1px
(223,225,228) at **y=155** — the separator *above* the band, not the one I changed (y=204). **Establish the y-map
before claiming a target row.** The 6x side-by-side composite also came out misaligned and was discarded in favour
of the numeric bands.

**Subagent note:** `code-writer` is **not registered in this session** (available: claude, Explore, general-purpose,
Plan, statusline-setup). For a two-constant edit I made the changes directly instead of spending the round on agent
plumbing. **The loop's identity split (tester vs implementer) was not exercised this round.**

**Scope guards:** `hourHeight` (40), `gridLine`/`gridLineMinor`, every grid Rectangle, the gutter `Label`, the
all-day band's `min 28 / row 18 / gap 2` + `Layout.preferredHeight: 18` (`:289`), the upper separator, the chips,
and `AppTheme.qml` — all untouched.

---

### state.md trim log (R067)
Two long blocks were cut from state.md's 外推 section this round and live here instead:
- **R065 grid-line tokens in full** — see the R065 entry above; the surviving one-liner is
  "`AppTheme.border` is NOT the grid line any more; `allDaySeparator` is NOT the grid line either."
- **R063 ref fact-sheet detail in full** — see the R063 entry above; the ref numbers that matter day-to-day are
  kept in state.md as a compact fact sheet.
Nothing else was dropped; `AppTheme.border` still legitimately owns the separator *above* the all-day band (`:240-243`).

---

## R068 — measurement only: the ref's separator ABOVE the all-day band is 1px, not 2px. (2026-10-17)

**Atomic step:** standing Next-round #1 — "close the separator story". **Zero source edits, zero builds.**
~16 Bash calls / ≈6 min. Evidence: `docs/ui-calendar/r068-ref-allday-band-5x.png`.

**The discrimination method (reusable).** A hairline is "2px" only if it has **two full-value rows plus a
partial AA partner on one side**. Ref bottom separator: y=182 **(233..236)** partial → y=183 **217** → y=184
**217** ⇒ 2px. Ref top boundary: y=123 **(254,254,254)** → y=124 **242** → y=125 **(244/249)** ⇒ **1px**, the
"partner" rows are the white above and the band tint below, not AA of the line. **Do not count a row that
belongs to a neighbouring surface.** Row-mean alone cannot tell them apart — dump exact RGB at several x.

**Numbers.** Ref y=124 = (242,242,242), min 229 / max 242 / mean 242.0 over x 244..812 (229s = the 6 column
separators). Run starts at the gutter's left edge: x=194…246 all 242, x=186/190 = 236 (sidebar). Ref hour
lines re-confirmed 1px (237,237,237) at y=220/221, x=260.

**The finding that matters — a weight INVERSION.** Ref, lightest→heaviest: top boundary **242** < hour lines
**237** < bottom separator **217** (2px). Ours: top boundary **223,225,228** > our hour lines **237**. So our
top boundary is our heaviest rule and the ref's is its lightest. **Width (1px) and span (fillWidth, the whole
window incl. gutter) are both already correct** — only the weight is wrong. Deliberately not fixed this round.

**A01 data (recorded, no code change).** The ref's all-day band is a **tinted section**: weekday ≈249, weekend
≈244; the hour grid below is **white 255 weekday / 249 Sun+Sat** (y=210/216). Band rows in col 1 (bg 244):
chip fill **126..142 / 144..161 / 163..180** ⇒ **h ≈17, pitch ≈18.5, gap ≈1**; first row **2px** under the
y=124 line, last row **1px** above y=183. Chip **x 244..323** in a column bounded 243/324 ⇒ **inset ≈1**,
**radius ≈6**. Scaled (×1.33 h / ×1.35 w): h **≈22.6**, pitch **≈24.6**, gap **≈1.3**, inset **≈1.35**,
radius **≈8**, band content **≈77**. Ours: min 28 / row 18 / gap 2 / inset 2–3 ⇒ rows ~20% short, inset ~2×.

**Ref fact, new:** the ref grid field is **not uniformly 249** — weekday columns are **255 white**; only the
**weekend columns (Sun, Sat)** are 249 in the hour grid, and the all-day band adds its own 249 tint (244 on
weekends). Our week runs Mon–Sun, so our weekend columns are Sat/Sun. **No spec ID.**

**Method cost paid this round (avoid next time):** a `max(px) < 252` horizontal run-scan is useless for chip
edges in this ref — the weekday band background (249) and the weekend background (244) are themselves
"non-white", so every run comes back as the whole column. Use a **per-column background reference** and a
difference threshold, and confirm edges with an exact value dump.

## R069 — the inverted weight above the all-day band: FIXED (242,242,242 light / 39,39,39 dark)
**Atomic step:** Next-round #1 from R068. New local token `sectionRule` at `CalendarScheduleView.qml:66-71`
(light `#F2F2F2`, dark `white@0.04`) + `:249` `AppTheme.border` → `root.sectionRule`. That was the file's **only**
remaining `AppTheme.border` consumer, so nothing else in this view moved. 1px and `fillWidth` untouched.

**Light, row-mean x 0..1099:** 154/156 = 255 white; **155 = (242,242,242) — exact target**; 204/205 = 217
(2px, unchanged); 206 = 237 (unchanged); 226 = 244 (unchanged). Single-pixel dump at x=600/700/800/900 identical.
**Dark:** 155 = **39** (=30+225×0.04, the derivation held); 206 ≈59; 226 = 43; 204/205 = 84 (white@0.24, 2px).
**Ordering now matches the ref in both themes** (ref 242 < 237 < 217; ours light 242<237<217, dark 39<59<84).

**Eyes:** crop `r069-ref-vs-ours-3x.png` (ref band over ours, 3×) — our top rule now reads as faint as the ref's,
the heavy rule is only at the band's bottom. The same crop re-exposes the untouched A01/E01 gap: our all-day chips
are blue-filled pills, the ref's are neutral light-grey with a coloured left stripe.

**Environment:** the `code-writer` subagent is **not registered** in this session (`Agent` returned
"Agent type 'code-writer' not found"; available: claude, Explore, general-purpose, Plan, statusline-setup). The
edit was 2 lines and was made directly. This is the **standing gap** already recorded in R058's family — do not
retry it each round; either use `general-purpose` or edit directly.

## R070 (2026-10-17) — the "band tint" premise was wrong; the weekend column tint shipped instead

**Atomic step chosen:** the standing Next-round #1, "give the all-day band its section tint".

**What happened:** the premise did not survive measurement, and the round's main output is the correction plus
the ref-anchored thing the premise was reaching for.

**The falsification.** R068 had recorded the ref band as a "tinted section (249 weekday / 244 weekend)". That came
from a single-row sample. This round profiled the two *empty* ref columns vertically, y=124..185:

- Tue (x=440): `124=242, 125=249, 126..181=255, 182=236, 183/184=217, 185=249`
- Sat (x=770): `124=242, 125=244, 126..181=249, 182=236, 183/184=217, 185=249`

So the band interior on a **weekday** column is **255** — plain white, exactly like the hour grid below it.
In the hour grid (y=500) Sat/Sun read **249** and weekdays read **255**. The 249 is therefore the **weekend
column's field colour, identical in the band and in the grid**, and there is **no band-specific tint at all**.
`y=125` is not a fill row: it is the **half-strength row of the 242 top boundary** — 242 blended over white gives
249, over the weekend's 249 gives 244, which is exactly what the two columns read. R068's "249/244 band tint" was
that artefact. The day-header row is not tinted either (weekend 254 vs weekday 255 — below noise).

**The change** (`apps/calendar/qml/CalendarScheduleView.qml`, one file):

1. new `weekendField` token — light `#F9F9F9` (249,249,249), dark `Qt.rgba(1,1,1,0.03)` — and
   `isWeekendColumn(column)` reading `dateForColumn(column).getDay()` ∈ {0,6}. Deliberately **date-driven, not
   position-driven**: our week starts Monday, so our weekend is the *last two* columns, where the reference's
   Sunday-start week puts them first and last.
2. a `Rectangle { anchors.fill: parent }` declared **first** in the all-day band's `allDayColumn` Item, so it
   stacks below the chips and below the column separators.
3. the same Rectangle declared **first** in the `hourCell` delegate, so the grid agrees with the band.
4. the grid one is guarded with `hourCell.columnIndex > 0`: column 0 is the gutter and `dateForColumn(-1)` is the
   *previous* Sunday — unguarded, it would have tinted the whole gutter column.

**Measured (light, our 1100x692 capture).** Row 180 (inside the band): weekday x=600/700 = **(255,255,255)**;
weekend x=880/900/1050 = **(249,249,249)**. Row 400 (empty hour grid): the same split. Row-180 histogram over
x 0..1099 = **298 px at 249**, which is the two weekend columns (2 × 149.7 = 299.4) to the pixel. All four
structural rules re-verified untouched on the tinted column x=1050: **155 = 242, 204/205 = 217 (2px), 206 = 237**
— the tint rectangle sits behind them. The day-header row is unchanged.

**Eyes** (`docs/ui-calendar/r070-weekend-tint-light.png`): 周六 4 / 周日 5 now read as a single section running from
the top rule to the window floor, and the header row above them stays white. The all-day band's left edge no
longer looks like a cut-off rectangle.

**Not done:** the dark leg. `weekendField` dark is *derived* (`white@0.03` on the 30,30,30 field ≈ 37), not
measured — that is next round's single job, with an explicit warning not to accept a value that reads as nothing.

**Cost:** ~26 Bash calls, ~9 min — over the 25-call budget. Cause: the falsification needed five measurement
passes on the reference before the per-column vertical profile (the decisive idiom) was reached. Recorded in
state.md so the next per-column question starts with a vertical profile.

---

## R071 — the dark leg of the weekend tint: measured, exact, visible. No code change.

**Atomic step:** R070's standing Next-round #1 — "measure `weekendField` in the dark theme; verify, do not assume."
A **measurement-only** round. The derived token survived contact: nothing to fix, so nothing was edited.

**Drive.** Killed the light app by the pid in `live-app.pid` (127529), `start-review-vm.sh dark` backgrounded,
new pid **128304** after ~16s, then one flat 4-command list in a single `review-command.py` invocation —
`resize 1100x692` + `view week` + `date 2026-04-02` + `captureClient r071-dark.png`. Success line as documented.
*R069's md5 caveat earned its keep a second time: the dark PNG is **3050463 bytes**, byte-identical in **size** to
R070's light one, but `md5sum` 66eb6ad3… vs afc56d02… — a size comparison would have called this capture stale.*

**Method.** R070's decisive idiom reused verbatim: a full-width **row run-scan** to fix the column map, then a
**vertical profile** on the columns of interest. The row scan was cheaper than expected — one row in the empty
grid (y=400) returns the entire column structure in a single call.

**Column map (row 400, dark).** x=0 = 1px rim **(53,53,53)**; gutter x 1..51 = **30**; 1px separators at
**x=52/202/352/502/652/802** ⇒ **pitch 150**, 7 columns of 149: Mon 53..201, Tue 203..351, Wed 353..501,
Thu 503..651, Fri 653..801, **Sat 803..951**, **Sun 953..1099**. Matches `dayColumnWidth` ≈ 149.7 and R070's
Mon-start order (weekend = last two).

**The three specified checks, all PASS.**

1. **Weekday column stays (30,30,30).** Fri x=700: band interior y=156..203 = 30, grid y=400 = 30.
2. **Weekend reads the derived value in BOTH regions.** Sat x=880 and Sun x=1050: band y=156..203 =
   **(37,37,37)** *and* grid y=400 = **(37,37,37)**. The derivation `white@0.03` over (30,30,30) =
   30 + 0.03×225 = **36.75 → 37** — the token is correct and the band/grid agreement proves the tint, not a
   chip, is what is being read.
3. **The rules hold on the tinted column.** y=155 = **(39,39,39)** (`sectionRule`, 0.04×225 = 9 over 30) and
   y=204/205 = **(84,84,84)** (`allDaySeparator`, 0.24×225 = 54 over 30) — **identical to a weekday column**.
   Neither rule is affected by the tint: the section rule is drawn at `ColumnLayout` level above the band's
   own rects, and the separator is a sibling *between* the band and the `ScrollView`, so no tint rect reaches
   under either.

**Exclusions, measured not assumed.** Gutter (band row y=180, x 1..54) = **30**. Day-header row (y 119..154 on a
weekend column) = **30**, and a full-width scan at y=130 is **30 across** ⇒ the header row is not tinted, matching
the reference's 254-vs-255. The `hourCell` tint rect's `columnIndex > 0` guard does its job.

**The one asymmetry found — recorded as a fact, not filed as a defect.** The dark `gridLine` token is
**translucent** `white@0.13`, so it composites with whatever field is beneath it: over 30 it renders **59**, over
the tint 37 it renders 37 + 0.13×218 = **65.3 → 65**. Measured **y=206 = 59 on Fri, 65 on Sat/Sun**. The light
token is the **opaque** `#EDEDED` = 237, which is why R070 measured 237 on *both* columns: **light is
layering-invariant, dark is not.** This is the honest consequence of a translucent rule over a lighter field, and
the reference has **no dark theme** to arbitrate it; Δ6/255 = 2.4% on a 1px line is not a form defect. Same cause
one pixel over: the shared separator at **x=802** reads **(65,65,65)** rather than 59 — the Sat cell's fill
reaches one pixel left, *under* the boundary line. Written down so a later round does not "discover" either as a
bug.

**Eyes** (`docs/ui-calendar/r071-weekend-tint-dark.png`): 周六 4 / 周日 5 read as one continuous lighter section
from the `sectionRule` at the top of the all-day band down to the window floor; the header row above and the
gutter to the left stay dark. Δ7 across a 149px-wide, ~500px-tall field is subtle but unambiguous at 100%.
**The tint is not "nothing"** — the explicit failure mode this round was told to reject.

**Cost:** ~11 Bash calls, ~5 min. Comfortably inside budget; the row-run-scan-first idiom is what made it cheap.

---

## R071 ARCHIVE — full `外推待确认` block as it stood at end of R070

## 外推待确认 (do NOT assume)
*(R053's 9 older items are archived to rounds.md — read them there, don't re-derive. R065/R067/R068 moved their
full grid-token and ref-fact-sheet blocks to rounds.md; the live ones are below.)*
- **THE WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070, replaces R068's tint note).** Ref: weekday columns
  **255** in the all-day band **and** in the hour grid; **Sat/Sun 249** in both. The band has **no tint of its own**; the day-header
  row is not tinted (254 vs 255 ⇒ noise). `y=125` is the **half-strength row of the 242 boundary** (242 over white → 249,
  242 over the 249 tint → 244), not a fill. **Ours now:** `CalendarScheduleView.qml` `weekendField` (light `#F9F9F9`, dark
  `white@0.03` — *derived, unmeasured*) + `isWeekendColumn(column)` (getDay() ∈ {0,6}, **date-driven so it survives a
  Mon-start week**), consumed by **two** first-child background Rectangles: the band's `allDayColumn` Item and the `hourCell`
  delegate (**guarded `columnIndex > 0`** — `dateForColumn(-1)` is the previous Sunday and would tint the gutter).
  **Measured light:** row 180 and row 400 both 249 on Sat/Sun, 255 on weekdays; 298 of 1100 px at 249 on row 180.
- **FOUR LOCAL TOKENS NOW OWN THE GRID'S RULES (R065/R067/R069).** `CalendarScheduleView.qml:51-71`:
  `gridLine` (light `#EDEDED` / dark white@0.13), `gridLineMinor` (light `#F4F4F4` / dark white@0.06),
  `allDaySeparator` (light `#D9D9D9` / dark white@0.24), `sectionRule` (light `#F2F2F2` / dark white@0.04).
  **`AppTheme.border` now has ZERO consumers in this view** — do not reintroduce it; it is blue-tinted and app-wide.
  *Do not call `sectionRule` "the lightest rule in the view": `gridLineMinor` (244 light) is numerically lighter.*
  **The ref-anchored requirement is the ORDERING among the four structural rules, not the absolute minimum:**
  ref **242 (top boundary) < 237 (hour line) < 217 (band bottom, 2px)**; ours light **sectionRule 242 < gridLine 237
  < allDaySeparator 217**, dark **39 < 59 < 84**. `gridLineMinor` 244 is a **half-hour line** — a different role,
  T02-anchored, and sits outside that ordering; never fold it in. **R070: all three re-verified unchanged on a tinted
  column (x=1050): 155=242, 204/205=217, 206=237.**
- **THE ALL-DAY SEPARATOR IS 2px AND SPANS THE GUTTER (R067).** It is a `ColumnLayout` sibling of the `ScrollView`
  with `Layout.fillWidth: true`, so it runs the full window width — matching the ref, whose run starts at the gutter's left
  edge (ref x≈192) and stops at the right rim (x=812). **R068: the top boundary spans identically (ref y=124 reaches x=194).
  Do not "fix" either to start at the grid line. R069: the (242,242,242) row is uniform over x 0..1099.**
- **ONE LINE PER BOUNDARY (R065).** A cell must never draw both a top and a bottom edge, and never both a left and a
  right edge: adjacent edges land on the same pixel row/column and render as 2px. The right rim is drawn only by
  `columnIndex === root.dayCount`. **R067 corollary:** the separator (204/205) and the first hour line (206) are
  **adjacent rows** with different weights — never read them as one 2px+2px band. **R068:** our y=155 top boundary
  and the day-header text above it are *not* adjacent — there is real white between them.
- **Our schedule grid field is pure WHITE (255,255,255)** light / **(30,30,30)** dark — not the app's 247 card fill.
  **R070: the weekend columns are now 249 light** (the ref's own weekend value). The **gutter** stays 255 light — the tint is
  per *day* column only. **Do not quote "the ref's 249" as a field mismatch any more: the ref's weekday field is 255, the
  same as ours; only its weekend columns are 249, which we now match.**
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** `CalendarScheduleView.qml:373-383`: font 11,
  `anchors.right` + `rightMargin: 7`, vertical centring from `-Math.round(implicitHeight/2)`, **not** a tuned
  constant. Anchored on **top + right** ⇒ it cannot contribute to the cell's implicit height; unanchoring it
  vertically would inflate the 40px row and break the pitch. `parent.right` of the gutter cell **is** the grid's
  left edge line.
- **The window's leftmost column x=0 is a 1px rim (224,224,224) light / (53,53,53) dark** — a gutter scan must start
  at **x ≥ 3** or that column merges every text band into one. (R066, cost one wasted measurement.)
- **HARNESS COMMAND FORM IS FLAT (R064, hard-won).** `harness/Main.qml` matches `command.action` only
  (`:122 captureClient{path}`, `:204 escape`, `:208 resize{width,height}`, `:217 sidebar{expanded}`,
  `:221 view{view}`, `:225 date{date}`, `:230 openItem{kind,titleContains}`); a command with no `action`
  **silently hits the `:249` fallback** (`[UIReview] manual undefined …`) and does nothing. `review-command.py`
  takes a **flat** list/dict and bumps `sequence` itself, writing **in place** (never `os.replace`) — the QML dir
  watcher would reload and invalidate the state. `captureClient` writes a **relative** path against the **app's CWD**,
  which follows **your launch CWD** ⇒ **launch from the task dir**. Confirmed success line:
  `qml: [UIReview] native app client capture <name> true`. **R069/R070: the whole drive list
  (`resize`+`view`+`date`+`captureClient`) in ONE invocation works fine.**
- **`hourHeight` is THE pitch constant (R064).** `CalendarScheduleView.qml:49`; used for the scroll offset (`:124`)
  and the cell height (`:365`); chip height = `Math.round(root.hourHeight * 21 / 54)` = **16**. The half-hour line is
  `Math.round(parent.height / 2)` = **20**. Anything that hardcodes 40 or 16 again will drift.
- **REF FACT SHEET (R063, compacted).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026,
  Sun 29–Sat 4) + 243px sidebar + mini calendar. Day headers (text y108-116) → **all-day band (3 rows, y 124–184)**
  → hour grid 8 AM–8 PM. Gutter labels **193/220/247/274/301/328 = pitch 27**; the red `9:41` pill **replaces** the
  10 AM label. Now-line y=238 = 9 AM line + 0.683×27 (proportional, not snapped). **All-day band boundaries: TOP
  y=124 1px (242,242,242); BOTTOM y=183-184 2px (217,217,217)** (R068/R067); both span **x≈192..812**. **7 equal day
  columns, 1px separators at x=324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** Traffic-light dots
  **12px** ⇒ 1:1. **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ **36** for us (contract says 40 — 40
  was chosen). Hour lines and vertical separators are both **1px (237,237,237)**; half-hour lines are not
  measurable. In the band the column separators read **(244,244,244)** — lighter than in the hour grid. Gutter label
  (ref x 215..238, y 189..197): digit **(89,89,89)**, cap band **9 ref-px** centred on the hour line; `AM`/`PM`
  suffix **(176..193) 12 ref-px wide, flush right**; right ink edge 238 vs grid line 243 ⇒ **5 ref-px**. `Noon` has
  no suffix, 24 ref-px wide. **R070: the half-strength rows above/below the two boundaries read 249 (weekday) / 244
  (weekend) above and 236 + 249 below — they are AA of the boundary, not separate lines.**
- **REF ALL-DAY BAND AS A FORM (R068).** Rows **h ≈17, pitch ≈18.5, gap ≈1**, first row 2px under the top line, last row
  1px above the bottom line ⇒ band content **58 ref-px**. Chip **inset ≈1**, **radius ≈6** (rounded). Scaled ×1.33/×1.35:
  h ≈22.6, pitch ≈24.6, gap ≈1.3, inset ≈1.35, radius ≈8, content ≈77. **Ours (R069 re-measured on our own capture):
  min 28 / row 18 / gap 2 / inset 2–3 / radius 5.** (R070 changed none of these — the band's field colour only.)
- **REF EVENT CHIPS (R063, this is E01/E02's anchor).** Chip = **light desaturated same-hue fill + dark same-hue text
  + a 2–3px solid same-hue LEFT STRIPE** + small radius. Confirmed on `Portfolio…`/`Leadersh…`/`Presenta…` (red),
  `Choir…` (olive/yellow), `Morning…` (blue), `Palm Sun…` (pink/magenta stripe). **This contradicts our dark
  theme's solid-saturated-fill + white-text** ⇒ the E family's first question is whether our dark translation is
  legitimate. Not yet judged. *(Our timed chip is `radius: 5`, a 1px border, no left stripe. **R068:** the ref's
  all-day pill radius ≈6 on a 17px row ⇒ ≈0.35×height; ours is 5 on 16.)* **R070 addendum:** the ref's `FaceTi…` /
  `Buy pots` / `Status…` all-day chips are **near-white (248) with a coloured ring icon**, i.e. a *second* all-day chip
  style beside the saturated ones — do not read every ref all-day chip as saturated.
- **THE REF HAS NO POPOVER, NO MENU, NO TOOLTIP, NO HOVER FRAME.** The 弹框/浮层 section (`D`/`O`) is therefore
  HIG+token-anchored only, never pixel-anchored. Unchanged from R061/R062.
- **`lineHeight`: Qt's `ProportionalHeight` is a multiple of the *font's own* line box, not of `pixelSize` (R062).**
  With the app's CJK-capable stack that box is **1.47em** (22px at 15px), so `lineHeight: 1.2` *loosens*. For a
  **pixel** target use `Text.FixedHeight` + `lineHeight: <px>`. Measured valid pair: **FixedHeight 20 at font 15**
  in `EventDetailsPopover.qml:115-118`. **R066 corollary:** the same 1.47em box is why a size-tuned `topMargin` is
  unsafe — use `implicitHeight`.
- **`pointer{target:"<label>"}` is a free geometry + live-state probe for `KosButton`s (R061)** — matches
  `item.text === label`, so it needs the **rendered/translated** label (`"添加"`; a miss logs `NaN NaN` and the
  capture is a silent no-op). Log carries the resolved centre **and** `hover`/`down`. Needs the item `visible`
  (drive to **monthPage** for 添加). `scrollInfo` cannot see buttons; this can.
- **`flat:` and `secondary:` are different branch groups in `KosButton.qml:53-65`.** `flat` rest = `"transparent"`,
  hover/press = `buttonHover`/`buttonPressed` (accent tint) **and it gains a 1px `border` rim** (`:69`, `:80`; inner
  highlight = `!flat || hovered`). `secondary` = `buttonNeutral*` (neutral grey), never gets an edge.
  `AppTheme.qml:97-99` owns all three tokens.
- **The popover's 编辑 y depends on the RECORD (R060).** Event "Design review" ⇒ (672,401); todo "[UI] Green
  planning" ⇒ **(673,375)**. Card height is content-driven, so a *reused* y is a **silent no-op**. Read 编辑's
  centre off a frame first. **R062 caveat:** the popover y also differs 11px **between binaries** ⇒ never diff a y
  against another binary.
- **Opening the TASK editor (R060, verified):** `date 2026-04-02` → `view day` → `openItem kind=todo
  titleContains="Green planning"` → raw `pointer` click at **(673,375) @1100x692**. `pointerObject` needs THREE
  commands.
- **Pressed-button band arithmetic (R060): a 2px-thinner pressed band is the FOCUS RING**, drawn 1px inside the
  perimeter, exact `(43,115,160)`/`(45,115,159)` = `accent`@0.76 dark. `pressScale` 0.968 is ≤1px at height 31 —
  **never read "no animation" from a 31px band.**
- **Dark footer token values, measured verbatim (R060):** primary `accent` (48,140,198) / `accentHover` (69,152,204)
  / `accentPressed` (85,161,208); secondary+destructive `buttonNeutral` (69,69,69)/(79,79,79)/(89,89,89);
  destructive **label** peak ≈(239,103,95) on a neutral fill. Hover **never** changes the band height ⇒ no edge
  token. **Dark card fill = (31,36,43)**; **popover** dark = **(38,38,38)**; window = (30,30,30); flat-button
  hover/press = **(35,60,81)/(36,67,92)**; `border` dark rim ≈**(71,78,87)**. `windowRaised` is **not** a neutral
  grey. **R066/R067: the schedule field dark = (30,30,30)** and its leftmost rim = (53,53,53).
- **Esc semantics (R059): `escape` is a key event addressed to whoever holds `activeFocusItem`.** It closes a
  **focused** popup and does **nothing** to a `modal:false` popup that never takes focus. Ask *who has focus* first.
- **Spec family split (R059): `D01–D13` = 弹框 (has a scrim), `O01–O09` = 浮层/tooltip/menu.** P01's popover is a
  **浮层** (`spec.md:120` O08). A requirement written in a `D` row does **not** automatically bind the popover.
- **Dark event-editor footer at 1100x692, `contentY = 0`: 保存 548..577 / 取消 585..614 / 删除日程 622..651**,
  x 384..730, centre x ≈ 557, pitch 37, gap 6 (light ≤1px the same). The **task** editor is the same shape **32px
  higher** (516/553/590) — always say *which* editor a footer number belongs to.
- **`nativeRecord` with `interval == duration` captures ZERO frames** (R056). Keep `interval ≤ duration/4`; frames
  land at 0, interval, 2·interval…; the recorder is non-blocking so keep `duration` under the 0.6s command spacing.
- **Diff bounding boxes FIRST, sample pixels second** (R058): `ImageChops.difference(...).getbbox()` separates
  "nothing happened" (`None`) from "a view switch" (≈whole window) at no cost. **R061 caveat:** a *neighbouring*
  widget's hover state can inflate the bbox.
- **Row-band measurement idiom that has now worked eleven times (R046/R062–R070):** scan the target column (or row) for
  pixels that are **not** the background, threshold, group into bands, read the band **centre** (text rows) or
  **start** (cap-tops). A **row/column mean over a wide span** is the cheapest way to find horizontal lines when
  chips make single-column probing noisy. **Caveats:** keep the scan window strictly inside the intended region
  (R064 — and **R067: establish the y-map first, my window stopped 4px short of the target**); the all-day separator
  and the first hour line can be **adjacent rows** (204/205 vs 206 — different weights, don't merge, R065/R067);
  the x=0 rim column merges every band, start at x ≥ 3 (R066). **R068:** for edges inside the ref's *band*, the
  "background" is per-column and the field is 255 — a global `not-white` threshold returns whole columns.
  **R069: a row-mean over the FULL width (x 0..1099) is exact for a full-width rule.** **R070: the decisive idiom for a
  *per-column* property is a VERTICAL profile of one empty column (y=124..185) — a single-row sample of a chip-infested
  band gave a wrong answer for two rounds.**
- **A glob and a literal path in the same `for` list will crash the crop script** (R057): assert `im.size` first.
  **R067:** Pillow crops need **absolute** paths — a bare relative path breaks the moment the harness `cd`s you into
  the task dir.
- **The ring is press-driven, in BOTH themes:** nothing has a ring at a clean open; press a button and the ring
  appears 1–2px inset and **persists after release-outside**. On hover the ring is **covered by the hover fill**.
- **The reference macOS alert at rest shows NO focus ring** ⇒ "no ring at open" is the target, not a bug.
- **`focusRing`: light = `accent`@0.64 = (120,179,216); dark = `accent`@0.76 = (45,115,159)/(43,115,160).**
  `accent`(48,140,198) / `accentHover`(69,152,204) / `accentPressed`(85,161,208) are **identical in both themes**.
- **`scrollInfo` is THE instrument for dialog geometry** — one `[UIReview] scrollInfo [...]` line per call in
  `live-runtime-vm.log`, reaching Flickables that `objectNamed`/`inspectGeometry`/`regionPosition` cannot. Parse as
  JSON, filter `parent` + `visible:true`, and **take the last matching line**. It lists **Flickables/ScrollViews
  only — not `KosButton`s**.
- **The 4-step open chain and the 3-step click CAN go in ONE list**; the recording may be the **first** item.
  **`press` → `move` off the button → `release` outside** captures *pressed* without firing the click.
- **`start-review-vm.sh` blocks on `wait "$app_pid"` — background it** (`nohup … & disown`). A rebuilt binary
  requires a **kill+relaunch**; kill the pid **read from `live-app.pid`**, never `pkill`. ~12–14s before the new pid
  appears. Include `resize 1100x692` in the drive list. It starts in `--view week --date 2026-10-15`, so every drive
  list must re-send `view week` + `date 2026-04-02`. It loads `harness/Main.qml`, which imports
  `../../../..//apps/calendar/qml` **relative to the harness file** ⇒ the **source tree** is what renders, and a
  relaunch is required after every rebuild.
- **Fixtures on 2026-04-02** (live file = `profile/pim/calendar.ics`; the repo-root *`calendar-fixture.ics` is a
  stale copy with no VTODOs*): VEVENTs = Morning planning 08:00 / Short appointment 10:15 / **Long review with a
  deliberately lengthy title** 11:00 / **Design review** 14:30 / Evening session 18:00; plus a **`Multi-day review`**
  all-day strip spanning 3 days. VTODOs (kind `"todo"`): `[UI] Green planning` (09:00), `[UI] Gold review` (12:00),
  `[UI] Red review` (16:00), `A deliberately long task title to inspect elision` (11:00), **`[R019 LONG TASK]
  任务长标题与编辑表单检查`** (11:00 — a *repeated* long string; **the record for any wrapping-title test**).
  The week is **Mon 30 – Sun 5** (locale weeks start Monday, 7 columns, `dayColumnWidth` ≈ 149.7 at 1100x692).
  **R070: column order = Mon 30, Tue 31, Wed 1, Thu 2, Fri 3, Sat 4, Sun 5 ⇒ the tinted columns are the LAST TWO.**
- **Light theme**: the notes field is indistinguishable from the card fill — locate a light field box by its
  **border** only. Popover fill `#F5F5F5` / `#262626` dark; editor dialogs `#F7F7F7` light / `#262626` dark;
  event-editor card at x=450 renders (247,247,247) light / (38,38,38) dark. `defaultAccentSeed` #3478f6.
  **R066: our text renders with subpixel (RGB) antialiasing** — single-pixel probes of glyph cores come back
  colour-fringed (e.g. (133,142,196) light / (141,142,118) dark). **Never read a text colour from one pixel**; use
  a band's dominant/median over many pixels.
- **`motionFast`** = 120, **`motionNormal`** = 220 (`AppTheme.qml:174-175`), both 0 under `reduceMotion`.
  `controlHeight` renders **31px here, not the spec's 34**; the dim is `Overlay.modal`, **0.20 light / 0.42 dark**.
- **Save is deliberately NOT exercised** (isolated-profile discipline) — *pressed* is captured by
  press→drag-out→release-outside.
- **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots
  in (name them **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest
  first). `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the
  `Co-Authored-By: Claude Opus 5` trailer.** Note: a prepend Edit that uses only the previous round's heading as
  `old_string` **deletes that heading** — re-append it. **R069: two different PNGs can come out byte-identical in
  size — `md5sum` before you conclude a capture is stale.**


---

## R072 — A01 step 2: the all-day band's row geometry (row 18 -> 24, gap 2 -> 1, band 48 -> 80)
**Atomic step:** the standing Next-round #1 — the all-day band's ROW GEOMETRY only (row height + gap), ref-anchored, no spec ID.
**Ref measured 1:1 this round:** rows y126-143 / y145-162 / y164-181 => row **18**, gap **1**, pitch **19**; top rule y=124 (242,
1px); bottom separator y=183-184 (217, 2px); band total **60**. Our vertical factor vs the ref is **1.33** (40px hour pitch vs 27)
=> row **24**, gap **1**, band **80**. (Supersedes R068's h~17 / pitch~18.5.)
**Code (edited directly — `code-writer` is not registered):** `apps/calendar/qml/CalendarScheduleView.qml` gained four tokens next
to `hourHeight` — `allDayRowHeight: 24`, `allDayRowGap: 1`, `allDayBandRows: 3`, `allDayBandInset: 3` (step 3's target, kept at 3
this round) — and `allDayBandHeight` **derived** from them = 3*24 + 2*1 + 3*2 = **80**. The delegate now reads
`Layout.preferredHeight: root.allDayBandHeight` (was 48), the chip `Layout.preferredHeight: root.allDayRowHeight` (was 18), and
the `ColumnLayout` `spacing: root.allDayRowGap` (was 2).
**Fixture:** added two all-day VEVENTs on 2026-04-02 (`Design sync`, `Release notes`, UIDs `ui-review-r072-allday-a/b@isolated.local`)
to `tmp/ui-acceptance/calendar/profile/pim/calendar.ics`. Reason: `Multi-day review` alone gives **one** all-day row per column, so
the *gap* was unmeasurable. Thursday now carries 3 all-day items (`slice(0, 2)` renders 2).
**Capture 1 (r072-band-light.png, kept as r072-band-light-spread.png):** row height **24 ✓** but the layout betrayed us — profile at
x=577 read chip1 166-189, **gap 13**, chip2 203-226 with 7px above and 6px below. Diagnosis: a `ColumnLayout` taller than its
**items** does not leave the slack at the bottom; it distributes the surplus into its **spacings** (leading half-spacing / between /
trailing half-spacing) — 25px of surplus became 6.5 / 13 / 6.5. Items kept their preferred height (no `Layout.fillHeight`).
**Fix:** re-anchor the band's `ColumnLayout` to `anchors.top/left/right` + `height: implicitHeight` so there is no surplus to
spread. Cross-checked against a single-chip column (x=300, Tue): its chip now sits at the **top** with the slack below.
**Capture 2 (docs/ui-calendar/r072-band-light.png, light, 1100x692, `view week` + `date 2026-04-02`):** x=577 profile =
155 `sectionRule` (242) / 156-158 white (inset 3) / **159-182 chip (24)** / **183 gap (1)** / **184-207 chip (24)** / 208-235 empty
third slot / **236-237 separator (217)** / **238 first hour line (237)**. x=860 (Sat) = 249 tint, no chip. **Light measured first;
dark skipped on budget — the changed values are pure geometry (theme-invariant) and the dark tint was verified in R071.**
**Y-map movement (record it):** the band's top boundary (sectionRule y=155) is unchanged; the band interior is now 156..235 =
**80**; the bottom separator moved **204/205 -> 236/237** and the following hour lines shift with it (first hour line 206 -> 238)
= **+32px**, so the grid loses 32px of viewport.
**Not touched:** inset (step 3), radius (step 4), the four rule tokens, the weekend tint, `hourHeight`.
**Budget:** 2 build+capture cycles (the limit), 25 bash calls (the limit), ~10 min.

---

## R073 — A01 step 3: the all-day band's inset 3 → 1 (band 80 → 76)
**Atomic step:** the standing Next-round #1, ref-anchored, no spec ID. One number: `CalendarScheduleView.qml` `allDayBandInset` **3 → 1**;
`allDayBandHeight` derives ⇒ 1*2 + 3*24 + 2*1 = **76**.
**Reference re-measured at 1:1 on BOTH legs.** Vertical: top rule **y=124**, first chip **y=126** ⇒ inset ≈1. Horizontal (new this
round): separator **x=324** → near-white chip starts **x=326**; separator **x=487** → pink chip starts **x=488** ⇒ inset ≈1 on the
horizontal leg too, so the single shared token is the right shape (our horizontal factor is 1.85 not 1.33, so a purist would want 2;
1 ref-px is 1 ref-px, and the 1px difference is not visible).
**Our capture (light, 1100x692, Thursday x=577) — every value matched the prediction:**
155 `sectionRule` (242, unchanged) · 156 white = **inset 1** · **157-180 chip1 (24)** · **181 = the 1px gap** · **182-205 chip2 (24)** ·
206-231 third slot empty · **232-233** `allDaySeparator` (217, 2px) · **234** first hour line (237) · 235 white.
Horizontal: Thu chip **503..650** (delegate 502..651, separator at 502, inset 1 both sides); Wed chip ends 500 ⇒ the gap between
adjacent chips is 2px.
**The R072 spreading trap did NOT come back:** the gap stayed **1**, because the `ColumnLayout` is `height: implicitHeight`, so
shrinking the band removed surplus instead of redistributing it.
**New finding (this round): our all-day band draws NO column separators.** At y=215 (the empty third slot) x 495..664 is uniformly
**255**; the same x-window in the grid (y=250) has 1px **237** at **502** and **652**. The reference is the opposite: its separators
run *continuously through* the band — x=324 reads **244**, x=406 **236**, x=487 **242** for the whole band height. Those three values
are the *same* line at different subpixel coverage (81.3px columns ⇒ fractional x); the full-coverage value ≈ **236**, i.e. the
ref's band separators are the **same token as its hour lines**, no lighter variant. **So no new token is needed on our side — the
band's columns should carry the existing `gridLine`.** This was promoted to Next-round #1 (A01 step 4) ahead of the chip radius.
**Bonus E01 evidence:** the ref's pink all-day chip carries a **solid saturated 3px LEFT STRIPE**, x=491-493 = **(187,62,216)**, over
a light purple fill (488-489 = (237,228,239)/(244,226,249)). The stripe is real and 3px at 1:1. The neighbouring chip at x=326-340
is a *near-white* chip (248) with a coloured **ring icon** (blue 329-330 / 339-340, white centre) — the second all-day chip style.
**Dark skipped on budget** — the changed value is pure geometry (theme-invariant); the dark tint was verified in R071. 1 build +
1 capture cycle, 12 bash calls, ~8 min.
**Not touched:** radius (now step 5), the four rule tokens, the weekend tint, `allDayRowHeight`/`allDayRowGap`, the fixture.

## R074 — A01 step 4: the all-day band's column separators (DONE)
Asymmetric read: our band drew NO column separators (y=215 uniform 255 across x 495..664) while the reference's run unbroken
through it. Re-measured the ref 1:1 at x=324/406/487 -> 244/236/242 = ONE line at three subpixel coverages on 81.3px columns
(full coverage ~236 = the ref's own hour-line token) => reuse `gridLine`, no new token.
Edit: `apps/calendar/qml/CalendarScheduleView.qml`, `allDayColumn` delegate (after the R070 weekend-tint Rectangle) — two 1px
Rectangles at full delegate height: `anchors.left: parent.left` (the per-column left edge, same idiom as hourCell: ONE edge per
boundary so neighbours cannot stack into 2px) and `anchors.right: parent.right` with
`visible: allDayColumn.index === root.dayCount - 1` (the right rim).
Result (docs/ui-calendar/r074-band-separators-light.png, 1100x692 light, view week + date 2026-04-02): row run-scan at y=215
now reads 1px 237 at 52/202/352/502/652/802 — byte-identical to the grid row y=250 — with single-width boundaries
(501=255, 502=237, 503=255; 651=255, 652=237, 653=255). Vertical profile x=577 unchanged: 155/156/157-180/181/182-205/232-234.
New for next round: the band's right rim sits on Sun's right edge (x=1102), clipped at 1100. Next: A01 step 5 — all-day chip
radius 5 -> ~8.

## R075 — A01 step 5: the all-day chip's corner, 5 → 8 (derived)
**Atomic step:** the standing Next-round #1. **Ref first (1:1, before editing):** Thursday chip, fill `(244,226,249)`, left
edge x≈488.5, top y=126 ⇒ fill-start inset per row from the top = **4.5 / 3.5 / 2.5 / 1.5 / 1 / 0.5 / 0** ref-px ⇒ fully
turned after **6 of 18 px** ⇒ **r ≈ 6 = row/3**. **Edit:** `CalendarScheduleView.qml` `allDayChip` `radius: 5` →
`radius: Math.round(root.allDayRowHeight / 3)` = 8. Derived on purpose: a literal 8 rots the moment the row height moves.
**Ours after:** per-row inset from y=157 = **8 / 5 / 3 / 2 / 2 / 1 / 1 / 1 / 0** (blue channel; 246 = full fill, 237 = the R074
separator at x=502, 255 = white) ⇒ **8 rows on 24** = the ref's **6/18** normalized. The ref is a **squircle** (first row 4.5
where a true r=6 circle reads ~6) — arc *length and orientation* match, which is what a 1:1 read can compare.
**Regression surface, same capture:** chip left edge still x=503 (inset 1), chip 157..180, gap 181, second chip 182..205 ⇒ R073
y-map intact; separator still 1px (503 = 255 in the gap rows); row 24 / gap 1 / band 76 / four tokens / weekend tint / timed
chip (`:556` `radius: 5`) untouched. Light only — pure geometry on an already-verified fill. **Evidence:**
`docs/ui-calendar/r075-chip-radius-light.png`, `docs/ui-calendar/r075-corner-compare.png`.
**A01 verdict (tester):** all four clauses now match the ref 1:1 (row 18/gap 1/inset 1 ref-px → ours 24/1/1); the spec row's
"vertical gap 2" and "column inset 2–3" do **not** survive a re-measure (both read 1) ⇒ **spec erratum → ruling G**, A01 is
**PASS-pending-final-regression**, do not "fix" the code to 2/3.
**Harness gotcha paid this round:** `captureClient` on a nested relative path returns **`false`** (the app's CWD is the task dir,
so `tmp/ui-acceptance/calendar/x.png` resolved into a non-existent subdir) — use a **flat** filename and read the success flag in
`live-runtime-vm.log`. **Next:** A03 (multi-day strip continuity / which corners round).

## R076 — A03: the multi-day all-day strip (continuity / which corners round)
**Ref first, and the ref refused the question:** walking all 21 band rows at every separator (324/406/487/569/650/732) shows the
rule **visible and darker than both neighbours on every row**, with chip fills on both sides stopping 1–2 px short. The
reference week therefore contains **no multi-day all-day event** — every chip lives inside one column and has a symmetric arc
on *both* edges (Thu chip measured fill-left per row: y126→499, 127→494, 128→492, 129→491, 130→490, 131→490, 132..138→489,
139→491, 140→492, 141→493, 142→496; right edge mirrors). So A03 is **spec-only**, and the ref only contributes the half the
clause needs: **the day boundary is drawn *through* the band.**
**Edit:** `CalendarScheduleView.qml` — new injected `itemRecord` (bound in `Main.qml`'s two `CalendarScheduleView`s), helpers
`isoDay` / `isoDayPattern` / `lastCoveredDay` / `allDayContinues`, and `allDayChip`'s single `radius` split into
`topLeftRadius`/`bottomLeftRadius`/`topRightRadius`/`bottomRightRadius` = `endRadius` unless the item continues past that
column edge. Single-day chips continue neither way ⇒ bit-identical to R075.
**Measured result (per-row `!= white` envelope, chips at 53..200 / 203..350 / 353..500):** Mon 30 `insetL 4·2·1·1·0…`,
`insetR 1` on all 24 rows → **round left / square right**; Tue 31 both edges flat → **square/square**; Wed 1 `insetL` flat,
`insetR 5·3·2·2·1…1·2·2·3·5` → **square left / round right.** One bar; only the outer ends round. ✓ A03 PASS.
**The check that stopped this being guesswork:** the strip is Mon 30 – Wed 1, **not** Mon–Thu. Popover:
`2026年3月30日星期一 – 2026年4月1日星期三 · 全天`. So Wed's right end *is* the run's end and a rounded corner there is correct —
the corner test (record `start`/`end`) and the coverage (service date expansion) agree, which is exactly the pair that could
have silently disagreed.
**Correction to the record:** R072's "Thursday carries 3 all-day items" is wrong — `Multi-day review` is absent from Apr 2
(the `openItem` probe on Apr 2 found nothing; the item's DTEND is `20260403` but the record's end is the inclusive last day,
Apr 2), so Apr 2 holds exactly 2 all-day items and `slice(0, 2)` hides nothing on this fixture.
**Harness notes paid this round:** `captureClient` lands a flat filename in the repo root (app CWD = `/home/amao/nextkde`) —
move it into `tmp/`. A second capture that needs no rebuild costs only a drill, not a kill+relaunch. `openItem` searches the
*selected* date's items, so "no popover appeared" is a usable negative result.
**Next:** E01/E02 step 1 — the ref chip's 3px same-hue left stripe (measured 1:1 in R073).


## R077 — the "3px same-hue left stripe" is a TIMED-grid-chip property; R073 read the band ICON.
**The claim this round was sent to act on, and the measurement that killed half of it.** The standing Next-round #1 said
"add the stripe to the **all-day chip**", resting on R073's "measured 1:1: x=491-493 = (187,62,216)". A classified 2D dump of
that region (`macos-calendar.png` x482..513, y123..149) shows what is really there: a **ring icon** — saturated purple only on
its left arc (x490-491), a hollow centre at **x495-496 (255,255,255)**, and a right arc at x500-501; rows 129-140. A stripe
would be a full-column bar of constant width; this narrows to nothing at both ends. **R073 measured the icon's arc.**
Re-scanning the whole band (y124..184, saturation >90) returns exactly four 12x12 blobs — x247-258, x329-340, x491-502,
x654-665, each ~4px inside its column rule — and **no 2-3px full-height bar at any band chip's left edge.** The ref's all-day
band chip has an **icon, no stripe**.
**Where the stripe actually lives — the timed chips of the hour grid.** A saturation scan of the grid (y186..460) returns 3px
runs at x328-330, x409-411, x572-574, x654-656, x735-737, and the 4x crop shows them plainly: blue "Morning…", red
"Portfolio…", red "Leadersh…" each carry a full-height bar at the left edge. Numeric profile of two of them:
**blue x409-411 = (59,134,247)** with the fill at 407-408 = (222,237,254); **red x328-330 = (235,76,70)** with the fill at
326-327 = (251,228,227). Both say the same thing, so the numbers are not a subpixel accident: **~2.4 ref px of ink (2 solid +
AA) on an ~80 ref px column, its left edge ~2 ref px inside the chip's fill** — a sliver of the light wash shows beside it —
**capped round**, held ~1 ref px clear of the chip's top and bottom. The bar's width is **absolute, not proportional**: the
30-min chip (11 ref px tall) and the 60-min chip (22) carry the same 2.4px. Text ink starts **7 ref px** in from the chip's
fill edge (chip x=326 → ink x=333).
**Edit** (`CalendarScheduleView.qml`, `timedChip` only): `stripeWidth: Math.round(chipHeight / 4)` = **4** (the chip is 16),
`stripeInset: stripeWidth`, a capsule (`radius: width/2`) at `x: stripeInset`, `anchors.top/bottom` with `topMargin`/
`bottomMargin` **2**, `color: root.itemColor(modelData)` (no alpha), and the Label's `leftMargin` 5 → `inset + width + 5`
= **13**. Derived from the box, not typed (R075's rule). **Not touched:** the all-day chip (R076 corners, R075 radius, R074
separators, all band geometry), the fill translation, the 1px border, `radius: 5`.
**Evidence.** Light: stripe runs `x59..62` (4px) in a column whose chip starts at 55 ⇒ fill 55-58, bar 59-62, exactly as
specified. Dark: `x509..512` = **(48,140,198)** with the fill `(36,69,90)` on **both** sides. Composite
`docs/ui-calendar/r077-timed-stripe-compare.png` (ref at ×1.8, ours at 1:1, both at our feature scale) shows matched bar
length, inset, caps and text clearance.
**Still open from the same family:** the ref's chip text is **dark same-hue** (red chip ink (117,37,34), blue chip ink
(99,131,172)+) where ours is `AppTheme.text`; and the ref's chip has **no border** where ours draws 1px at alpha 0.34 — the
ref goes column-rule (236) → fill (222,237,254) with no darker ring. That is `Next` #1.
**Next:** delete `timedChip`'s 1px border (verify on a second edge first — the left edge sits against the column rule), then
the dark same-hue text.

## R078 — E01/E02 step 2: the timed chip's 1px border is deleted (it is not in the ref)
Read the two edges that can prove absence — **top and bottom**, on two different chips — as raw 1:1 profiles.
Ref Wed blue chip **top**: 255 → 242 (rule) → 249 → **230,242,254** (AA) → 222,237,254 fill. Ref Wed blue chip **bottom**:
fill → **224,235,248** (AA) → 242 (rule) → 253,242,241 (next chip). Ref Tue blue chip **top**: 255 → 249 → 236 (hour line) →
**239,246,255** (AA) → fill. **Every transition goes lighter than the fill, never darker**; a 1px ring at alpha 0.34 would be a
row darker *and* more saturated. None of the three has one. Deleted `border.width: 1` + `border.color` from `timedChip`
(`CalendarScheduleView.qml:631-633`) and left the measurement as a comment. Ours after — light: rule 237 @x502 → white →
fill (216,234,245) from x505; top row 277 fill, 292→293 straight to white. Dark: rule (59,59,59) → (30,30,30) → fill
(36,69,90) from x505; same edges. **R077's bar reads 509-512 = (48,140,198) in both legs — bit-identical to R077.** Evidence:
`r078-noborder-light.png`, `r078-noborder-dark.png`, `r078-noborder-compare.png`.
**Still open, same family:** the ref's chip text is **dark same-hue** (red ink (117,37,34)) where ours is `AppTheme.text`.
**Next:** E01/E02 step 3 — the dark same-hue chip text.

## (archived from state.md) R070/R072 notes now fully settled
- **WEEKEND TINT IS A *COLUMN* PROPERTY, NOT A BAND PROPERTY (R070/R071).** Ref: weekday columns 255 in band *and* grid,
  Sat/Sun 249 in both; the band has no tint of its own; the day-header row is not tinted. Ours: `weekendField` (light `#F9F9F9`
  = 249, dark `white@0.03` = 37) + `isWeekendColumn(column)` (`getDay()` in {0,6} — date-driven so it survives a Mon-start
  week), consumed by two first-child background Rectangles: the band's `allDayColumn` and the `hourCell` delegate (guarded
  `columnIndex > 0`). R074: the band's separators are drawn ON TOP of the tint.
- **A `ColumnLayout` TALLER THAN ITS ITEMS SPREADS THE SURPLUS INTO ITS SPACINGS (R072).** Measured: a band 74px tall holding
  two 24px chips on `spacing: 1` rendered leading 7 / between 13 / trailing 6. Fix = remove the surplus, not fight the
  distribution (`anchors.top/left/right` + `height: implicitHeight`). Re-check on any future band-height work.

## R079 — E01/E02 step 3: the timed chip's ink is the calendar colour at HALF VALUE (settled by measurement)
**The question this round existed to settle.** The standing `Next` #1 asked whether the ref's dark same-hue chip text is a *translation*
of the calendar colour or "the colour at some alpha" — explicitly: "check whether a saturation/value mapping reproduces
(59,134,247)→(99,131,172) and (235,76,70)→(117,37,34) with the *same* parameters". Read as **ink CORES** (the extreme cluster of the
glyph, not the AA edge — R078's (99,131,172) was an AA pixel and R079's own scan found the blue core at **(26,67,123)**), the answer is
the simplest possible one: **the ink is the chip's own colour at 1:2 on every channel.** red bar (235,76,70) → (117,37,34); blue bar
(59,134,247) → (26,67,123); an olive chip (254,204,0) → (127,102,0). A *uniform RGB scale* is exactly an **HSV value** scale —
`S = (max−min)/max` is invariant — so there is **no separate value/saturation mapping to find**, and no per-colour fudge is needed.
**Rule adopted:** `ink = c + (pole − c) * 0.5`, `pole = dark ? 1 : 0` — half to black in light, half to white in dark, hue and
saturation untouched. **Edit** (`CalendarScheduleView.qml`, `timedChip` only): a new `readonly property color inkColor` carrying the
measurement as a comment, and the Label's `color: AppTheme.text` → `timedChip.inkColor`.
**How it was verified — the coverage test, which is the round's real instrument.** A pixelSize-9 glyph never reaches full coverage, so
"is the ink X?" was answered by **solving the blend for its coverage per channel**: `t = (fill − pixel) / (fill − X)`. A correct X makes
the three t's **agree**. Light — green (57,196,135) → (28,98,67): (45,111,85) ⇒ 0.91/0.91/0.89; gold (215,166,44) → (107,83,22):
(129,105,43) ⇒ 0.84/0.86/0.89; blue (48,140,198) → (24,70,99): (49,89,121) ⇒ 0.87/0.88/0.85. Dark — green → (156,226,195):
(141,210,176) ⇒ 0.87/0.88/0.85; gold → (235,211,150): (220,199,128) ⇒ 0.89/0.91/0.81; blue → (151,197,226): (137,183,206) ⇒
0.88/0.89/0.85. **Nine chips, two legs, ±0.05 agreement ⇒ the endpoint is right.** Corroboration by kind: R078's grey ink produced
near-equal channels; every chip now reads its own hue (blue B>G>R, green G>B>R, gold R>G>B) — the ref's idiom — and the ×3 composite
`r079-ink-compare.png` puts the ref's "Stretchin…" ink beside our "Morning planning".
**Two instruments that FAILED, recorded so they are not retried.** (1) **The hull.** In light the darkest pixel overshot the segment (blue
R read 60 where the ink is 24); in dark the brightest overshot (blue G reached the ink's G while R/B sat *below* it — impossible for a
convex blend). Small coloured text is subpixel-AA'd in **both** themes. (2) **The cross-round A/B.** r078-noborder-light.png and
r079-ink-light.png — same session, view and date — have **different chip sets at the same y** (R078 has 16px bands at 277-292 / 414-430 /
517-532, R079 has none there and has 454-470 / 477-492 / 557-572 instead), and in the dark pair y317-332 is a *green* chip in R078 (mean
(66,110,91)) and a *blue* one in R079 (mean (46,80,102)). **Two rounds' captures are not position-aligned; the band map must be
re-derived per capture.**
**Regression guard.** The bars read **bit-identically to R078 in both legs** — (48,140,198) / (57,196,135) / (215,166,44); dark fills
(36,69,90) / (40,90,68) / (96,79,35) unchanged. Fill alpha, `radius: 5`, the R077 bar, the R078 border deletion and the whole all-day
band untouched. **Evidence:** `r079-ink-light.png`, `r079-ink-dark.png`, `r079-ink-compare.png`.
**Operational cost, recorded.** The first light capture of this round was served by R078's **still-running dark app**: `start-review-vm.sh`
**exits 1** (`Owned review instance still running: <pid>`) when `live-app.pid` is alive, and `>/dev/null` hid the message — so no new
process existed and the old theme answered the capture. Kill `"$(cat live-app.pid)"` first, keep the launcher's stderr, and confirm
`live-app.pid` changed.
**Next:** the all-day band chip's ink — **measure the ref's band-chip ink core first** (never measured), then copy `inkColor` if the ref
says hue, or record a grey verdict and leave the code alone.

## (archived from state.md, R079)
- **A LITERAL `8` WOULD HAVE BEEN WRONG TO WRITE; `row/3` IS THE RULE (R075).** Ref chip radius ≈ **6 ref-px on an 18 ref-px row = one
  third of the row height**. **Any future corner — or bar, R077's `chipHeight/4`, or ink, R079's pole fraction — must be derived from the
  box/colour it sits in, not typed.** Corollary: **the ref's corner is a SQUIRCLE (continuous curvature)** — its first row reads 4.5
  where a true circle of r=6 would read ~6 ⇒ **compare arc *length and orientation* against the box, never the first-row inset alone.**
- **THE BAND RULES ITS COLUMNS WITH THE GRID'S TOKEN (R074).** `allDayColumn`: left-edge 1px `gridLine` per column + right rim on
  `index === root.dayCount - 1`. Measured: y=215 (band) and y=250 (grid) give the SAME run list (52/202/352/502/652/802, all 237) and
  the boundary pixels are single-width (501=255, 502=237, 503=255) ⇒ **no band-only token.** (Still live in state.md; the *measured run
  list* is the part that matters and it is repeated there.)

## R080 — the band chip's ink: the REF settles it (1:2 on two of its own colours), then our code copies the rule
**The question the round existed to settle.** The timed chip's ink became `itemColor` half-way to the pole in R079, but the *band*
chip's Label was still `AppTheme.text`, so the two chip families disagreed visibly in one screenshot. The ref had **never** been
measured for the band chip's ink — so the round measured the ref first, before touching code. Instrument: `Counter` mode over a cell for
the fill, then the ink core (the extreme cluster of the glyph) read against **the chip's own ring icon**, which the ref draws in the item
colour. Results, 1:1, on the ref band rows y126-143 / 145-162 / 164-181:
- purple ring **(187,62,217)** (April Fool…, Passover, Good Fri… — three chips, identical) → ink **(93,30,108)**
- blue-grey ring **(133,148,173)** (Sun "Antonio…", two rows) → ink **(67,74,86)**
**Both are 1:2 on every channel** (187/2 = 93.5 → 93; 217/2 = 108.5 → 108; 173/2 = 86.5 → 86). ⇒ the band chip's ink is exactly R079's
rule, anchored in the band by the ref rather than by analogy, and **the ring-icon colour is the item colour** — which is the number the
eventual icon work will need.
**Edit:** `CalendarScheduleView.qml`, `allDayChip` only — a derived `readonly property color inkColor` (the same expression as
`timedChip`'s) and the Label's `color:` → `allDayChip.inkColor`, with the measurement in the comment. Nothing else in the band.
**Our verification (coverage test `t = (fill − pixel)/(fill − ink)` per channel).** Light, blue (48,140,198), fill (220,236,246):
(125,155,175) ⇒ **0.48/0.49/0.48**; (50,90,118) ⇒ 0.87/0.88/0.87; (101,133,154) ⇒ 0.61/0.62/0.63; spread ≤0.019 with **25 px < 0.05**.
Dark, fill (35,65,83), ink (152,198,227): (92,130,153) ⇒ **0.49/0.49/0.49**, **40 px < 0.05**. A grey ink fits only 11 px (light) / 6 px
(dark) to the same tolerance.
**Why the count alone is not the argument, and what is.** On our low-saturation blue the hue direction from the fill and the grey
direction are only **9.6° apart**, so the pixel count separates the candidates by just ~2.3×. The exact discriminator is a **channel gap
the fill cannot reach**: the fill's **B−R is 26 (light) / 48 (dark)**, so no neutral endpoint can produce the observed **50 at t=0.48**
(light) or **61 at t=0.49** (dark) — only an endpoint of the fill's own hue can. **Use the gap, not the count.** (Corollary for a future
green/gold band chip: those separate far more sharply, so a coloured band fixture would be the stronger test.)
**The hull failed again, as R079 warned.** Our light band chip's *darkest* pixel is (60,71,121) — off the fill→ink segment, G too dark —
while dozens of mid-coverage pixels fit the assumed ink to ±0.005. **Never read an ink off the extreme pixel in either theme.**
**The ref's band has a second, unexplained chip family — recorded so it is not cited.** Besides the coloured chips there are **neutral**
ones: fill **248**, ink **(38,38,38)** — a pair that cannot be `itemColor` and `itemColor/2` of one source, since fill 248 implies a pale
colour while ink 38 implies a dark one — carrying a strongly coloured ring (Mon: blue (69,117,232), salmon (199,167,162)) or, when the
event is declined, greyed text (184,184,184) (Thu "Take o…", Fri "Status…"/"Weekl…"). Those chips must not be used to derive any ink or
fill rule.
**Regression.** Band fills (light (220,236,246), dark (35,65,83)) and the timed chip's light fill (216,234,245) read as in R079; the
multi-day strip's square joints, corner radii, separators, inset and `slice(0,2)` untouched. **Observed but not chased:** the two Thu band
chips swap order between the light and dark launches (`Release notes`/`Design sync` reversed) — a model/view ordering instability, no ID.
**Evidence:** `docs/ui-calendar/r080-bandink-{light,dark,compare,dark-band-x2}.png`.
**Next:** the band chip's 12×12 ring icon — measure its geometry on the ref, then ask for ruling H (decoration or checkable control)
before building anything.
# R081 — **the ref's all-day band chip icon is a 12x12 RING: outer 12, stroke 3, hole 6, inset 3 from the chip's fill on left/top/bottom.**
Measured on the ref only — **no code changed, no build, nothing was built.** The band chip's ring icon was 仍差 #1 and had never been
measured, so this round measured it: a x6 `NEAREST` crop of six ref rings plus raw row/column profiles. The ring is **12x12 ref px**
(Wed1 r0 x491-502, y129-140) inside a chip fill spanning y126-143 ⇒ **vertically centred, 3 px top and bottom**; its **outer left edge
sits 3 px right of the chip's fill left edge** on **all four** chips checked (Wed1 fill 488/ring 491, Fri3 651/654, Sun29 r2 244/247,
Mon30 326/329) — and the fill is **rule + 1**. **Two stroke weights exist**: stroke **3 / hole 6** in purple (187,62,216) and blue-grey
(133,148,172), stroke **~1.5 / hole ~9** in blue (76,121,232) and salmon (235,186,179); both are 12 outer, and the correlation is
**thick ⇔ tinted-wash fill, thin ⇔ neutral-248 fill** (R080's *unexplained* family). The *reason* is not measurable off a PNG ⇒ **ruling
H**. Text ink starts **17-19 ref px** right of the ring's outer-left edge. **Nothing is built until H is answered** (decoration vs
checkable control). Figure: `r081-bandicon-ref-geometry.png`. (2026-10-17)

**Ring, exact.** Wed1 r0 centre row: x491(188,66,218) 492(187,62,216) 493(193,78,220) | wash x494-499 | x500(201,103,225)
501(187,62,217) 502(189,68,218) ⇒ stroke 3 / hole 6 / outer 12. Centre column: ring y129-131, hole y132-136, ring y137-140 (the 4th row
of that run is AA). Sun29 r0 blue-grey is pixel-identical in form (x247-249 / hole / x256-258). **Thin family:** Mon30 r0 =
x329(76,121,232) 330(164,186,241) | hole x331-338 | x339(102,141,235) 340(138,167,238) ⇒ outer 12, stroke ~1.5, hole ~9; Fri3 r2
salmon (235,186,179) is 1 px with heavy AA. **Ring colour = the item colour at full saturation, no alpha** (re-confirms R080) — and it is a
**ring, not a stripe** (R077's x491-493 read was this ring's left arc).
**Chip geometry re-confirmed on ring-bearing chips.** Fill left = **rule + 1** (Wed1 488/rule 487, Fri3 651/650, Sun29r2 244/243, Mon30
~326/324); fill spans **y126-143 = 18 rows** ⇒ R072's row 18 / gap 1 / pitch 19 holds; fills (244,226,249) purple, (234,236,240)
blue-grey, (248,248,248) neutral.
**THE SCALE IS ANISOTROPIC — the round's one open design number.** Ref chip fill is 18 tall x 81 wide, ours is 24 x 148 ⇒ **x1.33
vertical, x1.83 horizontal**, and a circle cannot use both. Recommended (vertical ratio, so the icon fits the 24-px row): **ring
16 = round(row x 2/3), stroke 4 = 16 x 3/12, hole 8, inset 4 = round(24 x 3/18) on left/top/bottom, text ink at fill_left + 28** (ref
3+12+6 = 21, x1.33). The horizontal ratio would give ring 22 / inset 5.5 — rejected: 22 on a 24-px row leaves 1 px and puts the title at
+38. **No ref anchor exists for the two-weight rule** — record the correlation, do not encode it.
**Archived out of state.md (superseded by the above):** *the ref's same-hue left stripe is a TIMED-GRID-CHIP property; the band chip has
an icon instead (R077)* — R073's "x=491-493 = (187,62,216) stripe" is the band ring's left arc (hollow centre x495-496); never cite the
ref for a stripe in the all-day band.
**Evidence:** `docs/ui-calendar/r081-bandicon-ref-geometry.png` (6 rings, x6 NEAREST, 1-ref-px grid).
**Next:** the icon is blocked on **ruling H**; the next unblocked step is the Thu band-chip order swap (仍差 #8).


## R082 — the Thu band-chip order swap is RUN-TO-RUN (仍差 #8 CLOSED as a defect, fix deferred)
**Step:** Next-round #1, classification only — **no code change.** Three legs of the **same** build: `leg.sh light light1`,
`leg.sh dark dark1`, `leg.sh light light2`; each kills `live-app.pid` first (pids 141747 → 143818 → 144014 → 144185), re-launches with
`start-review-vm.sh <theme>`, waits 30 s, then drives ONE flat capture list (`resize 1100x692` + `view week` + `date 2026-04-02` +
`captureClient`). All three reported `capture capture-<leg>.png true`; the three PNGs are **the same byte size (3050463) but different
md5**, so the R069/R079 "same size ⇒ stale" trap was checked and cleared.
**Verdict: RUN-TO-RUN.** light1 r0/r1 = `Release notes` / `Design sync`; **dark1 identical**; **light2 REVERSED**
(`Design sync` / `Release notes`). Two same-theme legs disagreeing is the whole proof — **R080's "the swap is between the light and dark
launches" was an artifact of comparing one light run against one dark run.** Cost of the verdict: 3 launches + 1 scan script.
**Numeric backing:** per-column max-deviation-from-fill profile, x504..648, rows 157-181 and 182-206, rendered as an ASCII ramp string —
light1.r0's string is **character-identical** to light2.r1's, and light1.r1's to light2.r0's. (The `x=504..647` ink extent the script
prints is the clamp, not the text; the right-hand `.:` is the column rim. The *string identity* is the evidence.)
**Band y-map re-confirmed on all three legs** (row0 157-180, gap 181, row1 182-205, third slot 206-231 empty; rule y155 = 242 light /
39 dark; fill (220,236,246) light / (35,65,83) dark) ⇒ the swap is content, and R073's y-map is still exact two rounds on.
**Mechanism, read not guessed:** `Main.qml:1159-1166` sorts `itemsByDate` (all-day first, then `itemDateTime` lexicographic);
`CalendarScheduleView.qml:136-145` `allDayItems()` is an order-preserving filter; the two fixture VEVENTs have **identical
`DTSTART;VALUE=DATE:20260402` and `DTEND;VALUE=DATE:20260403`** (profile ICS lines 832-834 `Design sync` UID `…allday-a`, 842-844
`Release notes` UID `…allday-b`) ⇒ `localeCompare` returns **0**, `Array.sort` is stable, so the *incoming* order decides — and it is
**neither file order nor its reverse** across the three legs ⇒ **the upstream ordering of equal-start all-day items is nondeterministic.**
**Evidence:** `docs/ui-calendar/r082-thu-band-3legs.png`. **Next:** a deterministic tiebreak in that sort (blocked on nothing), then the
same 3-leg experiment as the regression.

## R083 — the tiebreak is in; the Thu band order is deterministic (2026-10-17)
**Step:** one code change. `apps/calendar/qml/Main.qml` — new `itemStableId(item)` (record `seriesId` = the VEVENT UID, then `id`), and
the `result[key].sort` comparator at 1159-1166 now falls back to it (then to `itemTitle`) when `itemDateTime` compares 0. All-day-first
rule untouched; icon/fills/inks/corners/separators/timed chip untouched. Build: 7 targets, clean.
**Regression:** R082's 3-leg shape verbatim — `leg.sh light light1` / `leg.sh dark dark1` / `leg.sh light light2` (pids 144185 → 145311 →
145475 → 145631), each `resize 1100x692` + `view week` + `date 2026-04-02` + `captureClient`, all three `capture … true`, all 3050463
bytes, md5s `8acbc1a1…` / `86a085f5…` / `f89ca055…`. **All three legs: r0 = `Design sync`, r1 = `Release notes`.**
**Instruments:** (a) R082's per-column max-deviation ASCII ramp over x504..648: `light1.r0 == light2.r0`, `light1.r1 == light2.r1`
character-identical; `dark1` same run *shape*, different ramp values (dark dynamic range). (b) raw numbers, light1 vs light2 in the band:
fill (220,236,246) n=502/515, top-5% ink mean (78.9,103.2,149.8)/(79.0,102.3,148.5), extremes (50,90,118)/(63,86,123) — **identical**.
(c) word-gap widths prove the titles: r0 28+19 px = 6+4 chars, r1 33+24 px = 7+5 chars, ~4.7 px/char.
**New instrument fact:** two same-theme launches can be **pixel-identical inside the band** while their md5s differ, because the now-line
moves with wall-clock between launches. **Never use a differing md5 as evidence of a content difference** — diff the region.
**Verdict:** 仍差 #8 (nondeterministic tie) **CLOSED**. No ref anchor exists for the order of two equal-start all-day items, so this is a
stability fix, not a ref match. **Next:** N02 — now-line + red time badge + today marker (needs a capture of the CURRENT week, 2026-10-17,
so the now-line lands inside the viewport).

## R084 — N02: the current-time line becomes the ref's four-part object (light leg)
Code: `apps/calendar/qml/CalendarScheduleView.qml` only. Before: a **1px `AppTheme.destructive` rule, per hour-cell, today's column
only, no dot, no badge**. After: six root properties (`nowRow`/`nowInHour`/`nowLineY`/`nowLabel`/`todayColumn`/`nowLabelClearance`),
`nowLine` (2px — full strength on today's column, `Qt.rgba(todayRed,0.10)` on the rest), `nowDot` (9px, centred on today's left
column rule), `nowPill` (42×20 `todayRed` capsule in the gutter, white time, `rightMargin 6`), and a gutter Label that hides when
the pill would collide with it.
Ref (1:1, now = 9:41): line **2 ref px, y238-239**; **strong x487..569** (Wed 1's column, `(235,76,70)`); **faint ~10% x243..813**
(`(253,237,236)`); **dot d≈6.5 centred x488.5 vs the rule at 487**; pill **31×15, x209..239** — right edge on the hour labels' ink
edge (238), centre y238 = the **true** now y (9:41 ⇒ 238.4, **not** the 220/247 ticks); **the pill's row drops the label it collides
with** (9AM ink y216-224 survives, 10AM is gone).
Ours (light 1100x692, `contentY 0`, clock 01:43): pill **42×20 x4..45**, line **y303-304**, strong **802..951 `(229,72,77)`**, faint
**`(252,236,237)`**, dot **9px centred x=802**, `01:00` ink **y270-278** survives and the next label is suppressed. Colour
`AppTheme.destructive` (216,59,59) → `root.todayRed` `#E5484D` (229,72,77): **6/255 off the ref**, where the old token was 19 off.
Instruments: (a) ref crop composite `r084-ref-nowline.png` (gutter+pill, the line strip, the header row); (b) red-run ASCII per row;
(c) pill bbox / label-ink bands on our capture. **Lesson recorded: the ref's line looked like it stopped at x=732 because a green
chip sat under it — a faint overlay on a coloured chip reads as a tint.** Dark leg NOT captured (budget). Figure:
`docs/ui-calendar/r084-nowline-compare.png`.

## R085 — N02 dark leg: no code change, the four-part now-line carries over part-for-part
Verification round on R084's object. Leg `r084-leg.sh dark r084-dark 2026-10-17 0`: pid 147363 → 148302, `capture-r084-dark.png true`,
3050463 bytes, md5 `beae751f…`, clock 01:46 (light leg 01:43). **All four parts shifted +2 rows together** — pill y293..312 → y295..314,
dot centre 303.5 → 305.5, line y303-304 → y305-306 — which is exactly R084's "one geometry source" claim being tested rather than
asserted. Colours **identical across themes**: pill fill and the strong segment both `(229,72,77)`; the faint rule `(252,236,237)` light
→ `(50,34,35)` dark, continuous over x60..799 by row mean in **both** (control rows 255 / 30). Untouched: `gridLineMinor`/`gridLine`
(dark 43 / 59), and the `02:00` label suppression (|314−305.5| = 8.5 ≤ 14). New live item: the dark faint rule's luminance contrast is
**7.4 vs the light leg's 15.5** at the same 0.10 alpha — equal channel deltas, half the perceived contrast, which is why the line *looks*
like it stops at the dot in dark. **Recorded, not fixed: no ref anchor exists** (the ref image has no dark mode) and the alpha is one
shared token. Figure `docs/ui-calendar/r085-nowline-dark-cmp.png`.

## R086 (2026-10-17) — 仍差 #8 closed: the today header disc 20 → 22 px
One atomic step: `CalendarScheduleView.qml` header date mark `width/height/radius 20/20/10` → `22/22/11`. Nothing else touched.
**The round's real work was rejecting its own premise.** 仍差 #8 carried "ref 22 ref px ⇒ 29 at our scale", derived by applying the
window-height ratio (522→692 = 1.33) to the disc. Measured the ref and our own capture with one instrument: ref gutter-label ink
height 9 px, ours 9 px; ref day-number ink inside the disc 9 px, ours 9 px (font pixelSize 12). **The two type scales are already 1:1
even though the layout is 1.33–1.48× bigger**, so the ref-anchored target is the ref's own 22, not 29. Change was therefore 20 → 22
(+10%), not 20 → 29.
Evidence: ref disc x536..557 × y101..122 = 22×22, fill (235,75,70); ours after x879..900 × y126..147 = 22×22, fill (229,72,77)
(`todayRed` #E5484D — untouched). Disc centre vs weekday-ink centre: ref 111.5 vs 111, ours 136.5 vs 137.5, ≤1 px, unchanged.
Before/after pixel diff is exactly three bands: y126-147 = the disc (1170 px), y297-318 = the now-line (it moves with wall-clock; the
two captures are 2 min apart, 01:50 → 01:52), 6 px at y62-63. **y148..y296 — the whole all-day band 156..231 and the grid down to the
now-line — byte-identical**; `sectionRule` y155 still 242.
Bash ≈ 13 (1 capture, 1 build, 2 measure, 1 diff). Figures: `docs/ui-calendar/r086-today-disc-cmp.png` (ref Wed 1 above ours Sat 17,
same 1:1 pixel scale), `r086-today-disc-after3x.png`.
Carried forward as a new extrapolation: **never scale a ref type element by the window ratio — find a same-class ink in both images
first** (digits are the cleanest). Next round: A02 phase 1, the 1-row / 4-row all-day fixture, measurement only.
## R087 — A02 phase 1: fixture only, prediction falsified, A02 re-classified
This round built the missing fixture and looked at the band's response. **No code changed.**
Fixture: 3 all-day VEVENTs appended to `profile/pim/calendar.ics` — UIDs `…r087-allday-c` and `…-d` on `DTSTART;VALUE=DATE:20260402`,
`…-e` on `20260403`. Result: **Thu Apr 2 = 4 all-day items** (was 2: `Design sync`, `Release notes`), **Fri Apr 3 = exactly 1**.
The other columns are unchanged (Mon/Tue/Wed 1 each from `Multi-day review`, Sat/Sun 0).
Capture: `leg.sh light r087a` — light 1100x692, `view week`, `date 2026-04-02`, md5 `24160c7fb7998cc21f7ed146bc046d54`, capture flag true.
Prediction under test: "the band stays 156..231 = 76 and the 4th row is clipped or overflows into the grid." **FALSIFIED.**
Measured, all unchanged: `sectionRule` y=155 (242); band interior 156..231 = 76; `allDaySeparator` y232-233 (217, 2px); first hour
line y234 (237). Nothing moved and nothing overflowed.
What actually happens on Thu: **exactly 2 chips render** — y157-180 `Design sync`, y182-205 `Release notes`. The third slot y206-231 is
empty and `R087 card C` / `R087 card D` are **not rendered at all** (no `+N`, no clip, no scroll). Fri renders its one chip at
y157-180. So the band **never clips and never grows — it is a fixed 3-row box whose 3rd row is unreachable.**
Cause is one line: `apps/calendar/qml/CalendarScheduleView.qml:454` `model: allDayColumn.columnItems.slice(0, 2)`, while
`:64 allDayBandRows: 3` feeds `:69 allDayBandHeight` = `1*2 + 3*24 + 2*1` = 76. The **height is already the ref's 3-row strip at our
scale** (ref `1*2 + 3*18 + 2*1` = 58 content; 76/58 = 1.31 ≈ our vertical 1.33). The **model** is what is capped.
Ref check (the part that changes the classification): crop `_r087-refband2x.png` + a row mean over x250..810. The ref band is **one
uniform 3-row strip shared by all 7 columns**, and those columns carry **0, 1, 2 and 3** chips (3/2/0/3/1/3 by column). The bottom
separator is **y183-184 (217, 2px)** and its row-mean is a constant **217.0 across both rows of the full grid width** => **shared bottom
edge, zero per-column variation**; row-2 chips are fully drawn, none half-clipped.
**=> the ref band does not expand with the row count either.** "The ref grows it with the number of all-day rows" was a spec reading,
never a measurement. **A02's height clause therefore has no ref anchor and our fixed 76 already matches the ref's structure**; what is
actually broken is **A04** (overflow count explicit) — our band's cap is 2 with no `+N` for the 3rd, on a strip that is already tall
enough for 3.
Figures: `docs/ui-calendar/r087-allday-band-cap.png` (ref strip above ours, each 1:1 at x2, labelled).
Bash ≈ 11 (1 fixture edit, 1 launch, 2 measurement scans, 2 image reads, 1 ledger write).
Next round: **A04 step 1** — `slice(0, 2)` -> `slice(0, allDayBandRows)` on the band model (ONE atomic change), then re-measure Thu.
A02 itself closes as ref-satisfied-for-height. Still needs a 3-item *month* cell before 仍差 #6 can be reproduced.

## R088 — A04 step 1 PASS: the band's model cap 2 -> allDayBandRows (3), one line.
`CalendarScheduleView.qml:454` `slice(0, 2)` -> `slice(0, root.allDayBandRows)` + a 2-line comment. Nothing else changed.
Result: Thu Apr 2 (4 all-day items) renders **3 chips** — y157-180 `Design sync`, y182-205 `Release notes`, **y207-230 `R087 card C`**.
The 4th (`R087 card D`) is still dropped and still has **no `+N`** — that is A04 step 2, and it has no ref anchor (the ref never exceeds 3).
Fri still 1 chip; Mon/Tue/Wed identical to 1e-3 (203.576); the four band rules unmoved (155 = 242 / interior 76 / sep 232-233 = 217 2px / hour line 234).
**Regression proof: whole-page ImageChops diff R087->R088, per-row count of pixels differing > 6 RGB-sum, has exactly ONE contiguous y-group — y207..230, max 148 px/row — and its x-range is 503..650, Thu's column alone. Everything else on the page is byte-identical.**
Slot geometry corrected: ours is inset1 + 24 + 1 + 24 + 1 + 24 + inset1 = 76, so slot content = 157-180 / 182-205 / **207-230** (the old "206-231" included gap+inset).
Figure `docs/ui-calendar/r088-allday-band-3chips.png`. md5 `4c59ed839306aa0d8fc7621e17db70b4`. Bash ≈ 8.
Next round: **A04 step 2** — the explicit overflow count for a band column with more items than slots. Design call needed (no ref anchor):
show `allDayBandRows - 1` chips + a final `+N` row (N = the items not shown), the macOS week-view convention; label it spec-only.

## R089 (round 69) — A04 step 2 PASS
Band overflow is explicit: `allDayStack.allDayOverflow` / `allDayVisible` on the band `ColumnLayout`; Repeater model = `slice(0, allDayVisible)`; a trailing `Label` `+N` in the last slot. Thu Apr 2 = `Design sync` / `Release notes` / `+2`.
Fri (1 item) unaffected. Whole-page diff vs R088 = ONE run y207..230 x503..650 (Thu slot 3 only), 3512 px.
Hoisted the third consumer of the chip ink into root `chipInk(item)`; both chip delegates binding-equivalent.
Spec-only (no ref anchor). Light + dark legs captured.

## R090 (round 70) — regression leg + the initial-scroll race (NO code change)
Fresh light leg `capture-r090.png` (md5 `e947d8a5…`) vs `capture-r089.png` (`2029858a…`). Whole-page diff = **154,551 px, 15 runs over the
whole grid** — the clean leg the plan expected did NOT occur.
Cause found in the source, not in the pixels alone: every timed chip bar moved exactly **−40 px** while the gutter labels and hour lines stayed
at the same absolute y (pitch = `hourHeight` 40 ⇒ invariant set). `CalendarScheduleView.qml:244 usefulStartHour()` returned **6** in r089
(earliest timed item 08:00 ⇒ 8−2) and **7** in r090 = its hard-coded fallback, i.e. it ran against an empty model. `positionTimeline()`
(`:270`) is driven by `autoScrollTimer` (`:283-289`, 450 ms) which re-arms on firstDate/dayCount/visible but **never on model population**
⇒ the initial scroll is a race with PIM arrival. r088 vs r089 both won it; r090 lost it.
Regression recovered by viewport-clamped realignment (r089 `274..691` ↔ r090 `234..651`): **450 px in one run at the viewport bottom**;
header+band (y0..233) differ by **163 px = the sidebar-toggle glyph's AA only**. So the band's 3 chips + `+2`, all four band rules, hour
lines, gutter labels and timed chips are byte-identical ⇒ A04 stays independently regression-verified.
Bash ≈ 21. No code touched; nothing to fix this round by design (one atomic step).
Next round: **fix the race** — make the initial scroll wait for / re-run on the model, so `usefulStartHour()` is always evaluated against
populated data (and consider whether the 07:00 fallback should survive at all).

## R091 — the "race" is the 450 ms autoScrollTimer window, not PIM arrival (CODE FIXED)
Baseline pair on the unmodified build (`leg.sh light r091a` / `r091b`): whole-page diff **154,551 px — R090's exact number** — and the Mon
x60 chip bar at `280..290` in one leg vs `320..330` in the other. Killed R090's diagnosis with a probe: a trailing `{"action":"stop"}`
(`harness/Main.qml:263` logs the pre-command `contentY`) reads **240 in BOTH legs**, while a mid-list probe showed the startup value `280`
(hour 7 = `usefulStartHour()`'s fallback for the launch week 2026-10-12..18, which carries no fixture items; hour 02 is outside the
`6..21` "today" branch). Grid lines and gutter-label ink bands are at identical y in the two legs; the *text* of the labels is one hour
apart (`07:00` vs `06:00`) and the chips follow the labels ⇒ **the capture landed inside the 450 ms `autoScrollTimer` window and showed the
previous week's offset.** No empty-model run is needed to explain it; PIM arrival was never the variable. Figure
`docs/ui-calendar/r091-pre-fix-one-hour-offset.png` (both panels stacked at 1:1, y150..470).
Fix in `CalendarScheduleView.qml:276`: `repositionTimeline()` calls `positionTimeline()` **immediately** and keeps
`autoScrollTimer.restart()` as the settle-net for an unlaid-out content item; wired to firstDate/dayCount/visible.
Verified (`leg.sh light r091c` / `r091d`): Mon x60 bars `320..330 / 400..410 / 440..450 / 560..570` **identical in both legs**, Sat x660
identical, and **whole-page diff 0 px** (the now-line is scrolled off above the viewport, so even that is quiet). md5s still differ while
the pixels do not — PNG bytes are not the instrument (R083 re-confirmed). Regression scope: one QML binding-path change; no chip, band,
grid, token or fixture touched ⇒ A04 / E01 / E02 / N02 evidence stands. Bash ≈ 24.
Next round: 仍差 #2 (band chip ring icon) if ruling H is answered; otherwise the next unblocked ref-anchored step.

## R092 — dark-leg regression closure for R091's fix (verdict only, NO code changed)
`leg.sh dark r091e` / `r091f`: `contentY 240` in BOTH `stop` probes (`contentHeight 960`); whole-page diff **0 px, 0 y-runs**
at the >6 RGB-sum threshold; md5s differ while pixels do not (R083/R091 rule, 3rd confirmation). Non-vacuous: Mon x60
saturated-bar runs `317..332 / 359..370 / 397..412 / 437..452` identical in both legs. The 0 is structural — the driven
week carries no "today", so `todayColumn = -1` and no now-line (not even the faint rule) is drawn; R085's dark ΔL 7.4 is
NOT exercised by this pair. Figure `docs/ui-calendar/r092-dark-zero-diff.png`. Bash ≈ 8.
Next round: the band chip's RING ICON if ruling H is answered (fully measured in R081: 16 / stroke 4 / inset 4 at the
vertical ratio); otherwise still-差 #2..#6 are all ruling-blocked.


## R093 — M04 colour clause: the mini month's today disc was blue, now `AppTheme.todayRed`
- **Defect.** `Main.qml:2203` drew today's mini-month disc in `root.tahoe.accent` = `#0088FF` = (0,136,255) — the one place
  in the app where "today" was not red. Every other today marker (week header disc `#E5484D` = (229,72,77) R086, now-line +
  now-dot R084, time pill `CalendarScheduleView.qml:687`) is red, and so is the ref's: the `9:41` pill and the now-line row
  both read **(235,76,70)**, the ref's mini disc **(207,51,35)** 15x15 at x91..105/y395..409.
- **Fix (R089's 2nd-consumer hoist).** `AppTheme.qml` gains `readonly property color todayRed: "#E5484D"`;
  `CalendarScheduleView.qml:111` repointed at it (identical value ⇒ no pixel change on any verified path);
  `Main.qml:2204` now reads `AppTheme.todayRed`. One literal left in the tree.
- **Acceptance** (light 1100x692, `view week` + `date 2026-10-15` + `sidebar expanded`; figure
  `docs/ui-calendar/r093-mini-today-red.png`): mini disc **20x20 at x156..175/y597..616, fill (229,72,77)**, white numeral;
  control — the week header's own today disc still **21x22 at x928..948/y126..147 = (229,72,77)**. Build 15/15 clean.
- **Still open (new 仍差 #7):** the disc is **20 px, the ref's is 15**; our mini row pitch ≈25.4 vs the ref's ≈26.7 ⇒ ~1:1 scale,
  so 15 is the target. Next round.
- **Instrument note:** the app launches with the **sidebar COLLAPSED**, so every R082–R092 leg contained no mini calendar at all;
  `{"action":"sidebar","expanded":true}` must be in the drive list. **Ruling H is still unanswered** (no rulings channel exists in
  the tree) ⇒ the band ring icon was **not** built.

## R094 — the mini month's today disc 20 → 15 (M04's size clause)
- **What.** `Main.qml:2199-2200` `width/height: 20` → `15` + the M03 comment; `radius: width / 2` follows. Same `Rectangle` is the
  selected-day marker ⇒ its 1 px accent ring is 15 too — one marker, one size. Font unchanged (`font.pixelSize: 11`). No other line.
- **Why 15 and not the spec's "18–20".** The ref's own disc is **15x15** (x91..105/y395..409), our mini month is ~1:1 (our row pitch
  ≈25.4 vs the ref's ≈26.7), and R086's precedent (the ref's diameter beat the derived literal for the header disc) applies.
- **Evidence** (light 1100x692, `view week` + `date 2026-10-15` + `sidebar expanded`; `docs/ui-calendar/r094-mini-today-15.png`):
  ours **15x15 rows 599..613 maxw 15**; ref **15x15 rows 395..409 maxw 15** — **same predicate, 1:1**. Selected ring 15x15 at
  x102..116/y599..613. Control: header disc still **22x22 rows 126..147**. No white ink outside x158..172 ⇒ `17` fits.
- **Instrument.** The disc diameter must be read as an **envelope** (`r > 150 and r > 1.6*g and b < 1.2*g`, per-row min/max), **not**
  as a count of token-coloured pixels: the white numeral carves ~40 % of the shape out and a strict token match reported 74 px for a
  15 px disc (R093's 20 px read used the same strict mask, which is why its "20x20" and this "15x15" are not directly comparable —
  the *envelope* is). A loose "reddish" mask is also wrong here: **Oct 17 is a Saturday and the weekend cell is tinted**.
- **R093's line archived out of state.md:** "the old one-hour-shift tell was the regression itself (R090's claim, corrected R091) —
  do not viewport-realign two legs by hand to 'recover' a clean diff; the decisive split is the trailing `stop` probe."
# R095 — verdict, **no code changed**: the mini month's weekday header does **not** tint today's column letter (the "red 六" was a ×2 `LANCZOS` artifact — the ref anchor and ours agree).

**The claim under test (R094's Next #1).** "`Main.qml`'s mini weekday-header row draws the today column's letter (`六`, today = Sat
Oct 17) in **red** while the other six are grey."

**The anchor, read FIRST (as instructed).** The ref's mini month is **Sunday-first** and its weekday row sits at **y378..385**.
Per-letter ink (30 % darkest mean) over the seven runs x25-27 / 46-52 / 71-76 / 94-102 / 120-124 / 145-148 / 168-172 =
**(135,135,135) (124,124,124) (161,161,161) (130,130,130) (143,143,143) (135,135,135) (130,130,130)** — **R == G == B on all
seven**, including the `W` directly above the today disc (x94-102, the Wed column). ⇒ **the ref tints nothing.**

**Our header, measured the same way.** Row `y541..549`, seven runs x21-30 / 49-58 / 77-86 / 106-113 / 133-142 / **161-170** /
190-197; the today column's letter **六 is the 6th run (x161-170)** — centred on 165.5, i.e. the same column as the today disc
(x158..172, R094). Ink 5 %-means: (154,156,162) (132,131,135) (150,149,154) (136,135,141) (157,153,171) (**150,148,153**)
(151,148,153). For 六, **warm (r−b>6) = 18 vs cool (b−r>6) = 19** — a *balanced* subpixel-AA fringe, not a hue (四 = 22/20,
日 = 16/17). And the code agrees: `Main.qml:2137-2156`, the weekday `Repeater`'s `Label` carries a single unconditional
`color: root.tahoe.labelSecondary` — **there is no `today` term to delete.**

**⇒ No defect. Verdict round: 0 code changes.** The ×2 `LANCZOS` crop that R093/R094 used for the mini month makes a 10-px grey
CJK glyph with RGB-subpixel AA *look* red; `NEAREST` and `LANCZOS` at ×8 over the *same pixels* show `五 六 日` in one grey.
**R094's Next #1 is refuted, and the last mini-month question closes.**

**Evidence:** `docs/ui-calendar/r095-header-no-tint.png` — the ref strip (x20..186 y374..390, ×5 `NEAREST`) over our strip
(x14..201 y533..553, ×5 `NEAREST`), each labelled with its per-letter ink RGB. Source pixels: `capture-r094.png` — **the same
binary, unchanged this round** (no build, no leg: R083's same-theme byte-stability plus an unmodified tree make a fresh launch a
no-op). **Deliberately no fresh leg** — a verdict round must not spend one.

**Instrument (new, → state.md 外推).** **A 10-px CJK glyph is not an ink instrument under an upscale.** Read its colour as the
**warm/cool balance** — `count(r−b>6)` vs `count(b−r>6)` over the glyph's bbox: a real red tint makes warm dominate ~10:1,
while RGB-subpixel AA keeps the two within ±10 %. Corollary: **R093/R094's ×2 `LANCZOS` mini-month crops are colour-unsafe**;
their *geometric* reads (15 px disc, 22 px header disc) stand because R094 re-verified them with an envelope predicate.


## R096 — verdict + **first-ever expanded-sidebar capture**: S04's "selected row gray radius 6" governs the compact **category** row,
not the capsule nav row; ours is already r=6 and the other two clauses hold ⇒ **0 code changes**.

**Why this round.** R095's Next #1 said the sidebar's own rows (S01/S04) had never been measured and are **not** ruling-blocked. Both
clauses were read verbatim (`spec.md:22-25`): S04 = "Checked/unchecked checkbox distinct; **selected row gray radius 6**; hover lighter
than selection"; S01 = "Neutral sidebar surface in settings palette; brighter flat calendar canvas, no blue cast/gradient".

**The ref anchor, read FIRST.** The whole ref sidebar contains exactly **one** rounded selection shape: the calendar row **"Personal"**
(fill **(226,226,226)**, **R == G == B**, rows **y102..129 ⇒ h 28**, x **10..182 ⇒ w 173**). Its per-row fill-start inset over the first
five rows is **4, 2, 1, 1, 0**; a circle of r=6 predicts 3.6, 2.0, 1.1, 0.55, 0.19 — **fits to ≤0.4 px ⇒ radius 6**. The plane is
**(237,237,237)** ⇒ **selection ΔL = −11**. Ref row pitch ≈ **26–27**. The ref's only *unchecked* row (Siri Suggestions) is a hollow
1 px coloured border at the **same x18** as the checked boxes ⇒ **the ref does not indent an unchecked row**. **No hovered row exists
in the ref** (no pointer) ⇒ clause 3 has **no ref anchor**, only the ΔL ordering.

**Which delegate S04 governs — `CategoryRow`, not `SidebarRow`.** The ref's highlighted row is a *compact checkbox row*. That is
`CategoryRow` (`Main.qml:362`): **`radius: 6`** already, `hoverEnabled: true`, 30 tall, 12 px box at inset 12. `SidebarRow`
(`Main.qml:234`) is **44 tall, inset 20/11, `radius: height / 2` = capsule 22** — a row class **the ref does not contain at all** —
and `SidebarRow.selected` is **never set true** (`todayNavigation` at `:1960` binds no `selected`), so its capsule is **dead chrome:
changing its radius would move zero pixels.**

**Ours, measured.** First ever capture with the sidebar expanded (`r096-sidebar-light.png`; light 1100x692, `sidebar{expanded}`,
`view week`, `date 2026-10-15`, `contentY 280`, capture flag **true**): sidebar **x0..219**, plane **(228,228,228)** neutral R==G==B,
**uniform within ±3 over y118..683 ⇒ no gradient and no blue cast**; canvas **255** at x221. Boxes **x12..24**, row pitch **30**.
`selectionFill` = #767680@12 % over 228 ⇒ **(215,215,216)**, ΔL **−13**; `rowHoverFill` = #747480@8 % ⇒ **(219,219,220)**, ΔL **−9**
⇒ **hover (9) < selection (13) ⇒ clause 3 holds**; our Δ13 vs the ref's Δ11 is 0.8 % of range. **Clause 1 PASS** (filled + white check
vs hollow 1 px border, both visible in the capture). **Clause 2 already satisfied.** Everything else in the sidebar (inset 12, box 12,
row 30, heading 11 pt) is S02/S03-locked and PASSing ⇒ **nothing to change, 0 code changes.**

**Why 237 vs our 228 is NOT a defect.** The ref sidebar is a **vibrancy material** — R093 already caught the same token reading
(207,51,35) there vs (235,76,70) in the grid. ⇒ **the ref sidebar's absolute greys do not transfer; only Δ's and orderings do.**
S01's clause is relational ("neutral plane + brighter flat canvas") and ours holds.

**Evidence:** `docs/ui-calendar/r096-sidebar-selection.png` — the ref's row block over ours at ×2, each panel labelled with its numbers;
raw capture `docs/ui-calendar/r096-sidebar-light.png`.

**Instrument (new, → state.md 外推).** (a) **A vibrancy sidebar's absolute greys never transfer** — measure ΔL against the sidebar's
own plane. (b) **A radius is the per-row fill-start inset**; r=6 fits the 4,2,1,1,0 signature — never eyeball it off an upscale.
(c) **The harness has no pointer-move action** ⇒ **`hovered`/`pressed` chrome cannot be driven**; such clauses are static-only (token
ordering at best) and can never be called PASS. (d) Two verdict rounds in a row is the correct outcome when the spec literals and the
ref agree: **the remaining unmeasured surface is C05, the toolbar.**

---

## R097 — C05 clause 1 (the toolbar chrome): the view segment rendered the reference's capsule with its **two fills exchanged**. FIXED.

**Scope.** C05 = "Hover/pressed/inactive chrome matches actual settings; no second capsule or conflicting controls" — the last unmeasured
row in `spec.md`'s table. Next #1's reading step (no new leg), then the fix this step implies, then **one** verification leg (`code-writer`
is unregistered; `general-purpose` was the stand-in implementer, given exact file:line + values).

**"Settings" = the settings app, settled by evidence not guesswork.** `rounds.md`'s R001 note says the window dots match
**`apps/settings/main.qml`** ⇒ "settings" is the settings app, whose chrome is `KosSettingsDialog.qml:174`/`:212` — two
`LiquidSegmentedControl`s passing **no colour overrides** (defaults: `AppTheme.button` / `AppTheme.cardHover` / `AppTheme.text` /
`AppTheme.mutedText`). Our calendar's instance (`Main.qml:1678`) overrode **four** ⇒ **one shared control, two chromes: that is literally the
"conflicting control"** the clause names.

**The reference, read 1:1 (`/tmp/r097-ref-seg-4x.png` = crop x380..630 y4..36).** Day/Week/Month/Year capsule: **track 249..253**, the
**selected** pill **230..235** ⇒ **the pill is DARKER than its own track by Δ≈20**. The pill sits over **"Week"** and the ref grid IS the week
view ⇒ **it is the selection indicator, not a hover artifact** (the one alternative reading, killed). Same construction as ours: a 51-wide
pill inset 2/side in a 226-wide 4-segment track (ours 60 in 196/3). **Both toolbars stand on white 255** ⇒ the Δ's transfer; R096's
vibrancy caveat does **not** apply here because neither side is a vibrancy layer at that row.

**Ours before (`r096-sidebar.png`, y=44).** track **229..233**, pill **254..255** ⇒ **the two fills were exchanged**: our track was the
ref's pill (Δ25 vs Δ2..6 below the plane) and our pill was `root.tahoe.contentPlane` = **#FFFFFF = the canvas itself**, so the selected
segment **vanished into the white canvas**. Root cause is a plane mismatch, and the token's own comment admits it: `Main.qml:76-82` documents
`controlFill` as *"#787880 @16% **over the sidebar plane** resolves to the #D2D2D2 the reference measures"* — a **#E4E4E4-plane** token
consumed by a **white-plane** control (renders 233 there). Independent corroboration: the round glass buttons beside it read **247..253**,
so **our own toolbar disagreed with itself by 20 levels.**

**Fix (`apps/calendar/qml/Main.qml`, 2 tokens + 2 lines; nothing else touched).** New content-plane tokens at `:94-103`:
`segmentTrack` (light `#787880@2.5%` → 252; dark `white@6%`) and `segmentPill` (**opaque** `#E7E7E7` = 231; dark `#3C3C3C` = 54), with a
measured comment; `:1715-1716` repoint `backgroundColor`/`selectionColor`. `controlFill`/`selectionFill`/`contentPlane` and
`shared/qml/controls/` untouched.

**The trap iteration 1 walked into, now an instrument.** A `#787880@17.5%` pill rendered **210**, not the 231 that over-white arithmetic
predicts: `LiquidSegmentedControl.qml:105-114` paints a `lensShadow` (**black@10% light / 24% dark**) **directly under the lens**, so the
composite is `plane − 0.10·plane` first, then the veil (255 → 227 → 210). ⇒ **the pill's reachable range under that shadow is [120, 227]
— a translucent pill can never be lighter than 227 on a white plane. Read the composite, or go opaque, whenever a target fill sits on a
component that draws its own shadow.**

**Verified (light 1100x692, `contentY 280`, `captureClient r097b-seg.png` flag `true`, `stop` probe `contentY 280`).** track
**250..252** (ref 249..253), pill **231..233** (ref 230..235), step **Δ20 = the ref's Δ20**. `docs/ui-calendar/r097-segment-beforeafter.png`
(a black-bar old-above/new-below ×3 `NEAREST` stack of the same region) is the one-read before/after proof.

**Structure — the "no second capsule" half.** Rendered capsules in the whole window: **exactly one** (the segment track). The other four
toolbar controls are 28x28 **round** glass buttons (one 40-px row: sidebar toggle · add · segment · search · more). **`GlassPill`
(`Main.qml:848`, `pillHeight` 44, "fully rounded") is DEFINED BUT NEVER INSTANTIATED** ⇒ no second capsule can render.
⚠ **Next #1's premise "the ref toolbar has no glass pill anywhere" is REFUTED** — the ref carries **two** capsules (the sidebar's 2-icon
Calendar/Reminders switcher at x≈122..190 and the centre 4-segment control at x≈389..615). ⇒ **"no second capsule" is an app-level
redundancy check (cf. L04's "no duplicate prominent New Event button"), never a count against the ref.**

**C05's pointer half — recorded, not passed.** No harness pointer action exists (R096), so `hovered`/`pressed` chrome is undrivable. But the
calendar *cannot* diverge from the settings app on interaction: hover/press is the **shared delegate**'s code (`:187-211`, `_visualIndex`,
`_pressedIndex`, `scale 0.96`), identical in every host — **the only host-variable of a shared control is its palette**, and the two
divergent palette entries were the fills fixed here. **Residue: `textColor`/`mutedTextColor` stay calendar-local** (Next #2).
"Inactive": `ToolbarButton` dims `enabled ? 1 : 0.5`; the segment has no disabled styling and nothing binds `enabled` ⇒ unobservable.

**C05 verdict: structural half CLOSED; dark leg + pointer half open.** The dark values are extrapolation (no dark reference exists) and
were never captured — the old dark pill was `contentPlane` = `#1E1E1E` = **the dark canvas**, i.e. the same vanished-selection defect, so
the dark leg is the honest next step rather than a formality.

## R098 — C05's **dark leg**, captured: the segment renders a distinct selection on the dark plane too. **VERDICT: PASS.** No code changed.

**The gap this closes.** R097 fixed the light leg with an **opaque** pill and left the dark values (`segmentTrack` white@6%, `segmentPill`
`#3C3C3C`) as **extrapolation — no dark reference exists** — while the *old* dark pill was `contentPlane` = `#1E1E1E` = **the dark canvas
itself**, i.e. exactly the vanished-selection defect the light leg had. One dark leg, one pass, no iteration: `kill` →
`start-review-vm.sh dark` → `resize 1100x692` → `sidebar{expanded:true}` → `view week` → `date 2026-10-15` → `captureClient
r098-seg-dark.png` (**flag `true`**) → `stop`; probe `contentY 280`. Figure (light-after 1:1 / dark 1:1 / dark ×3 `NEAREST`, one crop):
`docs/ui-calendar/r098-seg-dark.png`.

**Measured — capsule x562..757 (196), lens x629..690 (62): the SAME x in both legs** (the pill is on segment 2 = Week). Fill = the **mode
over the body rows y45..61**, never the top row.

| leg | plane | track | pill | pill−track | the two right round buttons (x1023..1048 / x1059..1084) |
|---|---|---|---|---|---|
| light, after R097 (`r097b-seg.png`) | 255 | 249 | 232 | **−17** | 248 |
| dark (`r098-seg-dark.png`) | 30 | **43** | **60** | **+17** | 96 |

**Both dark tokens land exactly on their arithmetic** — track 43 = `white@6% over 30` = 43.5 ✓; pill 60 = `#3C3C3C` ✓ (**an opaque fill
renders its absolute value**, so R097's shadow-reachability trap cannot bite it). The pill is **Δ30 above the plane and Δ17 above its own
track** ⇒ **the selection does not vanish. C05's dark leg PASSES.** The polarity flip (light −17, dark +17) is *extrapolation* — a symmetric
mirror of the ref's measured sink — with **no dark reference to confirm it against**. Recorded, not claimed.

**The instrument that had to be built first — A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW.** The top rows are
contaminated twice over: `LiquidSegmentedControl.qml:94-99` gives the *track* a specular `Gradient` (white@4% → black@2%) and `:128-136`
gives the *lens* a stronger one (white@9% → white@2.5%@0.58 → black@2.5%), while `:124` adds a 1px `border.color: white@16%` to the lens.
Reading the top row yields **99** where the body is **60** (dark) — a phantom 39-level error that would have been reported as a defect. The
identical overlay is measurable on the **light** leg (track 234 → 229 top-to-bottom) and **in both hosts** ⇒ **it is the shared control's own
material, never a C05 host divergence.**

**Structure re-confirmed on the dark plane, and our own map corrected.** Non-plane runs in the row: the sidebar (x0..220), the segment
capsule (x562..757), and exactly **two** round buttons (x1023..1048, x1059..1084) — the **same x as the light leg** (1026..1045 /
1062..1081; the light run reads narrower only because a 248-on-255 glass fill falls inside the `<250` threshold) ⇒ **the dark plane moved no
chrome geometry**, and "**exactly one capsule**" holds on both planes. **Correction: the capsule is y36..63 (28 tall, a 1px
`AppTheme.border` hairline top and bottom) and the lens y38..61 (24 = `height − 4`) — in BOTH legs; the earlier "toolbar row y≈22..58" is
wrong by 14.**

**C05 now: clause 1's structural half (R097) + its dark leg (R098) are CLOSED.** What remains is the label-token residue (the segment's
`textColor`/`mutedTextColor` are calendar-local — still 仍差 #2, now Next #1) and the **pointer half**, which no harness action can drive
(外推: the flat action set has no pointer-move) — structurally identical in both hosts, since hover/press lives in the shared delegate.

**Archived from `state.md` during R097 (older live instruments, kept for reference).**
- *Ref event-chip idiom (R063/R075/R077/R079/R080):* light desaturated same-hue fill + dark same-hue text + saturated same-hue left bar
  (timed) or ring icon (band) + small radius. **The ref has NO popover, menu, tooltip or hover frame** ⇒ the D/O families are
  HIG+token-anchored only. Tinted chips carry their icon at the **left inside edge** ⇒ crop the *second* chip row for a clean corner.
- *Two ring weights, rule unknown (R081):* stroke 3 / hole 6 on the tinted-wash chips; stroke ~1.5 / hole ~9 on the neutral-248 chips.
  Record the correlation only — needs ruling H.
- *Our scale is anisotropic: ×1.33 vertical, ×1.83 horizontal (R081).* A circular icon must pick one axis — the vertical ratio for
  anything that must fit the 24-px row.
- *A chip ink is settled by the coverage test plus the B−R gap (R079/R080);* `t = (fill − pixel)/(fill − ink)` must agree per channel
  (±0.05). **The hull fails as an ink instrument** — never read an ink off the extreme pixel; the top-5 %-coverage MEAN is the reproducible
  scalar. **In a chip the ring icon's colour IS `itemColor` with no alpha (R080).**
- *The ref's all-day band has two chip families, one unexplained (R080):* (a) coloured = wash + `itemColor/2` ink + same-hue ring;
  (b) neutral = fill **248**, ink **(38,38,38)** — a pair that cannot be `itemColor`/`itemColor/2` — while the ring is strongly coloured.
  **Do not cite the neutral chips for any ink or fill rule.**
- *A cross-round PNG is not position-aligned (R079, strengthened R082/R083):* for a same-theme pair even the content can be pixel-stable,
  but **measure it per region**; the file hash is not the instrument. **Two same-theme launches can have different md5s and 0 differing
  pixels.** **An equal-start tie is decided by us, and the key is the UID (R083)** — `itemStableId` then `itemTitle`, a total order.
- *A chip edge can only prove "no border" if it does not abut a rule (R078):* read a top/bottom edge as a raw profile and check
  monotonicity — a real border is a row darker *and* more saturated than the fill; a corner/AA row is *lighter*.
- *The ref bar is an absolute stroke, not a fraction of the chip (R077):* 2.4 ref px on both an 11 px and a 22 px chip ⇒ ours stays
  `chipHeight/4` regardless of duration; use the horizontal scale for its width.
- *The band's overflow row is a spec-only form (R089):* `+N` is plain `root.chipInk(hidden item)` on the band's own background, no fill,
  `leftPadding: 5`, `font.pixelSize: 9`, height bound to `allDayRowHeight`; measured Thu slot 3 = y207..230, x503..650. **The ref's 7 columns
  carry ≤3 chips ⇒ no ref anchor for its form, ink, or whether `+N` is right at all.**
- *A square joint only reads as "one bar" because the column rule is drawn through the band (R074+R076)* ⇒ the R074 separators and A03's
  rendering are **a pair**. **`itemRecord` is an injected property on `CalendarScheduleView` (R076)**; a view that omits it gets `({})`.
  **The reference week contains no multi-day all-day event (R076)** ⇒ A03's clause has no ref anchor. **All-day range arithmetic subtracts
  exactly one day, never two.** The band rules its columns with the grid's own token (R074): y=215 (band) and y=250 (grid) give the same
  run list (52/202/352/502/652/802, all 237).
- *The current-time object is four parts with one geometry source (R084):* `nowRow`/`nowInHour`/`nowLineY`/`nowLabel`/`todayColumn`/
  `nowLabelClearance` on `CalendarScheduleView`'s root — **do not re-derive a y per part.** **Our now-line, measured: pill 42×20 at
  x4..45; line 2 px at y303-304; strong segment = today's column 802..951 `(229,72,77)`; faint `(252,236,237)` (= 0.10 alpha) across
  52..1101; dot 9 px centred x=802.** The faint rule's dark-leg ΔL is half the light one's (a theme fact). **The ref's now-line is
  continuous across the whole week**, and its `9:41` pill **drops the hour label it collides with** ⇒ ours hides a label when
  `|label tick − nowLineY| ≤ 14`, and only when `todayColumn >= 0`. **A current-time capture needs `position contentY` first** (the
  launcher opens at hour 7).
- *Four local tokens own the grid's rules (R065/R067/R069):* `CalendarScheduleView.qml:51-75` — `gridLine`, `gridLineMinor` (a half-hour
  line, a different role), `allDaySeparator` (**2 px, spans the gutter**, a `ColumnLayout` sibling of the `ScrollView`), `sectionRule`.
  **One line per boundary (R065).**


**Archived from `state.md` during R098 (older live instruments, kept for reference).**
- *A DISC'S DIAMETER IS AN ENVELOPE, NOT A TOKEN-PIXEL COUNT (R094).* Read it as `r > 150 and r > 1.6*g and b < 1.2*g`, per-row min/max,
  take **max row width + the first/last rows**. A strict token match under-reports (the white numeral carves ~40 % out); a loose "reddish"
  mask over-reports (the weekend cell tint merges with the disc). *(M04 closed R093/R094.)*
- *A 10-PX CJK GLYPH IS NOT AN INK INSTRUMENT UNDER AN UPSCALE (R095).* Grey glyphs carry RGB-subpixel AA and an upscale smears the fringe
  into apparent colour. **Read the warm/cool balance instead:** `count(r−b>6)` vs `count(b−r>6)` over the glyph's bbox — a real red tint
  makes warm dominate ~10:1; subpixel AA keeps them within ±10 %. **Corollary: ×2 `LANCZOS` crops are colour-unsafe; their *geometric*
  reads stand.** *(R098 adds a second corollary: the label glyphs inside the segment carry a red/blue fringe in a ×3 `NEAREST` read — never
  judge a glyph's colour from an upscale.)*
- *THE REF'S "TODAY" RED IS ONE RED APP-WIDE (R093).* The `9:41` pill and the now-line both read **(235,76,70)**; the mini disc reads
  (207,51,35) — same token split by the sidebar's translucency. Ours is `AppTheme.todayRed` = `#E5484D` = (229,72,77), Δ≈(6,4,7).
- *THE REF ALL-DAY BAND DOES NOT EXPAND WITH ITS ROW COUNT (R087).* All 7 ref columns share **one uniform 3-row strip** while carrying
  0, 1, 2 and 3 chips ⇒ **any "the band should grow per column" claim is spec-only.**
- *OUR `timedChip` GEOMETRY AFTER R079/R080 (light 1100x692).* chip = column + 3; **fill 505-508, bar 509-512** (4 px, capsule), text
  ink from **518**. Light fill `(216,234,245)`, dark `(36,69,90)`, bar `(48,140,198)` both. **Our chip colours are NOT the ref's**: blue
  **(48,140,198)** / green **(57,196,135)** / gold **(215,166,44)**. Ours: fill `withAlpha(itemColor, .19 light / .36 dark)`, ink halfway
  to the pole, bar done, border deleted.
- *OUR `allDayChip` AFTER R080/R089.* fill `withAlpha(itemColor, dark ? 0.32 : 0.17)`; ink halfway to the pole. **Band rows 157-180 /
  182-205 / 207-230** (gap 1, inset 1, height 24); band chip inset 1 ⇒ fills 53..200 / 203..350 / 353..500 / 503..650…; Label
  `leftMargin: 5`. **R089: the model is `slice(0, allDayStack.allDayVisible)` — 3 chips when a column holds ≤3 items, else 2 chips + a `+N`
  row.**
- *MINI MONTH GEOMETRY (R093 + R094, light 1100x692, sidebar expanded, `date 2026-10-15`).* `Main.qml:2084` `miniCalendar`; day delegate
  `Main.qml:2162`; today/selected disc `Main.qml:2198-2206`. Sidebar `x0..219`; mini month rows start y≈545; **row pitch ≈25.4, column
  pitch ≈27.7, Monday-first**; the disc `Rectangle` is SHARED by the today marker and the selected marker ⇒ `width/height` = 15 for BOTH.

## R099 (2026-10-17) — C05's inactive label: one ink, not two
Next #1 was the "label-token residue" (calendar-local `labelPrimary`/`labelSecondary` vs the settings app's `AppTheme.text`/
`mutedText`), prescribed as "repoint at AppTheme if they differ". They do differ — but the reading refuted that target.

Ref crop `x385..620 y0..40`, ×4 and ×8, per-word probe (peak / top-5% mean / `n<100`):
`Day` (unsel) (0,0,0)/23/60 · `Week` (pill) (0,0,0)/11/76 · `Month` (unsel) (0,0,0)/15/85 · `Year` (unsel) (0,0,0)/20/53.
Ours: `月` (unsel) (147,145,150)/152/**0** · `日` (unsel) (140,142,147)/147/**0** · `周` (pill) (13,0,22)/21/100.
⇒ **the reference has a single black label ink; only the pill marks the selection.** The 11-vs-23 spread is the pill's darker
background lifting AA, not a second token.

Change: `apps/calendar/qml/Main.qml:1717-1722` — `mutedTextColor: root.tahoe.labelSecondary` → `root.tahoe.labelPrimary` (1
token). After (`r099-seg-light.png`, light, `contentY 280`, `contentHeight 960`): `月` 25/34/49 · `日` 11/25/38 · `周` **bit-identical**
((13,0,22)/21,12,28/100). No regression on the state that already matched. Figure `docs/ui-calendar/r099-seglabel.png`
(×4, ref / before / after).

**The refuted path is the finding:** `AppTheme.text` = `#172033` (23,32,51), `mutedText` = (100,107,120) — repointing there would
have turned a *matching* black label navy and left the unselected one 100 levels light anyway. **A shared control's host palette
is judged against the reference, not against `AppTheme`.**

**New, NOT chased (needs a ruling):** ref segment set = `Day·Week·Month·Year` (4, centres 418/474/530/587, pitch 56); ours =
`Month/Week/Day` (3, centres 594/660/724, pitch 64) — the reverse of both the ref's granularity order and L03's wording
("Day/week/month segment"). Reordering remaps `viewIndex`; not an atomic token edit. This is R100's Next #1.

## R100 (2026-10-17) — C05/L03's segment label ORDER: Day · Week · Month
Next #1 was the segment's label *list*. Reading round first (as R099 prescribed): `viewIndex` publishes 0=month/1=week/2=day and
has **five** consumers — `Main.qml:229` `activeView`, `:1544-1546` Ctrl+1..3, `:1054` `--view`, `:2372` `KosPageCache`, and
`harness/Main.qml:218` (`["month","week","day"].indexOf(command.view)`).

Ref crop ×5 of `x385..625 y12..40`: the reference reads **`Day · Week · Month · Year`**, granularity ascending, pill on `Week`.
L03's wording is "**Day**/week/**month** segment". Ours was `labels: [qsTr("Month"), qsTr("Week"), qsTr("Day")]` — the exact
reverse of both.

Change (`Main.qml:1713-1728`, 3 lines, one component): `labels` → `[Day, Week, Month]`; `currentIndex: 2 - root.viewIndex`;
`onSelectionRequested: index => root.viewIndex = 2 - index`. Week still lands on segment 1 ⇒ the pill geometry measured in
R097/R098 is untouched by construction, and none of the five `viewIndex` consumers changes semantics.

Acceptance (light 1100x692, `contentY 280` — the same leg as R098/R099): three drives over ONE live instance —
`view=week` ⇒ pill on the 2nd (`周`), `view=day` ⇒ 1st (`日`), `view=month` ⇒ 3rd (`月`). **Bidirectional, not cosmetic.**
Figures: `docs/ui-calendar/r100-seg-order.png` (ref ×4 over ours ×4, same 1:1 scale), `r100-seg-remap.png` (the three drives).

Not chased: the ref's 4th segment `Year` — no such view exists and L03 specifies three ⇒ a ruling, not a fix.

New general rule recorded: **a published index contract is mirrored in the presentation (`N-1-index`), never redefined** — the
visible order is a presentation concern and the acceptance test for it is "drive every index and check the pill".

## R101 — C05's segment pill **radius**: measured with a method validated against our own token; `0.42 → 0.48`.
**Step.** Fit `r − sqrt(r² − (r − (dy+0.5))²)` (the R096 inset method) to the pill's per-row fill-start inset, then apply the
one token the measurement justifies.
**Two false premises in R100's Next #1, both checked before acting.** (a) "the ref's pill is ~17 tall in a 28-tall track" —
the ref's pill is **h = 24** (`y12..35`; confirmed twice, run-detection and a raw column at x474). (b) "ours is 62x24 at 1:1" —
ours is **64 wide in the dark leg and 62 in the light leg**; the 2 px is the lens's own `:123-124` 1px `white@16%` border, bright
on the dark plane and invisible on the light one. ⇒ the comparison is **1:1 on both axes**; only the slot pitch differs
(ref 56.75, ours 65.33).
**Method validation.** Same fit, same interior rows dy1..22, threshold = the midpoint of that image's own two constants
(ours 241, ref 239):
`0.42`→fit **10.1** (token 10.08, +0.02); `0.46`→**11.2** (11.04); `0.48`→**11.4** (11.52); **REFERENCE → 11.7**
(sse 4.51 vs our 19.51; 13/14 rows inside ±0.5). A per-row *probe* threshold on the same ref image gives 11.1 instead ⇒ the
honest answer is the band **11.4–11.7**, ratio **0.475–0.49**. **Our 0.48 (r = 11.52) is inside it; 0.42 (10.08) was not.**
**Edit.** `shared/qml/controls/LiquidSegmentedControl.qml:121` `height * 0.42` → **`height * 0.48`**. One number, one component.
Two build/capture cycles (0.46 first, then 0.48 — the round's allowance).
**Residual misfit is material, not radius.** Our pill's top ramp is ~1.5 px longer than any rounded rect predicts and `dy0`
never crosses 241 at all: the lens's `:128-136` gradient opens at `white@9%` and `:124` adds a 1px `white@16%` border, so the
top rows sit *above* the threshold. This is R097's "a translucent fill cannot reach an absolute value" seen from the other side.
**Near-miss worth recording.** `r097-seg.png` (the obvious "before") reads a pill fill of **205**; the current light token is
**231**. Two builds 20 minutes apart, so it was NOT a valid baseline — the first fit against it produced a phantom 26-level
"the radius moved the fill" story. **Check that a before-shot's fill equals the current token before fitting anything.**
**Deliberately not chased.** The track's radius (`:87` `height * 0.38` = 10.64). The ref's track is **249 on a 255 plane** —
a 5-level edge, unmeasurable at any threshold I trust. Concentric corners would want `track_r = lens_r + 2 = 13.52` ⇒
`13.52/28 = 0.483` ⇒ **the same `0.48` constant on both** — i.e. `0.48` may be one design rule rather than two numbers. Unmeasured ⇒ unchanged.
**Figures.** `docs/ui-calendar/r101-seg-radius-3panel.png` (REF ×5 / ours-0.46 ×5 / ours-0.48 ×5, NEAREST, black-barred,
labelled), `docs/ui-calendar/r101-seg-light.png`, `r101c-seg-light.png`. Leg: light, `contentY 280`, `contentHeight 960` —
the same leg as R098/R099/R100.
**Verdict: C05's radius clause holds in the light leg; the dark leg is extrapolation. 仍差 #3 (the pill's WIDTH, 51 vs 64) is
the next item and needs no ruling.**

## R102 — the segment pill's WIDTH / horizontal slot inset. CLOSED (2 numbers, one component).
`LiquidSegmentedControl.qml:117` `x: 2 + …` → `4 + …`, `:119` `width: root.segmentWidth` → `segmentWidth - 4`.
**R101's premise was false.** The slots TILE (`segmentWidth = (width-4)/labels.length`, `x: 2 + index*segmentWidth`), so an interior pill is
adjacent to its neighbour: the true inset was **0 px/side**, not 1.2 — R101 had divided the *track width* by 3 and called the control's own 2 px
outer inset per-slot padding.
**The reference re-measured with R101's validated fit**: ref pill **W 52.4, h 24, r 11.5** on all eight interior rows (model
8.15/5.82/4.36/3.25/2.39/1.70/1.14/0.72 vs measured 7.7/5.7/4.2/3.2/2.7/1.7/1.2/0.7) ⇒ **the ref's radius token is the same 0.48; the width is
the discriminator.** Ref 52.4/56.75 slot = **92.3 %**; ours was 64/64 = **100 %**.
**After**: w **64 → 60** in the same 64 px slot = 93.75 % ⇒ 2.0 px/side vs the ref's 2.18 (0.2 px, below the ref W-fit's resolution). Track
x562..757, pill centre x659.5 and the label columns all unchanged; the radius fit re-runs to **11.5**, unchanged. Leg: light, `contentY 280`,
`contentHeight 960` — the same as R098–R101. Dark leg = extrapolation (geometry carries no colour).
**New negative result:** the ref *track*'s vertical extent is unmeasurable — its fill waves 248↔255 on a 255 plane (250 at y7-8 only over
x403..601, 255 at y9-10, 249 at y15-19, 253 at y30-32, 255 at y36-37, 248-252 at y39-43). The pill's vertical inset in the reference therefore
has no threshold. Ours stays at 2.
**Figures.** `docs/ui-calendar/r102-seg-width-3panel.png` (REF / before / after ×5 NEAREST, red lines = slot boundaries), `r102-seg-light.png`.
**Verdict: 仍差 #3's inset half CLOSED. Next: the slot PITCH (ref 56.75 vs our 64, `Main.qml:178` `segmentWidth: 196`) — check the spec literal first.**

## R103 — the segment's slot **PITCH**: `Main.qml:178` `segmentWidth: 196` is a spec literal (L03 width 180–210). VERDICT ONLY — no code changed.

**Why.** Next #1 from R102: the last unblocked *shape* error in the segmented control — the pitch (ref "56.75" vs our 64).
**R102's premise was FALSE, and it was the error R102 itself had diagnosed.** "227/4 = 56.75" is `track_width / n` — the exact bug R102's headline
names for our side; the true slot is `(W − 4)/n`, the 4 px being the control's own outer inset. Re-derived: **slot = (228 − 4)/4 = 56.0**, and the
**direct** measurement agrees — word centres **418 / 474 / 530 / 586** ⇒ pitch **55.5 / 57.0 / 56.0 = 56.0** (centroid 502.0 = the track's own centre,
so the four words are symmetrically placed ⇒ the *centres*, not the edges, are the instrument).
**The spec settles it.** `spec.md:17` **L03**: *"Day/week/month segment centered within main region; height 28 and width 180–210"*. Ours is **196x28**
(`Main.qml:171`/`:178`) and 196 is the band's **midpoint (195)**; a **3-label control at the ref's pitch = 3x56 + 4 = 172**, under L03's floor of 180,
while the floor already forces slot >= 58.67 > 56.0. => **the ref's pitch is unreachable inside L03. `Main.qml:178` `196` stays.**
**Measured 1:1.** Ref track x389..616 (W 228–229), the pill centred in its slot (fitted W 51–52.4, centre **474.0** = slot 2's centre exactly); ours
track x562..757 (W 196) unchanged, slot 64.0, word centres 595/660/723 ⇒ pitch 64.0. => **the discriminator is 4 labels vs 3, not a defect.** Side
effect: R102's "92.3 %" ratio re-reads as ref 51/56 = **91.1 %** (direct, sharp-edged) or 52.4/56 = 93.6 % (fit) vs ours **93.75 %** ⇒ our pill's
*relative* width is already >= the reference's; the residual is absolute and it is L03's.
**Negative result.** The ref **track has no measurable fill edge** — its edge pixels read **231–245** between a **250** fill and a **255** plane,
*darker than both* ⇒ a rim/shadow, not a fill boundary, so a mid-threshold fit there is invalid. Any track-edge-derived quantity is ±1 px, and a pitch
must come from the word centres (it did).
**Figure.** `docs/ui-calendar/r103-seg-pitch-2panel.png` — REF x3 and ours x3, NEAREST, **blue = track edge, green = slot boundary, red = word centre**,
captions on the final canvas (text drawn before an x3 upscale would be illegible; the canvas height must include the caption block).
**Verdict: 仍差 #3 CLOSED in full. Next: the track radius at `LiquidSegmentedControl.qml:87` (0.38) vs the lens's 0.48 (R101).**

## R104 — the segmented TRACK's radius: `LiquidSegmentedControl.qml:87` `height * 0.38` -> **`height * 0.48`** (10.64 -> 13.44 on the 28-tall track).

**Why this round.** Next #1 from R103: the last unmeasured *shape* constant in the segmented control and the last unblocked item in C05.

**The absolute measurement is DEGENERATE — recorded as a negative result.** A least-squares rounded-rect fit
`x(y) = x0 + r - sqrt(r^2 - (r - (y - y0))^2)` to the **rim-core trace** (argmin of the luma per row, both edges, mirrored about
x=502) recovers the **reference** track at **r = 11.25** (SSE 0.28, y0 9.5, y1 37.5, H 28.0) and, on the same rows, at **r = 13.50**
(SSE 0.15, y0 8.5, y1 38.0, H 29.5) — **r and y0/y1 are not separable when only the arc is visible**, and the two run a tie.
The instrument validated on our own track (true r = 0.38 x 28 = 10.64) reads **11.00** — a **+0.36 bias**, and the bias *flips sign*
(-1.14) when the two rows of horizontal top/bottom edge are left in. ⇒ **the reference's track radius is NOT absolutely measurable
beyond r in [11, 13.5] on H ~ 28-30.**

**The decisive instrument is WITHIN-IMAGE, and it cancels that bias.** Compare the track's corner *inset profile* — per row, the rim
core's x minus its own nadir column — against **the same control's own lens**, same image, same rows, same method:

| dy from the rim's top row | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| **REF track** (col 388, top y9) | 7 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | 1 | **0** |
| **REF lens** (col 450, top y12) | 6 | 4 | 3 | 2 | 1 | 1 | **0** | | | | |
| **ours BEFORE** (col 562, top y36) | 6 | 4 | 3 | 2 | 1 | 1 | 1 | **0** | | | |
| **ours AFTER** | 8 | 6 | 5 | 4 | 3 | 2 | 2 | 1 | 1 | **0** | |

The reference's **track** corner is uniformly **1-2 px wider (rounder) than its own lens's** at every depth. **Ours before was
IDENTICAL to our lens's** (both nadir at dy 7-8) — the outer capsule's corner was exactly as tight as the inner one, which is
geometrically what a concentric pair must not be. ⇒ **the defect was a two-token capsule (0.38 outer / 0.48 inner), not a radius value.**

**The fix is therefore one token, not a new number: `0.48` on both.** `:87` `height * 0.38` -> **`height * 0.48`**: track r
**10.64 -> 13.44**, lens r unchanged at **11.52** (R101), delta **1.92** against the **2 px** lens inset ⇒ **concentric by construction**
(the 0.08 px shortfall is sub-pixel). Our AFTER profile then reproduces the reference's to **<= 1 px on every row** (see table), and
the ref's own numbers agree: its track H measured **30** by rim-core span (ours 28, hard in QML) ⇒ ref r/H **0.46-0.48** = **the same token.**

**Scope, stated.** `:87` is inside the shared control, so this is app-wide by construction — `KosSettingsDialog.qml:174` and `:212` and
`WallpaperPreviewBar.qml`. It is a fix rather than a regression there because the token is now the one the *lens already used*, so every
host gains a concentric pair. **`:117/119` (R102) and `:121` (R101) untouched.**

**Figure.** `docs/ui-calendar/r104-track-corner-3panel.png` — **REF / ours-before / ours-after**, the track's left-end corner at **x6 NEAREST**,
each anchored on its own rim top-left; captions on the final canvas.

**Verdict: C05's track radius CLOSED — the last unblocked *shape* constant in the control. What remains of C05 is the pointer half
(no harness action drives it) and the label COUNT (ruling-blocked).**



---

# R105 — L03 PASS (5/5 clauses). Verification only: no build, no leg, no source file touched.

**Why.** Next #1 from R104. L03's control was edited in five of the last eight rounds and is now frozen; everything left in 仍差 is
ruling-blocked and no rulings channel exists. So the highest-value unblocked step is verification.

**Clause (c) — "centered within main region" — was the one clause never directly measured, and it needed a definition of the region.**
Ours: the sidebar's plane ends at x=220 (px[220,300]=224, px[221,300]=255) ⇒ main region 221..1099, centre 660.0; the track's rim spans
562..757, centre 659.5 ⇒ **-0.5 px, -0.057 % of the region width**. The reference measured the same way: its 237-plane ends at **x=191**
⇒ main region 192..813, centre **502.5**; its track's rim spans 388..616, centre **502.0** ⇒ **-0.5 px, -0.080 %**. **The same convention,
the same absolute residual.**

**This corrects a figure the ledger has carried since R063.** The ref's "243px sidebar" conflated the sidebar WITH the hour gutter: 192..243
is a white gutter whose right-aligned hour labels end at x≈242, and 243 is where the first *day column* starts. Measured against the grid
(243..812, centre 527.5) the ref looks **25 px mis-centred**; against the region it is centred to 0.5 px. **Any ref-centredness number
derived from "grid 243..812" is void.**

**The other four clauses, re-measured on the same capture.** (a) QML `196`, and the render agrees — the rim's widest row (y=50) reads
562..757 = **196**. (b) **28** tall (y36..63, both x570 and x660). (d) label ink centres **595.6** / **723.5** = the centres of slots
(562+4)+i*64, with the pill occupying slot 1 ⇒ order **Day · Week · Month** (R100). (e) the pill (fill 232, span 630..689) is on **Week**
and the leg ran `--view week`.

**Observation, not a finding.** Under this locale the labels render 日/周/月 — single CJK glyphs, ~10-11 px ink runs, which is what
R099/R100/R102 actually measured. L03 names the segment semantically; the locale is not one of its clauses. Recorded so 仍差 #1 is not
re-opened on this evidence.

**Figure.** `docs/ui-calendar/r105-l03-centre-2panel.png` — REF above, OURS below, **each rescaled so its own main region is 700 px wide**;
blue = rim span, grey = rim centre, green = region centre. Both green lines land within 1 px of x=350.

**Verdict: L03 PASS (5/5). The first ID of the final regression chain is closed.** Next: A01.

## R106 - A01 clause (a): the all-day band's MINIMUM height (26, was a hard 76)
**Atomic step:** the standing Next-round #1 - build A01's clause table, then act on the one clause that is neither closed nor G-blocked.
**The table.** spec vs ref: (a) min ~28 / **20** - (b) row 18 / 18 - (c) gap 2 / **1** - (d) inset 2-3 / **1**. (c)+(d) are the G erratum, (b) is ref-anchored (24 = 18 x our 1.33),
so **(a) was the only open clause - and it was open because it was UNOBSERVABLE**: `allDayBandRows: 3` was a hard constant, so the band was 76 px in a week with four all-day items
and 76 px in a week with none. R075's "all four clauses match the ref" was an inference from one 3-row week.
**Ref re-read 1:1 before editing** (`refs/macos-calendar.png`, crop x300..620 y118..200): the band **hugs** its rows - top rule y124, first chip y126, last row ends y181,
bottom separator y183-184 => a 1-row reference band is 1+18+1 = **20**, not 60. A fixed box cannot reproduce that shape.
**Change** (`CalendarScheduleView.qml`, 3 edits): `:64` `allDayBandRows: 3` -> **`allDayMaxRows: 3`** + new **`allDayContentRows`** (max `allDayItems().length` over the 7 columns)
+ **`allDayBandRows: Math.max(1, Math.min(allDayMaxRows, allDayContentRows))`**; `:483` R089's `allDayOverflow` re-pointed from `allDayBandRows` to **`allDayMaxRows`** (else a
1-item column in a 1-row band renders `+1` instead of its chip); `:411` the gutter `all-day` label `Layout.preferredHeight: 48` -> **`root.allDayBandHeight`**.
**Captures** (light, sidebar expanded, ONE launch, three captures): `r106-band-min.png` = week of Apr 6, **0 all-day items** -> 155 rule / **156..181 = 26** / `allDaySeparator`
182-183 / first hour line 184. `r106-band-3row.png` = week of Apr 2 -> 155 / 156..231 = **76 unchanged**, chips 157-180 + 182-205, **A04's `+2` still in slot 3 (207-230)**,
232-233, 234 = the R073-R104 map byte for byte. Gutter `all-day` label ink rows **167-174 on both legs** (the label edit moved nothing). Figure
`docs/ui-calendar/r106-a01-band-min-3panel.png` = ref 1:1 / ours 3-row / ours 0-item, red = section rule, blue = band bottom.
**Verdict: A01 clause (a) PASS** - 26, against the ref's own 1-row band 20 x 1.33 = **26.6** and the spec's "about 28" (-7 %). => **A01 = PASS-pending-ruling-G**.
**Two new load-bearing measurements, both from the same capture pair:** (1) **our weeks start MONDAY**, and an **expanded sidebar shifts the day columns to pitch 119**
(separators 272/391/510/629/748/867/986) - so `x=577`, the column every band measurement since R073 profiled as "Thursday", is the **3rd** day column; **Thursday is 629..747**
(x~690). The y-map is x-independent, so every vertical number stands. (2) An **all-day-empty week keeps a 26 px band** (the min reading); the ref has no empty week, so
hide-vs-26 is an extrapolation, not a finding.
**Not touched:** `allDayRowHeight`/`allDayRowGap`/`allDayBandInset`, the four rule tokens, the chip radius, A03's end-radius logic, the weekend tint, `hourHeight`, the fixture.
1 build + 1 launch + 3 captures, 19 bash calls, ~20 min.

## R107 — A02 re-verified on the R106 capture pair: all three clauses PASS (verification only, **no code changed, no build, no leg**)
Atomic step: **measure A02 clause-by-clause on `r106-band-min.png` (0 all-day rows) + `r106-band-3row.png` (3 rows)**, plus the ref's junction; classify each clause closed / blocked / open. 12 bash calls, 3 image reads.
**Why:** A02 was marked PASS at R087, but until R106 `allDayBandRows` was a hard 3 — "the band **expands** uniformly" had no observable subject.
**(a) expands uniformly — PASS (internal law).** 0 rows -> band 156..181 = **26** (the 1-row floor); 3 rows -> 156..231 = **76**: **+25 per row** (`2 + 24N + (N-1)`). In the 3-row leg the rows are **24/24/24, gaps 1/1** (157-180 / 182-205 / 207-230) — no row stretches. `sectionRule` **pinned at 155 on both legs** (downward-only growth); everything below translates by exactly **+50** (`allDaySeparator` 182->232, grid top rule 184->234). The ref has ONE band size, so it cannot witness expansion -> the middle of the range (1-2 rows) is **not in the fixture**; recorded as an extrapolation.
**(b) shared bottom edge — PASS (ref-anchored).** REF: last band row ends 181 -> **2px 217 at 183-184** -> **1px 244 at 185** -> field 250. OURS: last row ends 231 -> **2px 217 at 232-233** -> **1px 237 at 234** -> field 255. Same three-row structure, same separator token, 100 % row coverage across all 7 columns on both legs — the band's bottom edge *is* the grid's top edge, no gap, no second box, no header strip.
**(c) subtle stronger separator — PASS (ref-anchored).** REF separator 217 vs its own `sectionRule` 124 = **242** and its in-grid rules 242-249 => **d >= 25**, and **2px** where every other rule is **1px**. OURS 217 (2px) vs `sectionRule` 242 (1px) / hour 237 / half-hour 244 => d 25 and 20; the ordering **242 / 237 / 244 > 217** holds on both legs.
**Correction to the R106 record:** `r106-band-2row.png` is **NOT a 2-row leg** — its band rows 155-244 are numerically identical to `r106-band-3row.png` (row means equal to 2 dp); the two differ only in **37 rows inside 126-571** (day header + timed grid). It is the same 3-row band on a different date, so it is a **reproducibility** witness, not a middle-of-range one. => the fixture's all-day capacity in a column is {0, 3} only.
Figure `docs/ui-calendar/r107-a02-shared-edge-3panel.png`: ref / ours-3row / ours-0row, 28 rows at x5, each anchored 6 rows above its separator, red = 2px 217 separator, blue = grid top rule.
**Verdict: A02 PASS 3/3.** Next round #1 = **A03** on the same capture (the `Multi-day review` strip Mar 30 -> Apr 3 renders as one chip per day across Mon/Tue/Wed — "visually continuous, only outer corners rounded" is exactly the question that capture can answer).

---

## R108 — A03 measured: corner clause PASS (witnessed), continuity clause OPEN; the overlap fix produced a DARKER seam and was reverted

Atomic step: **A03 on the R106 capture** — 1 source hunk written, built, launched, captured, measured, **then reverted** (the attempt failed on its own evidence) and rebuilt. 2 builds, 1 launch, 1 capture. Figures: `docs/ui-calendar/r108-a03-bandform-2panel.png`, `docs/ui-calendar/r108-a03-joint-before-after-x10.png`.

### Verdict
- **"only outer corners rounded" — PASS, witnessed.** Mon [rounded-left / square-right, right edge **388 on every row 157-180**], Tue [square/square, **392-507 constant**], Wed [square-left 511 constant / rounded-right **622@157 -> 626@163 -> 622@180**]. Single-day neighbours Thu 630-745 and Fri 749-864 round on **both** ends. Mon's left ramp **277@157 -> 273@163 -> 277@180**. Implementation: `CalendarScheduleView.qml:540-547`.
- **"visually continuous" — OPEN.** Every inner joint reads: fill 220 -> **255, 255** -> gridLine **237** -> fill 220 = a **3 px light break** per day boundary. x=391 reads 237 for **y156-230**, so the day-column separators run unbroken THROUGH the band (A01's own design).
- **The ref cannot arbitrate the continuity clause.** Every ref band chip is single-day (row 1: `Antonio...`(Sun) / `FaceTi...`(Mon) / `April Fool...`(Wed) / `Take o...`(Thu) / `Good Fri...`(Fri)); each is its own rounded pill inset ~6-7 ref-px from its column rule (Wed **494-562** in a **487-569** column) with the 242-weight rule at 324/406/487 visible between them. There is **NO multi-day bar** anywhere in the capture. A03's continuity clause is an internal law, judged on the spec sentence, exactly like A02's clause (a).

### Attempted fix and why it failed
`Layout.leftMargin` / `Layout.rightMargin: continuesX ? -(allDayBandInset + 1) : 0` on the chip delegate. The break closed, but the joint then read **390 = 191, 391 = 205** against a **220** fill. Cause: `:548` paints the chip as `AppTheme.withAlpha(itemColor, 0.17)`, so two overlapping chips composite TWICE: 191 = **29/255 = 11 % DARKER** than the bar. An overlap trades a light gap for a dark seam. Reverted; tree rebuilt (source fingerprint unchanged from R107).

### Load-bearing findings
1. **A TRANSLUCENT CHIP CANNOT BE JOINED BY OVERLAP.** A "close the gap" fix must be an OPAQUE pre-blend — `AppTheme.mix(backdrop, itemColor, a)` (`AppTheme.qml:197`, returns alpha 1) — not a negative margin. Then the extension can be generous on both sides and immune to the +/-1 rounding.
2. **THE JOINT'S 3 px IS ONE PIXEL OF SLACK IN THREE PIECES.** A column is 119.0 px (833/7) and draws its own 1px separator as its FIRST pixel; the chips sit in a `ColumnLayout` inset `allDayBandInset: 1`. So a chip is 116 px inside a 119 px column, and the joint = 2 px field (column leftover + layout rounding) + the neighbour's separator + the neighbour's own 1 px inset. The leftover is known only to +/-1, which is what disqualifies an exact-fit margin and makes an overlapping one necessary.
3. **THE NEXT COLUMN'S SEPARATOR IS DECLARED AFTER THE PREVIOUS COLUMN'S CHIPS** (it belongs to that column's own delegate, which is later in the RowLayout). So only a **LEFT**-extension by the neighbour — covering its OWN separator — can hide a rule; a right-extension can never cover it.
4. **THE OPAQUE-CHIP REFACTOR NEEDS THREE BACKDROPS**: the weekday field **255 light / (30,30,30) dark**; the weekend `weekendField` `#F9F9F9` light / `white@0.03` dark — itself translucent, so it needs compositing first. And it cannot be signed off on a light leg alone.
5. **A 246..253 FILL DETECTOR CANNOT SEPARATE THE REF'S 249 WEEKEND TINT FROM ITS 250 CHIP.** The ref's "band row 1 at x 733-811" reads 246-253 on EVERY sampled row — that is the Saturday tint, not a chip. The discriminator is each column's OWN background.

## R109 — A03 clause (b): the band chip becomes opaque, and the run joins. PASS.
Atomic step: **A03 clause (b)** — the ONE open item in state.md that was not blocked on a ruling.

**The step.** Three hunks in `apps/calendar/qml/CalendarScheduleView.qml`, plus a fourth one-line guard:
1. `:114-134` — a local `scheduleField` token (`#FFFFFF` light / `#1E1E1E` dark, tracking `Root.tahoe.contentPlane` at `Main.qml:47-48`) and
   `allDayBackdrop(column)`, which returns the field for a weekday column and the field with the weekend tint already **composited** into it for a
   weekend one. The composite is the point: `weekendField`'s dark leg is `white@0.03` — translucent — so feeding it straight to `mix()` would drop
   its alpha and start the blend from the untinted field.
2. `:87-92` — `allDayJointOverlap: 4`, beside `allDayBandInset`.
3. `:551-562` — the chip's `color` went from `AppTheme.withAlpha(itemColor, 0.17|0.32)` to
   `AppTheme.mix(root.allDayBackdrop(allDayColumn.columnDate), itemColor, 0.17|0.32)` (alpha 1 by construction), and the chip gained
   `Layout.leftMargin: continuesLeft && allDayColumn.index > 0 ? -root.allDayJointOverlap : 0`. `:568` — the Label's left margin adds
   `allDayJointOverlap` back, so the title's x is unchanged on a continuing chip.
4. The `index > 0` gate is beyond the plan: `allDayContinues()` (`:243-252`) is pure date arithmetic, so on column 0 it returns true for an item that
   started in the *previous* week — with a reach attached, that would paint 4 px into the gutter with no rounding column to absorb it.

**Cost.** 2 builds, 2 launches, 2 captures. Second capture vs first: `ImageChops.difference` bbox covers the page but **max 1/255** — the gate is
invisible on this fixture, exactly as predicted, because Mon is column 0 and `continuesLeft` is false there.

**Measurement (light leg, 1100x692, `date 2026-04-02`, sidebar expanded, `contentY 240`).** Run-length scan of band rows 157/163/168/180:
the fill envelope is **Mon 273 … Wed 626 with no break**. At joint 1 the pixels **388..393** and at joint 2 the pixels **507..512** all read
**`(220,235,245)`** on every band row — **no 255, no 237**. R108's `389,390 = (255,255,255)` + `391 = (237,237,237)` are gone.
Outer ends still ramp: Mon **281@157 → 273@165 → 281@180**, Wed **618@157 → 625@163 → 618@180**. Single-day neighbours unchanged and still
rounded on both ends: Thu **638→630→638**, Fri **757→749→757**. The Saturday 249 tint runs 868..879 untouched.

**Fill identity.** `mix(field 255, itemColor, 0.17)` = **`(220,235,245)`** — the same value the translucent overlay produced over white, so the
bar's colour did not move; only its opacity did. This is why the change is not visible anywhere except the joints.

**Verdicts.** A03 clause (a) **PASS** (re-read on this capture, carried from R108). A03 clause (b) **PASS**. **A03 is now PASS on both clauses.**
The dark leg (alpha 0.32, and the weekend branch of `allDayBackdrop`) is **unverified** and is next round's #1.

**Still open / not fixed, recorded only.** `:550`'s `opacity: root.itemCompleted(...) ? 0.5 : 1` re-creates the same defect class this round removed —
item opacity composites the chip against what is below, so two overlapping 50 % chips would stack darker than the bar. No completed all-day item
exists in the fixture.

**Artifacts.** `docs/ui-calendar/r109-a03-joint-2panel.png` (1:1 band strip with green/magenta joint guides above a pair of ×6 joint zooms).

---

## R110 — the dark leg of A03 clause (b): the run is continuous on dark too. PASS.

**Verification only. 0 source files touched, no build.** One kill+relaunch (`start-review-vm.sh dark` — the theme is fixed at launch), the same
drive list as R109 (`resize 1100x692` / `sidebar expanded` / `view week` / `date 2026-04-02` / `position 240` / `captureClient` / `stop`), one
capture. The leg read back as `contentY 240 width 885 height 458 contentHeight 960` — identical to R109's light leg, so the two are comparable.

**Why the dark leg needed its own read.** R109's fix is a *pre-blend*: `mix(backdrop, itemColor, alpha)` with `alpha = dark ? 0.32 : 0.17`. Two of
its three inputs change on the dark leg. `allDayBackdrop`'s weekend branch composites a **translucent** `weekendField` (`white@0.03`) rather than
using it raw; and the alpha is nearly double. A joint can read continuous while every chip is the wrong colour — the joint test alone cannot see
that, so this round measured the fill's absolute value as well.

**Clause (b) — the joints.** At joint 1 (`385..393`) and joint 2 (`504..512`), **every pixel of every band row 157–180 equals the chip fill
`(36,65,84)`**. Not one pixel of field tone `(30,30,30)` and not one of the separator tone `(59,59,59)` — the dark leg's rule is `white@0.13` over
the 30 field. A separate contiguous-run test agrees: rows **157–164** and **175–180** (the rows the label ink does not touch) each resolve to a
**single** fill interval `274..625`. The rows in between (165–172) are broken only by the *text* — the label ink sits 22+ px clear of both joints
on every row, which is why the per-pixel joint probe still reads all-fill there.

**Clause (a) — the ends.** The envelope ramps **281@157 → 273@165–172 → 281@180** on the left and **618@157 → 625@165–172 → 618@180** on the right
— the same 8-px corner ramp R109 read on light, unchanged.

**Fill identity (the part the joint test cannot prove).** Measured fill **`(36,65,84)`**. Back-solving `30 + a·(accent − 30)` with `a = 0.32` gives
accent ≈ `(49,139,199)`; R109's light leg back-solved to `(49,137,196)`. Two legs, two alphas, two backdrops, agreeing inside rounding — so the dark
pre-blend starts from the **weekday** field `30`, not the weekend's `37`, and uses `0.32`. The two failure modes are numerically excluded: a **37**
backdrop would read `(41,70,89)` and the old light alpha **0.17** would read `(33,49,59)`.

**Weekend columns, recorded not claimed.** The Sat/Sun columns are pure `(37,37,37)` at (1000,300) and (900,600) — the weekend *field* is the
documented composite. No weekend all-day **chip** exists in the fixture, so a weekend chip's backdrop is still unwitnessed.

**Verdicts.** A03 clause (a) **PASS** (re-read). A03 clause (b) **PASS on the dark leg**. **A03 is now PASS on both clauses and both legs.**

**Artifacts.** `docs/ui-calendar/r110-a03b-dark-joint.png` — a 1:1 dark band strip (x260-640) with green guides on the two joints, above a pair of
x6 joint zooms, over a stacked caption block.

# R111 — **T01, T02 and T03 PASS on a fresh light leg.** R109's band work did not disturb the grid's three rules. Hour rules `(237,237,237)` and half-hour rules `(244,244,244)` land on *exactly one* row each at pitch **20/20**; the hour pitch is **40.0** across 11 consecutive intervals with `contentHeight 960` = 24x40; the tone ordering **242 < 237 < 217** holds; every tone is neutral `R=G=B`, so `gridLine` has not drifted to the blue-tinted `AppTheme.border`; and every gutter label's 9-row band centres **exactly on its own tick**, right-aligned with a **gap of 8** to the grid line at x272.

**Why this round.** T01/T02/T03 were PASS-pending-final-regression from R064-R066 — and R109 rebuilt the binary, so every figure that witnessed them predates the opaque all-day fill. This round is the re-read on the current build: **0 source files touched, no build**, one kill+relaunch to the light theme, one capture, one read.

**T01 — the pitch.** A gutter ink scan over x222..272 gives label bands at y270-278, 310-318, 350-358, ... 670-678. Their centres are **274.0 / 314.0 / 354.0 / 394.0 / 434.0 / 474.0 / 514.0 / 554.0 / 594.0 / 634.0 / 674.0** — **11/11 diffs of exactly 40.0**. The rule profile at x274 (the first day column's bare left edge) alternates **237 at 234/274/314/354/.../674** and **244 at 254/294/334/.../654** — hour-to-half and half-to-hour both **20.0**. The harness logs `contentHeight 960` = 24x40. The hour rules span **x272..x1099**, from the grid's left edge to the window's *last* pixel: the grid is not clipped short on the right, and the viewport's bottom (y691 = 234+458) is grid content.

**T02 — the rules.** `sectionRule` y155 = `(242,242,242)`; `allDaySeparator` y232-233 = `(217,217,217)`, 2 px; grid top rule y234 = `(237,237,237)`; in-grid hour `(237,237,237)` / half-hour `(244,244,244)`. All four are neutral, so the ordering **242 < 237 < 217** is the ref's and no rule has picked up the blue-tinted `AppTheme.border` (which renders 223/225/228 and would invert it). **Nothing stacks:** the profile y272..278 at x276 is non-white on **y274 alone** — one row per boundary, so R065's 2 px `(223,225,228)` defect has not returned. The day/gutter separators are **1 px 237** at **272/391/510/629/748/867** (pitch 119), and chips still paint above the lines.

**T03 — the labels.** Each label band is **9 rows** (font 11) and its centre sits **exactly on its own tick** — e.g. the 07:00 band is y270..278, centre **274.0**, and the hour rule is at y274. Ink runs **x238..264**, so the right gap to the grid line at x272 is **8** — inside the contract's 6-8, and identical to R066's collapsed-leg reading (ink 44, line 52).

**By-products, and one artifact of the leg.** In a rule row the only non-white pixels left of x272 are the label's own ink: **the rules do not cross the gutter**. And at `contentY 240` the topmost visible label is hour 6, whose 9-row band would be y230..238 — the rows above y234 are outside the scroll viewport, so the capture shows **234..238** and the visible band's centre reads 2 px late. That is clipping, not misalignment: the clipped band's ink x-extent is **identical (238..264)** to its siblings, and the full band's centre (234) is the tick.

**Verdicts.** T01 **PASS**, T02 **PASS**, T03 **PASS**. The T dark leg's tones (`gridLine` 59 / `gridLineMinor` 43) were read R065 and are **not** re-witnessed since R109's rebuild — one dark leg is owed before T is called final-regressed.

**Artifacts.** `docs/ui-calendar/r111-t-rules-3panel.png` — a 1:1 strip (x221..1100, y146..300) with colour-coded guides drawn in the empty gutter, above an x6 contrast-stretched rule stack, an x6 honest junction zoom, and an x6 honest label zoom, over a stacked caption block.



## R112 — M01/M02/M03 PASS on the light leg; the first mini-month reading at the EXPANDED sidebar geometry (verification only)
**0 source files touched, no build, no new leg** — R111's `r111-t-rules-light.png` is the same binary. Figure `docs/ui-calendar/r112-m-mini-month.png` (the ref's mini month above ours, both 1:1, magenta = our column centres, blue = the ink's own bottom row, green = the block's margins).
- **M01** block edges **x12..x208** of a **220** px sidebar => **12 / 12**, the same `categoryInset` the groups use (their ink also starts at **x12**); `cellWidth 196/7 = 28.0`, `cellHeight 21.0`, height pinned min = preferred = max; **no scrollbar anywhere in the sidebar** (x211..219 pure 228 at y100/300/500/650) => the category list cannot press on the block.
- **M02** arrows are **byte-identical mirrored ink boxes** (left x24..28, right x192..196, both y523..528) => **84.0** each side of the sidebar centre **110.0**; title ink 78..141, centre **109.5**; column centres **26.0 + 28.0i**, pitch **28.0 on 6/6** in all six date rows and in the weekday header; row band tops **561 + 21.0i**, pitch **21.0 on 5/5**.
- **M03** `font.pixelSize: 11`; all six bands are **9 rows** at the same +0 offset (561..569 / 582..590 / 603..611 / 624..632 / 645..653 / 666..674) => one baseline; 2-digit ink 12 px (20..31) and 1-digit 6 px (23..28) both centre **26.0**; `background: null`, and **no >100 px run of any 200..227 tone in any row or column** of y505..690 — between bands the field is 216/216 px of pure (228,228,228).
- **Calibration (load-bearing):** a pixel run p..q is the half-open interval **[p, q+1)**, so its centre is **(p+q+1)/2**. The inclusive form `(p+q)/2` gave an **impossible** 11.5 / 12.5 margin split (both margins are the same `categoryInset` property); the half-open form reproduces **12 / 12**. Corollary: a gap written as `line - last_ink_pixel` is the inclusive form and reads 1 larger than the continuous gap.
- **By-products:** (i) our chevrons are **4x5 px** of ink vs the ref's **9 px** tall — equal to each other, so M02 holds, but an unfiled ref-fidelity gap (仍差 #7); (ii) the Apr 2 disc is the M04 selection surface (15x15 `selectionFill` + accent number + 1 px border); (iii) the archived "mini month weekend cells (214,214,215)" **did not reproduce** — the field is pure 228 across, Sat/Sun included, and the 214 is the **selection disc's antialiased rim**.
### ARCHIVED OUT OF state.md AT R112 (the CLOSED-history block; rounds.md is the record)
- **- **CLOSED in R111: T01/T02/T03.** The grid's three rules re-read on the current build: pitch 40.0 / half 20.0, tones 237/244 one row each, ordering 242 < 237 < 217, label centres on their ticks with gap 8. **No further work on T.**
- **CLOSED in R110: the DARK LEG OF A03(b).** Both dark joints read the chip fill on every band row; the ink-free rows are one interval. **A03 clause (b) is now PASS on both legs.**
- **CLOSED in R109: A03 clause (b).** Both inner joints read the chip fill across the run; clause (a) re-witnessed on the same capture. **A03 is now PASS on both clauses.**
- **CLOSED in R107: A02 — all three clauses PASS.** (a) expansion witnessed (**+25/row**); (b) the band's bottom edge *is* the grid's top edge; (c) 217 vs 242/237/244.
- **CLOSED in R106: A01 clause (a) — the band's MINIMUM height.** 1 row = **26 px**. A01 = PASS-pending-ruling-G.
- **CLOSED in R105: L03 — ALL FIVE CLAUSES PASS.**
- **CLOSED in R104: C05's TRACK RADIUS** — `:87` `0.38` → `0.48`. ⇒ C05 spec-complete but for the label COUNT (ruling-blocked) and the pointer half (undrivable).
- **CLOSED in R103: 仍差's pitch question — the slot PITCH is spec-mandated.** `Main.qml:178` `196` stays.
- **CLOSED in R102/R101/R100/R099: the pill's padding and radius, L03's label ORDER, C05's label token.** **R098: C05's dark leg, R097: clause 1's chrome.**
### ARCHIVED OUT OF state.md AT R112 (the outgoing 最近已改 tail)
7. R104 — **C05's segment TRACK RADIUS**: `LiquidSegmentedControl.qml:87` `height * 0.38` -> **`height * 0.48`**.
- **THE REFERENCE'S SEGMENTED CONTROL HAS **ONE** LABEL INK (R099, load-bearing).** **`n<100` discriminates an ink *token* difference from an AA-coverage difference.**
- **A PUBLISHED INDEX CONTRACT IS MIRRORED IN THE PRESENTATION, NEVER REDEFINED (R100).** `viewIndex` (0=month/1=week/2=day) has five consumers.
- **A SEGMENT FILL IS THE MODE OVER ITS BODY ROWS, NEVER THE TOP ROW (R098).** **R101: the lens's 1px white@16% border makes the DARK leg measure 2 px wider (62 vs 60) — a capture comparison must state its leg.**
- **A TRANSLUCENT FILL CANNOT REACH AN ABSOLUTE VALUE WHEN A SHADOW SITS UNDER IT (R097).** Reachable range **[120, 227]** on white.
- **A SHARED CONTROL'S PALETTE IS THE ONLY THING A HOST CAN DIVERGE ON (R097–R099).**
- **R096 (compressed): THE REF'S SIDEBAR IS A VIBRANCY MATERIAL — ITS ABSOLUTE GREYS DO NOT TRANSFER** (compare ΔL only), and **A RADIUS IS THE PER-ROW FILL-START INSET**.
- **THE HARNESS HAS NO POINTER-MOVE ACTION (R096).** `captureClient{path}` / `escape` / `resize{width,height}` / `sidebar{expanded}` / `view{view}` /
- **THE APP LAUNCHES WITH THE SIDEBAR COLLAPSED (R093).** `{"action":"sidebar","expanded":true}` must be in the drive list.
- **A LEG'S `contentY` IS A FIRST-CLASS INSTRUMENT — PUT `{"action":"stop"}` AT THE END OF THE DRIVE LIST (R091).** **R109's leg read `contentY 240 width 885 height 458 contentHeight 960`.**
### ARCHIVED OUT OF state.md AT R112 (the R091-R100 toolkit bullets: the pointer-action limit, the launch facts, and the segment/ink instruments - all covered by the HARNESS + MEASURING bullets)


# R113 — **T01, T02 and T03 PASS on the DARK leg** — T is now re-read on **both legs of the current build**. Hour rules **(59,59,59)** and half-hour rules **(43,43,43)** each occupy **exactly one row** at pitch **20/20** (25 consecutive diffs of exactly 20 => hour pitch **40.0**, `contentHeight 960` = 24x40); the ordering **39 < 59 < 84** holds (`sectionRule` y155 = 39, `gridLine` y234 = 59, `allDaySeparator` y232-233 = 84 at 2 px); every tone is neutral `R=G=B`; labels are 9-row bands with ink **x237..264** (gap **8** to the grid line at x272) centring **exactly on their own tick** under the half-open convention (band `[220,229)` and tick row `[224,225)` are both centre **224.5**). **The dark geometry is pixel-identical to R111's light leg on the same crop** — same rule rows **234/274/314** and **254/294**, same label bands 270..278 / 310..318, same ink extent — and the separators sit at **272/391/510/629/748/867/986**, pitch **119**.

**Why this round.** T01/T02/T03 passed R111 on a *light* leg; the dark tones 59/43 were last read at **R065**, *before* R109 rebuilt the binary. One dark kill+relaunch closes T on both legs. **0 source files touched, no build** — verification only, two captures on the one dark instance (a 0-row week for the band floor, then the strip week at R111's exact geometry).

| | measured on `r113-t-rules-dark-strip.png` (dark, 1100x692, expanded sidebar, `date 2026-04-02`, `contentY 240`, `height 458`) | verdict |
|---|---|---|
| **T01** | hour rules **234/274/.../594** and half-hour **254/294/334/...** — 25 consecutive diffs of exactly **20.0**; `contentHeight 960` = 24x40; hour rules span **x272..x1099** | **PASS** |
| **T02** | `sectionRule` **39** / `allDaySeparator` **84** (2 px, y232-233) / grid top rule + in-grid hour **59** / half-hour **43**; one row per boundary (nothing stacks); ordering **39 < 59 < 84**; separators 1 px at **272/391/510/629/748/867/986** => pitch **119** | **PASS** |
| **T03** | label band **9 rows**, ink **x237..264**, gap **8** to the line at 272; every core centre = its own tick (274.5 vs 274 ... 674.5 vs 674); the topmost band is clipped at y236..239 and keeps its siblings' **identical ink x-extent** | **PASS** |

## 本轮 (R113)
Atomic step: **re-verify T01/T02/T03 on the dark leg** — 0 source files touched, **no build**, one dark kill+relaunch, two captures (0-row week, then the strip week). Files: `docs/ui-calendar/r113-t-rules-dark.png` (new figure: the light and dark rule stacks at the **SAME** x6 crop with row guides, over a x2 NEAREST dark gutter strip), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`.
**New and load-bearing: the dark `gridLine` is translucent `white@0.13`, the light one opaque `#EDEDED`.** At y400 the six weekday separators (x272/391/510/629/748) read **59** but the two **weekend** ones (**x867, x986**) read **65** = `37 + 0.13*(255-37)` — the same token composited over the weekend tint 37 instead of the weekday field 30. Light's opaque `#EDEDED` reads 237 on all seven. **A dark separator scan must expect two tones, and a "separators are 237" reading is light-leg-only.**
**By-products (recorded, not claimed as clauses).** Dark gutter field **30, untinted**. The **all-day band's own** rules DO cross the gutter (x240: y155 = 39, y182-183 = 84) while the **in-grid** rules do not — a refinement of R111's by-product, which was scoped to in-grid rule rows. The 0-row band floor is re-confirmed (interior **156..181 = 26**, separator 182-183, grid rule 184, `height 508` vs the strip leg's **458**). A reproducible **2-px glyph stub at x246..247**, one row below the 9-row core of the **17:00** band (and of 06:00 in the 0-row leg) — antialiasing, not layout. Dark sidebar plane **(40,40,40)** with a 1 px **(53,53,53)** rim at x220 (corrects the standing unmeasured "dark 30" guess). And **T02's z-order half is NOT discriminable on this fixture**: the chips are 16 px and placed +3 px below their tick, so no chip ever overlaps a rule row (every rule row survives at x640 through a chip-dense column) — "lines below event emphasis" holds as declared order only.

**Verdicts.** T01 **PASS**, T02 **PASS**, T03 **PASS** — **T is re-read on both legs of the current build and is closed.**

**Artifacts.** `docs/ui-calendar/r113-t-rules-dark.png`.
### ARCHIVED OUT OF state.md AT R113
- **A 246..253 FILL DETECTOR CANNOT SEPARATE THE REF'S 249 WEEKEND TINT FROM ITS 250 CHIP (R108).** **The discriminator is each column's OWN background**, never an absolute band.
- **THE REF HAS NO MULTI-DAY ALL-DAY STRIP (R108, load-bearing).** All 7 ref columns carry single-day chips only => **A03(b) is an internal law, judged on the spec sentence alone.** Record it as such; never claim a ref anchor for it.
- **Archive — R110 .. R102:** R110 dark leg of A03(b) PASS; R109 A03(b) light + opaque pre-blend + `allDayJointOverlap: 4`; R108 A03(a) + a reverted margin fix; R107 A02 3/3; R106 A01(a) band floor 26; R105 L03 5/5; R104 C05 radius 0.48; R103 slot pitch is a spec literal; R102 C05 pill width.
- **R105 — L03 PASS 5/5** (verification only). **All five L03 clauses closed.**

### ARCHIVED OUT OF state.md AT R114 (the outgoing R113 header block)
# R113 — **T01, T02 and T03 PASS on the DARK leg** — T is now re-read on **both legs of the current build**. Hour rules **(59,59,59)** and half-hour rules **(43,43,43)** each occupy **exactly one row** at pitch **20/20** (25 consecutive diffs of exactly 20 => hour pitch **40.0**, `contentHeight 960` = 24x40); the ordering **39 < 59 < 84** holds (`sectionRule` y155 = 39, `gridLine` y234 = 59, `allDaySeparator` y232-233 = 84 at 2 px); every tone is neutral `R=G=B`; labels are 9-row bands with ink **x237..264** (gap **8** to the grid line at x272) centring **exactly on their own tick** under the half-open convention (band `[220,229)` and tick row `[224,225)` are both centre **224.5**). **The dark geometry is pixel-identical to R111's light leg on the same crop** — same rule rows **234/274/314** and **254/294**, same label bands 270..278 / 310..318, same ink extent — and the separators sit at **272/391/510/629/748/867/986**, pitch **119**.

**Why this round.** T01/T02/T03 passed R111 on a *light* leg; the dark tones 59/43 were last read at **R065**, *before* R109 rebuilt the binary. One dark kill+relaunch closes T on both legs. **0 source files touched, no build** — verification only, two captures on the one dark instance (a 0-row week for the band floor, then the strip week at R111's exact geometry).

| | measured on `r113-t-rules-dark-strip.png` (dark, 1100x692, expanded sidebar, `date 2026-04-02`, `contentY 240`, `height 458`) | verdict |
|---|---|---|
| **T01** | hour rules **234/274/.../594** and half-hour **254/294/334/...** — 25 consecutive diffs of exactly **20.0**; `contentHeight 960` = 24x40; hour rules span **x272..x1099** | **PASS** |
| **T02** | `sectionRule` **39** / `allDaySeparator` **84** (2 px, y232-233) / grid top rule + in-grid hour **59** / half-hour **43**; one row per boundary (nothing stacks); ordering **39 < 59 < 84**; separators 1 px at **272/391/510/629/748/867/986** => pitch **119** | **PASS** |
| **T03** | label band **9 rows**, ink **x237..264**, gap **8** to the line at 272; every core centre = its own tick (274.5 vs 274 ... 674.5 vs 674); the topmost band is clipped at y236..239 and keeps its siblings' **identical ink x-extent** | **PASS** |

## 本轮 (R113)
Atomic step: **re-verify T01/T02/T03 on the dark leg** — 0 source files touched, **no build**, one dark kill+relaunch, two captures (0-row week, then the strip week). Files: `docs/ui-calendar/r113-t-rules-dark.png` (new figure: the light and dark rule stacks at the **SAME** x6 crop with row guides, over a x2 NEAREST dark gutter strip), `docs/ui-calendar/LEDGER.md`, + this file and `rounds.md`.
**New and load-bearing: the dark `gridLine` is translucent `white@0.13`, the light one opaque `#EDEDED`.** At y400 the six weekday separators (x272/391/510/629/748) read **59** but the two **weekend** ones (**x867, x986**) read **65** = `37 + 0.13*(255-37)` — the same token composited over the weekend tint 37 instead of the weekday field 30. Light's opaque `#EDEDED` reads 237 on all seven. **A dark separator scan must expect two tones, and a "separators are 237" reading is light-leg-only.**
**By-products (recorded, not claimed as clauses).** Dark gutter field **30, untinted**. The **all-day band's own** rules DO cross the gutter (x240: y155 = 39, y182-183 = 84) while the **in-grid** rules do not — a refinement of R111's by-product, which was scoped to in-grid rule rows. The 0-row band floor is re-confirmed (interior **156..181 = 26**, separator 182-183, grid rule 184, `height 508` vs the strip leg's **458**). A reproducible **2-px glyph stub at x246..247**, one row below the 9-row core of the **17:00** band (and of 06:00 in the 0-row leg) — antialiasing, not layout. Dark sidebar plane **(40,40,40)** with a 1 px **(53,53,53)** rim at x220 (corrects the standing unmeasured "dark 30" guess). And **T02's z-order half is NOT discriminable on this fixture**: the chips are 16 px and placed +3 px below their tick, so no chip ever overlaps a rule row (every rule row survives at x640 through a chip-dense column) — "lines below event emphasis" holds as declared order only.


## R114 — M01/M02/M03 PASS on the DARK leg; the dark mini month is byte-identical to the light one on every disc-free path (verification only)
**0 source files touched, no build, no relaunch** — the R113 dark instance was still alive (`live-app.pid` 188348) and `r113-t-rules-dark-strip.png` was already at the required state (1100x692, **expanded sidebar**, `date 2026-04-02`), so the dark leg cost no capture at all. Figure `docs/ui-calendar/r114-m-dark-pair.png` (dark mini month above the light one, same crop x0..220 y505..692 at x2 NEAREST, with the SAME guides on both panels: magenta = column centres **26+28i**, blue = band tops **561+21i**, green = block edges **12 / 208**; every guide lands identically in both panels).
- **M01** block = 7 cells x `196/7 = 28.0` centred in the 220 px sidebar => cells start at **12**, end at **208** => **12 / 12**, the same `categoryInset` the group rows use; `cellHeight 21.0` (band-top pitch 21.0 on 5/5). Not compressed: **x211..219 is pure `(40,40,40)`** at y100/300/500/650 (light: pure 228) => no sidebar scrollbar on dark either. **PASS**
- **M02** arrows **x24..27** and **x192..195**, both **y523..527** — **byte-identical to the light leg at tolerance 3 AND at tolerance 8**; equal 4x5 boxes with half-open centres **26.0 / 194.0** => **84.0 / 84.0** about the sidebar centre **110.0** (the mirror axis of a 0..219 pixel row is 109.5 = the -0.5 px R105 established as the convention for a centred-in-region element); title ink **x77..140**, identical on both legs at tolerance **2, 6, 12 and 30**; **7 equal columns** — header centres **26/54/82/110/138/166/194**, pitch **28.0 on 6/6**, and the same in all six date rows. **PASS**
- **M03** `font.pixelSize: 11` (R112 source constant, theme-independent) with all six ink bands the **same 9 rows at the same +0 offset** — 561..569 / 582..590 / 603..611 / 624..632 / 645..653 / 666..674, tops **561+21i** => **one baseline**; a 1-digit ink box (x135..140, centre **138.0**) and its 2-digit siblings (x20..32, x48..60, x76..88, x103..116) both centre on **26.0 + 28.0i** => optical centring holds; **no cell border** — every row y512..677 has dominant tone exactly `(40,40,40)` with >= 120 px, and the longest non-plane horizontal run in the block is **44 px** (the title glyphs at y528), under R112's >100 px criterion. **PASS**
- **NEW and load-bearing: THE SIDEBAR'S 1 px RIM AT x220 EXISTS ON BOTH LEGS (dark `(53,53,53)`, light `(224,224,224)`) — a whole-sidebar ink scan must stop at x219.** A scan over x0..**220** on the dark leg returns **ONE band (490,691)**, because the rim makes *every* row read as ink; the same scan on light looked clean only because 224 is within 8 of the 228 plane and slipped under the threshold. **A whole-sidebar test that passes on light can be silently vacuous on dark.**
- **By-products.** (i) The mini month carries **no fill of its own** on either leg — the block's field IS the sidebar plane — so M01's **12 / 12 is arithmetic, not tonal**: it follows from `cellWidth 196/7 = 28.0` and the column centres, and can never be read off an edge. (ii) **A band scan on a disc-bearing row must be disc-free (x <= 99):** the 15x15 selection disc (x102..116, **y557..571**) extends 4 px above and 2 px below the 9-row band — that is why a full-width scan gives 557..571 for row 1 while R112's disc-free scan gave 561..569. The disc is **15x15 on both legs**, a **blue ring** (dark core `(25,106,178)`, light ~`(39,152,250)`) with the digit in the ordinary text tone. (iii) The selected weekday's **header glyph is accent-tinted on both legs** (blue x105..114 y542..549; 24 px light / 21 px dark). (iv) A pure-**black** region at x0..6 y677..691 (122 px) sits at the sidebar's bottom-left on **both** legs — theme-independent, and invisible to R112's 200..227 tone test. (v) **An ink box on a dark leg is threshold-sensitive at +-1 px** (R112's `x24..28 / y523..528` and this round's `x24..27 / y523..527` are the same glyph at two thresholds) — **the reliable instrument is the PAIR** (arrow vs arrow, dark vs light), which agreed byte for byte. (vi) **M04 is still PENDING and this is its first evidence:** the *selection* disc is **blue, 15x15, ring-style, digit in the normal text tone**, where M04 asks for "other selection **gray**"; and **no today cell exists in this fixture** (week = Apr 2026, today = 2026-10-17), so the red today circle has never been captured at all.
- **Verdicts.** M01 **PASS**, M02 **PASS**, M03 **PASS** — **M is now re-read on both legs; M04 stays PENDING (see (vi)).**


---

## R115 — M04 read for the first time (dark leg, free capture)
Atomic step: **read M04.** Capture `r115-m04-week.png` — reuses R113's still-live dark instance (`live-app.pid` 188348, `kill -0` clean), 1100x692, sidebar expanded, `date 2026-10-15`. **0 source files touched, no build, no relaunch.** Figure `docs/ui-calendar/r115-m04-states.png`: ref mini month 1:1 above ours 1:1, then ×6 zooms *ref today / our selection / our today*.

**Why this leg.** `date 2026-04-02`'s week (Apr 2026) contains **no today**, so every prior M leg was blind to the today surface. `date 2026-10-15` is the launch week: it contains **today = Sat Oct 17** *and* **the selection = Thu Oct 15** (the launch date). Both states render in one frame — the fixture M04 has been missing since R008.

**Verdicts — 1 PASS, 1 PASS-in-form-but-misses-its-literal, 1 FAIL.**
1. **today — form PASS.** Ours: disc **x159..171 (15 wide) / y599..613 (15 rows)**, core **(229,72,77)**, digit **white** (89 px, min channel > 170). Ref (measured 1:1 for the first time): **x91..105 / y395..409 = 15x15**, core **(207,51,35)**, digit white (31 px > 200). **Identical construction.** M04's literal is *"red **18–20** circle"* ⇒ **15 fails it**. The ref is not the clause either: ref mini-month **column pitch 24.25** (weekday-header ink centres 25 / 49.5 / 73.5 / 97.5 / 122, plus `10` 146.5 and `11` 169.5) vs our **28.0** ⇒ **scale 1.155** (sidebar 220/192 = 1.146 agrees) ⇒ the ref disc in our layout is **17.3**, also under 18. **The clause is not a restatement of the reference at any measurable scale; our 15 is small under both readings.**
2. **"other selection gray" — FAIL.** Ours is a **hollow ring**: outer **x102..116 / y599..613**, peak **(0,136,255)**, AA ladder `(22,84,139)(14,102,179)(7,119,218)`, digit drawn in **(63,63,66)** (32 px, the cell's modal non-plane tone). M04's own today clause fixes the intended shape — a **filled disc + white number** — so "other selection **gray**" is that disc in **gray**. Blue-and-hollow is neither. **And the reference cannot arbitrate:** its selection *is* today, so it shows no gray state at all.
3. **"outside-month muted" — PASS.** Same 40 plane: row 6 (Nov 2..8) cell-0 ink **(114,114,114)** vs in-month row 4 cell-0 ink **(216,216,216)** ⇒ **0.53** of the in-month luminance.

**Corrections.** R114's by-product (vi) called the selection digit *"the ordinary text tone"* — **wrong**, it is **63** against in-month **~216–220**; R112/R114 read it at a threshold that never separated the digit from the ring. **The ×6 zoom is the instrument.** R114's other by-products **re-witnessed**: the six date-band tops are again **561/582/603/624/645/666** (so the mini-month grid is **month-independent**), and the disc again overhangs its 9-row band by **4 above / 2 below**.

**Recorded, not claimed.** Our locale reads **`2026年10月` / `一二三四五六日`** with the week starting **Monday** (Oct 12 in column 一) where the ref reads **`April 2026` / `S M T W T F S`** — an **unfiled** heading/header divergence; M02's equal-arrows / seven-equal-columns / six-equal-rows clauses are unaffected. The sidebar's **pure-black bottom-left wedge** (R114) is visible again at the foot of our 1:1 strip.

**M04 moves PENDING → MEASURED with 2 open gaps**, both in the mini-month delegate in `Main.qml` and **neither ruling-blocked**. Nothing was fixed this round.

### Archived from state.md this round (R107/R110/R111/R105/R063 methodology + closed verdicts)
- **A02'S CLAUSE (a) IS AN INTERNAL LAW, NOT A REF QUESTION (R107, load-bearing).** The reference has exactly **one** band size. Ours is settled by the affine fit `1 + 25N` at **N = 1 (floor, 26 px)** and **N = 3 (76 px)** with the top rule pinned — and by the **+50 translation of everything below**. **The 1–2-row middle is not in the fixture.** **Record it as an extrapolation, never as witnessed.**
- **THE REF'S BAND/GRID JUNCTION IS THREE ROWS OF INK: 217,217 (2px) + ONE 1px RULE (R107, load-bearing).** Ref 183-184 = 217 2px, **185 = 244 1px**, field 250. Ours: 232-233 = 217 2px, **234 = 237 1px**, field 255. **A "shared edge" check is: separator tone + the very next row's tone.**
- **THE REFERENCE'S IN-GRID RULES ARE 242–249 AND ARE NOT FULL-WIDTH UNIFORM (R107).** Its **hour pitch is 27**; its gutter label ink sits at 189-197 / 216-224 / 271-278 / 299-305 / 325-333 (the 247 band is swallowed by the red now-pill at 232-245, centre 238 = the now-line).
- **A03 IS PASS ON BOTH CLAUSES AND ON BOTH LEGS (R110).** (a) outer-corner-only, witnessed R108 / re-read R109 light / re-read R110 dark; (b) visually continuous, witnessed R109 light and R110 dark. **No further work on A03.**
- **T01/T02/T03 ARE PASS ON BOTH LEGS (R111 light, R113 dark).** Light: pitch 40.0/20.0, `contentHeight 960`, tones 237/244, ordering 242 < 237 < 217, label centres on ticks with gap 8. Dark: the R113 leg at R111's exact geometry. **T is final-regressed.**
- **A LOCALIZED LABEL IS NOT A 4th WORD (R105).** **L03 names the segment semantically, so the locale is not one of its clauses.**
- **THE REF'S INK RULE IS ONE PARAMETER: HALFWAY TO THE POLE (R079 + R080).**

## R116 — M04 (a) "other selection gray" FIXED (first source change since R109)

**Step.** One atomic detail: the mini-month *other selection* state. **Files:** `apps/calendar/qml/Main.qml` only (2 hunks), figure `docs/ui-calendar/r116-m04-sel.png`, `docs/ui-calendar/LEDGER.md`.
**Change.** (1) New token in the calendar's `tahoe` block beside `selectionFill`: `readonly property color selectionDisc: "#8E8E93"` (Apple systemGray; leg-independent like `todayRed` — 142 is Δ86 below the 228 light plane, Δ102 above the 40 dark one). (2) The mini-month day delegate (`:2233-2260`): fill `selectionFill` → `selectionDisc`; **`border.width`/`border.color: accent` deleted** (the ring *was* the defect); digit colour `today || selected ? "#FFFFFF" : labelPrimary` (was `accent`). Untouched: today disc (still `todayRed`, still 15), geometry, `categoryInset`, arrows, `opacity: inMonth ? 1 : 0.42`.

**Evidence (light leg, `r116-m04-sel-light.png`, first capture of the R116 binary).**
- gray disc `x102..116 / y599..613` (15x15), core **`(142,142,147)`**, 67 px of exactly that tone in the box (a fill, not a stroke); red today disc `x158..172 / y599..613` (15x15), core `(229,72,77)` ⇒ **equal to the pixel on both axes** — M04's "the same shape" holds by construction.
- **19 px `min>235`** inside the disc box = white digit (visible at ×6); **0** accent `(0,136,255)±40` pixels in the entire mini month. The 220 bluish px that remain in the block are **text sub-pixel fringes** on the weekday header / out-of-month glyphs, none in the disc.
- **Grid re-witnessed:** band tops 541 (header) then 561/582/599..613/624/645/666/689 — the same six 9-row bands as R114/R115, the disc row still merged by its 4-above/2-below overhang ⇒ M01/M02/M03 unmoved.
- M04 (c) "outside-month muted" is **carried from R115's dark measurement** (114 vs 216); the out-of-month rows read visibly lighter here but **nothing was measured and none is claimed**.

**Method note (load-bearing, new).** R115's *"selected digit `(63,63,66)`, ring peak `(0,136,255)`"* is a **two-tone misidentification**, and the deleted source shows why: the digit's colour **was `root.tahoe.accent`** — the *same* `(0,136,255)` as the border — and the tone it called the digit is dark `selectionFill` (`0x76,0x76,0x80 @30%` over the 40 plane) = **63**, i.e. the **ring's interior fill**. ⇒ **When a glyph and its outline share one token, no threshold ladder separates them and even a ×6 zoom cannot: check the source for the glyph's colour, and report the *fill* tone and the *outline* tone as separate claims.** (Inference from the removed code; not a re-measurement of the R115 figure.)

**Harness note (new).** A rebuilt binary keeps running under a live instance (`live-app.pid` 188348 was alive, dark) — the theme is fixed at launch and the QML is compiled in, so **a source change always costs kill + relaunch + ~40 s**; there is no free capture on a changed build. Band-scan gotcha: `sum(px) < 660` (not 690 — the plane is 684) and **flush the final band after the loop** (R116 printed `[]` once because of exactly that).

**Verdict.** M04: **2 of 3 halves PASS** (other selection PASS as of R116; outside-month muted PASS R115; today PASSes in form but is 15 px where the clause says 18–20 — and the ref scaled into our layout is 17.3, so 18 is the smallest literal satisfying both). Next round = that one number.

**R115 (archived from `state.md`, full text in `docs/ui-calendar/LEDGER.md`):** M04 read for the first time — three halves from one free capture of the still-live R113 dark instance: today PASSES in form (solid red disc + white number, byte-for-byte the ref's construction) but is 15 px vs the clause's 18–20; "other selection" FAILS (hollow blue ring, peak `(0,136,255)`, dim interior); "outside-month muted" PASSES (114 vs 216 on the 40 plane). `date 2026-10-15` is the launch week and contains both today (Sat Oct 17) and the selection (Thu Oct 15) — the M04 fixture. Ref mini-month column pitch 24.25 vs our 28.0 ⇒ **scale 1.155**; ref disc 15 at 1:1 ⇒ **17.3** in our layout. 0 source files touched, no build, no relaunch. Figure `docs/ui-calendar/r115-m04-states.png`.

## R117 — M04 (b): today disc 15 -> 18, both discs on one token. M04 CLOSED 3/3.
Step: M04's last open half. One file (`apps/calendar/qml/Main.qml`), 2 hunks, 1 build, 1 light leg, 1 figure.
**Change.** New `readonly property int miniDisc: 18` beside `selectionDisc`; the delegate's single shared `Rectangle` (`:2243-2250`) now reads `root.tahoe.miniDisc` for both `width` and `height` where it read the literal `15`. Because ONE `Rectangle` serves both the today disc and the selected disc, the clause's *"the same shape"* was already structural — the token makes it non-drifting as well.
**Why 18.** M04's literal is **18-20**. The reference's own mini-month today disc is **15 px at 1:1** (re-measured this round, independently of R115: red blob `x91..105 / y395..409`, 171 saturated px, per-row extents 6/9/11/13/13/12/13/13/13/13/13/13/12/10/7 — a circle, saturated core 13, true diameter 15). Scaling into our sidebar: **220/192 = 1.146 by width**, **28.0/24.25 = 1.155 by column pitch** => **17.2 / 17.3**. 18 is the smallest integer that satisfies the clause AND is not smaller than the ref at either scale. The spec literal wins; the ref number is recorded beside it.
**After, measured on the light leg** (`resize 1100x692`, `sidebar expanded`, `date 2026-10-15`):
- SELECTED (gray) **x101..118** at row 607 => **18 wide**; TODAY (red) **x157..174** => **18 wide**. Centres **110.0 / 166.0** = `12 + 28c + 14` exactly for c=3 and c=5.
- Tones: red `(229,72,77)` (`todayRed`), gray `(142,142,147)` (`selectionDisc`), plane `(228,228,228)`. **0** px of accent `(0,136,255)` anywhere in the mini month — the R116 ring deletion is intact.
- **Grid unmoved:** col-0 ink-row starts **545 / 561 / 582 / 603 / 624 / 645 / 666 / 688** — identical to R112/R114/R115/R116 (weekday header 545, then six 9-row bands 21 apart). So a size change to the disc did not perturb the bands: M01/M02/M03 still hold.
**M04 (c) — measured on THIS leg instead of carried.** Out-of-month digits (`Sep 28` row-0 col-0, `Sep 30` row-0 col-2) have an ink floor of **137 / 133**; in-month digits (`Oct 12`, `Oct 14`) floor at **3 / 3**. The `opacity: 0.42` muting is unambiguous on the light leg, matching R115's dark read (114 vs 216). Method: `min(px[x,y])` over the 9-row band, digit columns only.
**Tooling note (new, cost 3 round-trips):** the harness's capture action is **`captureClient` with a `path`**, not `capture` with a `name`. A `capture` command has **no matching `action` and silently hits the fallback** (R064's rule, re-confirmed the hard way) — the run leaves no PNG and no log line, and only `captureClient` prints `native app client capture <path> true`. A rebuilt binary needs kill + full relaunch (a live instance keeps the OLD resources).
**NEW OBSERVATION, recorded not fixed (candidate fidelity gap):** the reference's mini-month today disc fill is **`(207,51,35)`** (digit-free margin sample, 40 + 35 px), while the reference's own 9:41 now-pill is **`(235,76,70)`**. We use one token `todayRed` `(229,72,77)` for both. So **the reference itself uses two different reds** and we use one. Caveat: the ref's sidebar is *vibrant* material, which renders systemRed darker/more saturated; our sidebar is a flat plane (228), so copying `(207,51,35)` is not obviously right. **Needs a ruling-grade judgment, not a literal swap.**

---

## R118 — 仍差 #7 CLOSED: the month chevrons (still-image, light leg). Figure `r118-month-chevrons.png`.

**What was actually wrong.** Our two `KosToolButton`s in `Main.qml`'s `miniCalendarHeading` drew the **glyph** `‹` / `›` (U+2039 / U+203A) at 13 px, which rasterised to **4 x 5 px of ink** (`x24..27 / x192..195`, `y523..527`). The reference's own arrows are **5 wide x 9 tall** — *taller* than wide (aspect 1.8) — while an angle-quote glyph is *wider* than tall (aspect 0.8). **So this was never a size-only defect: the glyph's SHAPE was wrong, and no font size could have fixed both axes.** The fix is a local vector, the same idiom `DateNavButton` already states at `Main.qml:981` ("a local chevron vector, not a glyph font").

**Ref measurement (the instrument).** Left arrow ink **x22..27 / y350..358**; per-row extents `1/1/1/1/1/1/1/1` = a constant **1-px stroke**, apex at `x22 y354`. Right arrow **x169..173**, apex `x173 y354`. Core tone **~130 (121–140)** with one AA pixel at 163–197 on the 237 plane. The month title's ink (x69..123) shares the row band `y349..358`, and the ref's own digits there span 9 rows.

**The number, and why the scale choice did NOT matter.** The ref's mini month has column pitch **24.25** where ours is **28.0** (**x1.155**, R115/R117), giving two candidate targets 1.4 px apart in height: **ref 1:1 = 5 x 9** and **ref x1.155 = 5.8 x 10.4**. The shape was built so its ink lands at **5.4 x 9.9 ± 0.3** — i.e. between them — so at this size the choice cannot be read off the image. A third, independent datum agreed: our title's own digits render **~1.2–1.33x** the ref's, so the whole mini month is enlarged by roughly that factor. **Shipped/measured: `x23..27 / x191..196`, height 9–10.**

**Implementation.** A new top-level inline component `MiniMonthChevron` in `Main.qml`: two `Rectangle`s, `1.4 x 6.3`, `radius 0.6`, `color: root.tahoe.labelSecondary`, at `rotation: 45 / -45`, meeting at a point on the left; the right arrow is the same item with `rotation: 180`. **Untouched on purpose:** the two buttons keep `28x28` / `flat` / `Accessible.name` / their `onClicked` month steps — only `text: "‹"|"›"` -> `text: ""` changed. The six date bands, both 18 px discs, `categoryInset`, and the title `Label` are all untouched.

**THE ITEM'S CENTRE MUST BE THE INK'S CENTRE (load-bearing, cost the 2nd cycle).** First attempt used `implicitWidth 5.4 / implicitHeight 9.9`. **Rotated-rect *bounding boxes* are not *ink*:** the two bars' ink actually spans `x0.18..5.62 / y0.24..10.18` (the rotated rects' corners are empty), so the ink centre is `(2.90, 5.21)` against an item centre of `(2.70, 4.95)`. The right arrow is the left one rotated 180, and **a 180° rotation about an off-centre item centre SHIFTS the ink instead of mirroring it** — the pair measured **26.2 / 193.8**, i.e. 0.4 px closer together than their buttons. Sizing the item to `5.8 x 10.42` puts item centre = ink centre and the pair reads **26.0 / 194.0 = exactly 168 apart**, the two 28-wide buttons' separation. **Measured as a PAIR at one threshold (R114's instrument), not as two absolute boxes.**

**Colour was already right — only the size was wrong.** Chevron ink tone **ref (156,156,156) vs ours (157,157,159)**. Nothing about the tone was touched.

**Containment (light leg, `resize 1100x692` / `sidebar expanded` / `date 2026-10-15`, capture `r118-chevrons-light.png`):** both mini-month discs still **18 px at row 607** (gray `x101..118`, red `x157..174`) — identical to R117; the six date-band tops **561/582/603/624/645/666** unmoved. The change is local to the heading row.

**M02 was never failing.** It demands only *equal* arrows — which is now exact rather than approximate. This was an **unfiled ref-fidelity gap**, not a clause failure.

**NEW, recorded not fixed (the new 仍差 #7):** the month title's ink is **pure black** in ours (darkest pixel `0/255`, darkest-5% `0`) where the reference's is **`97/255` throughout** — measured on **same-class ink** (the digits `2026` exist in both titles; the ref's *letters* independently agree at `97`, so it is not a coverage artefact of our denser glyphs). A separate atomic step; not touched this round. **Caveat:** the ref's sidebar is *vibrant*, so `97` may be a render of near-black rather than a token value — the R117 two-reds trap.

**ARCHIVE — `state.md` verbatim as it stood at the end of R117 (rolling-window trim; nothing is lost):**


```
# R117 — **M04 CLOSED, 3 of 3 halves.** The today disc's size went 15 → 18 (`apps/calendar/qml/Main.qml` **only**, 2 hunks, 1 build, 1 light leg). M04's literal is **18–20**; the reference's own disc is **15 at 1:1** and **17.2–17.3** in our sidebar, so **18 is the smallest number satisfying both**. Both discs were already **one `Rectangle`**; they now read **one named token** `tahoe.miniDisc: 18`, so the clause's *"the same shape"* cannot drift. **Measured: both discs 18 wide at row 607 — gray x101..118, red x157..174, centres 110.0 / 166.0 = `12 + 28c + 14` exactly; 0 accent px; the six date bands unmoved.** **(c) was measured on this leg this time, not carried (135 vs 3).**

## 本轮 (R117)
Atomic step: **M04 (b) — the today disc's size.** Files: `apps/calendar/qml/Main.qml` (**only**), figure `docs/ui-calendar/r117-m04-disc.png` (top: ref mini month 1:1 | ours 1:1; bottom: ref today disc ×6 | ours ×6 col3 SELECTED + col5 TODAY), + `LEDGER.md`, this file, `rounds.md`.
**(1) New token** beside `selectionDisc`: `readonly property int miniDisc: 18`.
**(2) The delegate** (`Main.qml:2243-2250`): `width: 15 / height: 15` → `root.tahoe.miniDisc`. **Untouched on purpose:** `categoryInset`, the six bands, the two chevrons, `selectionDisc` `#8E8E93`, the white digit, the hover fill, `opacity: inMonth ? 1 : 0.42`.
**(b) is now PASS**, so **M04 is 3 of 3**: (a) gray disc / no ring (R116, re-witnessed: gray `(142,142,147)`, white digit, **0** accent px); (b) size 18 (this round); (c) outside-month muted — **light 135/133 vs 3/3 THIS round**, dark 114 vs 216 (R115).
**Why 18, re-derived independently of R115:** ref disc re-measured this round as a red blob `x91..105 / y395..409` (15 px, per-row extents 6/9/11/13/13/12/13/13/13/13/13/13/12/10/7 = a circle). Scale into our sidebar: **1.146** by width (220/192), **1.155** by pitch (28.0/24.25) ⇒ **17.2 / 17.3**.
**Harness correction (cost 3 round-trips, now in the rules below):** the capture action is **`captureClient` + `path`**, never `capture` + `name` — the latter matches no `action` and **silently hits the fallback** (no PNG, no log line).

## Archive — R116 .. R103
R116 M04 (a): gray `selectionDisc`, accent ring deleted, white digit (fig `r116-m04-sel.png`; **first build since R109**); R115 M04 read for the first time; R114 M01/M02/M03 dark; R113 T01/T02/T03 dark; R112 M01/M02/M03 light; R111 T01/T02/T03 light; R110 dark A03(b); R109 A03(b) light + opaque pre-blend; R108 A03(a); R107 A02 3/3; R106 A01(a) band floor 26; R105 L03 5/5; R104 C05 radius 0.48; R103 slot pitch is a spec literal. **Full text: `rounds.md` tail (append-only).**

## 仍差 (top 8, visual-impact order) — **#1–#6 are ruling-blocked; #7 is plain work; #8 is NEW and needs a judgment**
1. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies exactly three, so **three is
   spec-correct**; adding a view is not an atomic step. Ref word centres **418/474/530/586, pitch 56.0**; ours **595/660/723, pitch 64.0**
   (`(W−4)/n` both; 196 is L03's midpoint). **Blocked on a ruling.**
2. **The all-day BAND chip's icon — ours has NONE. Fully MEASURED, blocked on ruling H (R081).** Ref: **12×12 ring, stroke 3 / hole 6, inset 3
   from the chip's fill on left/top/bottom, colour = `itemColor` at full saturation (no alpha)**, text ink 17–19 ref px right of the ring's
   outer-left edge. @x1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Also unanswered: the thin-stroke family** (stroke ~1.5, hole ~9)
   on the neutral-248 chips. **Do NOT build either until H is answered.**
3. **Ref gutter labels are 12-hour and two-tone** (dark hour number + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** right edge
   (digit (89,89,89), suffix (176..193)); ours is single-size 24-hour `07:00`. **Needs ruling F.**
4. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`): `Overlay.modal` is a plain un-animated `Rectangle`. App-wide.
   **Needs ruling A.**
5. **Shadow magnitude** (D03 follow-up): peak Δ≈10/255 = 3.9%; macOS alerts read ~Δ25–40 at 1px. App-wide. **Needs ruling B.**
6. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D — and a 3-all-day-item *month* day** before it can be
   reproduced at all. **The only remaining `slice(0, 2)` with a content cap** (`:689` is the grid hour cell).
7. **Our month chevrons are 4x5 px of ink where the ref's are 9 px tall** (both arrows, read at 1:1, R112; re-measured R114 `x24..27 / x192..195, y523..527`, both legs). M02 demands only *equal* arrows — satisfied — so **this is not a clause failure, it is an unfiled ref-fidelity gap**. **Not ruling-blocked:** it is a plain glyph-size question on the two 28x28 `KosToolButton`s in `Main.qml`'s `miniCalendarHeading`. **This is the next atomic step.**
8. **NEW (R117): the reference uses TWO reds where we use one.** Its mini month disc fill is **`(207,51,35)`** (digit-free margin sample, 40 + 35 px) while its own 9:41 now-pill is **`(235,76,70)`**; we spend `todayRed` `(229,72,77)` on both. **Caveat that makes this a judgment, not a literal swap:** the ref's sidebar is *vibrant* material (systemRed renders darker/more saturated there) and ours is a flat 228 plane — so `(207,51,35)` may not be the right target at all. **Recorded, deliberately not fixed.**
- **ALL CLOSED:** **M04 all three halves (R116/R117)** · T01/T02/T03 (R111/R113) · A03 both clauses both legs (R108-R110) · A02 3/3 (R107) · A01 but for G (R106) · L03 5/5 (R105) · C05 but for its two blocked halves (R104) · C05's pitch question (R103) · the pill's padding+radius, L03's label order, C05's label token (R102-R099) · C05's dark leg (R098) · clause 1's chrome (R097) · M01/M02/M03 both legs (R112/R114). **Full text: `rounds.md` tail.**
- *(archived to rounds.md tail: R116's gray disc + the ring/digit one-token lesson, R115's M04 read (three halves, the mini-month scale 1.155, the R114 digit correction), R096 S04 verdict, R095 weekday-header tick, R094 size, R093 colour, R092 dark-leg verdict, R091 timeline trigger, R108's band measurements, R107's A02 internal law + ref junction + in-grid rules, R110's A03 restatement, R111's T-light restatement, R105's "a localized label is not a 4th word", R063's ref-methodology note.)*

## ## 最近已改 (most recent 8)  [R117 appended; R108 archived to rounds.md]
0. R117 — **M04 (b) fixed**: `tahoe.miniDisc: 18`, the delegate's shared `Rectangle` moved onto it. `Main.qml` only, 2 hunks. Figure `r117-m04-disc.png`. **M04 closes 3/3.**
1. R116 — **M04 (a) fixed**: `selectionDisc` (`#8E8E93`, Apple systemGray) + the delegate's fill swap and the **deletion** of the accent ring; digit white. `Main.qml` only, 2 hunks. Figure `r116-m04-sel.png`.
2. R115 — **verification only**: M04 read for the first time (1 of 3 halves). 0 source files touched, no build, no capture cost. Figure `r115-m04-states.png`.
3. R114 — **verification only**: M01/M02/M03 on the DARK leg, reusing the still-live R113 dark capture. Figure `r114-m-dark-pair.png`.
4. R113 — **verification only**: T01/T02/T03 on a fresh DARK leg at R111's exact geometry. Figure `r113-t-rules-dark.png`.
5. R112 — **verification only**: M01/M02/M03 on R111's light capture at the expanded sidebar. Figure `r112-m-mini-month.png`.
6. R111 — **verification only**: T01/T02/T03 on a fresh light leg. Figure `r111-t-rules-3panel.png`.
7. R110 — **verification only**: the dark leg of A03(b). Figure `r110-a03b-dark-joint.png`.

## 外推待确认 (live only — older live items are archived to rounds.md tail)
- **THE HARNESS'S CAPTURE ACTION IS `captureClient` + `path`; `capture` + `name` FAILS SILENTLY (R117, load-bearing, cost 3 round-trips).** A command whose `action` matches nothing **hits the fallback with no error**: `harness/command.json` updates, the app logs nothing new, and **no PNG appears anywhere**. The tell is the log line `[UIReview] native app client capture <path> true` — if it is absent, nothing was written. **Always grep that line after a capture, and `ls` the file.** (R064 said the fallback is silent; this is the round that paid for it.)
- **THE REFERENCE ITSELF CAN SPEND TWO TONES ON ONE SEMANTIC COLOUR (R117, load-bearing).** Its mini-month today disc is **`(207,51,35)`** but its 9:41 now-pill is **`(235,76,70)`** — both are "today red". macOS renders systemRed through *vibrancy* in the sidebar and flat in the toolbar. ⇒ **When a reference tone is taken from a vibrant surface, it is not a token value; it is a render.** Sample the same semantic colour on a *flat* surface in the same screenshot before proposing a literal. **(Corollary: a single screenshot can contain two renderings of one token — never derive a token from one sample.)**
- **A SIZE LITERAL BEATS A REF MEASUREMENT, BUT THE MEASUREMENT MUST BE RECORDED BESIDE IT (R115/R117, load-bearing).** M04 says **18–20**; the ref is **15 at 1:1** and **17.2–17.3** scaled. We shipped **18** and wrote both numbers down. **The clause and the ref disagree; the clause wins; the ref number stays in the record so a later ruling can revisit it.**
- **A RING AND A DIGIT THAT SHARE ONE TOKEN FUSE INTO ONE READING (R116, load-bearing).** R115 read our selection as a ring peaking `(0,136,255)` with the digit `(63,63,66)`, "32 px, the cell's modal non-plane tone". The deleted source shows why that is a **two-tone misidentification**: the digit's colour *was* `root.tahoe.accent`, i.e. **the same `(0,136,255)` as the border**, and the tone it took for the digit is dark `selectionFill` = **63**, the **ring's interior fill**. ⇒ **Before calling a value "the digit", check the source for the digit's colour and the outline's colour: if they are one token, a threshold ladder cannot separate them and a ×6 zoom still cannot.**
- **THE MINI MONTH'S GRID IS MONTH-INDEPENDENT (R115/R117, load-bearing).** The six date-band tops are **561/582/603/624/645/666** — identical in the Apr-2026 capture and the Oct-2026 one — and the disc overhangs its 9-row band. **R117: a disc SIZE change did not move a single band** (col-0 starts still 545/561/582/603/624/645/666/688), because the disc is `anchors.centerIn` a fixed cell. ⇒ a mini-month reading taken on one month holds for any month, **and a disc geometry change is band-neutral by construction.**
- **A 9-ROW GLYPH INSIDE A DISC IS NOT LEGIBLE ENOUGH TO CARRY A TONE CLAIM (R115, load-bearing).** R112/R114 read the selection disc's digit as "the ordinary text tone" at 1:1; the **×6 zoom** separated a 63-tone fill from a 216-tone glyph. **Ring/disc interiors need a zoom before any tone claim** — a threshold that separates the ring from the plane will not separate the digit from the ring.
- **A DISC'S RIM NEEDS AN ENVELOPE, NOT A TONE TOLERANCE, AND THE ENVELOPE MUST BE ROW-BOUNDED (R117).** A ±7 tolerance on the gray tone reads the disc as **16 wide**, because the rim blends toward the 228 plane within 1 px; a saturated-red threshold reads the SAME 18 px disc as 18. **The pair is the instrument:** measure both discs with one criterion (`sum(px) < 3*228 − 60`) and report their equality, never an absolute box from a single tolerance. **And keep the row range inside the disc's own cell** — an envelope spanning several rows picks up the neighbouring dates' glyphs (R117 read a 40-row "disc" that way before clamping).
- **THE SIDEBAR'S 1 px RIM AT x220 EXISTS ON BOTH LEGS (R114, load-bearing).** Dark `(53,53,53)` at x220 with the plane 40 at x219; light `(224,224,224)` with the plane 228. **A whole-sidebar ink scan must stop at x219.**
- **THE MINI MONTH HAS NO FILL OF ITS OWN (R114, load-bearing).** The block's field IS the sidebar plane ((40,40,40) dark / 228 light, the dominant tone in **every** row), so **M01's 12 / 12 margins are arithmetic, not tonal**: they follow from `cellWidth 196/7 = 28.0` and the column centres 26.0 + 28.0i (⇒ cells 12..208 in a 220 px sidebar). The same is true on light.
- **A BAND SCAN ON A DISC-BEARING ROW MUST BE DISC-FREE (R114).** The disc extends above and below the 9-row text band, so a full-width scan of the selected row reads wider than a disc-free scan. **R117: at 18 px the disc extends 4–5 px above and 2–3 below the 603..611 band** — a wider overhang than R114's 15 px disc gave, so a band scan on the disc row is now MORE polluted, not less.
- **A PIXEL RUN p..q IS THE HALF-OPEN INTERVAL [p, q+1) — ITS CENTRE IS (p+q+1)/2 (R112, load-bearing calibration).** **R117 used it to land both disc centres exactly on `12 + 28c + 14`: 110.0 and 166.0.** The inclusive form `(p+q)/2` would have shifted them to 109.5 / 165.5 and read as a misalignment that is not there. A GAP written as `line - last_ink_pixel` is the inclusive form and reads 1 larger than the continuous gap — **state which form a gap came from.**
- **THE PAIR, NOT THE BOX, IS THE INSTRUMENT ON A DARK LEG (R114).** An ink box reads ±1 px differently against a 40 plane than against 228, so a dark-leg fidelity claim must rest on a **pair comparison** — arrow vs arrow, dark vs light, at two thresholds — never on an absolute box edge. **R116/R117 applied the same instrument on one leg: the two discs measure equal to the pixel.**
- **A DARK `gridLine` COMPOSITES, A LIGHT ONE DOES NOT (R113, load-bearing).** The dark separators read **59** over the weekday field 30 and **65** over the weekend tint 37 — one token, `white@0.13`, two backdrops. The light `#EDEDED` is opaque and reads 237 everywhere. ⇒ **"all separators share one tone" is a light-leg fact.**
- **A RULE ROW'S GUTTER SEGMENT IS THE LABEL, NEVER A LINE (R111, load-bearing).** The hour/half-hour rules span **x272..x1099** only — the grid's left edge to the window's last pixel. In a rule row the only non-white pixels left of x272 are the gutter label's own ink (`238..264`).
- **A CLIPPED LABEL BAND IS STILL AN ALIGNMENT READING IF ITS INK X-EXTENT MATCHES ITS SIBLINGS (R111).**
- **THE HOUR LABELS SCROLL WITH THE GRID (R111, load-bearing).** At `contentY 240` the top tick is hour 6 at screen y234 and the label bands sit at 274/314/.../674 — a gutter scan must be indexed by **tick**, not by absolute hour.
- **EXPANDED-SIDEBAR T03 GEOMETRY, MEASURED (R111).** Gutter **221..272**; label ink **x238..264**, right gap **8** to the grid line at 272; separators **1 px 237** at **272/391/510/629/748/867** (**pitch 119**); weekend tint **249** right of the x867 separator. Label band = **9 rows**, font 11.
- **AN OPAQUE PRE-BLEND MUST RESOLVE THE WEEKEND TINT FIRST (R109, load-bearing).** `weekendField`'s dark leg is `white@0.03` — **translucent** — so `allDayBackdrop()` composites it explicitly: dark ⇒ ≈ **37**; light `#F9F9F9` is already opaque. **The weekend CHIP is still UNWITNESSED — the fixture's Sat/Sun all-day columns are empty (R107).**
- **`opacity: 0.5` ON A COMPLETED ITEM RE-CREATES THE EXACT DEFECT R109 FIXED (R109, load-bearing).** `CalendarScheduleView.qml:550` still fades a completed chip with item `opacity`. **No completed all-day item exists in the fixture. Recorded, not fixed.**
- **A TRANSLUCENT CHIP CANNOT BE JOINED BY OVERLAP (R108, load-bearing).** A join must be an opaque pre-blend. R109's reach = 3 px measured, 4 px shipped.
- **THE JOINT'S 3 px IS ONE PIXEL OF SLACK IN THREE PIECES (R108, load-bearing).** A column is **119.0 px** (833/7) and draws its own separator as its **FIRST** pixel; the chips sit inset 1 ⇒ a chip is **116 px inside a 119 px column**.
- **ONLY A LEFT-EXTENSION CAN HIDE A RULE (R108, load-bearing).** A right-extension can never cover the neighbour's rule; the neighbour's own chip, extending **left**, can.
- **A CONTINUATION IS A DATE FACT; A COLUMN IS A PLACE (R109, load-bearing).** `allDayContinues()` is pure date arithmetic; **gate the reach on `allDayColumn.index > 0`.**
- **THE ALL-DAY BAND IS CONTENT-SIZED WITH A ONE-ROW FLOOR (R106, load-bearing).** `allDayBandRows = clamp(maxItemsAcrossThe7Columns, 1, 3)`: **26 px** all-day-empty, **76** on the 3-row week. **`allDayMaxRows` and `allDayBandRows` must stay separate variables.**
- **OUR WEEKS START MONDAY, AND AN EXPANDED SIDEBAR SHIFTS THE DAY COLUMNS (R106, load-bearing).** Expanded: gutter **221..272**, separators at **272/391/510/629/748/867/986** — **pitch 119**. So **`x=577` is the 3rd day column; Thursday is 629..747 (x~690)**. **R115 note: the reference's mini month headers read `S M T W T F S` (Sunday-first) where ours read `一二三四五六日` (Monday-first) — an unfiled heading divergence. M02's clauses are unaffected.**
- **AN ALL-DAY-EMPTY WEEK STILL SHOWS A 26 px BAND (R106, extrapolation).** The spec says "min about 28", so the band has a floor rather than a hide.
- **THE REF'S SIDEBAR IS 192 px WIDE — "243px sidebar" WAS A CONFLATION (R105, load-bearing).** The 237-plane ends at **x=191**; the white hour gutter runs **192..243** and the first *day column* starts at **243**. ⇒ the reference's **main region is 192..813, centre 502.5** — and its segment's rim centre is **502.0**. **R063–R104 carried the wrong denominator ⇒ any ref-centredness number derived from "grid 243..812" must be recomputed.**
- **A CENTRED-IN-REGION SEGMENT IS −0.5 px ON BOTH SIDES, AND THAT IS THE CONVENTION (R105, load-bearing).**
- **A CAPSULE'S OUTER RADIUS IS MEASURED AGAINST ITS OWN INNER ELEMENT, NEVER IN ABSOLUTE PX (R104, load-bearing).**
- **AN ARC-ONLY FIT CANNOT SEPARATE r FROM y0 AND IS THEREFORE NOT AN ABSOLUTE INSTRUMENT (R104, load-bearing).** **Report the bound (11–13.5), not a point.**
- **A PILL'S HORIZONTAL PADDING IS MEASURED AGAINST ITS OWN SLOT, AND THE SLOTS OF A SEGMENTED CONTROL TILE (R102, load-bearing; R103).** **R103: the rule applies to both sides or the comparison is void. Correct ref slot = (228−4)/4 = 56.0.**
- **A WHOLE-CONTROL WIDTH CAN BE A SPEC LITERAL THAT OVERRIDES THE REFERENCE (R103, load-bearing).** **L03 fixes 180–210 ⇒ a 3-label control can never match a 4-label reference's pill width.**
- **WORD CENTRES BEAT CONTROL EDGES FOR A PITCH (R103, load-bearing).**
- **THE REFERENCE'S SEGMENTED CONTROL AND OURS SHARE ONE RADIUS TOKEN (R101–R104).** Ref lens **r ≈ 11.5 on h 24 (0.48)**; ref track **r ≈ 13.4–13.5**; ours **0.48 on both**.
- **A RADIUS IS MEASURED 1:1 AGAINST A SAME-HEIGHT ELEMENT, AND THE METHOD MUST RECOVER A KNOWN TOKEN FIRST (R101, load-bearing).** **threshold = the midpoint of THAT IMAGE's own two constants**; **only when the profile is monotone across the edge. R104: prefer the *within-image* track-vs-lens profile.**
- **A WHOLE-PAGE `ImageChops.difference` WITH A PER-ROW DIFF COUNT IS STILL THE CHEAPEST CONTAINMENT PROOF (R088).** Threshold **>6 RGB-sum**. **R109 used it to prove the `index > 0` guard is invisible.**
- **NEVER SCALE A REF *TYPE* ELEMENT BY THE WINDOW RATIO — FIND A SAME-CLASS INK IN BOTH IMAGES FIRST (R086).**
- **MEASURING A CORNER, A JOINT, A STRIPE, A BORDER OR AN INK (R075–R117).** Corner: per-row **fill-start inset** (body mode, R098; **interior rows, indexed from the first counted row, validated on a known token — R101/R102**; **R103: only on a monotone edge**; **R104: on a 250-on-255 fill use the rim's argmin core, and compare the outer element against the inner one in the SAME image**). Joint: per-row **`!= white` envelope**; **R107: a shared *horizontal* edge is separator-tone + the very next row's tone; R108: a shared *vertical* edge is the pair of fill edges plus whatever sits between them, and a JOIN must be read as an absolute tone against the fill; R109: after the join, the acceptance is "the fill envelope is unbroken and contains no 255 and no rule tone".** Stripe: a saturated run whose **width is constant over the chip's full height**. Border: **monotonicity of a raw profile across an edge that abuts no rule**. Ink: the **per-channel coverage agreement test PLUS the channel-gap argument**; cross-capture: **top-5 %-coverage mean** and **`n<100`**; **R115: a glyph inside a disc needs a ×6 zoom**; **R116: and if the glyph and its outline share one token, even the zoom needs the source**; **R117: a *disc* needs an ENVELOPE under one criterion for both members of the pair, row-bounded to its own cell — a per-tone tolerance reads the same disc 2 px narrow.** **Pitch: word centres, not edges (R103).**
- **HARNESS / COMMAND / TOKEN RULES.**
  **THE CAPTURE ACTION IS `captureClient` + `path` (R117).** `capture` + `name` matches no `action` and **silently hits the fallback**: no PNG, no log line. Verify with `grep "native app client capture" live-runtime-vm.log` **and** `ls` the file. **A `captureClient` RETURN OF `false` MEANS A NESTED RELATIVE PATH AND THE PNG IS SILENTLY NOT WRITTEN (R075)** — pass a **flat filename**. **Pillow crops need ABSOLUTE paths** — the shell CWD moves between calls. **R107: our PNGs are written at zlib level 0 — three different captures share a byte size, so compare `md5sum`, never the size.**
  **THE LAUNCHER REFUSES WHEN A LIVED INSTANCE IS ALIVE (R079), AND `>/dev/null` HIDES IT.** `start-review-vm.sh` exits **1** with `Owned review instance still running: <pid>`. **ALWAYS `kill -0 $(cat live-app.pid)` FIRST: if the leg you need is already alive, the capture is FREE** (R114/R115 both took that path). **R116/R117: a REBUILT binary needs kill + relaunch — a live instance keeps running the OLD resources, theme fixed at launch — so a source change always costs the full cycle (kill `live-app.pid` → `nohup ./start-review-vm.sh light|dark &` → `sleep 40` → `python3 review-command.py '<json list>'` → grep `capture ... true`).**
  **`review-command.py` IS NOT EXECUTABLE — always `python3 review-command.py`.** It takes **ONE argv that is a JSON list**, bumps `sequence` from the file's own last value, writes **in place** (never `os.replace`), sleeps 0.6 s between commands.
  **HARNESS COMMAND FORM IS FLAT (R064).** `harness/Main.qml` matches `command.action` only; a command with no `action` **silently hits the fallback**. Include `resize 1100x692`; the app starts in `--view week --date 2026-10-15` **with the sidebar COLLAPSED** (`{"action":"sidebar","expanded":true}` expands it; `{"action":"date","date":"YYYY-MM-DD"}` re-dates). Only `date`/`position`/`wheel`/`flick`/`stop`/`openItem{kind,titleContains}`/`windowWheel`/`captureClient` are available: **`hovered`/`pressed` chrome cannot be driven, and a static screenshot can never settle an animation.**
  **Compositing (R077/R080/R088/R097/R099/R101–R109/R115/R116/R117).** **A composite (a 1:1 strip above/beside a 2–6× zoom) answers "overall form + local detail" in ONE image read**, and **labelling the rows (`ImageDraw.text`) is what makes it self-describing.** **`LANCZOS` for a ×1.8 upscale of a ref crop; `NEAREST` when the point is pixel structure.** **Captions go on the FINAL canvas at 1x — text drawn *before* an ×N upscale is illegible, and the canvas height must include the caption block.** **R109: side-by-side panel captions collide even at 615 px of canvas — stack caption LINES, one per panel, at full width. R116: three panels side by side (ref 192 + ours 220 + zoom 612) fit in `W = 1080` with a single full-width caption line at the foot. R117: a TWO-ROW composite — row 1 the two 1:1 months (192 + 220), row 2 the ref disc ×6 (168) beside ours ×6 (528) — needs `W = 12 + 168 + 16 + 528 + 12 = 736` and fits `H = 431`; short full-width caption lines at the foot of each row.** **No `numpy` here.**
  **A WIDE, SHALLOW CROP CANNOT BE READ AT ×5+ (R107).** **Crop to the feature (≤30 rows) and anchor on the feature.**
  **`tmp/` is gitignored.** The committable artifact is the mirror under **`docs/ui-calendar/`**: copy screenshots in (name them **`r0NN-<slug>.png`**) and **prepend** the round summary to `docs/ui-calendar/LEDGER.md` (newest first) — **prepend with `Path.write_text(entry + old)`; an `Edit` whose only `old_string` is the previous round's heading deletes that heading.** `state.md`/`rounds.md` can never be committed — expected. **Commits must end with the `Co-Authored-By: Claude Opus 5` trailer.** **A `python3 -c` whose payload contains markdown backticks is mangled by the shell — write the payload to a file and use a heredoc.** **R116: a bare `sum(px[x,y]) < cut` band scan with `cut ≈ 660` is the only form that works on the 228 plane; and the FINAL band must be flushed after the loop.** **R117: the 3-round-trip cost of a wrong action name is the evidence — grep the capture line before believing a screenshot run, and note that `CWD` persists between Bash calls so a bare `cd` once is enough (the harness reports the change).**

## Pinned geometry (unchanged — see rounds.md tail for the derivations)
- **OUR COLUMN MAP AT 1100x692.** Sidebar-collapsed: rim x0; gutter x1..51; separators **52/202/352/502/652/802** in BOTH band and grid, pitch 150, 7×150 delegates from 52, weekend = the last two. **Expanded: gutter 221..272, separators 272/391/510/629/748/867/986 (pitch 119), Thu = 629..747.** Sidebar x0..219 (rim at x220). Toolbar segment track x562..757 (w 196), lens x630..689 (w 60) on segment 2 = Week (`radius 13.44` track / `11.52` lens); label centres 595.5/659.5/723.0 (pitch 64.0); capsule y36..63, lens y38..61.
- **THE MINI MONTH, EXPANDED SIDEBAR (R112/R115/R116/R117).** Cells 12..208 in the 220 px sidebar; `cellWidth = 196/7 = 28.0`, `cellHeight 21`; column centres **26.0 + 28.0i**; date-band tops **545** (weekday header) then **561 / 582 / 603 / 624 / 645 / 666 / 688** (9-row bands, font 11). **Both discs are `tahoe.miniDisc` = 18x18** (R117; was 15), today = `todayRed` `(229,72,77)`, selected = `selectionDisc` `#8E8E93` `(142,142,147)`, both with a white digit; the selected cell's plane reads (228,228,228). A disc-bearing row's scan is polluted by the disc's overhang (18 px disc: 4–5 above / 2–3 below the 9-row band).
- **THE ALL-DAY BAND'S Y-MAP (light 1100x692).** `sectionRule` **y=155** (242 light / 39 dark, 1px); 3-row leg interior **156..231 = 76**; `allDaySeparator` **232-233** (217, 2px); grid top rule **234** (237). Chips **157-180 / 182-205 / 207-230**. 0-row leg: interior **156..181 = 26**, separator 182-183, rule 184. ⇒ **band = 1 + 25N; everything below translates by 25 per row.**
- **OUR ALL-DAY CHIP.** Expanded sidebar, 3-row strip week: Mon chip **273..388**, Tue **392..507**, Wed **511..626** laid out; with R109's reach Tue/Wed start at 388/507 so the envelope is **273 … 626 unbroken**. ⇒ **chip = 116 px in a 119 px column, inset 1 each side.** `Multi-day review`'s fill is **(220,235,245)**.
- **REF ALL-DAY BAND, 1:1.** Rows **y126-143 / 145-162 / 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule **y=124** (242); bottom separator **183-184** (217); grid top rule **y=185** (244); inset ≈1; content **125..182 = 58**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; ink = itemColor/2; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**. **R108: every ref band chip is SINGLE-DAY, inset ~6–7 ref-px from its column rule; there is no multi-day bar.** Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 (or 26) / hue ink — every *form* item matched **except the icon (仍差 #2)**.
- **REF TIMED CHIP, 1:1.** Outer pitch **27 px/hour**; a 1-hour chip spans **y331..356 = 26**. Fill = light desaturated same-hue wash (blue (222,237,254)); text = the bar at 1:2; left bar 2.4 px, ~3 px in, round caps; no border.
- **OUR TOKENS.** `CalendarScheduleView.qml:95-112`: `gridLine` (light `#EDEDED` / dark white@0.13), `gridLineMinor` (`#F4F4F4` / white@0.06), `allDaySeparator` (`#D9D9D9` / white@0.24), `sectionRule` (`#F2F2F2` / white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, dark 39 < 59 < 84. Schedule grid field pure **WHITE** light / **(30,30,30)** dark (the local `scheduleField` token, R109; must track `Root.tahoe.contentPlane`, `Main.qml:47-48`). Weekend columns **249 light / 37 dark**; the gutter is NOT tinted. Sidebar plane light **(228,228,228)**; the mini month's weekend cells **(214,214,215)**.
- **`hourHeight` is THE pitch constant (R064)** (`:53`). Chip height **16**, half-hour line **20**. Additions since: R072 the four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`; R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill`; R099 the segment's `mutedTextColor`; R101 `LiquidSegmentedControl.qml:121`; R102 `:117`/`:119`; R104 `:87`; R106 `CalendarScheduleView.qml:64/76-83/483/411`; R108 `:548`; R109 `:87-92`, `:114-134`, `:551-562`, `:568`; R116 the mini-month `tahoe.selectionDisc` + the delegate's white digit; **R117 the mini-month `tahoe.miniDisc: 18` + the delegate's shared `Rectangle` (`Main.qml:2243-2250`)**.
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at x ≥ 3.**
- **REF FACT SHEET (R063, compacted; R103/R104/R105/R107/R108/R115/R117 revise the segment, the sidebar, the band and the mini month).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed Apr 1**) + a **192px sidebar** (plane 237, ends **x=191**, mini month with today Apr 1 at **x91..105 / y395..409**, header `S M T W T F S`, **column pitch 24.25**) + a **52px white hour gutter (192..243)**. Day headers (text y108-116) → all-day band (y124–184) → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill replaces the 10 AM label (centre = the now-line **y=238**), red **(235,76,70)**. **7 equal day columns, 1px separators at 324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ 36 (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.** **Toolbar row y4..36**, holding the traffic dots, a 2-icon capsule x≈122..190, a round `+` x≈205..230, the Day/Week/Month/Year capsule at **x388..616 (W 229, slot 56.0, selected pill W 51–52.4, h 24 y12..35, r 11.5, word centres 418/474/530/586, track rim core x388..616 / y8..38 ⇒ H ≈ 31, r fit 11.25–13.5 = the lens's own 0.48 token, R104; rim centre 502.0 = the main region's centre 502.5 to 0.5 px, R105)**, and two round glass buttons (radar, search) at x≈735..810. *The ref track has no measurable fill edge (R103), so all its edge-derived numbers carry ±1.* **R116: the ref mini month is the first thing a new mini-month claim should be checked against — `x0..191 / y330..540` holds the whole month in one crop. R117: its today disc fill is `(207,51,35)`, NOT the 9:41 pill's `(235,76,70)` — see 仍差 #8.**
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-30 … 2026-04-06** plus a **`Multi-day review`** all-day strip **`20260330` → `20260403`** (a 3-column run on Mon/Tue/Wed; Thursday does NOT carry it). **R087 ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** UID-ordered since R083. WTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00. **R107: the per-column all-day capacity in the fixture is {0, 3} — no 1- or 2-row week exists. The all-day columns carrying chips are Mon–Fri; Sat/Sun are empty (so the weekend chip backdrop is unwitnessed).** **R115: `date 2026-10-15` is the M04 fixture — its week carries BOTH today (Sat Oct 17) and the launch selection (Thu Oct 15); its Oct-2026 grid puts those at row 2 = band top 603, columns 3 and 5.**

## ## Next round (pick ONLY #1)
**#1 — 仍差 #7, the month chevrons (unfiled, NOT ruling-blocked).** Our two `KosToolButton`s in `Main.qml`'s `miniCalendarHeading` draw **4x5 px** of ink (x24..27 / x192..195, y523..527, both legs) where the ref's arrows are **9 px** tall. M02 demands only *equal* arrows — satisfied — so this is a plain glyph-size question: **one atomic edit + one light leg** (`date 2026-10-15`, sidebar expanded, capture). **Re-measure BOTH arrows as a pair at two thresholds (R114's instrument) and do not touch the mini month's discs, bands or `categoryInset`.** Ref check: crop the ref's own two chevrons (`x0..191 / y330..360`-ish) at ×6 beside ours before choosing a number.
**#2 — 仍差 #8, the darker mini-month disc red (`(207,51,35)` vs our `todayRed` `(229,72,77)`).** Recorded R117. **Only approach it with a judgment about vibrancy vs flat rendering — do not swap the literal blind, and do not touch `AppTheme.todayRed`'s other four consumers.** If the answer is "our flat sidebar should keep one red", the round's deliverable is the *decision* written into state.md, not a code change.
**#3 — the chain in spec order:** **S02/S03/S05, C01-C04/C06, E01/E02** (clauses 1+2+3 PASS), **L01-L07** (L03 done R105).
**T01/T02/T03 done BOTH legs (R111 light / R113 dark). M01/M02/M03 done BOTH legs (R112 light / R114 dark). A03 done BOTH clauses and BOTH legs (R108-R110). A01 done but for G (R106); A02 done (R107). M04 done ALL THREE halves (R116 (a), R117 (b) and (c) on the light leg, (c) dark R115).**
**Blocked / open on rulings A-H:** the **band icon (H, R081)**, dim snap (A), shadow magnitude (B), popover `CloseOnEscape` + E03 clause 3 (C/E; clauses 1+2 PASS R048), month `slice(0,2)` (D), **F = 12-hour two-tone gutter labels**, **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**, **and a 4th `Year` segment**. **No rulings channel exists anywhere in the tree.**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R117 were done inline.**
**The binary was rebuilt at R117** (the 18 px disc) — R109-R115 figures came from the R109 build, R116's from the R116 build; **`r117-m04-disc-light.png` is the first of the current one.**
**Not `DONE` — all spec IDs do not pass.** (**L03 PASS R105 5/5; A02 PASS 3/3 R107; A03 PASS both clauses, both legs R108/R109/R110; T01/T02/T03 PASS BOTH legs R111/R113; M01/M02/M03 PASS BOTH legs R112/R114; M04 PASS all three halves R116/R117; A01** PASS-pending-final-regression with clause (a) measured R106; **A04** fully PASS (+2 row re-verified mid-band R106); **E01/E02** clauses 1+2+3 PASS and the band ink PASS (R080); **N02 closed on both legs (R085)**; **S02/S03/S05/L01-L07/C01-C04/C06 PASS-pending-final-regression**; **S01 + S04 MEASURED R096**; **C05 — what remains is the pointer half (no harness action drives it) and the label COUNT (ruling-blocked)**.)
```

## R119 — 仍差 #7 CLOSED AS A DECISION: the mini-month title's ink is `0/255` and the reference's `97/255` is VIBRANCY, not a token. Figure `r119-title-ink-vibrancy.png`. NO code change, 0 builds.

Atomic step: **answer 仍差 #7's caveat.** Per R117's rule, the same-class ink had to be found on a **flat** surface of the SAME screenshot before any token was read out of the vibrant sidebar. Artifacts: `docs/ui-calendar/r119-title-ink-vibrancy.png` + `LEDGER.md` + `state.md` + this file. **No source file touched, no build, no launch, no capture** — `r118-chevrons-light.png` IS the current build's light leg.
**Flat surfaces give 0, twice, independently.** (a) The **toolbar segment words** `Day / Week / Month / Year` (x388..616 / y8..38) sit on a plane measuring **darkest 254 / lightest 255** and their ink is **darkest `(0,0,0)` in ALL FOUR slots**. (b) The **main-region day headers Mon..Fri** (x324..487 / y104..120, plane 255) ink **`39/255`**; the dimmed weekend pair reads `128`.
**Compression is the proof, not the single number.** On the one vibrant plane the ref spends **97** on its *primary* label and **110** on its *secondary* one (the weekday header `S M T W T F S`) — **1.13x**. Our real token pair differs by **0 vs 156 (156x)**. A surface that lifts `0 -> 97` and `0 -> 110` is a **blend of the desktop behind it**; `97` is not a token value.
**Ours, same instrument:** ink **darkest `0/255`, darkest-5% `0/255`** (`x75..143 / y519..530`); plane **`228,228,228` flat everywhere** (empty sample x150..210 / y300..330 = exactly 228). We have no vibrant sidebar, so 0 is the correct flat render of the same label.
**Spec check:** no ID constrains this tone (M01–M04 cover position / centring / date size / discs only), and `spec.md:81` says only the light week has a direct bitmap reference and other states must not pretend pixel-identical coverage.
**Decision:** the `miniCalendarHeading` title `Label` **keeps `root.tahoe.labelPrimary`**; a `97` literal would emulate a material we do not implement AND overshoot (our nearest token, `labelSecondary`, is 156). **Side observation, not a gap:** our title localizes to `2026年10月` where the ref reads `April 2026` — L06 sanctions it and R118's digit-based comparison is unaffected.
**Containment:** nothing built or relaunched, so no geometry could move; the figure's ours-panel is cropped at `x70..148`, i.e. **outside both chevrons (x23..27 / x191..196) by construction**.
**NEW RULE (see state.md 外推待确认): a vibrant surface's ink tone is not recoverable as a token — test it on the same image's flat planes. 仍差 #7 and #8 are one phenomenon.**

# R120 — **仍差 #7 (the two reds) CLOSED AS A DECISION by R119's own rule — and the rule now covers SATURATED FILLS, not just ink.** The ref's mini-month disc **(207,51,35)** sits on the **VIBRANT** sidebar (plane **237**); the same semantic red on the ref's **FLAT** planes reads **(235,76,70) TWICE, independently** — the `9:41` now-pill on the white hour gutter (n=230) and the **now-line over the flat grid inside today's column** (n=113, solid run `x493..569` = exactly the Wed column `487..569`). `vibrant - flat = (-28,-25,-35)`: **B -50%, G -33%, R -12%** — a saturation boost, the same class of distortion R119 measured for ink (flat `0` -> vibrant `97`). **Our disc reads exactly `todayRed` `(229,72,77)` on our flat 228 sidebar; the ref's own flat red is 7/255 (max channel) away — inside the noise of a re-encoded screenshot.** => **both discs keep `todayRed` / `selectionDisc`; no code change, 0 builds, 0 launches.** Figure `r120-two-reds-flat-vs-vibrant.png`. **CONSEQUENCE: every remaining 仍差 #1-#6 is RULING-BLOCKED — no plain-judgment visual gap is left, so the next rounds go to the spec-ID chain.**

## 本轮 (R120)
Atomic step: **apply R119's flat-plane test to 仍差 #7's caveat — does the token track the vibrant member `(207,51,35)` or the flat member `(235,76,70)`?** Artifacts: `docs/ui-calendar/r120-two-reds-flat-vs-vibrant.png` + `LEDGER.md`, `state.md`, `rounds.md`. **No source file touched, no build, no launch, no capture** — `r118-chevrons-light.png` IS the current build's own light leg.
**The planes, same instrument, one image.** Ref: sidebar **`(237,237,237)`** (`x150..190 / y440..470` — the plane the disc sits on, the same 237 of R114/R119), white hour gutter **`255`** (`x196..240 / y300..312` — the plane the pill sits on), toolbar **`254/255`**. Ours: sidebar **`(228,228,228)` flat, n=1800/1800** — no vibrant surface exists in our app.
**The flat samples, twice, independently.** (a) the `9:41` now-pill `(235,76,70)`, n=230, the mode of `x192..244 / y224..252`. (b) the **now-line** over the flat grid inside **today's** column `(235,76,70)`, n=113, mode of `x250..810 / y234..242`, whose solid-red run is `x493..569` with faded `(243,152,149)` tails elsewhere. Two different widgets, two different flat planes, one tone.
**The disc, ours.** `(229,72,77)`, n=126, mode of the red envelope in `x12..208 / y596..640` — i.e. **exactly `todayRed`**; the selection disc reads `(142,142,147)` = `selectionDisc`, n=114. Disc centres **x=166** (today, Sat Oct 17, col 5) and **x≈110** (selected, Thu Oct 15, col 3) on band top **603** — Monday-first columns, matching R115.
**Why the vibrant number is not a token.** A material that lifts a black `0 -> 97` and pulls `(235,76,70) -> (207,51,35)` is reshaping the tone scale; and the reshaping is **not** uniform (R -12% but B -50%). A flat darkening by the plane ratio (237/255 = 0.93) would give `(219,71,65)` — **not** the measured `(207,51,35)`. So the sidebar's material, not a colour token, produces 207/51/35.
**The pair test, the decisive one.** Ours vs the ref's *flat* member: `(229,72,77)` vs `(235,76,70)` = **Δ(-6,-4,+7)**, max channel **7/255 = 2.7%** over a 230-px mode of a re-encoded screenshot — at or under the noise floor, and **≈ΔE 2**, i.e. at the edge of visibility on an 18 px disc. Ours vs the ref's *vibrant* member would be Δ(-22,-21,-42), but that comparison is invalid: **our sidebar has no material to apply it.**
**Consistency with R119.** R119 kept the title ink at `labelPrimary` (flat `0`) rather than copying the vibrant `97`. Copying `(207,51,35)` here would make our *flat* rendering **more saturated than the reference's own flat rendering** of the same semantic red — the mirror-image mistake. The material argument applies the same way on both surfaces, so both keep their flat token.
**Containment:** `AppTheme.todayRed` has 5 consumers and was **not touched**; `selectionDisc` was not touched; no other file changed. Nothing was built or relaunched, so no geometry moved and R118's light leg is still the current build.
**Side observation (not a gap):** our selection disc is the *gray* `selectionDisc #8E8E93`, matching the ref's own selection treatment; only the today disc is red. No ID constrains either. Our mini-month title reads `2026年10月` where the ref reads `April 2026` — ruled on in R119 (L06).
**NEW RULE (extended):** *a vibrant surface's tone is not recoverable as a token — not for ink and not for a saturated fill; test it on the same image's flat planes, and for a fill ask whether the vibrant member is a scalar multiple of the flat one.*

## R121 — S02 / S03 / S05 re-verified on the R118 build (light, expanded sidebar): all three PASS

**Scope:** S02, S03, S05 — the three spec-only sidebar IDs ("final regression due" since R007). The reference PNG cannot arbitrate them: its 192 px sidebar carries only the mini month (fact sheet, R063), so the accept criteria are the spec's own literals, measured as geometry on our own render.

**Method.** Live light leg (pid alive since R118) at 1100x692, sidebar collapsed at launch ⇒ `resize` + `sidebar expanded` + `captureClient` in one command list. First capture `r121-sidebar-light.png` (canonical fixture). For S05's elide clause the canonical lists are all short, so the private `Inbox` was renamed in the ISOLATED profile — `profile/pim/metadata.json` name -> `收件箱与 Personal Inbox 的一个超长名称用于省略号回归验证 2026`, `revision` 31->32 — the pim service reads it at startup, so **kill + relaunch + 45 s**, then `r121-s05-elide.png`. Restored (`cp` back, revision 31, canonical 4 names) and relaunched clean. The real calendar is never touched (own D-Bus session + isolated XDG).

**S02 — groups.** Heading inset **12**: `Calendars` ink starts x13–15; at 11 px a Latin `C` carries ~1 px bearing, so the Label's left edge is 12. Heading font **11** (`font.pixelSize: 11`; ink band y141–149 = 9 px for `Calendars`, no descender). Heading block 137..153 = `Layout.topMargin: 16` + `preferredHeight: 16` ⇒ first category row top **158.5**, gap **6** (spec 6–8). Group gap: last category row bottom 248.5 -> `Task lists` label top **264.5** = **16** (spec 16–20). Headings `labelSecondary` on the 228 plane.

**S03 — rows.** Pitch **30.0**, measured twice over, seven rows: box centres **173.5 / 203.5 / 233.5** (Calendars: 日程 / 计划任务 / 显示已完成) and **301.5 / 331.5 / 361.5 / 391.5** (Task lists: Inbox / Personal / UI Review Gold / UI Review Red). Checkbox **12×12**: the saturated run is x12..23 over y168..179 — twelve columns, twelve rows, no 13th at any threshold. Corner: the first and last rows are inset 1 px on each side ⇒ radius ≈2–3, and the token is `categoryBoxRadius: 3` (report token beside measurement). Label **13** (`categoryFontSize`), gap **8**: box right edge **24** -> Label left **32**; measured ink start **x33** (Latin `I`/`U`, 1 px bearing) / **x34** (CJK `日程`, tighter bearing). Nested row inset `12 + 24 = 36` (hollow box x36..47, 1 px coloured border when unchecked); checked = filled + white check. Row hover background x6 / width−12 / radius 6.

**S05 — elide + no redundant chrome.** The long mixed CJK/Latin name renders **single line with a trailing ellipsis** (`收件箱与 Personal Inbox 的…`), ink ends **x203**, inside the 12 px right inset (**208**) — no wrap, no second line, no collision with anything. **No switches** anywhere in the sidebar (the 12 px box carries the whole state) and **no persistent healthy-status card** (the `visible: !pim.connected` banner at `Main.qml:2333` is absent while connected).

**Verdict: S02 PASS, S03 PASS, S05 PASS.** Source untouched — `Main.qml:160-171` is the S02/S03 token block and matched the render on every clause, so no `code-writer` dispatch was needed. No build. Figure `docs/ui-calendar/r121-sidebar-groups.png` (two rows: canonical @1x + @2x, long-name @1x + @2x, captioned).

**NEW RULE:** *a spec literal is measured on our own render — in row pitch and box edges, not on a crop's eyeball; an elide clause needs a long-name fixture (isolated `metadata.json` rename + relaunch), and the token is reported beside the measurement.*

---

## R122 — C01 / C02 / C03 / C04 / C06 re-verified on the frozen R118 build (light week, 1100x692): **all five PASS**. Verification only — 0 source files, 0 builds.

"Settings" is settled as the settings app: our dot block `apps/calendar/qml/Main.qml:1637-1661` is character-identical to `apps/settings/main.qml:911-928`.
**C01** diameter **14** (red box x1072..1084 / y11..23; edges 1071.5/1085.5 and 10.5/24.5). **C02** edge gap **14** (centres 1022.5/1050.5/1078.5, pitch 28). **C03** last dot right **14.5** (red right edge 1085.5 = 1100 - 14.5) and top **10.5**; the toolbar chrome starts at y36, so 11.5 px clear and the R001 overlap is gone. **C04** order green/yellow/red, `#28c840` / `#febc2e` / `#ff5f57` at `opacity: 0.85`; composited over white = (72,208,93)/(254,198,77)/(255,119,112). **C06** band **30** — y0..35 hold no ink but the rim, the corner arcs and the dots; no strip and no duplicate titlebar; outer corner radius **30**.
Not a defect, recorded so it is not "re-found": the ref's own dots are macOS-order **red/yellow/green at the top-LEFT** (13 px, gap 8, left inset 17); C01-C04 bind the dots to settings, not to the ref.
Figure: `docs/ui-calendar/r122-window-dots.png` (top band 1:1, ours x6, ref x6, TL corner x8).

**Method.** Re-read only — the R121 light instance was still alive (`kill -0 $(cat live-app.pid)`), so the capture was free; `harness/command.json` was untouched because the dots and the band render in the default launch state at 1100x692. Ink scans used the plane pair (sidebar 228 / content 255, rim x220) as the per-column baseline; tone boxes were taken at full saturation and the antialiased edges reported as half-pixel edges — which is what turns a 13-column full-tone box into a 14.0 disc.

**R123 — E01/E02 light-leg re-read on the R118 build (light, 1100x692, sidebar EXPANDED, Thu 2026-04-02).** The chain's next unblocked step, done as a **re-read with a real measurement** — **0 source files touched, 0 builds**; the capture was free (the R121/R122 light instance was still alive, `kill -0 $(cat live-app.pid)` = ALIVE pid 199769, `KOS_APPEARANCE=light` read off `/proc/<pid>/environ`). One command batch: `resize 1100x692`, `sidebar expanded`, `date 2026-04-02`, `captureClient r123-e01-light.png` — log line `[UIReview] native app client capture r123-e01-light.png true`, file present.

**Clause 1 — tint light/desaturated: PASS.** Our 08:00 "Morning planning" chip fill reads **(216,234,245)** = `withAlpha(blue (48,140,198), 0.19)` white-composited (`CalendarScheduleView.qml:843-844`). The ref's own chip fill is **(222,237,254)** (re-measured at x489..567) — same hue, ours a touch lighter because our item blue is darker. Box **x632..743 (112 w) x y317..332 (16 h)**.

**Clause 2 — dark same-hue text: PASS.** Our ink core on the same chip and the ref's **(26,67,123)** = ref bar **(59,134,247) / 2** on every channel; ours is `root.chipInk` = `itemColor/2` (`:834`, R079's coverage test, 9 chips x 2 legs, ±0.05). The darkest pixel reads **(60,71,121)** — off the fill→ink segment (G too dark), i.e. the AA hazard R079/R080 already recorded, so the *endpoint* stays the instrument and the extreme pixel is never the evidence.

**Clause 3 — left stripe: PASS with a 1-px note.** Ours is **4 px core at x636..639**, no AA, fill left 632 ⇒ `stripeInset` 4 (`:831-832`, `chipHeight/4`). The ref's bar is **2 px core x491..492 + AA at 493** on fill left 489 ⇒ **2.4 ref px**, inset 1.5-2. At the ×1.35 ref→our scale 2.4 ⇒ **3.2**, so 4 is ~1 px over; E01's literal "2–3" is violated by 1 if it is read as *our* px, satisfied if the rule is `chipHeight/4` (16/4 = 4). **A scale-convention ruling, same class as A01's G — do not "fix" without it.**

**Clause 4 — radius about 3: **FAIL, ours is 5, off by 2.**** Ours: `radius: 5` (`:842`); top row (y317) half-coverage edge **x634.5** against full-left 632 ⇒ corner cut **2.5 px**, consistent with r 4.4–5. The **ref's own timed chip** cuts **≈1–2 ref px** — its top row (y331) never reaches full fill across x489..492 (max coverage 0.76, x489 = 0.52) while y332-333 reach full 222 at x489 — i.e. ref radius **≈2 ref px on a 26 px chip = 0.08×height**, and ×1.33 ⇒ **2.7 ≈ E01's "about 3"**. **The `row/3` idiom was generalised from the ALL-DAY pill (ref 6 on 18 = 0.33×) onto the TIMED chip, where the ref says 0.08× — that is where the +2 px comes from.** E01's literal and the ref agree here; the derived-family rule (R075) is the odd one out.

**Clause 5 — E02 inset about 4: MISMATCH by 1, ref-anchored.** Ours: rule x629, fill left x632 ⇒ **3 from the rule's left edge, 2 from its right edge**. Ref: rule 487, fill 489 ⇒ **2 from the rule's left edge, 1 from its right** — so ours is the ref + 1 at both counts, and the spec's "about 4" matches neither. Same G-class ruling as the stripe.

**Clause 6 — E02 column gap about 2: source-declared only, NOT observable on this fixture.** `spacing: 2` (`:808`) on the hour cell's ColumnLayout; no hour cell of 2026-04-02 carries two items (08:00 / 10:15 / 11:00 / 14:30 / 18:00 land in distinct hours, verified chip fills at y317-332 / 397-412 / 437-452 / 557-572) ⇒ **a 2-item-hour fixture is required before this clause can ever be measured**; it is recorded as declared, not passed.

**Clause 7 — E02 title 11–12 medium: **FAIL, ours is 9 and not Medium.**** `font.pixelSize: 9` (`:884`) with no `font.weight` — the only weight in the file is elsewhere. Measured on the render: ink rows **321..330 = 10 px** total (dense 323..328 = 6), i.e. a ~9 px font, where the contract asks 11–12.

**Clause 8 — E02 secondary 10–11: **ABSENT.**** The chip has ONE `Label` (`:877-887`) and no secondary line at all; the ref's chip ("Lunch wi…") is 26 tall and visibly carries a larger title plus its own glyph.

**Clauses 7+8 are not a font-size bug — they are a chip-height conflict, and that is the round's real finding.** Ours is **16 tall on a 40 px hour = 0.40 of the hour** (`Layout.preferredHeight: Math.round(hourHeight * 21 / 54)`, `:817`), because **T01's model fits TWO chips per cell** (16 + 2 + 16 = 34 = 40 − 2×3). The **ref's own 1-hour chip is 26 on a pitch 27 = 0.96 of the hour**; scaled ×1.33 it is ~35, which is what E02's 11–12 title + 10–11 secondary needs. **E02 and T01 cannot both hold as written ⇒ ruling, not an edit.** (Corollary the round also establishes: our chips are fixed-height regardless of duration, so a 15-min event and a 2-hour event draw identically — a separate question, recorded, not chased.)

**Verdicts: E01 = 3 PASS (tint, ink, stripe-with-note) + 1 FAIL (radius). E02 = 2 clauses unmeasurable/declared (gap) or ref-divergent by 1 (inset) + 2 FAIL (title, secondary). Neither ID may be flipped to PASS on this leg.**
**Not a defect, recorded so it is not "re-found":** the *ref*'s "Lunch wi…" chip carries a small glyph at its right edge — the ref's timed chip can hold a decoration our chip has no room for at 16 px. It is downstream of the same height conflict.
**Evidence:** `docs/ui-calendar/r123-e01-timed-chip.png` (ours + ref at x4 NEAREST and x4 LANCZOS, labelled, with the numbers in the caption block). Raw capture `tmp/ui-acceptance/calendar/r123-e01-light.png`.
**Method note:** `harness/command.json` was driven in place; the live pid was confirmed before any launch attempt, so the whole round cost ONE capture and no relaunch.


## R124 — the timed chip's radius, 5 → 3, and the fixture's hidden two-item hour

**Atomic step.** R123's Next #1 called it: `apps/calendar/qml/CalendarScheduleView.qml:838`
`radius: 5` → `radius: 3`, **scoped to `timedChip` only**. Two independent anchors agreed — the
contract's E01 "radius about 3", and the ref's own TIMED chip corner (top row y331 never reaches
full fill across x489..492, max coverage 0.76 ⇒ a cut of ~1–2 ref px on a 26 px chip = 0.08 ×
height; ×1.33 ⇒ 2.7). R075's `row/3` family rule — measured on the ALL-DAY pill, 6 on an 18 px row
= 0.33 × height — stays with the pill: `allDayChip` and the band are untouched, so A01/A03 remain
closed on `row/3`. The stripe comment at `:856-860` was rewritten: it claimed the bar sits inside
"the 5px corner curve", which is now false; the R124 note records the actual check (the stripe's
top-left at x=4, y=2 is 1.41 px from the arc centre (3,3), so it is still inside a 3 px arc).

**Build.** `ninja -C .build/calendar-review kos-calendar kos-pim-service` — 7 steps, all
qmlcache/rcc plus the link; no C++ recompiled. Clean.

**Capture.** The light instance from R121-R123 (pid 199769) had to die — a live instance keeps the
OLD resources — so `kill` → `start-review-vm.sh light` → new pid **202938**,
`KOS_APPEARANCE=light` (read off `/proc/<pid>/environ`). One flat batch of four commands:
`resize 1100x692`, `sidebar expanded`, `date 2026-04-02`, `captureClient r124-e01-light.png`.
The PNG landed at the **repo root**, not beside the other captures: the `path` resolves against the
**CWD of the process that wrote `command.json`**, which was the repo. Moved into
`tmp/ui-acceptance/calendar/`. 1100×692 RGBA, as expected.

**Measurements (all on the R124 render, light, expanded, Thu 2026-04-02).**

- **E01 c4 radius — was FAIL, now PASS.** Coverage-solved along the chip's top row (y317), using
  the pure-white background just above the chip as the blend target:
  alpha 0.05 @ x632, 0.54 @ x633, 0.79 @ x634, 1.00 @ x635 ⇒ the **half-coverage left edge is
  633.4** against a full-left edge of **632** ⇒ **corner cut 1.4 px, down from 2.5 px at radius 5.**
  Geometry predicts r=3 → 1.34 and r=5 → 2.82, so the render is tracking the spec, not the AA.
  The bottom row y332 mirrors it (leftmost full-fill x635 on both the first and last row).
  Contract "about 3" is now met **literally**.
- **E01 c1/c2/c3 — unchanged.** The chip's interior is **bit-identical to R123 up to ±1/255**:
  the 90×8 text interior `(642,321)-(738,329)` differs **only** in a 15×2 patch, **max Δ 1/255**
  (font AA, not layout). That is the proof a radius edit moved nothing but the corners — better
  evidence than a zoom. Fill **216,234,245** on every full-coverage pixel. Stripe **(48,140,198)
  at x636..639 = 4 px**, fill left 632 ⇒ inset **4**, unmoved by the radius change (row y324 reads
  `…245, 245, (48,140,198)×4, 245, 245…` across x634..642).
- **E02 column gap — was "declared, NOT measurable", now PASS, measured 2.** A run-scan down the
  chip's fill column (x660, clear of the stripe) from y280 to 620 gives the real y-map:
  **08:00 317-332 · 09:00 357-372 · 10:00 397-412 · 11:00 437-452 AND 455-470 · 12:00 477-492 ·
  14:00 557-572**, with 237-tone hour rules at 294/334/374/414/454/494/534/574/614 and 244-tone
  minors on the 20s. **The 11:00 hour carries two chips**: 437..452 and 455..470, both 16 tall,
  **gap exactly 2** ⇒ the 40 px cell holds **16 + 2 + 16 = 34** with the layout's 3 px margins
  (437 = top + 3, 470 = top + 37 = 40 − 3). `spacing: 2` (`:808`) is exact.
- **Why R123 called it unmeasurable, and why that was wrong.** R063 recorded that the fixture's
  five daily VEVENTs (08:00/10:15/11:00/14:30/18:00) "all land in distinct hour cells". That is a
  claim about **VEVENTs**. The fixture also carries **WTODOs**, and `[R019 LONGTASK]` sits at
  **11:00** — the same hour as the `Long review with a d…` VEVENT. The double has been sitting
  there the whole time. Generalised: **before calling a clause unmeasurable, enumerate every item
  class in the fixture at that time slot — a per-class list is not the union.**

**Verdict.** **E01 is 4/4 PASS on the light leg** (tint / ink / stripe / radius). **E02's light leg
is 1/4 PASS** (column gap), 1 off-by-one (inset 3 where the contract says "about 4" — though the
ref's own inset of 2, ×1.35 ⇒ 2.7, says our 3 is the ref-correct number and "4" is the outlier), and
2 ruling-blocked (the font clauses, which cannot hold while the chip is 0.40 of the hour — the
11:00 double is now the visible exhibit for that collision, since two 16 px chips plus a 2 px gap
consume the cell exactly and leave no room for an 11 px title and a second line).

**Not touched, not passed**: `allDayChip`, the band, the month, the sidebar. **Figure:**
`docs/ui-calendar/r124-e01-radius.png` (ref corner vs ours, ×6 NEAREST, stacked captions).
## R125 — the DARK leg of E01/E02 on the R124 build, plus the L01/L02/L04/L06/L07 re-read. No source touched.

**Atomic step:** read the dark leg of the two IDs whose light legs closed at R124, on a live dark instance (kill 202938 -> relaunch, `live-app.pid` 204727, `KOS_APPEARANCE=dark`), one batch `resize 1100x692` / `sidebar expanded` / `date 2026-04-02` / `captureClient r124-e01-dark.png`; then a second capture in month view (`r125-L06-dark.png`) for L06. Figure `docs/ui-calendar/r125-dark-e01-toolbar.png`.

- **E01 dark — 4/4 PASS.** c1 tint: every full-coverage pixel is **(36,69,90)** = `itemColor` (48,140,198) at **0.36** over the dark field (30,30,30) — 30+0.36*18 = 36.5, 30+0.36*110 = 69.6, 30+0.36*168 = 90.5. The token is `AppTheme.dark ? 0.36 : 0.19` (`CalendarScheduleView.qml:850`) — a *declared* dark alpha, not an inversion of the light 0.19. c3 stripe: **(48,140,198) at x636..639 = 4 px**, i.e. byte-identical colour and geometry to the light leg, inset 3 from the rule at x629. **c4 corner: the top row y317 gives the SAME AA triple as the light leg** — t = 0.05@632 / 0.54@633 / 0.79@634 → half-coverage edge **632.9** against full-left 632 ⇒ cut **≈1.4 px**; radius 3 holds on dark, and the identity of the triple across legs is stronger evidence than either measurement alone.
- **E01 c2 ink on dark is the POLE MIRROR, and it is proved by the blend, not by the extreme pixel.** `chipInk` (`:269-276`) moves `itemColor` half toward the leg's pole: light pole 0 (→ half to black, R079), dark pole 1 (→ half to white) ⇒ (48,140,198) → **(151,197,226)**. At 9 px ink **no pixel reaches full coverage** (0 pixels > 0.9); the peak pixel is (716,326) = (136,182,209) with per-channel coverages **0.870 / 0.883 / 0.875** — agreeing to 0.013, i.e. sitting exactly on the fill→ink line. PASS.
- **E02 dark — column gap PASS, measured 2.** The 11:00 Thu cell carries the same double as light: **y437..452 and y455..470** (16 + 2 + 16 = 34 in the 40 px cell). Inset still **3** (off-by-one vs "about 4", unchanged, G-class); the two font clauses stay FAIL (chip-height ruling). The gap read is now on BOTH legs.
- **The stripe's 4 px at x636..639 is hue-invariant** — measured on all three chips the 11:00/12:00 rows expose: blue (48,140,198) fill (36,69,90) · green (57,196,135) fill (40,90,68) · gold (215,166,44) fill (96,79,35); each fill is its own stripe at 0.36 over 30 (30+0.36*Δ verified per channel). One geometry, three hues.
- **L01 PASS** — sidebar **x0..219 = 220**, one 1 px rim at **x220** (53,53,53), main canvas 221..1100 continuous to the window edge (no outer card margin).
- **L02 PASS** — toolbar band **y30..69 = 40** (the segment capsule y36..63, h **28**, centred at 49.5 = the band's centre); button boxes **28** (left pair 12..39 / 48..75, right pair 1022..1049 / 1058..1085), gaps **8**; icon item size **16** (`Main.qml:189 toolbarIconSize`) with **13 px** of glyph ink inside it — token beside measurement.
- **L04 PASS** — sidebar-toggle + add at the left (x12/48), search + more at the right (x1022/1058); no duplicate prominent New Event button anywhere in the chrome.
- **L06 PASS** — heading band **y70..117 = 48** (its lower rule at y118); week-view title ink left edge **241** ⇒ inset **20** from the main region's 221; title ink box **28** tall ⇒ the 26–28 font.
- **L07 PASS** — group ‹ 970..995 / 今天 1002..1047 / › 1054..1079, all **26** high (y81..106), right edge 1079 ⇒ margin **20** (the same inset as L06), inter-button gaps **6**, 1 px subdued grey borders.
- **L05 (search expansion) NOT re-read this round** — it needs the pointer to open the search field and the harness has no named point for it; carried to Next.

### 外推 (R125)
- **THE DARK WASH IS A DECLARED TOKEN, NOT A DERIVATION.** 0.19 light / 0.36 dark sits at `:850`; 0.36 is not 1−0.19 nor any scalar of it. Read the dark leg against the token — never by inverting the light alpha.
- **A THEME MIRROR IS PROVED BY THE BLEND, NOT BY THE EXTREME PIXEL.** Where ink is small and AA'd, no pixel is pure ink; the evidence is that the peak pixel's **three channel coverages agree** (here 0.870/0.883/0.875), which is what places it on the fill→ink line. Same lesson as R118, now with the mirror pole as the target.
- **A LEG CHANGE THAT LEAVES THE GEOMETRY ALONE SHOWS UP AS AN IDENTICAL AA TRIPLE.** The top row's t values are byte-for-byte the light leg's; geometry claims are cheaper to prove cross-leg than within one leg.
- **A HUE-INVARIANT FORM CLAUSE SHOULD BE READ ON MORE THAN ONE HUE IN THE SAME CAPTURE.** The stripe's 4 px / inset 3 held on blue, green and gold at once — one capture settles what would otherwise take three.


---

## R126 — the dark leg of S02/S03/S05 + C01-C04/C06 — ALL PASS (read-only, free capture)

### 本轮
Next #1 of R125. `kill -0 204727` → **ALIVE**, `KOS_APPEARANCE=dark` ⇒ **no relaunch, no build, the capture was free**. The R125 capture had left the app in MONTH view (R125's last action was `view month`), so the batch re-set the view: `resize 1100x692` / `view week` / `sidebar expanded` / `date 2026-04-02` / `captureClient r126-dark-s02-c01.png` — **one** `review-command.py` call, md5 distinct from both R125 PNGs.

### The chrome (C01-C04, C06) — every number is the R122 light number
- Plane check first: y5..29 reads **(40,40,40)** at x50 (left of the sidebar rim) and **(30,30,30)** at x300/600/1000 (right of it) ⇒ **C06's "carries the window's own planes" holds on dark as 40/30** (the light reading was 228/255). No strip, no title text; the first toolbar ink at x1078 is y37 ⇒ the chrome really does start at y36.
- **The outer corner radius 30 is proved, not restated.** R122 derived 30 from `Main.qml`; this round *predicted* the pixel: the corner circle has centre (1070,30), so on the row y=17 the window's edge sits at 1070+sqrt(900−169) = **x1097.04** — and the capture goes to (0,0,0) at exactly **x1097**. On y=5 the same arc predicts x1086.58 and x1090 is already black. The geometry forecast the pixel.
- **C04 is a blend claim and was solved three times.** The dots are hardcoded literals under `opacity: 0.85`, so on dark the prediction is 0.85·token + 0.15·**(30,30,30)**. Full-coverage cores: green **(38,174,59)** vs predicted (38.5, 174.5, 58.9) · yellow **(220,164,44)** vs (220.4, 164.3, 43.6) · red **(221,85,78)** vs (221.25, 85.25, 78.45). **Every channel within 0.5/255**, order green/yellow/red. (Light leg R122: (72,208,93)/(254,198,77)/(255,119,112) over white.) This is R125's "prove the mirror by the blend" applied to a *literal* rather than a wash — different rule, same method: never compare a literal's pixels across legs, solve the composite against each leg's plane.
- **C01/C02/C03 — geometry is leg-invariant, and the AA triples say so.** Green disc on y17: AA at x1015 reads **(34,102,44)** ⇒ coverage 0.48/0.47/0.48 from the R/G/B channels separately (they agree to 0.01), AA at x1029 the same ⇒ edges **1015.51 / 1029.49 ⇒ 13.98 ≈ 14.0**. Vertically at x1078: AA at y10 and y24 (t 0.507) ⇒ **10.49..24.51 = 14.02**. Gaps **13.99** (green→yellow) and **14.01** (yellow→red); centres **1022.50 / 1050.50 / 1078.49**, pitch 28. Red's right edge **1085.49 = 1100 − 14.51**; its top edge **10.49**. All within 0.03 px of R122's light numbers.

### The sidebar list (S02/S03/S05)
- **S03 — pitch and box are exact.** Five filled boxes at x17: y168..179 / y198..209 (the two checked calendars) and y296..307 / y326..337 / y356..367 / y386..397 (the four task lists) ⇒ centres **173.5/203.5/233.5** and **301.5/331.5/361.5/391.5**, **pitch 30** — byte-for-byte R121's light centres. Box extent at a mid row: coverage 1.00 across **x12..23** and 0.00 at x11/x24 ⇒ **12 wide**; the vertical runs are 12 ⇒ **12×12**.
- **Radius 3, fitted as an area not a ramp.** The Inbox box's top row (y296) reads 0.05 / 0.55 / 0.79 / 1.00 at x12..x15. QML rounds with a distance field, so the per-pixel ramp is not the area integral (r=3 would predict 0.24/0.24/0.90). The robust statistic is the row's **missing area = 1.61 px²**; a quarter disc gives 0.77 at r=2, **1.45 at r=3**, 2.19 at r=4 ⇒ **r ≈ 3.2 ⇒ the token 3**.
- **Label inset 32 ⇒ gap 8.** Label ink left edge is **32** on every row (x26..210 scan), the box's right edge is 23 ⇒ gap **8**. Label ink is **12 tall** for Latin (`Personal` 326..337) and **13** for CJK (日程 168..180) ⇒ the 13 pt font. Note 日程's row 36 vs 32 is the Chinese glyph's own left bearing, not a second inset.
- **S02 — headings and both gaps.** Heading ink left **12** (`Calendars`) / **11** (`Task lists`, the `T`'s bearing) ⇒ `leftMargin 12`. Heading ink **9 tall** on both ⇒ the 11 pt font. The block model (`topMargin 16` + a 16-tall label) predicts "Calendars" ink at 140.5..150.5 and `Task lists` at 267.5..277.5; the capture gives **140..149** and **268..277**. Group gap **16** = last calendar row's bottom 248.5 → the `Task lists` label's top 264.5. Heading→first row **6** = label bottom 280.5 → row top 286.5. Both inside the spec's 6–8 and 16–20.
- **S05 — both readable halves.** Every label's ink lies in ONE band (nothing wraps, nothing overflows its row), and the sidebar strip between the list's last row and the mini month is **empty plane — a full scan of y400..518 at x4..216 finds no ink at all**, the first ink below being the mini month at **y519**. So no green status card and no redundant switches.
- **S05's elide half cannot be exercised here.** The longest label is `UI Review Gold`, whose ink stops at **x122** against the elide tail at 208 ⇒ no elision is observable; exposing it needs the `profile/pim/metadata.json` rename + relaunch. R121 read it light. **Carried rather than claimed.**
- Incidental: the checkbox fills on dark are the *light* palette — 日程 **(0,136,255)**, 计划任务 **(52,199,89)**, Inbox (79,140,255), Personal (57,196,135), Gold (215,166,44), Red (227,92,86). 显示已完成 has **no fill run at x17** because it is unchecked — an outline only.

### 外推 (R126)
- **A HARDCODED LITERAL'S LEG-INVARIANCE IS PROVED AGAINST THAT LEG'S OWN PLANE.** C04's dots are literals at `opacity 0.85`; on dark the prediction is 0.85·token + 0.15·**(30,30,30)**, and all three land within 0.5/255. ⇒ **Never compare a literal's pixels across legs — solve the composite against each leg's plane.** (R125's rule was about a *wash*; this is its literal-side twin.)
- **A RADIUS TOKEN IS PROVED BY PREDICTING WHERE THE ARC PUTS THE EDGE, THEN LOOKING.** radius 30 ⇒ centre (1070,30) ⇒ y17's edge at **x1097.04**; the capture goes black at **1097**. ⇒ **A token restated from source is not a measurement; state the predicted pixel first.**
- **A ROUNDED CORNER'S RENDER IS A DISTANCE FIELD, NOT AN AREA INTEGRAL.** r=3 predicts top-row coverages 0.24/0.24/0.90; the capture gives 0.05/0.55/0.79. What fits is the **missing area** (1.61 px² ⇒ r≈3.2). ⇒ **Fit the integral, not the per-pixel ramp.**
- **A LIVE INSTANCE KEEPS THE VIEW YOU LAST SET IT TO.** R125 left the app on MONTH; R126's batch had to re-set `view week` explicitly. ⇒ **Re-set `view` in every batch; do not assume the `--view week` launch default survives.**


# R127 — **L03's DARK LEG — the segmented Day/Week/Month control: PASS 5/5, and all three light-only colour tokens solved on dark.** Read-only round: no source, no build — the R126 dark instance (204727) was still ALIVE, so the dark capture was free and the light leg came from the R124 PNG. Figure `docs/ui-calendar/r127-seg-dark-light-3x.png`.

## 本轮 (R127)
Atomic step: Next #1 of R126. L03 is 5/5 on light (R105), but three of its clauses are colour tokens that had only ever been read light — `tahoe.segmentTrack` / `tahoe.segmentPill` (R097, `Main.qml:114-118` → `LiquidSegmentedControl.qml:119-127`) and the segment's `mutedTextColor` (R099, `Main.qml:1787`). No relaunch: the dark instance was up, so `r126-dark-s02-c01.png` was read directly.

### The five clauses, reproduced on dark — every number is R105's light number
- **Width 196 ∈ [180,210]:** the track's own border pixels run **x562..757** = **196** (left rim x562, right rim x757, plane at x558/x758). R097's light reading was the same 562..757.
- **Height 28:** a vertical scan at x580 (track only, no lens) gives top rim **y36**, bottom rim **y63**, plane at y35/y64 ⇒ **y36..63 = 28**.
- **Centred −0.5 px vs the main region:** expanded, the sidebar is x0..219 with its rim at x220, so the main region is x221..1099, centre **660**; the track's centre is **659.5** ⇒ **−0.5**. R105's light clause reproduced exactly.
- **Order Day·Week·Month:** ink boxes left→right **x592..599 / x655..664 / x719..727**, centres **595.5 / 659.5 / 723.0** — identical to R105's light centres. (The labels render CJK on this fixture — 日/周/月 — one glyph each, ink 11 tall.)
- **Pill on Week:** the lens's border pixels are x630 and x689 ⇒ box ≈629.5..689.5, **centre 659.5 = Week's own ink centre**. Width **60**. The pill marks segment 2 (Week), never the ink.

### The three light-only colour tokens, solved on dark (plane (30,30,30))
- **`segmentTrack` = `Qt.rgba(1,1,1,0.06)` over the dark plane, PLUS the track's own gradient** (`LSC:92-100`, white@0.04 → black@0.02). Base = 30 + 225·0.06 = **43.5**. The gradient then predicts **51.5 / 46.4 / 43.1** at y37 / y49 / y61; the capture gives **50 / 47 / 42** — Δ ≤ 1.5 on all three, and the **monotone 8-level ramp 50→42 down the track is the gradient's signature**: a flat token could not produce it.
- **`segmentPill` = `#3C3C3C` (60), PLUS the lens's own 3-stop gradient** (`LSC:133-138`, white@0.09 → white@0.025@0.58 → black@0.025). Six-row fit down the lens: predicted **76.6 (y39) / 72.1 (y44) / 62.9 (y55) / 59.8 (y60)**, measured **76 / 71 / 62 / 59** — Δ ≤ 1.1 everywhere. The lens is **opaque** as its own comment demands (a translucent pill would composite down onto the track).
- **`mutedTextColor` = `labelPrimary` on dark too — the R099/C05 clause holds.** Ink peaks per label: Day **(236,230,237)**, Week **(242,242,241)**, Month **(233,225,226)** — i.e. all three at `#F2F2F2` = 242. A muted state would have been `labelSecondary` (`F2F2F2`@0.58) over the track ⇒ **≈160**, and it is nowhere in the frame. Dark mirrors light, where all three cores read 8 / 0 / 12 against the plane.
- **Bonus, the shared control's lens shadow is dark-aware.** `LSC:113` `Qt.rgba(0,0,0, AppTheme.dark ? 0.24 : 0.10)` at `lens.y+1`. The one row the shadow pokes below the pill is **y62 = (32,32,32)**; predicted 0.76·42.5 = **32.3**. Light would be 225.
- **The 1 px rims are `AppTheme.border` on the track** (`LSC:85-86`) and **white@0.16 on the lens** (`LSC:126`): track rims 62 over plane 30 / 222 over plane 255; lens rims 77 over the pill. Not an L03 clause; recorded so the next reader does not re-derive it.

### 外推 (R127)
- **A GRADIENT-BEARING TOKEN IS PROVED BY ITS RAMP, NOT ITS MIDPOINT (load-bearing).** `segmentTrack`'s dark base alone is 43.5; the capture reads 47 at mid-height — so the midpoint *alone* would have "failed" by 3.5. What proves the token is that the whole column walks **50 → 42** in the direction and magnitude the gradient predicts. ⇒ **When a token carries a gradient, measure ≥3 rows and fit the slope; a single row is a coin flip.**
- **AN OPAQUENESS COMMENT IS A TESTABLE CLAIM (load-bearing).** `Main.qml:109` says the pill is opaque on purpose "so a translucent pill [does not composite] down". On dark the pill's six-row fit holds against **60**, not against anything blended with the track ⇒ **opaque, confirmed a second way.**
- **A LEG-INVARIANT GEOMETRY IS CHEAPEST TO RE-PROVE ON THE LEG WITH THE WORSE CONTRAST.** Every L03 length on dark came out byte-equal to light (196 / 28 / 60 / centres 595.5·659.5·723.0) — a control whose form is tokenised cannot move between legs, so the dark read is the *confirmation*, not a new measurement.
# R128 — **A01 / A02 / A04 DARK LEG PASS — all four band rules and the whole row map byte-equal to light; dark order 39 < 59 < 84 exact.** Read-only round: no source, no build — the R126/R127 dark instance (204727) was still ALIVE (`KOS_APPEARANCE=dark`), so the capture was free. Figure `docs/ui-calendar/r128-band-dark-light-2x.png`.

## 本轮 (R128)
Atomic step: Next #1 of R127 — the A-series dark leg. A01/A02/A04 had all been measured on the LIGHT leg only (R106/R107), so the band was the last unread dark surface. `kill -0 $(cat live-app.pid)` ALIVE ⇒ one batch (`resize 1100x692` / `view week` / `sidebar expanded` / `date 2026-04-02` / `captureClient r128-dark-band.png`), one capture, no relaunch.

### Orientation — the week starts on MONDAY
The header reads 周一 30 / 周二 31 / 周三 1 / **周四 2** / 周五 3 / 周六 4 / 周日 5, so the seven columns are Mon..Sun at **272 · 391 · 510 · 629 · 748 · 867 · 986** — **Thu Apr 2 = x629..747**, matching the pinned map. Consequences used below: the `Multi-day review` strip (Mar 30 → Apr 3) runs Mon→Fri, `Design sync` / `Release notes` / `+2` occupy Thu, and **Sun Apr 5 is the empty all-day column** — the column that makes A02 measurable.

### A01 — the four rules, dark (plane 30,30,30); predicted = 30 + a·225
- `sectionRule` **y155 = (39,39,39)** — white@0.04 ⇒ **39.0** (light mirror 242).
- `allDaySeparator` **y232-233 = (84,84,84)**, **2 px** — white@0.24 ⇒ **84.0** (light 217).
- the grid's top rule **y234 = (59,59,59)** — gridLine white@0.13 ⇒ **59.25** (light 237); over the weekend columns it reads **65** (37 + 0.13·218 = 65.3), the same token on the tinted plane.
- **The spec's demanded dark order 39 < 59 < 84 holds with every rule within 0.5/255.** The light order (242 / 237 / 217) is the same *roles* read in the opposite direction.
- Rules span **x221..1099** (the sidebar plane is (40,40,40) with its rim at x220 = (61,61,61), the dark blend of the separator).

### A01 — the row map is leg-invariant, byte-for-byte
3-row leg interior **156..231 = 76** (= 1 + 25·3); chips **157-180 / 182-205 / 207-230** ⇒ **row 24, gap 1, pitch 25**, exactly source `CalendarScheduleView.qml:62-63` (`allDayRowHeight 24` / `allDayRowGap 1`). A mid-height envelope scan at **y178 and y179 returns the identical segment list on both legs** — light `(274,625) (631,744) (750,863)` ≡ dark `(274,625) (631,744) (750,863)` (the merged Mon–Wed bar, Thu's `Design sync`, Fri's `R087 sole`). ⇒ **the band's form did not move between legs; the dark read is the confirmation, not a new measurement** (R127's rule, second application).

### A02 — "expands uniformly": a PER-WEEK max, not a per-column fact
Sun Apr 5 has **zero** all-day items, yet its interior still runs **156..231 as (37,37,37)** (the weekend tint) and the separator at 232-233 is **continuous across x221..1099**. ⇒ **shared bottom edge = one horizontal edge at y231 for all seven columns, with an unbroken separator beneath it** — and it is only visible *because* one column contributes no rows. "Subtle stronger separator" = **84** against sectionRule's 39 and gridLine's 59: the strongest of the three, exactly as light's 217 is the weakest.

### A04 — the overflow row is explicit and full-height
Row 3 (**207-230**, a real 24-row slot at the correct pitch) carries **no chip fill** and only the text `+2` — ink cluster at **x635..645** on y218, plane (30,30,30) everywhere else in the row. No half-clipped row anywhere in the leg. The light leg reads the same row as plane 255 throughout at x700.

### Bonus — the band chip's fill is a DECLARED per-leg pre-blend (new token read)
`CalendarScheduleView.qml:589` `AppTheme.mix(allDayBackdrop(columnDate), itemColor, AppTheme.dark ? 0.32 : 0.17)`. Dark measured **(36,65,84)** = 0.32·(48,140,198) + 0.68·(30,30,30) to **≤0.3/255** on all three channels; light measured **(220,235,245)** = 0.17·(48,140,198) + 0.83·255 to **≤0.4/255**. The fill is uniform across the chip (x740 and x760 at y176 agree), i.e. no gradient — unlike the timed chip. **0.32 ≠ 1 − 0.17**, so R125's rule ("read a dark leg against the token, never by inverting the light alpha") now has a second, independent witness.

### 外推 (R128)
- **A BAND THAT GROWS BY MAX-ROW-COUNT IS PROVED BY ITS EMPTY COLUMN (load-bearing).** Sun Apr 5 contributes zero all-day items, yet the leg interior still runs 156..231 and the separator beneath is unbroken ⇒ "expands uniformly / shared bottom edge" is a **per-week max** read off the one column that adds no rows. ⇒ **Find the column with the fewest items; it is the only place the band's own edge is visible.**
- **A DECLARED PER-LEG ALPHA IS THE SECOND WITNESS TO R125 (load-bearing).** `:589`'s 0.32 dark / 0.17 light fits both legs to ≤0.4/255 and 0.32 ≠ 1−0.17 ⇒ **two independent tokens now say: never derive the dark leg from the light alpha.**

# R129 — **L05's CHANNEL IS OPEN: `pointerObject` addresses a toolbar control by objectName, and press+release on `toolbarSearchToggle` drives `toolbarSearch` 0 → 280 → 0.** Discovery only — no source, no build, no capture: the R124-build dark instance (204727) was still ALIVE (`KOS_APPEARANCE=dark`), so all three probes were free.

## 本轮 (R129)
Atomic step: Next #1 of R128 — L05 target discovery, so the pointer half has a channel at all. `kill -0 $(cat live-app.pid)` ALIVE and `/proc/204727/environ` says `KOS_APPEARANCE=dark` ⇒ every probe free, on the dark leg. L05 is a toolbar-geometry clause and leg-independent, so dark is a valid leg and is recorded as such. The plan's "Do NOT capture the expanded frame this round" was honoured: zero `captureClient`, zero PNG.

- **THE CHANNEL IS objectName, NOT id.** `pointerObject` → `harness/Main.qml:131-134` → `pointerDriver.namedPoint(reviewWindow, command.target)` = `ReviewInput.cpp:25-35` `root->findChild<QQuickItem *>(name)`, a **recursive objectName** lookup, then `mapToScene(width/2, height/2)`. ⇒ **the payload's `target` must equal a QML `objectName`; passing the `id` (`searchToggleButton`) returns `found:false` and the round would read as "no channel" when the channel is in fact fine.**
- **THE WHOLE TOOLBAR IS NOW ADDRESSABLE** (objectName @ `Main.qml`): `toolbarSidebarToggle` (1721) · `toolbarAdd` (1739) · **`toolbarViewSegment`** (1752-1754, the LiquidSegmentedControl) · `toolbarSearchToggle` (1790-1791) · `toolbarSearch` (1810-1811) · `toolbarSearchInput` (1896-1897) · `toolbarMore` (1937-1938).
- **Collapsed baseline** (1100x692, sidebar expanded, week): toggle **28×28 at x1022, y36** ⇒ centre **(1036,50)** — the pinned right pair 1022..1049 in the band y30..69; `toolbarSearch` **width 0, x1016, visible false** (1016 = toggle.left 1022 − `rightMargin 6`); `toolbarSearchInput` **width −24** = a fill of a 0-wide parent minus two 12s, `visible false`.
- **THE PAYLOAD THAT LANDS:** `{"action":"pointerObject","target":"toolbarSearchToggle","kind":"press"}` then `{... "kind":"release"}` ⇒ `namedPoint` reports **`{"found":true,"x":1036,"y":50}`**, and geometry moves to `toolbarSearch` **width 280, x736, visible true**, input **256 at x748**. ⇒ **280 is `maxWidth`'s CAP** (`Math.min(280, max(0, mainWidth − 2·28 − 3·8 − 24))`, `:1814-1817`) — at 1100 expanded the toolbar has ≥280 px of headroom, so the cap binds rather than the width.
- **L05's "strictly inside the toolbar" clause is already geometrically true on this leg:** the expanded field is **y36..63 = 28 h inside the 40 px toolbar band y30..69** — 6 px clear above, 6 below, no second row, no overlap with the heading band at y70. Input content **748..1004 = 256** ⇒ inset **12** per side (`:1898-1899`). Right edge 1016 = toggle.left 1022 − 6.
- **The toggle is idempotent both ways:** a second press+release returns `toolbarSearch` **280 → 0, x 736 → 1016, visible true → false**, input back to −24. Clean collapsed end state — the app is left exactly as found.
- **Carried to next round, NOT settled here:** the segment (`toolbarViewSegment`) hides via `opacity: toolbarSearch.active || toolbarSearch.width > 0 ? 0 : 1` with `visible: opacity > 0` (`:1757-1765`), so the handoff is **sequential, not a cross-fade**. "No frame ever shows both text areas" is therefore a **temporal** claim: `inspectGeometry` does not report `opacity`, and width→0 then visible-false is an animation. ⇒ **`inspectGeometry` is the right instrument for the ADDRESS; only a 50 ms `nativeRecord` across the 150 ms `AppTheme.motionFast` width animation can settle the ORDER.**
# R130 — **L05 CLOSED: the segment/field handoff is strictly SEQUENTIAL in both directions** — over 60 frames the segment is OFF on the first frame the field is non-zero, and back only after the field reads 0; neither text area is ever on screen with the other. Read-only, no source, no build: the R124-build dark instance (204727) was still ALIVE (`KOS_APPEARANCE=dark`), so the whole record was free. Figures `r130-l05-handoff-zoom3x.png` (both transitions, 3x, edge guides) and `r130-l05-handoff-strip.png`.

## 本轮 (R130)
Atomic step: Next #1 of R129 — L05's FRAMES. One `nativeRecord` interval 30 / duration 3000 spanning **two** `pointerObject` press+release pairs on `toolbarSearchToggle`, paced at 0.6 s per command (the poller reads one command per 100 ms tick). 60 frames, all `saved:true`, real spacing **31-88 ms** (mean ~50) — the requested 30 is a floor, not a rate.

- **THE ANIMATION IS DECLARED, NOT INFERRED.** `Main.qml:1882-1883` `Behavior on width { NumberAnimation { duration: AppTheme.motionFast; easing.type: Easing.OutCubic } }` => predict `w(t) = 280*(1-(1-t/150)^3)`. The field's **right edge is pinned at x1016 in every frame** and its **top/bottom lie on y36 / y63 in every frame** => **left-edge-only, width-only: no scale, no fade, no height change.**
- **OPEN (release S ~= 1229 ms):** f27 1199 **seg ON, w 0** | **f28 1231 seg OFF, w 0** | f29 1269 **w 171** | f30 1348 **w 252** | f31 1415 **w 280**. OutCubic from S predicts 170 / 245 / 277 => measured **171 / 252 / 280**.
- **CLOSE (release S ~= 2476 ms):** f49 2459 **w 280** | f50 2497 **w 180** (predict 178) | f51 2548 **w 55** (predict 39; +16 is the rounded cap) | f52 2614 **w 8** (the collapsed capsule's own rim) | f53 2678 **w 0, seg OFF** | f54 2743 **w 0, SEG ON**. Four samples across 155 ms => 150 ms OutCubic, not a snap.
- **(a) NO FRAME CARRIES BOTH — 60/60, two-sided, no exception.** Segment ink ~= **650** in every frame whose width <= 0 (f00-f27, f54-f59) and **<= 63** in every frame whose width > 0 (f29-f52). The 42-63 residue is measurement overlap: segment box x563..757 intersects the field x736..1016 at the field's left cap. **The bands are strictly complementary.**
- **(b) THE FIELD IS INSIDE THE TOOLBAR BAND AT EVERY WIDTH.** Top/bottom on y36 / y63 at w 171, 252, 280, 180, 55 and on the 8 px sliver — the same two lines the segment's pills and the 28 px toggle span. 28 h in y30..69: 6 clear above, 6 below, no second row, no overflow.
- **(c) THE SEGMENT RETURNS ONLY AFTER width == 0.** f52 w 8 seg OFF -> **f53 w 0 seg OFF** -> f54 w 0 SEG ON. The return lags the collapse by >= 1 frame (65 ms) and never anticipates it.
- **THE SEQUENTIAL HANDOFF'S SIGNATURE IS A BLANK FRAME, NOT AN OVERLAP.** `opacity: toolbarSearch.active || toolbarSearch.width > 0 ? 0 : 1` flips at the **first** animation frame (width ~= 0), so the band carries **NEITHER** control for one sampled frame per edge: **f28 1231 ms (open)** and **f53 2678 ms (close)** show only the magnifier ring. That is the *proof* of strict sequencing — a cross-fade would show both, a gapless handoff would show one. The blank lasts <= 38 ms (OutCubic puts w=40 px at t ~= 7.5 ms): real, but sub-frame.
- **Leg:** dark, and the clause is leg-invariant — it governs a `width` binding and an `opacity` binding, neither reads a colour token, and the segment/field geometry is already byte-equal across legs (R097/R127; R128's rule). The light leg was **not** re-run.
- **Instrument caveats.** (i) A left-edge scan on a capsule with radius = h/2 is biased **right by ~4-8 px**, so "width" reads high exactly as the field collapses (f51: 55 vs 39). (ii) `nativeRecord`'s `interval` is a floor; true times are only in the logged `[UIReview] native recording` JSON (`frames[i].elapsedMs`) — that is what placed these frames on a timeline. (iii) The easing evidence is a 3-4 sample fit: enough for "150 ms OutCubic, not a snap", not for 10 ms.


## R131 — C05's pointer half (dark leg, R124 build, read-only)

Atomic step: Next #1 of R130. Target `toolbarAdd`, box x48..76 x y36..64 = 28x28, centre (62,50) (inspectGeometry; the box is window-wide, so the expanded sidebar does not move it). One `nativeRecord` interval 30 / duration 2600 => 52 frames, 31-2579 ms; the 0.6 s command pacing lands `move` ~ f0017 (640 ms), `press` ~ f0027 (1220), `release` ~ f0040 (1856).

- **HOVER'S WITNESS IS BINARY.** `ToolTip.visible: hovered && hint.length > 0` (`Main.qml:934`) => the "Add event" panel appears at +640 ms, on the `move` frame, no delay. That is a frame-level read of `control.hovered === true`, not a colour inference.
- **FAIL — `hoverRimBoost` IS DEAD CODE.** The rim pixel (x49,y50) at rest = 113 = 59 + 0.28*(255-59) => effective alpha **0.2755** = `glassRim` dark 0.28 exactly. On hover the same pixel = 127 = 78 + a*(255-78) => **a = 0.2768**. Delta 0.001 against a declared 1.6x. `opacity: 1 + (hoverRimBoost-1) * hoverAmount` (`:829-833`) computes 1.6, but `opacity` is a QQuickItem 0..1 property => the clamp eats the whole boost. The G07 comment "the specular rim strengthens on hover" and the token `hoverRimBoost: 1.6` (`:233`) are inert on **both** legs (light 0.90 x 1.6 = 1.44 also clamps). The comparison is clean because the vertical profile (`:797-820`) is hover-invariant (`:801`), so it cancels.
- **Hover's only real effect is `hoverLift` 0.10.** Fill at y50 **59 -> 78** (+19; 0.10 over the fill predicts +19.6 => alpha read back **0.0996**); fill patch y39..41 70.3 -> 87.9 (alpha 0.095). `hoverLift: 0.10` (`:231`) has no dark branch => leg-invariant.
- **PRESS IS MEASURED.** `pressScale: 0.97` (`:235`) predicts 0.42 px inward per side. Left rim ink centroid (excess over the local fill, x47..52 at y50): **49.09 hover -> 49.47 pressed = +0.38 px**. Apex row (brightest of x61..63): **37 -> 38**. Shadow: the plane 8 px left of the button **39 -> 40** (offset x0.6 / blur x0.75 / opacity x0.55, `:709-723`).
- **RELEASE RETURNS EXACTLY TO THE HOVER BASELINE.** Right edge at y50: rest 74.66 / hover 74.87 / pressed 74.73 / released **74.88** => residual **0.01 px**. The un-sink ramps f41 (1908) -> f43 (2042), ~190 ms ~ `pressDuration` 150 + sampling.
- **Contamination.** `toolbarAdd`'s click opens the new-event dialog: at f0040 (1856 ms, +40 ms after the release) the dim scrim lands (plane 40 -> 23, `KosWorkspaceDialog.qml:24-27`) and the tooltip vanishes, so the released steady state is read *through* the scrim. Legitimate: a uniform scale of both sides of an edge cannot move that edge's mid-level crossing.
- **Instrument caveat (mine, not the scene).** On the pressed frames the L-edge mid-level `(min(plane)+max(glyph))/2 = 113.5` sits above the rim peak (110), so the detector fell through to the glyph and read a constant 55.34. The sink is therefore read off the rim's **ink centroid** and the apex row, never off a threshold whose level is set by the glyph.
- **New observation, own round:** the toolbar `ToolTip` is a **WHITE panel with dark ink on the DARK leg** ("Add event" floating over a dark window). Patch mean below the button 185 (text ink included). Flagged as 仍差 #8b; no action, no value invented.
- **Superseded rule:** the old "hovered/pressed chrome cannot be driven" is wrong — `pointerObject` kind `move|press|release` drives all three states. A static screenshot still cannot settle an animation.
- **Leg:** dark only. The clamp (a QML property range) and `pressScale` (a single literal) are leg-invariant expression-level facts; only `glassRim`'s base alpha differs per leg and both clamp.
- Figures: `docs/ui-calendar/r131-c05-hover-press-4x.png` (8 frames, 4x, elapsedMs labels), `docs/ui-calendar/r131-c05-tooltip-witness-3x.png` (rest vs hover @3x, the tooltip witness).

## 本轮 (R132)
Atomic step: Next #1 of R131 — **fix + verify C05's hover half**. One source edit, one build, one launch, one record, one read.

- **THE EDIT.** `apps/calendar/qml/Main.qml:828-839`, the rim `Rectangle` inside `GlassSurface`: `border.color` is now `Qt.rgba(glassRim.r, glassRim.g, glassRim.b, Math.min(1, glassRim.a * (1 + (hoverRimBoost-1) * hoverAmount)))` and the item is `opacity: 1`. The two comment lines now record why. `hoverLift`, `hoverRimBoost`, `pressScale`, `pressDuration` and the three shadow factors are **untouched** — all measured-correct in R131.
- **BUILD + LAUNCH.** `ninja -C .build/calendar-review kos-calendar kos-pim-service` ⇒ 7 steps, clean. A rebuilt binary needs kill+relaunch: 204727 killed, dark relaunched = **213298** (`KOS_APPEARANCE=dark` in `/proc/…/environ`, 1100×692, plane 30).
- **THE RECORD.** R131's exact batch: `resize 1100×692` · `sidebar false` · `view week` · `date 2026-10-15` · `nativeRecord(interval 30, duration 2600)` · `pointerObject toolbarAdd move` · `press` · `release` ⇒ **46 frames, 30–2632 ms**; rest f0000-f0014, hover ramp f0015-f0019, hover settled f0020-f0026, press f0027-f0033, released f0034-f0045.
- **PASS — THE BOOST RENDERS.** Left rim pixel **(x49, y50)** over the face it sits on (x51, x52): **rest 132 over 89 ⇒ α 0.2590**; **hover 169 over 106 ⇒ α 0.4228**. **Ratio 1.632** against the declared **1.6** (the old clamped code measured 1.005). Right rim (x74): rest 136/98 ⇒ 0.242, hover 171/115 ⇒ 0.400, **ratio 1.65**. Top apex (x62, y37): **139 → 174**. The ratio is insensitive to the background estimator — using x50 alone vs the mean of x51/x52 spans **1.63–1.66**.
- **THE THREE UNTOUCHED CLAUSES STILL HOLD, SAME FRAMES.** `hoverLift`: face at (x51,y50) **89 → 106**; `0.10·(255−89) = 105.6` ⇒ read-back alpha **0.0955** (R131 read 0.0996 on its own plane). Press: the left rim **peak moves x49 → x50** (= the +0.4 px inward sink `pressScale` 0.97 predicts) and the **apex row 37 → 38** — both R131's signatures, reproduced. Release: the right rim peak **returns x73 → x74** (the press position back to the hover column).
- **NEW LESSON (load-bearing): THE BUTTON'S FACE IS LENS-SAMPLED, SO ITS ABSOLUTE VALUE IS FIXTURE-DEPENDENT.** R131 read the fill at y50 as **59**; R132 reads the face at (x51,x52) as **89** in the same window size and the same dark leg — the `GlassSurface` lens samples the viewport content, and the fixture date differs (`2026-10-15` here). ⇒ **An acceptance criterion written as an absolute pixel borrowed from another round's scene is not portable; write it as an ALPHA, which is what the token actually declares.** R131's "accept only if the pixel rises 127 → 157" would have been unsatisfiable here for a reason that has nothing to do with the fix.
- **OPEN, flagged not claimed: the released rim.** Through the scrim (measured s ≈ **0.571** from three independent anchors: plane 29 → 17, left-out 28 → 16, face 106 → 59) the released rim at x49 reads 82 ⇒ true **≈144**, i.e. *between* the rest 132 and the hover 169, and it is still drifting up across f0034-f0040 (true 136.6 → 143.6). The face at x51/x52 sits on the lens gradient and does not disambiguate, and the tooltip has gone by f0034 (the click opened the new-event dialog, which takes focus). Hypothesis, **unresolved**: `hovered` goes false when the dialog grabs and the rim decays to rest over the 150 ms `Behavior` while the lens-sampled face does not follow. **Its own read.**
- **THE DARK-LEG WHITE TOOLTIP IS RE-CONFIRMED** (visible as a white panel below the button in the figure's hover/press/released tiles) — still 仍差 #8b, own round, no action.
- **Leg:** dark only. The edit is leg-invariant in expression (it scales `glassRim.a` whatever that alpha is); on light 0.90 × 1.6 = 1.44 now **saturates at 1.0** instead of being ignored — a visible change that has NOT been re-read, so the light leg's rim is **unverified this round** and C05 stays open on that leg.

# R133 — **C05's LIGHT leg rim after the R132 fix: PASS — the rim rises to the fully-opaque ceiling.** Read-only: no source, no build. The dark instance 213298 was killed and the light leg relaunched (**214895**, `KOS_APPEARANCE=light`); one batch produced an **80-frame record, 31–3363 ms**; state boundaries were read off the pixel series rather than inferred from the clock.

## 本轮 (R133)
Atomic step: Next #1 of R132 — verify the light leg's rim after the R132 edit. One kill+launch, one batch, one record, one read.

- **THE LAUNCH.** `start-review-vm.sh light` after killing the dark instance ⇒ **214895**, `KOS_APPEARANCE=light`, 1100×692. The binary is the R132 build, so no rebuild was due.
- **THE RECORD.** `resize 1100×692` · `sidebar false` · `view week` · `date 2026-10-15` · **`pointer(600,400,move)` to PARK** · `nativeRecord(interval 30, duration 3400)` · `pointerObject toolbarAdd move` · `move` · `press` · `release` ⇒ **80 frames, 31–3363 ms**. Boundaries from the series **x49,y50**: rest **f0000-f0015** (31–547 ms) at 251, hover **f0016-f0048** (595–1863) at 254, press **f0049-f0059** (1923–2316) at 248→244, released **f0060-f0079** (2349–3363) at 195→202.
- **PASS — THE LIGHT RIM RISES TO THE CEILING.** Left rim **(x49,y50) rest 251 → hover 254**, flat across all 16 rest frames and all 33 hover frames; face (x50,x51) **228/226 → 230/228**. Effective alpha **rest = (251−227)/(255−227) = 0.857**, **hover = (254−229)/(255−229) = 0.962** ⇒ **×1.12**, against the declared saturation **0.90 × 1.6 = 1.44 ⇒ clamp 1.0 ⇒ 1.0/0.90 = 1.111**. The declared **1.6** is unreachable from a 0.90 base. **Pre-fix this ratio was 1.000** (the boost rode a clamped `opacity`), so the rise itself is the discriminator.
- **SECOND WITNESS, COVERAGE-AGNOSTIC.** Apex (x62): rim row **y37 253 → 254** over its backdrop **y38 238 → 240**. Rim-box census (x46..78 × y34..66, pixels **≥254**): **rest 138 · hover 162 · press 337** — more of the 1 px ring reaches the near-white ceiling when hovered.
- **THE UNTOUCHED CLAUSES REPRODUCE ON LIGHT, SAME FRAMES.** `hoverLift`: face **227 → 229** = +2 (`0.10·(255−227) = 2.8`). Press: the x49 rim **splits to x49/x50 = 244/242** — the inward sink `pressScale` 0.97 predicts — and the ≥254 census jumps to 337. Release: the dim scrim lands **40 ms after the release** (f0059 clean → f0060 dimmed), the same +40 ms timing R132 saw on dark; the scrim's strength differs by leg — **face 231 → 185 = ×0.80 light vs ×0.571 dark**.
- **WHAT CANNOT BE CLAIMED HERE: THE RAMP.** The rim's whole hover travel on light is **2.74 levels**, so the 150 ms `Behavior` collapses into 1–2 integer steps and cannot be timed on this leg. Presence and magnitude are measured; the ramp is not — it stays proven on dark (43 levels of headroom, R131/R132).
- **THE +3 IS THE RIM'S OWN ALPHA, NOT LIFT BLEED.** `hoverLift` raises the substrate under the rim by +2, which can move the rim column by only **(1−α)·2 ≈ 0.3 level** ⇒ **≥2.7 of the 3 levels are the rim alpha itself.**
- **NEW LESSON (load-bearing): A SATURATING BOOST IS PROVED BY ITS RATIO, NOT BY REACHING THE CEILING.** The ceiling pixel reads **254, not 255** — no column of a 1 px AA border is fully covered (dark's coverage factor from R132 was 0.2590/0.28 = 0.925). ⇒ **When a declared multiplier saturates, write the criterion as the RATIO the declared saturation predicts; the ceiling itself is unreachable by construction.**
- **NEW LESSON (load-bearing): AN EXCURSION OF ~3/255 IS A QUANTIZATION-LIMITED MEASUREMENT.** On a low-contrast leg the whole travel fits in 3 integer levels, so any *timing* read there is an artifact. ⇒ **Prove a ramp where the excursion is large; use the low-contrast leg for presence + magnitude only — and attribute the rise correctly, subtracting the lift bleed.**
- **NEW LESSON: `position` IS A TIMELINE SCROLL, NOT A POINTER PARK.** The harness implements it as `timeline.contentY = command.contentY`. ⇒ **A "rest" frame set is only genuine if an explicit `pointer(x,y,move)` moved the pointer off the control first.** R133 added that step; R131/R132's rest sets were unverified in this respect.
- **Leg:** light only. No source was touched, so R131/R132's dark numbers stand unchanged.

## R133 (archived from state.md) — C05's LIGHT leg rim VERIFIED, verification only
Atomic step: read the light leg's rim after the R132 fix. No edit, no build; one kill+launch, one batch, one record, one read.
- **THE LAUNCH.** 213298 (dark) killed; `start-review-vm.sh light` ⇒ **214895**, `KOS_APPEARANCE=light`, 1100×692. Binary unchanged from R132 ⇒ no rebuild due.
- **THE RECORD.** Batch: `resize 1100×692` · `sidebar false` · `view week` · `date 2026-10-15` · `pointer(600,400,move)` PARK · `nativeRecord(interval 30, duration 3400)` · `pointerObject toolbarAdd move` · `move` · `press` · `release` ⇒ **80 frames, 31–3363 ms**. State boundaries read off the PIXEL series, not the clock: rest f0000-f0015, hover f0016-f0048, press f0049-f0059, released f0060-f0079.
- **PASS — THE LIGHT RIM RISES TO THE CEILING.** (x49,y50) rest **251 → hover 254**, flat across all 16 rest and all 33 hover frames. Face (x50,x51) **228/226 → 230/228**. Effective alpha **rest (251−227)/(255−227) = 0.857**, **hover (254−229)/(255−229) = 0.962** ⇒ **×1.12** against the declared saturation **1.111** — nowhere near the declared **1.6**, unreachable from a 0.90 base. Pre-fix the ratio would have been **1.000** (clamped no-op).
- **SECOND WITNESS, COVERAGE-AGNOSTIC.** Apex (x62) rim row **y37 rest 253 → hover 254** against backdrop **y38 238 → 240**. Census of the rim box (x46..78 × y34..66), pixels **≥254: 138 rest → 162 hover** (+17%).
- **THE UNTOUCHED CLAUSES REPRODUCE ON LIGHT.** `hoverLift`: face **227 → 229** = +2 (`0.10·(255−227) = 2.8`). Press: left rim **peak splits x49 → x49/x50 (244/242)**, box census jumps to **337** ≥254.
- **WHAT CANNOT BE CLAIMED: THE RAMP.** The rim's whole hover travel on light is **2.74 levels** ⇒ the 150 ms `Behavior` collapses to 1–2 integer steps and cannot be timed on this leg. Dark has 43 levels of headroom and did show it (R131/R132).
- **THE +3 IS THE RIM'S OWN ALPHA, NOT LIFT BLEED.** `hoverLift` raises the substrate by +2 ⇒ **(1−α)·2 ≈ 0.3 level** ⇒ ≥2.7 of the 3 levels are the rim alpha itself.
- **THE SCRIM LANDS 40 ms AFTER THE RELEASE ON LIGHT TOO** (f0059 2316 ms clean → f0060 2349 ms dimmed): face **231 → 185 = ×0.80**, against dark's **×0.571** — a different scrim per leg, same +40 ms timing. R132's open item, Next #3 there.
- **Leg:** light only; no source touched, dark's R131/R132 numbers stand.

## R134 — the dark-leg ToolTip is Qt's Basic style, UN-THEMED (measurement + verdict only)
Atomic step: Next #1 of R133 — measure the dark-leg ToolTip (fill/ink/radius) and decide Qt-default vs ours. One kill+launch, one batch, one record, one read. **No edit, no build.**
- **THE LAUNCH.** 214895 (light) killed; `start-review-vm.sh dark` ⇒ **216298**, `KOS_APPEARANCE=dark`, sidebar collapsed, `--view week --date 2026-10-15`. Binary unchanged since R132 ⇒ no rebuild due.
- **THE RECORD.** Batch as one list: `resize 1100×692` · `sidebar false` · `view week` · `date 2026-10-15` · `pointer(600,400,move)` PARK · `nativeRecord(prefix …/r134-tt, interval 30, duration 4200)` · `pointerObject toolbarAdd move` · **4× `{"action":"none"}`** · `captureClient(…/r134-tooltip-dark.png)` ⇒ **114 frames**. *New harness fact: there is no sleep action — pad a delay with `none` steps (~0.6 s each).*
- **HOVER REPRODUCES R132.** rim **x49 135 (rest) → 171 (hover)** at y50, face x51 **93 → 109**, apex (x62,y37) **141 → 174** ⇒ α 0.2590 → 0.4228 = **×1.632**. Onset of the ramp between f015 and f030; flat 171 to f113. The record is sound, so the tooltip read is trustworthy.
- **THE FIRST PROBE MISSED — THE PANEL IS BELOW, NOT ABOVE.** A probe box over the button (x8..130 × y8..34) read a flat 30.0 for all 70 sampled frames ⇒ **no tooltip above**. R131's figure `r131-c05-tooltip-witness-3x.png` then showed the white "Add event" panel *below* the two round buttons, which is what the record confirms. **Lesson: a negative result from one probe box is not an absence — the widget can be somewhere the style file says it cannot.**
- **VERDICT — QT'S DEFAULT IS LEAKING, AND IT IS A ROOT CAUSE, NOT A GUESS.** `grep` over `apps/calendar/qml`, `shared/qml` and `libs/` finds **no tooltip component and no `ToolTip.toolTip` override anywhere** — only the attached `visible`/`text` (plus `delay` at `KosWindowControls.qml:25` = 700, `KosSidebarToggle.qml:13` = 500, `LiquidNavBar.qml:278` = 600). `apps/common/src/ApplicationRunner.cpp:133` sets `QQuickStyle::setStyle("Basic")`. ⇒ the four Main.qml sites (`:869-870`, `:942-943`, `:1012-1013`, `:1954-1955`) render **`/usr/lib/…/qt6/qml/QtQuick/Controls/Basic/ToolTip.qml` verbatim**: `background: Rectangle { border.color: control.palette.dark; color: control.palette.toolTipBase }` (**no `radius`**), `contentItem: Text { text: control.text; color: control.palette.toolTipText }`, `padding: 6`, `margins: 6`, `closePolicy: CloseOnEscape|CloseOnPressOutsideParent|CloseOnReleaseOutsideParent`. Our palette is the default light one ⇒ on the dark leg the panel is white with black ink.
- **THE PANEL, MEASURED (dark leg, 1100×692).** **x29..95 (w 67) × y68..95 (h 28)**; interior **255,255,255**; plane left/right/above **(30,30,30)**; ink darkest **(6,20,88)** = black under subpixel AA (fringes only — not a colour token). **CORNERS SQUARE:** the left edge sits at **x29 for every row 68..74**, no inset ⇒ **radius 0**, exactly as Basic's radius-less `Rectangle` predicts. Height 28 = `padding 6` + ~16 px text + 6.
- **POSITION — CENTRED ON THE BUTTON, BUT BELOW IT.** Panel centre x = (29+95)/2 = **62 = `toolbarAdd`'s centre** ✓ (Basic's `x: (parent.width − implicitWidth)/2` with parent = the 28 px button: (28−67)/2 = −19.5 ⇒ 48−19.5 = 28.5). Top **68 = the button's bottom 64 + 4** ⇒ **below**. **The installed style declares `y: -implicitHeight − 3`, i.e. ABOVE.** The mechanism that moves it below is **unresolved and deliberately not claimed**. It is NOT a native popup: the panel is inside the 1100×692 `captureClient` grab.
- **THE DELAY IS ZERO AT THESE SITES — WITH A CAVEAT.** The panel region (x0..260 × y60..120) mean is flat **61.5 for f000-f018**, then **87.8 at f019 → 87.9** for every frame to **f113**: onset within one 30 ms frame of the hover, and **no timeout in 3.4 s**. That is ≈0 delay, against the 500/600/700 ms the three sibling components declare. **Caveat: `hovered` here is set programmatically by `pointerObject`, so "the app has no delay token" is NOT proved — only "the harness path shows it immediately". R131 measured the same independently.**
- **WHAT THIS ROUND DOES NOT DO: NO FIX.** Nothing was edited, so the binary and both legs stand unchanged. The remedy is Next #1.
- **Figure:** `docs/ui-calendar/r134-dark-tooltip-4x.png` (4× NEAREST crop x0..130 / y0..120, the panel boxed in red).

## R135 — the dark-leg ToolTip is THEMED (palette override; the shared-component attempt is REVERTED). Dark panel = **(60,60,60) = #3C3C3C** on the (30,30,30) plane (R134's white 255 is GONE), ink light ≈ #F2F2F2; light panel = **(242,242,242) = #F2F2F2** on the white plane with black ink. Radius stays **0** on both legs (documented choice: the ref has no tooltip at all, R063). Killed 305287-stale, relaunched dark **313923** with the R135 binary, then light **321009**.
- **ATTEMPT 1 — `KosToolTip` shared component: DEAD ON ARRIVAL, reverted.** `shared/qml/foundation/KosToolTip.qml` (ToolTip subclass, themed background/ink) + `ToolTip.toolTip: KosToolTip {}` at all 7 sites compiled clean and **qmllint ACCEPTS the assignment** — but the runtime rejected it: `Main.qml:871:26 无效的属性分配："toolTip"是一个只读属性` ⇒ the harness root failed to load, launcher exit 1. Site :871 is inside **`component GlassButton:` (an inline component)** — sites 1–3 of 4 are inline components. NOT diagnosed further (whether non-inline sites accept it is UNTESTED); the palette route sidesteps the mechanism entirely.
- **THE FIX — `Main.qml:13-27` (after `visible: true` on the `KosApplicationWindow` root): `palette.toolTipBase: root.tahoeDark ? "#3C3C3C" : "#F2F2F2"` + `palette.toolTipText: root.tahoe.labelPrimary`.** Basic/ToolTip.qml reads exactly these two slots; nothing else in QQC2 consumes them. Comment records the literals and the radius choice. The three sibling files (KosWindowControls/KosSidebarToggle/LiquidNavBar) are untouched — they render inside the calendar window only via this palette (LiquidNavBar's own windows, if any, stay un-themed; not a calendar concern).
- **THE MEASUREMENTS (both legs, 1100×692, R134 recipe: park (600,400), nativeRecord 30 ms, pointerObject toolbarAdd move, 4× none, captureClient).**
  - **DARK (313923, `r135-dark-tooltip.png`):** fill **(60,60,60)** at three interior probes (35,90)/(90,72)/(62,71) — **#3C3C3C byte-exact**; plane (20,80)/(120,80) = **(30,30,30)**; ink peak **(234,238,237)** ≈ #F2F2F2 under subpixel AA; **corners SQUARE** (left edge x28 for rows 68/70/74 — 1 px left of R134's x29, the added 1 px `separator`-family border's AA); panel **y67..97** at x40 (col edges 67/97) — 1–2 px taller than R134's 68..95, consistent with the border; centred on x62 unchanged.
  - **LIGHT (321009, `r135-light-tooltip.png`):** fill **(242,242,242)** = **#F2F2F2 byte-exact** on the white (255) plane; ink darkest **(10,5,7)** = black under subpixel AA; panel **y67..97**, left edge x28/29. Same geometry as dark.
  - Both captures md5-distinct (`947c4995…` dark / `960f3c14…` light). Figures: `docs/ui-calendar/r135-{dark,light}-tooltip-6x.png`.
- **ACCEPTANCE — PASS on both legs:** dark panel = a dark elevated surface, NOT white; ink = labelPrimary both legs; light panel stays light; radius 0 consistent both legs.
# R134 — **The dark-leg ToolTip is Qt's Basic style leaking through, UN-THEMED: a pure-white (255) panel, square corners (radius 0), near-black ink, 67×28, on a (30,30,30) plane.** No tooltip override exists anywhere in the tree — all four Main.qml sites use the bare QQC2 attached `ToolTip.visible`/`ToolTip.text`, so the panel is `Basic/ToolTip.qml`'s `Rectangle { color: palette.toolTipBase }` + `Text { color: palette.toolTipText }` with `padding: 6` and NO radius. Panel **x29..95 × y68..95 = 67×28**, **centred on the button's centre x62** (Basic's `x = (parent.width − implicitWidth)/2` with parent = the 28 px button: (28−67)/2 = −19.5 ⇒ left 48−19.5 = 28.5 ✓), **top edge 68 = the button's bottom 64 + 4** — *below* the button, though the installed style declares `y: -implicitHeight − 3` (**above**); that discrepancy is UNRESOLVED and is not claimed. **Onset f019 ≈ one frame after the hover, no delay**; no timeout within 3.4 s. Hover reproduced exactly (rim x49 135 → 171, apex x62 y37 141 → 174 = R132's ×1.632). **No source change this round — measurement + verdict only.** Killed 214895 (light), relaunched **dark = 216298**. Figure `docs/ui-calendar/r134-dark-tooltip-4x.png`.

## 本轮 (R134)
Atomic step: Next #1 of R133 — measure the dark-leg ToolTip (fill/ink/radius) and decide Qt-default vs ours. One kill+launch, one batch, one record, one read. No edit, no build.

- **THE LAUNCH.** 214895 (light) killed; `start-review-vm.sh dark` ⇒ **216298**, `KOS_APPEARANCE=dark`. Binary unchanged since R132 ⇒ no rebuild due.
- **THE RECORD.** Batch: `resize 1100×692` · `sidebar false` · `view week` · `date 2026-10-15` · `pointer(600,400,move)` PARK · `nativeRecord(interval 30, duration 4200)` · `pointerObject toolbarAdd move` · 4× `none` (delay steps) · `captureClient` ⇒ **114 frames**. Hover onset read off the rim column: **f015 135 (rest) → f020 149 → f025 166 → f030 171**, then flat 171 to f113.
- **VERDICT — QT'S DEFAULT IS LEAKING.** `grep` over `apps/calendar/qml`, `shared/qml`, `libs` finds **no tooltip component and no `ToolTip.toolTip` override** — only attached `visible`/`text` (+ `delay` at `KosWindowControls.qml:25` 700, `KosSidebarToggle.qml:13` 500, `LiquidNavBar.qml:278` 600). `ApplicationRunner.cpp:133` sets `QQuickStyle::setStyle("Basic")`. ⇒ the four Main.qml sites (`:869-870`, `:942-943`, `:1012-1013`, `:1954-1955`) render **`/usr/lib/.../qt6/qml/QtQuick/Controls/Basic/ToolTip.qml` verbatim**: `background: Rectangle { border.color: palette.dark; color: palette.toolTipBase }` — **no radius**, and `contentItem: Text { color: palette.toolTipText }`. Our palette is the default light one, so on the dark leg the panel is white with black ink.
- **THE PANEL, MEASURED (dark leg, 1100×692).** **x29..95 (w 67) × y68..95 (h 28)**; interior **255,255,255**; plane at left/right/above **(30,30,30)**; ink darkest **(6,20,88)** = black under subpixel AA (fringes only, not a colour token). **Corners SQUARE** — the left edge sits at **x29 for every row 68..74**, no inset ⇒ **radius 0** (Basic's background Rectangle has no radius). Height 28 = `padding 6` + ~16 px text + 6.
- **POSITION — CENTRED ON THE BUTTON, BUT BELOW IT.** Centre x = (29+95)/2 = **62 = `toolbarAdd`'s centre** ✓ (Basic's x formula). Top 68 = button bottom 64 **+ 4** ⇒ **below**. **The installed style says `y: -implicitHeight − 3`, i.e. above.** The mechanism that moves it below is **unresolved and not claimed** this round (not a native popup: the panel is inside the 1100×692 `captureClient` grab).
- **THE DELAY IS ZERO AT THESE SITES.** Panel region (x0..260 × y60..120) mean is flat **61.5 for f000-f018** then **87.8 at f019 → 87.9** for every frame to **f113** (3.4 s, **no timeout**). f019 is within one 30 ms frame of the hover onset ⇒ **≈0 delay**, against the 500/600/700 ms the other three components declare. **Caveat, load-bearing:** `hovered` here is set programmatically by `pointerObject`, so "no delay" may be an artifact of the harness path rather than the token-free default. R131 measured the same thing independently.
- **THE RECORD IS SOUND.** The dark rim reproduces R132 on the same frames: **x49 135 → 171** at y50, face x51 93 → 109, apex (x62,y37) **141 → 174** ⇒ α 0.2590 → 0.4228 = **×1.632**.
- **WHAT THIS ROUND DOES NOT DO: NO FIX.** The remedy (theme the panel, or accept Qt's) is the next round's step. Nothing was edited, so the binary and both legs stand unchanged.

## 仍差 (top 8, visual-impact order)
1. **The timed chip's text block — E02's "title 11–12 medium, secondary 10–11" vs our 9/no-secondary.** Root cause is the **chip height** (16 on a 40 px hour = 0.40 of the pitch, vs the ref's 26 on 27 = 0.96), colliding with **T01**'s two-chips-per-cell — exhibited by the 11:00 double. **Blocked on a ruling (chip-height model).**
2. **The E01/E02 inset-and-stripe scale convention (R123/R124/R125):** our inset 3 vs E02's "about 4" (the ref's own is 2, ×1.35 ⇒ 2.7 ⇒ 3 is ref-correct and "4" is the outlier); stripe 4 vs E01's "2–3" (ref 2.4 ⇒ 3.2 scaled). One **G-class scale ruling** settles inset + stripe + any future "about N".
3. **The all-day BAND chip's icon — ours has NONE.** Ref 12×12 ring, stroke 3 / hole 6, inset 3, colour = `itemColor`; @×1.33 ⇒ **16 / stroke 4 / inset 4 / text at fill_left + 28**. **Do NOT build until ruling H.**
4. **Ref gutter labels are 12-hour and two-tone** (dark hour + smaller lighter `AM`/`PM`), right-aligned on the **suffix's** edge; ours is single-size 24-hour `07:00`. **Needs ruling F.**
5. **Month day cell `slice(0, 2)` — 1 chip + `N` where the ref stacks 3.** **Needs ruling D** — and a 3-all-day-item *month* day before it can be reproduced at all.
6. **Dim snaps while the card animates** (`KosWorkspaceDialog.qml:24-27`) + **shadow magnitude** (D03: peak Δ≈10/255 = 3.9%). App-wide. **Need rulings A and B.** *R132/R133: the dim lands in one frame, +40 ms after the release, ×0.571 dark / ×0.80 light.*
7. **The ref's segment carries a 4th word — `Year` — and we have three with no year view.** L03 specifies three, so three is spec-correct; adding a view is not atomic. **Blocked on a ruling.**
8. **C05's remaining half — only the label COUNT is left.** (a) hover boost measured on both legs (dark α ×1.632 R132; light 0.857 → 0.962 = ×1.12 R133). (b) **the dark-leg `ToolTip` panel is WHITE — ROOT-CAUSED in R134 (Qt Basic leaking, un-themed); the fix is Next #1.** (c) the label COUNT stays ruling-blocked.
- **ALL CLOSED:** **C05 BOTH LEGS — hover (dark R132 α ×1.632, light R133 α ×1.12 saturating) + pointer (R131, press +0.38 px, release 0.01 px)** · **L05 BOTH HALVES (channel R129, frames R130)** · **A01 / A02 (3/3) / A04 on BOTH legs** · **L03 both legs (light R105, dark R127 5/5)** · **S02/S03/S05 + C01-C04/C06 on BOTH legs** · **E01 on BOTH legs** · **E02's column gap on BOTH legs (measured 2)** · the timed chip's radius · the two reds · the month title's ink · the month chevrons · **M04 all three halves** · T01/T02/T03 · A03 both clauses both legs · M01/M02/M03 both legs. **Full text: `rounds.md` tail.**

## 最近已改 (most recent 8)
0. R134 — **verification only, no source.** Dark ToolTip **root-caused**: no override in the tree ⇒ `Basic/ToolTip.qml` verbatim (`palette.toolTipBase`/`toolTipText`, no radius); panel **67×28 at x29..95/y68..95**, white 255 on a (30,30,30) plane, square corners, centred on the button's centre **x62** but **4 px BELOW** it; onset **f019 ≈ 0 delay**; no timeout in 3.4 s.
1. R133 — **verification only.** C05 light leg **PASS**: rim (x49,y50) 251 → 254 = α **0.857 → 0.962 (×1.12)** vs the declared saturation 1.111; the rim-box ≥254 census 138 → 162 → press 337. New: `position` is a timeline scroll, not a pointer park.
2. R132 — **`Main.qml:828-839`: the rim's `hoverRimBoost` moved from the item's `opacity` (clamped to 1.0) onto the border colour's alpha.** Verified dark: rim α 0.2590 → 0.4228 = ×1.632 (declared 1.6; clamped was 1.005).
3. R131 — verification only. C05 hover half **FAIL** on dark: rim α 0.2755 / 0.2768 vs a declared 1.6×; press sink **+0.38 px**; release → **0.01 px**. New: the dark-leg ToolTip is white.
4. R130 — verification only. L05 **PASS**: 60-frame record, segment ink ⇔ width 0, never both; one-frame blank band per edge.
5. R129 — verification only. L05 channel OPEN: `pointerObject` + objectName; press+release ⇒ `toolbarSearch` 0→280→0 at x736..1016.
6. R128 — verification only. A01/A02/A04 dark PASS: rules 39 / 84 / 59 (order 39 < 59 < 84), leg 156..231 = 76.
7. R127 — verification only. L03 dark PASS 5/5; `segmentTrack` / `segmentPill` / `mutedTextColor` solved on dark.
- *(R126 and earlier archived to `rounds.md` tail.)*

## 外推待确认 (live only)
- **AN UN-THEMED FRAMEWORK DEFAULT IS PROVED BY THE ABSENCE OF AN OVERRIDE, NOT BY ITS PIXELS (R134, load-bearing).** A white panel on a dark window proves *only* that it is white. ⇒ **Grep the whole tree for the control before naming a style: no `ToolTip` component and no `ToolTip.toolTip` in `apps/`, `shared/`, `libs/` + `QQuickStyle::setStyle("Basic")` at `ApplicationRunner.cpp:133` is what makes "Basic is leaking" a root cause instead of a guess.**
- **A FRAMEWORK STYLE FILE IS AUTHORITATIVE FOR *FORM*, NOT FOR *PLACEMENT* (R134, open).** The installed `Basic/ToolTip.qml` declares `y: -implicitHeight − 3` (above the item); the panel measures **4 px below** it. The form (no radius, `palette.toolTipBase`, `padding 6`) matches byte-for-byte, the y does not. ⇒ **Verify a style's geometry claim on the running app before repeating it; an unresolved discrepancy goes in the record, not into a derivation.**
- **A PROGRAMMATIC `hovered` CANNOT PROVE A DECLARED DELAY (R134, load-bearing).** The panel appears within one 30 ms frame of `pointerObject`'s move, while three sibling components declare 500–700 ms. ⇒ **The harness drives `hovered` directly, so "delay ≈ 0" is measured, but "the app has no delay token" is NOT — a real pointer move is the only way to settle it.**
- **A SATURATING BOOST IS PROVED BY ITS RATIO, NOT BY REACHING THE CEILING (R133, load-bearing).** On light, `0.90 × 1.6 = 1.44` clamps to 1.0, so the measurable excursion is 0.90 → 1.0 and the ceiling pixel reads **254, not 255**. ⇒ **When a declared multiplier saturates, the criterion is the RATIO the declared saturation predicts (1.0/0.90 = 1.111). Measured ×1.12.**
- **AN EXCURSION OF ~3/255 IS A QUANTIZATION-LIMITED MEASUREMENT (R133, load-bearing).** ⇒ **Prove a ramp on the leg/token whose excursion is large (dark, 43 levels); use the low-contrast leg only for presence + magnitude.** Corollary: attribute the rise correctly — `hoverLift` bleeds only `(1−α)·Δface ≈ 0.3` level onto the rim column.
- **AN ACCEPTANCE CRITERION MUST BE WRITTEN IN THE UNITS THE TOKEN DECLARES (R132, load-bearing).** The button's face is **lens-sampled**, so its absolute pixel is fixture- AND leg-dependent (R131 fill 59 vs R132 face 89; light reads 227). ⇒ **When a token declares an alpha, accept on the ALPHA.**
- **A DECLARED MULTIPLIER CAN BE SILENTLY CLAMPED BY THE PROPERTY IT DRIVES (R131/R132, load-bearing).** `opacity` is 0…1 ⇒ the 1.6 boost never rendered; R132 moved it to the colour's alpha, and R133 then found the **second** clamp — the alpha itself saturates at 1.0. ⇒ **Ask WHICH property carries a "boost", and whether it can express the result.**
- **`position` IS A TIMELINE SCROLL, NOT A POINTER PARK (R133).** ⇒ **Park the pointer with an explicit `pointer(x,y,move)` first, or the "rest" frames were never at rest.**
- **A UNIFORM SCRIM PRESERVES A MID-LEVEL EDGE CROSSING (R131, load-bearing).** ⇒ **A post-click dim does not invalidate a pre-click geometry reading.**
- **A STRICT MUTUAL-EXCLUSION CLAIM IS PROVED BY THE BLANK FRAME, NOT BY THE CLEAN FRAME (R130, load-bearing).** ⇒ **Look for the frame where both are ABSENT.**
- **A ROUNDED CAP BIASES A LEFT-EDGE SCAN RIGHT, AND THE BIAS GROWS AS THE CONTROL COLLAPSES (R130, load-bearing).** ⇒ **Measure a width at the control's PINNED edge, or read `inspectGeometry`.**
- **`nativeRecord`'s `interval` IS A FLOOR, NOT A RATE (R130, load-bearing).** Requested 30 produced real spacings of 31–88 ms. ⇒ **Never place frames on a timeline by `index × interval` — label states from the PIXEL series (R133).**
- **A POINTER CHANNEL IS PROVED BY A STATE CHANGE READ OFF GEOMETRY, NOT BY A FRAME (R129, load-bearing).** ⇒ **Buy the channel for one `inspectGeometry` round-trip; it is free and falsifiable.**
- **A HARNESS TARGET STRING IS AN `objectName`, NOT AN `id` (R129, load-bearing).**
- **A BAND THAT GROWS BY MAX-ROW-COUNT IS PROVED BY ITS EMPTY COLUMN (R128, load-bearing).**
- **A DECLARED PER-LEG ALPHA IS THE SECOND WITNESS TO R125 (R128, load-bearing).** `0.32` dark / `0.17` light ≠ 1−0.17 ⇒ **never derive the dark leg from the light alpha.** *R133: the click scrim is ×0.571 dark / ×0.80 light.*
- **A GRADIENT-BEARING TOKEN IS PROVED BY ITS RAMP, NOT ITS MIDPOINT (R127, load-bearing).**
- **AN OPAQUENESS COMMENT IS A TESTABLE CLAIM (R127, load-bearing).**
- **A LEG-INVARIANT GEOMETRY IS CHEAPEST TO RE-PROVE ON THE LEG WITH THE WORSE CONTRAST (R127, load-bearing).**
- **A HARDCODED LITERAL'S LEG-INVARIANCE IS PROVED AGAINST THAT LEG'S OWN PLANE (R126, load-bearing).**
- **A DYNAMIC APPEARANCE'S WASH IS A DECLARED TOKEN, NOT A DERIVATION (R125).** Light 0.19 / dark 0.36 is a literal at `CalendarScheduleView.qml:850`.
- **A THEME MIRROR IS PROVED BY THE BLEND, NOT THE EXTREME PIXEL (R125).** ⇒ **Never an extreme pixel on small coloured ink — solve all three channels.**
- **"EVERY EVENT SITS IN A DISTINCT HOUR" IS A CLAIM ABOUT ONE ITEM TYPE, NOT ABOUT THE FIXTURE (R124).** ⇒ **Before calling a clause unmeasurable, enumerate every item class at that slot.**
- **A DERIVED RATIO IS NOT A MEASUREMENT — RE-MEASURE THE REF ON THE ELEMENT YOU ARE ABOUT TO DERIVE (R123).**
- **A CLAUSE THE FIXTURE CANNOT REACH IS NOT PASSED (R123).**
- **HARNESS / COMMAND / TOKEN RULES.** **`review-command.py` takes ONE argv that is a JSON list OF OBJECTS**; a list of bare STRINGS raises `TypeError` at `:7`. It bumps `sequence` and writes **in place**. **The capture action is `captureClient` + `path`; `capture` + `name` FAILS SILENTLY** — `ls` the file. **THE `path` RESOLVES AGAINST THE APP'S CWD** ⇒ pass ABSOLUTE paths. Pillow crops need ABSOLUTE paths. Our PNGs are zlib level 0 ⇒ **compare `md5sum`, never the size**. **THE LAUNCHER REFUSES WHEN A LIVE INSTANCE IS ALIVE** ⇒ **ALWAYS `kill -0 $(cat live-app.pid)` FIRST**; the leg is readable off `/proc/<pid>/environ` (`KOS_APPEARANCE`). **A live instance keeps the VIEW and the SIDEBAR you last set** ⇒ re-set them every batch. **A rebuilt binary — or a changed pim fixture — NEEDS kill + relaunch**; the app starts `--view week --date 2026-10-15` sidebar COLLAPSED. **THE LAUNCHER RESETS `command.json`** ⇒ re-issue resize/sidebar/view/date after every relaunch. **The week starts MONDAY.** The app's console goes to `live-runtime-vm.log`. Actions: `resize(width,height)`/`sidebar(expanded)`/`view`/`date`/**`position` = TIMELINE `contentY`, NOT a pointer park (R133)**/`wheel`/`flick`/`stop`/`openItem`/`windowWheel`/**`pointer`(x,y,kind) = the way to PARK the pointer**/`pointerObject`(target=**objectName**, kind=**move|press|release**)/`inspect`/`inspectGeometry(names[])`/`runtimeInfo`/`scrollInfo`/`typeText`/`escape`/**`nativeRecord`(prefix,interval,duration) — non-blocking; all later steps land inside its window; there is NO sleep action — pad with `{"action":"none"}` steps (~0.6 s each, R134)**/`regionWheel`/`regionPosition`/`captureClient(path)`. **`pointerObject move` sets `hovered`, `press`/`release` sets `pressed` — all three are frame-drivable.** **A static screenshot still can never settle an animation.** **Compositing:** a 1:1 crop + a 2–7× zoom answers "form + detail" in ONE read; `ImageDraw.text`/`line` labels make it self-describing; `NEAREST` for pixel structure, `LANCZOS` for smooth upscale. **No `numpy` here** — `PIL` `get_flattened_data()` replaces the deprecated `getdata()`. **tmp/ is gitignored**; the committable mirror is `docs/ui-calendar/` with **`LEDGER.md` = a byte copy of `state.md`**. **A `python3 -c` payload containing markdown backticks is mangled by the shell — use a heredoc.**

## Pinned geometry (unchanged — derivations in rounds.md tail)
- **OUR COLUMN MAP AT 1100x692.** Sidebar-collapsed: rim x0; gutter x1..51; separators **52/202/352/502/652/802** in BOTH band and grid, pitch 150. **Expanded: gutter 221..272, separators 272/391/510/629/748/867/986 (pitch 119), Thu = 629..747**, rim x220 = the 1 px separator. Sidebar x0..219 (**220** wide, L01 R125 — canvas continuous, no outer card margin). **Chrome stack (R125/R126, 1100x692): top band y0..29, toolbar band y30..69 = 40 (capsule y36..63 h28 centred 49.5), heading band y70..117 = 48 with its rule at y118, title ink left 241 = inset 20 and 28 tall, L07 group 970..1079 (26 high, margin 20, gaps 6).** Toolbar buttons box **28**, gaps **8**, left pair 12..39 / 48..75, right pair 1022..1049 / 1058..1085, icon item **16** (`Main.qml:189 toolbarIconSize`, glyph ink 13).
- **THE TOOLBAR BUTTON'S POINTER STATES (R131/R132 dark, R133 LIGHT — both 1100x692; the box is window-wide, so the sidebar does not move it).** `toolbarAdd` box **x48..76 × y36..64 = 28×28**, centre **(62,50)**; the round face's rim line peaks at **x49** (left) / **x74** (right) at y50. `glassRim` = white@**0.90 light** / white@**0.28 dark** (`:72-73`); `glassEdge` = black@0.08 light / white@0.10 dark (`:68-69`), read at **x48**.
  - **DARK (R132, α from the face at x51/x52): rest 132/89 ⇒ 0.2590; hover 169/106 ⇒ 0.4228 (×1.632, declared 1.6); right rim x74 136/98 ⇒ 0.242 → 171/115 ⇒ 0.400 (×1.65); apex (x62,y37) 139 → 174.** *(R134 re-read on its own record: x49 135 → 171, face x51 93 → 109, apex 141 → 174.)*
  - **LIGHT (R133, α from the face at x50/x51): rest 251/227 ⇒ 0.857; hover 254/229 ⇒ 0.962 (×1.12, declared saturation 1.0/0.90 = 1.111). Neighbour columns at y50, rest → hover: x48 (edge) 216 → 220, x49 (rim) 251 → 254, x50 228 → 230, x51 226 → 228, x52 227 → 229, x73 235 → 237, x74 (rim) 252 → 254, x75 226 → 229. Apex x62: y37 253 → 254 over backdrop y38 238 → 240. Rim-box census (x46..78 × y34..66, pixels ≥254): rest 138 · hover 162 · press 337.**
  - **`hoverLift` (no dark branch, `:231`): dark face 89 → 106 (α 0.0955); light face 227 → 229 (+2, `0.10·(255−227) = 2.8`).**
  - **`pressScale` 0.97: dark — left rim peak x49 → x50, apex row 37 → 38, right rim x74 → x73. Light (R133) — the x49 rim splits to x49/x50 = 244/242 and the ≥254 census jumps 162 → 337. Release: right rim peak x73 → x74.**
  - **+40 ms after the release the new-event dialog's dim scrim lands and the tooltip vanishes — measured ×0.571 dark (R132) and ×0.80 light (R133, face 231 → 185). The released rim reads ≈144 true on dark, between rest and hover — OPEN (Next #2).**
  - **THE FACE PIXEL IS LENS-SAMPLED ⇒ fixture- AND leg-dependent (dark 89, light 227); only the ALPHA is comparable.**
- **THE `toolbarAdd` TOOLTIP — QT BASIC, UN-THEMED (R134, dark leg, 1100x692).** Panel **x29..95 (w 67) × y68..95 (h 28)**, interior **pure white 255**, plane around it **(30,30,30)**, ink near-black (darkest (6,20,88) = subpixel AA of black), **corners square (left edge x29 for rows 68..74 ⇒ radius 0)**. **Centred on the button's centre x62**; **top 68 = button bottom 64 + 4 ⇒ BELOW the button** (the installed `Basic/ToolTip.qml` declares `y: -implicitHeight − 3`, above — UNRESOLVED). Source = `Basic/ToolTip.qml` verbatim: `color: palette.toolTipBase`, `border.color: palette.dark`, `contentItem: Text { color: palette.toolTipText }`, `padding: 6`, `margins: 6`, `closePolicy: CloseOnEscape|CloseOnPressOutsideParent|CloseOnReleaseOutsideParent`; style set at `ApplicationRunner.cpp:133`. Sites: `Main.qml:869-870`, `:942-943`, `:1012-1013`, `:1954-1955` (**no `delay` declared ⇒ measured ≈0**); `KosWindowControls.qml:25` declares 700, `KosSidebarToggle.qml:13` 500, `LiquidNavBar.qml:278` 600. **No timeout observed in 3.4 s.**
- **THE TOOLBAR'S SEARCH FIELD — THE HANDOFF, BOTH EDGES (R129 geometry / R130 frames, dark leg, 1100x692, sidebar expanded).** Collapsed: `toolbarSearch` **width 0 at x1016** (= toggle.left 1022 − `rightMargin 6`), `visible false`; `toolbarSearchInput` width **−24**. Opened by press+release on the toggle: **x736..1016 = 280 w × y36..63 = 28 h** ⇒ 6 px inside the band's top (30) and bottom (69); input content **748..1004 = 256** ⇒ inset **12**. **280 is `maxWidth`'s cap** (`Math.min(280, max(0, mainWidth − 2·28 − 3·8 − 24))`, `:1814-1817`). Toggle box **1022..1049 × 36..63**, centre **(1036,50)**. **The transition is a left-edge-only width animation, `Behavior on width { NumberAnimation { duration: AppTheme.motionFast (150); Easing.OutCubic } }` at `:1882-1883`; the right edge stays pinned at 1016 and the height stays 28 at y36..63 at every sampled width, down to the 8 px sliver.** The segment hides via `opacity: toolbarSearch.active || toolbarSearch.width > 0 ? 0 : 1`, `visible: opacity > 0` (`:1757-1765`) ⇒ **strictly sequential, and its signature is a ONE-FRAME BLANK of the band on each edge** (open f28 ≈1231 ms, close f53 ≈2678 ms). **Measured widths:** open 171 / 252 / 280 at ≈40 / 117 / 184 ms; close 280 / 180 / 55 / 8 / 0 at ≈−17 / 21 / 72 / 138 / 202 ms from S ≈ 2476. Toolbar objectNames: `toolbarSidebarToggle` 1721 · `toolbarAdd` 1739 · `toolbarViewSegment` 1752-1754 · `toolbarSearchToggle` 1791 · `toolbarSearch` 1811 · `toolbarSearchInput` 1897 · `toolbarMore` 1938.
- **THE SEGMENT CONTROL (R097 light / R127 dark — both legs identical).** Track rim pixels **x562..757 = 196** ∈ [180,210], **y36..63 = 28**; main region x221..1099 centre 660 ⇒ track centre **659.5 = −0.5**. Lens rims **x630 / x689** ⇒ box ≈629.5..689.5, **w 60, centre 659.5 = Week's ink centre**; `radius 13.44` track / `11.52` lens (`LiquidSegmentedControl.qml:84/122`, = height × 0.48). Label ink boxes **x592..599 / x655..664 / x719..727** ⇒ centres **595.5 / 659.5 / 723.0**, ink **11 tall** (CJK 日/周/月 on this fixture). **Light (plane 255): track 250, lens 232, lens rim 233, track rim 222, ink cores 8 / 0 / 12. Dark (plane 30): track 47 (ramp 50→42 top→bottom), lens 66 (ramp 76→59), lens rim 77, track rim 62, ink peaks 236 / 242 / 233.** Tokens: `segmentTrack` = white@0.06 dark / `0x78,0x78,0x80`@0.025 light + the track's own gradient white@0.04→black@0.02; `segmentPill` = `#3C3C3C` dark / `#E7E7E7` light + the lens's 3-stop gradient; `mutedTextColor: labelPrimary`; track border `AppTheme.border`, lens border white@0.16; `lensShadow` black@ `dark ? 0.24 : 0.10` at `lens.y+1` (y62 on dark = 32).
- **THE DARK CHROME AND THE DARK SIDEBAR LIST (R126, read on the R125 leg, 1100x692).** Top band **y0..29** carries the window's own planes: **(40,40,40)** left of the rim, **(30,30,30)** right of it ⇒ the dark mirror of 228/255; **outer corner radius 30 proved by the arc** (centre (1070,30): y17 ⇒ edge **1097.04**, capture black at **1097**; y5 ⇒ 1086.58, x1090 black); first toolbar ink **y37**. Dots: cores **green (38,174,59) / yellow (220,164,44) / red (221,85,78)** = 0.85·token + 0.15·(30,30,30) to ≤0.5/255; disc **14.0** (edges 1015.51/1029.49; vertical 10.49..24.51), gaps **14.0**, centres **1022.50/1050.50/1078.49** (pitch 28), red right edge **1085.49**, red top edge **10.49**. Sidebar list on dark (plane 40,40,40): box **x12..23 = 12 w × 12 h**, radius **3** (top-row missing area **1.61 px²** ⇒ r≈3.2), pitch **30**, label ink left **32** (gap 8), label 13 (ink 12 Latin / 13 CJK) / heading 11 (ink 9), heading left **12**, group gap **16**, heading→first row **6**; box fills 日程 (0,136,255) · 计划任务 (52,199,89) · Inbox (79,140,255) · Personal (57,196,135) · Gold (215,166,44) · Red (227,92,86); 显示已完成 unchecked ⇒ outline only; **y400..518 empty** ⇒ no status card.
- **OUR TIMED CHIP (R123 geometry, R124 radius, R125 dark).** 08:00 Thu: fill **x632..743 (112 w) × y317..332 (16 h)**; rule x629 ⇒ inset **3** from its left edge; stripe **x636..639 = 4 px** at `stripeInset` 4; **light fill (216,234,245) = itemColor@0.19 over white; dark fill (36,69,90) = itemColor@0.36 over (30,30,30) — `:850` `AppTheme.dark ? 0.36 : 0.19`**; itemColor **(48,140,198)** (= the stripe, hue-invariant evidence: green (57,196,135), gold (215,166,44)); **`radius: 3` (`:838`, R124) ⇒ corner cut ≈1.4 px, the same AA triple on both legs**; hour pitch 40 ⇒ **chip = 0.40 of the hour**; `Math.round(hourHeight*21/54)` = 16 (`:817`), `:808` `anchors.margins: 3` + `spacing: 2`, title `font.pixelSize: 9` (`:884`, no weight), ink `root.chipInk` = itemColor half toward the leg's pole (`:269-276`; light → (24,70,99), dark → (151,197,226)), no secondary line. **Full chip y-map on 2026-04-02 Thu: 08:00 317-332 · 09:00 357-372 · 10:00 397-412 · 11:00 437-452 + 455-470 · 12:00 477-492 · 14:00 557-572** — the **11:00 cell is the fixture's two-item hour** (`Long review…` + `[R019 LONGTASK]`, the latter green), gap **2**, cell **434..474**.
- **REF TIMED CHIP, 1:1 (R063/R077, corner re-measured R123).** Hour pitch **27**; a 1-hour chip is **y332..355 = 24–26 ⇒ 0.96 of the hour**; fill **(222,237,254)** from **x489..567 (79 w)** in a column 487..569 ⇒ inset **2** from the rule's left edge; bar core **(59,134,247) x491..492 + AA at 493 = 2.4 px**, inset 1.5–2, round caps; **ink core (26,67,123) = bar/2**; **corner cut ≈1–2 ref px ⇒ radius ≈2 on 26 = 0.08×height**; no border. The ref's chip carries a small glyph at its right edge.
- **THE SIDEBAR CATEGORY LIST (S02/S03, R121 light / R126 dark — both legs identical).** Today row 44 tall then a 1 px separator. Group heading `Label`: `leftMargin 12`, `font.pixelSize 11`, block = `topMargin 16 + preferredHeight 16`, `bottomMargin 6` ⇒ heading→first row **6**, group gap **16**. `CategoryRow` pitch **30** — box centres **173.5/203.5/233.5** and **301.5/331.5/361.5/391.5**. Box **12×12** at **x12..23** (nested inset 36), `radius 3`, hover background x6 w-12 r6; label **13** at **left 32** (gap 8); elide tail inset 12 ⇒ ink must stop at **208**.
- **THE MINI MONTH, EXPANDED SIDEBAR (R112/R115-R118).** Cells 12..208; `cellWidth = 196/7 = 28.0`, `cellHeight 21`; column centres **26.0 + 28.0i**; date-band tops **545** then **561/582/603/624/645/666/688** (font 11). **Both discs are `tahoe.miniDisc` = 18×18**, today `todayRed` `(229,72,77)`, selected `selectionDisc` `#8E8E93`; white digits. **Heading row:** two buttons **28×28 at centres 26 / 194**; arrow ink **5 wide × 9–10 tall at `x23..27` / `x191..196`**, tone `(156,156,156)`; title **font 13 DemiBold, `labelPrimary`**, ink **`0/255`**.
- **THE ALL-DAY BAND'S Y-MAP — BOTH LEGS (light R106/R107, dark R128).** `sectionRule` **y=155** (light 242 / **dark 39** = 30+0.04·225, 1px); 3-row leg interior **156..231 = 76**; `allDaySeparator` **232-233** (light 217, **dark 84** = 30+0.24·225, 2px); grid top rule **234** (light 237 / **dark 59** = gridLine white@0.13; **dark weekend columns 65** = 37+0.13·218). 0-row leg: interior **156..181 = 26**, separator 182-183, rule 184. ⇒ **band = 1 + 25N.** **THE SPEC'S DARK ORDER IS 39 < 59 < 84 and every one lands ≤0.5/255.** Rules span **x221..1099** (sidebar plane 40,40,40 with rim 61 at x220).
- **OUR ALL-DAY CHIP (R128: form byte-equal on both legs).** Expanded week Mon 30 – Sun 5 2026: columns **272·391·510·629·748·867·986** (Mon..Sun) ⇒ **Thu Apr 2 = 629..747**. Mid-height envelope (y178/y179) **identical on light and dark**: merged Mon–Wed **274..625**, Thu `Design sync` **631..744**, Fri `R087 sole` **750..863**; Sun Apr 5 EMPTY (its interior reads the weekend tint to y231). With R109's reach Tue/Wed start at 388/507 so the envelope is **unbroken**; **chip = 116 px in a 119 px column, inset 1 each side**. Fill = `:589` `AppTheme.mix(allDayBackdrop, itemColor, dark ? 0.32 : 0.17)` — **light (220,235,245) = 0.17·(48,140,198)+0.83·255; dark (36,65,84) = 0.32·itemColor + 0.68·(30,30,30)** — both ≤0.4/255. Ink = `root.chipInk` (`:604`). Label `leftMargin 5` (+ joint overlap), `rightMargin 4`. **Overflow row**: row 3 (207-230) is a full row slot with **no fill**, text `+2` ink at **x635..645** on y218.
- **REF ALL-DAY BAND, 1:1.** Rows **y126-143 / 145-162 / 164-181** ⇒ **row 18, gap 1, pitch 19**; top rule **y=124** (242); bottom separator **183-184** (217); grid top rule **y=185** (244); inset ≈1; content **125..182 = 58**. Chip radius **≈6 = row/3**; fill alpha **≈0.16**; ink = itemColor/2; **ring icon 12x12, stroke 3, hole 6, 3 px inside the fill edge**. Every ref band chip is SINGLE-DAY, inset ~6–7 ref-px from its column rule. Ours: row 24 / gap 1 / inset 1 / radius 8 / band 76 (or 26) / hue ink — every *form* item matched **except the icon (仍差 #3)** and the G-class literals.
- **OUR TOKENS.** `CalendarScheduleView.qml:95-112`: `gridLine` (light `#EDEDED` / dark white@0.13), `gridLineMinor` (`#F4F4F4` / white@0.06), `allDaySeparator` (`#D9D9D9` / white@0.24), `sectionRule` (`#F2F2F2` / white@0.04). **The ORDERING is the requirement:** ref 242 < 237 < 217, ours light 242 < 237 < 217, **dark 39 < 59 < 84 (R128, measured)**. Schedule grid field pure **WHITE** light / **(30,30,30)** dark (`scheduleField`, `Root.tahoe.contentPlane`, `Main.qml:47-48`); the dark column separator reads **(59,59,59)**, the dark sidebar plane **(40,40,40)**, the sidebar rim **(53,53,53)** (R125/R126). Weekend columns **249 light / 37 dark**; the gutter is NOT tinted. Sidebar plane **(228,228,228)**; the mini month's weekend cells **(214,214,215)**.
- **`hourHeight` is THE pitch constant (R064)** (`:53`). Chip height **16**, half-hour line **20**. Additions since: R072 the four `allDay*` tokens; R077 the chip's `stripeWidth`/`stripeInset`; R079 `timedChip.inkColor`; R080 `allDayChip.inkColor`; R088 the band model; R083 `Main.qml:itemStableId`; R091 the timeline's reposition trigger (`:276`); R093 `AppTheme.todayRed` + its 5th consumer at `Main.qml:2204`; R094 the mini disc's `15`; R097 `tahoe.segmentTrack`/`segmentPill`; R099 the segment's `mutedTextColor`; R101 `LiquidSegmentedControl.qml:121`; R102 `:117`/`:119`; R104 `:87`; R106 `:64/76-83/483/411`; R108 `:548`; R109 `:87-92`, `:114-134`, `:551-562`, `:568`; R116 `tahoe.selectionDisc` + the delegate's white digit; R117 `tahoe.miniDisc: 18` + the delegate's shared `Rectangle` (`Main.qml:2243-2250`); R118 `component MiniMonthChevron` + the two `miniCalendarHeading` buttons' `text: ""`; R121 `Main.qml:160-171` = the S02/S03 token block — measured, not touched; R123 nothing; R124 `CalendarScheduleView.qml:838` `radius: 5` → `3` on `timedChip` + the stripe comment at `:856-860`; **R132 `Main.qml:828-839` — the rim's boost moved onto the border colour's alpha; R125-R131 / R133 / R134 nothing (verification only).**
- **THE GLASS BUTTON'S DECLARED STATE MODEL (R131 read, R132 fixed, R133 re-read on light).** `GlassSurface` (`Main.qml:642-845`) is the `background` of `ToolbarButton` (`:913-959`). Tokens: `hoverLift: 0.10` (`:231`, no dark branch), `hoverRimBoost: 1.6` (`:233`), `pressScale: 0.97` (`:235`), `pressDuration: 150` (`:237`), `glassRim` = white@**0.90 light** / white@**0.28 dark** (`:72-73`), `glassEdge` = black@0.08 light / white@0.10 dark (`:68-69`), `pressedShadowOpacityFactor 0.55` / `BlurFactor 0.75` / `OffsetFactor 0.6` (`:239-241`), `shadowBlur 8` / `shadowOffsetY 1.5` (`:204-206`), `lensSampleBand 84` / `lensVeilOpacity 0.55` (`:218/:226`). `hoverAmount`/`pressAmount` are plain `property real` with `Behavior` animations (`:660-665`) — unclamped, unlike `opacity`. The rim `Rectangle` at `:828-839` carries `border.color` = `Qt.rgba(glassRim.rgb, Math.min(1, glassRim.a * (1 + (hoverRimBoost-1)·hoverAmount)))` with `opacity: 1` — the R132 FIX; **the `Math.min(1, …)` is a SECOND clamp: on light 0.90 × 1.6 = 1.44 saturates, so the visible excursion there is 0.90 → 1.0 = ×1.111 (R133 measured ×1.12)**. The vertical profile at `:797-820` is hover-invariant (`:801`). The press sink is a `Scale` transform about the centre (`:836-844`) — visual-only, the layout box never moves.
- **THE WINDOW DOTS ARE THE SETTINGS APP'S, BYTE-FOR-BYTE (R122).** `apps/calendar/qml/Main.qml:1637-1661` ≡ `apps/settings/main.qml:911-928`: `width/height 14`, `radius 7`, `spacing 14`, `anchors.right: parent.right; rightMargin 14.5`, `topMargin 10.5`, colours **`#28c840` / `#febc2e` / `#ff5f57`** in that order, `opacity: 0.85`. Measured light: red box **x1072..1084 / y11..23**, centres **1022.5 / 1050.5 / 1078.5**. **R126 dark: the same numbers to 0.02 px.** The **top band is 30** (`topSafeInset`, `:1632`); toolbar chrome starts **y36**; outer corner radius **30**. The ref's own dots are macOS-order red/yellow/green at the **top-LEFT** — **not** our authority.
- **THE GUTTER LABEL IS RIGHT-ANCHORED AND SIZE-DERIVED (R066).** font 11, `anchors.right` + `rightMargin: 7`. **A gutter scan must start at x ≥ 3.**
- **REF FACT SHEET (R063, compacted; R103-R105/R107/R108/R115/R117/R118 revise the segment, the sidebar, the band and the mini month).** `.loop/refs/macos-calendar.png` = **814x522, 1:1, WEEK view** (Apr 2026, **today = Wed Apr 1**) + a **192px sidebar** (plane 237, ends **x=191**, mini month with today Apr 1 at **x91..105 / y395..409**, header `S M T W T F S`, **column pitch 24.25**, month arrows 5×9 ink at **x22..27 / x169..173, y350..358**, title ink **x69..123 / y349..358 at tone 97** — **the sidebar carries NO category list; S02/S03/S05 are spec-only**) + a **52px white hour gutter (192..243)**. Day headers (text y108-116) → all-day band (y124–184) → hour grid 8 AM–8 PM. Gutter labels 193/220/247/274/301/328 = **pitch 27**; the red `9:41` pill replaces the 10 AM label (centre = the now-line **y=238**), red **(235,76,70)**. **7 equal day columns, 1px separators at 324/406/487/569/650/732, grid x=243..812 ⇒ 81.3px/column.** **Scale to our 1100x692: w 1.35, h 1.33** ⇒ ref pitch 27 ≈ 36 (the contract says 40). **Columns: Sun 29 · Mon 30 · Tue 31 · Wed 1 · Thu 2 · Fri 3 · Sat 4.** **Toolbar row y4..36**, holding the traffic dots, a 2-icon capsule x≈122..190, a round `+` x≈205..230, the Day/Week/Month/Year capsule at **x388..616 (W 229, slot 56.0, selected pill W 51–52.4, h 24 y12..35, r 11.5, word centres 418/474/530/586, track rim core x388..616 / y8..38 ⇒ H ≈ 31, r fit 11.25–13.5 = the lens's own 0.48 token, R104; rim centre 502.0 = the main region's centre 502.5)** , and two round glass buttons (radar, search) at x≈735..810.
- **Fixtures on 2026-04-02** (live = `profile/pim/calendar.ics` **under `tmp/ui-acceptance/calendar/`** — the repo-root `calendar-fixture.ics` is **stale, no VTODOs**): VEVENTs **08:00 / 10:15 / 11:00 / 14:30 / 18:00 on EVERY day 2026-03-29 … 2026-04-04** plus a **`Multi-day review`** all-day strip **`20260330` → `20260403`**. **R087 ADDED**: `R087 card C`, `R087 card D` (both `20260402`) and `R087 sole` (`20260403`) ⇒ **Apr 2 carries 4 all-day items, Apr 3 exactly 1.** Also `Design sync` / `Release notes` (all-day `20260402`). UID-ordered since R083. WTODOs: `[UI] Green planning` 09:00, `[UI] Gold review` 12:00, `[UI] Red review` 16:00, `A deliberately long task title to inspect elision` 11:00, and **`[R019 LONGTASK]` 11:00 (R124)**. **R107: the per-column all-day capacity in the fixture is {0, 3}.** **R115: `date 2026-10-15` is the M04 fixture.** **R121: the 4 task lists live in `profile/pim/metadata.json` (`revision 31`)** — renaming one there + relaunch is the supported long-name fixture. **R124: the VEVENT list is NOT the fixture's item list at a time slot — check VTODOs too.** **R128: THE WEEK STARTS ON MONDAY — on the 2026-04-02 week, Mon 30 (272), Tue 31, Wed 1, Thu 2 (629..747), Fri 3, Sat 4, Sun 5; Sun is the empty all-day column.**

## Next round (pick ONLY #1)
**#1 — style the dark-leg `ToolTip` (the R134 root cause: Qt Basic leaking).** Fix in the smallest atomic way: the panel is `Basic/ToolTip.qml` verbatim, so give the four Main.qml sites (and the three siblings that declare a `delay`) a themed tooltip — either a shared `component KosToolTip : ToolTip` with `background: Rectangle { color: …; radius: … }` + `contentItem: Label { color: … }` wired through `ToolTip.toolTip`, or a palette override. Target on **dark**: panel = a dark elevated surface (NOT white), ink = `labelPrimary`; on **light**: keep it light. **Radius: the ref has NO tooltip at all** (R063: no popover/menu/tooltip/hover frame) ⇒ the radius is a free G-class choice — pick one, write it down, and keep BOTH legs consistent. Re-measure with the R134 recipe (park, record, hover, pad with `none`) and accept on the panel's fill against its plane, on both legs.
**#2 — the released-rim open reading (R132).** Through s ≈ 0.571 the dark released rim reads ≈144 true, between rest 132 and hover 169, still drifting up f0034-f0040. Test the hypothesis "the opened dialog takes focus ⇒ `hovered` false ⇒ the rim decays to rest while the lens-sampled face does not follow" — by reading `hovered` directly via `inspectGeometry`/`pointerObject` instead of inferring it. **Its own round.**
**#3 — the final full light+dark regression sweep**, then the `DONE` line **only if** every ID holds. As of R134 the sweep still cannot end in `DONE`: E02's two font clauses are FAIL and ruling-blocked, and **the ruling-blocked list below is untouched**.
**#4 — the ruling-blocked list (NO channel exists anywhere in the tree; do not invent one):** the **chip-height model (E02's title 11–12 + secondary 10–11 vs T01's two chips per cell)** — the headline, exhibit = the 11:00 double; the **E01/E02 inset-and-stripe scale convention (G-class)**; the **4th `Year` segment**; **H = the band chip's ring icon**; **F = 12-hour two-tone gutter labels**; **A = the dim's snap**; **B = shadow magnitude**; **D = the month cell's `slice(0, 2)`**; **E/C = popover `CloseOnEscape` + E03 clause 3**; **G = A01's spec literals (gap 2, inset 2-3) vs the ref's measured 1**; **plus R134's new one: the ToolTip's pan-leg radius/ink spec is undefined — the ref has no tooltip, so it needs a token ruling (or an explicit "ours, documented" decision).** Report the list, do not act on it.
**Chain status: A01/A02/A04 BOTH legs (R106/R107 light, R128 dark) — both sweeps COMPLETE. T01/T02/T03 BOTH legs (R111/R113). M01/M02/M03 BOTH legs (R112/R114). A03 both clauses both legs (R108-R110). M04 all three halves (R116/R117/R115). S02/S03/S05 + C01-C04/C06 BOTH legs (R121/R122 light, R126 dark). E01 BOTH legs (R124/R125 4/4 each); E02 1/4 PASS on both legs + 1 off-by-one + 2 ruling-blocked. L01/L02/L04/L06/L07 re-read PASS dark R125; L03 5/5 BOTH legs (light R105, dark R127); L05 CLOSED (channel R129, frames R130); C05 CLOSED ON BOTH LEGS (pointer R131, hover dark R132, hover light R133).**
**`code-writer` is STILL not registered in this session (do not retry it each round).** R097 used `general-purpose` as the stand-in implementer; **R098-R134 were done inline.**
**The binary is the R132 build (`Main.qml:828-839` fix). The LIVE instance is now 216298 (DARK, sidebar collapsed, `--view week --date 2026-10-15`). Nothing rebuilt since R132 — so the tooltip fix in Next #1 WILL need a rebuild + kill + relaunch.**
**Not `DONE` — all spec IDs do not pass.** (**A01/A02/A04 PASS both legs; L03 PASS both legs; A03 PASS both clauses, both legs; T01/T02/T03 PASS BOTH legs; M01/M02/M03 PASS BOTH legs; M04 PASS all three halves; S02/S03/S05 PASS BOTH legs; C01-C04/C06 PASS BOTH legs; L01/L02/L04/L06/L07 PASS dark; **L05 PASS (R129 channel + R130 frames)**; **E01 PASS 4/4 BOTH legs**; **E02** column gap PASS both legs, inset off-by-one, both font clauses FAIL (ruling-blocked); **N02 closed on both legs (R085)**; **S01 + S04 MEASURED R096**; **C05 PASS BOTH LEGS** (press +0.38 px, release 0.01 px, hover α ×1.632 dark / ×1.12-saturating light), and the label COUNT stays ruling-blocked.)

## R135 (2026-10-17) — ToolTip themed; C05(b) CLOSED on both legs
Atomic step: Next #1 of R134 — style the dark-leg ToolTip (Qt Basic leaking). Accept on panel fill vs plane, both legs.
- **THE FIX (found in the working tree, from a crashed prior round; verified this round).** `Main.qml:17-27`: window-level palette override `palette.toolTipBase: root.tahoeDark ? "#3C3C3C" : "#F2F2F2"`, `palette.toolTipText: root.tahoe.labelPrimary`. Dark panel = the tahoe elevated lift (#3C3C3C over #1E1E1E); light panel = one step below the white plane; ink = labelPrimary both legs. **Radius stays Basic's 0 (square) — the ref has NO tooltip (R063), so the choice is ours and is recorded in the source comment.** Atomic: window palette roles touch ONLY the two ToolTip slots (Basic uses `toolTipBase`/`toolTipText` nowhere else), so all seven sites (4 Main.qml + KosWindowControls/KosSidebarToggle/LiquidNavBar) are themed with two lines and no per-site component.
- **BUILD.** Binary newer than Main.qml (09:40 > 09:39) — the crashed round had already built; `ninja` reports no work to do. **THE LAUNCH.** Old instance killed; relaunched dark = 778644 (`KOS_APPEARANCE=dark`).
- **EVIDENCE REUSE.** The crashed round's records were found on disk, both on the fixed binary: dark batch `r135-dark-*.png` 117 frames 09:42 + `r135b-dark-final.png`; light batch `r135b-light-*.png` 110 frames 13:12 + `r135b-light-final.png`. Binary unchanged since ⇒ valid measurements. This round ran no new record (my own batch write failed on a stale `cd` and was NOT re-issued — the reuse is complete for the fill acceptance).
- **DARK PASS.** Panel fill **(60,60,60) = #3C3C3C** on plane (30,30,30) — dark elevated, NOT white; ink **(242,242,242) = labelPrimary**; border (53,54,55) = palette.dark (Basic's own). Fill y68..95 = 28 (same as R134); fill x26..97 = 72 (R134 read 67 incl. border; the crop confirms one text "Add event", no layout change — the R134 width read is the disputed one, not this build's). Corners square, panel below the button (unchanged). 5× crop `r135-crop-dark-panel-5x.png`.
- **LIGHT PASS.** Fill **(242,242,242) = #F2F2F2** on plane 255; ink **(0,0,0)**; border (53,54,55). 5× crop `r135-crop-light-panel-5x.png`. Both legs consistent (same geometry, per-leg colours only).
- **ONSET NOT RE-JUDGED.** In the reused dark batch the region-mean jumps 55.4 → 69.6 at f114/117 — the panel appears only in the tail, i.e. the crashed round's batch ordering differed from R134's recipe (move issued late). Presence is proved by the final captures; the ≈0-delay / real-delay question stays under R134's caveat (programmatic `hovered` cannot prove a declared delay anyway).
- **VERDICT: C05(b) CLOSED on both legs.** The un-themed framework default is replaced by a documented, per-leg themed panel. No timeout/change of position/size beyond the R134 notes.
- Note for next sweep: the two palette lines are the ONLY source change since the R132 build; regression risk is confined to consumers of `palette.toolTipBase`/`toolTipText` (ToolTip only).

## R135 (2026-10-17) — ToolTip themed on BOTH legs (Next #1 of R134)
- **Tree audit first.** state.md recorded "no source change since R132", but the tree held an uncommitted `Main.qml:17-27` edit (comment + `palette.toolTipBase: tahoeDark ? "#3C3C3C" : "#F2F2F2"`, `palette.toolTipText: tahoe.labelPrimary`) from a crashed R135 attempt; binary mtime 09:40 > Main.qml 09:39, `ninja` up-to-date, and 190 orphan `r135-*-*.png` frames (3 MB each, relative capture path ⇒ repo root — deleted) betrayed it. Conclusion: the fix was already built; this round verified it instead of editing again.
- **Record.** Dark 924322 → kill → light 937566 (launcher relaunch, `KOS_APPEARANCE` read off /proc/<pid>/environ both times). Batch per leg: resize 1100×692 · sidebar false · view week · date 2026-10-15 · pointer(600,400,move) park · pointerObject toolbarAdd move · 2× none · captureClient (ABSOLUTE) ⇒ `r136-dark-tooltip.png` / `r136-light-tooltip.png`.
- **DARK PASS:** interior fill (60,60,60) = **#3C3C3C exact** (1364/1416 px), plane (30,30,30), ink brightest (241,240,240) ≈ **#F2F2F2**, corners square (left edge x26 constant rows 68..75 ⇒ **radius 0**, the choice declared in the comment — the ref has no tooltip, R063).
- **LIGHT PASS:** fill (242,242,242) = **#F2F2F2 exact** on plane 255, ink darkest (0,0,0), hairline border (53,54,55) = palette.dark, corners square (left x25).
- **Geometry byte-equal both legs:** fill x26..97 (72 w) × y68..95 (28 h), centre x61.5 ≈ button centre 62, top 68 = button bottom 64 + 4 ⇒ **still BELOW the button** — R134's y-discrepancy (Basic declares `y: -implicitHeight − 3`, above) remains OPEN; theming was never going to move it.
- **Mechanism note:** two window-level palette slots themed all four Main.qml attached sites + KosWindowControls/KosSidebarToggle/LiquidNavBar at once — no component, no `ToolTip.toolTip` rewiring. Onset/timeout not re-measured (R134's, and the programmatic-`hovered` caveat stands).
- Figures: `docs/ui-calendar/r135-dark-tooltip-5x.png`, `r135-light-tooltip-5x.png`. C05's ToolTip clause CLOSED; C05 now has only the ruling-blocked label COUNT left.

## R136 — released-rim SETTLED by direct read: the dialog steals `hovered`; no source, no build.
- **Atomic step:** Next #1 of R135 — read `hovered` directly instead of inferring it from the rim pixels.
- **Channel:** action **`pointer`** with `target: <objectName>` logs `hover` and `down` after driving (`harness/Main.qml:193`). `pointerObject` calls the same `pointerDriver.pointer` but logs only the found-point — it canNOT read state. Both land the same event; only `pointer` echoes the control.
- **Protocol (light 937566, no relaunch, no rebuild):** `pointer(toolbarAdd,move)` → log `hover true down false` · `pointerObject(toolbarAdd,press)` · `pointerObject(toolbarAdd,release)` ⇒ dialog + scrim · `none` ×2 (~1.2 s) · `pointer(toolbarAdd,move)` → log **`hover false down false`** · `captureClient r136-release-hover.png` · `escape` · `captureClient r136-after-escape.png`.
- **The read:** the SAME move at (62,50) reads `hover true` pre-release and `hover false` 1.2 s after it — the modal blocks the toolbar's hover; the event no longer reaches the button.
- **Rim consequence (light, scrim settled ×0.80):** rim x49 **201** vs rest-prediction 251×0.80 = **200.8** (hover would be 203.2, 2 levels off); face x51 **180** vs 227×0.80 = 181.6 ⇒ **rim AT REST** — with `hovered` false the hover boost decays while the dialog is up.
- **After `escape`:** plane 255, face 227 (rest), rim x49 **254** (light hover ceiling) — hover RESTORED for the parked cursor with no further move ⇒ the false→true flip is purely the modal block disappearing.
- **R132's dark "released rim ≈144 true, drifting up f0034-f0040" is explained:** with hovered=false from the release, the rim's true value must fall 171 → 132; ≈144 sits on that path (mid-decay). Remaining loose end: the DARK rim's SETTLED value under the scrim (predict ≈75.4 observed) — Next #1.
- **No source change, no build.** Live instance kept (light 937566, sidebar collapsed, week, 2026-10-15); dialog closed before收工.

## R137 — dark rim under the scrim settles at REST; released-rim item FULLY CLOSED both legs. No source, no build.
- **Atomic step:** Next #1 of R136 — measure the DARK rim's settled value under the dialog scrim (the last loose end).
- **Relaunch:** killed light 937566 → launcher relaunch dark = **969763** (`KOS_APPEARANCE=dark` off /proc/969763/environ). Re-issued resize 1100×692 · sidebar collapsed · view week · date 2026-10-15 (the launcher resets them).
- **Protocol:** `pointer(toolbarAdd,move)` → log `hover true down false` · `pointerObject` press + release ⇒ new-event dialog · `none` ×2 (~1.2 s settle) · `pointer(toolbarAdd,move)` → log **`hover false down false`** (the modal steals hover, re-proven on dark) · `captureClient` ABSOLUTE ⇒ `r137-dark-released-scrim.png` · `escape` → log `hover true` (restored, parked cursor never moved).
- **The read (row y50):** plane x45-47 = **17 = 30×0.571** ✓ scrim settled · rim x49 = **78/79/80** · face x51 = **54-55** · glyph ink 103–133. 5× crop `r137-crop-5x.png`.
- **Arithmetic:** rim 78 vs **rest-prediction 132×0.571 = 75.4 (Δ+2.6)** vs hover-prediction 169×0.571 = 96.5 (Δ−18.5); face 54.5 vs rest 89×0.571 = 50.8 (Δ+3.7) vs hover 106×0.571 = 60.5 (Δ−6). **Both metrics sit on REST** — the same verdict R136 reached on light (201 = 251×0.80 within 0.5).
- **The +2.6/+3.7 offset is compositing, not hover:** the scrim dims a lens-sampled semi-transparent layer stack, so the dimmed pixel is not an exact ×0.571 of the undimmed one; the deviation's sign and magnitude class match R136's light leg (within 1.6 there).
- **VERDICT: the rim follows `hovered` — it decays to rest while the modal is up and snaps back when it closes. CLOSED on dark (R137) and light (R136).** R132's "≈144 true drifting up" stands explained as mid-decay on the 171→132 path. The released-rim item has no remaining clause.
- **No source change, no build.** Live instance left dark 969763, sidebar collapsed, week, 2026-10-15, dialog closed.

## R138 — FINAL TWO-LEG REGRESSION SWEEP PASS; itemColor drift found, bounded to DATA. No source, no build.
- **Atomic step:** Next #1 of R137 — the final full light+dark regression sweep.
- **Relaunch:** live 969763 dead → dark 986811, then light 1004321. `KOS_APPEARANCE` verified off /proc. Harness gotcha re-learned: `view`/`date` are the ONLY valid keys (`harness/Main.qml:217-223`); `{"name":…}`/`{"value":…}` silently land `viewIndex = −1` = MONTH view.
- **DARK (986811, week, 2026-04-02, sidebar expanded):** sidebar (40,40,40)✓ field (30,30,30)✓ seps 272/629 (59,59,59)✓ sectionRule y155 39✓ allDaySeparator 232/233 (84,84,84)✓ grid top 234 59✓ weekend 37✓. Band = merged Mon–Wed + Thu `Design sync`/`Release notes` + `+2` overflow no-fill + Fri `R087 sole` + Sun empty; 11:00 double = `Long review…` + green `[R019 LONG TASK]`; mini Apr 2026 day-2 disc; segment lens on 周. Timed fill (41,82,103), all-day (40,76,95), stripe (61,174,233).
- **LIGHT (1004321):** sidebar 228✓ field 255✓ sep 237✓ band sep 217✓ rule 242✓ grid 237✓ weekend 249✓; timed (219,240,251), all-day (222,241,251), stripe (61,174,233).
- **FINDING:** dark timed = 0.36·(61,174,233)+0.64·(30,30,30) EXACT; dark all-day 0.32 = (40,76,95) EXACT; light 0.19/0.17 EXACT. itemColor drifted (48,140,198)→(61,174,233); ICS mtime Oct 17 01:55, metadata 04:50 (post R125/R128); `git diff` clean ⇒ DATA change, math unchanged.
- **VERDICT: sweep PASS both legs; every closed ID holds; NOT DONE** (E02 fonts + ruling-blocked list). `r138-dark-week.png` / `r138-light-week.png` / `r138-dark-crops.png`.

## R139 (2026-10-17) — itemColor-drift PROVENANCE SETTLED: the HOST's Breeze SystemPalette.highlight. (61,174,233) BLESSED. No source, no build, no screenshot.
- **Atomic step:** Next #1 of R138 — find which round rewrote `profile/pim/` and decide bless vs restore.
- **The fixture is exonerated.** `calendar.ics` carries NO colour data at all (no CATEGORIES/COLOR lines — grep empty). `metadata.json`'s 4 list colours = PimStore defaults `#4f8cff`/`#39c487` (`PimStore.cpp:139/145`) + the two fixture lists Gold `#d7a62c` / Red `#e35c56` — **no #3DAEE9 anywhere in the fixture**. Both mtimes are the APP re-persisting its own store each run (metadata revision 31; `kos-calendar.conf` rewritten today 14:50 by R138's runs). No round edited the data.
- **The code path.** Event chips (non-todos) → `Main.qml:1403` itemColor → `AppTheme.accent`. accentName = **"system"** (`ApplicationPreferences.cpp:87-90`; no KOS_ACCENT, no `Appearance/accent` key in the review profile) → `shared/qml/foundation/AppTheme.qml:80` `systemAccent` = `SystemPalette.highlight` = the HOST platform theme's highlight. `grep -rn 3DAEE9` over the tree: ZERO hits — the colour never lived in our code.
- **The host.** `/usr/share/color-schemes/BreezeLight.colors`: DecorationFocus / DecorationHover / ForegroundActive = **61,174,233** — exact. (48,140,198) was the host palette as resolved at R125/R128; the host's colour scheme changed underneath between sessions. The 01:55/04:50 mtimes were correlation, not causation.
- **DECISION: (61,174,233) BLESSED** as the chip base colour; nothing restored. R138's per-channel blend solutions (all EXACT on both legs) stand unmodified. Load-bearing rule added: an event's itemColor is ENVIRONMENT-derived — never pin it as a constant; back-solve the base per sweep and read a cross-leg-consistent shift as a palette change, not a regression.
- **No source change, no build, no screenshot** — provenance round; the R138 sweep's measurements are untouched.

## R140 (2026-10-17) — RULING-BLOCKED LIST REPORTED AND STOPPED. No source, no build, no screenshot.
- **Atomic step:** Next #1 of R139 — report the ruling-blocked list, do not act on it (no ruling channel exists anywhere in the tree; verified R138/R139, not re-invented this round).
- **The full list (11 items, in the state.md visual-impact order), delivered verbatim:**
  1. **CHIP-HEIGHT MODEL** — E02: the timed chip's text block (title 11–12 medium, secondary 10–11) vs ours 9 px, no secondary line. Root cause is chip height 16 on a 40 px hour (0.40) vs the ref's 26 on 27 (0.96), colliding with T01's two-chips-per-cell. Needs a ruling on how tall a chip may be before T01 breaks.
  2. **INSET-AND-STRIPE SCALE CONVENTION (G-class)** — inset 3 vs E02's "about 4"; stripe 4 vs E01's "2–3". One scale ruling settles both.
  3. **BAND CHIP'S RING ICON (ruling H)** — the ref's all-day chips carry a 12×12 ring, stroke 3, hole 6, 3 px inside; ours have none.
  4. **GUTTER LABELS (ruling F)** — the ref is 12-hour two-tone; ours is single-size 24-hour.
  5. **MONTH DAY CELL (ruling D)** — `slice(0, 2)` renders 1 chip + `N`; the ref stacks 3.
  6. **DIM SNAP + SHADOW (rulings A and B)** — the scrim snaps while the card animates (`KosWorkspaceDialog.qml:24-27`); D03 shadow magnitude. Both app-wide.
  7. **FOURTH SEGMENT WORD + C05 LABEL COUNT** — the ref's segment carries `Year`; C05's spec pins 3 labels. Both ruling-blocked.
  8. **POPPERS + A01 + TOOLTIP Y** — E/C: popover `CloseOnEscape` + E03 clause 3; G: A01's spec literals vs the ref's measured 1; R134's ToolTip y-discrepancy (theming settled, position 4 px low, open).
- **No action taken on any item.** code-writer is still not registered; no build was warranted (nothing to implement).
- **No source change, no build, no screenshot.** State.md rotated: R139 moved here, Next round now the stop/idle condition.

## R141 (2026-10-17) — re-verify CLOSED id: the timed chip's radius 3 (R124) — PASS, light leg
- Per Next #1 (sweep complete, all else ruling-blocked): picked one CLOSED id and re-verified on ONE leg with a single screenshot. **Light leg, fresh relaunch.**
- Harness notes: relaunched after killing the live instance; first batch used the WRONG keys (`value` instead of `view`/`date`, `value` instead of boolean `expanded`) ⇒ landed on MONTH/Oct view — re-issued with `{"action":"view","view":"week"},{"action":"date","date":"2026-04-02"}` and the capture was correct. (Reconfirms R138's silent-wrong-key rule: wrong key = ignored/stale state, READ THE CAPTURE.)
- **Measurement (r141-light-week.png):** Thu 08:00 chip fill **x632..743 (112 w) × y317..332 (16 h)** — byte-consistent with the pinned map. Corner mask (fill = b>240 ∧ b−r>15 ∧ g>225): top row (y317) first fill **x633**, second row (y318) **x632**; stripe reads as a 4-px hole at **x636..639** (stripe itemColor (61,174,233) fails the b>240 threshold — an independent confirmation of the stripe's position/width). 12× crop `r141-chip-corner-12x.png` shows the rounded cut visually.
- **Radius analysis:** radius 3 predicts top-row fill boundary at x633.3 and row-2 at x632.4 (observed 633/632 within AA); radius 5 would start at x635, radius 1 at x632 flat. ⇒ **radius 3 CONFIRMED, not 5, not 0. R124 re-verified PASS.**
- **No source change, no build.** One screenshot, one leg. code-writer still not registered (nothing to implement).

## R142 (calendar) — re-verified CLOSED id R128 (all-day band y-map + separator tones), LIGHT leg
- Fresh relaunch, light. Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r142-alldayband-light.png`. (Relaunch cost one self-inflicted detour: command.json was overwritten with a bare list, breaking review-command.py's `['sequence']+1` counter — restored base 5000; harness requires strictly increasing sequence.)
- Column scan x=225 (y145..249): sectionRule y=155 (242,242,242) · allDaySeparator y=232-233 (217,217,217) — nothing else non-white.
- Rows 229..239 at x=400/640/1000/1090: grid top rule y=234 (237,237,237) on ALL columns; weekend Sun (x1000/1090) plane 249 on both sides of the rules — matches pinned.
- 3-row interior 156..231 = 76 = 1+25N (N=3). Crop `r142-band-2x.png` shows rule/chips/+2 layout.
- **PASS — R128 light leg byte-consistent with pinned (242 / 217 / 237 / weekend 249). No source change, no build.** Archived from state.md: R131 line (see R132 entry context).

## R143 — RE-VERIFIED CLOSED ID R097/R127 (segment control, light leg) — PASS, byte-consistent
- Atomic step: Next #1 — re-verify ONE closed id on one leg, single screenshot: **the segment control, light leg** (R124 done R141, R128 done R142).
- Detour: `harness/command.json` had been hand-clobbered with a bare list (again) ⇒ review-command.py crashed (`list indices must be integers`); re-seeded `{"sequence":0,"action":"none"}` then drove via argv. **Rule: NEVER hand-write command.json — only review-command.py argv.**
- Light leg, fresh relaunch. Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r143-segment-light.png`.
- Measurements (y=50 scan + x=660 vertical):
  - Track **x562..757** exact (pinned 562..757); band **y36..63** (edges 224/223) exact.
  - Track tone **250** ✓; track rim **222** (x562/x757 = 222,224,227) ✓; lens **232** ✓; lens rim **233** (vertical y40; horizontal lens column x630..689 = 60 w, rims x630/x689) ✓.
  - Label ink cores **8 / 0 / 12** (day 8 @599,54 · week 0 @656,51 · month 12 @727,51) — pinned 8/0/12 exact ✓.
  - Ink centres ~595.5 / 659.5 / 723 ✓. Lens sits on 周 (week) ✓.
- 4x crop `r143-segment-4x.png` visually confirms track pill + lens + rims.
- **PASS — R097/R127 light leg byte-consistent with pinned. No source change, no build.**
- *(Archived from state.md R143: R135 — verified the crashed round's edit. `Main.qml:23-27` window palette: `toolTipBase` #3C3C3C dark / #F2F2F2 light, `toolTipText` = `tahoe.labelPrimary`. Both legs byte-equal geometry x26..97 × y68..95.)*

## R144 — re-verify CLOSED M-group (mini month selected disc), light leg — PASS, byte-consistent
- Light leg, fresh relaunch (start script >180 s → backgrounded; app confirmed alive before driving). resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r144-minidisc-light.png`.
- Disc: **x101..118 × y556..573 = 18×18 exact**, centre (109.5, 564.5), centred in the Thu column (cells 96..124). Row profile 8/12/14/16/16/18×8/16/16/14/12/8 = true circle, radius 9. Face **(142,142,147) = #8E8E93 exact** (pinned `selectionDisc`). White digit inside; row 1 = Mar30–Apr5, disc on Apr 2. 4x crop `r144-minirow-4x.png` visually confirms header 一二三四五六日 + 30 31 1 **[2]** 3 4 5.
- **PASS — byte-consistent with pinned R115/R117. No source change, no build.**
- Observation (no action): disc centre y 564.5 does not reconcile with the pinned date-band tops (545 then 561/582…); flagged in state.md for a future band-top re-verify. Not opened as an item.

## R147 — re-verify CLOSED M-group (mini month date-band tops), light leg — PASS, pinned reconciled; R144's flagged conflict RESOLVED
- Rounds R145/R146 errored out before any output (`.loop/iter-145/146.err` = unrecognized_model, status 0) — no results were recorded; this round = 147. Tree audited (`git status` on apps/ clean) before proceeding; measurement-only round, no edits to audit.
- Atomic step: Next #1 — re-verify ONE closed id on one leg, single screenshot: **the mini month's date-band tops (pinned 545 then 561/582/603/624/645/666/688), light leg** — the exact item R144 flagged as irreconcilable with the disc centre.
- Light leg, fresh relaunch (>60 s; backgrounded, confirmed alive pid 1113069). Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r147-minimonth-light.png`.
- Measurement (dark-ink row profile, x12..208; thr180 run list): (519,531) heading · **(541,548) weekday header** · (556,573) = the selected disc (18 tall) + row-1 digits · **(582,589) (603,610) (624,631) (645,652) (666,673) (686,691)** = rows 2-7 ink.
- **Date-row digit-ink tops = 561, 582, 603, 624, 645, 666, 686/687 — pitch 21 exact.** Pinned 561/582/603/624/645/666 reproduce EXACTLY; the 7th (pinned 688) reads 686-687 within AA and is clipped by the 692-tall window.
- **The pinned "545" is the weekday-header ink CENTRE (541..548 → 544.5), NOT a date-row top.** ⇒ the pinned list is internally consistent as [weekday-header centre; seven digit-ink tops].
- **R144's conflict RESOLVED — bookkeeping units, not geometry:** "date-band tops" are digit-ink tops, not cell tops. Row-1 cell top ≈ 554.5 (ink top 561 − (21−8)/2); the 18×18 disc (556..573) is centred on row-1's ink — disc centre 564.5 = ink centre (561+568)/2 = 564.5. No discrepancy remains.
- Side observation (no action): the grid renders **7 date rows** (Mar 30 … May 17); the 7th (May 11-17, all adjacent-month muted) is clipped at the window bottom — visible only as a sliver. The pinned 7-top list is therefore complete, not spurious.
- 3x crop `r147-minimonth-crop-3x.png` visually confirms: heading 2026年4月, header 一二三四五六日, rows 30 31 1 **[2]** 3 4 5 … 27 28 29 30 1 2 3, muted 4-10 tail.
- **PASS — byte-consistent with pinned; M-group band-top bookkeeping closed. No source change, no build.** code-writer still not registered (nothing to implement).
- *(Archived from state.md 最近已改: R137 — released-rim under dialog scrim settled at REST both legs; item CLOSED.)*

## R148 — re-verify CLOSED T-group (timed-chip y-map, 2026-04-02 Thu), light leg — PASS
- Atomic step: Next #1 — the T-group chip y-map (pinned 08:00 317-332 · 09:00 357-372 · 10:00 397-412 · 11:00 437-452+455-470 · 12:00 477-492 · 14:00 557-572), light leg, single capture.
- Light leg, fresh relaunch (pid 1133943). Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r148-tchips-light.png`.
- **Method lesson: the WTODO chips render their own hues (green 57,196,135 / gold 215,166,44), so a blue-only tone filter silently drops 09:00 and 12:00.** Colour-agnostic scan instead: stripe column x637 (avoids text), "non-white" threshold — fill tones sum ≥33 of 765, white 0, thr 25.
- Measured fill runs at x637 thr25: **(317,332) (357,372) (397,412) (437,452) (454,470) (477,492) (557,572)** — all 7 pinned chips reproduce; only 11:00-second top reads 454 vs pinned 455 (1 px, AA). Pitch 40 exact.
- Extra run **(637,652) = 16:00 `[UI] Red review` WTODO**, pitch-consistent (557+80); not a regression, absent from the pinned list because the pinned list predates… simply enumerates the anchor chips.
- Stripe runs (thr 90) sit 2 px inside each fill (319..330 …) = the stripe's vertical inset within the 16-h chip; the stripe column x636..639 (R123) confirmed at (61,174,233) for the blue chips.
- 2x crop `r148-tchips-crop-2x.png` visually confirms the stack: Morning planning / [UI] Green planning / Short appointment / Long review with a d… + [R019 LONG TASK] / [UI] Gold review / Design review (14:00) / [UI] Red review (16:00).
- **PASS — T-group y-map closed byte-consistent with pinned. No source change, no build.** code-writer still not registered (nothing to implement).

## R149 — re-verify CLOSED S-group (sidebar category list S02/S03), light leg — PASS
- Atomic step: Next #1 — the S-group sidebar category list (S02/S03: Today row 44 tall + 1 px separator; heading font 11 / left 12; CategoryRow pitch 30, box 12×12 at x12..23 radius 3, label 13 at left 32), light leg, single capture.
- Light leg, fresh relaunch (start script timed out at 120 s → backgrounded; app confirmed alive pid 1152756 before driving). Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r149-sgroup-light.png`.
- **Layout (3x crops `r149-todayrow-3x.png`, `r149-sidebar-3x.png`):** mini-month nav at top → **Today row** (blue disc 12×12 x40..51 y86..97 + 今天 ink x72..99 y86..98, 13 tall + muted 周六 right-aligned ink x167..196 y86..99) → **separator y117 = 1 px (200,200,200) spanning x0..219** → heading `Calendars` (ink x13..62 y141..148, 8 tall) → 日程 / 计划任务 (checked, blue/green) → indented 显示已完成 row (orange outline ~x36..49 y228..239 12×12, label ink x57..119 y228..239) → heading `Task lists` (ink x12..56 y269..276, 8 tall) → Inbox / Personal / UI Review Gold / UI Review Red.
- **Pinned values all reproduce:** separator 1 px ✓; Today row 44 tall (73..116) ✓; both headings 8-tall ink = font 11, left 12-13 (AA of 12) ✓; **CategoryRow pitch 30 exact** (168→198; 296→326→356→386) ✓; **box 12×12 at x12..23** (rows 296..307 = 12 tall) ✓; **radius 3** — corner profile top row x14=243/x15=249/x16..21=255 AA ramp, 1 px inset at dy=1, matches the R141 timed-chip radius-3 signature ✓; **label 13 at left 32** — Inbox ink x33..65 y297..306 (ink left 33 = AA of nominal 32, gap 8 from box right 23) ✓. Group gap consistent: heading ink bottom → first box top = 20 in BOTH groups (148→168, 276→296).
- Box colours (0,136,255)/(52,199,89) vs Task-list (79,140,255)/(57,196,135)/gold/red = fixture category hues, env-derived — not pinned per R139/R148.
- **PASS — S02/S03 byte-consistent with pinned. No source change, no build.** code-writer still not registered (nothing to implement).

## R150 — re-verify CLOSED all-day BAND chip envelope, light leg — PASS, byte-consistent
- Atomic step: Next #1 — re-verify ONE closed id on one leg, single screenshot: **the all-day band chip envelope (pinned merged Mon–Wed 274..625 · Thu `Design sync` 631..744 · Fri `R087 sole` 750..863 · Sun empty · chip 116 px in 119 inset 1 · fill light (222,241,251)), light leg**.
- Light leg, fresh relaunch (start script hit its 120 s timeout as known; confirmed alive pid 1178813). Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r150-band-light.png`.
- Measurement, colour-agnostic first (non-white coverage ≥4 rows over y156..181) then EXACT fill tone (222,241,251) per row: at the clean row **y=175 the exact-fill runs are (274,625) / (631,744) / (750,863) — ALL THREE pinned envelopes reproduce byte-consistently.** Edge pixels: x272/x629/x748 = (237,237,237) AA shoulder, fill starts next px; fill ends 625/744/863, x627/746/865 pure white ⇒ inset 1 from the 272/629/748 separators holds. Fill tone (222,241,251) exact at y158/160/168/175.
- Row-1-only confirmation at clean columns: x400 (merged) and x800 (Fri) fill 157..180 only (24 tall), white 181..231; band rules present at x700: sectionRule y155 (242,242,242) · allDaySeparator y232 (217,217,217) · grid top rule y234 (237,237,237) — all three pinned tones in place.
- NOTE (not a conflict): at x700 (Thu) a SECOND fill row 182..205 exists = `Release notes` (all-day 20260402) on band row 2; the pinned envelope list describes row 1 (y156..181). Sat 867..984 / Sun 986..1099 carry no chip (only the 249 weekend field) ⇒ Sun EMPTY holds.
- **PASS — envelope closed byte-consistent. No source change, no build.** Figures `docs/ui-calendar/round-150.png`, `round-150-band-2x.png`.

## R151 — re-verify CLOSED M-group (mini-month heading: title ink + chevrons), light leg — PASS
- Atomic step: Next #1 — re-verify ONE closed id on one leg, single screenshot: **the mini-month heading — title `2026年4月` ink + the two chevron buttons (pinned: title font 13 DemiBold / ink 0/255; buttons 28×28 at centres 26/194; arrow ink 5×9–10 at x23..27 / x191..196 tone (156,156,156)), light leg**.
- Light leg, fresh relaunch (pid 1198313? — recorded 1198312; launcher wrapper exited 124 at its 150 s timeout = the known behaviour, app confirmed alive before driving). Commands: resize 1100x692 / sidebar expand / view week / date 2026-04-02 / capture `r151-minimonth-light.png`.
- **Title: dark-ink row profile (x12..208, thr180) gives the title band (519,531) = 13 tall — font 13 DemiBold ✓ — and the weekday header (541,548) reproduced as context.** Title ink columns (thr<100) = **x79..138**, darkest tone **(0,0,0) pure black on the 255 field — pinned ink 0/255 ✓**.
- **Chevrons (ASCII map + tight-tone scan, y510..540 to exclude the muted weekday row):** left `<` ink core **x23..27** (x28 = AA shoulder `.`), rows **519..528 = 10 tall**; right `>` ink **x190..195** (core x191..195), rows **520..528 = 9 tall** — pinned 5×9–10 at x23..27 / x191..196 reproduced **within 1 px AA**. Ink centres (25.5, 523.5) / (192.5, 524) vs pinned button centres 26/194 — AA-level.
- Tone NOTE (not a conflict): the arrows are a 1-px AA stroke — core 114..131, shoulder 150..175. The pinned (156,156,156) sits in the shoulder band = an AA-sampled reading of the same stroke; geometry is what this round pinned, and it holds.
- 4x crop `r151-heading-4x.png` visually confirms: bold black title centred between the two muted chevrons, muted weekday row below.
- **PASS — mini-month heading closed byte-consistent. No source change, no build.** code-writer still not registered (nothing to implement).

## R152 — gutter hour labels right-anchor (R066), light leg — PASS (verification only, no source)
Atomic step: Next #1 — re-verify the gutter hour labels, light leg, single capture.
- Fresh relaunch (light). **Harness change: `timeout 150 ./start-review-vm.sh light` killed the app child with the launcher's process group (pid died; log truncated at QML load). Fix: background-launch the bare script, poll `kill -0 $(cat live-app.pid)` — app stayed alive.** Drive: resize 1100x692 / sidebar expand / view week / date 2026-04-02 → `r152-gutter-light.png`.
- Scan window **x221..270 strictly inside the gutter** (first lesson: chips' ink crosses x272 into column 1 — a wider window pollutes the census with 20-tall blobs).
- **11 labels, ink y270..277 / 310..317 / 350..357 / 390..397 / 430..437 / 470..477 / 510..517 / 550..557 / 590..597 / 630..637 / 670..677.**
- **Right anchor: all 11 ink right edges = x263 byte-consistent** (left 237/238 uniform — zero-padded 24-hour strings equal width). Text rect right = 272 − rightMargin 7 = 265; digit sidebearing insets ink to 263 — consistent.
- **Font 11 ⇒ ink 8 tall ✓; pitch 40 EXACT ✓; tone darkest (113,117,130) = AppTheme.mutedText ✓.**
- Source `CalendarScheduleView.qml:714-720` re-read: `anchors.right: parent.right` (parent.right IS the grid line), `rightMargin: 7`, `font.pixelSize: 11`, zero-padded text, `color: AppTheme.mutedText`. N02 intact: today-less week ⇒ no now-pill ⇒ all labels visible (18:00 clipped off-window).
- 5x crop `r152-gutter-5x.png`: 07:00/08:00 right edges aligned, muted gray single tone.
- **PASS — R066 closed byte-consistent. Next: window dots (R122) light leg.**

## R153 — window dots (R122), light leg — PASS (verification only, no source)
Atomic step: Next #1 — re-verify the three window dots, light leg, single capture (dots are chrome — visible at any view).
- Fresh relaunch (light), **background-launched bare script per the R152 harness note; pid alive after 1 s; drove immediately.** Commands: resize 1100x692 / capture `r153-dots-light.png` (no sidebar/view/date needed).
- **Colour census (top band y0..29, saturation >30): exactly three dots — green x1015..1029, yellow x1043..1057, red x1071..1085; halo rows y10..24. Cores (≥full-sat pixels): green (72,208,93) n129, yellow (254,198,77) n129, red (255,119,112) n129.**
- **Opacity math byte-consistent with the pinned literals @0.85 over a (252,252,252) band: #28c840 → (72,208,93) EXACT; #febc2e → (254,198,77) EXACT; #ff5f57 → (255,119,112) EXACT.** The dots are transmissive (opacity 0.85), so the measured tone is literal×0.85 + band×0.15 — all three land on the measured cores to the last bit.
- **Centres: green 1022 / yellow 1050 / red 1078 (halo midpoints) = pinned 1022.5/1050.5/1078.5 within AA; pitch 28, gaps 28−14 = 14 ✓. Right edge: red halo ends x1085 = 1100 − rightMargin 14.5 ✓. Circle profile symmetric (row widths 3/9/11/15/15/15/17/17/17/15/15/15/11/9/3) = disc 14 + AA ✓.**
- **y-centre CLARIFICATION: measured 17 (halo 10..24). The R122 derivation (topMargin 10.5 + radius 7) gives 17.5 — matches. The R153 task line's "y-centre ≈15" was imprecise; the authoritative pinned figure is topMargin 10.5 ⇒ centre ≈17.5.** No conflict.
- Source re-read `Main.qml:1637-1685`: Row anchored right/top, `rightMargin 14.5`, `topMargin 10.5`, `spacing 14`, model `#28c840`/`#febc2e`/`#ff5f57`, 14×14 radius 7, `opacity: 0.85`. Order green/yellow/red left→right (settings-app order, per R122 not the macOS ref's authority) ✓.
- 6x crop `r153-dots-6x.png` visually confirms: three round dots green/yellow/red on the light band, window corner radius top-right.
- **PASS — R122 window dots closed byte-consistent. Next: toolbar search field (R129/R130) LIGHT leg (only ever measured dark).**

## R154 — toolbar search field, LIGHT leg (R129/R130 re-verify) — PASS
- Atomic step: Next #1. Fresh relaunch (light, background-launch bare, pid alive). Drive: resize 1100x692 / sidebar expand / pointer press+release (1035,50) / capture `r154-search-open.png`.
- **HARNESS GOTCHA (new): the `pointer` action's `kind` only implements `press`/`release`/`move` (`ReviewInput.cpp:74-83`) — `kind:"click"` is a SILENT NO-OP.** Two false starts (captures `r154-search-light.png` / `-b.png` byte-identical toolbar crops, field never opened; log prints `pointer click undefined … hover n/a`) before reading the driver. Correct sequence: press → one `none` → release.
- False-start 1 also produced a red herring: a dark-outlined box x1009..1062 y67..140 = the themed tooltip (fill 242,242,242) under the hovered toggle — expected, R135.
- **GEOMETRY byte-consistent:** field rect x736..1015 = **280 w** × y36..63 = **28 h**; right border inner edge **1016 = pinned right edge** ✓; left border x736 ✓; **capsule radius 14** — corner profile (y36→x746, y37→744, y38→742, y39→741, y40→740, y41→739, y42→738, y44→737) fits an r=14 circle centred (750,50) ✓ (`radius: height/2`); input content ink from **x748 ⇒ leftMargin 12** ✓, right content 1004 ✓.
- **LIGHT tones (first measurement — the field had only ever been measured dark):** face **(210,210,210) = `searchFill` "#D2D2D2" EXACT**; focused border **1 px (0,136,255) = `accent` "#0088FF" EXACT** (`border.width: input.activeFocus ? 1 : 0`); placeholder "Search" ink x748..788 y45..54, tone labelSecondary.
- Source re-read `Main.qml:1817-1925` (toolbarSearch: maxWidth cap 280, anchored right = searchToggle.left − 6, radius height/2, insets 12, focus border accent, deferred-focus timer) + `Main.qml:141-149` (accent #0088FF; searchFill #D2D2D2 light / #3A3A3A dark).
- Crops: `r154-c1.png`, `r154-field-3x.png`, `r154-c4.png`.
- **PASS — R129/R130 search field closed, light leg byte-consistent. No source change, no build.**
- Next: window dots DARK leg (R126 last measured; R153 covered light only).

## R155 — window dots re-verified, DARK leg — PASS (verification only, no source, no build)
- Fresh relaunch dark (background-launch bare; pid 1272871). Drive: resize 1100x692 → capture `r155-dots-dark.png`. Crop `r155-dots-dark-5x.png` (1:1 strip + 5x NEAREST).
- **Cores byte-EXACT: green (38,174,59) / yellow (220,164,44) / red (221,85,78) = #28c840/#febc2e/#ff5f57 @0.85 over band plane (30,30,30) — plane (30,30,30) EXACT.** Matches R126 pinned dark cores exactly.
- **Geometry: row y=17 core runs 1016..1028 / 1044..1056 / 1072..1084 (13 px core, AA shoulder each side ⇒ disc 14); centres x 1022.5 / 1050.5 / 1078.5, pitch 28, gaps 14 ✓. Column core y11..23, shoulders y10/y24 ⇒ y-centre 17.5 — R153's light leg read 17; 1 px AA, not a conflict (R153 itself noted derivation 17.5).**
- Verdict: R122/R126 window dots CLOSED both legs.
- Archived from state.md: R147 entry — "M-group band tops re-verified light leg: PASS; pinned tops 561/582/603/624/645/666/688 reproduced (pitch 21); '545' = weekday-header centre; R144's conflict RESOLVED (units mislabel)."
- Next: segment control DARK leg (R143 covered light only).

## R156 — segment control re-verified, DARK leg — PASS (verification only, no source, no build)
- Fresh relaunch dark (background-launch bare). Drive: resize 1100x692 → capture `r156-segment-dark.png`. Crop `r156-segment-dark-4x.png` (1:1 strip + 4x NEAREST).
- **Track: exterior x562..757 = 196 w (rims 61-62 both ends), y36..63 = 28 h; interior fill 46-47 (pinned 47), vertical ramp 50→42 (col x580: 50…42) = pinned exactly.**
- **Lens: rims x630/x689 (76) ⇒ lens w 60 ✓; fill ramp 76→59 (col x645: 76…59) = pinned; lens rim 76-77 vs pinned 77 ✓.**
- **Label ink peaks: 日 236 / 周 242 / 月 233 — byte-EXACT vs pinned 236/242/233.** Ink 11 tall (y45..55); centres 596 / 660 / 723 (pinned 595.5/659.5/723.0). Note: single-row y50 peaks read lower (222/241/203) — the pinned figures are full-bbox maxima, which is how R097/R127 measured them.
- Verdict: R097/R127 segment control CLOSED both legs (light R143, dark R156).
- Archived from state.md: R154 entry — "Toolbar search field re-verified LIGHT leg: PASS — rect x736..1015 (280 w) × y36..63 (28 h), capsule r14, insets 12, face #D2D2D2 exact, focused border #0088FF exact, placeholder labelSecondary; gotcha: pointer kind:'click' is a silent no-op — use press+release."
- Next: nothing non-blocked remains open; pick the next closed id for re-verification from the R156 state.md list or move to wrap-up.
- Archived from state.md (R156 windowing): R148 entry — "T-group timed-chip y-map re-verified light leg: PASS — all 7 pinned chips reproduce (11:00b 454 vs 455, 1 px AA); extra 16:00 WTODO chip pitch-consistent; per-event colours ⇒ colour-agnostic scan required."

## R157 — mini-month selected disc re-verified, DARK leg — PASS (verification only, no source, no build)
- Fresh relaunch dark (background-launch bare; pid 1290546, environ KOS_APPEARANCE=dark). Drive: resize 1100x692 / sidebar expanded → capture `r157-minidisc-dark.png`. Ledger figure `docs/ui-calendar/r157-minidisc-dark-4x.png` (1:1 strip + 4x NEAREST).
- **Selected disc (Oct 15, Thu col): bbox x101..118 × y598..615 = 18×18 — x-range BYTE-EQUAL to light R144 (x101..118). Face interior (142,142,147) = `selectionDisc` #8E8E93 EXACT (clean samples at (110,613); (103,600)/(116,601) are outside-disc AA).**
- **Circle profile symmetric: row widths 2/8/10/12/14 → 16 core (x102..117, full 18 with AA at rows 606-607) → 14/12/10/8/2 — consistent with the light pinned profile.**
- **Disc centred on digit ink: "15" ink x106..114 y603..610, centre 606.5 = disc centre 606.5 ✓ (disc top 598 = ink top 603 − 5, matching the R144 model). White digits (255) both discs.**
- **Today disc (Oct 17, Sat col): bbox x157..174 × y598..615 = 18×18, face (229,72,77) = `todayRed` EXACT, white digit ink.**
- Verdict: R116/R117 mini discs CLOSED both legs (light R144, dark R157).
- Next: nothing non-blocked remains open; continue re-verifying closed ids on the uncovered leg or wrap up.
- Archived from state.md (R157 windowing): R149 entry — "S-group sidebar list re-verified light leg: PASS — separator/Today row/pitch 30/box 12×12/radius 3/label left 32 all byte-consistent."

## R158 — all-day band y-map + envelope re-verified, DARK leg — PASS (verification only, no source, no build)
- Fresh relaunch dark (background-launch bare; pid 1304330, environ KOS_APPEARANCE=dark). Drive: resize 1100x692 / sidebar expanded / date 2026-04-02 → capture `r158-band-dark.png`. Ledger figures `docs/ui-calendar/r158-band-dark-1x.png` + `r158-band-dark-thu-4x.png`.
- Scroll-state control: Thu timed fills at x700 = 08:00 317-332 / 10:00 397-412 / 11:00 437-452 / 14:00 557-572 — byte-consistent with the R148 y-map ⇒ same contentY as every pinned measurement.
- **Rules: `sectionRule` y155 = (39,39,39) EXACT; 3-row interior 156..231 (row1 fill 157..180, gap 181, row2 182..205, row3 207..230); `allDaySeparator` 232-233 = (84,84,84) EXACT; grid top rule 234 = (59,59,59) weekday / (65,65,65) weekend EXACT.**
- **Envelope (R128/R150 model) at y175, exact-fill scan (40,76,95): (274,625) / (631,744) / (750,863) — BYTE-EXACT to pinned. Thu row 2 `Release notes` fill 631..744 (y200). Sun AND Sat carry no fill in 156..231; weekend plane (37,37,37).**
- **Thu chip fill (40,76,95) = `:589` dark mix for itemColor (61,174,233) EXACT. Overflow `+2` ink bbox x635..645 y215..222 (n=58, subpixel-AA cores), centre y218.5 ≈ pinned 218 — x-range byte-equal.**
- **NEW OBSERVATION (not a regression, previously unrecorded): a clipped "06:00" gutter-label sliver at y234..237, x~230..269 — the 06:00 label (ink 230..237 centred on the top rule 234, `CalendarScheduleView.qml:711-725` text `"0"+rowIndex+":00"`) is mostly covered by the all-day band; its bottom 4 ink rows peek out below the separator. The ref's topmost gutter label (8 AM) sits fully below the band. Never flagged by R066/R152 censuses. Non-blocked; candidate for a future atomic fix.**
- Verdict: R106/R107/R128 band y-map + R128/R150 envelope CLOSED both legs (dark R142 y-map / R142+R158 envelope; light R142+R150).
- Next: the 06:00 gutter sliver is the only non-blocked open item — either fix it (clip/offset the topmost label) or re-verify another closed id.
- Archived from state.md (R158 windowing): R150 entry — "All-day band chip envelope re-verified light leg: PASS — exact-fill runs 274..625 / 631..744 / 750..863 byte-consistent, fill (222,241,251) exact, Sun empty; Thu row 2 = `Release notes`."

## R159 (2026-10-17) — FIXED the clipped "06:00" gutter-label sliver (R158's new finding) — PASS both legs
- Atomic step: Next #1 — fix the sliver: hide the hour label whose line coincides with the grid top rule when the timeline is hour-aligned.
- **Source change (`CalendarScheduleView.qml`, the T03 hour Label's `visible`, was `:725-733` → now `:725-740`): added the clause `hourCell.rowIndex * root.hourHeight > timelineScroll.contentItem.contentY + 0.5` to the existing `visible` condition.** Rationale: `positionTimeline()` always leaves contentY hour-aligned (`usefulStartHour() * 40`, logged contentY 240), so the topmost visible hour line sits ON the grid top rule under the band separator and the flickable `clip: true` slices its straddling label in half — the fragment. The 0.5 absorbs contentY rounding; mid-scroll (non-aligned contentY) the topmost fully-visible line is > contentY so its label is kept; labels fully above the top were already clipped.
- Build: ninja OK (7 targets). Relaunch light (pid 1333029) → drive resize 1100x692 / sidebar expanded / date 2026-04-02 / capture `r159-fix-light.png`. Relaunch dark (pid 1336363) → same drive → `r159-fix-dark.png`.
- **BOTH LEGS PASS.** Top-rule crop (x210..285 × y220..250, 8x): NO glyph fragment below the band separator on either leg; first label now 07:00, fully below the band — matches the ref's topmost-label model.
- **R152 pins re-measured and held: 9 labels 07:00..15:00 in y235..600, ink height 8, pitch 40 exact, right edge x263 (dark byte-equal to R152's pin; light x264 = one more AA shoulder at the looser scan threshold — rightMargin model untouched).** 06:00's absence is the intended fix, not a regression (N02's now-pill clearance logic untouched).
- Ledger figures: `docs/ui-calendar/r159-fix-light.png`, `r159-fix-dark.png`.
- 仍差 shrinks by one: the ONLY non-blocked open item is CLOSED; everything remaining on the list is ruling-blocked (E02 fonts, inset/stripe scale, band-chip icon, gutter 12-hour two-tone, month slice count, dim/shadow, segment 4th word + label count + popover clauses + ToolTip y).
- Next: no non-blocked items remain. Either (a) take a ruling decision from the user on one of the blocked items, or (b) re-verify another closed id on the unverified leg for extra assurance. If nothing actionable: the sweep is complete and only the ruling-blocked list stands — report and hold, do not invent work.
- Archived from state.md (R160 windowing): R152 entry — "Gutter hour labels re-verified light leg: PASS — 11 labels, ink right edge x263 all byte-consistent (rect right 265 = 272−7, sidebearing 2), ink 8 tall, pitch 40 exact, tone mutedText (113,117,130); source :714-720 re-read confirms anchor model. Harness note: launcher now kills the app under timeout — background-launch instead."

## R160 (2026-10-17) — mini-month date-band tops + weekday header re-verified, DARK leg — PASS (verification only, no source, no build)
- Atomic step: Next #1 option (a). The M-group band tops (R147) and weekday header (R151-era) had only ever been measured on the light leg — the last uncovered twin after R155-R159.
- Fresh relaunch dark (background-launch bare; pid 1345557, environ KOS_APPEARANCE=dark). Drive: resize 1100x692 / sidebar expanded → capture `r160-minimonth-dark.png`. Crop x0..220 × y528..692 (1x + 3x NEAREST, single read).
- **Weekday-header ink rows 541..548 — BYTE-EQUAL to the light pin (centre 544.5).**
- **Date-row digit-ink tops 561 / 582 / 624 / 645 / 666 — ALL EXACT, pitch 21 exact.** Row 3's digit run is swallowed by the two 18 px discs (y598..615) — byte-equal to R157's dark disc bbox, expected. Row 7 (adjacent-month sliver at the 692 clip): faint ink, core ~64 over plane (40,40,40), top ~688 — consistent with the light measurement (686-687 AA), not a conflict.
- **New dark tone measurements (first for the band; light tones were never pinned):** weekday-header ink (153,153,153) ≈ #999999; current-month digit ink ~(226,228,230) (AA peaks); adjacent-month ink ~(120,120,120); mini-month plane (40,40,40).
- Verdict: M-group band tops CLOSED both legs (light R147, dark R160).
- Ledger figures: `docs/ui-calendar/r160-minimonth-dark-1x.png`, `r160-minimonth-dark-3x.png`.
- Next: the mini-month heading (R151, light only — month-title ink + chevron tone on dark) is the last known uncovered twin; after that, hold the checkpoint (blocked on a user ruling).

## R161 — mini-month heading re-verified DARK leg (R151 twin) — PASS — last uncovered twin closed; checkpoint held
- Atomic step: Next #1 option (a) — re-verify the mini-month heading (R151 measured light only) on the dark leg. **Verification only, no source, no build.**
- Instance alive from R160 (pid 1345557, dark). Re-drove resize 1100x692 / sidebar expand / view week / date 2026-04-02 → `r161-heading-dark.png`; crop x0..220 × y505..545 (1x + 4x NEAREST, one read).
- **Title: bright-row profile (x12..208, thr>170) = band 519..530, strict core (>200) rows 519..530; light pin was 519..531 (thr180 dark-ink) — within 1 px AA (dark row 531 is zero even at thr>140; the light count included one faint AA row).** Core columns (>200) **x80..139** vs light thr<100 x79..138 — 1 px AA shift, still centred on the button axis (mid 109.5 vs 110).
- **Title ink tone: dark core (242,242,242) — the dark labelPrimary, consistent with R156's segment ink peak 242 and R135's tooltip ink (241,240,240). The pinned "ink 0/255" is the LIGHT-leg literal; per-leg labelPrimary differs by design. Not a conflict.**
- **Chevrons: left `<` ink x23..27, rows 519..528 = 10 tall — EXACT vs pin (5×9–10 at x23..27, rows 519..528). Right `>` ink x191..196, rows 520..528 = 9 tall — EXACT vs pin (core x191..195, rows 520..528; x196 = AA shoulder). Centres (25.5, 523.5)/(193, 524) vs button centres 26/194 — AA-level.** *(First right-chevron scan polluted by the weekday-header row 541..548 ink (153,153,153) inside x180..210 — re-scanned x188..200 bounded y<535.)*
- Chevron tone: 1-px AA stroke, cores (150..173) with peaks (157,157,157)/(173,173,173) — same shoulder-band situation R151 recorded for the light pin (156,156,156); geometry is the pin, and it holds.
- Plane (40,40,40) EXACT = dark sidebar plane. 4x crop `r161-h-4x.png`: white bold title between two muted chevrons on the dark plane, muted weekday row below.
- **PASS — R151's heading closed byte-consistent on the dark leg. With this, EVERY closed spec item now has both legs measured; the sweep is COMPLETE and no non-blocked work remains. Checkpoint: blocked on a user ruling (E02's two font clauses + the 11-item ruling-blocked list, reported R140).**

## R162 — HOLD — no new rulings or spec updates since R161; checkpoint stands (nothing done, no source, no build, no re-verify)
- Atomic step: Next #1 option (b). R161 already spent the session's one allowed idle re-verify; two idle rounds in a row = hold, not loop.
- Ruling check: `spec.md` mtime 2026-10-17 04:56 — predates R161's 17:29 entry, no spec edit since. `.loop/DEADLINE` / `TASK.md` / `NOTICE-duplicate-loop.md` all mtime 2026-10-16. No new files, no ruling message, no uncommitted spec changes.
- 仍差 unchanged — all 7 real entries ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Next: unchanged — hold; pick up the first unblocked item only if a ruling/spec update lands after R162.

## R163 (2026-10-17) — HOLD (2nd consecutive), nothing done
- Atomic step: Next #1 option (b) — hold the checkpoint. No source, no build, no screenshot, no re-verify.
- Ruling check: `spec.md` mtime 2026-10-17 04:56 — unchanged since R162's check, still predates R161. `.loop/DEADLINE` 10-16 19:34 / `TASK.md` 10-16 20:40. Git head = R162 docs commit; only session artifacts (state.md/rounds.md/LEDGER.md/ROUND/health.state/pim-vm.log) touched. No ruling message anywhere.
- 仍差 unchanged — all 7 real entries ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Next: unchanged — hold; pick up the first unblocked item only if a ruling/spec update lands after R163.

## R164 (2026-10-17) — HOLD (3rd consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R163: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `git log` head = R163's hold commit (9af24a6); tracked tree clean except `docs/ui-calendar/HEALTH.md` (outer-loop bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161/R162 note idle rounds = hold, not loop — nothing new to measure, and re-verify at most one item per session when truly idle).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.

## R165 — HOLD (4th consecutive)
Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R164: **NONE** — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, git head = R164's docs commit, tracked tree clean except `.loop/ROUND` (outer-loop bookkeeping).
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). Checkpoint stands: sweep COMPLETE both legs, twin-covered; everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists).
- State.md rolling window trimmed: R157 archived to rounds.md tail; 最近已改 now R165..R158.

## R166 — HOLD (5th consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R165: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `git log` head = R165's hold commit (15a61d6); tracked tree clean except `.loop/ROUND` (outer-loop bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161 note idle rounds = hold, not loop).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.
- state.md rolling window trimmed: R158 archived to rounds.md tail (already recorded); 最近已改 now R166..R159.

## R167 — HOLD (6th consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R166: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `git log` head = R166's docs commit (3e0958e); tracked tree clean except `.loop/ROUND` (outer-loop bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161 note idle rounds = hold, not loop).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.
- state.md rolling window trimmed: R159 archived to rounds.md tail (already recorded); 最近已改 now R167..R160.

## R168 — HOLD (7th consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R167: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `git log` head = R167's hold commit (f83fc8b); tracked tree clean except `.loop/ROUND` (outer-loop bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161 note idle rounds = hold, not loop).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.
- state.md rolling window trimmed: R160 archived to rounds.md tail (already recorded); 最近已改 now R168..R161.

## R169 — HOLD (8th consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R168: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `git log` head = R168's docs commit (a639642); tracked tree clean except `.loop/ROUND` + state/rounds (this round's bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161 note idle rounds = hold, not loop).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.
- state.md rolling window trimmed: R160 archived to rounds.md tail (already recorded); 最近已改 now R169..R161.

## R170 — HOLD (9th consecutive), no source, no build, no screenshot
- Next #1 option (b). Checked for rulings/spec updates since R169: NONE — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161), `.loop/DEADLINE` 10-16 19:34, `.loop` control files (PROMPT/TASK/NOTICE/health) all 10-16, `git log` head = R169's hold commit (4e4872f); tracked tree clean except `.loop/ROUND` + state/rounds (this round's bookkeeping). No ruling message anywhere.
- No re-verify this round (idle hold; per R161 note idle rounds = hold, not loop).
- Checkpoint stands: sweep COMPLETE, every closed item twin-covered (R161); 仍差 entirely ruling-blocked (E02 two font clauses + 11-item list reported R140, no channel). NOT `DONE`.
- state.md rolling window trimmed: R161 archived to rounds.md tail (already recorded); 最近已改 now R170..R162; duplicate "1." numbering fixed.

## R161 — VERIFICATION ONLY (dark leg), no source (archived from state.md window)
- Mini-month heading re-verified DARK leg: PASS — title core rows 519..530 / cols x80..139 (1 px AA of the light pin), ink (242,242,242) = dark labelPrimary; chevrons left x23..27 r519..528 EXACT, right x191..196 r520..528 EXACT, cores ≈(157,157,157); plane (40,40,40). **Last uncovered twin closed — every closed item now measured on both legs.**
- **R171 — HOLD (10th consecutive).** Next #1 option (b). Checked for new rulings/spec updates since R170: NONE (spec.md mtime 2026-10-17 04:56 unchanged; .loop control files PROMPT 20:18 / TASK 20:40 / NOTICE 19:57 all 10-16; git head = R170 docs commit 85cc5cb; only .loop/ROUND newer). No source, no build, no screenshot, no re-verify. Checkpoint stands: blocked on a user ruling. state.md window advanced to R171..R163 (R162 archived here).
- **R162 — HOLD.** Checked for rulings/spec updates: none since R161 (spec mtime 04:56 predates it; .loop control files all 2026-10-16). Checkpoint stands. *(archived R171)*

## R172 — HOLD (11th consecutive; checkpoint = blocked on a user ruling)
- Next #1 option (b). Checked for new rulings/spec updates since R171: **NONE** — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R171 hold commit 39d0494; tracked tree clean except `.loop/ROUND` + state/rounds bookkeeping. No ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list from R140). Sweep COMPLETE, every closed item twin-covered (R161).
- Not `DONE`.

## R173 — HOLD (12th consecutive; checkpoint = blocked on a user ruling)
- Next #1 option (b). Checked for new rulings/spec updates since R172: **NONE** — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R172 docs commit 56f28f5; tracked tree clean except `.loop/ROUND` + state/rounds bookkeeping. No ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list from R140). Sweep COMPLETE, every closed item twin-covered (R161).
- Not `DONE`.
- *(Archived from state.md window: R165 — hold, nothing done (4th consecutive); checked none since R164; spec mtime 04:56 unchanged; git head = R164 docs commit.)*

## R174 — HOLD (13th consecutive; checkpoint = blocked on a user ruling)
- Next #1 option (b). Checked for new rulings/spec updates since R173: **NONE** — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R173 hold commit f9f18d0; tracked tree clean except `.loop/ROUND` + state/rounds bookkeeping. No ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list from R140). Sweep COMPLETE, every closed item twin-covered (R161).
- Not `DONE`.
- *(Archived from state.md window: R166 — hold, nothing done (5th consecutive); checked none since R165; spec mtime 04:56 unchanged; git head = R165 hold commit.)*

## R175 — HOLD (14th consecutive). Checked for new rulings/spec updates since R174: NONE (spec.md mtime 2026-10-17 04:56 unchanged, predates R161; .loop/DEADLINE 10-16 19:34; git head = R174 docs commit 057166e; tracked tree clean except .loop/ROUND + this round's bookkeeping). No source, no build, no screenshot, no re-verify (idle hold per R161 note). 仍差 unchanged — all ruling-blocked. Sweep COMPLETE both legs, twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT DONE.

## R176 — HOLD (15th consecutive)
- Atomic step: Next #1 option (b) — HOLD the checkpoint.
- Checked for new rulings/spec updates since R175: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; `git log` head = R175 hold commit 23eb96e; tracked tree clean except `.loop/ROUND` + state/rounds bookkeeping. No ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — nothing new to measure).
- 仍差 unchanged: all 7 entries ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling.
- *(archived from state.md window)* R168 — hold, nothing done (7th consecutive). Checked for rulings/spec updates: none since R167 (spec mtime 04:56 unchanged; git head = R167 hold commit f83fc8b). Checkpoint stands: blocked on a user ruling.

## R177 (2026-10-17) — HOLD (16th consecutive)
- Atomic step: Next #1 option (b) — HOLD the checkpoint.
- Checked for new rulings/spec updates since R176: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; `git log` head = R176 docs commit 93bc468; tracked tree clean except `.loop/ROUND` + state/rounds bookkeeping. No ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — nothing new to measure).
- 仍差 unchanged: all 7 entries ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling.
- *(archived from state.md window)* R169 — hold, nothing done (8th consecutive). Checked for rulings/spec updates: none since R168 (spec mtime 04:56 unchanged; git head = R168 docs commit a639642). Checkpoint stands: blocked on a user ruling.

## R178
Atomic step: HOLD the checkpoint (17th consecutive hold).
- Checked for new rulings/spec updates since R177: NONE. spec.md mtime 2026-10-17 04:56 (unchanged, predates R161); .loop/DEADLINE 10-16 19:34; git head = R177 hold commit (9cb156d); tracked tree clean except .loop/ROUND — no ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold).
- 仍差 unchanged: all 7 entries ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling.

## R179 (2026-10-17) — HOLD (18th consecutive)
- Next #1 option (b). Checked for new rulings/spec updates since R178: **NONE** — `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; `git log` head = R178 docs commit 9e43cfd; no ruling message anywhere (`.loop/ROUND` = 179, iter bookkeeping only; `HEALTH.md` diff = watchdog heartbeats only).
- No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140; no channel exists).

## R180 — HOLD (19th consecutive)
- **Checked for new rulings/spec updates since R179: NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; `git log` head = R179 docs commit a0e5be0; `.loop/ROUND` = 180. Files newer than the R179 session: only `.loop/ROUND`, `.loop/health.state` (watchdog heartbeat), and this round's own state/rounds/ledger/log files — no ruling message anywhere.
- No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140).
- **R181 (2026-10-17) — HOLD (20th consecutive).** Checked for new rulings/spec updates since R180: none (spec.md mtime 04:56 unchanged, predates R161; .loop/DEADLINE 10-16 19:34; git head = R180 docs commit 156a113). No source, no build, no screenshot, no re-verify — idle hold. 仍差 unchanged (all ruling-blocked); sweep complete, twin-covered. Checkpoint stands: blocked on a user ruling. NOT DONE (E02 font clauses FAIL, ruling-blocked).

## R182 (2026-10-17) — HOLD (21st consecutive)
- Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R181: NONE — spec.md mtime 2026-10-17 04:56 unchanged (predates R161); .loop/DEADLINE 10-16 19:34; git head = R181's hold commit 651043d; .loop/ROUND = 182; only ROUND counter, health heartbeat, R181's own state/rounds/LEDGER writes and pim-vm.log newer than the R181 session.
- No source, no build, no screenshot, no re-verify (idle hold). Sweep COMPLETE both legs, every closed item twin-covered (R161). 仍差 all ruling-blocked: E02's two font clauses (chip text) + the 11-item ruling-blocked list (reported R140).
- Checkpoint stands: blocked on a user ruling. NOT DONE.

## R174 (2026-10-17) — HOLD (13th consecutive) *(archived from state.md window R183)*
- Atomic step: Next #1 option (b). No new rulings/spec updates since R173 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R173 hold commit f9f18d0). Checkpoint stands: blocked on a user ruling. NOT DONE.

## R183 (2026-10-17) — HOLD (22nd consecutive)
- Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R182: NONE — spec.md mtime 2026-10-17 04:56 unchanged (predates R161); .loop/DEADLINE 10-16 19:34; git head = R182's docs commit 1237190; .loop/ROUND = 183; only the ROUND counter newer than R182's session.
- No source, no build, no screenshot, no re-verify (idle hold). Sweep COMPLETE both legs, every closed item twin-covered (R161). 仍差 all ruling-blocked: E02's two font clauses (chip text) + the 11-item ruling-blocked list (reported R140).
- Checkpoint stands: blocked on a user ruling. NOT DONE.

## R184 (2026-10-17) — HOLD (23rd consecutive)
- Checked for new rulings/spec updates since R183: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R183 hold commit e72bcf4; `.loop/ROUND` = 184.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R185 (2026-10-17) — HOLD (24th consecutive)
- Checked for new rulings/spec updates since R184: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R184 docs commit 4691a3f; `.loop/ROUND` = 185.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R186 (2026-10-17) — HOLD (25th consecutive)
- Checked for new rulings/spec updates since R185: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R185 hold commit b150f76; `.loop/ROUND` = 186.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R178 (archived from state.md window 2026-10-17) — HOLD (17th consecutive)
- Checked for rulings/spec updates: none since R177 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R177 hold commit 9cb156d). Checkpoint stands: blocked on a user ruling.

## R187 (2026-10-17) — HOLD (26th consecutive)
- Checked for new rulings/spec updates since R186: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R186 docs commit 0540943; `.loop/ROUND` = 187.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R188 — HOLD (27th consecutive hold; checkpoint = blocked on a user ruling)
- Checked for new rulings/spec updates since R187: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R187 hold commit 93d1d58; `.loop/ROUND` = 188.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R181 (archived from state.md window 2026-10-17) — HOLD (20th consecutive)
- Checked for rulings/spec updates: none since R180 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R180 docs commit 156a113). Checkpoint stands: blocked on a user ruling.

## R189 — HOLD (28th consecutive hold; checkpoint = blocked on a user ruling)
- Checked for new rulings/spec updates since R188: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R188 docs commit d9fc80b; `.loop/ROUND` = 189.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R182 (archived from state.md window 2026-10-17) — HOLD (21st consecutive)
- Checked for rulings/spec updates: none since R181 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R181 hold commit 651043d). Checkpoint stands: blocked on a user ruling.

## R181 (archived from state.md window 2026-10-17) — HOLD (20th consecutive)
- Checked for rulings/spec updates: none since R180 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R180 docs commit 156a113). Checkpoint stands: blocked on a user ruling.

## R190 — HOLD (29th consecutive hold; checkpoint = blocked on a user ruling)
- Checked for new rulings/spec updates since R189: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-16 19:34; git head = R189 hold commit bc4b924; `.loop/ROUND` = 190.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R190 (archived from state.md window 2026-10-17) — HOLD (29th consecutive)
- Checked for rulings/spec updates: none since R189 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R189 hold commit bc4b924). Checkpoint stands: blocked on a user ruling.

## R191 — HOLD (30th consecutive hold; checkpoint = blocked on a user ruling)
- Checked for new rulings/spec updates since R190: **NONE.** `spec.md` mtime 2026-10-17 04:56 (unchanged, predates R161); `.loop/DEADLINE` 10-17 19:34 (outer loop's rolling session deadline — advanced one day from 10-16, not a ruling); `git log` head = R190 docs commit 4252060; `.loop/ROUND` = 191.
- No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — everything on it is ruling-blocked. Sweep COMPLETE, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R192 (2026-10-17) — HOLD (31st consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R191: NONE — spec.md mtime still 2026-10-17 04:56 (predates R161); git head = R191 hold commit b81321f; .loop/ROUND = 192. No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: sweep COMPLETE both legs, twin-covered (R161); all remaining items (E02's two font clauses + the 11-item list) ruling-blocked. Not DONE.
*(archived from state.md window)* R185 — hold, nothing done (24th consecutive). Checked for rulings/spec updates: none since R184 (spec mtime 04:56 unchanged; .loop/DEADLINE 10-16; git head = R184 docs commit 4691a3f). Checkpoint stands: blocked on a user ruling.

## R193 (2026-10-17) — HOLD (32nd consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R192: NONE — spec.md mtime still 2026-10-17 04:56 (predates R161); git head = R192 docs commit 6498d5f; .loop/ROUND = 193; .loop/DEADLINE 1792236870 (10-17, rolling). No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: sweep COMPLETE both legs, twin-covered (R161); all remaining items (E02's two font clauses + the 11-item list) ruling-blocked. Not DONE.

## R194 (2026-10-17) — HOLD (33rd consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R193: NONE — spec.md mtime still unchanged (predates R161); git head = R193 hold commit f0a0bf0; .loop/ROUND = 194; .loop/DEADLINE 1792236870 (10-17, rolling, not a ruling). No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: sweep COMPLETE both legs, twin-covered (R161); all remaining items (E02's two font clauses + the 11-item list) ruling-blocked. Not DONE.

## R195 (2026-10-17) — HOLD (34th consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R194: NONE — spec.md mtime still 2026-10-17 04:56 (predates R161); git head = R194 docs commit 011b092; .loop/ROUND = 195; .loop/DEADLINE 1792236870 (10-17, rolling, not a ruling). No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: sweep COMPLETE both legs, twin-covered (R161); all remaining items (E02's two font clauses + the 11-item list) ruling-blocked. Not DONE.

## R196 (2026-10-17) — HOLD (35th consecutive)
Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R195: **NONE**. `spec.md` mtime unchanged (2026-10-17 04:56); git head = R195 hold commit 045c190; `.loop/ROUND` = 196; no source changes under apps/; `.loop/DEADLINE` rolling (not a ruling).
- No source edit, no build, no screenshot, no re-verify (idle hold; per R161 note).
- 仍差 unchanged: all 7 entries ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE, twin-covered.
- state.md window rolled to R196..R189 (R187 line archived; already recorded here).
- Checkpoint stands: blocked on a user ruling.

## R197 (2026-10-17) — HOLD (36th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R196: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R196 docs commit 5d3ac50; `.loop/ROUND` = 197; no source changes under apps/. No source, no build, no screenshot, no re-verify (idle hold; nothing new to measure). 仍差 unchanged — everything on it is ruling-blocked. Checkpoint stands: blocked on a user ruling. Window trimmed: R189 entry archived here.

## R198 (2026-10-17) — HOLD (37th consecutive)
- Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R197: NONE — spec.md mtime unchanged (2026-10-17 04:56), git head = R197 hold commit 00b1efc, no source changes under apps/.
- No build, no screenshot, no re-verify (nothing new to measure). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140; no channel exists).
- NOT DONE.

## R199 (2026-10-17) — HOLD (38th consecutive)
- Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R198: NONE — spec.md mtime unchanged (2026-10-17 04:56), git head = R198 docs commit 529db14, no source changes under apps/.
- No build, no screenshot, no re-verify (nothing new to measure). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140; no channel exists).
- NOT DONE.


## R200 (2026-10-17) — HOLD, 39th consecutive. Checked for new rulings/spec updates since R199: NONE (spec.md mtime 2026-10-17 04:56 unchanged; git head = R199 hold commit 46a9cfa; .loop/ROUND = 200; no source changes under apps/). Option (b) taken: checkpoint stands, blocked on a user ruling. No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — all ruling-blocked; sweep COMPLETE both legs, every closed item twin-covered. NOT DONE.

## R201 (2026-10-17) — HOLD, 40th consecutive. Checked for new rulings/spec updates since R200: NONE (spec.md mtime 2026-10-17 04:56 unchanged; git head = R200 docs commit 984ff1c; .loop/ROUND = 201; no source changes under apps/). Option (b) taken: checkpoint stands, blocked on a user ruling. No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — all ruling-blocked; sweep COMPLETE both legs, every closed item twin-covered. NOT DONE.
R202 — HOLD (41st consecutive). Checked for new rulings/spec updates since R201: NONE (spec.md mtime 2026-10-17 04:56 unchanged; git head = R201 hold commit cf581a4; .loop/ROUND = 202; no source changes under apps/, last = R159 8145412). No source, no build, no screenshot, no re-verify. 仍差 unchanged — everything ruling-blocked (E02's two font clauses + the 11-item list reported R140). Checkpoint stands: blocked on a user ruling. NOT DONE.
R195 archive — hold, nothing done (34th consecutive). Checked for rulings/spec updates: none since R194 (spec mtime 2026-10-17 04:56 unchanged; git head = R194 docs commit 011b092). Checkpoint stands: blocked on a user ruling.

## R203 (2026-10-17) — HOLD, 42nd consecutive. Checked for new rulings/spec updates since R202: NONE (spec.md mtime 2026-10-17 04:56 unchanged; git head = R202 docs commit c7301b6; .loop/ROUND = 203). R203 audit: Main.qml / CalendarScheduleView.qml carry post-04:56 mtimes (09:39 / 17:24) but `git diff apps/` is EMPTY — content byte-identical to HEAD, touch-only, not a change; last real source change remains R159 (8145412). Option (b) taken: checkpoint stands, blocked on a user ruling. No source, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140); sweep COMPLETE both legs, every closed item twin-covered. NOT DONE.

## R204 (2026-10-17) — HOLD (43rd consecutive)
- Audit: spec.md mtime unchanged (2026-10-17 04:56); git head = R203 hold commit 2c4b981; `.loop/ROUND` = 204; `git status`/`git diff apps/` EMPTY. No new rulings or spec updates since R203.
- Atomic step: Next #1 option (b) — hold the checkpoint. No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — held, nothing new to measure).
- 仍差 unchanged: all 7 entries ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE both legs, every closed item twin-covered (R161).
- Checkpoint stands: blocked on a user ruling. NOT `DONE`.
- state.md window rotated to R204..R197; R196 entry archived below.
- Archived from state.md: R196 — hold, nothing done (35th consecutive). Checked for rulings/spec updates: none since R195 (spec mtime 2026-10-17 04:56 unchanged; git head = R195 hold commit 045c190; no source changes under apps/). Checkpoint stands: blocked on a user ruling.

## R205 (2026-10-17) — HOLD (44th consecutive)
- Checked for new rulings/spec updates since R204: NONE. spec.md mtime unchanged (2026-10-17 04:56); git head = R204 docs commit 079469a; `git status`/`git diff apps/` empty.
- No source, no build, no screenshot, no re-verify. Checkpoint stands: blocked on a user ruling (E02 font clauses + 11-item list).
- Archived R197 hold entry from state.md window (now R205..R198).
- Next: unchanged — hold unless a ruling lands.

## R206 (2026-10-17) — HOLD (45th consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R205: NONE — spec.md mtime unchanged (2026-10-17 04:56), git head = R205 hold commit a8d087d, `.loop/ROUND` = 206, `git status`/`git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold per R161). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list, reported R140; no channel). 仍差 unchanged, all ruling-blocked. state.md window moved to R206..R199 (R198 archived to rounds.md tail).

## R207 (2026-10-17) — HOLD (46th consecutive)
- Next #1 option (b): checked for new rulings/spec updates since R206 — NONE. `spec.md` mtime unchanged (2026-10-17 04:56); git head = R206 docs commit b5e10c6; `git status`/`git diff apps/` empty.
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged (all ruling-blocked): E02 chip text block · E01/E02 inset-stripe scale · band chip icon (ruling H) · gutter label format (ruling F) · month slice cap (ruling D) · dim snap + shadow (rulings A/B) · Year word / C05 count / popover escape (ruling E/C/G) · ToolTip y (open).
- Checkpoint stands: blocked on a user ruling. NOT `DONE`.

## R208 (2026-10-17) — HOLD (47th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R207: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R207 hold commit (61ee320); `.loop/ROUND` = 208; `git status`/`git diff apps/` EMPTY (only dirty file = `docs/ui-calendar/HEALTH.md`, the outer loop's heartbeat line, not a ruling). No source, no build, no screenshot, no re-verify (idle hold per R161 note). 仍差 unchanged — all ruling-blocked; sweep COMPLETE, twin-covered (R161). Checkpoint stands: blocked on a user ruling. state.md window rolled to R208..R200 (R199 archived here).

## R209 (2026-10-17) — HOLD (48th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R208: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R208 docs commit a91ecbe; `.loop/ROUND` = 209; `git status`/`git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: the sweep is COMPLETE both legs and twin-covered (R161); everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Next round: re-check for rulings; hold if none.

## R210 (2026-10-17) — HOLD (49th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R209: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R209 hold commit 093fe08; `.loop/ROUND` = 210; `git status`/`git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold per R161 note). Checkpoint stands: the sweep is COMPLETE both legs and twin-covered (R161); everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Next round: re-check for rulings; hold if none. state.md window rolled to R210..R203 (R202/R200 archived here; R201 was already archived).

## R211 (2026-10-17) — HOLD (50th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R210: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R210 docs commit d9c686a; `.loop/ROUND` = 211; `git status`/`git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold per R161 note). Checkpoint stands: the sweep is COMPLETE both legs and twin-covered (R161); everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Next round: re-check for rulings; hold if none. state.md window rolled to R211..R204 (R203 archived here).

## R212 — HOLD (51st consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R211: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56); git head = R211 hold commit 10ab864; `git status apps/` empty. No source, no build, no screenshot, no re-verify (idle hold). 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE, twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT `DONE`.

## R213 — HOLD (52nd consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R212: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56); git head = R212 docs commit (29776e9); `.loop/ROUND` = 213; `git status apps/` empty. No source, no build, no screenshot, no re-verify. Checkpoint stands: sweep COMPLETE both legs, every closed item twin-covered (R161); everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). NOT `DONE`. state.md window now R213..R206 (R205 entry moved here).

## R214 — HOLD (53rd consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R213: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56); git head = R213 hold commit (fea6a79); `.loop/ROUND` = 214; `git status apps/` empty. No source, no build, no screenshot, no re-verify. Checkpoint stands: sweep COMPLETE both legs, every closed item twin-covered (R161); everything in 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). NOT `DONE`. state.md window now R214..R207 (R206 entry moved here).

## R215 — HOLD (54th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R214: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R214 docs commit (1309f54); `.loop/ROUND` = 215; `git status apps/` EMPTY. No source, no build, no screenshot, no re-verify (idle hold). 仍差 unchanged — everything on it is ruling-blocked (E02's two font clauses + the 11-item list, reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT `DONE`.

## R216 — HOLD (55th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R215: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R215 docs commit (fe19f29); `.loop/ROUND` = 216; `git status apps/` EMPTY. No source, no build, no screenshot, no re-verify (idle hold). 仍差 unchanged — everything on it is ruling-blocked (E02's two font clauses + the 11-item list, reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT `DONE`. state.md window now R216..R209 (R208 entry moved here).
- **R217 — HOLD (56th consecutive).** Atomic step = Next #1 option (b). Checked for new rulings/spec updates since R216: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds), git head = R216 docs commit 542f88d, `.loop/ROUND` = 217, `git status apps/` + `git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — nothing new to measure). 仍差 unchanged: all 7 entries ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT `DONE`.

## R218 — HOLD (57th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R217: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R217 hold commit (91e0f05); `.loop/ROUND` = 218; `git status apps/` EMPTY, `git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold). 仍差 unchanged — everything on it is ruling-blocked (E02's two font clauses + the 11-item list, reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered (R161). Checkpoint stands: blocked on a user ruling. NOT `DONE`. state.md window now R218..R211 (R210 entry moved here).

## R219 — HOLD (58th consecutive)
Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R218: NONE — `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R218 docs commit 832774a; `.loop/ROUND` = 219; `git status apps/` empty, `git diff apps/` empty. No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — nothing new to measure, held). Sweep COMPLETE both legs, every closed item twin-covered (R161). 仍差 unchanged: everything on it is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Checkpoint stands: blocked on a user ruling. NOT `DONE`.
## R220 (2026-10-17) — HOLD (59th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R219: **NONE** (spec.md mtime 2026-10-17 04:56 unchanged; git head = R219 hold commit 0e9b537; `.loop/ROUND` = 220; `git status`/`git diff apps/` empty).
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140). Sweep COMPLETE both legs, twin-covered (R161). NOT `DONE`.
- Next round: same Next #1 — if a new ruling/spec update has landed, pick up the first unblocked item; else hold again.

## R221 (2026-10-17) — HOLD (60th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R220: **NONE** (spec.md mtime 2026-10-17 04:56 unchanged; git head = R220 docs commit 18d106d; `.loop/ROUND` = 221; `git status`/`git diff apps/` empty).
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140). Sweep COMPLETE both legs, twin-covered (R161). NOT `DONE`.
- Next round: same Next #1 — if a new ruling/spec update has landed, pick up the first unblocked item; else hold again.

## R222 (2026-10-17) — HOLD (61st consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R221: **NONE** (spec.md mtime 2026-10-17 04:56 unchanged; git head = R221 hold commit 6ae4102; `.loop/ROUND` = 222; `git status`/`git diff apps/` empty).
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140). Sweep COMPLETE both legs, twin-covered (R161). NOT `DONE`.
- Next round: same Next #1 — if a new ruling/spec update has landed, pick up the first unblocked item; else hold again.

## R223 (2026-10-17) — HOLD (62nd consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R222: **NONE** (spec.md mtime 2026-10-17 04:56 unchanged; git head = R222 docs commit 6f06ade; `.loop/ROUND` = 223; `git status`/`git diff apps/` empty).
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140). Sweep COMPLETE both legs, twin-covered (R161). NOT `DONE`.
- Next round: same Next #1 — if a new ruling/spec update has landed, pick up the first unblocked item; else hold again.

## R224 (2026-10-17) — HOLD (63rd consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint. Checked for new rulings/spec updates since R223: **NONE** (spec.md mtime 2026-10-17 04:56 unchanged; git head = R223 hold commit 956cc20; `.loop/ROUND` = 224; `git status`/`git diff apps/` empty).
- No source, no build, no screenshot, no re-verify (idle hold per R161 note).
- 仍差 unchanged — all ruling-blocked (E02's two font clauses + the 11-item list reported R140). Sweep COMPLETE both legs, twin-covered (R161). NOT `DONE`.
- Next round: same Next #1 — if a new ruling/spec update has landed, pick up the first unblocked item; else hold again.

## R225 (2026-10-17) — HOLD (64th consecutive)
Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R224: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56); git head = R224 docs commit 8817ff2; `.loop/ROUND` = 225; `git status apps/` / `git diff apps/` empty. No source, no build, no screenshot, no re-verify. Everything in 仍差 remains ruling-blocked (E02's two font clauses + the 11-item list from R140; no channel exists). Checkpoint stands: **blocked on a user ruling**. NOT `DONE`.
## R226 (2026-10-17) — HOLD (65th consecutive)
Checked for new rulings/spec updates since R225: none (spec.md mtime 2026-10-17 04:56 unchanged; git head = R225 hold commit 5e2dea4; git status/git diff apps/ and spec.md empty; .loop/ROUND=226). Idle hold per R161 note — no source, no build, no screenshot. Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered.

- **R227 — hold (66th consecutive).** Checked for rulings/spec updates since R226: none (spec.md mtime 2026-10-17 04:56 unchanged; git head = R226 docs commit 84e34e2; git status/diff apps/ empty). No source, no build, no screenshot, no re-verify (idle hold per R161 note). Checkpoint stands: blocked on a user ruling. Archived R219 entry from the state window to rounds tail.
## R228 (2026-10-17) — HOLD (67th consecutive)
Checked for new rulings/spec updates since R227: none (spec.md mtime 2026-10-17 04:56 unchanged; git head = R227 hold commit b403ac6; git status/git diff apps/ and spec.md empty; .loop/ROUND=228). Idle hold per R161 note — no source, no build, no screenshot, no re-verify. Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item list reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered.

## R229 — HOLD (68th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R228: **NONE.** `spec.md` mtime unchanged (2026-10-17 04:56, predates all rounds); git head = R228 docs commit 32ec11c; `.loop/ROUND` = 229; `git status apps/` EMPTY, `git diff apps/` empty.
- No source edit, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — every item ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists).
- Checkpoint stands: **NOT `DONE`**, blocked on a user ruling.

## R230 — HOLD (69th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R229: **NONE.** `spec.md` mtime unchanged (2026-10-17 04:56, predates all rounds); git head = R229 hold commit 5e782f8; `.loop/ROUND` = 230; `git status apps/` EMPTY.
- No source edit, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — every item ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists).
- Checkpoint stands: **NOT `DONE`**, blocked on a user ruling.

## R231 — HOLD (70th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R230: **NONE.** `spec.md` mtime unchanged (2026-10-17 04:56, predates all rounds); git head = R230 docs commit f75f23d; `.loop/ROUND` = 231; `git status apps/` EMPTY.
- No source edit, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — every item ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists).
- Checkpoint stands: **NOT `DONE`**, blocked on a user ruling.

## R232 — HOLD (71st consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R231: **NONE.** `spec.md` mtime unchanged (2026-10-17 04:56, predates all rounds); git head = R231 hold commit 9152262; `.loop/ROUND` = 232; `git status apps/` EMPTY.
- No source edit, no build, no screenshot, no re-verify (idle hold per the R161 note). 仍差 unchanged — every item ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). Window slide: R221 archived to rounds.md tail (window = R232..R222).
- Checkpoint stands: **NOT `DONE`**, blocked on a user ruling.

## R233 — HOLD (72nd consecutive)
Checked for new rulings/spec updates since R232: **NONE.** spec.md mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R232 docs commit (62c52b7); `.loop/ROUND` = 233; `git status apps/` EMPTY. No source, no build, no screenshot (idle hold). Checkpoint stands: blocked on a user ruling (E02's two font clauses + the 11-item ruling-blocked list reported R140; no channel exists). Sweep COMPLETE, every closed item twin-covered (R161).

## R234 — HOLD (73rd consecutive hold)
Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R233: NONE. `spec.md` mtime unchanged (2026-10-17 04:56, predates all recent rounds); git head = R233 hold commit (8248faf); `.loop/ROUND` = 234; `git status apps/` empty.
- No source, no build, no screenshot, no re-verify (idle hold; re-verify at most one item per session — held, nothing new to measure).
- 仍差 unchanged: everything on it is ruling-blocked (E02 font clauses + 11-item list, reported R140; no channel). Sweep COMPLETE, twin-covered (R161). Not `DONE`.

## R235 — HOLD (74th consecutive)
- **Checked for new rulings/spec updates since R234: NONE.** `spec.md` mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R234 docs commit (30be550); `.loop/ROUND` = 235; `git status apps/` EMPTY.
- No source, no build, no screenshot, no re-verify (idle hold; per R161 note). Checkpoint stands: **blocked on a user ruling** — E02's two font clauses + the 11-item ruling-blocked list (reported R140; no channel exists).
- 仍差 unchanged; sweep COMPLETE, every closed item twin-covered (R161). NOT DONE.
- *(R224 archived from state.md window at R235: hold, nothing done (63rd consecutive); checked for rulings/spec updates — none since R222 (spec mtime unchanged; git head = R222 docs commit 6f06ade; git status apps/ empty). Checkpoint stood: blocked on a user ruling.)*

## R236 (2026-10-17) — HOLD (75th consecutive)
- Atomic step: Next #1 option (b) — hold the checkpoint.
- Checked for new rulings/spec updates since R235: NONE (spec.md mtime 2026-10-17 04:56 unchanged, predates the rounds; git head = R235 hold commit 78b85bb; .loop/ROUND = 236; git status apps/ empty).
- No source, no build, no screenshot, no re-verify (idle hold; per R161 note). Checkpoint stands: **blocked on a user ruling** — E02's two font clauses + the 11-item ruling-blocked list (reported R140; no channel exists).
- 仍差 unchanged; sweep COMPLETE, every closed item twin-covered (R161). NOT DONE.
- *(R225 archived from state.md window at R236: hold, nothing done (64th consecutive); checked for rulings/spec updates — none since R224 (spec mtime unchanged; git head = R224 docs commit 8817ff2; git status/diff apps/ empty). Checkpoint stood: blocked on a user ruling.)*

## R237 — HOLD (76th consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R236: NONE — spec.md mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R236 docs commit 2c15e2c; `.loop/ROUND` = 237; `git status apps/` empty. No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).

## R238 — HOLD (77th consecutive)
Next #1 option (b). Checked for new rulings/spec updates since R237: NONE — spec.md mtime unchanged (2026-10-17 04:56, predates the rounds); git head = R237 hold commit dc5bab4; `.loop/ROUND` = 238; `git status apps/` empty. No source, no build, no screenshot, no re-verify (idle hold). Checkpoint stands: blocked on a user ruling. NOT `DONE` — E02's two font clauses remain FAIL (ruling-blocked).
- *(R227 archived from state.md window at R238: hold, nothing done (66th consecutive); checked for rulings/spec updates — none since R226 (spec mtime unchanged; git head = R226 docs commit 84e34e2; git status/diff apps/ empty). Checkpoint stood: blocked on a user ruling.)*

## R239 — HOLD (78th consecutive)
- Atomic step: Next #1 option (b). Checked for new rulings/spec updates since R238: **NONE** — `spec.md` mtime unchanged (2026-10-17 04:56); git head = R238 docs commit 5d98795; `.loop/ROUND` = 239; `git status apps/` EMPTY.
- No source edit, no build, no screenshot, no re-verify (idle hold; nothing new to measure).
- Checkpoint stands: sweep COMPLETE both legs, every closed item twin-covered (R161); all of 仍差 is ruling-blocked (E02's two font clauses + the 11-item list reported R140; no channel exists). NOT `DONE`.
- state.md window rotated to R239..R231; R230 moved to rounds.md tail.

## R240 — RULING LANDED; R-CHIP clause 1 + R-SCALE implemented and verified
- **spec.md mtime jumped 04:56 → 22:50:48** — first change since R238. New section 「用户裁决（2026-10-17 22:55，人工拍板 — 立即生效，解除 hold）」 with four rulings: **R-CHIP** (chip height = round(hourHeight*0.96) ⇒ 38; title 11–12 medium; secondary 10–11; T01 side-by-side halves, never shrink/hide), **R-GUTTER/F** (12-hour two-tone: digits labelPrimary + smaller AM/PM same baseline; keep x263 anchor, 40 pitch, R159 top-row-hidden), **R-MONTH/D** (month cells stack 3 then +N, truncate not overflow), **R-SCALE/G** (ref-measured beats spec literal estimates, tie-break 7.5 直译优先; stripe ≈ 2.4×1.35 ≈ 3). Remaining held: ring icon (H), segment `Year`, R134 tooltip y, A/B dim+shadow — 保持 hold.
- Implemented via code-writer in `CalendarScheduleView.qml`: chip height `Math.round(root.hourHeight*0.96)`=38 (`:824-827`); title `font.pixelSize: 11` + `Font.Medium` (`:899-901`); forced re-derivation `stripeWidth: 3` literal (old round(chipHeight/4) would have given 10) with R-SCALE comment (`:834-839`), `stripeInset = stripeWidth` unchanged.
- Build OK (7 targets). Launch light, resize 1100x692, date 2026-04-02, capture `r240-light-week.png`.
- **Verified (light):** 08:00 chip fill y317..354 = **38 exactly** (hour lines 314/354; top margin 3, bottom flush to next hour line ⇒ 38/40 = 0.95); consecutive chips 317/357/397/437/477 pitch 40. Stripe **x635..637 = 3 px** full-sat (61,174,233); fill inset 3 (fill from x632); title ink from x643 (= 3+3+5 margin), 11 Medium vertically centered, chipInk blue (`r240-chip08-4x.png`).
- **Expected transitional break:** the 11:00 two-chip hour overflows — chip 2 lands y477..514 and garbles 12:00's slot. T01 side-by-side = next+1.
- 仍差: E02 secondary line (no accessor yet — NEXT) · T01 side-by-side · R-GUTTER · R-MONTH · ring icon (H, blocked) · Year/tooltip-y/A/B (blocked).
- state.md window rotated to R240..R233.

## R241 — R-CHIP clause 2: timed chip SECONDARY line (time range) implemented and verified
- Atomic step: Next #1 — E02's secondary clause.
- **Ref evidence** (fresh crops of refs/macos-calendar.png): the secondary is the **TIME RANGE** — "🕐 11AM – 1PM" (small clock glyph + range, same chip-ink hue) under the title; ref 1-hour chips (26 px) show title ONLY, the secondary appears on the taller (2-hour) chip.
- Implemented via code-writer:
  1. `Main.qml:1301-1314` new `itemSecondary(item)`: all-day → ""; else start "HH:MM" (start/due), " – end" appended when the record's end carries T(HH:MM); todos render their due time.
  2. `CalendarScheduleView.qml:28` accessor declaration `property var itemSecondary`.
  3. TimedChip text block → Column: title 11 Medium TOP-aligned (topMargin 2; ref puts title near the top, never centred), secondary 10 regular below (spacing 1, same inkColor), visible when text ≠ "" and chip height ≥ 34.
  4. Wired `itemSecondary: root.itemSecondary` into both `CalendarScheduleView` instances (`Main.qml:2654/2686`).
- Build OK. The live instance was stale (22:55 pid, pre-build binary) — killed, relaunched (pid 2062778), resize 1100x692, date 2026-04-02, capture `r241-light-week.png`.
- **Verified (light):** "Morning planning" chip — title ink from x645 near chip top (317+2), secondary "08:00 – 08:45" 10 px same blue ink below, bottom whitespace, nothing overflows y354; todos show due-only secondary ("09:00"); a 2-hour event reads "11:00 – 13:00"; stripe/fill/radius untouched. Half-hour line bleeds through the 0.19-alpha fill — pre-existing (r240 crop shows the same). T01 garble at 12:00 unchanged (transitional).
- Notes: ref's 1-hour chips hide the secondary (no room at 26 px); ours shows it at 38 px — defensible under E02 (the ruling asks for the line; 38 px fits). The ref's clock glyph is NOT implemented — text-only this round, glyph listed in 仍差.
- state.md window rotated to R241..R234.

## R242 (2026-10-17 ~23:2x) — T01 side-by-side rework (R-CHIP clause 3) — PASS
- Atomic step: state Next #1. Ref evidence: `.loop/refs/macos-calendar.png` crop x320-580 y195-275 (read once at 4× NEAREST): ref Wed column (406..487) 11AM row = "Art…" (≈409..447) + "Me…" (≈447..486) side by side, each ≈half column, full chip height, title-only, elided.
- code-writer edit: `CalendarScheduleView.qml` hour-cell chip ColumnLayout (stacking, the garble source) → anchored `Item { id: chipHost; anchors.margins: 3 }` with `visibleItems = hourCell.cellItems.slice(0, 2)`; delegate `width: (chipHost.width − (n−1)·2)/n`, `x: index·(width+2)`, height 0.96·hourHeight unchanged; trailing layout spacer deleted; T01 comment added.
- **Loop 1 FAIL (instructive):** built, relaunched, screenshot showed ZERO timed chips, no QML error, all-day band fine. Root cause: delegate declared `required property var modelData` but used the Repeater context `index` unqualified — Qt6 resolves it as `undefined` in required-property delegates ⇒ `x = NaN` ⇒ silently invisible. Fix: `required property int index` (`:826`). Loop 2 (the round's last) clean.
- Verify (light 1100x692 expanded, `r242-light-week.png`): Wed 09:00 pair fills 513..567 + 570..625 (55/56 px, gap 2, inset 3) with stripes, elided titles, secondaries ("[UI] G… 09:00" / "Revie… 09:30"); Thu 11:00 pair "Long…"/"[R019…"; Wed 14:00 "Desig…"/"Prepa…"; singles full 113 (Mon fill 275..387); chip height 38 unchanged (317..354 / 357..393); **12:00 row clean in every column — R240's garble gone**.
- Notes: `>2` same-hour still `slice(0,2)` (ruling silent; not invented). Half chips keep secondary at 38px (R241 accepted deviation). `sidebar` command key `open:true` errored (`Cannot assign [undefined] to bool`) though sidebar ended expanded — key unconfirmed. `inspectGeometry` key is `names` (array), not `objectName`.
- Ledgered: R242 chipHost + half-width lanes + required-index fix. Next: R-GUTTER.

## R243 (2026-10-17) — R-GUTTER clause: 12-hour two-tone gutter labels (ruling F)
- Atomic step: state Next #1. Ref evidence: `.loop/refs/macos-calendar.png` 1:1 crop x188-246 y192-260 (6× NEAREST): "9" digit ink x218..223 (6 w) y216..224 (9 tall) core ~90 gray; "AM" x227..234 (starts +3~4 from digit) y219..224 (6 tall), core ~175-198 — SAME bottom baseline (224), smaller+lighter. Red 9:41 pill below unchanged.
- code-writer edit: `CalendarScheduleView.qml:706-752` — single zero-padded 24h `Label` (mutedText 11) replaced by `Item { id: hourLabel }` (same anchors: rightMargin 7, top −implicitHeight/2, R158 visible clause verbatim) containing digitText (11, `AppTheme.text`) + meridiemText (8, `AppTheme.mutedText`, `anchors.right: parent.right`, digit baseline-anchored to it, gap 3); 12-hour text `h%12, 0→12`, AM/PM by `<12`.
- **Loop 1 FAIL: rendered all-black — `AppTheme.labelPrimary`/`labelSecondary` DO NOT EXIST on the shared singleton** (`shared/qml/foundation/AppTheme.qml` has only `text` :153 / `mutedText` :154; labelPrimary/Secondary live on Main.qml's `tahoe` object). Undefined color ⇒ Label default black; both tones identical. Fix: `AppTheme.text` / `AppTheme.mutedText`.
- Verify loop 2 (light 1100x692 expanded, `r243b-light-week.png`): two-tone ✓ — 8 digit core (33,38,60)≈primary vs AM core (114,122,135)=mutedText; same baseline ✓ (8AM digit bottom 314 = AM bottom 314); AM cap 6 : digit 9 = ref ratio ✓; 12-hour ✓ (7 AM…12 PM, `12 PM` correct at noon); pitch 40 exact (band tops 266/306/346/386/426/466/506/546/586/626/666) ✓; ink right edge x264 (vs old x263 — 'M' sidebearing, anchor unchanged) ✓; R159 top-row-hidden intact (first band 07:00) ✓; no QML errors.
- **仍差 (next round first): vertical centre shifted — digit ink 266..274 ⇒ ink centre 270 vs the 07:00 line y274 (old 24h label ink 270..277 centre 273.5 ≈ ON the line; ref ink is centred on the line). Cause: Item top = meridiemText (font 8) line-box top while topMargin still −digitText.implicitHeight/2 ⇒ digit baseline lands ON the line instead of ink-centred. One-number fix next round (shift Item top down ~4px, e.g. topMargin −round(digitText.implicitHeight/2)+4 — re-measure, don't trust this arithmetic blindly).**
- Not verified this round (loop budget spent): DARK leg of R-GUTTER — do it next round after the centre fix.
- Note: harness `sidebar` key is `expanded` (bool) — `harness/Main.qml:214`, NOT `open`. Record supersedes R242's unconfirmed `open:true`.
- Ledgered: R-GUTTER two-tone structure + AppTheme.text/mutedText tokens. Next: centre fix → then R-MONTH.

## R244 (2026-10-17 ~23:3x) — R-GUTTER residual: ink-centre fix + dark leg — PASS, ITEM CLOSED
- Atomic step: state Next #1. Ref behaviour: ref "9AM" digit ink 216..224 with line 220 ⇒ ink CENTRE on the hour line.
- code-writer edit: `CalendarScheduleView.qml:718` — `anchors.topMargin: -Math.round(digitText.implicitHeight / 2) + 4` (comment appended :714-715). Single-line change, nothing else touched.
- Build OK; killed stale pid, relaunched via start-review-vm.sh (light pid 2124325).
- **Verify LIGHT (`r244a-light-week.png` + 6× zoom `r244a-gutter-zoom.png`):** digit ink rows 271..276 / 311..318 / 351..358 / 391..398 ⇒ ink centres 273.5 / 314.5 / 354.5 / 394.5 vs hour lines 274 / 314 / 354 / 394 — ON the line ✓; pitch 40 unchanged ✓; two-tone + same baseline + gap 3 intact ✓ (visually digits straddle the gray hour lines, 7 AM…11 AM).
- **Verify DARK (`r244b-dark-week.png` + zoom `r244b-gutter-zoom.png`):** identical geometry (ink centred on lines 274/314/354/394); bright digit (AppTheme.text) vs dimmer AM (mutedText) two-tone ✓; same baseline ✓; 12-hour ✓; no QML errors in live-runtime-vm.log territory (rendered clean).
- R-GUTTER CLOSED (structure R243 + centre R244 + both legs). Ledgered at `CalendarScheduleView.qml:718`.
- Next: R-MONTH (ruling D) — month day cells stack up to 3 then `+N`, truncate not overflow (currently `slice(0, 2)`).

## R245 (2026-10-17 ~23:5x) — R-MONTH (ruling D): verify stack-3/`+N`/truncate — PASS, ITEM CLOSED, NO CODE CHANGE
- Atomic step: state Next #1 — R-MONTH: month day cells stack up to 3 then `+N`, truncate per ref, no row overflow.
- **Finding before touching anything:** the state.md claim "currently `slice(0, 2)`" was wrong — grep shows the only `slice(0, 2)` is the WEEK view's chip host (`CalendarScheduleView.qml:840`). The month view (`CalendarMonthView.qml`, untouched this loop) already has `visibleItemCount = Math.max(0, Math.min(3, Math.floor((height − topPadding − bottomPadding − 26) / 20)))` (`:97`), slices to it (`:154`), `clip: true` (`:96`), and a `+N` label (`:131-135`). Git log: file last modified before the loop started.
- **Verified DARK month view on 2026-04-02 via window-height sweep (live R244 instance, no rebuild):**
  - 692 h → `r245a-month-692.png`: dayHeight ~70 ⇒ 1 chip + `+N` (Thu "+13" = 14−1). Truncated cleanly.
  - 920 h → `r245b-month-920.png`: dayHeight ~92 ⇒ 2 chips + `+N` (Thu "+12" = 14−2).
  - 1000 h → `r245c-month-1000.png`: **3 chips + `+N`** (Mon 30: 9−3 = "+6"; Thu 2: Design sync / Release notes / R087 card C, "+11" = 14−3). Adjacent rows clean ⇒ clip holds, no overflow.
- All three = ruling D's exact text ("最多 3 条，超出 +N；格子不够高时按参考截断，不得溢出到相邻行"). R-MONTH CLOSED with zero diff. Note: no month-view ref image exists; ruling D text is the sole authority (R-SCALE consistent).
- Ledgered: month-view pin added to state.md. Window restored to 1100×692.
- Next: timed-chip secondary clock glyph (ref 2-hour chip "🕐 11AM – 1PM").

## R246 (2026-10-17) — timed-chip clock glyph + 12-hour secondary — DONE, light+dark
- Next #1. Ref measured via 8×/20× NEAREST crops of the "Stretchin…" chip secondary: outlined clock ring 8×8 ref px, stroke ~1, hands 12+3, ink = text ink (26,67,123); left of text, gap 4, glyph bottom = digit baseline (glyph 8 vs digit cap 6). Other ref chips confirm: "Hike with…" "🕐 10AM – 12…", "Sign language…" "🕐 12 – 2PM" ⇒ 12-hour, shared period drops start meridiem.
- code-writer: `CalendarScheduleView.qml:950-999` secondary Label → Row { glyph Item 11×11 (ring r5.5 border 1.5 chipInk; hand-12 1.5×4; hand-3 3.5×1.5; spacing 5; verticalCenter on label) + Label 10 }; `Main.qml:1308-1338` `formatClock12()` (12h, minutes only when nonzero, 12-not-0) + `itemSecondary` with start-meridiem drop. All-day still "".
- Verify: build ok; relaunch light, `date` no-oped twice — **harness `Main.qml:221` reads `command.date`, NOT `value`** (recorded as load-bearing). Date 2026-04-02 then applied. r246-light.png: all timed chips show ring glyph + "8 – 8:45AM" / "10:15 – 10:30AM" / "11AM – 1PM" / "2:30 – 3:30PM" / "3 – 4:15PM"; 6× crops confirm glyph structure/tone/gap vs ref. r246-dark.png same date: glyph renders in light chipInk on dark fill.
- 24h-vs-12h sanity: ref secondary and R243 gutter both 12-hour ⇒ 12-hour chosen; consistent.
- Next: regression sweep (R240-R246 areas) while holds stand. Not DONE.

## R247 (2026-10-17) — regression sweep #1 — PASS both legs, no code change
- Next #1. Week view 1100×692 expanded, date 2026-04-02, light + dark. Spot-checked every area closed in R240-R246 against pinned values.
- Light (r247-light.png; 2× chip crop _r247-light-chips2x.png; band crop _r247-light-band.png): chip height/title/stripe ✓; 1-item full-width vs 2-item halves with 2px gap, each half own tone (Wed 9AM, 11AM, 2PM) ✓; glyph ring+hands tone=gap=5 ✓; "8 – 8:45AM"/"9AM"/"10:15 – 10:30AM"/"11AM – 1PM"/"3 – 4:15PM" 12h + shared-period meridiem drop ✓; gutter two-tone baseline ✓; all-day band y-map + "+2" ✓; segment pill on 周 ✓.
- Dark (r247-dark.png; 3× Wed crop _r247-dark-wed3x.png): glyph light chipInk on dark fill ✓; green/purple halves keep tones ✓; band ✓.
- Verdict: zero regressions. Held items unchanged (H ring icon · Year word · R134 tooltip y · A/B dim+shadow).
- Next: regression sweep #2 — day view light + collapsed-sidebar week dark.

## R249 — Regression sweep #3: month view light @1100×692 expanded — PASS, no code change
- Next #1 taken verbatim. Relaunch wrinkle: first drive reused R248's dark instance (capture sampled (30,30,30) chrome); `start-review-vm.sh` refuses to start while an owned instance is alive ("Owned review instance still running", exit 1) — killed the pid, relaunched `light`, re-drove resize/sidebar/view/date. Lesson folded into state.md (theme is fixed at launch; no runtime theme action).
- Artifacts: `r249-month-light.png` (1100×692, chrome (255,255,255)) + `r249-crops.png` (week-1 cells 2×, mini-month 2×, chrome 1:1).
- **R-MONTH areas (ruling D, R245 pins):** every event cell = exactly 1 chip + `+N` top-right at this geometry (30→+8, 31→+8, 1→+11, 2→+13, 3→+8, 4→+7); chips clipped to cell, stripe 3, radius ≈5, single-line elide; today cell (2) bordered + tinted. No overflow, no truncation artifact.
- **Mini-month:** heading `2026年4月` + two 28×28 nav buttons; MONDAY-first header; 6 rows (30/31/1…4/5/6/10); today+selected `2` grey disc (selected wins); adjacent-month muted. Matches R112/R115-R118/R144.
- **Toolbar chrome:** segment pill on 月; heading + `< 今天 >`; search/more; window dots. Matches R097/R127/R143.
- Cell 21 hover `+` + tint = cursor hover artifact (pinned R245 hover behaviour), not a delta.
- Verdict: **PASS, zero regressions. Nothing fixed, nothing broken.** Next: sweep #4 — month dark collapsed + agenda panel spot-check.

## R250 — Regression sweep #4 PASS (month view dark @1100×692 COLLAPSED sidebar + bottom agenda panel — zero regressions, no code change)
- Relaunch: killed R249's light instance, `start-review-vm.sh dark`. **Drive-key gotcha: `sidebar` action reads `command.expanded` (bool), NOT `state`** — first drive with `"state":"collapsed"` silently no-opped (harness Main.qml:214); re-drove `{"action":"sidebar","expanded":false}`. resize 1100×692 / view month / date 2026-04-02.
- Artifacts: `r250-month-dark-full.png` (collapsed, chrome topband (30,30,30), sidebar n/a collapsed, grid (30,30,30), agenda tint (31,37,44)) + crops (cell30 4×, cell31 4×, cells1-3 2×, today 3×, agenda 1:1).
- **R-MONTH dark pins (R245) re-verified:** first-row counts EXACT — 30→+8, 31→+8 (4× crops settle the 1:1 misread "+6"), 1→+11, 2→+13, 3→+8, 4→+7; every cell exactly 1 chip, single-line elide, stripe 3 visible, clipped to cell; today cell 2 bordered + tinted + tinted chip (Design sync).
- **Bottom agenda panel:** heading `2026年4月2日星期四 14 项` (bold + muted count); 添加 top-right; rows = blue vertical bar + 全天 blue tab, title Design sync / Release notes, subtitle 日历日程, blue 日程 link right; third row clipped by panel bottom. Panel bg tinted (31,37,44).
- **Collapsed geometry:** mini-month absent (lives in sidebar) ✓; grid spans rim x0 → full width; toolbar chrome (segment pill on 月, heading 2026年4月, `< 今天 >`, search/more, dots) matches R097/R127/R143 dark pins.
- Cell 22 hover `+` + tint = cursor hover artifact (pinned R245 hover behaviour), not a delta.
- Verdict: **PASS, zero regressions. Nothing fixed, nothing broken.** Remaining uncovered rotation leg: day view dark.

## R251 — Regression sweep #5 PASS (day view dark @1100×692 EXPANDED sidebar — zero regressions, no code change)
- Relaunch: `live-app.pid` pointed at a dead proc → `start-review-vm.sh dark`. **Drive-key gotcha (NEW): `view` action reads `command.view` (harness Main.qml:218), NOT `value`** — first drive with `"value":"day"` silently no-opped (capture succeeded, still on month); re-drove `{"action":"view","view":"day"}`. Also resize 1100×692 / `{"action":"sidebar","expanded":true}` / date 2026-04-02.
- Artifacts: `r251-day-dark-full.png` + crops `r251-c1-gutter.png` (2×), `r251-c2-chip.png` (2×), `r251-c3-allday.png` (1:1), `r251-c4-halves.png` (1:1).
- **Gutter two-tone (R243/R244) re-verified in day dark:** digit bright + AM muted, same baseline, ink-centred on hour lines; 12-hour "7 AM"…"4 PM"; first visible 7 AM (R159); pitch 40.
- **Timed chips + R246 secondary re-verified:** title 11 medium top-aligned + Row(clock glyph, spacing 5) + secondary 10 on every chip; formats EXACT — "8 – 8:45AM", "9AM", "10:15 – 10:30AM", "11AM – 1PM" (shared period drops start meridiem), "12PM", "2:30 – 3:30PM", "4PM". Stripe 3, dark fill alpha 0.36, radius 3.
- **T01 side-by-side re-verified in day dark:** 11 AM slot = blue "Long review with a deliberately lengthy title 11AM – 1PM" + green "[R019 LONG TASK] 任务长标题与编辑表单检查 任…" halves with 2px gap, both with glyph+secondary, elided.
- **All-day band:** 全天 label; Design sync / Release notes full-width blue-bar tab chips, single-line elide; `+2` overflow row. Matches R128/R150/R158 pins.
- **Chrome:** day header `周四 2` + today disc on 2; segment pill on 日; heading `2026年4月2日星期四`; `< 今天 >`; search/more; dots; field (30,30,30). Matches R097/R126/R143.
- Verdict: **PASS, zero regressions. Nothing fixed, nothing broken.** All five rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) are now swept clean. Nothing actionable remains; H / Year / R134 tooltip-y / A-B dim+shadow stay ruling-blocked. Next: hold.

## R252 — HOLD round (no code change, no screenshot)
- Next #1 taken verbatim: all 5 rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) swept clean with zero regressions; every actionable spec ID is done. Per the standing ruling and state.md's own "do NOT invent deltas", this round is a pure hold: no code, no build, no relaunch.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R253 — HOLD round (no code change, no screenshot)
- Next #1 taken verbatim: all 5 rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) swept clean with zero regressions; every actionable spec ID is done. Code untouched since R246 ⇒ no regression is even possible; per the standing ruling and state.md's own "do NOT invent deltas", this round is a pure hold: no code, no build, no relaunch.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R254 — HOLD round (no code change, no screenshot)
- Next #1 taken verbatim: all 5 rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) swept clean with zero regressions; every actionable spec ID is done. Code untouched since R246 ⇒ no regression is even possible; per the standing ruling and state.md's own "do NOT invent deltas", this round is a pure hold: no code, no build, no relaunch.
- Pre-round ruling check (NEW this round): spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- state.md 最近已改 window trimmed to 8 (R246/R245/R244 entries moved to this archive; all CLOSED, details in their own round entries above).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R255 — HOLD round (no code change, no screenshot)
- Next #1 taken verbatim: all 5 rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) swept clean with zero regressions; every actionable spec ID is done. Code untouched since R246 ⇒ no regression is even possible; per the standing ruling and state.md's own "do NOT invent deltas", this round is a pure hold: no code, no build, no relaunch.
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- state.md 最近已改 window trimmed to 8 (R247 entry moved to this archive; regression sweep #1 PASS, details in its own round entry above).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R256 — HOLD round (no code change, no screenshot)
- Next #1 taken verbatim: all 5 rotation legs (R247 week exp l+d / R248 day light + week dark collapsed / R249 month light expanded / R250 month dark collapsed + agenda / R251 day dark expanded) swept clean with zero regressions; every actionable spec ID is done. Code untouched since R246 ⇒ no regression is even possible; per the standing ruling and state.md's own "do NOT invent deltas", this round is a pure hold: no code, no build, no relaunch.
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R257 — HOLD round (2026-10-18 00:19)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R258 — HOLD round (2026-10-18 00:21)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R259 — HOLD round (2026-10-18)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- No opportunistic spot-check: code untouched since R246, 5 clean sweeps R247–R251 + R252–R258 holds, nothing suspicious.
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R260 — HOLD round (2026-10-18)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; grep re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 待裁决. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- No opportunistic spot-check: code untouched since R246, 5 clean sweeps R247–R251 + R252–R259 holds, nothing suspicious.
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R261 — HOLD round (2026-10-18)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; sed re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 保持 hold. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- No opportunistic spot-check: code untouched since R246, 5 clean sweeps R247–R251 + R252–R260 holds, nothing suspicious.
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.

## R262 — HOLD round (2026-10-18)
- Pre-round ruling check: spec.md mtime still 2026-10-17 22:50; sed re-confirms spec.md:145 — all-day ring icon (H) / segment 4th word Year / R134 tooltip y / A-B dim+shadow remain 保持 hold. No ruling landed ⇒ nothing to resume.
- Held items re-listed per-round as required: all-day band ring icon (H, ref 12×12 stroke 3 hole 6) · segment 4th word `Year` · R134 tooltip y-discrepancy · dim snap (`KosWorkspaceDialog.qml:24-27`) + shadow magnitude (D03).
- No opportunistic spot-check: code untouched since R246, 5 clean sweeps R247–R251 + R252–R261 holds, nothing suspicious.
- Verdict: HOLD — nothing fixed, nothing broken, nothing invented. Not DONE (ruling-blocked items remain). Next: hold again, or resume the moment a ruling lands on H / Year / R134 tooltip-y / A-B, taking it as the next atomic step.
- R263 — HOLD round. Pre-round: spec.md mtime unchanged (2026-10-17 22:50); grep re-confirms spec.md:145-146 — H (all-day ring icon) / segment 4th word Year / R134 tooltip y / A-B dim+shadow magnitude 保持 hold. No code change, no build, no screenshot (code untouched since R246; R247–R251 sweeps clean; nothing suspicious to spot-check). Ruling-blocked items re-listed in state.md. Verdict: HOLD.
- R264 — HOLD round. Pre-round: spec.md mtime unchanged (2026-10-17 22:50); grep re-confirms spec.md:145-146 — H (all-day ring icon) / segment 4th word Year / R134 tooltip y / A-B dim+shadow magnitude 保持 hold. No code change, no build, no screenshot (code untouched since R246; R247–R251 sweeps clean; nothing suspicious to spot-check). Ruling-blocked items re-listed in state.md. Verdict: HOLD.
- R265 — HOLD round. Pre-round: spec.md mtime unchanged (2026-10-17 22:50); grep re-confirms spec.md:145-146 — H (all-day ring icon) / segment 4th word Year / R134 tooltip y / A-B dim+shadow magnitude 保持 hold. No code change, no build, no screenshot (code untouched since R246; R247–R251 sweeps clean; nothing suspicious to spot-check). Ruling-blocked items re-listed in state.md. Verdict: HOLD.
- R266 — HOLD round. Pre-round: spec.md mtime unchanged (2026-10-17 22:50); sed re-confirms spec.md:145-146 — H (all-day ring icon) / segment 4th word Year / R134 tooltip y / A-B dim+shadow magnitude 保持 hold. No code change, no build, no screenshot (code untouched since R246; R247–R251 sweeps clean; nothing suspicious to spot-check). Ruling-blocked items re-listed in state.md. Verdict: HOLD.
- R267 — HOLD round. Pre-round: spec.md mtime unchanged (2026-10-17 22:50); sed re-confirms spec.md:145-146 — H (all-day ring icon) / segment 4th word Year / R134 tooltip y / A-B dim+shadow magnitude 保持 hold. No code change, no build, no screenshot (code untouched since R246; R247–R251 sweeps clean; nothing suspicious to spot-check). Ruling-blocked items re-listed in state.md. Verdict: HOLD.

## R268 (2026-10-18) — HOLD
- Pre-round check: spec.md mtime unchanged (2026-10-17 22:50) — no new ruling. sed re-confirmed spec.md:145-146: H (all-day ring icon) / Year / R134 tooltip-y / A-B dim+shadow all still 保持 hold.
- No code change, no build, no screenshot. Code untouched since R246; all 5 rotation legs (R247–R251) swept clean; nothing suspicious to spot-check — no delta invented.
- Ruling-blocked items re-listed in state.md 仍差 (per the standing ruling's per-round requirement).
- Verdict: HOLD. Not DONE — H/Year/tooltip-y/A-B still ruling-blocked.

## R269 (2026-10-18) — HOLD
- Pre-round check: spec.md mtime unchanged (2026-10-17 22:50) — no new ruling. sed re-confirmed spec.md:145-146: H (all-day ring icon) / Year / R134 tooltip-y / A-B dim+shadow all still 保持 hold.
- No code change, no build, no screenshot. Code untouched since R246; all 5 rotation legs (R247–R251) swept clean; nothing suspicious to spot-check — no delta invented.
- Ruling-blocked items re-listed in state.md 仍差 (per the standing ruling's per-round requirement).
- Verdict: HOLD. Not DONE — H/Year/tooltip-y/A-B still ruling-blocked.

## R270 (2026-10-18) — HOLD
- Pre-round check: spec.md mtime unchanged (2026-10-17 22:50) — no new ruling. sed re-confirmed spec.md:145-146: H (all-day ring icon) / Year / R134 tooltip-y / A-B dim+shadow all still 保持 hold.
- No code change, no build, no screenshot. Code untouched since R246; all 5 rotation legs (R247–R251) swept clean; nothing suspicious to spot-check — no delta invented.
- Ruling-blocked items re-listed in state.md 仍差 (per the standing ruling's per-round requirement).
- Verdict: HOLD. Not DONE — H/Year/tooltip-y/A-B still ruling-blocked.

## R271 (2026-10-18) — HOLD + regression spot-check (week expanded light)
- Pre-round check: spec.md mtime unchanged (2026-10-17 22:50) — no new ruling. sed re-confirmed spec.md:145-146: H (all-day ring icon) / Year / R134 tooltip-y / A-B dim+shadow all still 保持 hold.
- No code change, no build. Stale pid found dead → relaunched via start-review-vm.sh light, drove resize/sidebar-expanded/view week/date 2026-04-02, captured r271-week-expanded-light.png.
- Spot-check of the R247 leg: PASS — clock glyph + 12-hour two-tone secondary ("8 – 8:45AM" / "11AM - 1PM" / "12PM" shared period), same-hour side-by-side halves (Wed 9 AM, 11 AM, 2 PM pairs), all-day band with "+2" overflow, two-tone gutter, chip height/mass all match. No regression, no delta invented.
- Ruling-blocked items re-listed in state.md 仍差 (per the standing ruling's per-round requirement).
- Verdict: HOLD. Not DONE — H/Year/tooltip-y/A-B still ruling-blocked.

## R272 (2026-10-18) — HOLD + regression spot-check week collapsed light PASS
- Pre-round check: spec.md mtime unchanged (2026-10-17 22:50) — no new ruling. sed re-confirmed spec.md:145-146: H (all-day ring icon) / Year / R134 tooltip-y / A-B dim+shadow all still 保持 hold.
- No code change, no build. Stale pid found dead → relaunched via start-review-vm.sh light, drove resize/sidebar-collapsed/view week/date 2026-04-02, captured r272-week-collapsed-light.png.
- Spot-check leg chosen: week collapsed light — the only leg not covered by the R247–R251 rotation (R247 week expanded light+dark, R248 day light + collapsed week dark, R249 month light expanded, R250 month dark collapsed + agenda, R251 day dark expanded).
- Spot-check verdict: PASS — clock glyph + 12-hour two-tone secondary ("8 – 8:45AM" / "11AM - 1PM" / "12PM" shared period), same-hour side-by-side halves (Wed 9:30 / 11 AM / 2:30 pairs), all-day band "Multi-day review" span + Thu "+2" overflow + Fri "R087 sole", two-tone gutter, weekend column tint, 周 pill selected, Thu-2 today ring, collapsed sidebar renders full-width content. No regression, no delta invented.
- Ruling-blocked items re-listed in state.md 仍差 (per the standing ruling's per-round requirement).
- Verdict: HOLD. Not DONE — H/Year/tooltip-y/A-B still ruling-blocked.

## R273 — HOLD round (no code change, no spot-check)
- Pre-round: spec.md mtime still 2026-10-17 22:50 — no new ruling; H / Year / R134 tooltip-y / A-B dim+shadow re-confirmed 保持 hold (spec.md tail re-read).
- Spot-check skipped: all 6 rotation legs (R247–R251 + R272 week-collapsed-light) already swept clean; nothing suspicious since — per Next-round rule the check is optional.
- Ruling-blocked items re-listed in state.md 仍差 per standing requirement.
- Verdict: HOLD. Nothing fixed, nothing broken, nothing invented.

## R274 — HOLD round + regression spot-check #7: month dark expanded PASS
- Pre-round: spec.md mtime still 2026-10-17 22:50 — no new ruling; H / Year / R134 tooltip-y / A-B dim+shadow re-confirmed 保持 hold (spec.md tail re-read).
- No code change, no build (code untouched since R246).
- Spot-check leg 7 (new combination, unswept): month view, DARK, sidebar EXPANDED, fixture date 2026-04-02. Launched via start-review-vm.sh dark (stale pid dead → fresh launch), drove resize 1280×800 + sidebar expanded:true + view month + date 2026-04-02; capture → r274-month-dark-expanded.png.
- Eyeball verdict: PASS. Dark palette coherent across sidebar / toolbar / month grid / agenda panel; today (Apr 2) cell outlined with +13 badge; multi-day chips span Mon–Wed with +8/+11 truncation badges; chip stripes + truncation behave (no overflow into adjacent cells); agenda panel lists 2 all-day items (Design sync, Release notes) with 14 项 count. No mixed-theme artifacts, no layout breakage.
- Ruling-blocked items re-listed in state.md 仍差 per standing requirement.
- Verdict: HOLD. Nothing fixed, nothing broken, nothing invented.

## R275 — HOLD + regression spot-check #8: month light collapsed PASS (2026-10-18)
- spec.md mtime unchanged (2026-10-17 22:50) — no new ruling; ruling-blocked items re-listed in state.md.
- Fresh launch (old pid dead) → light → 1280×800, sidebar collapsed, view month, date 2026-04-02 → `r275-month-light-collapsed.png`.
- Verdict **PASS**: light palette coherent; today cell 2 outlined + `+13`; multi-day chips Mon–Wed `+6/+6/+11` striped; Design sync / R087 sole / Morning planning chips striped; out-month days muted; agenda panel 14 项 with 2 all-day.
- Anomaly: Apr 15 cell full-cell blue fill + bare `+`, no chips, no fixture data (grep: no 20260415 in profile/). `position` action rejected in month view ("No visible timeline") — pointer never moved, first re-test invalid. Re-drove with `pointer` kind `move` → tint + `+` gone from row 3 (`r275-crop-row3-hover.png`). **It is the hovered-cell highlight + quick-add button, follows the pointer** (R274's Apr-14 tint = same artifact). Benign, macOS-like.
- No code change, no build. HOLD.

## R276 — HOLD + regression spot-check #9: day light collapsed PASS (2026-10-18)
- spec.md mtime unchanged (2026-10-17 22:50) — no new ruling; ruling-blocked items re-listed in state.md.
- Fresh launch (stale pid dead) → light → 1280×800, sidebar collapsed, view day, date 2026-04-02 → `r276-day-light-collapsed.png`.
- Verdict **PASS**: title 2026年4月2日星期四; all-day band Design sync / Release notes / `+2`; timed chips Morning planning 8–8:45AM, Green planning 9AM, Short appointment 10:15–10:30, Long review + [R019 LONG TASK] side-by-side halves at 11AM (T01), Gold review 12PM, Design review 2:30–3:30PM, Red review 4PM, Evening session 6–7:30PM — every secondary carries the clock glyph (R246); gutter digit+AM two-tone same baseline (R243); 12-hour shared-meridiem `8 – 8:45AM` (R246). No hover-tint artifact this launch; no mixed theme; no layout breakage.
- Crop check `/tmp/r276-crop-gutter.png` (2×): glyph ring+hands left of secondary, gap ~4, baseline-aligned; gutter two-tone intact.
- No code change, no build. HOLD. Regression sweep now 9/11 legs; remaining unswept: day dark collapsed.
