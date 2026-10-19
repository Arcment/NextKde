import QtQuick
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4d — gallery baseline for GlassSwitch (SPEC §3.15).
//
// 74×32, thumb 44×26, travel = width - 44 - 6. Both forms read
// ControlForm.materialForm.
//
//   liquid    track crossfades from neutral to accent with progress; thumb is
//             a white glass pill that expands on press
//   material  M3 pill track (accent when on) + circular handle 16 off / 24 on,
//             scaled by m3Scale = min(1, h / 32)
//
// Contract: `checked` belongs to the host. toggle() only emits
// toggled(!checked) — the component never assigns `checked` itself, so an
// asynchronous owner can confirm (or reject) the request without a local
// flip. thumbX animates 200 ms OutCubic; press expansion 120 ms, release 200.
//
// Forced states used by the matrix: off / on / hovered / pressed / disabled /
// focusVisible. hovered / pressed / focusVisible cards keep the host value
// passed by the page (the state is the pointer/focus treatment, not the
// checked value).
Item {
    id: root

    property bool checked: false
    property bool enabled: true
    property color accentColor: tokens.accentColor
    property color trackColor: Qt.rgba(0.5, 0.5, 0.55, 0.35)
    // M3 handle colours; the liquid thumb ignores them.
    property color handleOnColor: "#ffffff"
    property color handleOffColor: Qt.rgba(0.47, 0.47, 0.47, 1.0)
    // "" (live) | off | on | hovered | pressed | disabled | focusVisible
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false
    property real _expansion: pressedNow ? 1.0 : 0.0
    property real _stretch: 0.0

    signal toggled(bool checked)

    readonly property bool disabledNow:
        forcedState === "disabled" || !enabled
    readonly property bool hoveredNow:
        !disabledNow && (forcedState === "hovered"
            || (forcedState === "" && _hovered))
    readonly property bool pressedNow:
        !disabledNow && (forcedState === "pressed"
            || (forcedState === "" && _pressed))
    readonly property bool focusVisible:
        !disabledNow && (forcedState === "focusVisible"
            || (forcedState === "" && activeFocus))

    // Forced off/on pin the value; every other state keeps the host value.
    readonly property bool checkedNow: {
        if (forcedState === "on")
            return true
        if (forcedState === "off" || forcedState === "disabled")
            return false
        return root.checked
    }

    readonly property real thumbWidth: tokens.switchThumbWidth
    readonly property real thumbHeight: tokens.switchThumbHeight
    readonly property real travel: Math.max(0,
        width - tokens.switchThumbWidth - tokens.switchTravelInset)
    property real _thumbX: checkedNow ? travel : 0

    readonly property real progress:
        travel > 0 ? Math.max(0, Math.min(1, _thumbX / travel)) : 0
    readonly property color currentTrackColor: Qt.rgba(
        trackColor.r + (accentColor.r - trackColor.r) * progress,
        trackColor.g + (accentColor.g - trackColor.g) * progress,
        trackColor.b + (accentColor.b - trackColor.b) * progress,
        1.0)

    readonly property color ink: AppearanceTokens.content.glassInk() || "#f2f4f7"

    ControlTokens { id: tokens }

    implicitWidth: tokens.switchWidth
    implicitHeight: tokens.switchHeight

    activeFocusOnTab: true
    opacity: disabledNow ? 0.5 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    // The glass lens scales past the pill on press. Production clips it with a
    // pill mask; the gallery baseline instead clamps the expanded height to the
    // track (see glassThumb), which keeps the lens inside the pill without a
    // per-card offscreen layer.
    Behavior on _thumbX {
        NumberAnimation {
            duration: tokens.switchThumbXDuration
            easing.type: Easing.OutCubic
        }
    }

    Behavior on _expansion {
        NumberAnimation {
            duration: root.pressedNow
                ? tokens.switchPressDuration : tokens.switchReleaseDuration
            easing.type: root.pressedNow ? Easing.OutCubic : Easing.OutQuint
        }
    }

    SequentialAnimation on _stretch {
        id: wobbleAnim
        running: false
        NumberAnimation { to: 0.175; duration: 50; easing.type: Easing.OutQuad }
        NumberAnimation { to: -0.08; duration: 70; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.04; duration: 60; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.0; duration: 50; easing.type: Easing.OutQuad }
    }

    function toggle() {
        if (!enabled || disabledNow)
            return
        // Host confirmation, not a local flip.
        root.toggled(!root.checkedNow)
        wobbleAnim.restart()
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return
                || event.key === Qt.Key_Enter) {
            root.toggle()
            event.accepted = true
        }
    }

    // ── focus ring: shape + ink hairline, never colour alone ──────────────
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: height / 2
        color: "transparent"
        border.width: 2
        border.color: root.accentColor
        visible: root.focusVisible
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        radius: height / 2
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusVisible
    }

    // ── liquid form ───────────────────────────────────────────────────────
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.currentTrackColor
        visible: !root.materialForm

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.15) }
                GradientStop { position: 0.5; color: Qt.rgba(0, 0, 0, 0.05) }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.08) }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.12) }
                GradientStop { position: 0.4; color: Qt.rgba(1, 1, 1, 0.0) }
            }
        }

        // Hover / press state layer, so the pointer states read on the track.
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "#ffffff"
            opacity: root.pressedNow ? 0.12 : root.hoveredNow ? 0.06 : 0.0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }
    }

    // Thumb shadow fades out as the thumb expands.
    Rectangle {
        x: tokens.switchTravelInset / 2 + root._thumbX
            - (width - root.thumbWidth) / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        width: root.thumbWidth * (1 + 0.3 * root._expansion)
        height: Math.min(root.height,
            root.thumbHeight * (1 + 0.3 * root._expansion))
        radius: width / 2
        color: Qt.rgba(0, 0, 0, 0.25)
        opacity: (1 - root._expansion) * 0.5
        visible: !root.materialForm && opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Item {
        id: glassThumb
        x: tokens.switchTravelInset / 2 + root._thumbX
            - (width - root.thumbWidth) / 2
        anchors.verticalCenter: parent.verticalCenter
        width: root.thumbWidth * (1 + 0.4 * root._expansion)
            * (1 - 0.2 * root._stretch)
        height: Math.min(root.height - 2,
            root.thumbHeight * (1 + 0.4 * root._expansion)
                * (1 + 0.3 * root._stretch))
        visible: !root.materialForm

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: "#ffffff"
            opacity: 1 - root._expansion

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "#ffffff" }
                GradientStop { position: 0.5; color: "#f5f5f7" }
                GradientStop { position: 1.0; color: "#e8e8ed" }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 1
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.5
                height: parent.height * 0.35
                radius: width / 2
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.7) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                }
            }
        }

        // Glass lens shown while pressed; matches production's refraction.
        Item {
            anchors.centerIn: parent
            width: parent.width - 2
            height: parent.height - 2
            opacity: root._expansion

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(1, 0.2, 0.2, 0.25 * root._expansion)
                x: -0.5
            }
            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(0.2, 0.9, 1, 0.25 * root._expansion)
                x: 0.5
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                radius: height / 2
                color: Qt.rgba(1, 1, 1, 0.10 + 0.15 * root._expansion)

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: root.checkedNow
                            ? Qt.rgba(root.accentColor.r, root.accentColor.g,
                                root.accentColor.b, 0.4)
                            : Qt.rgba(1, 1, 1, 0.25)
                    }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.12) }
                    GradientStop {
                        position: 1.0
                        color: root.checkedNow
                            ? Qt.rgba(1, 1, 1, 0.25)
                            : Qt.rgba(root.accentColor.r, root.accentColor.g,
                                root.accentColor.b, 0.4)
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.0) }
                        GradientStop { position: 0.6; color: Qt.rgba(0, 0, 0, 0.0) }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.15) }
                    }
                }
            }

            Rectangle {
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.4
                height: parent.height * 0.25
                radius: width / 2
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.5) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.2) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                }
                opacity: 0.4 + 0.4 * root._expansion
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                radius: height / 2
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.30 * root._expansion)
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: root.accentColor
            opacity: 0.10 * root._expansion
        }
    }

    // ── M3 form ───────────────────────────────────────────────────────────
    Item {
        id: materialLayer
        anchors.fill: parent
        visible: root.materialForm

        readonly property real m3Scale: Math.min(1, root.height / 32)
        readonly property real handleSize:
            (root.checkedNow ? 24 : 16) * m3Scale
        readonly property real inset: Math.max(1, 4 * m3Scale)
        readonly property real handleX: inset
            + (root.checkedNow
                ? Math.max(1, root.width - inset * 2 - handleSize) : 0)

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: root.checkedNow ? root.accentColor : root.trackColor
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        // M3 state layer: 10% hover / 16% pressed.
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: materialLayer.handleX + materialLayer.handleSize / 2 - width / 2
            width: Math.min(root.height, 40 * materialLayer.m3Scale)
            height: width
            radius: width / 2
            color: root.accentColor
            opacity: root.pressedNow ? 0.16 : root.hoveredNow ? 0.10 : 0.0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: materialLayer.handleX
            width: materialLayer.handleSize
            height: materialLayer.handleSize
            radius: width / 2
            color: root.checkedNow ? root.handleOnColor : root.handleOffColor
            Behavior on x {
                NumberAnimation {
                    duration: tokens.switchThumbXDuration
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: tokens.switchThumbXDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.disabledNow
        hoverEnabled: true
        cursorShape: root.disabledNow ? Qt.ArrowCursor : Qt.PointingHandCursor

        onEntered: root._hovered = true
        onExited: root._hovered = false
        onPressed: root._pressed = true
        onReleased: root._pressed = false
        onCanceled: {
            root._pressed = false
            root._expansion = 0
        }
        onClicked: {
            root.forceActiveFocus()
            root.toggle()
        }
    }
}
