#!/usr/bin/env bash
# ==================================================
#  Sunshine Hyprland Dots (2026)
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Shared helpers for the per-distro install scripts in distro/.
# Each distro script sets PKG_MANAGER, lists its packages, and calls
# finish_install, which checks for Hyprland and then runs copy.sh.

DISTRO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$DISTRO_DIR/.." && pwd)"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 1)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
RESET="$(tput sgr0)"

# Install one or more packages with the distro's package manager.
pkg_install() {
  case "$PKG_MANAGER" in
    pacman) sudo pacman -S --needed --noconfirm "$@" ;;
    apt)    sudo apt-get install -y "$@" ;;
    dnf)    sudo dnf install -y "$@" ;;
    zypper) sudo zypper --non-interactive install --no-recommends "$@" ;;
    xbps)   sudo xbps-install -y "$@" ;;
    *)      echo "${ERROR} No package manager set." >&2; return 1 ;;
  esac
}

# Install a list. If the batch fails, retry each package on its own so one
# missing name does not stop the rest, and report the packages that failed.
install_list() {
  local failed=() pkg
  echo "${INFO} Installing $# packages with ${PKG_MANAGER}..."
  if ! pkg_install "$@"; then
    echo "${NOTE} Batch install failed; retrying packages one by one."
    for pkg in "$@"; do
      pkg_install "$pkg" || failed+=("$pkg")
    done
  fi
  if [ "${#failed[@]}" -gt 0 ]; then
    echo "${WARN} Could not install: ${failed[*]}"
    echo "${WARN} Check the package names for this release, install them by hand, then re-run."
  fi
}

# Is a package available from the distro's configured repositories?
pkg_in_repos() {
  case "$PKG_MANAGER" in
    pacman) pacman -Si "$1" >/dev/null 2>&1 ;;
    apt)    [ -n "$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/ && $2 != "(none)" {print $2}')" ] ;;
    dnf)    dnf -q list --available "$1" >/dev/null 2>&1 || dnf -q list --installed "$1" >/dev/null 2>&1 ;;
    zypper) zypper --non-interactive --quiet search --match-exact "$1" >/dev/null 2>&1 ;;
    xbps)   xbps-query -R "$1" >/dev/null 2>&1 ;;
    *)      return 1 ;;
  esac
}

# Waybar: prefer waybar-git when the repositories carry it. Releases up to
# 0.15.0 send hyprlang dispatchers on a workspace click, which Hyprland's Lua
# config rejects; the git build speaks Lua. Fall back to the release package.
install_waybar() {
  if pkg_in_repos waybar-git; then
    echo "${INFO} Installing waybar-git..."
    if [ "$PKG_MANAGER" = pacman ]; then
      # --ask 4 accepts replacing the conflicting waybar package.
      sudo pacman -S --needed --noconfirm --ask 4 waybar-git && return 0
    else
      pkg_install waybar-git && return 0
    fi
    echo "${WARN} waybar-git could not be installed; installing waybar instead."
  else
    echo "${NOTE} waybar-git is not in this distro's repositories; installing waybar."
  fi
  pkg_install waybar || echo "${WARN} Could not install waybar. Install it by hand, then re-run."
}

# Hyprland itself is not installed by copy.sh. Stop here if it is missing.
check_hyprland() {
  if ! command -v Hyprland >/dev/null 2>&1 && ! command -v hyprland >/dev/null 2>&1; then
    echo "${ERROR} Hyprland is not installed. Install it for this distro, then re-run this script."
    exit 1
  fi
}

# Hand over to copy.sh, which copies the dotfiles and installs the fork's
# extra packages (Dolphin, editor, jq, socat).
finish_install() {
  check_hyprland
  cd "$REPO_DIR" || exit 1
  echo "${OK} Packages done. Running copy.sh..."
  bash ./copy.sh
}
