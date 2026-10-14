# ==================================================
#  KoolDots fork additions (2026)
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Fork-only install steps, sourced by copy.sh:
#   - package install for Dolphin and the chosen editor (Arch, Debian/Ubuntu,
#     Fedora, openSUSE, Void)
#   - custom-info.json seeding for fastfetch
#   - fastfetch on interactive shell start

# Print the package manager family for this system: pacman, apt, dnf, zypper,
# xbps, or nothing when unsupported (NixOS and unknown distros).
fork_detect_pkg_family() {
  local id="" id_like=""
  if [ -f /etc/os-release ]; then
    id=$(. /etc/os-release && printf '%s' "${ID:-}")
    id_like=$(. /etc/os-release && printf '%s' "${ID_LIKE:-}")
  fi

  case " $id $id_like " in
    *" arch "*|*" manjaro "*|*" endeavouros "*|*" garuda "*) echo pacman; return 0 ;;
    *" debian "*|*" ubuntu "*) echo apt; return 0 ;;
    *" fedora "*|*" rhel "*) echo dnf; return 0 ;;
    *" suse "*|*" opensuse-tumbleweed "*|*" opensuse-leap "*) echo zypper; return 0 ;;
    *" void "*) echo xbps; return 0 ;;
    *" nixos "*) return 0 ;;
  esac

  # Fall back to whichever package manager binary exists.
  if command -v pacman >/dev/null 2>&1; then echo pacman
  elif command -v apt-get >/dev/null 2>&1; then echo apt
  elif command -v dnf >/dev/null 2>&1; then echo dnf
  elif command -v zypper >/dev/null 2>&1; then echo zypper
  elif command -v xbps-install >/dev/null 2>&1; then echo xbps
  fi
}

# Map a logical package name to the name used by the given package family.
# Only names that differ between families are listed here.
fork_pkg_name() {
  local family=$1 pkg=$2
  case "$pkg" in
    vim)
      if [ "$family" = dnf ]; then echo vim-enhanced; else echo vim; fi
      ;;
    *)
      echo "$pkg"
      ;;
  esac
}

# Install packages (logical names) with the detected package manager.
# Usage: fork_install_packages <log> <pkg>...
# Returns non-zero when the package manager fails or the system is unsupported.
fork_install_packages() {
  local log="${1:-/dev/null}"
  shift
  local family
  family=$(fork_detect_pkg_family)

  if [ -z "$family" ]; then
    echo "${WARN:-[WARN]} No supported package manager found for this system. Install manually: $*" 2>&1 | tee -a "$log"
    return 1
  fi

  local pkgs=() pkg
  for pkg in "$@"; do
    pkgs+=("$(fork_pkg_name "$family" "$pkg")")
  done

  echo "${INFO:-[INFO]} Installing via ${MAGENTA:-}${family}${RESET:-}: ${pkgs[*]}" 2>&1 | tee -a "$log"

  local rc=0
  case "$family" in
    pacman) { sudo pacman -S --needed --noconfirm "${pkgs[@]}"; } 2>&1 | tee -a "$log"; rc=${PIPESTATUS[0]} ;;
    apt)    { sudo apt-get install -y "${pkgs[@]}"; } 2>&1 | tee -a "$log"; rc=${PIPESTATUS[0]} ;;
    dnf)    { sudo dnf install -y "${pkgs[@]}"; } 2>&1 | tee -a "$log"; rc=${PIPESTATUS[0]} ;;
    zypper) { sudo zypper --non-interactive install "${pkgs[@]}"; } 2>&1 | tee -a "$log"; rc=${PIPESTATUS[0]} ;;
    xbps)   { sudo xbps-install -Sy "${pkgs[@]}"; } 2>&1 | tee -a "$log"; rc=${PIPESTATUS[0]} ;;
    *)      rc=1 ;;
  esac
  return "$rc"
}

# Dolphin is the fork's file manager; installed here so the default works.
install_fork_file_manager() {
  local log="${1:-/dev/null}"
  if fork_install_packages "$log" dolphin; then
    echo "${OK:-[OK]} Dolphin file manager installed." 2>&1 | tee -a "$log"
  else
    echo "${WARN:-[WARN]} Dolphin could not be installed. The file manager keybind falls back to other installed file managers." 2>&1 | tee -a "$log"
  fi
}

# Seed custom-info.json with the install date when it has no entries.
# Entries that already exist are left alone.
seed_custom_info_json() {
  local log="${1:-/dev/null}"
  local json="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/custom-info.json"
  local today
  today=$(date +%F)

  [ -f "$json" ] || return 0

  if [ ! -s "$json" ]; then
    printf '{\n  "entries": [\n    {\n      "title": "Dotfiles installed",\n      "since": "%s"\n    }\n  ]\n}\n' "$today" > "$json"
    echo "${OK:-[OK]} custom-info.json was empty; seeded with install date ${today}." 2>&1 | tee -a "$log"
    return 0
  fi

  if ! command -v python3 >/dev/null 2>&1; then
    echo "${WARN:-[WARN]} python3 not found; custom-info.json left unchanged." 2>&1 | tee -a "$log"
    return 0
  fi

  local count
  if ! count=$(python3 -c 'import json,sys; print(len(json.load(open(sys.argv[1])).get("entries") or []))' "$json" 2>/dev/null); then
    echo "${WARN:-[WARN]} custom-info.json is not valid JSON; left unchanged." 2>&1 | tee -a "$log"
    return 0
  fi

  if [ "$count" != "0" ]; then
    echo "${NOTE:-[NOTE]} custom-info.json already has entries; left unchanged." 2>&1 | tee -a "$log"
    return 0
  fi

  python3 - "$json" "$today" <<'PY'
import json, sys
path, day = sys.argv[1], sys.argv[2]
with open(path, encoding="utf-8") as f:
    data = json.load(f)
data["entries"] = [{"title": "Dotfiles installed", "since": day}]
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
  echo "${OK:-[OK]} custom-info.json seeded with install date ${today}." 2>&1 | tee -a "$log"
}

