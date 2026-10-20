import QtQuick
import qs.desktop.modules.common

// G6d — SPEC §7-② tooltip edge-gap lane.
//
// A lane: gap -6px. The side facing the anchor overlaps it by 6px, the
// original negative margin (margins.bottom -6 / margins.top -6).
// B lane: gap +4px, a positive gap that never covers the anchor; shipped by
// the G7 decision ②B and kept here as record.
//
// The stage draws a hairline for the screen edge, the anchor chip flush to
// it, and the anchor's bottom hairline. The tooltip is seeded shown so a
// still frame carries the geometry; hover the chip or use the button to
// show/hide it. Readings print the actual gap and both edge coordinates.
Item {
    id: root

    property int gap: -6
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)
    // G7d — light theme uses a near-white lane; white chips/buttons vanish.
    readonly property color controlFill: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.07)
    readonly property color controlFillPressed: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(0, 0, 0, 0.14)
    readonly property color chipFill: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08)

    property bool shown: true
    property bool hovered: false
    property string lastEvent: "seed"

    readonly property int anchorHeight: 28
    readonly property int tipHeight: 40
    readonly property int anchorBottom: 12 + anchorHeight
    readonly property int tipTop: root.anchorBottom + root.gap

    function showTip() {
        root.shown = true
        root.lastEvent = "显示"
    }

    function hideTip() {
        root.shown = false
        root.lastEvent = "隐藏"
    }

    function toggleTip() {
        if (root.shown)
            root.hideTip()
        else
            root.showTip()
    }

    Column {
        anchors.fill: parent
        spacing: 6

        // ── stage: screen edge, anchor chip, attached tooltip ────────
        Rectangle {
            width: parent.width
            height: 108
            radius: 10
            color: AppearanceTokens.isDarkTheme
                ? Qt.rgba(0, 0, 0, 0.18) : Qt.rgba(0, 0, 0, 0.06)
            border.width: 1
            border.color: root.hairline

            // screen edge hairline
            Rectangle {
                x: parent.width - 14
                y: 8
                width: 1
                height: parent.height - 16
                color: root.hairline
            }
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 18
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                text: "屏幕边缘"
                color: root.inkDim
                font.pixelSize: 8
            }

            // anchor chip, flush to the edge
            Rectangle {
                id: chip
                x: parent.width - 14 - width
                y: 12
                width: 96
                height: root.anchorHeight
                radius: height / 2
                color: root.chipFill
                border.width: 1
                border.color: root.hairline

                Text {
                    anchors.centerIn: parent
                    text: "10:42"
                    color: root.ink
                    font.pixelSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        root.hovered = true
                        if (!root.shown)
                            root.lastEvent = "hover · 显示"
                        root.showTip()
                    }
                    onExited: {
                        root.hovered = false
                        root.lastEvent = "hover 离开 · 隐藏"
                        root.hideTip()
                    }
                    onClicked: root.toggleTip()
                }
            }

            // anchor bottom hairline: the tooltip covers it under -6,
            // leaves it visible under +4.
            Rectangle {
                x: chip.x
                y: root.anchorBottom
                width: chip.width
                height: 1
                color: root.hairline
            }

            // tooltip, right edge also flush to the screen edge
            LiquidGlassPanel {
                id: tip
                x: parent.width - 14 - width
                y: root.tipTop
                width: 150
                height: root.tipHeight
                radius: 8
                cornerExponent: 2.0
                material: "thick"
                scrimEnabled: AppearanceTokens.surface.usesBackdrop
                scrimLevel: "readable"
                useKwinEffect: false
                fallbackEnabled: AppearanceTokens.surface.paintInQml
                opacity: root.shown ? 1 : 0
                scale: root.shown ? 1 : 0.97
                transformOrigin: Item.Top

                Behavior on opacity {
                    NumberAnimation {
                        duration: root.shown ? 70 : 70
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on scale {
                    NumberAnimation {
                        duration: root.shown ? 70 : 70
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "已复制到剪贴板"
                    color: root.ink
                    font.pixelSize: 11
                    font.weight: Font.Medium
                }
            }
        }

        // ── readouts ────────────────────────────────────────────────
        Row {
            width: parent.width
            spacing: 10

            Text {
                text: "gap       " + (root.gap > 0 ? "+" : "") + root.gap + "px"
                color: root.ink
                font.pixelSize: 9
                font.family: "monospace"
            }
            Text {
                text: "anchorB " + root.anchorBottom
                    + " · tipTop " + root.tipTop
                color: root.ink
                font.pixelSize: 9
                font.family: "monospace"
            }
            Text {
                text: "state " + (root.shown ? "shown" : "hidden")
                color: root.ink
                font.pixelSize: 9
                font.family: "monospace"
            }
        }

        Text {
            width: parent.width
            text: "last " + root.lastEvent
                + " · 点 chip 或按钮切换；悬停 chip 显示"
            color: root.inkDim
            font.pixelSize: 9
            font.family: "monospace"
            elide: Text.ElideRight
        }

        // ── trigger ─────────────────────────────────────────────────
        Rectangle {
            width: 66
            height: 24
            radius: 8
            color: toggleMouse.pressed
                ? root.controlFillPressed : root.controlFill
            border.width: 1
            border.color: root.hairline

            Text {
                anchors.centerIn: parent
                text: "显示/隐藏"
                color: root.ink
                font.pixelSize: 10
            }

            MouseArea {
                id: toggleMouse
                anchors.fill: parent
                onClicked: root.toggleTip()
            }
        }
    }
}
