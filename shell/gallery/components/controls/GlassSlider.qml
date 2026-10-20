import QtQuick
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4d — gallery baseline for GlassSlider (SPEC §3.14).
//
// value 0..1, track 6, thumb 32×16, height 44, accent read from ControlTokens.
// Both forms read ControlForm.materialForm.
//
//   liquid    iOS glass: translucent thumb with refraction + specular layers
//   material  M3: thin inactive track, thick active track, capsule handle
//             scaled by m3Scale = min(1, h / 44)
//
// Contract: the host owns `value`. Dragging emits previewChanged; release
// emits commitRequested(still-current value) and suppresses the thumb x
// animation for 400 ms so an async write-back lands without a visible slide.
// Ctrl+wheel steps by wheelStep 0.01 (mouse, angleDelta ±120) or
// wheelPixelStep 10 (touchpad pixels), then commits after a 180 ms debounce.
// canceled() fires when the interaction is revoked (disabled / hidden).
//
// Forced states used by the matrix: idle / hovered / pressed / disabled. The
// two value cards pass a value with forcedState idle, so they stay inert.
// `wheelValue` / `wheelSteps` are gallery-only readouts for the live row.
Item {
    id: root

    property real value: 0.0
    property bool enabled: true
    property color accentColor: tokens.accentColor
    property color trackColor: Qt.rgba(0.5, 0.5, 0.55, 0.35)
    property real trackHeight: tokens.sliderTrackHeight
    property real thumbWidth: tokens.sliderThumbWidth
    property real thumbHeight: tokens.sliderThumbHeight
    property real wheelStep: 0.01
    property real wheelPixelStep: 10
    // "" (live) | idle | hovered | pressed | disabled
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false
    property bool _suppressXAnimation: false
    property bool _wheelPending: false
    property real _angleAccum: 0
    property real _pixelAccum: 0

    // Live-row readout only; not part of the control contract.
    property real wheelValue: -1
    property int wheelSteps: 0

    signal previewChanged(real value)
    signal commitRequested(real value)
    signal canceled()

    readonly property bool disabledNow: forcedState === "disabled" || !enabled
    readonly property bool hoveredNow:
        !disabledNow && (forcedState === "hovered"
            || (forcedState === "" && _hovered))
    readonly property bool pressedNow:
        !disabledNow && (forcedState === "pressed"
            || (forcedState === "" && _pressed))

    readonly property real visualValue: Math.max(0, Math.min(1, value))
    readonly property real edgeInset: thumbWidth / 2
    readonly property real travel: Math.max(1, width - edgeInset * 2)
    readonly property real thumbCenterX: edgeInset + visualValue * travel

    // SPEC §2.7 expansion, §3.14 hover converges on 0.3.
    property real _expansion: pressedNow ? tokens.expansionPressed
        : hoveredNow ? tokens.expansionHovered : 0.0
    Behavior on _expansion {
        NumberAnimation {
            duration: root.pressedNow
                ? tokens.sliderPressedDuration : tokens.sliderReleaseDuration
            easing.type: Easing.OutQuint
        }
    }

    ControlTokens { id: tokens }

    implicitWidth: 240
    implicitHeight: tokens.sliderHeight

    opacity: disabledNow ? 0.45 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    // ── Ctrl+wheel stepping ───────────────────────────────────────────────
    // A bare wheel belongs to the scrolling panel this slider usually lives
    // in; Ctrl is the signal that the pointer means the slider. Mouse and
    // touchpad deltas have different magnitudes, so each accumulates against
    // its own step size.
    function stepByWheel(delta) {
        if (!enabled || !visible || _pressed || delta === 0)
            return
        const next = Math.max(0, Math.min(1, visualValue + delta * wheelStep))
        if (Math.abs(next - visualValue) < 1e-9)
            return
        _wheelPending = true
        wheelValue = next
        wheelSteps += 1
        previewChanged(next)
        wheelCommitTimer.restart()
    }

    function accumulateWheel(angleY, pixelY) {
        if (!enabled || !visible || _pressed)
            return
        if (pixelY !== 0) {
            _pixelAccum += pixelY
            while (Math.abs(_pixelAccum) >= wheelPixelStep) {
                stepByWheel(_pixelAccum > 0 ? 1 : -1)
                _pixelAccum -= (_pixelAccum > 0 ? wheelPixelStep : -wheelPixelStep)
            }
        } else if (angleY !== 0) {
            _angleAccum += angleY
            while (Math.abs(_angleAccum) >= 120) {
                stepByWheel(_angleAccum > 0 ? 1 : -1)
                _angleAccum -= (_angleAccum > 0 ? 120 : -120)
            }
        }
    }

    Timer {
        id: wheelCommitTimer
        interval: tokens.sliderCommitDebounce
        onTriggered: {
            if (!root._wheelPending)
                return
            root._wheelPending = false
            root.commitRequested(root.value)
        }
    }

    Timer {
        id: suppressXAnimTimer
        interval: tokens.sliderSuppressX
        onTriggered: root._suppressXAnimation = false
    }

    function cancelInteraction() {
        const active = _pressed || _wheelPending
        _wheelPending = false
        wheelCommitTimer.stop()
        _angleAccum = 0
        _pixelAccum = 0
        if (!active)
            return
        _pressed = false
        _expansion = 0
        canceled()
    }
    onEnabledChanged: { if (!enabled) cancelInteraction() }
    onVisibleChanged: { if (!visible) cancelInteraction() }

    function positionForPointer(pointerX) {
        return Math.max(0, Math.min(1, (pointerX - edgeInset) / travel))
    }

    // ── iOS glass form ────────────────────────────────────────────────────
    Item {
        id: liquidLayer
        anchors.fill: parent
        visible: !root.materialForm

        Rectangle {
            id: track
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: root.trackHeight
            radius: height / 2
            color: root.trackColor

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.12) }
                    GradientStop { position: 0.5; color: Qt.rgba(0, 0, 0, 0.03) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.06) }
                }
            }
        }

        Rectangle {
            id: progress
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(height, root.thumbCenterX)
            height: root.trackHeight
            radius: height / 2
            color: root.accentColor

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.45) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.12) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
                }
            }
        }
    }

    Item {
        id: glassThumb
        x: root.thumbCenterX - root.thumbWidth / 2
        anchors.verticalCenter: parent.verticalCenter
        width: root.thumbWidth
        height: root.thumbHeight
        visible: !root.materialForm

        transform: Scale {
            origin.x: root.thumbWidth / 2
            origin.y: root.thumbHeight / 2
            xScale: 1 + 0.06 * root._expansion
            yScale: 1 + 0.06 * root._expansion
        }

        Behavior on x {
            NumberAnimation {
                duration: root.pressedNow || root._suppressXAnimation
                    ? 0 : tokens.sliderThumbXDuration
                easing.type: Easing.OutQuint
            }
        }

        // Ambient shadow.
        Rectangle {
            anchors.fill: parent
            anchors.verticalCenterOffset: root.pressedNow ? 2.0
                : root.hoveredNow ? 1.4 : 0.8
            radius: height / 2
            color: root.pressedNow ? Qt.rgba(0, 0, 0, 0.32)
                : root.hoveredNow ? Qt.rgba(0, 0, 0, 0.24)
                : Qt.rgba(0, 0, 0, 0.16)
            z: -1
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }
            Behavior on color { ColorAnimation { duration: 160 } }
        }

        // Frosted base pill.
        Rectangle {
            id: basePill
            anchors.fill: parent
            radius: height / 2

            readonly property real baseAlpha:
                AppearanceTokens.isDarkTheme ? 0.36 : 0.70

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(1, 1, 1, Math.min(0.96,
                        basePill.baseAlpha * (root.pressedNow ? 1.25
                            : root.hoveredNow ? 1.12 : 1.0)))
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0.96, 0.96, 0.96, Math.min(0.90,
                        basePill.baseAlpha * 0.72 * (root.pressedNow ? 1.25
                            : root.hoveredNow ? 1.12 : 1.0)))
                }
            }

            border.width: 1
            border.color: root.pressedNow
                ? (AppearanceTokens.isDarkTheme
                    ? Qt.rgba(1, 1, 1, 0.75) : Qt.rgba(0, 0, 0, 0.35))
                : root.hoveredNow
                    ? (AppearanceTokens.isDarkTheme
                        ? Qt.rgba(1, 1, 1, 0.55) : Qt.rgba(0, 0, 0, 0.25))
                    : (AppearanceTokens.isDarkTheme
                        ? Qt.rgba(1, 1, 1, 0.32) : Qt.rgba(0, 0, 0, 0.16))
            Behavior on border.color { ColorAnimation { duration: 160 } }
        }

        // Refraction / accent transmission.
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            opacity: 0.50 + 0.40 * root._expansion

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop {
                    position: 0.0
                    color: root.visualValue > 0.05
                        ? Qt.rgba(root.accentColor.r, root.accentColor.g,
                            root.accentColor.b, AppearanceTokens.isDarkTheme
                                ? 0.35 + 0.15 * root._expansion
                                : 0.22 + 0.12 * root._expansion)
                        : (AppearanceTokens.isDarkTheme
                            ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.08))
                }
                GradientStop {
                    position: 0.4
                    color: AppearanceTokens.isDarkTheme
                        ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(1, 1, 1, 0.25)
                }
                GradientStop {
                    position: 0.7
                    color: AppearanceTokens.isDarkTheme
                        ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(1, 1, 1, 0.20)
                }
                GradientStop {
                    position: 1.0
                    color: root.visualValue > 0.95
                        ? Qt.rgba(root.accentColor.r, root.accentColor.g,
                            root.accentColor.b, AppearanceTokens.isDarkTheme
                                ? 0.30 + 0.15 * root._expansion
                                : 0.18 + 0.12 * root._expansion)
                        : Qt.rgba(root.trackColor.r, root.trackColor.g,
                            root.trackColor.b, 0.25)
                }
            }
        }

        // Top specular chamfer.
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.55
            height: Math.max(2, parent.height * 0.26)
            radius: height / 2

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(1, 1, 1, root.pressedNow ? 0.75
                        : root.hoveredNow ? 0.65 : 0.45)
                }
                GradientStop {
                    position: 0.6
                    color: Qt.rgba(1, 1, 1, root.pressedNow ? 0.28
                        : root.hoveredNow ? 0.20 : 0.12)
                }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.0) }
            }
            opacity: AppearanceTokens.isDarkTheme ? 0.85 : 0.95
        }

        // Inner specular rim.
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: root.pressedNow ? Qt.rgba(1, 1, 1, 0.45)
                : root.hoveredNow ? Qt.rgba(1, 1, 1, 0.30)
                : Qt.rgba(1, 1, 1, 0.16)
            Behavior on border.color { ColorAnimation { duration: 160 } }
        }

        // Accent glow.
        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: root.accentColor
            opacity: root.pressedNow ? 0.16 : root.hoveredNow ? 0.08 : 0.03
            Behavior on opacity { NumberAnimation { duration: 160 } }
        }
    }

    // ── M3 form ───────────────────────────────────────────────────────────
    Item {
        id: materialLayer
        anchors.fill: parent
        visible: root.materialForm

        readonly property real m3Scale: Math.min(1, root.height / 44)
        readonly property real inactiveTrack: Math.max(2, 4 * m3Scale)
        readonly property real activeTrack: Math.max(6, 16 * m3Scale)
        readonly property real handleWidth: Math.max(3, 4 * m3Scale)
        readonly property real handleHeight: Math.min(root.height, 44 * m3Scale)
        readonly property real handleX: root.thumbCenterX - handleWidth / 2

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: root.edgeInset
            width: Math.max(0, root.width - root.edgeInset * 2)
            height: materialLayer.inactiveTrack
            radius: height / 2
            color: root.trackColor
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: root.edgeInset
            width: Math.max(0, materialLayer.handleX - root.edgeInset)
            height: materialLayer.activeTrack
            radius: height / 2
            color: root.accentColor
        }

        // M3 state layer: 10% hover / 16% pressed.
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: materialLayer.handleX + materialLayer.handleWidth / 2 - width / 2
            width: height
            height: Math.min(root.height, 40 * materialLayer.m3Scale)
            radius: height / 2
            color: root.accentColor
            opacity: root.pressedNow ? 0.16 : root.hoveredNow ? 0.10 : 0.0
            Behavior on opacity { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: materialLayer.handleX
            width: materialLayer.handleWidth
            height: materialLayer.handleHeight
            radius: width / 2
            color: root.accentColor
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.disabledNow
        hoverEnabled: true
        cursorShape: root.disabledNow ? Qt.ArrowCursor : Qt.PointingHandCursor

        // Bare wheel scrolls the host panel; Ctrl+wheel is ours.
        onWheel: function(wheel) {
            if (!(wheel.modifiers & Qt.ControlModifier)) {
                wheel.accepted = false
                return
            }
            root.accumulateWheel(wheel.angleDelta.y, wheel.pixelDelta.y)
            wheel.accepted = true
        }

        onEntered: root._hovered = true
        onExited: root._hovered = false

        onPressed: function(mouse) {
            root._pressed = true
            root._wheelPending = false
            wheelCommitTimer.stop()
            root._angleAccum = 0
            root._pixelAccum = 0
            root.previewChanged(root.positionForPointer(mouse.x))
        }

        onPositionChanged: function(mouse) {
            if (!pressed)
                return
            root.previewChanged(root.positionForPointer(mouse.x))
        }

        onReleased: function() {
            if (!root._pressed)
                return
            root._pressed = false
            // Commit the current value, not the release position: the pointer
            // usually drifts 1–2 px on release.
            root._suppressXAnimation = true
            suppressXAnimTimer.restart()
            root.commitRequested(root.value)
        }

        onCanceled: root.cancelInteraction()
    }
}
