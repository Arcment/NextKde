import QtQuick

// G10e — screen-aligned hidden copy of the controlled backdrop for popup
// windows. A popup is a separate Wayland surface, so it cannot capture the
// main window's copy; this one is translated by the popup's screen position
// and hidden by ShaderEffectSource.hideSource on the card's capture.
Item {
    id: root

    property real screenX: 0
    property real screenY: 0
    property real screenWidth: 0
    property real screenHeight: 0

    anchors.fill: parent

    GalleryBackdropBoard {
        x: -root.screenX
        y: -root.screenY
        width: root.screenWidth
        height: root.screenHeight
    }
}
