import QtQuick
import qs.desktop.modules.common

// G5 — labelled glass card for one motion demo slot (TASK §3: every demo slot
// is one glass card). Same labelling job as SurfaceBlock, but the card itself
// is the glass surface, so the demo sits on the material it describes.
LiquidGlassPanel {
    id: root

    property string title: ""
    property string badge: ""
    property string caption: ""
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    // Room reserved under the body for the caption (two lines at 11px).
    property real captionHeight: 30
    default property alias body: bodyHost.data

    radius: 24
    cornerExponent: 2.0
    material: "regular"
    useKwinEffect: false

    Text {
        id: titleText
        x: 16
        y: 14
        text: root.title
        color: root.ink
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }

    Rectangle {
        visible: root.badge !== ""
        x: titleText.x + titleText.implicitWidth + 10
        y: (titleText.height - height) / 2
        width: badgeLabel.implicitWidth + 14
        height: 18
        radius: 9
        color: Qt.rgba(1, 1, 1, 0.14)

        Text {
            id: badgeLabel
            anchors.centerIn: parent
            text: root.badge
            color: root.inkDim
            font.pixelSize: 10
        }
    }

    Item {
        id: bodyHost
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 42
        anchors.bottom: captionText.top
        anchors.bottomMargin: 8
        anchors.leftMargin: 16
        anchors.rightMargin: 16
    }

    Text {
        id: captionText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        height: root.captionHeight
        text: root.caption
        color: root.inkDim
        font.pixelSize: 11
        lineHeight: 0.95
        wrapMode: Text.WordWrap
    }
}
