import QtQuick
import qs.desktop.modules.common

// G1c — right-hand live parameter panel. Values live here and are read by
// GalleryRoot, which forwards them to every preview on both pages. Collapsible
// so the preview area can take the full width when comparing surfaces.
LiquidGlassPanel {
    id: panel

    // Deliberately not named `surfaceOpacity`: the inherited property of the
    // same name would tint this panel itself, and the panel is chrome, not a
    // preview.
    property real previewOpacity: 1.0
    property real blurAmount: 0.63
    property real previewRadius: 24
    property bool reduceMotionOn: false
    property bool darkMode: true
    property bool collapsed: false

    signal themeRequested(string mode)

    readonly property real blurLevel:
        Math.round(1 + Math.pow(blurAmount, 1.5) * 14)
    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)

    width: collapsed ? 56 : 260
    radius: 24
    cornerExponent: 2.0
    useKwinEffect: false
    material: "regular"

    // ── header ───────────────────────────────────────────────────────
    Text {
        visible: !panel.collapsed
        x: 16
        y: 16
        text: "参数"
        color: panel.ink
        font.pixelSize: 15
        font.weight: Font.DemiBold
    }

    // Collapsed rail label.
    Text {
        visible: panel.collapsed
        x: 0
        y: 60
        width: panel.width
        horizontalAlignment: Text.AlignHCenter
        text: "参\n数"
        lineHeight: 1.3
        color: panel.inkDim
        font.pixelSize: 13
    }

    Rectangle {
        x: panel.width - 40
        y: 12
        width: 28
        height: 28
        radius: 8
        color: collapseMouse.pressed
            ? Qt.rgba(1, 1, 1, 0.24) : Qt.rgba(1, 1, 1, 0.10)

        Text {
            anchors.centerIn: parent
            text: panel.collapsed ? "‹" : "›"
            color: panel.ink
            font.pixelSize: 16
        }
        MouseArea {
            id: collapseMouse
            anchors.fill: parent
            onClicked: panel.collapsed = !panel.collapsed
        }
    }

    // ── controls ─────────────────────────────────────────────────────
    Column {
        visible: !panel.collapsed
        x: 16
        y: 52
        width: panel.width - 32
        spacing: 6

        Text {
            text: "表面"
            color: panel.inkDim
            font.pixelSize: 10
            font.weight: Font.DemiBold
        }

        ParamSlider {
            label: "surfaceOpacity"
            valueText: Math.round(panel.previewOpacity * 100) + "%"
            value: panel.previewOpacity
            from: 0.2
            to: 1.0
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) { panel.previewOpacity = v }
        }

        ParamSlider {
            label: "blurStrength"
            valueText: "KWin L" + panel.blurLevel
            value: panel.blurAmount
            from: 0
            to: 1
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) { panel.blurAmount = v }
        }

        Item { width: 1; height: 6 }

        Text {
            text: "圆角"
            color: panel.inkDim
            font.pixelSize: 10
            font.weight: Font.DemiBold
        }

        Row {
            spacing: 6

            Repeater {
                model: [32, 24, 16]

                delegate: Rectangle {
                    required property int modelData

                    width: (panel.width - 32 - 12) / 3
                    height: 26
                    radius: 8
                    color: Math.round(panel.previewRadius) === modelData
                        ? Qt.rgba(1, 1, 1, 0.32) : Qt.rgba(1, 1, 1, 0.10)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.16)

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: panel.ink
                        font.pixelSize: 11
                        font.weight: Math.round(panel.previewRadius) === modelData
                            ? Font.DemiBold : Font.Normal
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: panel.previewRadius = modelData
                    }
                }
            }
        }

        ParamSlider {
            label: "radius"
            valueText: Math.round(panel.previewRadius)
            value: panel.previewRadius
            from: 0
            to: 32
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) { panel.previewRadius = v }
        }

        Item { width: 1; height: 6 }

        Text {
            text: "主题"
            color: panel.inkDim
            font.pixelSize: 10
            font.weight: Font.DemiBold
        }

        Row {
            spacing: 6

            Repeater {
                model: [{ label: "浅色", mode: "light" },
                        { label: "深色", mode: "dark" }]

                delegate: Rectangle {
                    required property var modelData

                    width: (panel.width - 32 - 6) / 2
                    height: 28
                    radius: 8
                    color: (modelData.mode === "dark") === panel.darkMode
                        ? Qt.rgba(1, 1, 1, 0.30) : Qt.rgba(1, 1, 1, 0.08)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.16)

                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: panel.ink
                        font.pixelSize: 11
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: panel.themeRequested(modelData.mode)
                    }
                }
            }
        }

        Item { width: 1; height: 6 }

        Text {
            text: "动效"
            color: panel.inkDim
            font.pixelSize: 10
            font.weight: Font.DemiBold
        }

        Row {
            width: parent.width
            spacing: 8

            Text {
                text: "reduceMotion"
                color: panel.ink
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 36
                height: 20
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                color: panel.reduceMotionOn
                    ? Qt.rgba(1, 1, 1, 0.38) : Qt.rgba(0, 0, 0, 0.28)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.24)

                Rectangle {
                    x: panel.reduceMotionOn ? 18 : 2
                    y: 2
                    width: 16
                    height: 16
                    radius: 8
                    color: "#ffffff"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: panel.reduceMotionOn = !panel.reduceMotionOn
                }
            }
        }

        Text {
            width: parent.width
            text: "G1 只存值，G5 才联动动效"
            color: panel.inkDim
            font.pixelSize: 10
            wrapMode: Text.WordWrap
        }
    }
}
