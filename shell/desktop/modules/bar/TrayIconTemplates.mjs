// Menu-bar templates carry transparent internal details instead of a colored
// application badge. Resolve identity before replacing artwork: Electron tray
// IDs alone are often generic and must never be guessed to be a particular app.
export function bundledTemplate(id, name) {
    const names = [id, name].map(value => String(value || "").trim().toLowerCase());
    const identity = names.join("\n");
    if (/(^|[\s:./_-])(codex|chatgpt|openai)($|[\s:./_-])/.test(identity)) return "openai.svg";
    if (names.some(value => /^(qq|linuxqq|linux qq|腾讯qq|com\.tencent\.qq|com\.qq\.qq)$/.test(value))) return "qq.svg";
    if (/clash[-_\s]?verge/.test(identity)) return "clash-verge.png";
    if (names.some(value => /^(wechat|weixin|微信)$/.test(value))) return "wechat.svg";
    if (/splayer[-_\s]?next/.test(identity)) return "music.svg";
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
