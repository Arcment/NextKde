import QtQuick
import qs.desktop.modules.common

// G2e — gallery-local notification card baseline. Container is a regular
// LiquidGlassPanel at radius 24; entries and the "+2 条" group pill use
// radius 16. Type scale is fixed: title 17/22, body 13/16, secondary 11/14,
// timestamp 10/13 — no 9px anywhere. Hover raises the fill *and* the stroke
// so the state is not carried by colour alone.
LiquidGlassPanel {
    id: root

    property var entries: [
        {
            title: "林溪",
            body: "晚点出发，路上有点堵，预计 7:20 到。",
            meta: "信息",
            time: "刚刚"
        },
        {
            title: "相册",
            body: "共享相簿「周末」新增 4 张照片",
            meta: "iCloud 照片",
            time: "12 分钟前"
        },
        {
            title: "下载完成",
            body: "Xcode 16.4 — 3.2 GB 已下载",
            meta: "Safari",
            time: "1 小时前"
        }
    ]
    property string groupLabel: "+2 条"

    readonly property color ink: foregroundColor
    readonly property color inkSecondary: secondaryForegroundColor
    readonly property color inkTertiary: tertiaryForegroundColor

    width: 360
    height: column.implicitHeight + 24
    radius: 24
    material: "regular"
    cornerExponent: 2.0
    scrimEnabled: AppearanceTokens.surface.usesBackdrop
    // G10f — dense notification text: fill in near-opaque at the extremes,
    // the same preset the live toast uses.
    scrimLevel: "readable"
    // Gallery baseline: paint in QML, never claim the KWin effect.
    useKwinEffect: false
    fallbackEnabled: AppearanceTokens.surface.paintInQml
    blurAnchor: root

    Column {
        id: column
        x: 12
        y: 12
        width: root.width - 24
        spacing: 0

        // Card header — Title2 17/22.
        Item {
            width: parent.width
            height: 24

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "通知"
                color: root.ink
                font.pixelSize: 17
                font.weight: Font.DemiBold
            }
            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "现在"
                color: root.inkTertiary
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }

        Item { width: 1; height: 10 }

        Column {
            width: parent.width
            spacing: 6

            Repeater {
                model: root.entries

                delegate: Rectangle {
                    id: entry
                    required property var modelData
                    required property int index

                    readonly property bool hovered: entryMouse.containsMouse

                    width: column.width
                    height: 68
                    radius: 16
                    color: hovered
                        ? Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.11)
                        : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.05)
                    border.width: 1
                    border.color: hovered
                        ? Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.36)
                        : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.10)

                    Row {
                        x: 10
                        y: 7
                        spacing: 10

                        Rectangle {
                            width: 26
                            height: 26
                            radius: 8
                            color: Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.08)

                            BundledIcon {
                                anchors.centerIn: parent
                                name: entry.index === 0 ? "bell"
                                    : entry.index === 1 ? "image-x-generic" : "window"
                                size: 15
                                color: root.ink
                            }
                        }

                        Column {
                            width: entry.width - 10 - 26 - 10 - 10
                            spacing: 2

                            Item {
                                width: parent.width
                                height: 17

                                Text {
                                    anchors.left: parent.left
                                    anchors.right: timeText.left
                                    anchors.rightMargin: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: entry.modelData.title
                                    color: root.ink
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                }
                                Text {
                                    id: timeText
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: entry.modelData.time
                                    color: root.inkTertiary
                                    font.pixelSize: 10
                                }
                            }
                            Text {
                                width: parent.width
                                text: entry.modelData.body
                                color: root.inkSecondary
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }
                            Text {
                                width: parent.width
                                text: entry.modelData.meta
                                color: root.inkTertiary
                                font.pixelSize: 11
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                            }
                        }
                    }

                    MouseArea {
                        id: entryMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }

        Item { width: 1; height: 8 }

        // Group pill — radius 16, secondary 11/14, same hover contract.
        Rectangle {
            id: groupPill
            width: parent.width
            height: 26
            radius: 16
            color: groupMouse.containsMouse
                ? Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.11)
                : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.05)
            border.width: 1
            border.color: groupMouse.containsMouse
                ? Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.36)
                : Qt.rgba(root.ink.r, root.ink.g, root.ink.b, 0.10)

            Text {
                anchors.centerIn: parent
                text: root.groupLabel
                color: root.inkSecondary
                font.pixelSize: 11
                font.weight: Font.Medium
            }
            MouseArea {
                id: groupMouse
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}
