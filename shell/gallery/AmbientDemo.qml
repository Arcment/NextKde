import QtQuick
import qs.desktop.modules.common

// G5b — ambient light transition (SPEC §2.7): 2600ms.
//
// Production owner is LiquidGlassSurface.ambientTransitionDuration: 2600 with
// InOutSine, restarted at full duration from the currently displayed colours.
// reduceMotion is not a production switch there; the gallery derives it from
// the panel and skips the transition (effective 0), settling on the target.
//
// A static screenshot starts on the t=0.5 sample so the blend reads as a
// blend; clicking toggles between the two end swatches.
Item {
    id: root

    property bool reduceMotion: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property color endA: "#c08a5a"
    readonly property color endB: "#5a8fb0"
    readonly property int tokenDuration: 2600
    readonly property int effectiveDuration: reduceMotion ? 0 : tokenDuration

    property bool atB: false
    property bool running: false
    property real progress: reduceMotion ? 0 : 0.5

    readonly property color displayColor: mix(endA, endB, progress)

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t,
                       a.g + (b.g - a.g) * t,
                       a.b + (b.b - a.b) * t,
                       1.0)
    }

    function stateLabel() {
        if (root.running)
            return "running"
        if (root.reduceMotion)
            return "skipped"
        return (root.progress > 0.001 && root.progress < 0.999)
            ? "sampled" : "settled"
    }

    function toggle() {
        root.atB = !root.atB
        var target = root.atB ? 1.0 : 0.0
        if (root.reduceMotion) {
            // Ambient transition skipped: land on the end colour directly.
            flow.stop()
            root.progress = target
            root.running = false
            return
        }
        root.running = true
        // Production restarts the full 2600ms from the current colours rather
        // than scaling by remaining distance.
        flow.from = root.progress
        flow.to = target
        flow.start()
    }

    onReduceMotionChanged: {
        flow.stop()
        root.running = false
        root.atB = false
        root.progress = root.reduceMotion ? 0 : 0.5
    }

    NumberAnimation {
        id: flow
        target: root
        property: "progress"
        duration: root.tokenDuration
        easing.type: Easing.InOutSine
        onFinished: root.running = false
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ── end swatches + token ────────────────────────────────────
        Row {
            width: parent.width
            height: 76
            spacing: 12

            Column {
                spacing: 3

                Rectangle {
                    width: 74
                    height: 52
                    radius: 10
                    color: root.endA
                    border.width: 1
                    border.color: root.hairline
                }
                Text {
                    text: "A 起点"
                    color: root.inkDim
                    font.pixelSize: 10
                }
            }

            Item {
                width: parent.width - 74 * 2 - 24
                height: 76

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.tokenDuration + "ms"
                        color: root.ink
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                        font.family: "monospace"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "InOutSine"
                        color: root.inkDim
                        font.pixelSize: 10
                    }
                }
            }

            Column {
                spacing: 3

                Rectangle {
                    width: 74
                    height: 52
                    radius: 10
                    color: root.endB
                    border.width: 1
                    border.color: root.hairline
                }
                Text {
                    text: "B 终点"
                    color: root.inkDim
                    font.pixelSize: 10
                }
            }
        }

        // ── live blend plate ────────────────────────────────────────
        Rectangle {
            width: parent.width
            height: 54
            radius: 10
            color: root.displayColor
            border.width: 1
            border.color: root.hairline

            Text {
                anchors.centerIn: parent
                text: "mix " + Math.round(root.progress * 100) + "%"
                color: "#ffffff"
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }

            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 6
                text: "progress " + root.progress.toFixed(3)
                color: "#ffffff"
                opacity: 0.8
                font.pixelSize: 9
                font.family: "monospace"
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 2

            Text {
                text: "progress  " + root.progress.toFixed(3)
                color: root.ink
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "effective  " + root.effectiveDuration + "ms"
                    + (root.reduceMotion ? "（reduceMotion · 跳过）"
                                         : " · InOutSine")
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "state  " + root.stateLabel()
                    + " · target " + (root.atB ? "B" : "A")
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
        }

        // ── toggle ──────────────────────────────────────────────────
        Row {
            width: parent.width
            height: 26
            spacing: 12

            Rectangle {
                width: 96
                height: 26
                radius: 8
                anchors.verticalCenter: parent.verticalCenter
                color: ambientMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "切换到 " + (root.atB ? "A" : "B")
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: ambientMouse
                    anchors.fill: parent
                    onClicked: root.toggle()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "点击在两端之间切换"
                color: root.inkDim
                font.pixelSize: 10
            }
        }
    }
}
