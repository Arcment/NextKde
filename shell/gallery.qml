import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.desktop.modules.common
import "gallery"
import "gallery/components"

// Gallery entry (G1a). Two layer-shell windows:
//   1. A controlled background board (Background layer) so the three glass
//      material tiers stay comparable regardless of the wallpaper.
//   2. The gallery itself (Top layer), full-screen, transparent.
//
// The board is on by default and can be toggled from the gallery's nav.

Item {
    id: root

    property bool showBackgroundBoard: true

    onShowBackgroundBoardChanged: GlassBackdrop.sourceItem =
        showBackgroundBoard ? sampleBoard : null

    // Apply the theme requested by run.sh (GALLERY_THEME=light|dark, default dark).
    // Glass keeps its dark presentation unless "follows appearance" is on, so a
    // light run has to flip both switches; dark is already the glass default.
    // AppearanceConfigService loads its persisted file asynchronously, which
    // lands after Component.onCompleted and would overwrite this, so apply it
    // once immediately and again after the load settles.
    function applyTheme() {
        const theme = Quickshell.env("GALLERY_THEME")
        if (theme === "light") {
            AppearanceConfigService.updateThemeMode("light")
            AppearanceConfigService.updateGlassFollowsAppearanceMode(true)
        } else if (theme === "dark") {
            AppearanceConfigService.updateThemeMode("dark")
            AppearanceConfigService.updateGlassFollowsAppearanceMode(false)
        }
    }

    Component.onCompleted: {
        applyTheme()
        themeSettle.restart()
        GlassBackdrop.sourceItem = root.showBackgroundBoard ? sampleBoard : null
    }

    Timer {
        id: themeSettle
        interval: 800
        repeat: true
        // Reapply the requested theme for the first few seconds: the service
        // loads its persisted file asynchronously and a late load would
        // otherwise flip a light run back to dark after the first pass.
        property int remaining: 10
        onTriggered: {
            root.applyTheme()
            if (--remaining <= 0)
                stop()
        }
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

        GalleryBackdropBoard {
            anchors.fill: parent
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

        // Hidden pixel-identical copy of the visible board. Glass surfaces
        // capture it with hideSource, so it feeds the QML fallback sampling
        // without painting a second board over the scene (G10).
        Item {
            id: sampleBoard
            anchors.fill: parent
            visible: root.showBackgroundBoard

            GalleryBackdropBoard {
                anchors.fill: parent
            }
        }

        GalleryRoot {
            anchors.fill: parent
            backgroundBoardVisible: root.showBackgroundBoard
            onBackgroundBoardVisibleChanged: root.showBackgroundBoard = backgroundBoardVisible
            onToggleBackgroundBoard: root.showBackgroundBoard = !root.showBackgroundBoard
        }
    }
}