# Run fastfetch when an interactive shell starts, in .zshrc and .bashrc.
# Only existing rc files are touched, and the block is added once.
enable_fastfetch_on_shell() {
  local log="${1:-/dev/null}"
  local marker="# >>> KoolDots fastfetch >>>"
  local rc
  for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    [ -f "$rc" ] || continue
    if grep -qF "$marker" "$rc"; then
      continue
    fi
    cat >> "$rc" <<'EOF'

# >>> KoolDots fastfetch >>>
# Show fastfetch when an interactive shell starts (added by KoolDots).
case $- in
  *i*) command -v fastfetch >/dev/null 2>&1 && fastfetch ;;
esac
# <<< KoolDots fastfetch <<<
EOF
    echo "${OK:-[OK]} fastfetch will run on shell start (${rc})." 2>&1 | tee -a "$log"
  done
}

# Theme directory of the active SDDM theme. Reads Current= from sddm.conf and
# falls back to simple_sddm_2, the theme the fork's SDDM setup uses.
fork_sddm_theme_dir() {
  local conf theme="" value
  for conf in /etc/sddm.conf /etc/sddm.conf.d/*.conf; do
    [ -f "$conf" ] || continue
    value=$(sed -nE 's/^[[:space:]]*Current[[:space:]]*=[[:space:]]*//p' "$conf" | tail -n1 | tr -d '[:space:]')
    [ -n "$value" ] && theme="$value"
  done
  printf '/usr/share/sddm/themes/%s\n' "${theme:-simple_sddm_2}"
}

# Set the SDDM login background from an image file.
# The path comes from the theme's Background= key (Backgrounds/default for
# simple_sddm_2). Needs sudo, since the theme lives under /usr/share.
set_fork_sddm_background() {
  local log="${1:-/dev/null}" src="$2"
  local dir bg_rel ext
  dir=$(fork_sddm_theme_dir)

  if [ ! -d "$dir" ]; then
    echo "${WARN:-[WARN]} SDDM theme not found at $dir; SDDM background not changed." 2>&1 | tee -a "$log"
    return 1
  fi
  bg_rel=$(sed -nE 's/^[[:space:]]*Background[[:space:]]*=[[:space:]]*"?([^"]*)"?.*/\1/p' "$dir/theme.conf" 2>/dev/null | head -n1)
  if [ -z "$bg_rel" ]; then
    echo "${WARN:-[WARN]} ${dir}/theme.conf has no Background key; SDDM background not changed." 2>&1 | tee -a "$log"
    return 1
  fi

  sudo mkdir -p "$(dirname "$dir/$bg_rel")" || return 1
  if ! sudo cp -f "$src" "$dir/$bg_rel"; then
    echo "${WARN:-[WARN]} Could not write the SDDM background (sudo failed?)." 2>&1 | tee -a "$log"
    return 1
  fi
  # Keep existing .jpg/.png variants of the same name in sync, as sddm_wallpaper.sh does.
  for ext in jpg png; do
    if [ -e "$dir/$bg_rel.$ext" ]; then
      sudo cp -f "$src" "$dir/$bg_rel.$ext"
    fi
  done
  echo "${OK:-[OK]} SDDM background set to $(basename "$src")." 2>&1 | tee -a "$log"
}

# Set the desktop wallpaper from an image file. The current-wallpaper state
# file is what the rest of the setup reads, so it is written the same way
# WallustSwww.sh writes it.
set_fork_desktop_wallpaper() {
  local log="${1:-/dev/null}" src="$2"
  local cfg_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local current="$cfg_home/hypr/wallpaper_effects/.wallpaper_current"
  local rofi_link="$cfg_home/hypr/rofi/.current_wallpaper"

  mkdir -p "$(dirname "$current")" "$(dirname "$rofi_link")" || return 1
  if ! cp -f "$src" "$current"; then
    echo "${WARN:-[WARN]} Could not set the desktop wallpaper." 2>&1 | tee -a "$log"
    return 1
  fi
  ln -snf "$current" "$rofi_link" 2>/dev/null || true
  echo "${OK:-[OK]} Desktop wallpaper set to $(basename "$src")." 2>&1 | tee -a "$log"
}

# Fork defaults on a fresh install: the sun image is the SDDM background and
# the flower bloom is the desktop wallpaper. Images come from the wallpapers
# folder (bank or the fork's own copy).
apply_fork_wallpapers() {
  local log="${1:-/dev/null}" dir="$2"
  local sun="$dir/SunshineOS_Wallpaper.png"
  local flower="$dir/SunshineOS_Flower_Bloom.png"

  if [ ! -f "$sun" ] || [ ! -f "$flower" ]; then
    echo "${WARN:-[WARN]} Default wallpapers not found in $dir; skipping wallpaper defaults." 2>&1 | tee -a "$log"
    return 1
  fi
  set_fork_desktop_wallpaper "$log" "$flower"
  set_fork_sddm_background "$log" "$sun" || true
}
