import QtQuick
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4a — gallery baseline for GlassButton (SPEC §3.9).
//
// Not a copy of the production LiquidGlassButton: the gallery draws the
// baseline once, in the gallery, so the matrix can force states that a static
// screenshot cannot otherwise reach. Both forms read ControlForm.materialForm,
// the same switch the shell uses.
//
//   liquid   pill, QML glass body, expansion 0 → 0.3 → 1.0 from the token
//   material filled tonal button, small radius 10, M3 state layer
//
// State cards set forcedState = idle / hovered / pressed / focus / disabled.
// With forcedState empty the control behaves live.
Item {
    id: root

    property string text: "确定"
    property string glyph: ""
    property bool iconOnly: false
    // "" (live) | idle | hovered | pressed | focus | disabled
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false

    readonly property bool hoveredNow:
        forcedState === "hovered" || (forcedState === "" && _hovered)
    readonly property bool pressedNow:
        forcedState === "pressed" || (forcedState === "" && _pressed)
    readonly property bool focusVisible:
        forcedState === "focus" || (forcedState === "" && activeFocus)
    readonly property bool disabledNow: forcedState === "disabled" || !enabled

    signal clicked()

    ControlTokens { id: tokens }

    // Token colours can resolve to undefined for the first frame while the
    // appearance services load; fall back to the theme's ink so the binding
    // never assigns undefined to a colour role.
    readonly property color liquidInk:
        AppearanceTokens.content.glassInk(1.0)
            || (AppearanceTokens.isDarkTheme ? "#ffffff" : "#1b1b1b")
    // M3 filled button. The scheme's primary role is the token; the ink is
    // chosen from the resulting luminance so the label can never disappear
    // when a role resolves late or the shell style has no M3 palette.
    readonly property color materialFill:
        AppearanceTokens.colors.primary || "#0a84ff"
    readonly property color materialInk:
        (materialFill.r * 0.2126 + materialFill.g * 0.7152
            + materialFill.b * 0.0722) > 0.55 ? "#101010" : "#ffffff"

    implicitHeight: tokens.buttonHeight
    implicitWidth: iconOnly
        ? tokens.buttonHeight
        : Math.max(72, label.implicitWidth + tokens.buttonPadding * 2)

    activeFocusOnTab: true
    opacity: disabledNow ? 0.38 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    // Expansion is the token value, never a literal in the drawing.
    property real expansion: disabledNow ? tokens.expansionIdle
        : pressedNow ? tokens.expansionPressed
        : hoveredNow ? tokens.expansionHovered
        : tokens.expansionIdle
    Behavior on expansion {
        NumberAnimation {
            duration: root.pressedNow ? tokens.expandDuration : tokens.releaseDuration
            easing.type: root.pressedNow ? Easing.OutBack : Easing.OutQuint
            easing.overshoot: root.pressedNow ? 1.25 : 1.0
        }
    }

    scale: materialForm
        ? (pressedNow ? 0.98 : 1.0)
        : (pressedNow ? 0.96 : hoveredNow ? 1.02 : 1.0)
    Behavior on scale { NumberAnimation { duration: tokens.expandDuration; easing.type: Easing.OutCubic } }

    // ── focus ring: shape, not just a colour change ───────────────────────
    Rectangle {
        id: focusRing
        anchors.fill: body
        anchors.margins: -4
        radius: body.radius + 4
        color: "transparent"
        border.width: 2
        border.color: AppearanceTokens.colors.primary
        visible: root.focusVisible && !root.disabledNow
    }
    Rectangle {
        anchors.fill: body
        anchors.margins: -1
        radius: body.radius + 1
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusVisible && !root.disabledNow
    }

    // ── body ──────────────────────────────────────────────────────────────
    Rectangle {
        id: body
        anchors.centerIn: parent
        width: parent.width * (0.88 + 0.12 * root.expansion)
        height: parent.height * (0.88 + 0.12 * root.expansion)
        radius: root.materialForm ? tokens.buttonRadiusSmall : height / 2

        color: root.materialForm ? root.materialFill : "transparent"
        border.width: root.materialForm ? 0 : 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.32 + 0.28 * root.expansion)
            : Qt.rgba(0, 0, 0, 0.18 + 0.14 * root.expansion)

        gradient: root.materialForm ? null : liquidGradient

        Gradient {
            id: liquidGradient
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.26 + 0.18 * root.expansion) }
            GradientStop { position: 0.35; color: Qt.rgba(1, 1, 1, 0.12 + 0.08 * root.expansion) }
            GradientStop { position: 0.65; color: Qt.rgba(1, 1, 1, 0.08 + 0.06 * root.expansion) }
            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.22 + 0.14 * root.expansion) }
        }

        // Material 3 state layer (hover 8%, press 12%).
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            visible: root.materialForm
            color: root.materialInk
            opacity: root.pressedNow ? 0.12 : root.hoveredNow ? 0.08 : 0.0
            Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }
        }

        // Liquid specular cap.
        Rectangle {
            visible: !root.materialForm
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.52
            height: Math.max(3, parent.height * 0.16)
            radius: height / 2
            color: Qt.rgba(1, 1, 1, 0.26 + 0.24 * root.expansion)
        }
    }

    Row {
        anchors.centerIn: parent
        height: tokens.bodyLineHeight
        spacing: 5

        // Positioners own child x/y, so the labels use vertical text alignment
        // instead of vertical anchors.
        Text {
            visible: root.glyph !== ""
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: root.glyph
            color: root.materialForm ? root.materialInk : root.liquidInk
            font.pixelSize: root.materialForm ? 14 : 13
            font.weight: Font.DemiBold
        }

        Text {
            id: label
            visible: !root.iconOnly
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: root.text
            color: root.materialForm ? root.materialInk : root.liquidInk
            font.pixelSize: tokens.bodyFontSize
            font.weight: Font.Medium
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
            root.clicked()
        }
    }
}
