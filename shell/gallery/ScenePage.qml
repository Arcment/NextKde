import QtQuick
import Quickshell
import qs.desktop.modules.common
import "components"

// S2 — scene page: fixed glass capsules floating over scrolling content.
//
// The point of the page is a side-by-side: the upper capsule is the existing
// LiquidGlassPanel without KWin and without sampling (it keeps its ambient
// QML finish), the lower one captures the content directly under it with a
// ShaderEffectSource and paints blur + refraction + tint entirely in QML.
// Nothing here touches KWin or ext-background-effect.
//
// Both capsules sit in the right half on top of the dot column so the row
// titles on the left stay clear. The vertical 6px stripe band is the
// refraction judge: it crosses both capsule edges, so a lens bend shows as a
// visible kink at the rim.
Item {
    id: page

    readonly property color ink: AppearanceTokens.content.glassInk()
    readonly property color inkDim: AppearanceTokens.content.glassInk(0.62)
    readonly property bool dark: AppearanceTokens.isDarkTheme

    // The chrome ink S1 used everywhere. Kept as an explicit comparison
    // target: GALLERY_SCENE_INK=fixed paints it over every row, including the
    // light ones where it has visibly too little contrast.
    readonly property color fixedInk: "#f2f4f7"

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

    // Default is the declared tone: the capsule centre's row (from the scroll
    // position) picks dark ink on light rows and light ink on dark rows.
    // GALLERY_SCENE_INK=fixed turns that off for the contrast comparison.
    property bool declaredTone:
        Quickshell.env("GALLERY_SCENE_INK") !== "fixed"

    // scenePill.y is in page coordinates, so the stage offset has to come out
    // before the row arithmetic; otherwise every row is reported one late.
    readonly property int pillRow: Math.max(0, Math.min(rowCount - 1,
        Math.floor((scenePill.y - stage.y + scenePill.height / 2
            + flick.contentY) / rowHeight)))
    readonly property bool overLightRow: pillRow % 2 === 1

    // ── ink selection: the material's colour, not the raw row ─────────
    // The declared tone used to follow the row colour alone, so in the light
    // theme a dark row chose white text even though the white tint lifts the
    // capsule to mid grey. The shader paints
    //   mix(sampled, tintColor, tintStrength)
    // so the row only contributes (1 - tintStrength); tintLuminance is 0 for
    // the black dark-mode tint and 1 for the white light-mode tint. The
    // weights are the same perceptual formula LiquidGlassSurface uses.
    readonly property color tintColor: dark ? "#000000" : "#ffffff"
    readonly property real tintStrength: dark ? 0.18 : 0.32
    readonly property real tintLuminance: dark ? 0.0 : 1.0
    // Tuned against the two screenshot rows: light theme + dark row lands at
    // 0.36 and must be dark ink, dark theme + light row at 0.75.
    readonly property real inkThreshold: 0.34

    readonly property color rowColorDark: "#0d0f12"
    readonly property color rowColorLight: "#e8eaee"

    function colorLuminance(c) {
        return c.r * 0.2126 + c.g * 0.7152 + c.b * 0.0722
    }
    function effectiveLuminance(rowLum) {
        return rowLum * (1.0 - tintStrength) + tintLuminance * tintStrength
    }
    function inkFor(rowLum) {
        return effectiveLuminance(rowLum) < inkThreshold ? "#f2f4f7" : "#16181c"
    }

    readonly property real sceneRowLuminance:
        colorLuminance(overLightRow ? rowColorLight : rowColorDark)
    readonly property real sceneEffectiveLuminance:
        effectiveLuminance(sceneRowLuminance)
    readonly property color declaredInk: inkFor(sceneRowLuminance)
    readonly property color sceneInk: declaredTone ? declaredInk : fixedInk

    // The tonal capsule sits exactly one row below the scene capsule. Without
    // sampling it still needs the same rule; the tint strength above is the
    // page's closest stand-in for its baseColor overlay.
    readonly property int tonalRow: Math.min(rowCount - 1, pillRow + 1)
    readonly property bool tonalOverLightRow: tonalRow % 2 === 1
    readonly property real tonalRowLuminance:
        colorLuminance(tonalOverLightRow ? rowColorLight : rowColorDark)
    readonly property real tonalEffectiveLuminance:
        effectiveLuminance(tonalRowLuminance)
    readonly property color tonalInk:
        declaredTone ? inkFor(tonalRowLuminance) : fixedInk

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

                        // Refraction judge: two 48px bands of 6px light /
                        // 6px dark vertical stripes, one crossing each
                        // capsule edge. Keeping them off the capsule centre
                        // leaves the row's own colour behind the label, so
                        // the ink comparison is not averaged to mid-grey.
                        Repeater {
                            model: 16
                            Rectangle {
                                required property int index
                                x: (index < 8 ? 306 : 526) + (index % 8) * 6
                                width: 6
                                height: page.rowHeight
                                color: index % 2 === 0
                                    ? (rowItem.index % 2 === 0
                                        ? "#f2f4f7" : "#ffffff")
                                    : (rowItem.index % 2 === 0
                                        ? "#111318" : "#16181c")
                            }
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
    // Both capsules are stacked over the dot column in the right half. The
    // row titles (x 28) keep their full width, and the legend below explains
    // the two materials instead of stamping a caption over the content.
    //
    // Upper: scene-sampled, pure QML. It sits over row 0 at offset 0 and over
    // the light row 5 at offset 600, which is exactly where the declared /
    // fixed ink comparison has to be read.
    SceneGlassPill {
        id: scenePill
        x: stage.x + 330
        y: stage.y + 38
        width: 220
        height: 44
        radius: 22
        sourceItem: rowsColumn
        // Explicit arithmetic instead of mapToItem: a mapping call is not a
        // tracked dependency, so at contentY 0 the binding kept the rectangle
        // it computed during construction (before layout) forever — the pill
        // sampled the strip above itself. Every term below is a tracked QML
        // property, so the rect re-evaluates as soon as the layout settles.
        sourceRect: {
            const settle = rowsColumn.height + flick.contentHeight
            const contentX = flick.contentX
            const contentY = flick.contentY
            const originX = scenePill.x - viewport.x - flick.x + contentX
            const originY = scenePill.y - viewport.y - flick.y + contentY
            return Qt.rect(originX, originY, scenePill.width, scenePill.height)
        }
        tintColor: page.tintColor
        tintStrength: page.tintStrength
        strokeColor: page.dark
            ? Qt.rgba(1, 1, 1, 0.28) : Qt.rgba(0, 0, 0, 0.22)
        highlightStrength: page.dark ? 0.10 : 0.22

        Text {
            anchors.centerIn: parent
            text: "scene"
            color: page.sceneInk
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }
    }

    // Lower: tonal, no sampling. Same size/radius as the scene capsule so the
    // comparison is material-only.
    LiquidGlassPanel {
        id: tonalPill
        x: stage.x + 330
        y: stage.y + 158
        width: 220
        height: 44
        radius: 22
        cornerExponent: 2.0
        useKwinEffect: false
        material: "regular"
        baseColor: page.dark ? Qt.rgba(0, 0, 0, 0.22) : Qt.rgba(1, 1, 1, 0.26)

        // The panel derives its foreground from the theme, but the page knows
        // the row underneath, so the same effective-luminance rule as the
        // scene capsule owns the ink here.
        Text {
            anchors.centerIn: parent
            text: "tonal"
            color: page.tonalInk
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }
    }

    // First-frame sampling: the capture can run before the repeater has laid
    // out its rows, which leaves the texture flat. Recapture once after the
    // scene settles, whenever the content height changes, and when a scroll
    // stops.
    Component.onCompleted: firstFrameRefresh.start()

    Timer {
        id: firstFrameRefresh
        interval: 260
        repeat: false
        onTriggered: scenePill.refresh()
    }

    Connections {
        target: flick
        function onContentHeightChanged() { scenePill.refresh() }
        function onMovingChanged() {
            if (!flick.moving)
                scenePill.refresh()
        }
    }

    // ── legend ───────────────────────────────────────────────────────
    Row {
        x: 0
        y: stage.y + stage.height + 14
        height: 20
        spacing: 18

        Rectangle {
            width: 8
            height: 8
            radius: 4
            anchors.verticalCenter: parent.verticalCenter
            color: "#8b93a1"
        }
        Text {
            text: "tonal — LiquidGlassPanel（环境色，无采样）"
            color: page.inkDim
            font.pixelSize: 12
            height: parent.height
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle {
            width: 8
            height: 8
            radius: 4
            anchors.verticalCenter: parent.verticalCenter
            color: "#8b93a1"
        }
        Text {
            text: "scene — 内容采样（纯 QML）"
            color: page.inkDim
            font.pixelSize: 12
            height: parent.height
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle {
            width: 8
            height: 8
            radius: 2
            anchors.verticalCenter: parent.verticalCenter
            color: "#d6dbe4"
        }
        Text {
            text: "竖条带 6px — 折射判据"
            color: page.inkDim
            font.pixelSize: 12
            height: parent.height
            verticalAlignment: Text.AlignVCenter
        }
    }

    // ── declared-tone toggle ─────────────────────────────────────────
    Row {
        x: 0
        y: stage.y + stage.height + 50
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
                ? ("declared · row " + page.pillRow + " · effective "
                    + page.sceneEffectiveLuminance.toFixed(2) + " · "
                    + (page.sceneEffectiveLuminance < page.inkThreshold
                        ? "浅字" : "深字"))
                : "fixed · 固定浅字（浅行对比度低）"
            color: page.inkDim
            font.pixelSize: 12
        }
    }

    // Read-only readout for the manual check: the declared row luminance, the
    // luminance after the tint is mixed in, and the ink each capsule got.
    Text {
        x: 0
        y: stage.y + stage.height + 80
        text: "scene  rowLum " + page.sceneRowLuminance.toFixed(3)
            + " / effectiveLum " + page.sceneEffectiveLuminance.toFixed(3)
            + " / ink " + page.declaredInk
            + "    tonal  rowLum " + page.tonalRowLuminance.toFixed(3)
            + " / effectiveLum " + page.tonalEffectiveLuminance.toFixed(3)
            + " / ink " + page.inkFor(page.tonalRowLuminance)
        color: page.inkDim
        font.pixelSize: 12
        font.family: "monospace"
    }

    Text {
        x: 0
        y: stage.y + stage.height + 104
        width: stage.width
        wrapMode: Text.WordWrap
        text: "上：SceneGlassPill 采样正下方内容，1/6 降采样 + 9 tap 模糊，"
            + "边缘沿 SDF 法线做 3.5px 折射，tint 随主题（深色 0.18 / 浅色 0.32）；"
            + "下：LiquidGlassPanel（useKwinEffect: false），只用自己的环境色。"
            + "文字 ink 取 mix(rowLum, tintLum, tintStrength) 后与 0.34 比较，"
            + "浅色主题下深行被 tint 抬到中灰，因此也走深字。"
            + "滚轮或拖拽内容，胶囊内的行号应与下方露出的行号一致；"
            + "竖条带在胶囊左右边缘处应出现可辨认的弯折。"
        color: page.inkDim
        font.pixelSize: 12
        lineHeight: 1.35
    }
}
