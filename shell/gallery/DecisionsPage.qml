import QtQuick
import Quickshell
import qs.desktop.modules.common

// G6c/G6d — SPEC §7 decision page. Three A/B pairs that are visually
// equivalent but product-semantically different. The page presents both
// options with interaction, readings and consequence lines; it never ranks
// them and never writes a recommendation.
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

            // ── ② Tooltip edge gap ──────────────────────────────────
            MotionCard {
                id: tooltipCard
                visible: page.tooltipVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 360
                title: "② Tooltip 贴边"
                badge: "SPEC §7-②"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = -6px 负 margin（StatusTooltip.qml:40-43；"
                    + "DockAppNameTooltip.qml:67-69）；B = +4px 正间隙。两栏均呈现交互、读数与后果，不写推荐，待人工裁定。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 保留 -6px 重叠"
                        tag: "gap -6px"
                        consequence: "贴边手感：浮层压进锚点 6px，贴边更紧、视觉连续；"
                            + "锚点下缘的 6px 被覆盖。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionTooltipLane {
                            anchors.fill: parent
                            gap: -6
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "B · 改正偏移"
                        tag: "gap +4px"
                        consequence: "贴边手感：浮层不压锚点，边界清楚；"
                            + "多出一道 4px 正间隙，贴合感略松。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionTooltipLane {
                            anchors.fill: parent
                            gap: 4
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }
                }
            }

            // ── ③ SessionMenu extreme height ────────────────────────
            MotionCard {
                id: sessionCard
                visible: page.sessionVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 484
                title: "③ SessionMenu 极端高度"
                badge: "SPEC §7-③"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = 接受固定 Footnote 10，不随 itemHeight 变；"
                    + "B = 对 SessionMenu 单独设定 itemHeight 范围 44–56。两栏并排 24 / 72 两种极端，"
                    + "读数写 itemHeight 与实际字号；不写推荐，待人工裁定。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 固定 Footnote 10"
                        tag: "raw 24 / 72"
                        consequence: "可读性：24 行高下 10px 字拥挤；72 行高下同一字号显空旷，"
                            + "但字本身始终可读。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionSessionLane {
                            anchors.fill: parent
                            mode: "raw"
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "B · itemHeight clamp 44–56"
                        tag: "clamp"
                        consequence: "可读性：极端请求被 clamp 到 44–56，Footnote 10 保持可读；"
                            + "代价是菜单行高不再随请求自由伸缩。"
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline

                        DecisionSessionLane {
                            anchors.fill: parent
                            mode: "clamp"
                            ink: page.ink
                            inkDim: page.inkDim
                            hairline: page.hairline
                        }
                    }
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
