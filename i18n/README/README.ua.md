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
  Готовий робочий стіл Hyprland з теплим сонячним виглядом.
</p>
<p align="center">
  Початково форк LinuxBeginnings/Hyprland-Dots (https://github.com/LinuxBeginnings/Hyprland-Dots.git)
</p>

<div align="center">
<br>
  <a href="#встановлення"><kbd> <br> Встановлення <br> </kbd></a>&ensp;&ensp;
  <a href="#оновлення"><kbd> <br> Оновлення <br> </kbd></a>&ensp;&ensp;
  <a href="#шпалери"><kbd> <br> Шпалери <br> </kbd></a>&ensp;&ensp;
  <a href="#комбінації-клавіш"><kbd> <br> Комбінації клавіш <br> </kbd></a>&ensp;&ensp;
  <a href="#внесок"><kbd> <br> Внесок <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## Що входить

- Конфігурація Hyprland на Lua, поділена на системні файли та перевизначення користувача
- Waybar, Rofi, огляд Quickshell, swaync, wlogout, Hyprlock, Hypridle
- Kitty як термінал. Це єдине прозоре вікно, через `background_opacity`.
  Усі інші вікна повністю непрозорі.
- Dolphin як файловий менеджер
- Fastfetch із логотипом SUN та власним модулем «tracked dates». Запускається при старті інтерактивної оболонки.
- Перемикання розкладки клавіатури для кожного вікна, працює як користувацька служба systemd
- Тематизація Wallust, яка залежить від шпалер робочого столу

### Пакети, які додає інсталятор

Ці dotfiles не встановлюють самий Hyprland. Це роблять скрипти встановлення для кожного дистрибутива.
Інсталятор додає ще такі пакети:

- `dolphin`: файловий менеджер
- Обраний редактор: `vim`, `neovim`, `nano` або `kate`. `nano` завжди встановлюється як запасний варіант.
- `jq` та `socat`: використовуються слухачем розкладки клавіатури для кожного вікна

Підтримувані менеджери пакетів: `pacman` (Arch), `apt` (Debian/Ubuntu), `dnf` (Fedora),
`zypper` (openSUSE) та `xbps` (Void).

---

## Встановлення

### Встановлення однім рядком (рекомендовано)

Для цього потрібен `curl`.

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` клонує цей репозиторій у `~/Sunshine_Hyprland_Dots`, читає `/etc/os-release`
і запускає скрипт встановлення для вашого дистрибутива з [`distro/`](../../distro/). Кожен скрипт встановлює
пакети цього дистрибутива, перевіряє наявність Hyprland і потім запускає `copy.sh`.

| Дистрибутив | Скрипт встановлення |
| --- | --- |
| Arch Linux (і CachyOS, EndeavourOS, Garuda, Manjaro) | [`distro/arch.sh`](../../distro/arch.sh) |
| Debian (trixie, testing, sid) | [`distro/debian.sh`](../../distro/debian.sh) |
| Ubuntu 24.04 LTS | [`distro/ubuntu-24.04.sh`](../../distro/ubuntu-24.04.sh) |
| Ubuntu 26.04 LTS | [`distro/ubuntu-26.04.sh`](../../distro/ubuntu-26.04.sh) |
| Fedora | [`distro/fedora.sh`](../../distro/fedora.sh) |
| openSUSE Tumbleweed | [`distro/opensuse.sh`](../../distro/opensuse.sh) |
| Void Linux | [`distro/void.sh`](../../distro/void.sh) |
| NixOS | [`distro/nixos.sh`](../../distro/nixos.sh) |

> [!WARNING]
> Для цього форку перевірено лише Arch. Інші скрипти використовують назви пакетів, які я не зміг
> перевірити на цих дистрибутивах. Назва, яку не вдалося знайти, буде вказана наприкінці встановлення.
> Тоді її можна встановити вручну й запустити скрипт ще раз.

> [!CAUTION]
> Якщо ви користуєтеся **fish** як оболонкою, не запускайте команду в один рядок. Натомість клонуйте
> репозиторій вашого дистрибутива та запустіть його `install.sh` напряму.

### Ручне встановлення

Якщо Hyprland уже встановлено або ви хочете самі обрати кроки:

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` ставить запитання під час роботи: розкладка клавіатури, роздільна здатність монітора, редактор за замовчуванням
та чи завантажувати додаткові шпалери. Для нового встановлення і для оновлення він працює однаково.

> [!NOTE]
> `copy.sh` створює резервні копії тек конфігурації, які збирається замінити.
> Перевірте `~/.config` на наявність цих копій, перш ніж їх видаляти, і зробіть власну резервну копію,
> якщо у вас працює налаштована система. Якщо Hyprland уже налаштовано, спочатку видаліть його
> або встановлюйте в новому обліковому записі користувача.

---

## Оновлення

Запустіть `copy.sh` ще раз із клонованого репозиторію. Він визначає наявне встановлення і оновлює його,
зберігаючи ваші зміни (комбінації клавіш, програми автозапуску та власні скрипти). Вибір редактора
та шпалер, зроблений під час встановлення, зберігається.

Щоб оновити сам репозиторій:

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## Значення за замовчуванням під час встановлення

- **Шпалери робочого столу:** flower bloom
- **Фон входу SDDM:** сонце
- **Редактор за замовчуванням:** обраний у меню інсталятора. Kate встановлюється як `VISUAL`, а nano залишається `EDITOR`.
- **Fastfetch:** запускається при старті оболонки. Його запис «tracked dates» отримує дату встановлення, яку можна змінити в `~/.config/fastfetch/custom-info.json`.

---

## Шпалери

Інсталятор копіює шпалери з цього репозиторію і пропонує завантажити колекцію шпалер з
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers).
Колекція велика, тому завантаження необов'язкове. Два типові зображення копіюються завжди.

---

## Комбінації клавіш

Комбінації клавіш визначено в конфігурації Lua. `SUPER + SHIFT + K` відкриває список активних комбінацій із пошуком.
Щоб їх змінити, дивіться [HOWTO: зміна комбінацій клавіш](../../docs/HOWTO-Change-Keybindgs.md).

---

## Налаштування

Розміщуйте свої зміни в `~/.config/hypr/UserConfigs/`. Файли там перевизначають системні значення за замовчуванням
і зберігаються під час оновлень:

- `user_keybinds.lua`, `user_startup.lua`, `user_window_rules.lua`, `user_decorations.lua`, `user_settings.lua`
- `user_defaults.lua`: програми за замовчуванням (файловий менеджер, редактор, термінал)
- `kitty.conf`: налаштування терміналу

Посібники є в [`docs/`](../../docs/).

---

## Внесок

Pull request-и вітаються в гілку `main`. Тримайте зміни сфокусованими та тестуйте на дистрибутиві, який змінюєте.
Дивіться [CONTRIBUTING.md](../../CONTRIBUTING.md) і [COMMIT_MESSAGE_GUIDELINES.md](../../COMMIT_MESSAGE_GUIDELINES.md).

---

## Ліцензія

GNU GPLv3. Дивіться [LICENSE.md](../../LICENSE.md).
