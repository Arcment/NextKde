import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.desktop.modules.common
import "gallery"

// Gallery entry (G1a). Two layer-shell windows:
//   1. A controlled background board (Background layer) so the three glass
//      material tiers stay comparable regardless of the wallpaper.
//   2. The gallery itself (Top layer), full-screen, transparent.
//
// The board is on by default and can be toggled from the gallery's nav.

Item {
    id: root

    property bool showBackgroundBoard: true


    // Apply the theme requested by run.sh (GALLERY_THEME=light|dark, default dark).
    Component.onCompleted: {
        const theme = Quickshell.env("GALLERY_THEME")
        if (theme === "light" || theme === "dark")
            AppearanceConfigService.updateThemeMode(theme)
    }

    // ── controlled background board ──────────────────────────────────
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        visible: root.showBackgroundBoard
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        Rectangle {
            anchors.fill: parent

            // Saturated quadrants so blur/tint differences are obvious.
            Rectangle {
                x: 0; y: 0
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: "#e53935"
            }
            Rectangle {
                x: parent.width * 0.5; y: 0
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: "#fdd835"
            }
            Rectangle {
                x: 0; y: parent.height * 0.5
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: "#00acc1"
            }
            Rectangle {
                x: parent.width * 0.5; y: parent.height * 0.5
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: "#d81b60"
            }

            // White / black dots to read edge behaviour and transparency.
            Repeater {
                model: 40
                Rectangle {
                    required property int index
                    x: (index % 8) * (parent.width / 8) + parent.width / 16 - 18
                    y: Math.floor(index / 8) * (parent.height / 5) + parent.height / 10 - 18
                    width: 36
                    height: 36
                    radius: 18
                    color: index % 2 === 0 ? "#ffffff" : "#000000"
                    opacity: 0.85
                }
            }
        }
    }

    // ── gallery main window ──────────────────────────────────────────
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        visible: true
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "gallery"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        GalleryRoot {
            anchors.fill: parent
            backgroundBoardVisible: root.showBackgroundBoard
            onBackgroundBoardVisibleChanged: root.showBackgroundBoard = backgroundBoardVisible
            onToggleBackgroundBoard: root.showBackgroundBoard = !root.showBackgroundBoard
        }
    }
}
