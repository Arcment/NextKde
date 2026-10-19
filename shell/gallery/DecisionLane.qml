import QtQuick
import qs.desktop.modules.common

// G6c — one A/B lane inside a decision card. The lane carries the option
// title, the interactive demo (default property), and the consequence line.
// It deliberately has no "recommended" affordance: the page presents both
// options and the human makes the call.
Rectangle {
    id: root

    property string title: ""
    property string tag: ""
    property string consequence: ""
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    property color hairline: Qt.rgba(1, 1, 1, 0.16)
    default property alias body: host.data

    radius: 12
    // The gallery's controlled background board is saturated on purpose, so
    // the lane needs its own backing: a dark scrim under white ink in dark
    // theme, a light scrim under dark ink in light theme. Without it the B
    // lane (over the yellow quadrant) loses its readouts.
    color: AppearanceTokens.isDarkTheme
        ? Qt.rgba(0, 0, 0, 0.22) : Qt.rgba(1, 1, 1, 0.34)
    border.width: 1
    border.color: root.hairline

    Text {
        id: titleText
        x: 12
        y: 10
        width: host.width
        text: root.title
        color: root.ink
        font.pixelSize: 12
        font.weight: Font.DemiBold
        elide: Text.ElideRight
    }

    Text {
        visible: root.tag !== ""
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 11
        text: root.tag
        color: root.inkDim
        font.pixelSize: 10
        font.family: "monospace"
    }

    Item {
        id: host
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.bottom: consequenceText.top
        anchors.bottomMargin: 6
    }

    // Consequence line: what each choice costs, never which one to pick.
    Text {
        id: consequenceText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        height: 36
        text: root.consequence
        color: root.inkDim
        font.pixelSize: 10
        lineHeight: 0.95
        wrapMode: Text.WordWrap
    }
}
