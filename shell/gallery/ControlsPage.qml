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
    // SPEC §3.10 names normal/focused/error/disabled. The two extra cards show
    // hover and the value-bearing appearance; neither is a new state.
    readonly property var fieldStates:
        ["normal", "hovered", "focused", "error", "filled", "disabled"]
    readonly property var checkboxStates:
        ["unchecked", "checked", "hovered", "pressed", "focusVisible", "disabled"]
    readonly property var tiers: ["clear", "regular", "thick"]

    readonly property bool buttonVisible: filter === "" || filter === "button"
    readonly property bool textfieldVisible:
        filter === "" || filter === "textfield"
    readonly property bool checkboxVisible:
        filter === "" || filter === "checkbox"
    readonly property var knownFilters:
        ["button", "textfield", "checkbox"]
    readonly property bool unknownFilter:
        filter !== "" && knownFilters.indexOf(filter) === -1

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
                    + " 尚未交付（G4b 已含 button / textfield / checkbox）"
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

            // ── GlassTextField ─────────────────────────────────────────
            Item {
                width: column.width
                height: page.textfieldVisible ? fieldColumn.height : 0
                visible: page.textfieldVisible

                Column {
                    id: fieldColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassTextField"
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
                                text: "G4b"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "material regular · 高 28 · Body 13/16 · placeholder"
                            + " · focus = 2px 描边 + 外环 + tint 加深 · error = 红描边 + ! 徽标"
                            + " · 状态 normal/hovered/focused/error/filled/disabled"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: fieldTierRow
                            required property string modelData

                            width: fieldColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + fieldTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: fieldStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.fieldStates

                                    delegate: ControlStateCard {
                                        id: fieldCard
                                        required property string modelData

                                        width: (fieldStateRow.width
                                            - 5 * fieldStateRow.spacing) / 6
                                        height: 104
                                        materialTier: fieldTierRow.modelData
                                        stateLabel: fieldCard.modelData

                                        GlassTextField {
                                            anchors.centerIn: parent
                                            width: Math.min(184, parent.width)
                                            forcedState: fieldCard.modelData
                                            text: fieldCard.modelData === "filled"
                                                    ? "liquid@glass"
                                                : fieldCard.modelData === "focused"
                                                    ? "glass"
                                                : fieldCard.modelData === "error"
                                                    ? "name@" : ""
                                            placeholder: "输入文字"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── GlassCheckbox ──────────────────────────────────────────
            Item {
                width: column.width
                height: page.checkboxVisible ? checkboxColumn.height : 0
                visible: page.checkboxVisible

                Column {
                    id: checkboxColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassCheckbox"
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
                                text: "G4b"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "框 20×20 · radius 5 · label Body 13/16 · 勾选为 √ 路径"
                            + " · focusVisible = 外环 + ink 发丝 · 状态 unchecked/checked"
                            + "/hovered/pressed/focusVisible/disabled"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: checkboxTierRow
                            required property string modelData

                            width: checkboxColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + checkboxTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: checkboxStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.checkboxStates

                                    delegate: ControlStateCard {
                                        id: checkboxCard
                                        required property string modelData

                                        width: (checkboxStateRow.width
                                            - 5 * checkboxStateRow.spacing) / 6
                                        height: 104
                                        materialTier: checkboxTierRow.modelData
                                        stateLabel: checkboxCard.modelData

                                        GlassCheckbox {
                                            anchors.centerIn: parent
                                            text: "同意条款"
                                            forcedState: checkboxCard.modelData
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
