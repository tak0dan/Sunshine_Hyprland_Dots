#!/usr/bin/env bash
# Sunshine Hyprland Dots: NixOS
# Packages on NixOS are declared in configuration.nix, not installed with a package manager.
# This script checks Hyprland and then runs copy.sh. Add the following to your
# configuration.nix, run `sudo nixos-rebuild switch`, and re-run this script:
#
#   programs.hyprland.enable = true;
#   environment.systemPackages = with pkgs; [ kitty waybar rofi swaync wlogout dolphin jq socat ];
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
PKG_MANAGER=""
finish_install
