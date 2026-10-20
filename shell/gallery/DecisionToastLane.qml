import QtQuick
import qs.desktop.modules.common

// G6c — interactive toast lane for the SPEC §7-① A/B presentation.
//
// A: holdToken 1600ms, auto-dismiss, no hover pause (the original behaviour).
// B: holdToken 2600ms, auto-dismiss, hover pauses the retention clock and
//    leaving resumes it (shipped by the G7 decision ①B; kept here as record).
//
// Seeded shown + stopped so a static screenshot carries both surfaces and
// both readings without synthesising a click. 发一条 starts the real clock;
// 关闭 clears it. The lane prints total / elapsed / remaining / paused, which
// is all a still frame can prove about a retention duration.
Item {
    id: root

    property int holdToken: 1600
    property bool hoverPause: false
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)
    // G7d — near-white lane in light theme: white-on-white controls vanish.
    readonly property color controlFill: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.07)
    readonly property color controlFillPressed: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(0, 0, 0, 0.14)

    // Seeded shown for the static frame; the retention clock starts on 发一条.
    property bool shown: true
    property bool running: false
    property bool hovered: false
    readonly property bool paused: root.running && root.hoverPause && root.hovered
    property int remaining: holdToken
    readonly property int elapsed: root.holdToken - root.remaining
    property string lastEvent: "seed"
    readonly property bool ticking: root.running && !root.paused

    function stateLabel() {
        if (root.paused)
            return "paused"
        if (root.running)
            return "holding"
        return root.shown ? "shown" : "dismissed"
    }

    function send() {
        root.shown = true
        root.running = true
        root.remaining = root.holdToken
        root.lastEvent = "发一条"
    }

    function close() {
        root.running = false
        root.shown = false
        root.remaining = 0
        root.lastEvent = "关闭"
    }

    Timer {
        id: tick
        interval: 50
        repeat: true
        running: root.ticking
        onTriggered: {
            root.remaining = Math.max(0, root.remaining - interval)
            if (root.remaining <= 0) {
                root.running = false
                root.shown = false
                root.lastEvent = "存留到期"
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 7

        // ── stage ───────────────────────────────────────────────────
        Rectangle {
            id: stage
            width: parent.width
            height: 90
            radius: 10
            color: AppearanceTokens.isDarkTheme
                ? Qt.rgba(0, 0, 0, 0.18) : Qt.rgba(0, 0, 0, 0.06)
            border.width: 1
            border.color: root.hairline

            // Same surface contract as the shipped ActionFeedbackToast:
            // regular material, readable scrim, 36px tall pill, Callout 12.
            LiquidGlassPanel {
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - height) / 2
                width: Math.min(226, parent.width - 24)
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
                    NumberAnimation {
                        duration: root.shown ? 150 : 180
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on scale {
                    NumberAnimation {
                        duration: root.shown ? 150 : 180
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

            Text {
                visible: !root.shown
                anchors.centerIn: parent
                text: "toast 已消失"
                color: root.inkDim
                font.pixelSize: 10
            }

            // Only the B lane pauses on hover; the A lane has no MouseArea so
            // it cannot intercept anything.
            MouseArea {
                anchors.fill: parent
                enabled: root.hoverPause
                hoverEnabled: root.hoverPause
                onEntered: {
                    root.hovered = true
                    if (root.running)
                        root.lastEvent = "hover · 暂停"
                }
                onExited: {
                    root.hovered = false
                    if (root.running)
                        root.lastEvent = "hover 离开 · 继续"
                }
            }

            Text {
                visible: root.hoverPause
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                text: root.hovered && root.hoverPause ? "hover · 暂停中" : "hover 暂停"
                color: root.inkDim
                font.pixelSize: 9
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Row {
            width: parent.width
            spacing: 8

            Column {
                width: (parent.width - 8) / 2
                spacing: 2
                Text {
                    text: "total     " + root.holdToken + "ms"
                    color: root.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
                Text {
                    text: "elapsed   " + root.elapsed + "ms"
                    color: root.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
            }
            Column {
                width: (parent.width - 8) / 2
                spacing: 2
                Text {
                    text: "remaining " + root.remaining + "ms"
                    color: root.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
                Text {
                    text: "paused    " + (root.paused ? "yes" : "no")
                    color: root.ink
                    font.pixelSize: 10
                    font.family: "monospace"
                }
            }
        }

        Text {
            width: parent.width
            text: "state " + root.stateLabel() + " · last " + root.lastEvent
            color: root.inkDim
            font.pixelSize: 10
            font.family: "monospace"
        }

        // ── triggers ────────────────────────────────────────────────
        Row {
            spacing: 8

            Rectangle {
                width: 66
                height: 24
                radius: 8
                color: sendMouse.pressed
                    ? root.controlFillPressed : root.controlFill
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
                    onClicked: root.send()
                }
            }

            Rectangle {
                width: 56
                height: 24
                radius: 8
                color: closeMouse.pressed
                    ? root.controlFillPressed : root.controlFill
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "关闭"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    onClicked: root.close()
                }
            }
        }
    }
}
