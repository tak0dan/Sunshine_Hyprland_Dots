#!/usr/bin/env bash
# Sunshine Hyprland Dots: Arch Linux (and derivatives: CachyOS, EndeavourOS, Garuda, Manjaro)
# Package names checked against the official repositories.
# wallust is not in the official repos; it comes from the AUR.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=pacman

# Packages that conflict with the dotfiles' notification and launcher setup
for conflict in mako; do
  if pacman -Qi "$conflict" >/dev/null 2>&1; then
    echo "${NOTE} Removing ${conflict} (conflicts with swaync)."
    sudo pacman -R --noconfirm "$conflict" || true
  fi
done

install_list \
  hyprland hypridle hyprlock hyprsunset hyprpolkitagent hyprland-guiutils \
  kitty waybar rofi swaync awww wlogout quickshell uwsm \
  qt5ct qt6ct qt5-declarative qt5-quickcontrols2 qt6-declarative qt6-svg kvantum kvantum-qt5 \
  cliphist grim slurp swappy wl-clipboard playerctl pamixer pavucontrol libpulse \
  network-manager-applet curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  imagemagick brightnessctl btop cava fastfetch nwg-look nwg-displays nwg-dock-hyprland \
  loupe mpv nvtop gvfs gvfs-mtp ttf-fantasque-nerd dolphin nano yazi lua rsync findutils \
  base-devel inxi libspng python-requests python-pyquery pacman-contrib qalculate-gtk \
  yt-dlp mousepad gnome-system-monitor ddcutil

# wallust from the AUR
if ! command -v wallust >/dev/null 2>&1; then
  if command -v paru >/dev/null 2>&1; then
    paru -S --needed --noconfirm wallust
  elif command -v yay >/dev/null 2>&1; then
    yay -S --needed --noconfirm wallust
  else
    echo "${WARN} wallust is not installed and no AUR helper (paru or yay) was found."
    echo "${WARN} Install wallust from the AUR, then re-run this script."
  fi
fi

finish_install
