import QtQuick
import Quickshell
import qs.desktop.modules.common

// G2 — shared gallery popup host for the G2a–G2e baselines.
// AnimatedPopupWindow owns the mapped / interactive contract, the 150/140ms
// motion and the 0.96 start scale; subclasses only describe card content.
// The window is the card plus the shadow's margin on every side. The anchor
// margin is therefore compensated by that margin: a positive `anchorGap`
// between the source item and the card is `anchorGap - shadowMargin` at the
// window edge, because the shadow margin is transparent padding inside the
// window.
AnimatedPopupWindow {
    id: root

    property Item anchorItem: null
    property bool shown: false

    property real cardWidth: 300
    property real cardRadius: 16
    property string material: "regular"
    property real contentPadding: 12
    property real contentSpacing: 0
    property real anchorGap: 8

    // G10f — QML fallback scrim for popup cards. The card already samples the
    // popup's screen-aligned backdrop copy (G10e); these hand it the same
    // readability preset the compositor path uses. Off by default so a
    // subclass opts in and every existing popup keeps its old finish.
    property bool scrimEnabled: false
    property string scrimLevel: "transparent"

    // Subclass content lands in this Column; the card follows its height.
    default property alias contentData: body.data

    readonly property real shadowMargin: shadow.margin
    readonly property real cardHeight: body.implicitHeight + root.contentPadding * 2

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

    // G10e — screen-aligned hidden copy of the backdrop board. The popup is a
    // separate surface, so the card cannot sample the main window's copy; this
    // one is translated by the popup's screen position instead. It stays
    // visible so the card's ShaderEffectSource can grab it (hideSource keeps
    // it out of the painted scene); gating on the board switch keeps the old
    // KWin path pixel-identical when the board is off.
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
        margins.bottom: root.shadowMargin - root.anchorGap
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
        width: root.cardWidth
        height: root.cardHeight
        radius: root.cardRadius
        cornerExponent: 2.0
        material: root.material
        useKwinEffect: false
        backdropItem: GlassBackdrop.sourceItem !== null ? backdropSample : null
        scrimEnabled: root.scrimEnabled
        scrimLevel: root.scrimLevel

        Column {
            id: body
            anchors.fill: parent
            anchors.margins: root.contentPadding
            spacing: root.contentSpacing
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
