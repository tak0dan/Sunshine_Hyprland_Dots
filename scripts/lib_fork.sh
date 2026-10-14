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
