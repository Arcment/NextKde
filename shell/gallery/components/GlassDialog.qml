import QtQuick
import qs.desktop.modules.common

// G3a — gallery-local modal dialog baseline. This is an in-page overlay,
// not a new window, and it deliberately does not reuse the live control.
//
// Correspondence with the foundation (mapping, not reuse):
//   • shared/qml/foundation/KosDialog.qml is a QtQuick Controls Dialog driven
//     by revealProgress + closing. The same contract is expressed here as a
//     four-state machine: opening / open / closing / closed.
//   • shell/desktop/modules/common/PopupMotion.qml fixes open 150ms OutCubic,
//     close 140ms InCubic and the 0.96→1 scale. The gallery re-implements
//     those numbers in-page because the dialog must stay inside the gallery
//     surface (no second layer window) and must not reuse the live widget.
//   • The compositor scrim is the single source in normal use; the QML
//     backdrop is the qml-fallback demonstration only (see scrimMode).
//
// Tokens (SPEC §3.2): surface radius 24, material thick, Title1 22/26
// SemiBold, Body 13/16, button height 28, padding 20. Width 360 is
// extrapolated — SPEC does not fix the dialog width.
Item {
    id: root

    // Screenshot/demo contract shared with PopupsPage. "compositor" is the
    // legal production pairing; "both" exists only to show the violation.
    property string scrimMode: "compositor" // compositor | qml | both
    readonly property bool compositorScrim:
        scrimMode === "compositor" || scrimMode === "both"
    readonly property bool qmlScrim:
        scrimMode === "qml" || scrimMode === "both"
    readonly property bool violation: scrimMode === "both"

    property bool reduceMotion: false
    property real cardWidth: 360
    property real cardPadding: 20
    property real cardRadius: 24

    // Four-state lifecycle, mirroring KosDialog's revealProgress + closing.
    property string dialogState: "closed" // opening | open | closing | closed
    property real progress: 0
    property bool requestedOpen: false

    readonly property int openDuration: AppearanceTokens.motion.popupOpenDuration
    readonly property int closeDuration: AppearanceTokens.motion.popupCloseDuration

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)

    visible: dialogState !== "closed"
    // Modal overlay: swallows every click while it is up. The QML backdrop
    // only paints in qml/both — in compositor mode the click-catcher stays
    // transparent so the compositor scrim is the only darkening.
    z: 1000

    function open() {
        if (dialogState === "opening" || dialogState === "open")
            return
        requestedOpen = true
        dialogState = "opening"
        animateTo(1, openDuration, Easing.OutCubic)
    }

    function close() {
        if (dialogState === "closed" || dialogState === "closing")
            return
        requestedOpen = false
        dialogState = "closing"
        animateTo(0, closeDuration, Easing.InCubic)
    }

    function animateTo(target, fullDuration, easingType) {
        animation.stop()
        if (reduceMotion) {
            // No motion: settle on the target state in the same call.
            progress = target
            settle()
            return
        }
        // Scaling the duration by the remaining distance keeps an interrupted
        // open/close at the same speed (the PopupMotion contract).
        const remaining = Math.abs(target - progress)
        animation.duration = Math.max(1, Math.round(fullDuration * remaining))
        animation.easing.type = easingType
        animation.to = target
        animation.start()
    }

    function settle() {
        if (requestedOpen) {
            dialogState = "open"
        } else {
            dialogState = "closed"
            progress = 0
        }
    }

    property NumberAnimation animation: NumberAnimation {
        target: root
        property: "progress"
        onFinished: root.settle()
    }

    // ── QML backdrop (qml / both modes only) ────────────────────────────
    Rectangle {
        anchors.fill: parent
        visible: root.qmlScrim
        color: Qt.rgba(0, 0, 0, 0.32)
        opacity: root.progress
    }

    // Click-outside-to-close. A deliberate addition on top of SPEC §3.2;
    // recorded in the gallery ledger.
    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    // ── card ────────────────────────────────────────────────────────────
    Item {
        id: cardHost
        anchors.centerIn: parent
        width: root.cardWidth
        height: card.height
        // PopupMotion scale contract; centred because the card is the item.
        scale: root.reduceMotion ? 1 : 0.96 + 0.04 * root.progress
        opacity: root.progress

        // A click inside the card must not reach the backdrop MouseArea.
        MouseArea {
            anchors.fill: parent
        }

        KosCardShadow {
            id: shadow
            x: -margin
            y: -margin
            castEnabled: true
            cardWidth: card.width
            cardHeight: card.height
            cornerRadius: card.radius
            cornerExponent: card.cornerExponent
            offsetX: 12
            offsetY: 16
            softness: 18
            shadowColor: Qt.rgba(0.5, 0.5, 0.5, 0.30)
        }

        LiquidGlassPanel {
            id: card
            width: root.cardWidth
            height: body.implicitHeight + root.cardPadding * 2
            radius: root.cardRadius
            cornerExponent: 2.0
            material: "thick"
            // compositor scrim mode: KWin owns the finish and the scrim.
            // qml mode: the QML liquid fallback paints the card instead.
            useKwinEffect: root.compositorScrim
            scrimEnabled: root.compositorScrim
            scrimLevel: "balanced"

            Column {
                id: body
                anchors.fill: parent
                anchors.margins: root.cardPadding
                spacing: 12

                Text {
                    width: parent.width
                    text: "保存更改？"
                    color: root.ink
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    lineHeight: 26
                    lineHeightMode: Text.FixedHeight
                }

                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: "基准 GlassDialog：仅用于 gallery 演示，不替代现役 KosDialog。"
                    color: root.inkDim
                    font.pixelSize: 13
                    lineHeight: 16
                    lineHeightMode: Text.FixedHeight
                }

                Item { width: 1; height: 2 }

                // Cancel / Save, right-aligned, gap 8, height 28.
                Row {
                    anchors.right: parent.right
                    spacing: 8

                    Rectangle {
                        width: cancelLabel.implicitWidth + 28
                        height: 28
                        radius: 8
                        color: cancelMouse.containsMouse
                            ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                        border.width: 1
                        border.color: AppearanceTokens.content.glassInk(0.22)

                        Text {
                            id: cancelLabel
                            anchors.centerIn: parent
                            text: "取消"
                            color: root.ink
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }
                        MouseArea {
                            id: cancelMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.close()
                        }
                    }

                    Rectangle {
                        width: saveLabel.implicitWidth + 28
                        height: 28
                        radius: 8
                        color: saveMouse.containsMouse
                            ? Qt.darker(AppearanceTokens.colors.primary, 1.08)
                            : AppearanceTokens.colors.primary

                        Text {
                            id: saveLabel
                            anchors.centerIn: parent
                            text: "保存"
                            color: AppearanceTokens.colors.primaryForeground
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }
                        MouseArea {
                            id: saveMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.close()
                        }
                    }
                }
            }
        }

        // 1px stroke (token). LiquidGlassPanel leaves the edge to KWin in the
        // shell; this in-page card draws it itself.
        Rectangle {
            x: card.x
            y: card.y
            width: card.width
            height: card.height
            radius: card.radius
            color: "transparent"
            border.width: 1
            border.color: AppearanceTokens.content.glassInk(0.16)
        }

        // "both" only: the compositor scrim and the QML backdrop are both on.
        Rectangle {
            visible: root.violation
            x: card.x
            y: card.y
            width: card.width
            height: card.height
            radius: card.radius
            color: "transparent"
            border.width: 2
            border.color: "#e53935"
        }
        Text {
            visible: root.violation
            anchors.top: card.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width + 200
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: "违规：compositor scrim × QML 背板双重变暗"
            color: "#e53935"
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }
}
