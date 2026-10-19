import QtQuick
import qs.desktop.modules.common

// G5c — toast retention (SPEC §2.7): 2600ms hold + hover pause.
//
// Mirrors the G2d gallery baseline GlassToast surface (material regular,
// scrim readable, 36px tall, pill radius, Callout 12 Medium) and its entry
// motion (show 150ms / hide 180ms OutCubic, 0.96 -> 1 scale). The retention
// clock is the token under test: 2600ms. SPEC §7-① has ruled B (2600ms with
// hover pause), so the demo labels that ruling and keeps the static hold.
//
// The toast is seeded shown and the hold clock is not started, matching the
// existing toast demo's "演示常显" convention: a static screenshot can show
// the surface and the token but cannot prove the 2600ms hold. Clicking
// 发一条 restarts the real clock. reduceMotion makes show/hide and the hold
// duration effective 0, so the toast appears and dismisses in the same frame.
Item {
    id: root

    property bool reduceMotion: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property int showToken: 150
    readonly property int hideToken: 180
    readonly property int holdToken: 2600
    readonly property int showEffective: reduceMotion ? 0 : showToken
    readonly property int hideEffective: reduceMotion ? 0 : hideToken
    readonly property int holdEffective: reduceMotion ? 0 : holdToken

    // Seeded shown for the static frame; the hold clock starts on 发一条.
    property bool shown: true
    property bool holding: false
    property int remaining: holdToken
    property string lastEvent: "seed"

    function stateLabel() {
        if (root.holding)
            return "holding"
        return root.shown ? "shown" : "dismissed"
    }

    function showToast() {
        root.shown = true
        root.lastEvent = "发一条"
        if (root.holdEffective <= 0) {
            // reduceMotion: the retention duration is 0, so it is gone in the
            // same frame. Nothing to count down.
            root.holding = false
            root.remaining = 0
            root.shown = false
            root.lastEvent = "发一条 · 存留 0ms"
            return
        }
        root.holding = true
        root.remaining = root.holdEffective
        hold.restart()
        tick.restart()
    }

    function dismissToast() {
        hold.stop()
        tick.stop()
        root.holding = false
        root.shown = false
        root.remaining = 0
        root.lastEvent = "手动关闭"
    }

    onReduceMotionChanged: {
        hold.stop()
        tick.stop()
        root.holding = false
        // Read the switch directly: holdEffective's binding may not have
        // re-evaluated yet when this handler runs, which would leave the
        // readout on the 2600ms token value.
        root.remaining = root.reduceMotion ? 0 : root.holdToken
        if (root.reduceMotion)
            root.lastEvent = "reduceMotion · 时长 0"
    }

    Timer {
        id: hold
        // The retention budget itself; 0 is handled before start.
        interval: root.holdEffective
        onTriggered: {
            root.holding = false
            root.shown = false
            root.remaining = 0
            root.lastEvent = "存留到期"
            tick.stop()
        }
    }

    Timer {
        id: tick
        interval: 100
        repeat: true
        onTriggered: {
            root.remaining = Math.max(0, root.remaining - interval)
            if (root.remaining <= 0)
                stop()
        }
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ── stage ───────────────────────────────────────────────────
        Rectangle {
            width: parent.width
            height: 96
            radius: 10
            color: Qt.rgba(0, 0, 0, 0.18)
            border.width: 1
            border.color: root.hairline

            // Baseline GlassToast surface: regular, scrim readable, 36px
            // tall pill, Callout 12 Medium.
            LiquidGlassPanel {
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - height) / 2
                width: 216
                height: 36
                radius: height / 2
                material: "regular"
                scrimEnabled: AppearanceTokens.surface.usesBackdrop
                scrimLevel: "readable"
                useKwinEffect: false
                fallbackEnabled: AppearanceTokens.surface.paintInQml
                opacity: root.shown ? 1 : 0
                scale: root.shown ? 1 : 0.96

                Behavior on opacity {
                    enabled: !root.reduceMotion
                    NumberAnimation {
                        duration: root.shown
                            ? root.showEffective : root.hideEffective
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on scale {
                    enabled: !root.reduceMotion
                    NumberAnimation {
                        duration: root.shown
                            ? root.showEffective : root.hideEffective
                        easing.type: Easing.OutCubic
                    }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 7

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "✓"
                        color: root.ink
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "已复制到剪贴板"
                        color: root.ink
                        font.pixelSize: 12
                        font.weight: Font.Medium
                    }
                }
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 2

            Text {
                text: "hold  " + root.holdToken + "ms → effective "
                    + root.holdEffective + "ms · §7-① 已裁定 B"
                color: root.ink
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "effective  show " + root.showEffective + "ms"
                    + " · hide " + root.hideEffective + "ms OutCubic"
                    + (root.reduceMotion ? "（reduceMotion）" : "")
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "state  " + root.stateLabel() + " · remaining "
                    + root.remaining + "ms · last " + root.lastEvent
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
                width: 72
                height: 26
                radius: 8
                color: sendMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "发一条"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: sendMouse
                    anchors.fill: parent
                    onClicked: root.showToast()
                }
            }

            Rectangle {
                width: 72
                height: 26
                radius: 8
                color: dismissMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "关闭"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: dismissMouse
                    anchors.fill: parent
                    onClicked: root.dismissToast()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "发一条后按 2600ms 存留倒计时 · 悬停暂停见裁定页 B 栏；截图为演示常显"
                color: root.inkDim
                font.pixelSize: 10
            }
        }
    }
}
