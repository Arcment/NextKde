import QtQuick
import qs.desktop.modules.common

// G2a — gallery-local popover baseline. G2 product: these Glass*.qml
// components only serve the gallery; they do not replace the live shell
// components. Host, motion and the shadow/card geometry come from GlassPopup.
// Tokens: card radius 16, padding 12, material regular, cornerExponent 2.0,
// stroke 1, anchor gap 8 (extrapolated — SPEC does not fix it).
GlassPopup {
    id: root

    cardWidth: 300
    contentSpacing: 6

    // G11f — the card sampled the backdrop but shipped with the scrim off, so
    // its interior stayed at board colour and failed the hard contrast rule.
    // Opt in at the same readable ceiling as dialog so the card interior is
    // visibly compressed against the board behind it.
    scrimEnabled: true
    scrimLevel: "readable"

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
