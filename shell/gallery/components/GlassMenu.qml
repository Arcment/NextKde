import QtQuick
import qs.desktop.modules.common

// G2b — gallery-local menu baseline. Same host and motion as GlassPopover
// (GlassPopup), different card metrics: padding 8, item height 28, item
// radius 8, item spacing 4, Body 13, 1px separator.
// Keyboard contract: Up/Down move the focus ring, Enter activates, Esc
// closes. The ring is a 1px stroke *plus* a brighter fill so focus is not
// signalled by colour alone; the disabled row also carries a text cue.
GlassPopup {
    id: root

    signal itemTriggered(int index, string label)

    // 5 items (one disabled) plus one separator.
    property var items: [
        { label: "New window" },
        { label: "Pin to top" },
        { label: "Move to workspace" },
        { separator: true },
        { label: "Close window" },
        { label: "Delete workspace", enabled: false }
    ]
    property int activeIndex: 0

    cardWidth: 224
    contentPadding: 8
    contentSpacing: 4

    function firstEnabled() {
        for (let i = 0; i < items.length; i++)
            if (!items[i].separator && items[i].enabled !== false)
                return i
        return -1
    }
    function resetFocus() { activeIndex = firstEnabled() }
    function move(step) {
        if (items.length === 0)
            return
        let i = activeIndex
        for (let n = 0; n < items.length; n++) {
            i = (i + step + items.length) % items.length
            if (!items[i].separator && items[i].enabled !== false) {
                activeIndex = i
                return
            }
        }
    }
    function activate(index) {
        const i = index === undefined ? activeIndex : index
        if (i < 0 || i >= items.length)
            return
        const item = items[i]
        if (item.separator || item.enabled === false)
            return
        root.itemTriggered(i, item.label)
        root.close()
    }

    Repeater {
        model: root.items

        delegate: Item {
            id: row
            required property var modelData
            required property int index

            // Explicit `=== true`: an absent key is undefined, and a bare
            // `visible: modelData.separator` would not reliably fall back to
            // false (every row drew a 1px line in the G2b first screenshot).
            readonly property bool isSeparator: modelData.separator === true
            readonly property bool isEnabled: isSeparator || modelData.enabled !== false

            width: parent.width
            height: isSeparator ? 1 : 28

            // Separator line.
            Rectangle {
                visible: row.isSeparator
                width: parent.width
                height: 1
                color: AppearanceTokens.content.glassInk(0.14)
            }

            // Item surface: hover raises the fill, focus adds the 1px ring.
            Rectangle {
                id: surface
                anchors.fill: parent
                visible: !row.isSeparator
                radius: 8
                color: {
                    if (!row.isEnabled)
                        return "transparent"
                    if (row.index === root.activeIndex)
                        return Qt.rgba(1, 1, 1, 0.12)
                    return mouse.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent"
                }
                border.width: row.index === root.activeIndex ? 1 : 0
                border.color: AppearanceTokens.content.glassInk(0.55)
            }

            Text {
                id: label
                visible: !row.isSeparator
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData.label || ""
                color: row.isEnabled
                    ? AppearanceTokens.content.glassInk()
                    : AppearanceTokens.content.glassInk(0.35)
                font.pixelSize: 13
                font.weight: Font.Medium
            }

            // Non-colour cue for the disabled state.
            Text {
                visible: !row.isSeparator && !row.isEnabled
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                text: "N/A"
                color: AppearanceTokens.content.glassInk(0.45)
                font.pixelSize: 10
                font.weight: Font.Medium
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.activate(row.index)
                onEntered: {
                    if (row.isEnabled && !row.isSeparator)
                        root.activeIndex = row.index
                }
            }
        }
    }
}
