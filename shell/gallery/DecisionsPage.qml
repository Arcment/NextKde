import QtQuick
import Quickshell
import qs.desktop.modules.common

// G6c/G6d — SPEC §7 decision page. Three A/B pairs that are visually
// equivalent but product-semantically different. The page presents both
// options with interaction, readings and consequence lines; it never ranks
// them and never writes a recommendation.
//
// G7d — the three decisions are closed: each card carries a fixed "已裁定"
// marker (①B 2600ms + hover pause, ②B +4px, ③A fixed Footnote 10) while
// both A/B lanes remain on the page as the written record. Lane backing is
// near-opaque so readings stay ≥ 4.5:1 over the saturated background board
// in both themes; ink is pinned per theme rather than derived from the glass
// tint.
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
    // G7d — fixed theme ink for the near-opaque lane backing. glassInk() at
    // 0.62 composited to ~4.6:1 over the light lane and much worse over the
    // saturated quadrants; these values measure ≈12:1 (dark) / ≈10:1 (light)
    // against the worst-case lane composite.
    readonly property color ink: AppearanceTokens.isDarkTheme
        ? "#FFFFFF" : "#14161A"
    readonly property color inkDim: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.82) : Qt.rgba(0.078, 0.086, 0.102, 0.86)
    readonly property color hairline: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.14)

    readonly property string filter: Quickshell.env("GALLERY_DECISION") || ""
    readonly property bool toastVisible: filter === "" || filter === "toast"
    readonly property bool tooltipVisible: filter === "" || filter === "tooltip"
    readonly property bool sessionVisible: filter === "" || filter === "session"

    // G7d — the page header sits on the raw saturated board, so the subtitle
    // and the DECISION readout lost contrast over the yellow quadrant. A
    // near-opaque band reuses the lane backing so every header line keeps the
    // same ≥ 4.5:1 floor as the lane text.
    Rectangle {
        x: -8
        y: -10
        width: parent.width + 16
        height: 56
        radius: 12
        color: AppearanceTokens.isDarkTheme
            ? Qt.rgba(0.045, 0.05, 0.06, 0.95) : Qt.rgba(0.965, 0.97, 0.98, 0.95)
        border.width: 1
        border.color: page.hairline
    }

    Text {
        x: 0
        y: 0
        text: "裁定 G7"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width - 220
        text: "SPEC §7 三项已裁定 · A/B 两栏保留为记录，只呈现交互与后果，不写推荐"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }
    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 4
        text: "DECISION=" + (page.filter === "" ? "all" : page.filter)
            + " · 已裁定 G7"
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
                decision: "B · 2600ms + 悬停暂停"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = 原 1600ms 定时消失（不可暂停）；"
                    + "B = 现行 2600ms + 悬停暂停。两栏保留为裁定记录，不写推荐。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 原 1600ms"
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
                        tag: "2600ms · 现行"
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
                decision: "B · +4px 正间隙"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = 原 -6px 负 margin（StatusTooltip / DockAppNameTooltip 贴边重叠）；"
                    + "B = 现行 +4px 正间隙。两栏保留为裁定记录，不写推荐。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 原 -6px 重叠"
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
                        title: "B · +4px 正间隙"
                        tag: "gap +4px · 现行"
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
                decision: "A · 固定 Footnote 10"
                ink: page.ink
                inkDim: page.inkDim
                caption: "A = 现行固定 Footnote 10，不随 itemHeight 变；"
                    + "B = itemHeight clamp 44–56。两栏并排 24 / 72，读数写高度与字号，保留为记录。"

                Row {
                    anchors.fill: parent
                    spacing: 12

                    DecisionLane {
                        width: (parent.width - 12) / 2
                        height: parent.height
                        title: "A · 固定 Footnote 10"
                        tag: "raw 24 / 72 · 现行"
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
                text: "后果行只描述各自代价；三项已于 G7 裁定（标记见各卡右上），A/B 保留为记录。"
                color: page.inkDim
                font.pixelSize: 10
            }
        }
    }
}
