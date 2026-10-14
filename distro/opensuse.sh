#!/usr/bin/env bash
# Sunshine Hyprland Dots: openSUSE Tumbleweed
# NOT VERIFIED on openSUSE yet. Package names are from the Tumbleweed repositories as best
# known; install_list reports any that do not resolve.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=zypper

install_list \
  hyprland hypridle hyprlock hyprpolkitagent hyprsunset \
  kitty rofi swaync wlogout awww \
  qt5ct qt6ct kvantum \
  grim slurp swappy wl-clipboard cliphist playerctl pamixer pavucontrol \
  NetworkManager-applet curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  ImageMagick brightnessctl btop cava fastfetch nwg-look nwg-displays \
  mpv nvtop gvfs gvfs-fuse dolphin nano yazi lua rsync findutils \
  python3-requests python3-pyquery yt-dlp mousepad
install_waybar

finish_install
