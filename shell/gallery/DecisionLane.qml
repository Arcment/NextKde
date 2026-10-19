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
    // G7d — the gallery's controlled background board is saturated on purpose
    // (red / yellow / cyan / magenta quadrants). The earlier 0.22 / 0.34 scrim
    // left the lane mid-tone over the yellow and red quadrants, so the 9–12px
    // readouts fell below 4.5:1. The backing is now near-opaque: deep charcoal
    // in dark theme, near-white in light theme. Worst-case composite (95% lane
    // over #FFEB3C yellow) is #1D1D14 dark and #F5EDF0 light; the strongest
    // dim ink (#FFFFFF @ 0.82 / #14161A @ 0.86) measures ≈12:1 and ≈10:1.
    color: AppearanceTokens.isDarkTheme
        ? Qt.rgba(0.045, 0.05, 0.06, 0.95) : Qt.rgba(0.965, 0.97, 0.98, 0.95)
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
