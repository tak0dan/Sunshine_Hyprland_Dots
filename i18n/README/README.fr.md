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
  Un bureau Hyprland préconfiguré, à l'allure chaude et solaire.
</p>
<p align="center">
  Initialement forké depuis LinuxBeginnings/Hyprland-Dots (https://github.com/LinuxBeginnings/Hyprland-Dots.git)
</p>

<div align="center">
<br>
  <a href="#installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;
  <a href="#mise-à-jour"><kbd> <br> Mise à jour <br> </kbd></a>&ensp;&ensp;
  <a href="#fonds-decran"><kbd> <br> Fonds d'écran <br> </kbd></a>&ensp;&ensp;
  <a href="#raccourcis-clavier"><kbd> <br> Raccourcis <br> </kbd></a>&ensp;&ensp;
  <a href="#contribuer"><kbd> <br> Contribuer <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## Contenu

- Configuration Hyprland en Lua, séparée en fichiers système et en surcharges utilisateur
- Waybar, Rofi, vue d'ensemble Quickshell, swaync, wlogout, Hyprlock, Hypridle
- Kitty comme terminal. C'est la seule fenêtre transparente, grâce à `background_opacity`.
  Les autres fenêtres sont entièrement opaques.
- Dolphin comme gestionnaire de fichiers
- Fastfetch avec le logo SUN et un module personnalisé « tracked dates ». Il se lance au démarrage d'un shell interactif.
- Changement de disposition clavier par fenêtre, exécuté comme service utilisateur systemd
- Thème Wallust piloté par le fond d'écran du bureau

### Paquets ajoutés par l'installateur

Ces dotfiles n'installent pas Hyprland lui-même. Ce sont les scripts d'installation par distribution qui s'en chargent.
L'installateur ajoute ensuite ces paquets :

- `dolphin` : gestionnaire de fichiers
- L'éditeur que vous choisissez : `vim`, `neovim`, `nano` ou `kate`. `nano` est toujours installé en secours.
- `jq` et `socat` : utilisés par l'écouteur de disposition clavier par fenêtre

Gestionnaires de paquets pris en charge : `pacman` (Arch), `apt` (Debian/Ubuntu), `dnf` (Fedora),
`zypper` (openSUSE) et `xbps` (Void).

---

## Installation

### Installation en une commande (recommandée)

Vous avez besoin de `curl` pour cela.

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` clone ce dépôt dans `~/Sunshine_Hyprland_Dots`, lit `/etc/os-release`,
puis lance le script d'installation de votre distribution depuis [`distro/`](../../distro/). Chaque script installe
les paquets de sa distribution, vérifie la présence de Hyprland, puis lance `copy.sh`.

| Distribution | Script d'installation |
| --- | --- |
| Arch Linux (et CachyOS, EndeavourOS, Garuda, Manjaro) | [`distro/arch.sh`](../../distro/arch.sh) |
| Debian (trixie, testing, sid) | [`distro/debian.sh`](../../distro/debian.sh) |
| Ubuntu 24.04 LTS | [`distro/ubuntu-24.04.sh`](../../distro/ubuntu-24.04.sh) |
| Ubuntu 26.04 LTS | [`distro/ubuntu-26.04.sh`](../../distro/ubuntu-26.04.sh) |
| Fedora | [`distro/fedora.sh`](../../distro/fedora.sh) |
| openSUSE Tumbleweed | [`distro/opensuse.sh`](../../distro/opensuse.sh) |
| Void Linux | [`distro/void.sh`](../../distro/void.sh) |
| NixOS | [`distro/nixos.sh`](../../distro/nixos.sh) |

> [!WARNING]
> Seul Arch a été testé pour ce fork. Les autres scripts utilisent des noms de paquets que je n'ai pas pu
> vérifier sur ces distributions. Un nom qui ne se résout pas est signalé à la fin de l'installation,
> et vous pouvez l'installer à la main avant de relancer le script.

> [!CAUTION]
> Si vous utilisez **fish** comme shell, n'exécutez pas la commande en une ligne. Clonez le dépôt
> de votre distribution et lancez directement son `install.sh`.

### Installation manuelle

Si Hyprland est déjà installé, ou si vous voulez choisir la démarche vous-même :

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` pose des questions pendant l'installation : disposition du clavier, résolution de l'écran, éditeur par défaut
et téléchargement des fonds d'écran supplémentaires. Le fonctionnement est le même pour une installation neuve et une mise à jour.

> [!NOTE]
> `copy.sh` crée des sauvegardes des dossiers de configuration qu'il va remplacer.
> Vérifiez votre `~/.config` pour ces sauvegardes avant de les supprimer, et gardez votre propre copie
> si vous avez une configuration qui fonctionne. Si vous avez déjà une configuration Hyprland, désinstallez-la
> d'abord ou installez dans un nouveau compte utilisateur.

---

## Mise à jour

Relancez `copy.sh` depuis le dépôt cloné. Il détecte l'installation existante et la met à jour
en conservant vos modifications (raccourcis, applications au démarrage et scripts personnels). Les choix d'éditeur
et de fond d'écran faits à l'installation sont conservés.

Pour mettre à jour le dépôt lui-même :

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## Valeurs définies à l'installation

- **Fond d'écran du bureau :** la fleur (flower bloom)
- **Fond de connexion SDDM :** le soleil
- **Éditeur par défaut :** celui choisi dans le menu de l'installateur. Kate est défini comme `VISUAL` et nano reste `EDITOR`.
- **Fastfetch :** se lance au démarrage du shell. Son entrée « tracked dates » est remplie avec la date d'installation, modifiable dans `~/.config/fastfetch/custom-info.json`.

---

## Fonds d'écran

L'installateur copie les fonds d'écran de ce dépôt et propose de télécharger la collection de fonds d'écran depuis
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers).
La collection est volumineuse, le téléchargement est donc facultatif. Les deux images par défaut sont toujours copiées.

---

## Raccourcis clavier

Les raccourcis sont définis dans la configuration Lua. `SUPER + SHIFT + K` ouvre une liste consultable des raccourcis actifs.
Pour les modifier, voir [HOWTO : modifier les raccourcis](../../docs/HOWTO-Change-Keybindgs.md).

---

## Personnalisation

Placez vos modifications dans `~/.config/hypr/UserConfigs/`. Les fichiers qui s'y trouvent remplacent les valeurs
par défaut du système et sont conservés lors des mises à jour :

- `user_keybinds.lua`, `user_startup.lua`, `user_window_rules.lua`, `user_decorations.lua`, `user_settings.lua`
- `user_defaults.lua` : applications par défaut (gestionnaire de fichiers, éditeur, terminal)
- `kitty.conf` : réglages du terminal

Les guides sont dans [`docs/`](../../docs/).

---

## Contribuer

Les pull requests sont les bienvenues vers `main`. Gardez les changements ciblés et testez sur la distribution que vous modifiez.
Voir [CONTRIBUTING.md](../../CONTRIBUTING.md) et [COMMIT_MESSAGE_GUIDELINES.md](../../COMMIT_MESSAGE_GUIDELINES.md).

---

## Licence

GNU GPLv3. Voir [LICENSE.md](../../LICENSE.md).
