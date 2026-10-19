import QtQuick
import qs.desktop.modules.common

// G4e — gallery baseline for GlassScrollBar (SPEC §3.13).
//
// v1 proposal: one overlay-style bar — width 6, 8 on hover, shown while
// scrolling / hovering, faded out when still, pill radius. The thumb uses the
// selected role: light `#22000000`, dark `#30ffffff`.
//
// The component is host-driven: `position` / `size` belong to the scroll host
// (KosKineticScroll in production). Dragging only emits dragStarted /
// dragMoved / dragEnded; the host writes `position` back, exactly like the
// switch's checked contract.
//
// Forced states used by the matrix: idle / scrolling / hovered / dragging /
// top / bottom. `idle` is the settled state after the fade — the thumb is
// fully transparent, which is the spec, not a missing card.
Item {
    id: root

    // Visible fraction of the document (0..1) and scroll offset (0..1).
    property real position: 0.0
    property real size: 0.35
    // Host reports scroll activity; the bar stays visible while true.
    property bool active: false
    property bool enabled: true

    // "" (live) | idle | scrolling | hovered | dragging | top | bottom
    property string forcedState: ""

    // SPEC §3.13 fixes no durations; reuse the shell motion tokens
    // (slow = fade out, fast = width/position follow).
    property int fadeDuration: AppearanceTokens.motion.slowDuration
    property int growDuration: AppearanceTokens.motion.fastDuration
    property int minThumbLength: 24

    signal dragStarted()
    signal dragMoved(real position)
    signal dragEnded()

    readonly property color thumbColor: AppearanceTokens.isDarkTheme
        ? "#30ffffff" : "#22000000"

    property bool _hovered: false
    property bool _dragging: false
    property real _dragStartY: 0
    property real _dragStartPosition: 0

    readonly property bool disabledNow: !enabled
    readonly property bool hoveredNow: !disabledNow && (forcedState === "hovered"
        || forcedState === "dragging"
        || (forcedState === "" && (_hovered || _dragging)))
    readonly property bool draggingNow: !disabledNow
        && (forcedState === "dragging" || (forcedState === "" && _dragging))

    // The forced idle card demonstrates the faded end state.
    readonly property bool shown: {
        if (forcedState === "idle")
            return false
        if (forcedState !== "")
            return true
        return active || _hovered || _dragging
    }

    readonly property real thumbWidth: hoveredNow ? 8 : 6
    readonly property real thumbLength: Math.max(minThumbLength,
        Math.min(height, Math.max(0, size) * height))
    readonly property real travel: Math.max(0, height - thumbLength)
    readonly property real thumbY: Math.max(0, Math.min(travel,
        Math.max(0, Math.min(1, position)) * travel))

    implicitWidth: 8
    implicitHeight: 96

    opacity: shown ? (disabledNow ? 0.45 : 1.0) : 0.0
    Behavior on opacity {
        NumberAnimation { duration: root.fadeDuration; easing.type: Easing.OutCubic }
    }

    Rectangle {
        id: thumb
        anchors.right: parent.right
        width: root.thumbWidth
        height: root.thumbLength
        radius: width / 2
        color: root.thumbColor
        y: root.thumbY

        Behavior on width {
            NumberAnimation { duration: root.growDuration; easing.type: Easing.OutCubic }
        }
        Behavior on y {
            enabled: !root.draggingNow
            NumberAnimation { duration: root.growDuration; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onEntered: root._hovered = true
        onExited: root._hovered = false

        onPressed: function(mouse) {
            if (root.disabledNow)
                return
            root._dragging = true
            root._dragStartY = mouse.y
            root._dragStartPosition = root.position
            root.dragStarted()
        }

        onPositionChanged: function(mouse) {
            if (!root._dragging || root.travel <= 0)
                return
            const next = root._dragStartPosition
                + (mouse.y - root._dragStartY) / root.travel
            root.dragMoved(Math.max(0, Math.min(1, next)))
        }

        onReleased: {
            if (!root._dragging)
                return
            root._dragging = false
            root.dragEnded()
        }
    }
}
