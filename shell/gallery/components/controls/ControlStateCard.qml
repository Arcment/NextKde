import QtQuick
import qs.desktop.modules.common

// G4 — one state cell of a control matrix. The card is a glass shell
// (QML liquid fallback, never a compositor effect: a matrix of 18 compositor
// blur regions would be both wrong and slow) with the material tier and state
// printed in the top-right corner. The control under test is the default
// content, so a caller writes it exactly as it would in production.
Item {
    id: root

    property string materialTier: "regular"
    property string stateLabel: "idle"

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)

    implicitWidth: 180
    implicitHeight: 104

    default property alias content: contentHost.data

    LiquidGlassPanel {
        anchors.fill: parent
        radius: 16
        cornerExponent: 2.0
        material: root.materialTier
        // Matrix cells use the QML finish only: the gallery window is one
        // layer surface, per-cell compositor blur does not exist.
        useKwinEffect: false
        surfaceOpacity: 1.0
    }

    // Hairline so the six cells stay readable even on the clear tier, where
    // the liquid finish is nearly transparent over the saturated board.
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.20) : Qt.rgba(0, 0, 0, 0.16)
    }

    Item {
        id: contentHost
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 22
        anchors.bottomMargin: 8
    }

    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 7
        anchors.rightMargin: 8
        text: root.materialTier + " · " + root.stateLabel
        color: root.ink
        font.pixelSize: 10
    }
}
