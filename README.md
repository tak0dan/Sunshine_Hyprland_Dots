<p align="center">
  <img src="assets/sunshine-icon.png" width="200" alt="Sunshine" />
</p>

<h1 align="center">Sunshine Hyprland Dotfiles</h1>

<p align="center">
  Pre-configured Hyprland desktop with a warm, sun-themed look.
</p>

<div align="center">
<br>
  <a href="#installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
  <a href="#updating"><kbd> <br> Updating <br> </kbd></a>&ensp;&ensp;
  <a href="#wallpapers"><kbd> <br> Wallpapers <br> </kbd></a>&ensp;&ensp;
  <a href="#keybinds"><kbd> <br> Keybinds <br> </kbd></a>&ensp;&ensp;
  <a href="#contributing"><kbd> <br> Contributing <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## What's included

- Hyprland configuration written in Lua, split into system files and user overrides
- Waybar, Rofi, Quickshell overview, swaync, wlogout, Hyprlock, Hypridle
- Kitty as the terminal. It is the only transparent window, through `background_opacity`.
  Other windows are fully opaque.
- Dolphin as the file manager
- Fastfetch with the SUN logo and a custom "tracked dates" module. It runs when an interactive shell starts.
- Per-window keyboard layout switching, running as a systemd user service
- Wallust theming driven by the desktop wallpaper

### Packages the installer adds

These dotfiles do not install Hyprland itself. The per-distro install scripts do that.
The installer adds these packages on top:

- `dolphin`: file manager
- The editor you choose: `vim`, `neovim`, `nano`, or `kate`. `nano` is always installed as the fallback.
- `jq` and `socat`: used by the per-window keyboard layout listener

Supported package managers: `pacman` (Arch), `apt` (Debian/Ubuntu), `dnf` (Fedora),
`zypper` (openSUSE), and `xbps` (Void).

---

## Installation

### One-line install (recommended)

You need `curl` for this.

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` reads `/etc/os-release` and the available package managers, picks the
matching per-distro install script, clones it, and starts its `install.sh`. That script installs
Hyprland and its dependencies, then clones these dotfiles and runs `copy.sh`.

| Distro | Per-distro install script |
| --- | --- |
| Arch Linux (and derivatives) | [Sunshine_Arch_Hyprland](https://github.com/tak0dan/Sunshine_Arch_Hyprland) |
| Debian | [Sunshine_Debian_Hyprland](https://github.com/tak0dan/Sunshine_Debian_Hyprland) |
| Ubuntu 24.04 / 26.04 | [Sunshine_Ubuntu_Hyprland](https://github.com/tak0dan/Sunshine_Ubuntu_Hyprland) (one branch per release) |
| Fedora | [Sunshine_Fedora_Hyprland](https://github.com/tak0dan/Sunshine_Fedora_Hyprland) |
| openSUSE | [Sunshine_OpenSUSE_Hyprland](https://github.com/tak0dan/Sunshine_OpenSUSE_Hyprland) |
| Void Linux | [Sunshine_Void_Hyprland](https://github.com/tak0dan/Sunshine_Void_Hyprland) |
| NixOS | [Sunshine_NixOS_Hyprland](https://github.com/tak0dan/Sunshine_NixOS_Hyprland) |

> [!CAUTION]
> If you use **fish** as your shell, do not run the one-line command. Clone the per-distro repo
> and run its `install.sh` directly.

### Manual install

If you already have Hyprland installed, or want to choose the branch yourself:

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` asks questions as it goes: keyboard layout, monitor resolution, default editor,
and whether to download the extra wallpapers. It runs the same way for a fresh install and an update.

> [!NOTE]
> `copy.sh` backs up any config directories it is about to replace.
> Check your `~/.config` for backups before you delete them, and keep your own backup if
> you have a working setup. If you already have a Hyprland configuration, uninstall it first or
> install into a new user account.

---

## Updating

Run `copy.sh` again from the cloned repo. It detects the existing install and upgrades it,
keeping your own changes (keybinds, startup apps, and your custom scripts). Editor and
wallpaper choices made at install time are kept.

To update the repo itself:

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## Defaults set on install

- **Desktop wallpaper:** the flower bloom
- **SDDM login background:** the sun
- **Default editor:** the one you pick in the installer menu. Kate is set as `VISUAL` and nano stays `EDITOR`.
- **Fastfetch:** runs on shell start. Its tracked-dates entry is filled with the install date, which you can edit in `~/.config/fastfetch/custom-info.json`.

---

## Wallpapers

The installer copies the wallpapers in this repo and offers to download the wallpaper bank from
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers).
The bank is large, so the download is optional. The two default images are always copied.

---

## Keybinds

Keybinds are defined in the Lua config. `SUPER + SHIFT + K` opens a searchable list of the active keybinds.
To change them, see [HOWTO Change Keybinds](docs/HOWTO-Change-Keybindgs.md).

---

## Customizing

Put your own changes in `~/.config/hypr/UserConfigs/`. Files there override the system defaults and
survive updates:

- `user_keybinds.lua`, `user_startup.lua`, `user_window_rules.lua`, `user_decorations.lua`, `user_settings.lua`
- `user_defaults.lua`: default apps (file manager, editor, terminal)
- `kitty.conf`: terminal settings

Guides are in [`docs/`](docs/).

---

## Contributing

Pull requests are welcome against `main`. Keep changes focused, and test on the distro you change.
See [CONTRIBUTING.md](CONTRIBUTING.md) and [COMMIT_MESSAGE_GUIDELINES.md](COMMIT_MESSAGE_GUIDELINES.md).

---

## License

GNU GPLv3. See [LICENSE.md](LICENSE.md).
