-- ==================================================
--  Sunshine Hyprland Dots (2026)
--  Project URL: https://github.com/tak0dan/Sunshine_Hyprland_Dots
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================

-- Converted from config/hypr/UserConfigs/01-UserDefaults.conf (active values only).

SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}
local editor = os.getenv("EDITOR")
if editor == nil or editor == "" then
  editor = "nano"
end
local visual = os.getenv("VISUAL")
if visual == nil then
  visual = ""
end
SUNSHINEDOTS_DEFAULTS.edit = editor
SUNSHINEDOTS_DEFAULTS.visual = visual
SUNSHINEDOTS_DEFAULTS.term = "kitty"
SUNSHINEDOTS_DEFAULTS.files = "dolphin"
SUNSHINEDOTS_DEFAULTS.search_engine = "https://www.google.com/search?q={}"

-- Optional user overrides live outside the pristine lua/ source tree.
do
  local configHome = os.getenv("XDG_CONFIG_HOME") or ((os.getenv("HOME") or "") .. "/.config")
  local userDefaults = configHome .. "/hypr/UserConfigs/user_defaults.lua"
  local ok, err = pcall(dofile, userDefaults)
  if not ok and err and tostring(err):find("No such file or directory", 1, true) == nil then
    print("[WARN] Unable to load user defaults file " .. userDefaults .. ": " .. tostring(err))
  end
end
