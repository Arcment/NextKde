import QtQuick
import qs.desktop.modules.common

// G5 — labelled glass card for one motion demo slot (TASK §3: every demo slot
// is one glass card). Same labelling job as SurfaceBlock, but the card itself
// is the glass surface, so the demo sits on the material it describes.
LiquidGlassPanel {
    id: root

    property string title: ""
    property string badge: ""
    // G7d — decision record pill. Empty means no pill (motion page cards).
    property string decision: ""
    property string caption: ""
    property color ink: AppearanceTokens.content.glassInk()
    property color inkDim: AppearanceTokens.content.glassInk(0.62)
    // G5d — live tint from the parameter panel.
    property real tintStrength: 0.16
    // Room reserved under the body for the caption (two lines at 11px).
    property real captionHeight: 30
    default property alias body: bodyHost.data

    radius: 24
    cornerExponent: 2.0
    material: "regular"
    useKwinEffect: false
    baseColor: Qt.rgba(
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        tintStrength)

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

    // G7d — "已裁定" marker. A fixed record of the human decision, not a
    // recommendation: both A/B lanes stay on the card as the written record.
    Rectangle {
        visible: root.decision !== ""
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.top: parent.top
        anchors.topMargin: 11
        width: decisionLabel.implicitWidth + 16
        height: 20
        radius: 10
        color: "#1E7A4B"
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.28)

        Text {
            id: decisionLabel
            anchors.centerIn: parent
            text: "已裁定 · " + root.decision
            color: "#FFFFFF"
            font.pixelSize: 10
            font.weight: Font.DemiBold
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
