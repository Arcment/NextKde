import QtQuick
import qs.desktop.modules.common

// G2d — gallery-local toast baseline. Mirrors ActionFeedbackToast's content
// so the pair can be compared side by side, but the surface follows the G2
// tokens: material regular, scrimLevel readable, 36px tall, pill radius
// (= height / 2), Callout 12 Medium, show 150 / hide 180ms and 0.96 → 1
// scale. `timeout: 0` keeps it on screen for the screenshot demo.
LiquidGlassPanel {
    id: root

    property string message: ""
    property string iconName: "check"
    property int timeout: 1600
    property bool shown: false

    function show(text, icon) {
        message = text
        iconName = icon || "check"
        shown = true
        if (timeout > 0)
            hold.restart()
        else
            hold.stop()
    }
    function dismiss() {
        hold.stop()
        shown = false
    }

    implicitWidth: content.implicitWidth + 28
    implicitHeight: 36
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    material: "regular"
    scrimEnabled: AppearanceTokens.surface.usesBackdrop
    scrimLevel: "readable"
    // Gallery baseline: paint in QML, never claim the KWin effect.
    useKwinEffect: false
    fallbackEnabled: AppearanceTokens.surface.paintInQml
    blurAnchor: root
    enabled: false
    visible: opacity > 0
    opacity: shown ? 1 : 0
    scale: shown ? 1 : 0.96
    Accessible.name: message
    Behavior on opacity {
        NumberAnimation {
            duration: root.shown ? 150 : 180
            easing.type: Easing.OutCubic
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: root.shown ? 150 : 180
            easing.type: Easing.OutCubic
        }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 7
        BundledIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: root.iconName
            size: 15
            color: root.foregroundColor
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.message
            color: root.foregroundColor
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }

    Timer {
        id: hold
        interval: root.timeout
        onTriggered: root.shown = false
    }
}
