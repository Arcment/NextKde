import QtQuick
import Quickshell
import qs.desktop.modules.common

// G6c — SPEC §7 decision page. Three A/B pairs that are visually equivalent
// but product-semantically different. The page presents both options with
// interaction, readings and consequence lines; it never ranks them.
// G6c delivers the skeleton and the Toast pair; G6d adds Tooltip and
// SessionMenu.
//
// Screenshot hooks (must be set on the same command line as shot.sh):
//   GALLERY_PAGE=decisions
//   GALLERY_DECISION=toast|tooltip|session   show one segment only
Item {
    id: page

    property real previewOpacity: 1.0
    property real blurAmount: 0.63
    property real previewRadius: 24
    property real tintStrength: 0.16
    property bool radiusPill: false
    property bool reduceMotionOn: false

    readonly property real effectiveRadius: radiusPill ? 999 : previewRadius
    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property color hairline: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.14)

    readonly property string filter: Quickshell.env("GALLERY_DECISION") || ""
    readonly property bool toastVisible: filter === "" || filter === "toast"
    readonly property bool tooltipVisible: filter === "" || filter === "tooltip"
    readonly property bool sessionVisible: filter === "" || filter === "session"

    Text {
        x: 0
        y: 0
        text: "裁定 G6"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width - 220
        text: "SPEC §7 三项 A/B：视觉等价、产品语义不同 · 只呈现交互与后果，不写推荐"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }
    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 4
        text: "DECISION=" + (page.filter === "" ? "all" : page.filter)
            + " · 待人工裁定"
        color: page.inkDim
        font.pixelSize: 10
        font.family: "monospace"
    }

    Flickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 64
        anchors.bottom: parent.bottom
        contentWidth: width
        contentHeight: column.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: flick.width
            spacing: 16

            // ── ① Toast retention ───────────────────────────────────
            MotionCard {
                id: toastCard
                visible: page.toastVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 356
                title: "① Toast 存留"
                badge: "SPEC §7-①"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = 现行 1600ms（ActionFeedbackToast.qml:10）；"
                    + "B = 2600ms + 悬停暂停。两栏均呈现交互、读数与后果，不写推荐，待人工裁定。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 保留 1600ms"
                        tag: "1600ms"
                        consequence: "HIG 符合程度：1600ms 快速反馈与「立即确认」一致；"
                            + "定时消失、不可暂停，与 HIG「少用定时消失」仍有距离。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionToastLane {
                            anchors.fill: parent
                            holdToken: 1600
                            hoverPause: false
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "B · 延长 + 悬停暂停"
                        tag: "2600ms"
                        consequence: "HIG 符合程度：2600ms 更长且悬停暂停，更贴近"
                            + " HIG「少用定时消失、可暂停」；代价是反馈占用更久。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionToastLane {
                            anchors.fill: parent
                            holdToken: 2600
                            hoverPause: true
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }
                }
            }

            // ── ② Tooltip edge gap (G6d) ───────────────────────────
            Rectangle {
                visible: page.tooltipVisible && page.filter === "tooltip"
                width: column.width
                height: 120
                radius: 12
                color: AppearanceTokens.isDarkTheme
                    ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.04)
                border.width: 1
                border.color: page.hairline

                Text {
                    anchors.centerIn: parent
                    text: "② Tooltip 贴边 A/B：G6d 交付"
                    color: page.inkDim
                    font.pixelSize: 12
                }
            }

            // ── ③ SessionMenu extreme height (G6d) ─────────────────
            Rectangle {
                visible: page.sessionVisible && page.filter === "session"
                width: column.width
                height: 120
                radius: 12
                color: AppearanceTokens.isDarkTheme
                    ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.04)
                border.width: 1
                border.color: page.hairline

                Text {
                    anchors.centerIn: parent
                    text: "③ SessionMenu 极端高度 A/B：G6d 交付"
                    color: page.inkDim
                    font.pixelSize: 12
                }
            }

            Text {
                width: column.width
                text: "后果行只描述各自代价；三项均待人工裁定。"
                color: page.inkDim
                font.pixelSize: 10
            }
        }
    }
}
