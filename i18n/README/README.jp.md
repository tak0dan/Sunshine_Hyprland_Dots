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
  温かみのある太陽テーマの、設定済み Hyprland デスクトップ。
</p>
<p align="center">
  元は LinuxBeginnings/Hyprland-Dots (https://github.com/LinuxBeginnings/Hyprland-Dots.git) からフォークしました。
</p>

<div align="center">
<br>
  <a href="#インストール"><kbd> <br> インストール <br> </kbd></a>&ensp;&ensp;
  <a href="#更新"><kbd> <br> 更新 <br> </kbd></a>&ensp;&ensp;
  <a href="#壁紙"><kbd> <br> 壁紙 <br> </kbd></a>&ensp;&ensp;
  <a href="#キーバインド"><kbd> <br> キーバインド <br> </kbd></a>&ensp;&ensp;
  <a href="#コントリビュート"><kbd> <br> コントリビュート <br> </kbd></a>&ensp;&ensp;
</div><br>

---

## 含まれるもの

- Lua で書かれた Hyprland 設定。システム用ファイルとユーザー用の上書き設定に分かれています
- Waybar、Rofi、Quickshell のオーバービュー、swaync、wlogout、Hyprlock、Hypridle
- ターミナルは Kitty。`background_opacity` によって、透明になるのは Kitty のウィンドウだけです。
  他のウィンドウは完全に不透明です。
- ファイルマネージャーは Dolphin
- SUN ロゴと独自の「tracked dates」モジュールを含む Fastfetch。対話型シェルの起動時に実行されます。
- ウィンドウごとのキーボードレイアウト切り替え。systemd のユーザーサービスとして動作します
- デスクトップの壁紙に基づく Wallust のテーマ設定

### インストーラーが追加するパッケージ

これらのドットファイルは Hyprland 自体をインストールしません。それは各ディストリビューション用のインストールスクリプトが行います。
インストーラーは以下のパッケージを追加します。

- `dolphin`：ファイルマネージャー
- 選択したエディター：`vim`、`neovim`、`nano`、`kate` のいずれか。`nano` は予備として常にインストールされます。
- `jq` と `socat`：ウィンドウごとのキーボードレイアウト監視で使用します

対応パッケージマネージャー：`pacman`（Arch）、`apt`（Debian/Ubuntu）、`dnf`（Fedora）、
`zypper`（openSUSE）、`xbps`（Void）。

---

## インストール

### ワンラインインストール（推奨）

`curl` が必要です。

```bash
sh <(curl -L https://raw.githubusercontent.com/tak0dan/Sunshine_Hyprland_Dots/main/Distro-Hyprland.sh)
```

`Distro-Hyprland.sh` はこのリポジトリを `~/Sunshine_Hyprland_Dots` にクローンし、`/etc/os-release` を読み取って、
お使いのディストリビューション用のインストールスクリプトを [`distro/`](../../distro/) から実行します。各スクリプトは
そのディストリビューションのパッケージをインストールし、Hyprland があることを確認してから `copy.sh` を実行します。

| ディストリビューション | インストールスクリプト |
| --- | --- |
| Arch Linux（CachyOS、EndeavourOS、Garuda、Manjaro を含む） | [`distro/arch.sh`](../../distro/arch.sh) |
| Debian（trixie、testing、sid） | [`distro/debian.sh`](../../distro/debian.sh) |
| Ubuntu 24.04 LTS | [`distro/ubuntu-24.04.sh`](../../distro/ubuntu-24.04.sh) |
| Ubuntu 26.04 LTS | [`distro/ubuntu-26.04.sh`](../../distro/ubuntu-26.04.sh) |
| Fedora | [`distro/fedora.sh`](../../distro/fedora.sh) |
| openSUSE Tumbleweed | [`distro/opensuse.sh`](../../distro/opensuse.sh) |
| Void Linux | [`distro/void.sh`](../../distro/void.sh) |
| NixOS | [`distro/nixos.sh`](../../distro/nixos.sh) |

> [!WARNING]
> このフォークで動作確認が済んでいるのは Arch のみです。それ以外のスクリプトは、私が各ディストリビューションで
> 確認できなかったパッケージ名を使っています。解決できない名前はインストールの最後に報告されます。
> その場合は手動でインストールしてから、スクリプトを再実行してください。

> [!CAUTION]
> シェルに **fish** を使っている場合は、ワンラインコマンドを実行しないでください。代わりに、
> ディストリビューション用のリポジトリをクローンして、その `install.sh` を直接実行してください。

### 手動インストール

Hyprland がすでにインストールされている場合や、手順を自分で選びたい場合：

```bash
git clone --depth=1 https://github.com/tak0dan/Sunshine_Hyprland_Dots.git && cd Sunshine_Hyprland_Dots
chmod +x copy.sh
./copy.sh
```

`copy.sh` は途中でいくつか質問します：キーボードレイアウト、モニターの解像度、既定のエディター、
追加の壁紙をダウンロードするかどうか。新規インストールでも更新でも、流れは同じです。

> [!NOTE]
> `copy.sh` は置き換える予定の設定ディレクトリをバックアップします。
> 削除する前に `~/.config` のバックアップを確認してください。動作している環境がある場合は、
> 自分でもバックアップを取っておいてください。すでに Hyprland の設定がある場合は、先にアンインストールするか、
> 新しいユーザーアカウントにインストールしてください。

---

## 更新

クローンしたリポジトリで `copy.sh` をもう一度実行します。既存のインストールを検出して更新し、
キーバインド、スタートアップアプリ、独自スクリプトなど、あなたの変更は保持されます。インストール時に選んだエディターと
壁紙も保持されます。

リポジトリ自体を更新するには：

```bash
cd Sunshine_Hyprland_Dots && git pull && ./copy.sh
```

---

## インストール時の既定値

- **デスクトップの壁紙：** flower bloom
- **SDDM のログイン背景：** 太陽
- **既定のエディター：** インストーラーのメニューで選んだもの。Kate は `VISUAL` に設定され、nano は `EDITOR` のままです。
- **Fastfetch：** シェル起動時に実行されます。その「tracked dates」の項目にはインストール日が入ります。内容は `~/.config/fastfetch/custom-info.json` で編集できます。

---

## 壁紙

インストーラーはこのリポジトリの壁紙をコピーし、
[Sunshine_Hyprland_Wallpapers](https://github.com/tak0dan/Sunshine_Hyprland_Wallpapers) から壁紙コレクションをダウンロードするかを尋ねます。
コレクションは大きいため、ダウンロードは任意です。既定の 2 枚の画像は常にコピーされます。

---

## キーバインド

キーバインドは Lua 設定で定義されています。`SUPER + SHIFT + K` で、有効なキーバインドを検索できる一覧が開きます。
変更方法は [HOWTO：キーバインドの変更](../../docs/HOWTO-Change-Keybindgs.md) を参照してください。

---

## カスタマイズ

独自の変更は `~/.config/hypr/UserConfigs/` に置いてください。そこにあるファイルはシステムの既定値を上書きし、
更新後も保持されます：

- `user_keybinds.lua`、`user_startup.lua`、`user_window_rules.lua`、`user_decorations.lua`、`user_settings.lua`
- `user_defaults.lua`：既定のアプリ（ファイルマネージャー、エディター、ターミナル）
- `kitty.conf`：ターミナルの設定

ガイドは [`docs/`](../../docs/) にあります。

---

## コントリビュート

プルリクエストは `main` 向けに歓迎します。変更は絞り込み、変更したディストリビューションで動作確認をしてください。
[CONTRIBUTING.md](../../CONTRIBUTING.md) と [COMMIT_MESSAGE_GUIDELINES.md](../../COMMIT_MESSAGE_GUIDELINES.md) を参照してください。

---

## ライセンス

GNU GPLv3。[LICENSE.md](../../LICENSE.md) を参照してください。
