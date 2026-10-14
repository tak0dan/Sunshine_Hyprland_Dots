#!/usr/bin/env bash
# ==================================================
#  Sunshine Hyprland Dots (2026)
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Runs rofi with its own keyboard layout, separate from the focused window.
#   RofiKeyboardLayout.sh <rofi arguments...>
# On open: remember the window's layout, switch to rofi's layout (default: index 0).
# Ctrl+Shift+L inside rofi: cycle rofi's layout and reopen rofi with the same arguments.
# On close: restore the window's layout.

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sunshinedots"
ROFI_INDEX_FILE="$STATE_DIR/rofi-layout-index"
CYCLE_KEY="Control+Shift+l"
CYCLE_RC=10            # rofi exit code for -kb-custom-1
# ~/.config/rofi is left empty by the installer, so rofi needs the config path
# or it starts unthemed. Callers that pass their own -config keep it.
ROFI_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/rofi/config.rasi"
mkdir -p "$STATE_DIR"

# Keyboards that take layout changes (the first one is used for reading).
kb_names() { hyprctl devices -j 2>/dev/null | jq -r '.keyboards[] | select(.layout != "") | .name'; }

kb_count() {
  hyprctl devices -j 2>/dev/null | jq -r '[.keyboards[] | select(.layout != "")][0].layout // ""' | awk -F, '{print NF}'
}

kb_current() {
  hyprctl devices -j 2>/dev/null | jq -r '[.keyboards[] | select(.main==true)][0].active_layout_index // ([.keyboards[]][0].active_layout_index) // 0'
}

kb_set() {
  local idx="$1" name
  while read -r name; do
    [ -n "$name" ] || continue
    hyprctl switchxkblayout "$name" "$idx" >/dev/null 2>&1 || true
  done < <(kb_names)
}

rofi_index() {
  local idx=0
  [ -f "$ROFI_INDEX_FILE" ] && idx=$(<"$ROFI_INDEX_FILE")
  printf '%s' "$idx"
}

save_rofi_index() { printf '%s\n' "$1" > "$ROFI_INDEX_FILE"; }

main() {
  local window_index count rc new_index
  window_index=$(kb_current)
  count=$(kb_count)
  [ "${count:-0}" -ge 1 ] || count=1

  kb_set "$(rofi_index)"

  while true; do
    if [[ " $* " == *" -config "* ]]; then
      rofi -kb-custom-1 "$CYCLE_KEY" "$@"
    else
      rofi -kb-custom-1 "$CYCLE_KEY" -config "$ROFI_CONFIG" "$@"
    fi
    rc=$?
    if [ "$rc" -eq "$CYCLE_RC" ]; then
      new_index=$(( ( $(rofi_index) + 1 ) % count ))
      save_rofi_index "$new_index"
      kb_set "$new_index"
      continue
    fi
    break
  done

  kb_set "$window_index"
  return 0
}

main "$@"
