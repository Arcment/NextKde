import QtQuick
import Quickshell
import qs.desktop.modules.common
import "components"

// S1 — scene page: a fixed glass capsule floating over scrolling content.
//
// The point of the page is a side-by-side: the left capsule is the existing
// LiquidGlassPanel without KWin and without sampling (it keeps its ambient
// QML finish), the right one captures the content directly under it with a
// ShaderEffectSource and paints blur + refraction + tint entirely in QML.
// Nothing here touches KWin or ext-background-effect.
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property bool dark: AppearanceTokens.isDarkTheme

    // Screenshot hook: shot.sh exports GALLERY_SCENE_OFFSET in front of the
    // run, so the initial scroll position is reproducible.
    readonly property int initialOffset: {
        const v = parseInt(Quickshell.env("GALLERY_SCENE_OFFSET") || "0", 10)
        return isNaN(v) ? 0 : v
    }

    // 10 rows of 120px, alternating. Row index 0 is dark at contentY 0, row 5
    // is light — the two screenshot offsets land on one of each.
    readonly property int rowHeight: 120
    readonly property int rowCount: 10

    // The capsule does not sample for this value: it is declared from the
    // scroll position, which is exactly what the toggle is meant to contrast
    // with the scene-sampled material.
    readonly property int pillRow: Math.max(0, Math.min(rowCount - 1,
        Math.floor((scenePill.y + scenePill.height / 2 + flick.contentY) / rowHeight)))
    readonly property bool overLightRow: pillRow % 2 === 1
    readonly property color declaredInk: overLightRow ? "#16181c" : "#f2f4f7"

    // ── header ───────────────────────────────────────────────────────
    Text {
        x: 0
        y: 0
        text: "场景"
        color: page.ink
        font.pixelSize: 24
        font.weight: Font.DemiBold
    }
    Text {
        x: 0
        y: 34
        text: "同窗口内容采样 · ShaderEffectSource + ShaderEffect · 纯 QML · 无 KWin"
        color: page.inkDim
        font.pixelSize: 13
    }

    // ── content stage ────────────────────────────────────────────────
    Item {
        id: stage
        x: 0
        y: 78
        width: 640
        height: 420
    }

    // Sharp content, scrolled by the user (and seeded by the screenshot hook).
    // It is a plain Rectangle Flickable with clipped square edges: rounding the
    // viewport would need a layered mask around the item this page samples.
    Rectangle {
        id: viewport
        x: stage.x
        y: stage.y
        width: stage.width
        height: stage.height
        color: "#0d0f12"
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.16)

        Flickable {
            id: flick
            anchors.fill: parent
            clip: true
            contentWidth: width
            contentHeight: rowsColumn.height
            boundsBehavior: Flickable.StopAtBounds
            // Initial value only; a drag writes contentY and releases the
            // binding, which is what a normal flickable should do.
            contentY: Math.max(0, Math.min(page.initialOffset,
                contentHeight - height))

            Column {
                id: rowsColumn
                width: flick.width

                Repeater {
                    model: page.rowCount

                    delegate: Rectangle {
                        id: rowItem
                        required property int index

                        width: rowsColumn.width
                        height: page.rowHeight
                        color: index % 2 === 0 ? "#0d0f12" : "#e8eaee"

                        Text {
                            x: 28
                            anchors.verticalCenter: parent.verticalCenter
                            text: (index % 2 === 0 ? "深色内容 " : "浅色内容 ")
                                + (index + 1)
                            color: index % 2 === 0 ? "#e9edf2" : "#14161a"
                            font.pixelSize: 42
                            font.weight: Font.DemiBold
                        }
                        Text {
                            x: 28
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 18
                            text: "row " + index + " · y " + (index * page.rowHeight)
                            color: index % 2 === 0 ? "#8b93a1" : "#5b6270"
                            font.pixelSize: 12
                        }

                        // High-contrast markers sit directly under the scene
                        // capsule: their smear and rim bend are what make the
                        // 1/6 capture and the SDF refraction judgeable.
                        Repeater {
                            model: 6
                            Rectangle {
                                required property int index
                                x: 344 + index * 38
                                anchors.verticalCenter: parent.verticalCenter
                                width: 30
                                height: 30
                                radius: 15
                                color: rowItem.index % 2 === 0
                                    ? "#d6dbe4" : "#2a2f38"
                            }
                        }
                    }
                }
            }
        }
    }

    // ── fixed capsules ───────────────────────────────────────────────
    // Left: tonal, no sampling. Same size/radius as the right one so the
    // comparison is material-only.
    LiquidGlassPanel {
        id: tonalPill
        x: stage.x + 88
        y: stage.y + 44
        width: 220
        height: 44
        radius: 22
        cornerExponent: 2.0
        useKwinEffect: false
        material: "regular"
        baseColor: page.dark ? Qt.rgba(0, 0, 0, 0.22) : Qt.rgba(1, 1, 1, 0.26)

        Text {
            anchors.centerIn: parent
            text: "tonal"
            color: page.ink
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }
    }

    // Right: scene-sampled, pure QML.
    SceneGlassPill {
        id: scenePill
        x: stage.x + 332
        y: stage.y + 44
        width: 220
        height: 44
        radius: 22
        sourceItem: rowsColumn
        // mapToItem is not reactive on its own: reading contentY in the same
        // expression is what makes sourceRect follow the scroll.
        sourceRect: {
            const scrollY = flick.contentY
            const origin = scenePill.mapToItem(rowsColumn, 0, 0)
            return Qt.rect(origin.x, origin.y, scenePill.width, scenePill.height)
        }
        tintColor: page.dark ? "#000000" : "#ffffff"
        tintStrength: page.dark ? 0.30 : 0.32
        strokeColor: page.dark
            ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(0, 0, 0, 0.22)
        highlightStrength: page.dark ? 0.10 : 0.22

        Text {
            anchors.centerIn: parent
            text: "scene"
            color: page.declaredTone ? page.declaredInk : page.ink
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }
    }

    // Captions sit directly under their capsule on a small dark chip so they
    // stay legible over both the dark and the light rows.
    Rectangle {
        x: tonalPill.x + (tonalPill.width - width) / 2
        y: tonalPill.y + tonalPill.height + 8
        width: tonalCaption.implicitWidth + 16
        height: 22
        radius: 11
        color: Qt.rgba(0, 0, 0, 0.45)

        Text {
            id: tonalCaption
            anchors.centerIn: parent
            text: "tonal（环境色）"
            color: "#f2f4f7"
            font.pixelSize: 11
        }
    }
    Rectangle {
        x: scenePill.x + (scenePill.width - width) / 2
        y: scenePill.y + scenePill.height + 8
        width: sceneCaption.implicitWidth + 16
        height: 22
        radius: 11
        color: Qt.rgba(0, 0, 0, 0.45)

        Text {
            id: sceneCaption
            anchors.centerIn: parent
            text: "scene（内容采样 · 纯 QML）"
            color: "#f2f4f7"
            font.pixelSize: 11
        }
    }

    // ── declared-tone toggle ─────────────────────────────────────────
    property bool declaredTone: false

    Row {
        x: 0
        y: stage.y + stage.height + 20
        height: 22
        spacing: 10

        Text {
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: "文字自适应（declared）"
            color: page.ink
            font.pixelSize: 13
        }

        Rectangle {
            width: 36
            height: 20
            radius: 10
            anchors.verticalCenter: parent.verticalCenter
            color: page.declaredTone
                ? Qt.rgba(1, 1, 1, 0.35) : Qt.rgba(1, 1, 1, 0.12)

            Rectangle {
                x: page.declaredTone ? 18 : 2
                y: 2
                width: 16
                height: 16
                radius: 8
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: page.declaredTone = !page.declaredTone
            }
        }

        Text {
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            text: page.declaredTone
                ? ("row " + page.pillRow + " · " + (page.overLightRow
                    ? "浅色内容 · 深字" : "深色内容 · 浅字"))
                : "关闭：固定 ink"
            color: page.inkDim
            font.pixelSize: 12
        }
    }

    Text {
        x: 0
        y: stage.y + stage.height + 56
        width: stage.width
        wrapMode: Text.WordWrap
        text: "左：LiquidGlassPanel（useKwinEffect: false），只用自己的环境色；"
            + "右：SceneGlassPill 采样正下方内容，1/6 降采样 + 9 tap 模糊，"
            + "边缘沿 SDF 法线做 3.5px 折射，tint 随主题（深色偏黑 / 浅色偏白）。"
            + "滚轮或拖拽内容，胶囊内的行号应与下方露出的行号一致。"
        color: page.inkDim
        font.pixelSize: 12
        lineHeight: 1.35
    }
}
