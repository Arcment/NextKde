import QtQuick
import QtQuick.Shapes
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4c — gallery baseline for GlassComboBox (SPEC §3.12).
//
// height 36, pill radius, Body 13. Both forms read ControlForm.materialForm.
//
//   liquid    glass pill; stroke white 0.16 (dark) / black 0.12 (light)
//   material  M3 filled field, same pill, outline from the colour role
//
// Popup: sheetColor #262b31 (dark) / #f6f8fb (light), radius 16, offset 5
// below the field, padding 8, height min(360, content + 12). The popup is
// drawn inside the component and is never clipped by it, so a state card can
// show the expanded final state.
//
// Forced states used by the matrix: idle / hovered / pressed / focusVisible /
// open / disabled. With forcedState empty the control is live: click to open,
// click a row to choose.
Item {
    id: root

    property var model: ["始终", "跟随系统", "仅深色"]
    property int currentIndex: 1
    property string placeholder: "选择"
    // "" (live) | idle | hovered | pressed | focusVisible | open | disabled
    property string forcedState: ""

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false
    property bool _open: false

    signal activated(int index)

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
    readonly property bool openNow:
        !disabledNow && (forcedState === "open"
            || (forcedState === "" && _open))

    readonly property color primaryColor:
        AppearanceTokens.colors.primary || "#0a84ff"
    readonly property color liquidInk:
        AppearanceTokens.content.glassInk() || "#f2f4f7"
    readonly property color materialInk:
        AppearanceTokens.colors.surfaceForeground || "#f2f4f7"
    readonly property color materialFill:
        AppearanceTokens.colors.surfaceContainerHigh || "#262b31"
    readonly property color outlineColor:
        AppearanceTokens.colors.outline
            || (AppearanceTokens.isDarkTheme ? "#8d9199" : "#6f7377")
    // SPEC §3.12 sheet token, fixed per theme (not the M3 role).
    readonly property color sheetColor:
        AppearanceTokens.isDarkTheme ? "#262b31" : "#f6f8fb"
    readonly property color sheetInk:
        (sheetColor.r * 0.2126 + sheetColor.g * 0.7152
            + sheetColor.b * 0.0722) > 0.55 ? "#1b1b1f" : "#f2f4f7"
    // SPEC §3.12 stroke alpha: dark 0.16 / light 0.12.
    readonly property color comboStroke:
        AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.12)

    readonly property color ink: materialForm ? materialInk : liquidInk
    readonly property color inkDim: Qt.rgba(ink.r, ink.g, ink.b, 0.58)
    readonly property color selectedInk:
        (primaryColor.r * 0.2126 + primaryColor.g * 0.7152
            + primaryColor.b * 0.0722) > 0.55 ? "#101010" : "#ffffff"

    ControlTokens { id: tokens }

    implicitHeight: tokens.comboHeight
    implicitWidth: 160

    activeFocusOnTab: true
    opacity: disabledNow ? 0.38 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    readonly property int popupContentHeight:
        model.length * tokens.comboItemHeight + tokens.comboPopupPadding * 2
    readonly property int popupHeight:
        Math.min(tokens.comboPopupMaxHeight, popupContentHeight + 12)

    // ── focus ring: shape, not colour alone ───────────────────────────────
    Rectangle {
        anchors.fill: fieldBody
        anchors.margins: -3
        radius: fieldBody.radius + 3
        color: "transparent"
        border.width: 2
        border.color: root.primaryColor
        visible: root.focusVisible
    }
    Rectangle {
        anchors.fill: fieldBody
        anchors.margins: -1
        radius: fieldBody.radius + 1
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusVisible
    }

    // ── field ─────────────────────────────────────────────────────────────
    Rectangle {
        id: fieldBody
        anchors.fill: parent
        radius: tokens.comboRadiusPill

        color: root.materialForm ? root.materialFill : "transparent"
        border.width: root.hoveredNow || root.openNow ? 2 : 1
        border.color: root.materialForm
            ? (root.hoveredNow || root.openNow
                ? root.primaryColor : root.outlineColor)
            : (root.hoveredNow || root.openNow
                ? Qt.rgba(1, 1, 1, 0.34) : root.comboStroke)

        gradient: root.materialForm ? null : fieldGradient

        Gradient {
            id: fieldGradient
            orientation: Gradient.Vertical
            GradientStop {
                position: 0.0
                color: Qt.rgba(1, 1, 1, root.openNow ? 0.28
                    : root.hoveredNow ? 0.24 : 0.18)
            }
            GradientStop {
                position: 1.0
                color: Qt.rgba(1, 1, 1, root.openNow ? 0.16
                    : root.hoveredNow ? 0.12 : 0.08)
            }
        }

        // State layer.
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.materialForm ? root.materialInk : "#ffffff"
            opacity: root.pressedNow ? 0.12 : root.hoveredNow ? 0.06 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: tokens.expandDuration }
            }
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: chevron.left
        anchors.leftMargin: 8
        anchors.rightMargin: 4
        text: (root.model.length > 0 && root.currentIndex >= 0
                && root.currentIndex < root.model.length)
            ? String(root.model[root.currentIndex]) : root.placeholder
        color: root.ink
        font.pixelSize: tokens.bodyFontSize
        elide: Text.ElideRight
    }

    // Chevron: two stroked segments; flips when the popup is open.
    Shape {
        id: chevron
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: 10
        height: 6
        rotation: root.openNow ? 180 : 0
        transformOrigin: Item.Center
        Behavior on rotation {
            NumberAnimation { duration: tokens.expandDuration; easing.type: Easing.OutCubic }
        }

        ShapePath {
            strokeColor: root.ink
            strokeWidth: 1.5
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: 1.0
            startY: 1.2
            PathLine { x: 5.0; y: 5.0 }
            PathLine { x: 9.0; y: 1.2 }
        }
    }

    // ── popup (final state, drawn unclipped) ──────────────────────────────
    Item {
        id: popup
        visible: root.openNow
        x: 0
        y: fieldBody.height + tokens.comboPopupOffset
        width: root.width
        height: root.popupHeight

        Rectangle {
            anchors.fill: parent
            radius: tokens.comboRadiusCard
            color: root.sheetColor
            border.width: 1
            border.color: AppearanceTokens.isDarkTheme
                ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, 0.10)
        }

        Column {
            anchors.fill: parent
            anchors.margins: tokens.comboPopupPadding
            spacing: 0

            Repeater {
                model: root.model

                delegate: Rectangle {
                    id: popupRow
                    required property var modelData
                    required property int index

                    width: parent.width
                    height: tokens.comboItemHeight
                    radius: 8
                    color: index === root.currentIndex
                        ? root.primaryColor : "transparent"

                    property bool rowHovered: false

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: root.sheetInk
                        opacity: popupRow.rowHovered
                            && popupRow.index !== root.currentIndex ? 0.06 : 0.0
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        anchors.right: rowCheck.left
                        anchors.rightMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        text: String(popupRow.modelData)
                        color: popupRow.index === root.currentIndex
                            ? root.selectedInk : root.sheetInk
                        font.pixelSize: tokens.bodyFontSize
                        elide: Text.ElideRight
                    }

                    Text {
                        id: rowCheck
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                        visible: popupRow.index === root.currentIndex
                        text: "✓"
                        color: root.selectedInk
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: popupRow.rowHovered = true
                        onExited: popupRow.rowHovered = false
                        onClicked: {
                            root.currentIndex = popupRow.index
                            root._open = false
                            root.activated(popupRow.index)
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: fieldBody
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
            root._open = !root._open
        }
    }
}
