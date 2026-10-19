import QtQuick
import qs.desktop.modules.common

// The three material tiers side by side with identical content, so the only
// visible variable is tintStrength / KWin blur level (SPEC 2.1). Used at the
// top of both the overview and the surface page.
Item {
    id: root

    property real previewOpacity: 1.0
    property real previewRadius: 24
    property real blurAmount: 0.63
    property real tintStrength: 0.16
    property color ink: "white"
    property color inkDim: Qt.rgba(1, 1, 1, 0.62)

    readonly property color tintColor: Qt.rgba(
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        tintStrength)

    readonly property real gap: 10
    readonly property real cardHeight: 76
    // Fixed caption block: two lines at 11px.
    readonly property real captionHeight: 34

    readonly property real blurLevel:
        Math.round(1 + Math.pow(blurAmount, 1.5) * 14)
    readonly property var tiers: [
        { key: "clear", tint: "0.10" },
        { key: "regular", tint: "0.16" },
        { key: "thick", tint: "0.24" }
    ]

    Row {
        anchors.fill: parent
        spacing: root.gap

        Repeater {
            model: root.tiers

            delegate: Item {
                required property var modelData

                width: (root.width - 2 * root.gap) / 3
                height: root.height

                LiquidGlassPanel {
                    width: parent.width
                    height: root.cardHeight
                    radius: root.previewRadius
                    cornerExponent: 2.0
                    material: modelData.key
                    useKwinEffect: true
                    baseColor: root.tintColor
                    surfaceOpacity: root.previewOpacity
                    blurOverrideEnabled: true
                    blurStrength: root.blurAmount

                    // Identical content across all three cards.
                    Column {
                        anchors.centerIn: parent
                        spacing: 3

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Liquid Glass"
                            color: root.ink
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Aa 13 · 同内容"
                            color: root.inkDim
                            font.pixelSize: 11
                        }
                    }
                }

                Text {
                    y: root.cardHeight + 6
                    width: parent.width
                    height: root.captionHeight
                    text: "material " + modelData.key
                        + " · tint " + modelData.tint + "→" + root.tintStrength.toFixed(2)
                        + "\nradius " + (root.previewRadius > 32
                            ? "pill" : Math.round(root.previewRadius))
                        + " · L" + root.blurLevel + " blur"
                        + " · " + Math.round(root.previewOpacity * 100) + "%"
                    color: root.inkDim
                    font.pixelSize: 11
                    lineHeight: 0.95
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
