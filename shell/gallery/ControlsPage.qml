import QtQuick
import Quickshell
import qs.desktop.modules.common
import "../shared/qml/controls" as SharedControls
import "components/controls"

// G4 — controls page. One section per control, each a 3 material × 6 state
// matrix. Liquid/material form is global (ControlForm.materialForm), switched
// from the toolbar here and seeded by GALLERY_CONTROL_FORM for screenshots.
//
// Screenshot hooks (must be set on the same command line as shot.sh):
//   GALLERY_CONTROLS_FILTER      show one section only, from the top
//   GALLERY_CONTROLS_OFFSET      initial contentY
//   GALLERY_CONTROL_FORM         liquid | material
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property color hairline: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.14)

    readonly property bool materialForm: SharedControls.ControlForm.materialForm
    readonly property string filter: Quickshell.env("GALLERY_CONTROLS_FILTER") || ""
    readonly property var buttonStates:
        ["idle", "hovered", "pressed", "focus", "icon", "disabled"]
    readonly property var tiers: ["clear", "regular", "thick"]

    readonly property bool buttonVisible: filter === "" || filter === "button"
    readonly property bool unknownFilter:
        filter !== "" && filter !== "button"

    function setForm(mode) {
        SharedControls.ControlForm.materialForm = (mode === "material")
    }

    function applyOffset() {
        const raw = Quickshell.env("GALLERY_CONTROLS_OFFSET") || ""
        const value = parseInt(raw)
        if (!isNaN(value))
            flick.contentY = Math.max(0, value)
    }

    Component.onCompleted: {
        const form = Quickshell.env("GALLERY_CONTROL_FORM")
        if (form === "material")
            page.setForm("material")
        else if (form === "liquid")
            page.setForm("liquid")
        offsetTimer.start()
    }

    Timer {
        id: offsetTimer
        interval: 200
        repeat: false
        onTriggered: page.applyOffset()
    }

    Flickable {
        id: flick
        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        contentWidth: width
        contentHeight: Math.max(height, column.height + 24)

        Column {
            id: column
            width: flick.width
            spacing: 14

            // ── toolbar ────────────────────────────────────────────────
            Item {
                width: parent.width
                height: 52

                Text {
                    x: 0
                    y: 0
                    text: "控件"
                    color: page.ink
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                }
                Text {
                    x: 0
                    y: 30
                    width: parent.width - formToggle.width - 24
                    text: "每控件一整行矩阵：3 材质行 × 6 状态卡；"
                        + "主题用右侧参数面板切换，形态切换作用于全部控件"
                    color: page.inkDim
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }

                Row {
                    id: formToggle
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 28
                    spacing: 4

                    Rectangle {
                        width: 84
                        height: 28
                        radius: 14
                        color: page.materialForm
                            ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(1, 1, 1, 0.26)
                        border.width: 1
                        border.color: page.materialForm
                            ? page.hairline : page.ink

                        Text {
                            anchors.centerIn: parent
                            text: "Liquid"
                            color: page.materialForm ? page.inkDim : page.ink
                            font.pixelSize: 12
                            font.weight: page.materialForm ? Font.Normal : Font.DemiBold
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.setForm("liquid")
                        }
                    }

                    Rectangle {
                        width: 94
                        height: 28
                        radius: 14
                        color: page.materialForm
                            ? Qt.rgba(1, 1, 1, 0.26) : Qt.rgba(1, 1, 1, 0.08)
                        border.width: 1
                        border.color: page.materialForm
                            ? page.ink : page.hairline

                        Text {
                            anchors.centerIn: parent
                            text: "Material"
                            color: page.materialForm ? page.ink : page.inkDim
                            font.pixelSize: 12
                            font.weight: page.materialForm ? Font.DemiBold : Font.Normal
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: page.setForm("material")
                        }
                    }
                }
            }

            // ── unsupported filter ─────────────────────────────────────
            Text {
                visible: page.unknownFilter
                width: parent.width
                text: "GALLERY_CONTROLS_FILTER=" + page.filter
                    + " 尚未交付（G4a 只含 button）"
                color: page.inkDim
                font.pixelSize: 13
            }

            // ── GlassButton ────────────────────────────────────────────
            Item {
                width: column.width
                height: page.buttonVisible ? buttonColumn.height : 0
                visible: page.buttonVisible

                Column {
                    id: buttonColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassButton"
                            color: page.ink
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                        }
                        Rectangle {
                            width: 34
                            height: 20
                            radius: 10
                            color: Qt.rgba(1, 1, 1, 0.14)
                            Text {
                                anchors.centerIn: parent
                                text: "G4a"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "material regular · 高 28 · radius pill / small 10 · Body 13/16"
                            + " · expansion hovered 0.3 / pressed 1.0 · 状态 idle/hovered/pressed/disabled"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: tierRow
                            required property string modelData

                            width: buttonColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + tierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: stateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.buttonStates

                                    delegate: ControlStateCard {
                                        id: stateCard
                                        required property string modelData

                                        width: (stateRow.width - 5 * stateRow.spacing) / 6
                                        height: 104
                                        materialTier: tierRow.modelData
                                        stateLabel: stateCard.modelData

                                        GlassButton {
                                            anchors.centerIn: parent
                                            forcedState: stateCard.modelData === "icon"
                                                ? "idle" : stateCard.modelData
                                            iconOnly: stateCard.modelData === "icon"
                                            glyph: stateCard.modelData === "icon" ? "+" : ""
                                            text: stateCard.modelData === "focus"
                                                ? "保存" : "确定"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item { width: 1; height: 12 }
        }
    }
}
