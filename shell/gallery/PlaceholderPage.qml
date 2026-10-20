import QtQuick
import qs.desktop.modules.common

// G1a placeholder page. Real pages land in G1b/G1c (surfaces / overview)
// and G2/G3/G4.

Item {
    property string title: ""
    property string note: ""

    Column {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: parent.parent.title
            color: AppearanceTokens.content.glassInk()
            font.pixelSize: 28
            font.weight: Font.DemiBold
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: parent.parent.note
            color: AppearanceTokens.content.glassInk(0.55)
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
