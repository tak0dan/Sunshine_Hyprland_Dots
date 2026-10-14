#!/usr/bin/env bash
# Sunshine Hyprland Dots: Arch Linux (and derivatives: CachyOS, EndeavourOS, Garuda, Manjaro)
# Package names checked against the official repositories.
# wallust is not in the official repos. It is installed from the AUR, so this script
# makes sure an AUR helper (paru or yay) exists first.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=pacman

if [ "$(id -u)" -eq 0 ]; then
  echo "${ERROR} Run this script as your normal user, not root (makepkg refuses to run as root)."
  exit 1
fi

# Build and install an AUR helper (paru or yay) from the AUR, as the user.
install_aur_helper() {
  local helper="$1" tmp
  echo "${INFO} Installing ${helper} from the AUR..."
  sudo pacman -S --needed --noconfirm git base-devel || return 1
  tmp=$(mktemp -d) || return 1
  if git clone "https://aur.archlinux.org/${helper}.git" "$tmp/$helper" \
     && (cd "$tmp/$helper" && makepkg -si --needed --noconfirm); then
    rm -rf "$tmp"
    command -v "$helper" >/dev/null 2>&1
  else
    rm -rf "$tmp"
    return 1
  fi
}

# Use paru or yay if one is installed. Otherwise ask which to build.
ensure_aur_helper() {
  if command -v paru >/dev/null 2>&1; then AUR_HELPER=paru; return 0; fi
  if command -v yay >/dev/null 2>&1; then AUR_HELPER=yay; return 0; fi

  echo "${NOTE} No AUR helper found. The AUR is needed for wallust."
  echo "  1) paru"
  echo "  2) yay"
  local choice=""
  while true; do
    echo -n "${CAT} Choose the AUR helper to install (1 or 2): "
    read -r choice </dev/tty || choice=""
    case "$choice" in
      1) AUR_HELPER=paru; break ;;
      2) AUR_HELPER=yay; break ;;
      *) echo "${ERROR} Invalid choice. Enter 1 or 2." ;;
    esac
  done

  if ! install_aur_helper "$AUR_HELPER"; then
    echo "${ERROR} Could not install ${AUR_HELPER} from the AUR. Install it by hand and re-run."
    exit 1
  fi
  echo "${OK} ${AUR_HELPER} installed."
}

ensure_aur_helper

# Packages that conflict with the dotfiles' notification and launcher setup
for conflict in mako; do
  if pacman -Qi "$conflict" >/dev/null 2>&1; then
    echo "${NOTE} Removing ${conflict} (conflicts with swaync)."
    sudo pacman -R --noconfirm "$conflict" || true
  fi
done

install_list \
  hyprland hypridle hyprlock hyprsunset hyprpolkitagent hyprland-guiutils \
  kitty rofi swaync awww wlogout quickshell uwsm \
  qt5ct qt6ct qt5-declarative qt5-quickcontrols2 qt6-declarative qt6-svg kvantum kvantum-qt5 \
  cliphist grim slurp swappy wl-clipboard playerctl pamixer pavucontrol libpulse \
  network-manager-applet curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  imagemagick brightnessctl btop cava fastfetch nwg-look nwg-displays nwg-dock-hyprland \
  loupe mpv nvtop gvfs gvfs-mtp ttf-fantasque-nerd dolphin nano yazi lua rsync findutils \
  base-devel inxi libspng python-requests python-pyquery pacman-contrib qalculate-gtk \
  yt-dlp mousepad gnome-system-monitor ddcutil
install_waybar

# wallust comes from the AUR
if ! command -v wallust >/dev/null 2>&1; then
  echo "${INFO} Installing wallust from the AUR with ${AUR_HELPER}..."
  "$AUR_HELPER" -S --needed --noconfirm wallust || echo "${WARN} wallust could not be installed."
fi

finish_install
