#!/usr/bin/env bash
# Sunshine Hyprland Dots: Void Linux
# NOT VERIFIED on Void yet. Package names are from the Void repositories as best known;
# install_list reports any that do not resolve. Hyprland must be installed first.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=xbps

sudo xbps-install -Syu || true

install_list \
  hyprland hypridle hyprlock kitty waybar rofi swaync wlogout \
  qt5ct qt6ct kvantum \
  grim slurp swappy wl-clipboard cliphist playerctl pamixer pavucontrol \
  NetworkManager curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  ImageMagick brightnessctl btop cava fastfetch \
  mpv nvtop dolphin nano yazi lua rsync findutils \
  python3-requests yt-dlp mousepad base-devel

finish_install
