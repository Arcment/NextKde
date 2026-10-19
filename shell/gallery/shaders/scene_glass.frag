#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

// S1 — in-window content sampling. `source` is a ShaderEffectSource pointed at
// the scrolling content behind the capsule; Qt Quick binds a sampler by QML
// property name, so this must stay `source` or every tap reads black.
layout(binding = 1) uniform sampler2D source;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float radius;
    vec2 pillSize;
    vec4 tintColor;
    float tintStrength;
    float refractAmount;
    float highlightStrength;
    vec4 strokeColor;
};

float sdRoundBox(vec2 p, vec2 halfSize, float r)
{
    vec2 q = abs(p) - halfSize + vec2(r);
    return length(max(q, vec2(0.0))) + min(max(q.x, q.y), 0.0) - r;
}

// 3x3 taps on the 1/6-downsampled capture. The texture is already blurry from
// bilinear reconstruction; the taps only have to remove the remaining block
// structure, so a small cross/Gaussian kernel is enough and cheap.
vec3 blur9(vec2 uv, vec2 step)
{
    vec3 c = texture(source, uv).rgb * 0.25;
    c += texture(source, uv + vec2(step.x, 0.0)).rgb * 0.125;
    c += texture(source, uv - vec2(step.x, 0.0)).rgb * 0.125;
    c += texture(source, uv + vec2(0.0, step.y)).rgb * 0.125;
    c += texture(source, uv - vec2(0.0, step.y)).rgb * 0.125;
    c += texture(source, uv + step).rgb * 0.0625;
    c += texture(source, uv - step).rgb * 0.0625;
    c += texture(source, uv + vec2(step.x, -step.y)).rgb * 0.0625;
    c += texture(source, uv + vec2(-step.x, step.y)).rgb * 0.0625;
    return c;
}

void main()
{
    vec2 halfSize = pillSize * 0.5;
    float r = min(radius, min(halfSize.x, halfSize.y));
    vec2 p = (qt_TexCoord0 - 0.5) * pillSize;

    // Rounded-rectangle SDF. dist < 0 inside, > 0 outside, -dist is the
    // distance to the nearest edge for interior pixels.
    float dist = sdRoundBox(p, halfSize, r);
    float band = max(fwidth(dist), 1e-6);
    float shape = 1.0 - clamp(0.5 + dist / band, 0.0, 1.0);
    float inside = max(-dist, 0.0);

    // Refraction: the SDF gradient is the outward normal. Finite differences
    // at three quarters of a pixel keep the normal stable under the 1px edge
    // anti-aliasing. The offset is confined to a band hugging the rim (about
    // 0.9 x radius deep), which is where a lens would bend the backdrop; the
    // middle of the capsule stays a clean blur.
    const float eps = 0.75;
    vec2 grad = vec2(
        sdRoundBox(p + vec2(eps, 0.0), halfSize, r)
            - sdRoundBox(p - vec2(eps, 0.0), halfSize, r),
        sdRoundBox(p + vec2(0.0, eps), halfSize, r)
            - sdRoundBox(p - vec2(0.0, eps), halfSize, r))
        / (2.0 * eps);
    vec2 normal = normalize(grad + vec2(1e-6));

    float edgeBand = max(6.0, r * 0.9);
    float edge = 1.0 - smoothstep(0.0, edgeBand, inside);
    // 10px at refractAmount 1.0: the default 0.35 pulls the rim by ~3.5px,
    // enough to read as a lens without visibly displacing row labels.
    vec2 refractPx = normal * (refractAmount * edge * 10.0);
    vec2 uv = qt_TexCoord0 + refractPx / pillSize;

    // One texel of the downsample, expressed in UV. Spread the taps 1.25 texels
    // so the kernel reaches across the bilinear reconstruction.
    vec2 step = 1.25 * 6.0 / pillSize;
    vec3 sampled = blur9(uv, step);

    vec3 color = mix(sampled, tintColor.rgb, clamp(tintStrength, 0.0, 1.0));

    // Top highlight: a 2.5px band hanging from the upper edge. It is the only
    // light source the capsule pretends to have, and it makes the top edge
    // legible over a bright row as well as a dark one.
    float topDist = p.y + halfSize.y;
    float topBand = 1.0 - smoothstep(0.0, 2.5, topDist);
    color += vec3(highlightStrength) * topBand;

    // Inner 1px stroke, drawn along the same SDF so it follows the corner
    // exactly instead of being clipped like Rectangle.border would be.
    float rim = 1.0 - smoothstep(0.0, 1.5, inside);
    color = mix(color, strokeColor.rgb, rim * strokeColor.a);

    // No separate outer ring: outside the silhouette stays transparent so the
    // sharp content beneath remains visible right up to the glass edge, which
    // is what lets the blur/refraction boundary be judged.
    fragColor = vec4(color, 1.0) * shape * qt_Opacity;
}
