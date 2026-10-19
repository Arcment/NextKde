import QtQuick
import qs.desktop.modules.common
import qs.desktop.modules.bar

// G1b — the surface page: four real components, each one labelled with the
// token values it was built from. Two of them paint themselves in QML, two ask
// KWin for the finish, so the page doubles as the A-layer / B-layer comparison.
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property real colW: (width - 16) / 2
    readonly property real rowH: (height - 76) / 2

    Text {
        x: 0
        y: 0
        text: "表面"
        color: page.ink
        font.pixelSize: 22
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 32
        width: parent.width
        text: "LiquidGlassPanel（B 层宿主）· LiquidGlassSurface（A 层）· "
            + "ControlCenterGlass 配方 · KosFloatPanel（独立 layer-shell 窗口）"
        color: page.inkDim
        font.pixelSize: 12
        elide: Text.ElideRight
    }

    // ── 1. LiquidGlassPanel, KWin glass vs QML fallback ─────────────────
    SurfaceBlock {
        x: 0
        y: 76
        width: page.colW
        height: page.rowH
        title: "LiquidGlassPanel"
        badge: "B 层宿主"
        ink: page.ink
        inkDim: page.inkDim
        caption: "radius 32 · cornerExponent 2.0 · 阴影 —（由合成器描边）· "
            + "material regular"

        LiquidGlassPanel {
            anchors.fill: parent
            radius: 32
            cornerExponent: 2.0
            useKwinEffect: kwinSwitch.checked
            material: "regular"

            Column {
                anchors.centerIn: parent
                spacing: 4
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LiquidGlassPanel"
                    color: page.ink
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: kwinSwitch.checked
                        ? "KWin Glass 合成层"
                        : "QML 回退（LiquidGlassSurface）"
                    color: page.inkDim
                    font.pixelSize: 11
                }
            }
        }

        // useKwinEffect switch, sitting on the panel's top-right corner.
        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 12
            spacing: 8

            Text {
                id: kwinLabel
                anchors.verticalCenter: parent.verticalCenter
                text: "useKwinEffect"
                color: page.ink
                font.pixelSize: 11
            }
            Rectangle {
                id: kwinSwitch
                property bool checked: true
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 20
                radius: 10
                color: checked ? Qt.rgba(1, 1, 1, 0.38)
                    : Qt.rgba(0, 0, 0, 0.28)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.30)

                Rectangle {
                    x: kwinSwitch.checked ? 18 : 2
                    y: 2
                    width: 16
                    height: 16
                    radius: 8
                    color: "#ffffff"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: kwinSwitch.checked = !kwinSwitch.checked
                }
            }
        }
    }

    // ── 2. LiquidGlassSurface, the A-layer fallback on its own ──────────
    SurfaceBlock {
        x: page.colW + 16
        y: 76
        width: page.colW
        height: page.rowH
        title: "LiquidGlassSurface"
        badge: "A 层"
        ink: page.ink
        inkDim: page.inkDim
        caption: "radius 24 · 圆形角（Rectangle.radius，无合成器）· "
            + "阴影 — · material regular"

        LiquidGlassSurface {
            anchors.fill: parent
            radius: 24
            baseColor: Qt.rgba(0, 0, 0, 0.1)
            material: "regular"

            Column {
                anchors.centerIn: parent
                spacing: 4
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LiquidGlassSurface"
                    color: page.ink
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "纯 QML 材质，不依赖合成器"
                    color: page.inkDim
                    font.pixelSize: 11
                }
            }
        }
    }

    // ── 3. ControlCenterGlass recipe ────────────────────────────────────
    SurfaceBlock {
        x: 0
        y: 76 + page.rowH + 16
        width: page.colW
        height: page.rowH
        title: "ControlCenterGlass"
        badge: "配方"
        ink: page.ink
        inkDim: page.inkDim
        caption: "radius 32（宿主给定）· cornerExponent 2.0 · 阴影 — · "
            + "material regular / KWin blur L1（实值取 AppearanceTokens）"

        ControlCenterGlass {
            anchors.fill: parent
            radius: 32

            Column {
                anchors.centerIn: parent
                spacing: 4
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ControlCenterGlass"
                    color: page.ink
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "控制中心 / 通知共用的玻璃配方"
                    color: page.inkDim
                    font.pixelSize: 11
                }
            }
        }
    }

    // ── 4. KosFloatPanel, a separate layer-shell window ─────────────────
    SurfaceBlock {
        x: page.colW + 16
        y: 76 + page.rowH + 16
        width: page.colW
        height: page.rowH
        title: "KosFloatPanel"
        badge: "layer-shell"
        ink: page.ink
        inkDim: page.inkDim
        caption: "radius 32 · cornerExponent 3.0 · 阴影 0.30 / 12,16 / 18 · "
            + "material regular · 独立 PanelWindow（Overlay）"

        Item {
            anchors.fill: parent

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.18
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "独立 layer-shell 窗口，不参与本页布局"
                color: page.inkDim
                font.pixelSize: 11
            }

            Rectangle {
                id: floatButton
                anchors.centerIn: parent
                width: 208
                height: 44
                radius: 22
                color: floatMouse.pressed
                    ? Qt.rgba(1, 1, 1, 0.26) : Qt.rgba(1, 1, 1, 0.16)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.34)

                Text {
                    anchors.centerIn: parent
                    text: floatLoader.active && floatLoader.item
                        && floatLoader.item.visible
                        ? "关闭 layer-shell 浮层" : "打开 layer-shell 浮层"
                    color: page.ink
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    id: floatMouse
                    anchors.fill: parent
                    onClicked: page.toggleFloat()
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                text: "Esc 关闭 · 卡片自适应内容尺寸"
                color: page.inkDim
                font.pixelSize: 10
            }
        }
    }

    Loader {
        id: floatLoader
        active: false
        sourceComponent: floatComponent
    }

    Shortcut {
        sequence: "Esc"
        context: Qt.ApplicationShortcut
        onActivated: if (floatLoader.item)
            floatLoader.item.hide()
    }

    Component {
        id: floatComponent

        KosFloatPanel {
            contentPadding: 24

            Column {
                width: 340
                spacing: 10

                Text {
                    width: parent.width
                    text: "KosFloatPanel"
                    color: page.ink
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                }
                Text {
                    width: parent.width
                    text: "独立的 layer-shell 表面：同一窗口内既有背景 underlay，"
                        + "也有卡片玻璃。关闭方式：Esc 或再次点击按钮。"
                    color: page.inkDim
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: parent.width
                    text: "radius 32 · shadow 0.30 / 12,16 / 18"
                    color: page.inkDim
                    font.pixelSize: 10
                }
            }
        }
    }

    function toggleFloat() {
        if (!floatLoader.item) {
            floatLoader.active = true
            floatLoader.item.show()
            return
        }
        floatLoader.item.toggle()
    }
}
