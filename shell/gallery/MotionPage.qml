import QtQuick
import Quickshell
import qs.desktop.modules.common

// G5 — motion page. G5a ships the page skeleton and the Popup open/close
// comparison; G5b adds liquid press expansion and the 2600ms ambient
// transition; G5c adds tooltip 70ms and toast 1600ms; G5d adds the full
// parameter panel wiring.
//
// Screenshot hooks (must be set on the same command line as shot.sh):
//   GALLERY_PAGE=motion            selects this page
//   GALLERY_MOTION_DEMO=popup|press|ambient|tooltip|toast|params
//   GALLERY_MOTION_REDUCE=1        seeds the panel's reduceMotion switch
//
// Static screenshots cannot judge motion. What they can carry, and what this
// page therefore prints, is the token value, every effective duration, the
// live progress reading, and the easing curve sampled at t=0/.25/.5/.75/1.
Item {
    id: page

    property real previewOpacity: 1.0
    property real blurAmount: 0.63
    property int blurLevel: 8
    property real previewRadius: 24
    property real tintStrength: 0.16
    property bool radiusPill: false
    property bool reduceMotionOn: false

    readonly property real effectiveRadius: radiusPill ? 999 : previewRadius

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property color hairline: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.14)

    readonly property string filter: Quickshell.env("GALLERY_MOTION_DEMO") || ""
    readonly property bool popupVisible: filter === "" || filter === "popup"
    readonly property bool pressVisible: filter === "" || filter === "press"
    readonly property bool ambientVisible: filter === "" || filter === "ambient"
    readonly property bool tooltipVisible: filter === "" || filter === "tooltip"
    readonly property bool toastVisible: filter === "" || filter === "toast"
    readonly property bool paramsVisible: filter === "params"
    readonly property bool builtVisible: popupVisible || pressVisible
        || ambientVisible || tooltipVisible || toastVisible || paramsVisible

    Text {
        x: 0
        y: 0
        text: "动效"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width
        text: "PopupMotion 开合（OutCubic / InCubic）· 按压 expansion · 环境光 2600ms"
            + " · tooltip 70ms · toast 1600ms · 参数面板（tint / blur / radius / reduceMotion）"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }
    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 4
        text: "DEMO=" + (page.filter === "" ? "all" : page.filter)
            + " · reduceMotion=" + (page.reduceMotionOn ? "on" : "off")
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

            // G5d — the parameter panel contract as a readable card. Visible
            // alone under GALLERY_MOTION_DEMO=params so the panel screenshot
            // carries the scales next to the live panel itself.
            MotionCard {
                id: paramsCard
                visible: page.paramsVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 214
                title: "参数面板完备"
                badge: "DEMO §4"
                ink: page.ink
                inkDim: page.inkDim
                caption: "左右两处读的是同一组值：本卡片跟随右侧面板实时变化"
                    + " · tintStrength 作用到 baseColor，radius/blur 作用到面板实例"

                Column {
                    anchors.fill: parent
                    spacing: 6

                    Text {
                        text: "tintStrength   " + page.tintStrength.toFixed(2)
                            + "   range 0.00–0.40 · ticks 0.10 / 0.16 / 0.24"
                        color: page.ink
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                    Text {
                        text: "blurLevel      L" + page.blurLevel
                            + "   range 1–15 · clear 1..5 / regular 6..10 / thick 11..15"
                            + " · band " + (page.blurLevel <= 5 ? "clear"
                                : page.blurLevel <= 10 ? "regular" : "thick")
                        color: page.ink
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                    Text {
                        text: "radius         " + (page.radiusPill
                            ? "pill" : Math.round(page.previewRadius))
                            + "   presets 32/24/16 · free 0–32 · pill "
                            + (page.radiusPill ? "on" : "off")
                        color: page.ink
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                    Text {
                        text: "reduceMotion   " + (page.reduceMotionOn ? "on" : "off")
                            + "   effective 0 · expansion 0 · ambient skipped"
                        color: page.ink
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                    Text {
                        text: "apply          表面 / 控件 / 动效 三页实时读取同一组值"
                        color: page.inkDim
                        font.pixelSize: 11
                        font.family: "monospace"
                    }
                }
            }

            MotionCard {
                id: popupCard
                visible: page.popupVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 470
                title: "Popup 开合对比"
                badge: "SPEC §2.7"
                ink: page.ink
                inkDim: page.inkDim
                caption: "open 150ms OutCubic · close 140ms InCubic · startScale 0.96"
                    + " · anchorOffset 20px · 时长按剩余进度等比缩放"
                    + " · reduceMotion 下 effective 时长 = 0，expansion 关闭"

                Row {
                    anchors.fill: parent
                    spacing: 20

                    PopupLane {
                        width: (parent.width - 20) / 2
                        height: parent.height
                        direction: "open"
                        reduceMotion: page.reduceMotionOn
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline
                    }
                    PopupLane {
                        width: (parent.width - 20) / 2
                        height: parent.height
                        direction: "close"
                        reduceMotion: page.reduceMotionOn
                        ink: page.ink
                        inkDim: page.inkDim
                        hairline: page.hairline
                    }
                }
            }

            MotionCard {
                id: pressCard
                visible: page.pressVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 300
                title: "液态按压 expansion"
                badge: "SPEC §2.7"
                ink: page.ink
                inkDim: page.inkDim
                caption: "idle 0 · hovered 0.3 · pressed 1.0 · press 200ms OutBack"
                    + " / release 360ms OutQuint（G4 GlassButton 同源）"
                    + " · reduceMotion 下时长 0、expansion 关闭"

                PressDemo {
                    anchors.fill: parent
                    reduceMotion: page.reduceMotionOn
                    ink: page.ink
                    inkDim: page.inkDim
                    hairline: page.hairline
                }
            }

            MotionCard {
                id: ambientCard
                visible: page.ambientVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 330
                title: "环境光过渡"
                badge: "2600ms"
                ink: page.ink
                inkDim: page.inkDim
                caption: "起止色样 A/B，点击切换"
                    + " · LiquidGlassSurface.ambientTransitionDuration 2600ms"
                    + " · InOutSine · reduceMotion 下跳过（effective 0）"

                AmbientDemo {
                    anchors.fill: parent
                    reduceMotion: page.reduceMotionOn
                    ink: page.ink
                    inkDim: page.inkDim
                    hairline: page.hairline
                }
            }

            MotionCard {
                id: tooltipCard
                visible: page.tooltipVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 306
                title: "tooltip 显隐"
                badge: "70ms"
                ink: page.ink
                inkDim: page.inkDim
                caption: "显隐 70ms（open OutCubic / close InCubic）· 镜像 GlassTooltip"
                    + " thick / radius 10 · 锚点侧重叠 6px · reduceMotion 下 effective 0"

                TooltipDemo {
                    anchors.fill: parent
                    reduceMotion: page.reduceMotionOn
                    ink: page.ink
                    inkDim: page.inkDim
                    hairline: page.hairline
                }
            }

            MotionCard {
                id: toastCard
                visible: page.toastVisible
                width: column.width
                radius: page.effectiveRadius
                tintStrength: page.tintStrength
                surfaceOpacity: page.previewOpacity
                blurOverrideEnabled: true
                blurStrength: page.blurAmount
                height: 286
                title: "toast 存留"
                badge: "1600ms"
                ink: page.ink
                inkDim: page.inkDim
                caption: "show 150 / hide 180ms OutCubic · 存留 1600ms（SPEC §7-① 待裁定）"
                    + " · reduceMotion 下 show/hide 与存留 effective 0"

                ToastDemo {
                    anchors.fill: parent
                    reduceMotion: page.reduceMotionOn
                    ink: page.ink
                    inkDim: page.inkDim
                    hairline: page.hairline
                }
            }
        }
    }

    Text {
        visible: !page.builtVisible && page.filter !== ""
        anchors.centerIn: parent
        text: "未知演示位「" + page.filter + "」（可用 popup / press / ambient / tooltip / toast / params）"
        color: page.inkDim
        font.pixelSize: 13
    }
}
