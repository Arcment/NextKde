import QtQuick
import qs.desktop.modules.common

// G5a — one replay lane for the PopupMotion open/close comparison.
//
// The production owner of these numbers is
// shell/desktop/modules/common/PopupMotion.qml: progress 0→1, duration scaled
// by the remaining distance, OutCubic on open / InCubic on close. The gallery
// re-implements that progress contract in-page (same mapping GlassDialog uses)
// so it can (a) hold a static sample for screenshots and (b) honour
// reduceMotion, without touching the live component.
//
// reduceMotion is not a PopupMotion property in production; here the effective
// duration is derived from the gallery panel switch: 150/140 → 0.
Item {
    id: lane

    property string direction: "open" // open | close
    property bool reduceMotion: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property bool opening: direction === "open"
    readonly property int tokenDuration: opening
        ? AppearanceTokens.motion.popupOpenDuration
        : AppearanceTokens.motion.popupCloseDuration
    readonly property int effectiveDuration: reduceMotion ? 0 : tokenDuration
    readonly property string easingLabel: opening ? "OutCubic" : "InCubic"
    readonly property int easingType: opening ? Easing.OutCubic : Easing.InCubic
    readonly property real startScale: AppearanceTokens.motion.popupStartScale
    readonly property real anchorOffset: AppearanceTokens.motion.popupAnchorOffset
    readonly property bool sampled: !running && progress > 0.001 && progress < 0.999

    // Static initial state. Open rests on the token terminal (1.0); close holds
    // the t=0.75 sample (1 - 0.75³ = 0.578) so a still screenshot shows one
    // open state and one mid-flight close state instead of two identical ones.
    // Under reduceMotion both settle on their terminals (open 1, close 0).
    property real progress: reduceMotion ? (opening ? 1 : 0)
        : opening ? 1.0 : 1 - Math.pow(0.75, 3)
    property bool running: false

    readonly property var sampleT: [0, 0.25, 0.5, 0.75, 1]

    function easeAt(t) {
        return opening ? 1 - Math.pow(1 - t, 3) : Math.pow(t, 3)
    }

    function progressAt(t) {
        return opening ? easeAt(t) : 1 - easeAt(t)
    }

    function replay() {
        animation.stop()
        if (reduceMotion) {
            // No motion: settle on the terminal state in the same call.
            progress = opening ? 1 : 0
            running = false
            return
        }
        // Open replays from closed, close replays from fully open.
        progress = opening ? 0 : 1
        running = true
        animateTo(opening ? 1 : 0)
    }

    function animateTo(target) {
        animation.from = progress
        animation.to = target
        // PopupMotion contract: duration scales with the remaining distance,
        // so an interrupted run keeps the same speed.
        animation.duration = Math.max(1,
            Math.round(effectiveDuration * Math.abs(target - progress)))
        animation.easing.type = easingType
        animation.start()
    }

    onReduceMotionChanged: {
        animation.stop()
        running = false
        if (reduceMotion)
            progress = opening ? 1 : 0
        else
            progress = opening ? 1.0 : 1 - Math.pow(0.75, 3)
    }

    property NumberAnimation animation: NumberAnimation {
        target: lane
        property: "progress"
        onFinished: lane.running = false
    }

    Column {
        anchors.fill: parent
        spacing: 8

        // ── title + token badge ─────────────────────────────────────
        Item {
            width: parent.width
            height: 18

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: lane.opening ? "OutCubic · 开" : "InCubic · 关"
                color: lane.ink
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }

            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: badgeText.implicitWidth + 12
                height: 18
                radius: 9
                color: Qt.rgba(1, 1, 1, 0.14)

                Text {
                    id: badgeText
                    anchors.centerIn: parent
                    text: lane.tokenDuration + "ms"
                    color: lane.inkDim
                    font.pixelSize: 10
                }
            }
        }

        // ── scale/opacity proxy stage ───────────────────────────────
        Rectangle {
            width: parent.width
            height: 96
            radius: 10
            color: Qt.rgba(0, 0, 0, 0.18)
            border.width: 1
            border.color: lane.hairline

            Rectangle {
                id: proxy
                anchors.centerIn: parent
                width: 180
                height: 54
                radius: 12
                color: Qt.rgba(1, 1, 1, 0.18)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.28)
                scale: lane.startScale + (1 - lane.startScale) * lane.progress
                opacity: lane.progress

                Text {
                    anchors.centerIn: parent
                    text: "popup"
                    color: lane.ink
                    font.pixelSize: 11
                }
            }

            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 6
                text: "scale " + lane.startScale.toFixed(2) + " → 1.00"
                color: lane.inkDim
                font.pixelSize: 9
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Column {
            width: parent.width
            spacing: 2

            Text {
                text: "progress  " + lane.progress.toFixed(3)
                color: lane.ink
                font.pixelSize: 11
                font.family: "monospace"
            }
            Text {
                text: "effective  " + lane.effectiveDuration + "ms"
                    + (lane.reduceMotion ? "（reduceMotion）" : "")
                color: lane.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "state  " + (lane.running ? "running"
                    : lane.sampled ? "sampled" : "settled")
                color: lane.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
        }

        Row {
            width: parent.width
            spacing: 10

            Rectangle {
                width: 64
                height: 26
                radius: 8
                color: replayMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                border.color: lane.hairline

                Text {
                    anchors.centerIn: parent
                    text: "重播"
                    color: lane.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: replayMouse
                    anchors.fill: parent
                    onClicked: lane.replay()
                }
            }

            // anchorOffset is a token of the same contract; shown here so the
            // comparison card carries every number the open/close pair uses.
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "anchorOffset " + lane.anchorOffset + "px"
                color: lane.inkDim
                font.pixelSize: 9
            }
        }

        // ── static easing sample table ──────────────────────────────
        Text {
            text: "曲线采样（静态） t / ease / progress"
            color: lane.inkDim
            font.pixelSize: 9
        }

        Row {
            spacing: 0

            Text {
                width: 46
                text: "t"
                color: lane.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                width: 60
                text: "ease"
                color: lane.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
            Text {
                text: "progress"
                color: lane.inkDim
                font.pixelSize: 10
                font.family: "monospace"
            }
        }

        Repeater {
            model: lane.sampleT

            delegate: Row {
                required property real modelData

                Text {
                    width: 46
                    text: modelData.toFixed(2)
                    color: lane.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
                Text {
                    width: 60
                    text: lane.easeAt(modelData).toFixed(3)
                    color: lane.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
                Text {
                    text: lane.progressAt(modelData).toFixed(3)
                    color: lane.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
            }
        }

        Text {
            width: parent.width
            text: lane.opening
                ? "progress = 1-(1-t)³；时长为 150ms"
                : "progress = 1-t³；时长为 140ms"
            color: lane.inkDim
            font.pixelSize: 9
            wrapMode: Text.WordWrap
        }
    }
}
