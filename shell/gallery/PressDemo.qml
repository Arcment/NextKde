import QtQuick
import qs.desktop.modules.common

// G5b — liquid press expansion (SPEC §2.7): idle 0 / hovered 0.3 /
// pressed 1.0. The three token states sit side by side; the live pill below
// replays one press + release bounce on click.
//
// Durations follow the same gallery mapping G4's GlassButton uses
// (components/controls/ControlTokens.qml): press = motion.normalDuration
// 200ms OutBack, release = motion.slowDuration 360ms OutQuint. reduceMotion
// collapses both to 0 and the bounce settles in the same call.
Item {
    id: root

    property bool reduceMotion: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property int pressToken: AppearanceTokens.motion.normalDuration
    readonly property int releaseToken: AppearanceTokens.motion.slowDuration
    readonly property int pressEffective: reduceMotion ? 0 : pressToken
    readonly property int releaseEffective: reduceMotion ? 0 : releaseToken

    property real liveExpansion: 0.0
    property bool livePressed: false
    // idle (never pressed) | pressed (held) | released (bounce returned)
    property string lastEvent: "idle"

    readonly property var stateSamples: [
        { name: "idle", value: 0.0 },
        { name: "hovered", value: 0.3 },
        { name: "pressed", value: 1.0 }
    ]

    // Press overshoots (OutBack), release settles slowly (OutQuint); both are
    // the values GlassButton already uses for this token.
    Behavior on liveExpansion {
        enabled: !root.reduceMotion
        NumberAnimation {
            duration: root.livePressed ? root.pressToken : root.releaseToken
            easing.type: root.livePressed ? Easing.OutBack : Easing.OutQuint
            easing.overshoot: root.livePressed ? 1.25 : 1.0
        }
    }

    function beginPress() {
        root.livePressed = true
        root.lastEvent = "pressed"
        root.liveExpansion = 1.0
    }

    function endPress() {
        if (!root.livePressed)
            return
        root.livePressed = false
        root.lastEvent = "released"
        root.liveExpansion = 0.0
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ── three token states side by side ─────────────────────────
        Row {
            width: parent.width
            spacing: 12

            Repeater {
                model: root.stateSamples

                delegate: Column {
                    required property var modelData

                    width: (root.width - 24) / 3
                    spacing: 4

                    Rectangle {
                        width: parent.width
                        height: 60
                        radius: 10
                        color: Qt.rgba(0, 0, 0, 0.18)
                        border.width: 1
                        border.color: root.hairline

                        Rectangle {
                            anchors.centerIn: parent
                            width: 104
                            height: 40
                            radius: 20
                            // Same proxy GlassButton uses: the body grows with
                            // the token expansion, it is never a literal.
                            scale: 0.88 + 0.12 * modelData.value
                            color: Qt.rgba(1, 1, 1, 0.14 + 0.20 * modelData.value)
                            border.width: 1
                            border.color: Qt.rgba(1, 1, 1, 0.28)

                            Text {
                                anchors.centerIn: parent
                                text: modelData.value.toFixed(1)
                                color: root.ink
                                font.pixelSize: 11
                                font.family: "monospace"
                            }
                        }
                    }

                    Text {
                        text: modelData.name + " · " + modelData.value.toFixed(3)
                        color: root.inkDim
                        font.pixelSize: 10
                        font.family: "monospace"
                    }
                }
            }
        }

        // ── live press target ───────────────────────────────────────
        Row {
            width: parent.width
            height: 40
            spacing: 12

            Rectangle {
                width: 160
                height: 40
                radius: 20
                anchors.verticalCenter: parent.verticalCenter
                scale: 0.88 + 0.12 * root.liveExpansion
                color: Qt.rgba(1, 1, 1, 0.14 + 0.20 * root.liveExpansion)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.30)

                Text {
                    anchors.centerIn: parent
                    text: "按住 / 点击"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: root.beginPress()
                    onReleased: root.endPress()
                    onCanceled: root.endPress()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "点击触发一次按压回弹"
                color: root.inkDim
                font.pixelSize: 10
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 2

            Text {
                text: "expansion  " + root.liveExpansion.toFixed(3)
                    + "   idle 0.000 / hovered 0.300 / pressed 1.000"
                color: root.ink
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "effective  press " + root.pressEffective + "ms OutBack"
                    + " · release " + root.releaseEffective + "ms OutQuint"
                    + (root.reduceMotion ? "（reduceMotion）" : "")
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "state  " + root.lastEvent
                color: root.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
        }
    }
}
