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
  Un desktop Hyprland preconfigurat, cu un aspect cald, inspirat de soare.
</p>
<p align="center">
  Inițial forkat din LinuxBeginnings/Hyprland-Dots (https://github.com/LinuxBeginnings/Hyprland-Dots.git)
</p>

<div align="center">
<br>
  <a href="#instalare"><kbd> <br> Instalare <br> </kbd></a>&ensp;&ensp;
  <a href="#actualizare"><kbd> <br> Actualizare <br> </kbd></a>&ensp;&ensp;
  <a href="#imagini-de-fundal"><kbd> <br> Imagini de fundal <br> </kbd></a>&ensp;&ensp;
  <a href="#combinatii-de-taste"><kbd> <br> Combinații de taste <br> </kbd></a>&ensp;&ensp;
  <a href="#contribuie"><kbd> <br> Contribuie <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## Ce include

- Configurație Hyprland scrisă în Lua, împărțită în fișiere de sistem și suprascrieri de utilizator
- Waybar, Rofi, overview-ul Quickshell, swaync, wlogout, Hyprlock, Hypridle
- Kitty ca terminal. Este singura fereastră transparentă, prin `background_opacity`.
  Celelalte ferestre sunt complet opace.
- Dolphin ca manager de fișiere
- Fastfetch cu logo-ul SUN și un modul propriu „tracked dates”. Rulează la pornirea unui shell interactiv.
- Schimbarea layout-ului tastaturii pe fereastră, rulând ca serviciu systemd de utilizator
- Tematizare Wallust bazată pe imaginea de fundal a desktopului

### Pachete adăugate de installer

Aceste dotfiles nu instalează Hyprland în sine. Asta fac scripturile de instalare pentru fiecare distribuție.
Installer-ul adaugă apoi aceste pachete:

- `dolphin`: manager de fișiere
- Editorul ales: `vim`, `neovim`, `nano` sau `kate`. `nano` este instalat mereu, ca rezervă.
- `jq` și `socat`: folosite de ascultătorul pentru layout-ul tastaturii pe fereastră

Manageri de pachete suportați: `pacman` (Arch), `apt` (Debian/Ubuntu), `dnf` (Fedora),
`zypper` (openSUSE) și `xbps` (Void).

---

## Instalare

### Instalare dintr-o linie (recomandată)

Ai nevoie de `curl` pentru asta.

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` clonează acest repo în `~/Sunshine_Hyprland_Dots`, citește `/etc/os-release`
și rulează scriptul de instalare pentru distribuția ta din [`distro/`](../../distro/). Fiecare script instalează
pachetele distribuției respective, verifică dacă Hyprland este prezent și apoi rulează `copy.sh`.

| Distribuție | Script de instalare |
| --- | --- |
| Arch Linux (și CachyOS, EndeavourOS, Garuda, Manjaro) | [`distro/arch.sh`](../../distro/arch.sh) |
| Debian (trixie, testing, sid) | [`distro/debian.sh`](../../distro/debian.sh) |
| Ubuntu 24.04 LTS | [`distro/ubuntu-24.04.sh`](../../distro/ubuntu-24.04.sh) |
| Ubuntu 26.04 LTS | [`distro/ubuntu-26.04.sh`](../../distro/ubuntu-26.04.sh) |
| Fedora | [`distro/fedora.sh`](../../distro/fedora.sh) |
| openSUSE Tumbleweed | [`distro/opensuse.sh`](../../distro/opensuse.sh) |
| Void Linux | [`distro/void.sh`](../../distro/void.sh) |
| NixOS | [`distro/nixos.sh`](../../distro/nixos.sh) |

> [!WARNING]
> Doar Arch a fost testat pe acest fork. Celelalte scripturi folosesc nume de pachete pe care nu le-am putut
> verifica pe aceste distribuții. Un nume care nu se rezolvă este raportat la finalul instalării,
> iar tu îl poți instala manual înainte de a rula din nou scriptul.

> [!CAUTION]
> Dacă folosești **fish** ca shell, nu rula comanda dintr-o linie. Clonează repo-ul
> distribuției tale și rulează direct `install.sh` din el.

### Instalare manuală

Dacă ai deja Hyprland instalat sau vrei să alegi singur pașii:

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` pune întrebări pe parcurs: layout-ul tastaturii, rezoluția monitorului, editorul implicit
și dacă să descarce imagini de fundal suplimentare. Rulează la fel pentru o instalare nouă și pentru o actualizare.

> [!NOTE]
> `copy.sh` face copii de rezervă ale directoarelor de configurare pe care urmează să le înlocuiască.
> Verifică-ți `~/.config` pentru aceste copii înainte să le ștergi și păstrează-ți propria copie
> dacă ai o configurație care funcționează. Dacă ai deja o configurație Hyprland, dezinstaleaz-o întâi
> sau instalează într-un cont de utilizator nou.

---

## Actualizare

Rulează din nou `copy.sh` din repo-ul clonat. Detectează instalarea existentă și o actualizează,
păstrând modificările tale (combinații de taste, aplicații la pornire și scripturile proprii). Alegerile de editor
și de imagine de fundal făcute la instalare sunt păstrate.

Pentru a actualiza chiar repo-ul:

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## Valori implicite la instalare

- **Imaginea de fundal a desktopului:** flower bloom
- **Fundalul de login SDDM:** soarele
- **Editor implicit:** cel ales din meniul installer-ului. Kate este setat ca `VISUAL`, iar nano rămâne `EDITOR`.
- **Fastfetch:** rulează la pornirea shell-ului. Intrarea lui „tracked dates” primește data instalării, pe care o poți edita în `~/.config/fastfetch/custom-info.json`.

---

## Imagini de fundal

Installer-ul copiază imaginile din acest repo și îți oferă să descarci colecția de imagini de fundal din
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers).
Colecția este mare, deci descărcarea este opțională. Cele două imagini implicite sunt copiate mereu.

---

## Combinații de taste

Combinațiile de taste sunt definite în configurația Lua. `SUPER + SHIFT + K` deschide o listă căutabilă cu combinațiile active.
Pentru a le modifica, vezi [HOWTO: Schimbarea combinațiilor de taste](../../docs/HOWTO-Change-Keybindgs.md).

---

## Personalizare

Pune modificările tale în `~/.config/hypr/UserConfigs/`. Fișierele de acolo suprascriu valorile implicite
ale sistemului și supraviețuiesc actualizărilor:

- `user_keybinds.lua`, `user_startup.lua`, `user_window_rules.lua`, `user_decorations.lua`, `user_settings.lua`
- `user_defaults.lua`: aplicațiile implicite (manager de fișiere, editor, terminal)
- `kitty.conf`: setările terminalului

Ghidurile sunt în [`docs/`](../../docs/).

---

## Contribuie

Pull request-urile sunt binevenite către `main`. Păstrează modificările concentrate și testează pe distribuția pe care o schimbi.
Vezi [CONTRIBUTING.md](../../CONTRIBUTING.md) și [COMMIT_MESSAGE_GUIDELINES.md](../../COMMIT_MESSAGE_GUIDELINES.md).

---

## Licență

GNU GPLv3. Vezi [LICENSE.md](../../LICENSE.md).
