import QtQuick
import Quickshell
import qs.desktop.modules.common

// G5 — motion page. G5a ships the page skeleton and the Popup open/close
// comparison; G5b adds liquid press expansion and the 2600ms ambient
// transition; G5c/G5d add tooltip, toast and the full parameter panel
// wiring.
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
    property real previewRadius: 24
    property bool reduceMotionOn: false

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property color hairline: AppearanceTokens.isDarkTheme
        ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.14)

    readonly property string filter: Quickshell.env("GALLERY_MOTION_DEMO") || ""
    readonly property bool popupVisible: filter === "" || filter === "popup"
    readonly property bool pressVisible: filter === "" || filter === "press"
    readonly property bool ambientVisible: filter === "" || filter === "ambient"
    readonly property bool builtVisible: popupVisible || pressVisible
        || ambientVisible

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
            + " · tooltip 70ms · toast 1600ms"
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

            MotionCard {
                id: popupCard
                visible: page.popupVisible
                width: column.width
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
        }
    }

    Text {
        visible: !page.builtVisible && page.filter !== ""
        anchors.centerIn: parent
        text: "演示位「" + page.filter + "」将在 G5c–G5d 补齐"
        color: page.inkDim
        font.pixelSize: 13
    }
}
