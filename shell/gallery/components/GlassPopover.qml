import QtQuick
import Quickshell
import qs.desktop.modules.common

// G2a — gallery-local popover baseline. G2 product: these Glass*.qml
// components only serve the gallery; they do not replace the live shell
// components. Host motion comes from AnimatedPopupWindow so the mapped /
// interactive contract, 150/140ms and 0.96 scale are the same as the shell.
//
// The window is the card plus the shadow's margin on every side. The anchor
// margin is therefore compensated by that margin: a positive 8px gap between
// the source item and the card is `8 - shadowMargin` at the window edge,
// because the shadow margin is transparent padding inside the window.
AnimatedPopupWindow {
    id: root

    property Item anchorItem: null
    property bool shown: false
    readonly property real shadowMargin: shadow.margin

    requestedOpen: root.shown && root.anchorItem !== null
    color: "transparent"
    implicitWidth: card.width + root.shadowMargin * 2
    implicitHeight: card.height + root.shadowMargin * 2
    openDuration: AppearanceTokens.motion.popupOpenDuration
    closeDuration: AppearanceTokens.motion.popupCloseDuration

    function open(item) {
        root.anchorItem = item
        root.shown = true
    }
    function close() { root.shown = false }
    function toggle(item) {
        if (root.shown && root.anchorItem === item)
            root.close()
        else
            root.open(item)
    }

    PopupAnchorBinding { popupAnchor: root.anchor; sourceItem: root.anchorItem }

    anchor {
        edges: Edges.Bottom
        gravity: Edges.Bottom
        // The window edge sits shadowMargin *outside* the card, and anchor
        // margins pull towards the source, so the 8px card gap is
        // `shadowMargin - 8` at the window edge.
        margins.bottom: root.shadowMargin - 8
    }

    // Floating cast: a sibling layer below the card, never a backdrop inside
    // it (a translucent card would show the darkening through itself).
    KosCardShadow {
        id: shadow
        x: card.x - margin
        y: card.y - margin
        castEnabled: true
        cardWidth: card.width
        cardHeight: card.height
        cornerRadius: card.radius
        cornerExponent: card.cornerExponent
        offsetX: 12
        offsetY: 16
        softness: 18
        shadowColor: Qt.rgba(0.5, 0.5, 0.5, 0.30)
    }

    LiquidGlassPanel {
        id: card
        z: 1
        x: root.shadowMargin
        y: root.shadowMargin
        width: 300
        height: content.implicitHeight + 24
        radius: 16
        cornerExponent: 2.0
        material: "regular"
        useKwinEffect: false

        Column {
            id: content
            anchors.fill: parent
            anchors.margins: 12
            spacing: 6

            Text {
                width: parent.width
                text: "GlassPopover"
                color: AppearanceTokens.content.glassInk()
                font.pixelSize: 17
                font.weight: Font.DemiBold
            }
            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "radius 16 · padding 12 · material regular"
                color: AppearanceTokens.content.glassInk(0.62)
                font.pixelSize: 13
            }
            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "cornerExponent 2.0 · 阴影 0.30 / 12,16 / 18"
                color: AppearanceTokens.content.glassInk(0.62)
                font.pixelSize: 13
            }
        }
    }

    // 1px stroke (token). LiquidGlassPanel leaves the edge to KWin in the
    // shell; this QML-fallback card has to draw it itself.
    Rectangle {
        z: 2
        x: card.x
        y: card.y
        width: card.width
        height: card.height
        radius: card.radius
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.content.glassInk(0.16)
    }
}
