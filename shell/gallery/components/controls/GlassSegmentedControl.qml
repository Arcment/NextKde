import QtQuick
import qs.desktop.modules.common
import "../../../shared/qml/controls" as SharedControls

// G4c — gallery baseline for SegmentedControl (SPEC §3.8).
//
// One ratio system, two forms:
//   liquid    pill form, radius = height / 2
//   material  card form, radius = height × 0.38
//
// cell 72×40, outerPadding 2, Body 13. The matrix draws a compact two-cell
// sample (40×26 cells) because a state card is only ~88 px wide; the section
// also shows a full-size three-cell sample below the matrix.
//
// Forced states: idle / hovered / pressed / focusVisible / selected /
// disabled. With forcedState empty the control is live.
Item {
    id: root

    property var model: ["日", "周", "月"]
    property int currentIndex: 0
    // "" (live) | idle | hovered | pressed | focusVisible | selected |
    // disabled
    property string forcedState: ""
    property int cellWidth: tokens.segmentCellWidth
    property int cellHeight: tokens.segmentCellHeight

    readonly property bool materialForm: SharedControls.ControlForm.materialForm

    property bool _hovered: false
    property bool _pressed: false

    signal selected(int index)

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

    // Hover/press act on a cell that is not the current one, so the state
    // layer stays readable next to the selected segment.
    readonly property int activeCell:
        model.length === 0 ? -1 : (currentIndex === 0 ? 1 : 0)

    readonly property color primaryColor:
        AppearanceTokens.colors.primary || "#0a84ff"
    readonly property color liquidInk:
        AppearanceTokens.content.glassInk() || "#f2f4f7"
    readonly property color materialInk:
        AppearanceTokens.colors.surfaceForeground || "#f2f4f7"
    readonly property color materialTrack:
        AppearanceTokens.colors.surfaceContainerHigh || "#262b31"
    readonly property color outlineColor:
        AppearanceTokens.colors.outline
            || (AppearanceTokens.isDarkTheme ? "#8d9199" : "#6f7377")
    readonly property color hairline:
        AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(0, 0, 0, 0.20)
    readonly property color selectedInk:
        (primaryColor.r * 0.2126 + primaryColor.g * 0.7152
            + primaryColor.b * 0.0722) > 0.55 ? "#101010" : "#ffffff"

    readonly property color ink: materialForm ? materialInk : liquidInk

    ControlTokens { id: tokens }

    readonly property int outerPadding: tokens.segmentOuterPadding
    readonly property int outerHeight: cellHeight + outerPadding * 2
    readonly property real bodyRadius: materialForm
        ? outerHeight * tokens.segmentCardRadiusRatio : outerHeight / 2

    implicitWidth: model.length * cellWidth + outerPadding * 2
    implicitHeight: outerHeight

    activeFocusOnTab: true
    opacity: disabledNow ? 0.38 : 1.0
    Behavior on opacity { NumberAnimation { duration: tokens.expandDuration } }

    // ── focus ring: shape, not colour alone ───────────────────────────────
    Rectangle {
        anchors.fill: body
        anchors.margins: -3
        radius: body.radius + 3
        color: "transparent"
        border.width: 2
        border.color: root.primaryColor
        visible: root.focusVisible
    }
    Rectangle {
        anchors.fill: body
        anchors.margins: -1
        radius: body.radius + 1
        color: "transparent"
        border.width: 1
        border.color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(1, 1, 1, 0.9) : Qt.rgba(0, 0, 0, 0.75)
        visible: root.focusVisible
    }

    // ── track ─────────────────────────────────────────────────────────────
    Rectangle {
        id: body
        anchors.centerIn: parent
        width: root.implicitWidth
        height: root.implicitHeight
        radius: root.bodyRadius

        color: root.materialForm ? root.materialTrack : "transparent"
        border.width: 1
        border.color: root.materialForm ? root.outlineColor : root.hairline
        gradient: root.materialForm ? null : trackGradient

        Gradient {
            id: trackGradient
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.10) }
            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.05) }
        }
    }

    Row {
        x: root.outerPadding
        y: root.outerPadding
        spacing: 0

        Repeater {
            model: root.model

            delegate: Item {
                id: cell
                required property var modelData
                required property int index

                width: root.cellWidth
                height: root.cellHeight

                readonly property bool isCurrent: index === root.currentIndex
                readonly property bool isActiveCell: index === root.activeCell

                Rectangle {
                    id: cellBody
                    anchors.fill: parent
                    anchors.margins: 1
                    radius: Math.max(2, root.bodyRadius - root.outerPadding - 1)

                    // Material selected segment is an accent fill; liquid is a
                    // lifted glass pill. Unselected cells are transparent.
                    color: cell.isCurrent
                        ? (root.materialForm ? root.primaryColor
                            : Qt.rgba(1, 1, 1, 0.24))
                        : "transparent"
                    border.width: cell.isCurrent && !root.materialForm ? 1 : 0
                    border.color: Qt.rgba(1, 1, 1, 0.36)

                    // Hover / press state layer on a non-current cell.
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: root.materialForm ? root.materialInk : "#ffffff"
                        opacity: cell.isActiveCell
                            ? (root.pressedNow ? 0.12
                                : root.hoveredNow ? 0.06 : 0.0)
                            : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: tokens.expandDuration }
                        }
                    }

                    scale: cell.isActiveCell && root.pressedNow ? 0.96 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: tokens.expandDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: String(cell.modelData)
                    color: cell.isCurrent
                        ? (root.materialForm ? root.selectedInk : root.ink)
                        : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.62)
                    font.pixelSize: tokens.bodyFontSize
                    font.weight: cell.isCurrent ? Font.DemiBold : Font.Normal
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root._hovered = true
                    onExited: root._hovered = false
                    onPressed: root._pressed = true
                    onReleased: root._pressed = false
                    onCanceled: root._pressed = false
                    onClicked: {
                        root.forceActiveFocus()
                        root.currentIndex = cell.index
                        root.selected(cell.index)
                    }
                }
            }
        }
    }
}
