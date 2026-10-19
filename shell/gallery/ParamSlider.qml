import QtQuick

// Minimal slider for the gallery parameter panel. No QtQuick.Controls: the
// gallery has to render with the same bare imports as the shell itself.
Item {
    id: root

    property string label: ""
    property string valueText: ""
    property real value: 0
    property real from: 0
    property real to: 1
    property color ink: "white"
    property color inkDim: Qt.rgba(1, 1, 1, 0.6)
    signal moved(real value)

    implicitHeight: 48
    width: parent ? parent.width : 200

    readonly property real ratio: to > from
        ? Math.max(0, Math.min(1, (value - from) / (to - from))) : 0

    Text {
        id: labelText
        x: 0
        y: 0
        text: root.label
        color: root.ink
        font.pixelSize: 12
    }
    Text {
        anchors.right: parent.right
        y: 0
        text: root.valueText
        color: root.inkDim
        font.pixelSize: 11
    }

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        y: 24
        height: 6
        radius: 3
        color: Qt.rgba(1, 1, 1, 0.18)

        Rectangle {
            width: track.width * root.ratio
            height: parent.height
            radius: 3
            color: Qt.rgba(1, 1, 1, 0.55)
        }

        Rectangle {
            x: Math.max(0, Math.min(track.width - width,
                track.width * root.ratio - width / 2))
            y: (track.height - height) / 2
            width: 16
            height: 16
            radius: 8
            color: "#ffffff"
        }

        MouseArea {
            anchors.fill: parent
            anchors.topMargin: -8
            anchors.bottomMargin: -8
            onPressed: function(mouse) { root.apply(mouse.x) }
            onPositionChanged: function(mouse) {
                if (pressed) root.apply(mouse.x)
            }
        }

        function apply(x) {
            const r = Math.max(0, Math.min(1, x / Math.max(1, track.width)))
            root.moved(root.from + r * (root.to - root.from))
        }
    }
}
