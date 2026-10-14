[![en](https://img.shields.io/badge/lang-en-yellow.svg)](../../README.md)
[![de](https://img.shields.io/badge/lang-de-magenta.svg)](./README.de.md)
[![fr](https://img.shields.io/badge/lang-fr-cyan.svg)](./README.fr.md)
[![jp](https://img.shields.io/badge/lang-jp-blue.svg)](./README.jp.md)
[![ro](https://img.shields.io/badge/lang-ro-green.svg)](./README.ro.md)
[![ua](https://img.shields.io/badge/lang-ua-white.svg)](./README.ua.md)
[![ru](https://img.shields.io/badge/lang-ru-red.svg)](./README.ru.md)

<p align="center">
  <img src="../../assets/sunshine-icon.png" width="200" alt="Sunshine" />
</p>

<h1 align="center">Sunshine Hyprland Dotfiles</h1>

<p align="center">
  Vorkonfigurierter Hyprland-Desktop mit einem warmen, sonnigen Look.
</p>
<p align="center">
  Ursprünglich geforkt von LinuxBeginnings/Hyprland-Dots (https://github.com/LinuxBeginnings/Hyprland-Dots.git)
</p>

<div align="center">
<br>
  <a href="#installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
  <a href="#aktualisieren"><kbd> <br> Aktualisieren <br> </kbd></a>&ensp;&ensp;
  <a href="#hintergrundbilder"><kbd> <br> Hintergrundbilder <br> </kbd></a>&ensp;&ensp;
  <a href="#tastenkombinationen"><kbd> <br> Tastenkombinationen <br> </kbd></a>&ensp;&ensp;
  <a href="#mitwirken"><kbd> <br> Mitwirken <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## Enthalten

- Hyprland-Konfiguration in Lua, aufgeteilt in Systemdateien und Benutzer-Overrides
- Waybar, Rofi, Quickshell-Übersicht, swaync, wlogout, Hyprlock, Hypridle
- Kitty als Terminal. Es ist das einzige transparente Fenster, über `background_opacity`.
  Alle anderen Fenster sind vollständig undurchsichtig.
- Dolphin als Dateimanager
- Fastfetch mit dem SUN-Logo und einem eigenen Modul für "Tracked Dates". Es startet, wenn eine interaktive Shell startet.
- Tastaturlayout-Wechsel pro Fenster, läuft als systemd-Benutzerdienst
- Wallust-Farbgebung, gesteuert vom Desktop-Hintergrundbild

### Pakete, die der Installer hinzufügt

Diese Dotfiles installieren Hyprland nicht selbst. Das übernehmen die Install-Skripte pro Distribution.
Der Installer fügt diese Pakete zusätzlich hinzu:

- `dolphin`: Dateimanager
- Den gewählten Editor: `vim`, `neovim`, `nano` oder `kate`. `nano` wird immer als Ausweichlösung installiert.
- `jq` und `socat`: werden vom Listener für das Tastaturlayout pro Fenster benötigt

Unterstützte Paketmanager: `pacman` (Arch), `apt` (Debian/Ubuntu), `dnf` (Fedora),
`zypper` (openSUSE) und `xbps` (Void).

---

## Installation

### Installation mit einer Zeile (empfohlen)

Dafür brauchst du `curl`.

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` klont dieses Repo nach `~/Sunshine_Hyprland_Dots`, liest `/etc/os-release`
und startet das Install-Skript für deine Distribution aus [`distro/`](../../distro/). Jedes Skript installiert
die Pakete dieser Distribution, prüft, ob Hyprland vorhanden ist, und führt dann `copy.sh` aus.

| Distribution | Install-Skript |
| --- | --- |
| Arch Linux (und CachyOS, EndeavourOS, Garuda, Manjaro) | [`distro/arch.sh`](../../distro/arch.sh) |
| Debian (trixie, testing, sid) | [`distro/debian.sh`](../../distro/debian.sh) |
| Ubuntu 24.04 LTS | [`distro/ubuntu-24.04.sh`](../../distro/ubuntu-24.04.sh) |
| Ubuntu 26.04 LTS | [`distro/ubuntu-26.04.sh`](../../distro/ubuntu-26.04.sh) |
| Fedora | [`distro/fedora.sh`](../../distro/fedora.sh) |
| openSUSE Tumbleweed | [`distro/opensuse.sh`](../../distro/opensuse.sh) |
| Void Linux | [`distro/void.sh`](../../distro/void.sh) |
| NixOS | [`distro/nixos.sh`](../../distro/nixos.sh) |

> [!WARNING]
> Bisher wurde nur Arch auf diesem Fork getestet. Die anderen Skripte verwenden Paketnamen, die ich auf
> diesen Distributionen nicht prüfen konnte. Ein Name, der nicht aufgelöst werden kann, wird am Ende der
> Installation gemeldet. Du kannst ihn dann von Hand installieren und das Skript erneut ausführen.

> [!CAUTION]
> Wenn du **fish** als Shell verwendest, führe den Einzeiler nicht aus. Klone stattdessen das Repo
> deiner Distribution und führe dessen `install.sh` direkt aus.

### Manuelle Installation

Wenn Hyprland schon installiert ist oder du den Ablauf selbst steuern willst:

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` stellt während der Installation Fragen: Tastaturlayout, Monitorauflösung, Standard-Editor
und ob zusätzliche Hintergrundbilder geladen werden sollen. Der Ablauf ist bei einer Neuinstallation und einem Update gleich.

> [!NOTE]
> `copy.sh` erstellt Sicherungen aller Konfigurationsordner, die es ersetzen wird.
> Prüfe deinen `~/.config` auf diese Sicherungen, bevor du sie löschst, und behalte eine eigene
> Sicherung, wenn du ein funktionierendes Setup hast. Wenn du bereits eine Hyprland-Konfiguration hast,
> deinstalliere sie zuerst oder installiere in einem neuen Benutzerkonto.

---

## Aktualisieren

Führe `copy.sh` im geklonten Repo erneut aus. Es erkennt die bestehende Installation und aktualisiert sie
und behält deine eigenen Änderungen (Tastenkombinationen, Autostart-Apps und eigene Skripte). Editor- und
Hintergrundbild-Auswahl aus der Installation bleiben erhalten.

Um das Repo selbst zu aktualisieren:

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## Standards bei der Installation

- **Desktop-Hintergrundbild:** die Flower-Bloom-Grafik
- **SDDM-Anmeldehintergrund:** die Sonne
- **Standard-Editor:** der, den du im Installer-Menü wählst. Kate wird als `VISUAL` gesetzt, nano bleibt `EDITOR`.
- **Fastfetch:** startet beim Start der Shell. Sein Eintrag für "Tracked Dates" wird mit dem Installationsdatum gefüllt. Du kannst ihn in `~/.config/fastfetch/custom-info.json` ändern.

---

## Hintergrundbilder

Der Installer kopiert die Hintergrundbilder aus diesem Repo und bietet an, die Hintergrundbilder-Sammlung von
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers) herunterzuladen.
Die Sammlung ist groß, deshalb ist der Download optional. Die beiden Standardbilder werden immer kopiert.

---

## Tastenkombinationen

Tastenkombinationen sind in der Lua-Konfiguration definiert. `SUPER + SHIFT + K` öffnet eine durchsuchbare Liste der aktiven Tastenkombinationen.
Zum Ändern siehe [HOWTO: Tastenkombinationen ändern](../../docs/HOWTO-Change-Keybindgs.md).

---

## Anpassen

Lege eigene Änderungen in `~/.config/hypr/UserConfigs/` ab. Dateien dort überschreiben die Standardwerte
und bleiben bei Updates erhalten:

- `user_keybinds.lua`, `user_startup.lua`, `user_window_rules.lua`, `user_decorations.lua`, `user_settings.lua`
- `user_defaults.lua`: Standard-Apps (Dateimanager, Editor, Terminal)
- `kitty.conf`: Terminal-Einstellungen

Anleitungen findest du im Ordner [`docs/`](../../docs/).

---

## Mitwirken

Pull Requests sind willkommen und gehen an `main`. Halte Änderungen fokussiert und teste auf der Distribution, die du änderst.
Siehe [CONTRIBUTING.md](../../CONTRIBUTING.md) und [COMMIT_MESSAGE_GUIDELINES.md](../../COMMIT_MESSAGE_GUIDELINES.md).

---

## Lizenz

GNU GPLv3. Siehe [LICENSE.md](../../LICENSE.md).
