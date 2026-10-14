#!/usr/bin/env python3
# ==================================================
#  Sunshine Hyprland Dots (2026)
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Converts a hyprlang Keybinds.conf into bind(...) calls for configs/system_keybinds.lua.
# Keeps the helper section of the existing Lua file and the trailing submap block.
#   keybinds_to_lua.py <Keybinds.conf> <system_keybinds.lua> <output.lua>
import re
import sys

VARS = {
    "$mainMod": "SUPER",
    "$scriptsDir": "$HOME/.config/hypr/scripts",
    "$UserScripts": "$HOME/.config/hypr/UserScripts",
    "$UserConfigs": "$HOME/.config/hypr/UserConfigs",
}
MODIFIER_KEYS = {"ALT_L": ("ALT", "Alt_L"), "ALT_R": ("ALT", "Alt_R"),
                 "SHIFT_L": ("SHIFT", "Shift_L"), "SHIFT_R": ("SHIFT", "Shift_R"),
                 "CTRL_L": ("CTRL", "Control_L"), "CTRL_R": ("CTRL", "Control_R"),
                 "SUPER_L": ("SUPER", "Super_L")}


def lua_string(s):
    # Long brackets keep shell quoting intact.
    level = 0
    while "]" + "=" * level + "]" in s:
        level += 1
    return "[" + "=" * level + "[" + s + "]" + "=" * level + "]"


def expand(text):
    for k, v in VARS.items():
        text = text.replace(k, v)
    return text


def convert_line(line):
    m = re.match(r"^(bind[a-z]*)\s*=\s*(.*)$", line.strip())
    if not m:
        return None
    flags, rest = m.group(1)[4:], m.group(2)
    rest = re.sub(r"\s+#.*$", "", rest).strip()  # trailing comment
    parts = [p.strip() for p in rest.split(",", 4)]
    if flags.startswith("d") or "d" in flags:
        if len(parts) < 4:
            return None
        mods, key, desc = parts[0], parts[1], parts[2]
        dispatcher = parts[3]
        args = parts[4] if len(parts) > 4 else ""
    else:
        if len(parts) < 3:
            return None
        mods, key = parts[0], parts[1]
        dispatcher = parts[2]
        args = parts[3] if len(parts) > 3 else ""
        desc = dispatcher
    mods = expand(mods)
    key = expand(key)
    opts = []
    if "l" in flags:
        opts.append("locked = true")
    if "e" in flags:
        opts.append("repeating = true")
    if key in MODIFIER_KEYS:
        mod, key = MODIFIER_KEYS[key]
        mods = mod
    mods = " ".join(mods.split())
    if dispatcher == "exec":
        # Rofi runs through the layout wrapper so it opens in its own layout.
        args = re.sub(r"(?<![\w/])rofi -show", "$scriptsDir/RofiKeyboardLayout.sh -show", args)
        action = f"exec_cmd({lua_string(expand(args))})"
    else:
        action = f"dispatch({lua_string(dispatcher)}, {lua_string(expand(args))})"
    opts.insert(0, f"description = {lua_string(desc)}")
    return f'bind("{mods}", "{key}", {action}, {{ {", ".join(opts)} }})'


def main():
    conf, base, out = sys.argv[1:4]
    binds = []
    skipped = []
    for line in open(conf, encoding="utf-8"):
        s = line.strip()
        if not s or s.startswith("#") or s.startswith("$") or s.startswith("source") or s.startswith("exec-once"):
            continue
        b = convert_line(line)
        (binds if b else skipped).append(b or s)
    src = open(base, encoding="utf-8").read()
    head = src[: src.index("-- Converted from configs/Keybinds.conf")] if "-- Converted from configs/Keybinds.conf" in src else src[: src.index("\nbind(")]
    tail_idx = src.find("-- KB passthrough submap")
    tail = src[tail_idx:] if tail_idx >= 0 else ""
    body = "-- Converted from the user's Keybinds.conf (scripts/keybinds_to_lua.py).\n" + "\n".join(binds) + "\n\n"
    open(out, "w", encoding="utf-8").write(head + body + tail)
    print(f"converted {len(binds)} binds; skipped {len(skipped)}")
    for s in skipped:
        print("  skipped:", s)


if __name__ == "__main__":
    main()
