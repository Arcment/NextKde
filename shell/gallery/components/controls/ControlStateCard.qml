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
    // G5d — live preview parameters (radius already pill-resolved by the page).
    property real previewRadius: 16
    property real tintStrength: 0.16
    property real previewBlur: 0.63
    property real previewOpacity: 1.0

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)

    implicitWidth: 180
    implicitHeight: 104

    default property alias content: contentHost.data

    LiquidGlassPanel {
        anchors.fill: parent
        radius: root.previewRadius
        cornerExponent: 2.0
        material: root.materialTier
        // Matrix cells use the QML finish only: the gallery window is one
        // layer surface, per-cell compositor blur does not exist.
        useKwinEffect: false
        baseColor: Qt.rgba(
            AppearanceTokens.isDarkTheme ? 0 : 1,
            AppearanceTokens.isDarkTheme ? 0 : 1,
            AppearanceTokens.isDarkTheme ? 0 : 1,
            root.tintStrength)
        surfaceOpacity: root.previewOpacity
        blurOverrideEnabled: true
        blurStrength: root.previewBlur
    }

    // Hairline so the six cells stay readable even on the clear tier, where
    // the liquid finish is nearly transparent over the saturated board.
    Rectangle {
        anchors.fill: parent
        radius: root.previewRadius
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
        width: parent.width - 12
        horizontalAlignment: Text.AlignRight
        // Long state names (focusVisible) wrap to a second line instead of
        // eliding: the material·state annotation is part of the matrix.
        wrapMode: Text.WordWrap
        maximumLineCount: 2
        elide: Text.ElideRight
        lineHeight: 1.05
        text: root.materialTier + " · " + root.stateLabel
        color: root.ink
        font.pixelSize: 10
    }
}
