import QtQuick
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4b — gallery baseline for GlassTextField (SPEC §3.10).
//
// height 28, regular material, Body 13/16. Both forms read
// ControlForm.materialForm.
//
//   liquid   pill body, QML glass gradient, 1px hairline
//   material M3 filled field, radius 10, 1px outline
//
// Focus is two shapes, not one colour swap: the field stroke grows to 2px
// accent AND a 2px ring is drawn 3px outside it (plus the inner ink hairline
// for contrast on saturated backdrops). The body tint also deepens.
// Error is a 2px error stroke AND an exclamation badge, so it is never
// signalled by colour alone.
//
// State cards set forcedState = normal / hovered / focused / error / filled /
// disabled. With forcedState empty the field is live and editable.
Item {
    id: root

    property string text: ""
    property string placeholder: "输入文字"
    // "" (live) | normal | hovered | focused | error | filled | disabled
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _active: false

    readonly property bool disabledNow: forcedState === "disabled" || !enabled
    readonly property bool errorNow: forcedState === "error"
    readonly property bool focusedNow:
        !disabledNow && (forcedState === "focused"
            || (forcedState === "" && _active))
    readonly property bool hoveredNow:
        !disabledNow && (forcedState === "hovered"
            || (forcedState === "" && _hovered))

    readonly property color primaryColor:
        AppearanceTokens.colors.primary || "#0a84ff"
    readonly property color errorColor:
        AppearanceTokens.colors.error || "#b3261e"
    readonly property color liquidInk:
        AppearanceTokens.content.glassInk() || "#f2f4f7"
    readonly property color materialInk:
        AppearanceTokens.colors.surfaceForeground || "#f2f4f7"
    readonly property color materialFill:
        AppearanceTokens.colors.surfaceContainerHigh || "#262b31"
    readonly property color outlineColor:
        AppearanceTokens.colors.outline
            || (AppearanceTokens.isDarkTheme ? "#8d9199" : "#6f7377")
    readonly property color hairline:
        AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.34) : Qt.rgba(0, 0, 0, 0.26)

    readonly property color ink: materialForm ? materialInk : liquidInk
    readonly property color inkDim:
        Qt.rgba(ink.r, ink.g, ink.b, 0.55)

    ControlTokens { id: tokens }

    implicitHeight: tokens.fieldHeight
    implicitWidth: 160

    opacity: disabledNow ? 0.38 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    // ── focus ring: shape + stroke, never colour alone ────────────────────
    Rectangle {
        anchors.fill: fieldBody
        anchors.margins: -3
        radius: fieldBody.radius + 3
        color: "transparent"
        border.width: 2
        border.color: root.primaryColor
        visible: root.focusedNow
    }
    Rectangle {
        anchors.fill: fieldBody
        anchors.margins: -1
        radius: fieldBody.radius + 1
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusedNow
    }

    // ── body ──────────────────────────────────────────────────────────────
    Rectangle {
        id: fieldBody
        anchors.fill: parent
        radius: root.materialForm ? tokens.buttonRadiusSmall : height / 2

        color: root.materialForm ? root.materialFill : "transparent"
        border.width: root.focusedNow || root.errorNow ? 2 : 1
        border.color: root.errorNow ? root.errorColor
            : root.focusedNow || root.hoveredNow ? root.primaryColor
            : root.materialForm ? root.outlineColor
            : root.hairline

        gradient: root.materialForm ? null : fieldGradient

        Gradient {
            id: fieldGradient
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: Qt.rgba(1, 1, 1, root.focusedNow ? 0.34
                    : root.hoveredNow ? 0.26 : 0.20)
            }
            GradientStop {
                position: 0.55
                color: Qt.rgba(1, 1, 1, root.focusedNow ? 0.16
                    : root.hoveredNow ? 0.12 : 0.08)
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(1, 1, 1, root.focusedNow ? 0.22
                    : root.hoveredNow ? 0.18 : 0.14)
            }
        }

        // Focus deepens the tint in both forms; hover is the lighter step.
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.primaryColor
            opacity: root.focusedNow ? 0.10 : root.hoveredNow ? 0.05 : 0.0
            Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }
        }
    }

    // ── text ──────────────────────────────────────────────────────────────
    Item {
        anchors.fill: fieldBody
        anchors.leftMargin: 10
        anchors.rightMargin: root.errorNow ? 26 : 10
        clip: true

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            visible: input.text.length === 0
            text: root.placeholder
            color: root.inkDim
            font.pixelSize: tokens.bodyFontSize
            elide: Text.ElideRight
        }

        TextInput {
            id: input
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            text: root.text
            color: root.ink
            font.pixelSize: tokens.bodyFontSize
            readOnly: root.forcedState !== ""
            selectByMouse: true
            activeFocusOnTab: true
            clip: true
            onTextEdited: root.text = text
            onActiveFocusChanged: root._active = activeFocus
        }
    }

    // Error badge: shape (circle) + glyph, so the state survives a
    // greyscale screenshot.
    Rectangle {
        anchors.right: fieldBody.right
        anchors.rightMargin: 6
        anchors.verticalCenter: fieldBody.verticalCenter
        width: 14
        height: 14
        radius: 7
        color: root.errorColor
        visible: root.errorNow
        border.width: 1
        border.color: Qt.rgba(0, 0, 0, 0.18)

        Text {
            anchors.centerIn: parent
            text: "!"
            color: "#ffffff"
            font.pixelSize: 10
            font.weight: Font.Bold
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        enabled: !root.disabledNow
        onEntered: root._hovered = true
        onExited: root._hovered = false
    }
}
