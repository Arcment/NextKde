import QtQuick
import qs.desktop.modules.common

// G6d — SPEC §7-③ SessionMenu extreme itemHeight lane.
//
// The shipped SessionMenu derives the label size from the row height
// (`Math.round(itemHeight * 0.34)`, SessionMenu.qml:286). This lane compares
// two ways to keep Footnote 10 legible at both extremes of itemHeight:
//
//   mode "raw"   (A): itemHeight stays as requested (24 / 72); the label is
//                     fixed Footnote 10, so 24 is crowded and 72 is roomy.
//                     Shipped by the G7 decision ③A.
//   mode "clamp" (B): itemHeight is clamped to 44–56 for SessionMenu only;
//                     the label stays Footnote 10 and remains readable.
//                     Not adopted; kept here as record.
//
// Both columns render the same three-action menu. Hover highlights a row and
// clicking selects it; the readout prints itemHeight and the actual font size.
Item {
    id: root

    property string mode: "raw"
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)

    readonly property int minHeight: 44
    readonly property int maxHeight: 56
    readonly property int fontPx: 10
    // The shipped lockscreen menu is dark-only, so its light-red danger ink
    // disappears on the gallery's light lane. Darken it for light theme.
    readonly property color dangerInk: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 0.66, 0.66, 0.96) : Qt.rgba(0.70, 0.12, 0.14, 0.96)
    // G7d — near-white lane in light theme: white hover would be invisible.
    readonly property color rowHoverFill: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.06)

    property string selectedLabel: ""

    readonly property var extremes: [24, 72]
    readonly property var actions: ["锁屏", "注销", "关机"]

    function effectiveHeight(requested) {
        if (root.mode !== "clamp")
            return requested
        return Math.max(root.minHeight, Math.min(root.maxHeight, requested))
    }

    Column {
        anchors.fill: parent
        spacing: 6

        Row {
            id: columns
            width: parent.width
            spacing: 10

            Repeater {
                model: root.extremes

                delegate: Column {
                    required property int modelData
                    id: col
                    width: (columns.width - 10) / 2
                    spacing: 4

                    readonly property int itemH: root.effectiveHeight(modelData)

                    Text {
                        width: parent.width
                        text: "itemHeight " + modelData
                            + (root.mode === "clamp" ? " → " + col.itemH : "")
                        color: root.ink
                        font.pixelSize: 10
                        font.family: "monospace"
                        elide: Text.ElideRight
                    }

                    Rectangle {
                        width: parent.width
                        height: col.itemH * root.actions.length + 12
                        radius: 10
                        color: AppearanceTokens.isDarkTheme
                            ? Qt.rgba(0, 0, 0, 0.20) : Qt.rgba(0, 0, 0, 0.07)
                        border.width: 1
                        border.color: root.hairline

                        Column {
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 2

                            Repeater {
                                model: root.actions

                                delegate: Rectangle {
                                    required property string modelData
                                    required property int index
                                    width: parent.width
                                    height: col.itemH
                                    radius: 7
                                    color: rowArea.containsMouse || root.selectedLabel === modelData
                                        ? root.rowHoverFill : "transparent"

                                    Behavior on color {
                                        ColorAnimation { duration: 120 }
                                    }

                                    Text {
                                        // Fixed Footnote 10 in both modes: the
                                        // point of the A/B is the row height,
                                        // not the label scale.
                                        anchors.verticalCenter: parent.verticalCenter
                                        x: 12
                                        text: modelData
                                        color: modelData === "关机"
                                            ? root.dangerInk : root.ink
                                        font.pixelSize: root.fontPx
                                    }

                                    MouseArea {
                                        id: rowArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.selectedLabel = modelData
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: root.mode === "clamp"
                            ? "req " + modelData + " → clamp " + col.itemH
                                + " · 字 " + root.fontPx + "px"
                            : (modelData <= 24 ? "拥挤" : "空旷")
                                + " · 行高 " + col.itemH + " · 字 " + root.fontPx + "px"
                        color: root.inkDim
                        font.pixelSize: 9
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Text {
            width: parent.width
            text: root.mode === "clamp"
                ? "readout itemHeight 44 · 56 ← req 24 · 72 · font " + root.fontPx + "px"
                : "readout itemHeight 24 · 72 · font " + root.fontPx + "px"
            color: root.ink
            font.pixelSize: 9
            font.family: "monospace"
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: "selected " + (root.selectedLabel === "" ? "—" : root.selectedLabel)
                + " · hover 高亮 / 点击选中"
            color: root.inkDim
            font.pixelSize: 9
            font.family: "monospace"
            elide: Text.ElideRight
        }
    }
}
