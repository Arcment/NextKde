import QtQuick

// S1 — glass capsule that samples its own window content.
//
// No KWin involvement: a ShaderEffectSource captures the sibling content item
// into a 1/6 texture, and shaders/scene_glass.frag (baked to .qsb) blurs,
// refracts and tints it. There is deliberately no `useKwinEffect` property
// here — this component never talks to the compositor.
//
// The source item must be a sibling, never a descendant: a subtree cannot
// capture itself. `sourceRect` is in the source item's coordinate system and
// is bound by the host, because a binding over mapToItem alone does not
// re-evaluate when the source scrolls; the host adds the scroll position to
// the expression to keep it live.
Item {
    id: root

    property Item sourceItem: null
    property rect sourceRect: Qt.rect(0, 0, width, height)

    property real radius: 22
    property real refractAmount: 0.35

    // Theme-owned finish. The host passes these so the shader stays free of
    // appearance policy: black tint in dark mode, white in light mode.
    property color tintColor: "#000000"
    property real tintStrength: 0.30
    property color strokeColor: Qt.rgba(1, 1, 1, 0.28)
    property real highlightStrength: 0.10

    // Everything the caller writes between the braces sits above the glass.
    default property alias content: contentHost.data

    // 1/6 in each axis: the capture is cheap and already blurred by bilinear
    // reconstruction, so the shader's 9 taps finish the job. The height floor
    // keeps a 44px capsule from collapsing to 7 texture rows, where the blur
    // taps and the stripe judge both run out of resolution.
    readonly property size sampleSize: Qt.size(
        Math.max(1, Math.round(width / 6)),
        Math.max(12, Math.round(height / 6)))

    // The host calls this once the layout has settled. The capture can run on
    // an early frame, before the sampled subtree has laid out, and then paint
    // a flat colour; scheduleUpdate forces one fresh render of the source.
    function refresh() {
        capture.scheduleUpdate()
    }

    ShaderEffectSource {
        id: capture
        sourceItem: root.sourceItem
        sourceRect: root.sourceRect
        textureSize: root.sampleSize
        wrapMode: ShaderEffectSource.ClampToEdge
        live: true
        visible: false
    }

    ShaderEffect {
        anchors.fill: parent
        fragmentShader: Qt.resolvedUrl("../shaders/scene_glass.frag.qsb")

        // The name is the binding: a sampler must be announced to Qt Quick as
        // `source` for the ShaderEffectSource to find it.
        property variant source: capture

        property real radius: root.radius
        property vector2d pillSize: Qt.vector2d(root.width, root.height)
        property color tintColor: root.tintColor
        property real tintStrength: root.tintStrength
        property real refractAmount: root.refractAmount
        property color strokeColor: root.strokeColor
        property real highlightStrength: root.highlightStrength
    }

    Item {
        id: contentHost
        anchors.fill: parent
    }
}
