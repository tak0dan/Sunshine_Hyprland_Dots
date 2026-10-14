#!/usr/bin/env bash
# ==================================================
#  Sunshine Hyprland Dots (2026)
#  Project URL: https://github.com/tak0dan/Sunshine_Hyprland_Dots
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# One-line entry point. Clones this repo, then runs the install script for
# the detected distro from distro/.
#   sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)

REPO_URL="https://github.com/tak0dan/Sunshine_Hyprland_Dots.git"
REPO_DIR="$HOME/Sunshine_Hyprland_Dots"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"

# Detect the distro from /etc/os-release and the available package manager.
# Prints the name of the script in distro/ (without .sh), or nothing.
detect_distro() {
  local id="" id_like="" version=""
  if [ -f /etc/os-release ]; then
    id=$(. /etc/os-release && printf '%s' "${ID:-}")
    id_like=$(. /etc/os-release && printf '%s' "${ID_LIKE:-}")
    version=$(. /etc/os-release && printf '%s' "${VERSION_ID:-}")
  fi

  case " $id $id_like " in
    *" nixos "*) echo nixos; return ;;
    *" arch "*|*" manjaro "*|*" endeavouros "*|*" cachyos "*|*" garuda "*) echo arch; return ;;
    *" ubuntu "*)
      case "$version" in
        24.04) echo ubuntu-24.04 ;;
        26.04) echo ubuntu-26.04 ;;
      esac
      return ;;
    *" debian "*) echo debian; return ;;
    *" fedora "*) echo fedora; return ;;
    *" suse "*|*" opensuse-tumbleweed "*) echo opensuse; return ;;
    *" void "*) echo void; return ;;
  esac

  # Unknown ID: fall back to the package manager that is present.
  if command -v pacman >/dev/null 2>&1; then echo arch
  elif command -v dnf >/dev/null 2>&1; then echo fedora
  elif command -v zypper >/dev/null 2>&1; then echo opensuse
  elif command -v xbps-install >/dev/null 2>&1; then echo void
  elif command -v apt-get >/dev/null 2>&1; then echo debian
  fi
}

# git is needed to clone the repo. Install it with the distro's package manager.
ensure_git() {
  command -v git >/dev/null 2>&1 && return 0
  echo "${INFO} git not found. Installing git..."
  if command -v pacman >/dev/null 2>&1; then sudo pacman -S --needed --noconfirm git
  elif command -v apt-get >/dev/null 2>&1; then sudo apt-get install -y git
  elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y git
  elif command -v zypper >/dev/null 2>&1; then sudo zypper --non-interactive install git
  elif command -v xbps-install >/dev/null 2>&1; then sudo xbps-install -y git
  else
    echo "${ERROR} Could not install git. Install it and re-run."
    exit 1
  fi
}

ensure_git

if [ -d "$REPO_DIR/.git" ]; then
  echo "${INFO} Updating ${REPO_DIR}..."
  git -C "$REPO_DIR" pull --ff-only || echo "${NOTE} Could not fast-forward ${REPO_DIR}; using the existing checkout."
else
  echo "${INFO} Cloning ${REPO_URL} into ${REPO_DIR}..."
  git clone --depth=1 "$REPO_URL" "$REPO_DIR" || { echo "${ERROR} Clone failed."; exit 1; }
fi

distro=$(detect_distro)
if [ -z "$distro" ] || [ ! -f "$REPO_DIR/distro/$distro.sh" ]; then
  echo "${ERROR} Unsupported system. Supported:"
  echo "  arch, debian, ubuntu-24.04, ubuntu-26.04, fedora, opensuse, void, nixos"
  echo "  Scripts are in $REPO_DIR/distro/"
  exit 1
fi

echo "${OK} Detected ${distro}. Running distro/${distro}.sh"
chmod +x "$REPO_DIR/distro/$distro.sh"
exec bash "$REPO_DIR/distro/$distro.sh"
