import QtQuick
import Quickshell
import qs.desktop.modules.common
import "components"

// G2 — popup page. G2a ships the skeleton and GlassPopover, G2b adds
// GlassMenu; the remaining anchors are placeholders for G2c–G2e.
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    // Screenshot hook: run.sh only exports GALLERY_THEME, so shot.sh exports
    // GALLERY_POPUP in front of the call and it is inherited here.
    readonly property string demo: Quickshell.env("GALLERY_POPUP") || ""
    readonly property var demoNames: ["Popover", "Menu", "Tooltip", "Toast", "Notification"]

    function showPopover() {
        popover.open(anchorRepeater.itemAt(0))
    }
    function showMenu() {
        menu.resetFocus()
        menu.open(anchorRepeater.itemAt(1))
    }
    function closeActive() {
        popover.close()
        menu.close()
    }
    function openDemo(index) {
        page.closeActive()
        if (index === 0)
            page.showPopover()
        else if (index === 1)
            page.showMenu()
    }

    // The gallery window has laid out by then; opening on completion alone can
    // anchor to a zero-size item and place the popup at the output origin.
    Timer {
        interval: 300
        running: page.demo === "popover" || page.demo === "menu"
        repeat: false
        onTriggered: page.openDemo(page.demo === "menu" ? 1 : 0)
    }

    Shortcut {
        sequence: "Esc"
        onActivated: page.closeActive()
    }
    // Menu keyboard contract. The gallery window owns keyboard focus after
    // the anchor click, so the shortcuts live here rather than in the popup.
    Shortcut {
        sequence: "Up"
        enabled: menu.shown
        onActivated: menu.move(-1)
    }
    Shortcut {
        sequence: "Down"
        enabled: menu.shown
        onActivated: menu.move(1)
    }
    Shortcut {
        sequence: "Return"
        enabled: menu.shown
        onActivated: menu.activate()
    }

    Text {
        x: 0
        y: 0
        text: "弹层"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width
        text: "Popover · Menu · Tooltip · Toast · Notification — 基准组件只服务 gallery"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    // ── anchor row ──────────────────────────────────────────────────────
    Row {
        id: anchorRow
        x: 0
        y: 64
        spacing: 8

        Repeater {
            id: anchorRepeater
            model: page.demoNames

            delegate: Rectangle {
                required property var modelData
                required property int index

                width: label.implicitWidth + 28
                height: 34
                radius: 10
                color: mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                border.width: 1
                border.color: page.inkDim

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: modelData
                    color: page.ink
                    font.pixelSize: 13
                    font.weight: Font.Medium
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: page.openDemo(index)
                }
            }
        }
    }

    // ── token summary ───────────────────────────────────────────────────
    Column {
        x: 0
        y: 300
        width: page.width
        spacing: 6

        Text {
            text: "GlassPopover（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "radius 16 · padding 12 · material regular · cornerExponent 2.0 · stroke 1"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "阴影 0.30 / offset 12,16 / softness 18 · 锚点间距 8（外推，SPEC 未定）"
            color: page.inkDim
            font.pixelSize: 12
        }

        Item { width: 1; height: 10 }

        Text {
            text: "GlassMenu（gallery 基准）"
            color: page.ink
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Text {
            text: "padding 8 · 项高 28 · item radius 8 · 项间距 4 · Body 13 · 分隔线 1px"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "Esc 关闭 · Up/Down 移动焦点 · Enter 触发 · focus 环 = 1px 描边 + 提亮"
            color: page.inkDim
            font.pixelSize: 12
        }
        Text {
            text: "同一宿主 AnimatedPopupWindow · open 150 / close 140 · startScale 0.96"
            color: page.inkDim
            font.pixelSize: 12
        }

        Text {
            visible: page.demo.length > 0
            text: "自动演示：GALLERY_POPUP=" + page.demo
            color: page.inkDim
            font.pixelSize: 11
        }
    }

    GlassPopover {
        id: popover
    }

    GlassMenu {
        id: menu
    }
}
