import QtQuick
import Quickshell
import qs.desktop.modules.common

// G2c — gallery-local tooltip baseline. Host, motion contract and anchor
// binding follow StatusTooltip.qml, but the durations are the tooltip pair
// (70/70) and the surface is a LiquidGlassPanel at the thick material.
// Tokens: material thick, radius 10, primary Callout 12 SemiBold,
// secondary Footnote 10 Medium, anchor-side margin -6 (SPEC §7 裁定项).
// No cast shadow: a tooltip is a small attached surface, not a floating card.
AnimatedPopupWindow {
    id: root

    property Item anchorItem: null
    property bool shown: false
    property string primaryText: "GlassTooltip"
    property string secondaryText: "material thick · radius 10 · 70ms"

    requestedOpen: root.shown && root.anchorItem !== null
    color: "transparent"
    implicitWidth: tooltipColumn.implicitWidth + 18
    implicitHeight: tooltipColumn.implicitHeight + 12
    openDuration: 70
    closeDuration: 70

    function open(item) {
        root.anchorItem = item
        root.shown = true
    }
    function close() { root.shown = false }

    PopupAnchorBinding { popupAnchor: root.anchor; sourceItem: root.anchorItem }

    // G10e — screen-aligned hidden copy of the backdrop board for this surface.
    // The tooltip lives in its own window, so it samples its own copy rather
    // than the main window's; hideSource on the card's capture keeps it out of
    // the painted scene.
    GalleryBackdropSample {
        id: backdropSample
        anchors.fill: parent
        visible: root.shown && GlassBackdrop.sourceItem !== null
        screenX: root.anchor.rect.x
        screenY: root.anchor.rect.y
        screenWidth: root.screen ? root.screen.width : 0
        screenHeight: root.screen ? root.screen.height : 0
    }

    anchor {
        edges: Edges.Bottom
        gravity: Edges.Bottom
        // The side facing the anchor overlaps it by 6px (SPEC §7 裁定项).
        margins.bottom: -6
    }

    LiquidGlassPanel {
        anchors.fill: parent
        radius: 10
        cornerExponent: 2.0
        material: "thick"
        useKwinEffect: false
        backdropItem: GlassBackdrop.sourceItem !== null ? backdropSample : null

        Column {
            id: tooltipColumn
            anchors.centerIn: parent
            spacing: 3

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.primaryText
                color: AppearanceTokens.content.glassInk()
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.secondaryText.length > 0
                text: root.secondaryText
                color: AppearanceTokens.content.glassInk(0.62)
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }
    }
}
