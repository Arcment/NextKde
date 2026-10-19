import QtQuick
import Quickshell
import qs.desktop.modules.common
import "components"

// G2 — popup page. G2a ships the skeleton and GlassPopover, G2b adds
// GlassMenu, G2c adds GlassTooltip, G2d adds GlassToast; Notification is
// still a placeholder for G2e.
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    // Screenshot hook: run.sh only exports GALLERY_THEME, so shot.sh exports
    // GALLERY_POPUP in front of the call and it is inherited here.
    readonly property string demo: Quickshell.env("GALLERY_POPUP") || ""
    readonly property var demoNames: ["Popover", "Menu", "Tooltip", "Toast", "Notification", "Dialog"]
    // GlassDialog is declared at GalleryRoot level so its scrim can cover the
    // whole window (nav and parameter panel included); this page drives it.
    property Item dialog: null
    property bool reduceMotionOn: false
    // G3b — strictly one scrim source at a time. The root owns the value so
    // GALLERY_SCRIM can seed it before the page exists; these buttons only
    // request a change. "both" is the intentional violation demo.
    property string scrimMode: "compositor"
    readonly property var scrimModes: ["compositor", "qml", "both"]
    readonly property string scrimNote:
        page.scrimMode === "compositor"
            ? "compositor scrim 单一来源：卡片 useKwinEffect + balanced，QML 不画背板"
            : page.scrimMode === "qml"
                ? "QML fallback：全窗黑 0.32 背板，卡片走 QML 液态回退"
                : "违规：compositor scrim × QML 背板同时开，卡片双重变暗（2px 红边）"
    signal scrimModeSelected(string mode)
    // The 360px card needs the summary column's space; the two are shown
    // one at a time so the in-page card never overlaps the token list.
    property bool notificationShown: false

    function showPopover() {
        popover.open(anchorRepeater.itemAt(0))
    }
    function showMenu() {
        menu.resetFocus()
        menu.open(anchorRepeater.itemAt(1))
    }
    function showTooltip() {
        tooltip.open(anchorRepeater.itemAt(2))
    }
    // Both toasts share the same copy so only the surface differs.
    function showToasts() {
        feedbackToast.show("已保存到相册", "check")
        glassToast.show("已保存到相册", "check")
    }
    function showNotification() {
        notificationShown = true
    }
    function showDialog() {
        if (page.dialog)
            page.dialog.open()
    }
    function closeActive() {
        popover.close()
        menu.close()
        tooltip.close()
        feedbackToast.dismiss()
        glassToast.dismiss()
        notificationShown = false
        // Esc also closes the modal; its shortcut stays here because the
        // gallery window owns keyboard focus.
        if (page.dialog)
            page.dialog.close()
    }
    function openDemo(index) {
        page.closeActive()
        if (index === 0)
            page.showPopover()
        else if (index === 1)
            page.showMenu()
        else if (index === 2)
            page.showTooltip()
        else if (index === 3)
            page.showToasts()
        else if (index === 4)
            page.showNotification()
        else if (index === 5)
            page.showDialog()
    }
    // Tooltip hover contract: 700ms dwell opens, leaving closes at once.
    // 700ms is extrapolated (SPEC does not fix a dwell time).
    function anchorHoverChanged(index, hovered) {
        if (index !== 2)
            return
        if (hovered) {
            tooltipHoverTimer.restart()
        } else {
            tooltipHoverTimer.stop()
            tooltip.close()
        }
    }

    Timer {
        id: tooltipHoverTimer
        interval: 700
        repeat: false
        onTriggered: page.showTooltip()
    }

    // The gallery window has laid out by then; opening on completion alone can
    // anchor to a zero-size item and place the popup at the output origin.
    Timer {
        interval: 300
        running: page.demo === "popover" || page.demo === "menu"
            || page.demo === "tooltip" || page.demo === "toast"
            || page.demo === "notification" || page.demo === "dialog"
        repeat: false
        onTriggered: page.openDemo(page.demo === "notification" ? 4
            : page.demo === "toast" ? 3
            : page.demo === "tooltip" ? 2
            : page.demo === "menu" ? 1
            : page.demo === "dialog" ? 5 : 0)
    }

    Shortcut {
        sequence: "Esc"
        onActivated: page.closeActive()
    }
    // Menu keyboard contract. The gallery window owns keyboard focus after
    // the anchor click, so the shortcuts live here rather than in the popup.
    Shortcut {
        sequence: "Up"
        enabled: menu.shown
        onActivated: menu.move(-1)
    }
    Shortcut {
        sequence: "Down"
        enabled: menu.shown
        onActivated: menu.move(1)
    }
    Shortcut {
        sequence: "Return"
        enabled: menu.shown
        onActivated: menu.activate()
    }

    Text {
        x: 0
        y: 0
        text: "弹层"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width
        text: "Popover · Menu · Tooltip · Toast · Notification — 基准组件只服务 gallery"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    // ── anchor row ──────────────────────────────────────────────────────
    Row {
        id: anchorRow
        x: 0
        y: 64
        spacing: 8

        Repeater {
            id: anchorRepeater
            model: page.demoNames

            delegate: Rectangle {
                required property var modelData
                required property int index

                width: label.implicitWidth + 28
                height: 34
                radius: 10
                color: mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                border.width: 1
                border.color: page.inkDim

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: modelData
                    color: page.ink
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onContainsMouseChanged: page.anchorHoverChanged(index, containsMouse)
                    onClicked: page.openDemo(index)
                }
            }
        }
    }

    // ── scrim source row (G3b) ──────────────────────────────────────────
    Row {
        id: scrimRow
        x: 0
        y: 108
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "scrim"
            color: page.inkDim
            font.pixelSize: 12
        }

        Repeater {
            model: page.scrimModes

            delegate: Rectangle {
                required property var modelData

                readonly property bool selected: page.scrimMode === modelData

                width: scrimLabel.implicitWidth + 28
                height: 30
                radius: 9
                color: selected
                    ? Qt.rgba(1, 1, 1, 0.16)
                    : scrimMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                border.width: 1
                border.color: selected ? page.ink : page.inkDim

                Text {
                    id: scrimLabel
                    anchors.centerIn: parent
                    text: modelData
                    color: page.ink
                    font.pixelSize: 12
                    font.weight: selected ? Font.DemiBold : Font.Medium
                }
                MouseArea {
                    id: scrimMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: page.scrimModeSelected(modelData)
                }
            }
        }
    }

    Text {
        x: 0
        y: 146
        width: parent.width
        text: page.scrimNote
        color: page.inkDim
        font.pixelSize: 11
        elide: Text.ElideRight
    }

    // ── token summary ───────────────────────────────────────────────────
    Column {
        x: 0
        y: 294
        width: page.width
        spacing: 5
        visible: !page.notificationShown

        Text {
            text: "GlassPopover（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "radius 16 · padding 12 · material regular · cornerExponent 2.0 · stroke 1"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "阴影 0.30 / offset 12,16 / softness 18 · 锚点间距 8（外推，SPEC 未定）"
            color: page.inkDim
            font.pixelSize: 12
        }

        Item { width: 1; height: 8 }

        Text {
            text: "GlassMenu（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "padding 8 · 项高 28 · item radius 8 · 项间距 4 · Body 13 · 分隔线 1px"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "Esc 关闭 · Up/Down 移动焦点 · Enter 触发 · focus 环 = 1px 描边 + 提亮"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "同一宿主 AnimatedPopupWindow · open 150 / close 140 · startScale 0.96"
            color: page.inkDim
            font.pixelSize: 12
        }

        Item { width: 1; height: 8 }

        Text {
            text: "GlassTooltip（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "material thick · radius 10 · Callout 12 SemiBold · Footnote 10 Medium"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "显隐 70ms · 朝向锚点 margin -6（SPEC §7 裁定项）· 悬停 700ms 显示（外推）· 移出即关"
            color: page.inkDim
            font.pixelSize: 12
        }

        Item { width: 1; height: 8 }

        Text {
            text: "GlassToast（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "regular · scrim readable · h 36 / radius 18 · Callout 12 Medium · 显 150 / 隐 180 · 存留 1600ms"
            color: page.inkDim
            font.pixelSize: 12
        }

        Item { width: 1; height: 8 }

        Text {
            text: "GlassDialog（G3a 基准 · 页内模态）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "thick · radius 24 · padding 20 · 标题 22/26 SemiBold · 正文 13/16"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "按钮高 28 · 行 gap 8 · 宽 360（外推，SPEC 未定）· 点背板关闭（外推）"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "四态 opening / open / closing / closed · open 150 OutCubic · close 140 InCubic · scale 0.96→1"
            color: page.inkDim
            font.pixelSize: 12
        }
    }

    // ── toast host (bottom centre) ──────────────────────────────────────
    // Persistent host for G2d. The two toasts share the copy so the surface
    // is the only difference; captions label the active and baseline pair.
    Column {
        id: toastHost
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 6

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Rectangle {
                width: 76
                height: 36
                radius: 18
                color: sendMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                border.width: 1
                border.color: page.inkDim

                Text {
                    anchors.centerIn: parent
                    text: "发一条"
                    color: page.ink
                    font.pixelSize: 12
                    font.weight: Font.Medium
                }
                MouseArea {
                    id: sendMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: page.showToasts()
                }
            }

            Column {
                spacing: 4

                ActionFeedbackToast {
                    id: feedbackToast
                    anchors.horizontalCenter: parent.horizontalCenter
                    // Gallery window paints in QML, not through the KWin effect.
                    useKwinEffect: false
                    fallbackEnabled: true
                    // Demo mode holds it on screen; the real timeout is 1600ms.
                    timeout: page.demo === "toast" ? 600000 : 1600
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "现役 ActionFeedbackToast"
                    color: page.inkDim
                    font.pixelSize: 11
                }
            }

            Column {
                spacing: 4

                GlassToast {
                    id: glassToast
                    anchors.horizontalCenter: parent.horizontalCenter
                    // timeout 0 = demo hold (SPEC §7-① pending).
                    timeout: page.demo === "toast" ? 0 : 1600
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "基准 GlassToast"
                    color: page.inkDim
                    font.pixelSize: 11
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: page.demo === "toast"
            text: "演示模式常显；实际存留 1600ms（SPEC §7-① 待裁定）"
            color: page.inkDim
            font.pixelSize: 11
        }
    }

    // ── notification card (G2e) ─────────────────────────────────────────
    Item {
        id: notificationHost
        visible: page.notificationShown
        x: (page.width - width) / 2
        y: 100
        width: 360
        height: notificationCard.height + 8 + caption.implicitHeight

        GlassNotificationCard {
            id: notificationCard
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: caption
            anchors.top: notificationCard.bottom
            anchors.topMargin: 8
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "G2e 基准 · 容器 radius 24 · entry / 分组 pill radius 16 · 17 / 13 / 11 / 10 · hover 描边 + 提亮"
            color: page.inkDim
            font.pixelSize: 11
            wrapMode: Text.WordWrap
        }
    }

    GlassPopover {
        id: popover
    }

    GlassMenu {
        id: menu
    }

    GlassTooltip {
        id: tooltip
    }
}
