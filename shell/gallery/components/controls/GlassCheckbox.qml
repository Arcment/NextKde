import QtQuick
import QtQuick.Shapes
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4b — gallery baseline for GlassCheckbox (SPEC §3.11).
//
// box 20×20, radius 5, label Body 13. Both forms read
// ControlForm.materialForm.
//
//   liquid   glass box, hairline, accent fill when checked
//   material M3 box, 2px outline unchecked, accent fill checked
//
// Checked is drawn as a check path, not a colour change; focusVisible is a
// ring around the box (shape + ink hairline), so neither survives only as
// colour.
//
// State cards set forcedState = unchecked / checked / hovered / pressed /
// focusVisible / disabled. With forcedState empty the box is live.
Item {
    id: root

    property string text: "选项"
    property bool checked: false
    // "" (live) | unchecked | checked | hovered | pressed | focusVisible |
    // disabled
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false

    signal toggled(bool checked)

    readonly property bool disabledNow: forcedState === "disabled" || !enabled
    readonly property bool hoveredNow:
        !disabledNow && (forcedState === "hovered"
            || (forcedState === "" && _hovered))
    readonly property bool pressedNow:
        !disabledNow && (forcedState === "pressed"
            || (forcedState === "" && _pressed))
    readonly property bool focusVisible:
        !disabledNow && (forcedState === "focusVisible"
            || (forcedState === "" && activeFocus))
    readonly property bool checkedNow:
        forcedState === "checked" || forcedState === "focusVisible"
            || (forcedState === "" && root.checked)

    readonly property color primaryColor:
        AppearanceTokens.colors.primary || "#0a84ff"
    readonly property color liquidInk:
        AppearanceTokens.content.glassInk() || "#f2f4f7"
    readonly property color materialInk:
        AppearanceTokens.colors.surfaceForeground || "#f2f4f7"
    readonly property color outlineColor:
        AppearanceTokens.colors.outline
            || (AppearanceTokens.isDarkTheme ? "#8d9199" : "#6f7377")
    readonly property color hairline:
        AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.42) : Qt.rgba(0, 0, 0, 0.32)

    readonly property color ink: materialForm ? materialInk : liquidInk
    // The check has to stay visible on the accent fill; choose by luminance
    // instead of trusting a role that can resolve late.
    readonly property color checkInk:
        (primaryColor.r * 0.2126 + primaryColor.g * 0.7152
            + primaryColor.b * 0.0722) > 0.55 ? "#101010" : "#ffffff"

    ControlTokens { id: tokens }

    implicitWidth: row.implicitWidth
    implicitHeight: tokens.checkBoxSize

    opacity: disabledNow ? 0.38 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    activeFocusOnTab: true

    // ── focus ring: shape around the box, plus ink hairline ───────────────
    Rectangle {
        anchors.fill: box
        anchors.margins: -3
        radius: tokens.checkBoxRadius + 3
        color: "transparent"
        border.width: 2
        border.color: root.primaryColor
        visible: root.focusVisible
    }
    Rectangle {
        anchors.fill: box
        anchors.margins: -1
        radius: tokens.checkBoxRadius + 1
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusVisible
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        // ── box ───────────────────────────────────────────────────────────
        Item {
            id: box
            width: tokens.checkBoxSize
            height: tokens.checkBoxSize

            Rectangle {
                id: boxBody
                anchors.fill: parent
                radius: tokens.checkBoxRadius

                color: root.checkedNow ? root.primaryColor : "transparent"
                border.width: root.checkedNow ? 0
                    : root.materialForm ? 2 : 1
                border.color: root.hoveredNow || root.pressedNow
                    ? root.primaryColor
                    : root.materialForm ? root.outlineColor : root.hairline

                gradient: root.materialForm || root.checkedNow
                    ? null : boxGradient

                Gradient {
                    id: boxGradient
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(1, 1, 1, root.hoveredNow ? 0.30 : 0.22)
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(1, 1, 1, root.hoveredNow ? 0.18 : 0.12)
                    }
                }

                // State layer (hover 8%, press 12%) in the form's contrast ink.
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: root.checkedNow ? root.checkInk : root.primaryColor
                    opacity: root.pressedNow ? 0.12 : root.hoveredNow ? 0.08 : 0.0
                    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }
                }

                scale: root.pressedNow ? 0.90 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: tokens.expandDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            // The check: two stroked segments, not a color swap.
            Shape {
                anchors.fill: parent
                visible: root.checkedNow

                ShapePath {
                    strokeColor: root.checkInk
                    strokeWidth: 2
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap
                    joinStyle: ShapePath.RoundJoin
                    startX: 5.0
                    startY: 10.3
                    PathLine { x: 8.4; y: 13.8 }
                    PathLine { x: 15.0; y: 6.6 }
                }
            }
        }

        // ── label ─────────────────────────────────────────────────────────
        Text {
            id: label
            height: tokens.checkBoxSize
            verticalAlignment: Text.AlignVCenter
            text: root.text
            color: root.ink
            font.pixelSize: tokens.bodyFontSize
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
        onCanceled: root._pressed = false
        onClicked: {
            root.forceActiveFocus()
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
}
