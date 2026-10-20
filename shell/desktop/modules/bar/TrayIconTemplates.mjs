// Menu-bar templates carry transparent internal details instead of a colored
// application badge. Resolve identity before replacing artwork: Electron tray
// IDs alone are often generic and must never be guessed to be a particular app.
const templates = new Map([
    ["codex", "openai.svg"], ["chatgpt", "openai.svg"], ["openai", "openai.svg"],
    ["com.openai.codex", "openai.svg"], ["com.openai.chatgpt", "openai.svg"],
    ["qq", "qq.svg"], ["linuxqq", "qq.svg"], ["linux qq", "qq.svg"],
    ["腾讯qq", "qq.svg"], ["com.tencent.qq", "qq.svg"], ["com.qq.qq", "qq.svg"],
    ["workbuddy", "workbuddy.png"], ["com.tencent.workbuddy", "workbuddy.png"],
    ["clash-verge", "clash-verge.png"], ["clash verge", "clash-verge.png"],
    ["clash-verge-rev", "clash-verge.png"], ["clash-verge-rev-tray", "clash-verge.png"],
    ["wechat", "wechat.svg"], ["weixin", "wechat.svg"], ["微信", "wechat.svg"],
    ["splayer-next", "music.svg"], ["splayer next", "music.svg"],
    ["top.imsyy.splayer_next", "music.svg"]
]);

function identityToken(value) {
    return String(value || "").trim().toLowerCase().split(/\r?\n/)[0]
        .replace(/\.desktop$/, "")
        .replace(/^tray[-\s]?icon(?:\s+tray\s+app)?\s+/, "")
        .replace(/[_-]status[_-]icon[_-]?\d*$/, "");
}

export function bundledTemplate(id, name) {
    // Match complete app identities; a path or another application's title
    // containing "qq"/"codex" is not sufficient evidence to replace its logo.
    for (const value of [id, name]) {
        const template = templates.get(identityToken(value));
        if (template) return template;
    }
    return "";
}

export function symbolicCandidates(source, id, name) {
    const names = [];
    const icon = String(source || "");
    if (icon.startsWith("image://icon/")) {
        try { names.push(decodeURIComponent(icon.slice("image://icon/".length).split("?")[0])); }
        catch (error) { /* A malformed application URL still renders through its original provider. */ }
    }
    for (const value of [id, name]) {
        const token = String(value || "").trim().toLowerCase();
        if (!token || /status[_-]icon|^tray-icon|^[a-z0-9]{16,}$/.test(token)) continue;
        if (/^[a-z0-9][a-z0-9._ -]*$/.test(token)) names.push(token.replace(/\s+/g, "-"));
    }
    return [...new Set(names.map(value => value.endsWith("-symbolic") ? value : value + "-symbolic"))];
}
