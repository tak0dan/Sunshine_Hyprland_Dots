#!/usr/bin/env bash
# Sunshine Hyprland Dots: Fedora (43 and later)
# NOT VERIFIED on Fedora yet. Some names (awww, hyprlock, hyprpolkitagent) may live in
# COPR repositories rather than the main repos; install_list reports any that do not resolve.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=dnf

install_list \
  hyprland hypridle hyprlock hyprsunset hyprpolkitagent \
  kitty rofi-wayland swaync wlogout awww \
  qt5ct qt6ct qt6-qtsvg kvantum \
  grim slurp swappy wl-clipboard cliphist playerctl pamixer pavucontrol pulseaudio-libs \
  NetworkManager-applet curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  ImageMagick brightnessctl btop cava fastfetch nwg-look nwg-displays \
  loupe mpv nvtop gvfs gvfs-mtp google-noto-sans-mono-fonts dolphin nano yazi lua rsync findutils \
  @development-tools python3-requests python3-pyquery yt-dlp mousepad
install_waybar

finish_install
