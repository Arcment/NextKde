import QtQuick

// Labeled slot for one surface preview: title line, the live component, and a
// caption that states the token values it was instantiated with.
Item {
    id: root

    property string title: ""
    property string badge: ""
    property string caption: ""
    property color ink: "white"
    property color inkDim: Qt.rgba(1, 1, 1, 0.55)
    // Room reserved under the body for the caption (two lines at 11px).
    property real captionHeight: 34
    default property alias body: bodyHost.data

    Text {
        id: titleText
        x: 0
        y: 0
        text: root.title
        color: root.ink
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }

    Rectangle {
        visible: root.badge !== ""
        x: titleText.implicitWidth + 10
        y: (titleText.height - height) / 2
        width: badgeText.implicitWidth + 14
        height: 18
        radius: 9
        color: Qt.rgba(1, 1, 1, 0.14)

        Text {
            id: badgeText
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
        anchors.topMargin: 24
        anchors.bottom: captionText.top
        anchors.bottomMargin: 6
    }

    Text {
        id: captionText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: root.captionHeight
        text: root.caption
        color: root.inkDim
        font.pixelSize: 11
        lineHeight: 0.95
        wrapMode: Text.WordWrap
    }
}
