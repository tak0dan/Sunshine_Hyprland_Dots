#!/usr/bin/env bash
# Sunshine Hyprland Dots: Ubuntu 24.04 LTS
# NOT VERIFIED on Ubuntu yet. Hyprland is not in the Ubuntu archive for this release:
# install it first (for example from a PPA or a source build), then run this script.
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=apt

sudo apt-get update || true

install_list \
  hypridle hyprlock hyprpolkitagent kitty waybar rofi swaync wlogout \
  qt5ct qt6ct kvantum \
  grim slurp swappy wl-clipboard cliphist playerctl pamixer pavucontrol pulseaudio-utils \
  network-manager-gnome curl wget jq socat bc unzip xdg-user-dirs xdg-utils util-linux yad \
  imagemagick brightnessctl btop cava fastfetch \
  mpv nvtop gvfs gvfs-backends fonts-firacode dolphin nano yazi lua5.4 rsync findutils \
  build-essential python3-requests python3-pyquery yt-dlp mousepad

finish_install
