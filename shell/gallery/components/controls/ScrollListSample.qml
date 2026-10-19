import QtQuick
import qs.desktop.modules.common

// G4e — a miniature document next to a GlassScrollBar. A 6 px bar alone is
// unreadable in a screenshot, so the matrix cards show it against a small
// line-list surface; the list is a mock, not a control.
Item {
    id: root

    property string forcedState: ""
    property real barPosition: 0.18
    property real barSize: 0.34
    property bool barActive: true

    implicitWidth: 70
    implicitHeight: 72

    Rectangle {
        id: body
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width - 12
        radius: 6
        color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.04)
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(0, 0, 0, 0.08)

        Column {
            anchors.fill: parent
            anchors.margins: 7
            spacing: 6

            Repeater {
                model: [0.92, 0.68, 0.84, 0.55, 0.74]

                Rectangle {
                    required property real modelData
                    width: (body.width - 14) * modelData
                    height: Math.max(3,
                        (body.height - 14 - 4 * 6) / 5)
                    radius: height / 2
                    color: AppearanceTokens.isDarkTheme
                        ? Qt.rgba(1, 1, 1, 0.20) : Qt.rgba(0, 0, 0, 0.16)
                }
            }
        }
    }

    GlassScrollBar {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        forcedState: root.forcedState
        position: root.barPosition
        size: root.barSize
        active: root.barActive
    }
}
