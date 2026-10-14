#!/usr/bin/env bash
# Sunshine Hyprland Dots: Debian (trixie, testing, sid)
# NOT VERIFIED on a Debian system yet. Package names are from the Debian archive as
# best known; install_list reports any name that does not resolve. Hyprland itself
# must be installed first (checked before copy.sh runs).
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=apt

sudo apt-get update || true

install_list \
  hyprland hypridle hyprlock hyprpolkitagent kitty waybar rofi swaync wlogout \
  qt5ct qt6ct kvantum kvantum-qt5 \
  grim slurp swappy wl-clipboard cliphist playerctl pamixer pavucontrol pulseaudio-utils \
  network-manager-gnome curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  imagemagick brightnessctl btop cava fastfetch nwg-look nwg-displays \
  loupe mpv nvtop gvfs gvfs-backends fonts-firacode dolphin nano yazi lua5.4 rsync findutils \
  build-essential python3-requests python3-pyquery yt-dlp mousepad

finish_install
