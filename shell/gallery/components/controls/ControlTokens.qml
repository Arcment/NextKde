import QtQuick
import qs.desktop.modules.common

// Gallery-local control tokens (G4).
//
// These are the values SPEC §2.7 / §3.8–§3.15 freeze for the controls. The
// production token file is not edited from the gallery round, so the numbers
// live here once and every gallery control reads them instead of hard-coding
// them at the call site. Durations borrow the shell motion scale: press is the
// normal step, release the slow step.
QtObject {
    id: tokens

    // SPEC §2.7 — liquid press expansion.
    readonly property real expansionIdle: 0
    readonly property real expansionHovered: 0.3
    readonly property real expansionPressed: 1.0

    readonly property int expandDuration: AppearanceTokens.motion.normalDuration
    readonly property int releaseDuration: AppearanceTokens.motion.slowDuration

    // SPEC §3.9 — GlassButton.
    readonly property int buttonHeight: 28
    readonly property real buttonRadiusPill: 999
    readonly property real buttonRadiusSmall: 10
    readonly property real buttonPadding: 12
    readonly property int bodyFontSize: 13

    // SPEC §3.10 — GlassTextField.
    readonly property int fieldHeight: 28
    readonly property int bodyLineHeight: 16

    // SPEC §3.11 — GlassCheckbox.
    readonly property int checkBoxSize: 20
    readonly property real checkBoxRadius: 5

    // SPEC §3.12 — GlassComboBox.
    readonly property int comboHeight: 36
    readonly property real comboRadiusPill: 999
    readonly property real comboRadiusCard: 16
    readonly property int comboPopupOffset: 5
    readonly property int comboPopupPadding: 8
    readonly property int comboPopupMaxHeight: 360

    // SPEC §3.8 — SegmentedControl.
    readonly property int segmentCellWidth: 72
    readonly property int segmentCellHeight: 40
    readonly property int segmentOuterPadding: 2

    // SPEC §3.14 — GlassSlider.
    readonly property int sliderHeight: 44
    readonly property int sliderTrackHeight: 6
    readonly property int sliderThumbWidth: 32
    readonly property int sliderThumbHeight: 16
    readonly property int sliderCommitDebounce: 180
    readonly property int sliderSuppressX: 400

    // SPEC §3.15 — GlassSwitch.
    readonly property int switchWidth: 74
    readonly property int switchHeight: 32
    readonly property int switchThumbWidth: 44
    readonly property int switchThumbHeight: 26
    readonly property int switchTravelInset: 6

    // SPEC §3.13 — GlassScrollBar.
    readonly property int scrollBarWidth: 6
    readonly property int scrollBarHoverWidth: 8

    // SPEC §2.4 — type scale. Ten steps, nothing invented.
    readonly property var typeScale: [
        { name: "LargeTitle", size: 26, line: 32, sample: "液态玻璃", source: "HIG Large Title" },
        { name: "Title1", size: 22, line: 26, sample: "控件基准", source: "HIG Title 1" },
        { name: "Title2", size: 17, line: 22, sample: "材质与状态", source: "NotificationHistoryCard:187" },
        { name: "Title3", size: 15, line: 20, sample: "三档材质", source: "HIG Title 3" },
        { name: "Headline", size: 13, line: 16, sample: "Headline Bold", source: "HIG Headline", bold: true },
        { name: "Body", size: 13, line: 16, sample: "正文 13/16", source: "控件正文" },
        { name: "Callout", size: 12, line: 15, sample: "Callout 12/15", source: "StatusTooltip:63" },
        { name: "Subheadline", size: 11, line: 14, sample: "Subheadline 11/14", source: "MaterialTrio 说明" },
        { name: "Footnote", size: 10, line: 13, sample: "Footnote 10/13", source: "时间戳:199" },
        { name: "Caption", size: 10, line: 13, sample: "Caption 10/13", source: "最小字号" }
    ]
}
