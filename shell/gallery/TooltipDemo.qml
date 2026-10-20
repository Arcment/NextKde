import QtQuick
import qs.desktop.modules.common

// G5c — tooltip show/hide (SPEC §2.7): 70ms open / 70ms close.
//
// Mirrors the gallery baseline GlassTooltip: material thick, radius 10, the
// side facing the anchor overlaps it by 6px, and the shared PopupMotion
// semantics (open OutCubic, close InCubic, duration scaled by remaining
// progress, startScale 0.96). The surface is painted inline so the demo can
// carry progress/effective/state readings in one static frame; the real
// component remains a PopupWindow and is unchanged.
//
// reduceMotion collapses both effective durations to 0 and the tooltip snaps
// between shown and hidden.
Item {
    id: root

    property bool reduceMotion: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property int openToken: 70
    readonly property int closeToken: 70
    readonly property int openEffective: reduceMotion ? 0 : openToken
    readonly property int closeEffective: reduceMotion ? 0 : closeToken
    readonly property real startScaleToken: 0.96
    readonly property real anchorOffset: -6

    // Seeded shown so the static screenshot carries the surface itself; the
    // buttons replay the real transition from here.
    property bool shown: true
    property real progress: 1.0
    property bool moving: false
    property string lastEvent: "seed"

    function stateLabel() {
        if (root.moving)
            return "animating"
        if (root.progress > 0.999)
            return "shown"
        if (root.progress < 0.001)
            return "hidden"
        return "sampled"
    }

    function animateTo(target) {
        motion.stop()
        root.moving = false
        if (root.reduceMotion) {
            root.progress = target
            return
        }
        var fullDuration = target > root.progress
            ? root.openToken : root.closeToken
        motion.from = root.progress
        motion.to = target
        // PopupMotion scales by remaining progress and never runs below 1ms.
        motion.duration = Math.max(1,
            Math.round(fullDuration * Math.abs(target - root.progress)))
        motion.easing.type = target > root.progress
            ? Easing.OutCubic : Easing.InCubic
        root.moving = true
        motion.start()
    }

    function showTip() {
        root.shown = true
        root.lastEvent = "显示"
        root.animateTo(1.0)
    }

    function hideTip() {
        root.shown = false
        root.lastEvent = "隐藏"
        root.animateTo(0.0)
    }

    onReduceMotionChanged: {
        motion.stop()
        root.moving = false
        root.progress = root.shown ? 1.0 : 0.0
    }

    NumberAnimation {
        id: motion
        target: root
        property: "progress"
        onFinished: root.moving = false
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ── stage: anchor + attached tooltip ────────────────────────
        Rectangle {
            width: parent.width
            height: 118
            radius: 10
            color: Qt.rgba(0, 0, 0, 0.18)
            border.width: 1
            border.color: root.hairline

            Rectangle {
                x: 20
                y: 18
                width: 96
                height: 30
                radius: 15
                color: Qt.rgba(1, 1, 1, 0.14)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "锚点"
                    color: root.ink
                    font.pixelSize: 11
                }
            }

            // The tooltip hangs below the anchor and overlaps it by 6px, the
            // same anchor-side margin GlassTooltip uses.
            LiquidGlassPanel {
                x: 20
                y: 18 + 30 + root.anchorOffset
                width: 208
                height: 48
                radius: 10
                cornerExponent: 2.0
                material: "thick"
                useKwinEffect: false
                scrimEnabled: true
                scrimLevel: "balanced"
                opacity: root.progress
                scale: root.startScaleToken
                    + (1 - root.startScaleToken) * root.progress
                transformOrigin: Item.Top

                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "GlassTooltip"
                        color: root.ink
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "material thick · radius 10 · 70ms"
                        color: root.inkDim
                        font.pixelSize: 10
                        font.weight: Font.Medium
                    }
                }
            }

            Text {
                x: 20 + 96 + 12
                y: 18
                width: parent.width - x - 12
                height: 30
                verticalAlignment: Text.AlignVCenter
                text: "70ms · OutCubic / InCubic · anchorOffset 6px"
                color: root.inkDim
                font.pixelSize: 10
                elide: Text.ElideRight
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 2

            Text {
                text: "progress  " + root.progress.toFixed(3)
                    + "   scale " + (root.startScaleToken
                        + (1 - root.startScaleToken) * root.progress).toFixed(3)
                color: root.ink
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "effective  open " + root.openEffective + "ms OutCubic"
                    + " · close " + root.closeEffective + "ms InCubic"
                    + (root.reduceMotion ? "（reduceMotion）" : "")
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "state  " + root.stateLabel() + " · last " + root.lastEvent
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
        }

        // ── trigger ─────────────────────────────────────────────────
        Row {
            width: parent.width
            height: 26
            spacing: 8

            Rectangle {
                width: 64
                height: 26
                radius: 8
                color: showMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "显示"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: showMouse
                    anchors.fill: parent
                    onClicked: root.showTip()
                }
            }

            Rectangle {
                width: 64
                height: 26
                radius: 8
                color: hideMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "隐藏"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: hideMouse
                    anchors.fill: parent
                    onClicked: root.hideTip()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "点击在显示 / 隐藏之间重播 70ms"
                color: root.inkDim
                font.pixelSize: 10
            }
        }
    }
}
