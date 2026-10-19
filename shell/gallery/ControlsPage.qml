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
    // SPEC §3.12 defines no state list; these six are the closed, keyboard,
    // expanded final state and disabled states the gallery needs to show.
    readonly property var comboStates:
        ["idle", "hovered", "pressed", "focusVisible", "open", "disabled"]
    // SPEC §3.8 defines the ratio system, not states. "selected" moves the
    // selection to the second cell; the first card keeps it on the first.
    readonly property var segmentStates:
        ["idle", "hovered", "pressed", "focusVisible", "selected", "disabled"]
    // SPEC §3.14 defines four states. The last two cards show the endpoint
    // values (0 / 1) with forcedState idle; they are value samples, not states.
    readonly property var sliderStates:
        ["idle", "hovered", "pressed", "disabled", "value 0%", "value 100%"]
    readonly property var switchStates:
        ["off", "on", "hovered", "pressed", "disabled", "focusVisible"]
    readonly property var tiers: ["clear", "regular", "thick"]

    readonly property bool buttonVisible: filter === "" || filter === "button"
    readonly property bool textfieldVisible:
        filter === "" || filter === "textfield"
    readonly property bool checkboxVisible:
        filter === "" || filter === "checkbox"
    readonly property bool comboVisible:
        filter === "" || filter === "combobox"
    readonly property bool segmentedVisible:
        filter === "" || filter === "segmented"
    readonly property bool sliderVisible: filter === "" || filter === "slider"
    readonly property bool switchVisible: filter === "" || filter === "switch"
    readonly property var knownFilters:
        ["button", "textfield", "checkbox", "combobox", "segmented",
            "slider", "switch"]
    readonly property bool unknownFilter:
        filter !== "" && knownFilters.indexOf(filter) === -1

    // ── live contract readouts (G4d) ──────────────────────────────────────
    // The slider host owns `value`; preview updates it immediately.
    property real sliderLiveValue: 0.42
    property real sliderPreviewValue: 0.42
    property real sliderCommitValue: -1
    property int sliderCancelCount: 0
    // The switch host only applies the request when it "confirms" it here.
    property bool switchChecked: false
    property bool switchPendingValue: false
    property string switchRequestedText: "—"
    property string switchConfirmedText: "关"

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

    // Simulated async owner: the switch only emits a request; this timer is
    // the host confirming it and writing `checked` back.
    Timer {
        id: switchConfirmTimer
        interval: 350
        repeat: false
        onTriggered: {
            page.switchChecked = page.switchPendingValue
            page.switchConfirmedText = page.switchPendingValue ? "开" : "关"
        }
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
                    + " 尚未交付（G4d 已含 button / textfield / checkbox"
                    + " / combobox / segmented / slider / switch）"
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

            // ── GlassComboBox ──────────────────────────────────────────
            Item {
                width: column.width
                height: page.comboVisible ? comboColumn.height : 0
                visible: page.comboVisible

                Column {
                    id: comboColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassComboBox"
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
                                text: "G4c"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "高 36 · radius pill · Body 13/16 · 描边 α 0.16 深 / 0.12 浅"
                            + " · sheet 深 #262b31 / 浅 #f6f8fb · 弹层 radius 16"
                            + " · offset 5 · padding 8 · 高 min(360, 内容+12)"
                            + " · 状态 idle/hovered/pressed/focusVisible/open/disabled"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: comboTierRow
                            required property string modelData

                            width: comboColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + comboTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: comboStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.comboStates

                                    delegate: ControlStateCard {
                                        id: comboCard
                                        required property string modelData

                                        width: (comboStateRow.width
                                            - 5 * comboStateRow.spacing) / 6
                                        // Tall enough for field + offset 5 +
                                        // the 3-row popup (118) inside the card.
                                        height: 196
                                        materialTier: comboTierRow.modelData
                                        stateLabel: comboCard.modelData

                                        GlassComboBox {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            y: 10
                                            width: Math.min(184, parent.width)
                                            forcedState: comboCard.modelData
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Full-size live sample; the matrix cells are only ~88 px
                    // wide, which is narrower than a comfortable field.
                    Item {
                        width: parent.width
                        height: 44

                        GlassComboBox {
                            id: comboLive
                            anchors.verticalCenter: parent.verticalCenter
                            width: 220
                        }
                        Text {
                            anchors.left: comboLive.right
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: "全尺寸 live · 高 36 · 点击展开；"
                                + "弹层终态见上方 open 卡（行高 30 · 偏移 5 · padding 8）"
                            color: page.inkDim
                            font.pixelSize: 11
                        }
                    }
                }
            }

            // ── SegmentedControl ───────────────────────────────────────
            Item {
                width: column.width
                height: page.segmentedVisible ? segmentColumn.height : 0
                visible: page.segmentedVisible

                Column {
                    id: segmentColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "SegmentedControl"
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
                                text: "G4c"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "cell 72×40 · outerPadding 2 · Body 13/16"
                            + " · liquid = pill（radius height/2）"
                            + " · material = card（radius height×0.38）"
                            + " · 状态 idle/hovered/pressed/focusVisible/selected/disabled"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: segmentTierRow
                            required property string modelData

                            width: segmentColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + segmentTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: segmentStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.segmentStates

                                    delegate: ControlStateCard {
                                        id: segmentCard
                                        required property string modelData

                                        width: (segmentStateRow.width
                                            - 5 * segmentStateRow.spacing) / 6
                                        height: 104
                                        materialTier: segmentTierRow.modelData
                                        stateLabel: segmentCard.modelData

                                        // Two compact cells (40×26) so the
                                        // control fits the ~88 px card; the
                                        // full-size sample sits below.
                                        GlassSegmentedControl {
                                            anchors.centerIn: parent
                                            model: ["日", "周"]
                                            cellWidth: 40
                                            cellHeight: 26
                                            currentIndex: segmentCard.modelData === "selected"
                                                ? 1 : 0
                                            forcedState: segmentCard.modelData
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: 44

                        GlassSegmentedControl {
                            id: segmentLive
                            anchors.verticalCenter: parent.verticalCenter
                            model: ["日", "周", "月"]
                            currentIndex: 1
                        }
                        Text {
                            anchors.left: segmentLive.right
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            text: "全尺寸 live · 3 × 72×40 + outerPadding 2"
                                + " · 当前 radius = " + (page.materialForm
                                    ? "height×0.38（card）" : "height/2（pill）")
                            color: page.inkDim
                            font.pixelSize: 11
                        }
                    }
                }
            }

            // ── GlassSlider ────────────────────────────────────────────
            Item {
                width: column.width
                height: page.sliderVisible ? sliderColumn.height : 0
                visible: page.sliderVisible

                Column {
                    id: sliderColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassSlider"
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
                                text: "G4d"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "高 44 · track 6 · thumb 32×16 · accent 进 token"
                            + " · 状态 idle/hovered/pressed/disabled"
                            + " · 悬停 expansion 0.3 · Ctrl+滚轮 0.01/档"
                            + " · 180ms 去抖 · 提交后 400ms 屏蔽 x 动画"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: sliderTierRow
                            required property string modelData

                            width: sliderColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + sliderTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: sliderStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.sliderStates

                                    delegate: ControlStateCard {
                                        id: sliderCard
                                        required property string modelData

                                        width: (sliderStateRow.width
                                            - 5 * sliderStateRow.spacing) / 6
                                        height: 104
                                        materialTier: sliderTierRow.modelData
                                        stateLabel: sliderCard.modelData

                                        GlassSlider {
                                            anchors.centerIn: parent
                                            width: Math.min(200, parent.width)
                                            value: sliderCard.modelData === "value 0%"
                                                    ? 0.0
                                                : sliderCard.modelData === "value 100%"
                                                    ? 1.0 : 0.42
                                            forcedState: sliderCard.modelData === "value 0%"
                                                    || sliderCard.modelData === "value 100%"
                                                ? "idle" : sliderCard.modelData
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Live contract row: readings are static text so a
                    // screenshot can see the last preview / commit / wheel.
                    Item {
                        width: parent.width
                        height: 58

                        GlassSlider {
                            id: sliderLive
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: 240
                            value: page.sliderLiveValue
                            onPreviewChanged: (v) => {
                                page.sliderLiveValue = v
                                page.sliderPreviewValue = v
                            }
                            onCommitRequested: (v) => page.sliderCommitValue = v
                            onCanceled: page.sliderCancelCount += 1
                        }

                        Text {
                            anchors.left: sliderLive.right
                            anchors.leftMargin: 16
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: "preview " + page.sliderPreviewValue.toFixed(2)
                                + " · commit " + (page.sliderCommitValue < 0
                                    ? "—" : page.sliderCommitValue.toFixed(2))
                                + " · wheel " + (sliderLive.wheelValue < 0
                                    ? "—" : sliderLive.wheelValue.toFixed(2))
                                + "（" + sliderLive.wheelSteps + " 档）"
                                + " · canceled " + page.sliderCancelCount
                                + "\n拖拽 = preview；松手 commit；Ctrl+滚轮按 0.01 步进，"
                                + "停顿 180ms 提交；提交后 400ms 内 x 动画屏蔽"
                            color: page.inkDim
                            font.pixelSize: 11
                            lineHeight: 1.4
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            // ── GlassSwitch ────────────────────────────────────────────
            Item {
                width: column.width
                height: page.switchVisible ? switchColumn.height : 0
                visible: page.switchVisible

                Column {
                    id: switchColumn
                    width: parent.width
                    spacing: 10

                    Row {
                        width: parent.width
                        height: 20
                        spacing: 8

                        Text {
                            height: parent.height
                            verticalAlignment: Text.AlignVCenter
                            text: "GlassSwitch"
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
                                text: "G4d"
                                color: page.inkDim
                                font.pixelSize: 10
                            }
                        }
                    }

                    Text {
                        width: parent.width
                        text: "74×32 · thumb 44×26 · travel = width-44-6"
                            + " · M3 handle 16 off / 24 on，m3Scale=min(1,h/32)"
                            + " · thumbX 200 OutCubic · 状态 off/on/hovered/pressed"
                            + "/disabled/focusVisible"
                        color: page.inkDim
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }

                    Repeater {
                        model: page.tiers

                        delegate: Column {
                            id: switchTierRow
                            required property string modelData

                            width: switchColumn.width
                            spacing: 6

                            Text {
                                height: 14
                                text: "material " + switchTierRow.modelData
                                color: page.ink
                                font.pixelSize: 11
                            }

                            Row {
                                id: switchStateRow
                                width: parent.width
                                spacing: 8

                                Repeater {
                                    model: page.switchStates

                                    delegate: ControlStateCard {
                                        id: switchCard
                                        required property string modelData

                                        width: (switchStateRow.width
                                            - 5 * switchStateRow.spacing) / 6
                                        height: 104
                                        materialTier: switchTierRow.modelData
                                        stateLabel: switchCard.modelData

                                        GlassSwitch {
                                            anchors.centerIn: parent
                                            forcedState: switchCard.modelData
                                            // Pointer/focus cards show the on
                                            // value; off and disabled are off.
                                            checked: switchCard.modelData === "on"
                                                || switchCard.modelData === "hovered"
                                                || switchCard.modelData === "pressed"
                                                || switchCard.modelData === "focusVisible"
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Host-confirmed contract row.
                    Item {
                        width: parent.width
                        height: 58

                        GlassSwitch {
                            id: switchLive
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            checked: page.switchChecked
                            onToggled: (v) => {
                                page.switchRequestedText = v ? "开" : "关"
                                page.switchPendingValue = v
                                switchConfirmTimer.restart()
                            }
                        }

                        Text {
                            anchors.left: switchLive.right
                            anchors.leftMargin: 16
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: "requested " + page.switchRequestedText
                                + " · confirmed " + page.switchConfirmedText
                                + "\n点击只发出 toggled 请求；宿主 350ms 后确认并写回"
                                + " checked（组件不本地翻转）。Tab 聚焦看 focus 环"
                            color: page.inkDim
                            font.pixelSize: 11
                            lineHeight: 1.4
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            Item { width: 1; height: 12 }
        }
    }
}
