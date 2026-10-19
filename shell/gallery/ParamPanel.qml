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
    // DEMO §4: tintStrength is continuous 0–0.40 with tier ticks at
    // 0.10 / 0.16 / 0.24. 0.16 is the regular tier.
    property real tintStrength: 0.16
    // DEMO §4: blurLevel is the integer control (1–15). The previews still
    // consume the normalised 0–1 strength, so it is derived here instead of
    // being a second source of truth.
    property int blurLevel: 8
    readonly property real blurAmount:
        Math.pow(Math.max(0, blurLevel - 1) / 14, 1 / 1.5)
    property real previewRadius: 24
    property bool radiusPill: false
    readonly property real effectiveRadius: radiusPill ? 999 : previewRadius
    property bool reduceMotionOn: false
    property bool darkMode: true
    property bool collapsed: false

    signal themeRequested(string mode)

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
            label: "tintStrength"
            valueText: panel.tintStrength.toFixed(2)
            value: panel.tintStrength
            from: 0
            to: 0.40
            ticks: [0.10, 0.16, 0.24]
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) { panel.tintStrength = v }
        }

        ParamSlider {
            label: "blurLevel"
            valueText: "L" + panel.blurLevel
            value: panel.blurLevel
            from: 1
            to: 15
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) { panel.blurLevel = Math.round(v) }
        }

        // DEMO §4: three bands over the 1–15 integer scale.
        Item {
            width: parent.width
            height: 26

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 14
                spacing: 2

                Repeater {
                    model: [
                        { key: "clear", from: 1, to: 5, alpha: 0.16 },
                        { key: "regular", from: 6, to: 10, alpha: 0.28 },
                        { key: "thick", from: 11, to: 15, alpha: 0.42 }
                    ]

                    delegate: Rectangle {
                        required property var modelData

                        width: (parent.width - 4) / 3
                        height: parent.height
                        radius: 3
                        color: Qt.rgba(1, 1, 1, modelData.alpha)

                        Text {
                            anchors.centerIn: parent
                            text: modelData.key + " " + modelData.from
                                + ".." + modelData.to
                            color: panel.ink
                            font.pixelSize: 8
                            font.family: "monospace"
                        }
                    }
                }
            }

            // Marker at the current integer level.
            Rectangle {
                x: parent.width * (panel.blurLevel - 1) / 14 - 1
                y: 0
                width: 3
                height: 20
                radius: 1.5
                color: "#ffffff"
                border.width: 1
                border.color: Qt.rgba(0, 0, 0, 0.35)

                Behavior on x {
                    enabled: !panel.reduceMotionOn
                    NumberAnimation {
                        duration: AppearanceTokens.motion.fastDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                text: "band  " + (panel.blurLevel <= 5 ? "clear"
                    : panel.blurLevel <= 10 ? "regular" : "thick")
                color: panel.inkDim
                font.pixelSize: 8
                font.family: "monospace"
            }
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
                    color: !panel.radiusPill
                        && Math.round(panel.previewRadius) === modelData
                        ? Qt.rgba(1, 1, 1, 0.32) : Qt.rgba(1, 1, 1, 0.10)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.16)

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: panel.ink
                        font.pixelSize: 11
                        font.weight: !panel.radiusPill
                            && Math.round(panel.previewRadius) === modelData
                            ? Font.DemiBold : Font.Normal
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            panel.previewRadius = modelData
                            panel.radiusPill = false
                        }
                    }
                }
            }
        }

        ParamSlider {
            label: "radius"
            valueText: panel.radiusPill ? "pill" : Math.round(panel.previewRadius)
            value: panel.previewRadius
            from: 0
            to: 32
            ink: panel.ink
            inkDim: panel.inkDim
            onMoved: function(v) {
                panel.previewRadius = v
                panel.radiusPill = false
            }
        }

        // DEMO §4: pill switch overrides the free radius on every preview.
        Row {
            width: parent.width
            spacing: 8

            Text {
                text: "pill"
                color: panel.ink
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 36
                height: 20
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                color: panel.radiusPill
                    ? Qt.rgba(1, 1, 1, 0.38) : Qt.rgba(0, 0, 0, 0.28)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.24)

                Rectangle {
                    x: panel.radiusPill ? 18 : 2
                    y: 2
                    width: 16
                    height: 16
                    radius: 8
                    color: "#ffffff"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: panel.radiusPill = !panel.radiusPill
                }
            }

            Text {
                text: "eff " + (panel.radiusPill ? "pill" : Math.round(panel.previewRadius))
                color: panel.inkDim
                font.pixelSize: 10
                font.family: "monospace"
                anchors.verticalCenter: parent.verticalCenter
            }
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
            text: "实时作用于 表面 / 控件 / 动效 预览 · "
                + "reduceMotion 开启后 effective 时长 0、expansion 0、环境光跳过"
            color: panel.inkDim
            font.pixelSize: 10
            wrapMode: Text.WordWrap
        }
    }
}
