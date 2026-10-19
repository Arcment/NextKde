import QtQuick
import Quickshell
import qs.desktop.modules.common
import "components"

// Gallery root (G1a): fixed left nav + right content Loader.

Item {
    id: root

    signal toggleBackgroundBoard()

    property bool backgroundBoardVisible: true
    // Overview is the landing page from G1c. GALLERY_PAGE=surfaces lets the
    // screenshot flow capture the surface page without synthesising a click.
    property int currentIndex:
        Quickshell.env("GALLERY_PAGE") === "surfaces" ? 1
            : Quickshell.env("GALLERY_PAGE") === "popups" ? 2
            : Quickshell.env("GALLERY_PAGE") === "controls" ? 3
            : Quickshell.env("GALLERY_PAGE") === "motion" ? 4
            : Quickshell.env("GALLERY_PAGE") === "scene" ? 5 : 0
    property string themeMode:
        Quickshell.env("GALLERY_THEME") === "light" ? "light" : "dark"
    // G3b scrim source demo. The default is the legal production pairing:
    // compositor owns the scrim, QML paints no backdrop.
    property string scrimMode:
        Quickshell.env("GALLERY_SCRIM") === "qml" ? "qml"
            : Quickshell.env("GALLERY_SCRIM") === "both" ? "both"
            : "compositor"

    // Live parameters owned by ParamPanel (declared below); every preview
    // page reads these through its own properties.
    readonly property real previewOpacity: paramPanel.previewOpacity
    readonly property real blurAmount: paramPanel.blurAmount
    readonly property int blurLevel: paramPanel.blurLevel
    readonly property real previewRadius: paramPanel.previewRadius
    readonly property real effectiveRadius: paramPanel.effectiveRadius
    readonly property bool radiusPill: paramPanel.radiusPill
    readonly property real tintStrength: paramPanel.tintStrength
    readonly property bool reduceMotionOn: paramPanel.reduceMotionOn

    function applyTheme(mode) {
        root.themeMode = mode
        if (mode === "light") {
            AppearanceConfigService.updateThemeMode("light")
            AppearanceConfigService.updateGlassFollowsAppearanceMode(true)
        } else {
            AppearanceConfigService.updateThemeMode("dark")
            AppearanceConfigService.updateGlassFollowsAppearanceMode(false)
        }
    }

    readonly property var pages: [
        { title: "总览", note: "G1c" },
        { title: "表面", note: "G1b" },
        { title: "弹层", note: "G2/G3" },
        { title: "控件", note: "G4" },
        { title: "动效", note: "G5" },
        { title: "场景", note: "S1" }
    ]

    readonly property string ink: AppearanceTokens.content.glassInk()
    readonly property string inkDim: AppearanceTokens.content.glassInk(0.55)

    // ── left nav ─────────────────────────────────────────────────────
    LiquidGlassPanel {
        id: nav

        x: 24
        y: 24
        width: 220
        height: parent.height - 48
        // SPEC 2.2: glass surfaces are circular (exponent 2.0); the 3.0 shape
        // token belongs to the non-glass shape system.
        radius: 24
        cornerExponent: 2.0
        useKwinEffect: false

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 4

            Text {
                text: "Liquid Glass Gallery"
                color: root.ink
                font.pixelSize: 15
                font.weight: Font.DemiBold
            }
            Text {
                text: "G1 骨架"
                color: root.inkDim
                font.pixelSize: 12
            }

            Item { width: 1; height: 12 }

            Repeater {
                model: root.pages

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width: parent.width
                    height: 40
                    radius: 10
                    color: root.currentIndex === index
                        ? Qt.rgba(1, 1, 1, 0.18)
                        : "transparent"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 8

                        Text {
                            text: modelData.title
                            color: root.currentIndex === index ? root.ink : root.inkDim
                            font.pixelSize: 14
                            font.weight: root.currentIndex === index ? Font.DemiBold : Font.Normal
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: modelData.note
                            color: root.inkDim
                            font.pixelSize: 11
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.currentIndex = index
                    }
                }
            }

            Item { width: 1; height: 12 }

            // Background board toggle (on by default).
            Row {
                spacing: 8
                Text {
                    text: "背景板"
                    color: root.inkDim
                    font.pixelSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    width: 36
                    height: 20
                    radius: 10
                    color: root.backgroundBoardVisible
                        ? Qt.rgba(1, 1, 1, 0.35)
                        : Qt.rgba(1, 1, 1, 0.12)
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        x: root.backgroundBoardVisible ? 18 : 2
                        y: 2
                        width: 16
                        height: 16
                        radius: 8
                        color: "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.toggleBackgroundBoard()
                    }
                }
            }
        }
    }

    // ── right content ────────────────────────────────────────────────
    Rectangle {
        id: contentRect
        x: 268
        y: 24
        width: paramPanel.x - x - 16
        height: parent.height - 48
        radius: AppearanceTokens.shape.large
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: 1

        Loader {
            id: pageLoader
            anchors.fill: parent
            anchors.margins: 24
            sourceComponent: root.currentIndex === 0 ? overviewPage
                : root.currentIndex === 1 ? surfacesPage
                : root.currentIndex === 2 ? popupsPage
                : root.currentIndex === 3 ? controlsPage
                : root.currentIndex === 4 ? motionPage
                : scenePage
        }
    }

    // ── right parameter panel (always mounted) ───────────────────────
    ParamPanel {
        id: paramPanel
        x: parent.width - width - 24
        y: 24
        height: parent.height - 48
        darkMode: root.themeMode === "dark"
        onThemeRequested: function(mode) { root.applyTheme(mode) }
    }

    // ── modal dialog overlay (G3a) ───────────────────────────────────
    // Declared at root level rather than inside PopupsPage so the scrim can
    // cover the whole gallery window, nav and parameter panel included.
    GlassDialog {
        id: glassDialog
        anchors.fill: parent
        reduceMotion: root.reduceMotionOn
        scrimMode: root.scrimMode
    }

    Component {
        id: overviewPage
        OverviewPage {
            previewOpacity: root.previewOpacity
            blurAmount: root.blurAmount
            previewRadius: root.previewRadius
            tintStrength: root.tintStrength
            radiusPill: root.radiusPill
            reduceMotionOn: root.reduceMotionOn
        }
    }
    Component {
        id: surfacesPage
        SurfacesPage {
            previewOpacity: root.previewOpacity
            blurAmount: root.blurAmount
            previewRadius: root.previewRadius
            tintStrength: root.tintStrength
            radiusPill: root.radiusPill
            reduceMotionOn: root.reduceMotionOn
        }
    }
    Component {
        id: popupsPage
        PopupsPage {
            dialog: glassDialog
            reduceMotionOn: root.reduceMotionOn
            scrimMode: root.scrimMode
            onScrimModeSelected: function(mode) { root.scrimMode = mode }
        }
    }
    Component {
        id: controlsPage
        ControlsPage {
            previewOpacity: root.previewOpacity
            blurAmount: root.blurAmount
            previewRadius: root.previewRadius
            tintStrength: root.tintStrength
            radiusPill: root.radiusPill
        }
    }
    Component {
        id: motionPage
        MotionPage {
            previewOpacity: root.previewOpacity
            blurAmount: root.blurAmount
            blurLevel: root.blurLevel
            previewRadius: root.previewRadius
            tintStrength: root.tintStrength
            radiusPill: root.radiusPill
            reduceMotionOn: root.reduceMotionOn
        }
    }
    Component {
        id: scenePage
        ScenePage {}
    }

    // GALLERY_MOTION_REDUCE=1 seeds the panel switch before the first frame so
    // the motion page's reduce screenshots need no synthetic click.
    Component.onCompleted: {
        if (Quickshell.env("GALLERY_MOTION_REDUCE") === "1")
            paramPanel.reduceMotionOn = true
    }
}
