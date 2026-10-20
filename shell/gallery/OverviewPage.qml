import QtQuick
import qs.desktop.modules.common

// G1c — overview: the three material tiers at the top, then the 16 component
// families from SPEC §3 as placeholder thumbnails tagged with their round.
Item {
    id: page

    property real previewOpacity: 1.0
    property real previewRadius: 24
    property real blurAmount: 0.63
    property real tintStrength: 0.16
    property bool radiusPill: false
    property bool reduceMotionOn: false

    readonly property real effectiveRadius: radiusPill ? 999 : previewRadius
    readonly property color tintColor: Qt.rgba(
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        AppearanceTokens.isDarkTheme ? 0 : 1,
        tintStrength)

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property real gridGap: 12
    readonly property real gridY: 192

    // SPEC §3.1–§3.16. G1 delivered the surface family; the rest are
    // placeholders until their round.
    readonly property var components: [
        { name: "GlassSurface", round: "G1" },
        { name: "GlassDialog", round: "G3" },
        { name: "GlassPopover", round: "G2" },
        { name: "GlassMenu", round: "G2" },
        { name: "GlassTooltip", round: "G2" },
        { name: "GlassToast", round: "G2" },
        { name: "GlassNotification", round: "G2" },
        { name: "SegmentedControl", round: "G4" },
        { name: "GlassButton", round: "G4" },
        { name: "GlassTextField", round: "G4" },
        { name: "GlassCheckbox", round: "G4" },
        { name: "GlassComboBox", round: "G4" },
        { name: "GlassScrollBar", round: "G4" },
        { name: "GlassSlider", round: "G4" },
        { name: "GlassSwitch", round: "G4" },
        { name: "GlassNavBar", round: "G4" }
    ]

    Text {
        x: 0
        y: 0
        text: "总览"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width
        text: "16 个组件族（SPEC §3）· G1 已交付表面族，其余为占位；"
            + "右侧参数实时作用于全部预览"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    MaterialTrio {
        x: 0
        y: 58
        width: parent.width
        height: 118
        previewOpacity: page.previewOpacity
        previewRadius: page.effectiveRadius
        blurAmount: page.blurAmount
        tintStrength: page.tintStrength
        ink: page.ink
        inkDim: page.inkDim
    }

    Grid {
        x: 0
        y: page.gridY
        width: parent.width
        height: parent.height - page.gridY
        columns: 4
        columnSpacing: page.gridGap
        rowSpacing: page.gridGap

        Repeater {
            model: page.components

            delegate: Item {
                required property var modelData

                width: (parent.width - 3 * page.gridGap) / 4
                height: (parent.height - 3 * page.gridGap) / 4

                LiquidGlassSurface {
                    anchors.fill: parent
                    radius: 16
                    material: "regular"
                    baseColor: page.tintColor
                    surfaceOpacity: page.previewOpacity
                    blurStrength: page.blurAmount
                    scrimEnabled: true
                    scrimLevel: "balanced"
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 3

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.name
                        color: page.ink
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.round + " · 占位"
                        color: page.inkDim
                        font.pixelSize: 10
                    }
                }
            }
        }
    }
}
